//===- DwarfEHPrepare - Prepare exception handling for code generation ----===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This pass mulches exception handling code into a form adapted to code
// generation. Required if using dwarf exception handling.
//
//===----------------------------------------------------------------------===//

#include "llvm/ADT/BitVector.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/Analysis/CFG.h"
#include "llvm/Analysis/DomTreeUpdater.h"
#include "llvm/Analysis/TargetTransformInfo.h"
#include "llvm/CodeGen/RuntimeLibcalls.h"
#include "llvm/CodeGen/StackProtector.h"
#include "llvm/CodeGen/TargetLowering.h"
#include "llvm/CodeGen/TargetPassConfig.h"
#include "llvm/CodeGen/TargetSubtargetInfo.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DebugInfoMetadata.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/EHPersonalities.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Type.h"
#include "llvm/InitializePasses.h"
#include "llvm/Pass.h"
#include "llvm/Support/Casting.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/TargetParser/Triple.h"
#include "llvm/Transforms/Utils/Local.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"
#include <cstddef>

using namespace llvm;

#define DEBUG_TYPE "dwarfehprepare"

STATISTIC(NumResumesLowered, "Number of resume calls lowered");
STATISTIC(NumCleanupLandingPadsUnreachable,
          "Number of cleanup landing pads found unreachable");
STATISTIC(NumCleanupLandingPadsRemaining,
          "Number of cleanup landing pads remaining");
STATISTIC(NumNoUnwind, "Number of functions with nounwind");
STATISTIC(NumUnwind, "Number of functions with unwind");

namespace {

class DwarfEHPrepare {
  CodeGenOpt::Level OptLevel;

  Function &F;
  const TargetLowering &TLI;
  DomTreeUpdater *DTU;
  const TargetTransformInfo *TTI;
  const Triple &TargetTriple;

  /// Return the exception object from the value passed into
  /// the 'resume' instruction (typically an aggregate). Clean up any dead
  /// instructions, including the 'resume' instruction.
  Value *GetExceptionObject(ResumeInst *RI);

  /// Replace resumes that are not reachable from a cleanup landing pad with
  /// unreachable and then simplify those blocks.
  size_t
  pruneUnreachableResumes(SmallVectorImpl<ResumeInst *> &Resumes,
                          SmallVectorImpl<LandingPadInst *> &CleanupLPads);

  /// Convert the ResumeInsts that are still present
  /// into calls to the appropriate _Unwind_Resume function.
  bool InsertUnwindResumeCalls();

public:
  DwarfEHPrepare(CodeGenOpt::Level OptLevel_, Function &F_,
                 const TargetLowering &TLI_, DomTreeUpdater *DTU_,
                 const TargetTransformInfo *TTI_, const Triple &TargetTriple_)
      : OptLevel(OptLevel_), F(F_), TLI(TLI_), DTU(DTU_), TTI(TTI_),
        TargetTriple(TargetTriple_) {}

  bool run();
};

} // namespace

Value *DwarfEHPrepare::GetExceptionObject(ResumeInst *RI) {
  Value *V = RI->getOperand(0);
  Value *ExnObj = nullptr;
  InsertValueInst *SelIVI = dyn_cast<InsertValueInst>(V);
  LoadInst *SelLoad = nullptr;
  InsertValueInst *ExcIVI = nullptr;
  bool EraseIVIs = false;

  if (SelIVI) {
    if (SelIVI->getNumIndices() == 1 && *SelIVI->idx_begin() == 1) {
      ExcIVI = dyn_cast<InsertValueInst>(SelIVI->getOperand(0));
      if (ExcIVI && isa<UndefValue>(ExcIVI->getOperand(0)) &&
          ExcIVI->getNumIndices() == 1 && *ExcIVI->idx_begin() == 0) {
        ExnObj = ExcIVI->getOperand(1);
        SelLoad = dyn_cast<LoadInst>(SelIVI->getOperand(1));
        EraseIVIs = true;
      }
    }
  }

  if (!ExnObj)
    ExnObj = ExtractValueInst::Create(RI->getOperand(0), 0, "exn.obj", RI);

  RI->eraseFromParent();

  if (EraseIVIs) {
    if (SelIVI->use_empty())
      SelIVI->eraseFromParent();
    if (ExcIVI->use_empty())
      ExcIVI->eraseFromParent();
    if (SelLoad && SelLoad->use_empty())
      SelLoad->eraseFromParent();
  }

  return ExnObj;
}

