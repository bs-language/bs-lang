#include "llvm/IR/Argument.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Type.h"

#include "llvm/ExecutionEngine/Orc/LLJIT.h"
#include "llvm/ADT/Optional.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/CodeGen.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/Target/TargetOptions.h"
#include "llvm/TargetParser/Host.h"

using namespace llvm;

// cl::opt<std::string> InputFilename(cl::Positional, cl::desc("Input filename (.bs)"));
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

void compileToObj(Module *mod) {
  auto TargetTriple = sys::getDefaultTargetTriple();
  mod->setTargetTriple(TargetTriple);

  std::string Error;
  const auto *Target = TargetRegistry::lookupTarget(TargetTriple, Error);
  if (!Target) {
    errs() << Error;
    exit(1);
  }

  const auto *CPU = "generic";
  const auto *Features = "";

  TargetOptions opt;
  const auto RM = std::optional<Reloc::Model>();
  auto *TheTargetMachine =
      Target->createTargetMachine(TargetTriple, CPU, Features, opt, RM);

  mod->setDataLayout(TheTargetMachine->createDataLayout());

  const auto *Filename = "output.o";
  std::error_code EC;
  raw_fd_ostream dest(Filename, EC, sys::fs::OF_None);

  if (EC) {
    errs() << "Could not open file: " << EC.message();
    exit(1);
  }

  legacy::PassManager pass;
  auto FileType = CGFT_ObjectFile;

  if (TheTargetMachine->addPassesToEmitFile(pass, dest, nullptr, FileType)) {
    errs() << "TheTargetMachine can't emit a file of this type";
    exit(1);
  }

  pass.run(*mod);
  dest.flush();
}

void runLLJIT(orc::ThreadSafeModule TSM){
  outs() << "------- Running JIT -------\n";
  ExitOnError ExitOnErr;
  ExitOnErr.setBanner("bs jit: ");

  auto lljit = ExitOnErr(orc::LLJITBuilder().create());

  ExitOnErr(lljit->addIRModule(std::move(TSM)));

  auto MainAddr = ExitOnErr(lljit->lookup("main"));
  int (*Main)(int, char**) = MainAddr.toPtr<int(int, char**)>();
  Main(0, nullptr);
}

int main(int argc, char **argv) {
  cl::ParseCommandLineOptions(argc, argv, " BS compiler\n");

  InitializeNativeTarget();
  InitializeNativeTargetAsmPrinter();
  auto Context = std::make_unique<LLVMContext>();

  // Create some module to put our function into it.
  std::unique_ptr<Module> MainModule(new Module("bs main module", *Context));
  addMainFunction(MainModule.get());
  MainModule->print(outs(), nullptr);

  if (JIT) {
    runLLJIT(orc::ThreadSafeModule(std::move(MainModule), std::move(Context)));
  } else {
    compileToObj(MainModule.get());
  }
  llvm_shutdown();

  return 0;
}
