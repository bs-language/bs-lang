#include "llvm/Bitcode/BitcodeWriter.h"
#include "llvm/IR/Argument.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

namespace {

//cl::opt<std::string> InputFilename(cl::Positional,
//                                   cl::desc("Input filename (.bs)"));

cl::opt<std::string> OutputFilename("o", cl::desc("Output filename"));

cl::opt<bool> JIT("jit", cl::desc("Run program Just-In-Time"));

void addMainFunction(Module *mod) {
  // define i32 @main(i32 %argc, i8 **%argv) -> main(int argc, char **argv)
  FunctionType *main_func_fty = FunctionType::get(
      Type::getInt32Ty(mod->getContext()),
      {Type::getInt32Ty(mod->getContext()),
       Type::getInt8Ty(mod->getContext())->getPointerTo()->getPointerTo()},
      false);
  Function *main_func =
      Function::Create(main_func_fty, Function::ExternalLinkage, "main", mod);

  {
    Function::arg_iterator args = main_func->arg_begin();
    Value *arg_0 = args++;
    arg_0->setName("argc");
    Value *arg_1 = args;
    arg_1->setName("argv");
  }

  // main.0:
  BasicBlock *bb = BasicBlock::Create(mod->getContext(), "main.0", main_func);

  // ret i32 0
  ReturnInst::Create(mod->getContext(),
                     ConstantInt::get(mod->getContext(), APInt(32, 0)), bb);
}

} // namespace

int main(int argc, char **argv) {
  cl::ParseCommandLineOptions(argc, argv, " BS compiler\n");

  LLVMContext Context;

  // Create some module to put our function into it.
  std::unique_ptr<Module> Owner(new Module("bs main module", Context));
  Module *M = Owner.get();
  addMainFunction(M);
  M->print(outs(), nullptr);

  if (JIT) {
    InitializeNativeTarget();
    InitializeNativeTargetAsmPrinter();

    outs() << "------- Running JIT -------\n";

    // run jit
  }

  //add code here that generate machine code

  llvm_shutdown();

  return 0;
}