size_t DwarfEHPrepare::pruneUnreachableResumes(
    SmallVectorImpl<ResumeInst *> &Resumes,
    SmallVectorImpl<LandingPadInst *> &CleanupLPads) {
  assert(DTU && "Should have DomTreeUpdater here.");

  BitVector ResumeReachable(Resumes.size());
  size_t ResumeIndex = 0;
  for (auto *RI : Resumes) {
    for (auto *LP : CleanupLPads) {
      if (isPotentiallyReachable(LP, RI, nullptr, &DTU->getDomTree())) {
        ResumeReachable.set(ResumeIndex);
        break;
      }
    }
    ++ResumeIndex;
  }

  // If everything is reachable, there is no change.
  if (ResumeReachable.all())
    return Resumes.size();

  LLVMContext &Ctx = F.getContext();

  // Otherwise, insert unreachable instructions and call simplifycfg.
  size_t ResumesLeft = 0;
  for (size_t I = 0, E = Resumes.size(); I < E; ++I) {
    ResumeInst *RI = Resumes[I];
    if (ResumeReachable[I]) {
      Resumes[ResumesLeft++] = RI;
    } else {
      BasicBlock *BB = RI->getParent();
      new UnreachableInst(Ctx, RI);
      RI->eraseFromParent();
      simplifyCFG(BB, *TTI, DTU);
    }
  }
  Resumes.resize(ResumesLeft);
  return ResumesLeft;
}

/// If a landingpad block doesn't already have a cleanup case, add one
/// that feeds directly into a resume instruction.
static void addCleanupResumeToLandingPad(BasicBlock &BB, DomTreeUpdater *DTU) {
  LandingPadInst *LP = BB.getLandingPadInst();
  if (LP->isCleanup())
    return;

  // There will usually be code testing for the other kinds of exception
  // immediately after the landingpad. Working out the far end of that chain is
  // tricky, so put our test for the new cleanup case (i.e. selector == 0) at
  // the beginning.
  BasicBlock *ContBB = SplitBlock(&BB, LP->getNextNode(), DTU);
  BB.getTerminator()->eraseFromParent();

  LP->setCleanup(true);
  IRBuilder<> B(&BB);
  Value *Selector = B.CreateExtractValue(LP, 1);
  Value *Cmp = B.CreateICmpEQ(Selector, ConstantInt::get(Selector->getType(), 0));

  Function *F = BB.getParent();
  LLVMContext &Ctx = F->getContext();
  BasicBlock *ResumeBB = BasicBlock::Create(Ctx, "resume", F);
  ResumeInst::Create(LP, ResumeBB);

  B.CreateCondBr(Cmp, ResumeBB, ContBB);
  if (DTU) {
    SmallVector<DominatorTree::UpdateType> Updates;
    Updates.push_back({DominatorTree::Insert, &BB, ResumeBB});
    DTU->applyUpdates(Updates);
  }
}

/// Create a basic block that has a `landingpad` instruction feeding
/// directly into a `resume`. Will be set to the unwind destination of a new
/// invoke.
static BasicBlock *createCleanupResumeBB(Function &F,  Type *LandingPadTy) {
  LLVMContext &Ctx = F.getContext();
  BasicBlock *BB = BasicBlock::Create(Ctx, "cleanup_resume", &F);
  IRBuilder<> B(BB);

  // If this is going to be the only landingpad in the function, synthesize the
  // standard type all ABIs use, which is essentially `{ ptr, i32 }`.
  if (!LandingPadTy)
    LandingPadTy =
        StructType::get(Type::getInt8PtrTy(Ctx), IntegerType::get(Ctx, 32));

  LandingPadInst *Except = B.CreateLandingPad(LandingPadTy, 0);
  Except->setCleanup(true);
  B.CreateResume(Except);
  return BB;
}

/// Convert a call that might throw into an invoke that unwinds to the specified
/// simple landingpad/resume block.
static void changeCallToInvokeResume(CallInst &CI, BasicBlock *CleanupResumeBB,
                                     DomTreeUpdater *DTU) {
  BasicBlock *BB = CI.getParent();
  BasicBlock *ContBB = SplitBlock(BB, &CI, DTU);
  BB->getTerminator()->eraseFromParent();

  IRBuilder<> B(BB);
  SmallVector<Value *> Args(CI.args());
  SmallVector<OperandBundleDef> Bundles;
  CI.getOperandBundlesAsDefs(Bundles);
  InvokeInst *NewCall =
      B.CreateInvoke(CI.getFunctionType(), CI.getCalledOperand(), ContBB,
                     CleanupResumeBB, Args, Bundles, CI.getName());
  NewCall->setAttributes(CI.getAttributes());
  NewCall->setCallingConv(CI.getCallingConv());
  NewCall->copyMetadata(CI);

  if (DTU) {
    SmallVector<DominatorTree::UpdateType> Updates;
    Updates.push_back({DominatorTree::Insert, BB, CleanupResumeBB});
    DTU->applyUpdates(Updates);
  }
  CI.replaceAllUsesWith(NewCall);
  CI.eraseFromParent();
}

/// Ensure that any call in this function that might throw has an associated
/// cleanup/resume that the stack protector can instrument later. Existing
/// invokes will get an added `cleanup` clause if needed, calls will be
/// converted to an invoke with trivial unwind followup.
static void addCleanupPathsForStackProtector(Function &F, DomTreeUpdater *DTU) {
  // First add cleanup -> resume paths to all existing landingpads, noting what
  // type landingpads in this function actually have along the way.
  Type *LandingPadTy = nullptr;
  for (Function::iterator FI = F.begin(); FI != F.end(); ++FI) {
    BasicBlock &BB = *FI;
    if (LandingPadInst *LP = BB.getLandingPadInst()) {
      // We can assume the type is broadly compatible with { ptr, i32 } since
      // other parts of this pass already try to extract values from it.
      LandingPadTy = LP->getType();
      addCleanupResumeToLandingPad(BB, DTU);
    }
  }

  // Next convert any call that might throw into an invoke to a resume
  // instruction for later instrumentation.
  BasicBlock *CleanupResumeBB = nullptr;
  for (Function::iterator FI = F.begin(); FI != F.end(); ++FI) {
    BasicBlock &BB = *FI;
    for (Instruction &I : BB) {
      CallInst *CI = dyn_cast<CallInst>(&I);
      if (!CI || CI->doesNotThrow())
        continue;

      // Tail calls cannot use our stack so no need to check whether it was
      // corrupted.
      if (CI->isTailCall())
        continue;

      if (!CleanupResumeBB)
        CleanupResumeBB = createCleanupResumeBB(F, LandingPadTy);

      changeCallToInvokeResume(*CI, CleanupResumeBB, DTU);

      // This block has been split, start again on its continuation.
      break;
    }
  }
}

bool DwarfEHPrepare::InsertUnwindResumeCalls() {
  if (F.hasPersonalityFn() &&
      !isScopedEHPersonality(classifyEHPersonality(F.getPersonalityFn())) &&
      StackProtector::requiresStackProtector(&F, nullptr))
    addCleanupPathsForStackProtector(F, DTU);

  SmallVector<ResumeInst *, 16> Resumes;
  SmallVector<LandingPadInst *, 16> CleanupLPads;
  if (F.doesNotThrow())
    NumNoUnwind++;
  else
    NumUnwind++;
  for (BasicBlock &BB : F) {
    if (auto *RI = dyn_cast<ResumeInst>(BB.getTerminator()))
      Resumes.push_back(RI);
    if (auto *LP = BB.getLandingPadInst())
      if (LP->isCleanup())
        CleanupLPads.push_back(LP);
  }

  NumCleanupLandingPadsRemaining += CleanupLPads.size();

  if (Resumes.empty())
    return false;

  // Check the personality, don't do anything if it's scope-based.
  EHPersonality Pers = classifyEHPersonality(F.getPersonalityFn());
  if (isScopedEHPersonality(Pers))
    return false;

  LLVMContext &Ctx = F.getContext();

  size_t ResumesLeft = Resumes.size();
  if (OptLevel != CodeGenOpt::None) {
    ResumesLeft = pruneUnreachableResumes(Resumes, CleanupLPads);
#if LLVM_ENABLE_STATS
    unsigned NumRemainingLPs = 0;
    for (BasicBlock &BB : F) {
      if (auto *LP = BB.getLandingPadInst())
        if (LP->isCleanup())
          NumRemainingLPs++;
    }
    NumCleanupLandingPadsUnreachable += CleanupLPads.size() - NumRemainingLPs;
    NumCleanupLandingPadsRemaining -= CleanupLPads.size() - NumRemainingLPs;
#endif
  }

  if (ResumesLeft == 0)
    return true; // We pruned them all.

  // RewindFunction - _Unwind_Resume or the target equivalent.
  FunctionCallee RewindFunction;
  CallingConv::ID RewindFunctionCallingConv;
  FunctionType *FTy;
  const char *RewindName;
  bool DoesRewindFunctionNeedExceptionObject;

  if ((Pers == EHPersonality::GNU_CXX || Pers == EHPersonality::GNU_CXX_SjLj) &&
      TargetTriple.isTargetEHABICompatible()) {
    RewindName = TLI.getLibcallName(RTLIB::CXA_END_CLEANUP);
    FTy = FunctionType::get(Type::getVoidTy(Ctx), false);
    RewindFunctionCallingConv =
        TLI.getLibcallCallingConv(RTLIB::CXA_END_CLEANUP);
    DoesRewindFunctionNeedExceptionObject = false;
  } else {
    RewindName = TLI.getLibcallName(RTLIB::UNWIND_RESUME);
    FTy =
        FunctionType::get(Type::getVoidTy(Ctx), Type::getInt8PtrTy(Ctx), false);
    RewindFunctionCallingConv = TLI.getLibcallCallingConv(RTLIB::UNWIND_RESUME);
    DoesRewindFunctionNeedExceptionObject = true;
  }
  RewindFunction = F.getParent()->getOrInsertFunction(RewindName, FTy);

  // Create the basic block where the _Unwind_Resume call will live.
  if (ResumesLeft == 1) {
    // Instead of creating a new BB and PHI node, just append the call to
    // _Unwind_Resume to the end of the single resume block.
    ResumeInst *RI = Resumes.front();
    BasicBlock *UnwindBB = RI->getParent();
    Value *ExnObj = GetExceptionObject(RI);
    llvm::SmallVector<Value *, 1> RewindFunctionArgs;
    if (DoesRewindFunctionNeedExceptionObject)
      RewindFunctionArgs.push_back(ExnObj);

    // Call the rewind function.
    CallInst *CI =
        CallInst::Create(RewindFunction, RewindFunctionArgs, "", UnwindBB);
    // The verifier requires that all calls of debug-info-bearing functions
    // from debug-info-bearing functions have a debug location (for inlining
    // purposes). Assign a dummy location to satisfy the constraint.
    Function *RewindFn = dyn_cast<Function>(RewindFunction.getCallee());
    if (RewindFn && RewindFn->getSubprogram())
      if (DISubprogram *SP = F.getSubprogram())
        CI->setDebugLoc(DILocation::get(SP->getContext(), 0, 0, SP));
    CI->setCallingConv(RewindFunctionCallingConv);

    // We never expect _Unwind_Resume to return.
    CI->setDoesNotReturn();
    new UnreachableInst(Ctx, UnwindBB);
    return true;
  }

  std::vector<DominatorTree::UpdateType> Updates;
  Updates.reserve(Resumes.size());

  llvm::SmallVector<Value *, 1> RewindFunctionArgs;

  BasicBlock *UnwindBB = BasicBlock::Create(Ctx, "unwind_resume", &F);
  PHINode *PN = PHINode::Create(Type::getInt8PtrTy(Ctx), ResumesLeft, "exn.obj",
                                UnwindBB);

  // Extract the exception object from the ResumeInst and add it to the PHI node
  // that feeds the _Unwind_Resume call.
  for (ResumeInst *RI : Resumes) {
    BasicBlock *Parent = RI->getParent();
    BranchInst::Create(UnwindBB, Parent);
    Updates.push_back({DominatorTree::Insert, Parent, UnwindBB});

    Value *ExnObj = GetExceptionObject(RI);
    PN->addIncoming(ExnObj, Parent);

    ++NumResumesLowered;
  }

  if (DoesRewindFunctionNeedExceptionObject)
    RewindFunctionArgs.push_back(PN);

  // Call the function.
  CallInst *CI =
      CallInst::Create(RewindFunction, RewindFunctionArgs, "", UnwindBB);
  CI->setCallingConv(RewindFunctionCallingConv);

  // We never expect _Unwind_Resume to return.
  CI->setDoesNotReturn();
  new UnreachableInst(Ctx, UnwindBB);

  if (DTU)
    DTU->applyUpdates(Updates);

  return true;
}

bool DwarfEHPrepare::run() {
  bool Changed = InsertUnwindResumeCalls();

  return Changed;
}

static bool prepareDwarfEH(CodeGenOpt::Level OptLevel, Function &F,
                           const TargetLowering &TLI, DominatorTree *DT,
                           const TargetTransformInfo *TTI,
                           const Triple &TargetTriple) {
  DomTreeUpdater DTU(DT, DomTreeUpdater::UpdateStrategy::Lazy);

  return DwarfEHPrepare(OptLevel, F, TLI, DT ? &DTU : nullptr, TTI,
                        TargetTriple)
      .run();
}

namespace {

class DwarfEHPrepareLegacyPass : public FunctionPass {

  CodeGenOpt::Level OptLevel;

public:
  static char ID; // Pass identification, replacement for typeid.

  DwarfEHPrepareLegacyPass(CodeGenOpt::Level OptLevel = CodeGenOpt::Default)
      : FunctionPass(ID), OptLevel(OptLevel) {}

  bool runOnFunction(Function &F) override {
    const TargetMachine &TM =
        getAnalysis<TargetPassConfig>().getTM<TargetMachine>();
    const TargetLowering &TLI = *TM.getSubtargetImpl(F)->getTargetLowering();
    DominatorTree *DT = nullptr;
    const TargetTransformInfo *TTI = nullptr;
    if (auto *DTWP = getAnalysisIfAvailable<DominatorTreeWrapperPass>())
      DT = &DTWP->getDomTree();
    if (OptLevel != CodeGenOpt::None) {
      if (!DT)
        DT = &getAnalysis<DominatorTreeWrapperPass>().getDomTree();
      TTI = &getAnalysis<TargetTransformInfoWrapperPass>().getTTI(F);
    }
    return prepareDwarfEH(OptLevel, F, TLI, DT, TTI, TM.getTargetTriple());
  }

  void getAnalysisUsage(AnalysisUsage &AU) const override {
    AU.addRequired<TargetPassConfig>();
    AU.addRequired<TargetTransformInfoWrapperPass>();
    if (OptLevel != CodeGenOpt::None) {
      AU.addRequired<DominatorTreeWrapperPass>();
      AU.addRequired<TargetTransformInfoWrapperPass>();
    }
    AU.addPreserved<DominatorTreeWrapperPass>();
  }

  StringRef getPassName() const override {
    return "Exception handling preparation";
  }
};

} // end anonymous namespace

char DwarfEHPrepareLegacyPass::ID = 0;

INITIALIZE_PASS_BEGIN(DwarfEHPrepareLegacyPass, DEBUG_TYPE,
                      "Prepare DWARF exceptions", false, false)
INITIALIZE_PASS_DEPENDENCY(DominatorTreeWrapperPass)
INITIALIZE_PASS_DEPENDENCY(TargetPassConfig)
INITIALIZE_PASS_DEPENDENCY(TargetTransformInfoWrapperPass)
INITIALIZE_PASS_END(DwarfEHPrepareLegacyPass, DEBUG_TYPE,
                    "Prepare DWARF exceptions", false, false)

FunctionPass *llvm::createDwarfEHPass(CodeGenOpt::Level OptLevel) {
  return new DwarfEHPrepareLegacyPass(OptLevel);
}
