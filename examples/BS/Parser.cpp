
#include <stack>
#include <vector>

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

#include "llvm/ADT/Optional.h"
#include "llvm/ExecutionEngine/Orc/LLJIT.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/CodeGen.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/Target/TargetOptions.h"
#include "llvm/TargetParser/Host.h"

#include "Parser.h"

Parser::Parser(int argc, char **argv) {
    cl::ParseCommandLineOptions(argc, argv, " BS compiler\n");
    InitializeNativeTarget();
    InitializeNativeTargetAsmPrinter();
    lexer.setInputSource(InputFilename);
}

Parser::~Parser() { llvm_shutdown(); }

void Parser::addMainFunction() {
    // define i32 @main(i32 %argc, i8 **%argv) -> main(int argc, char **argv)
    FunctionType *main_func_fty =
            FunctionType::get(Type::getInt32Ty(MainModule->getContext()),
                              {Type::getInt32Ty(MainModule->getContext()),
                               Type::getInt8Ty(MainModule->getContext())
                                       ->getPointerTo()
                                       ->getPointerTo()},
                              false);
    Function *main_func = Function::Create(
            main_func_fty, Function::ExternalLinkage, "main", MainModule.get());
    Function::arg_iterator arg = main_func->arg_begin();
    arg->setName("argc");
    arg++;
    arg->setName("argv");

    // main.0:
    BasicBlock *bb =
            BasicBlock::Create(MainModule->getContext(), "main.0", main_func);

    // ret i32 0
    ReturnInst::Create(MainModule->getContext(),
                       ConstantInt::get(MainModule->getContext(), APInt(32, 0)),
                       bb);

    MainModule->print(outs(), nullptr);
}

void Parser::compileToObj() {
    auto TargetTriple = sys::getDefaultTargetTriple();
    MainModule->setTargetTriple(TargetTriple);

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

    MainModule->setDataLayout(TheTargetMachine->createDataLayout());

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

    pass.run(*MainModule);
    dest.flush();
}

void Parser::runLLJIT() {
    outs() << "------- Running JIT -------\n";
    ExitOnError ExitOnErr;
    ExitOnErr.setBanner("bs jit: ");

    auto lljit = ExitOnErr(orc::LLJITBuilder().create());

    ExitOnErr(lljit->addIRModule(
            orc::ThreadSafeModule(std::move(MainModule), std::move(Context))));

    auto MainAddr = ExitOnErr(lljit->lookup("main"));
    int (*Main)(int, char **) = MainAddr.toPtr<int(int, char **)>();
    Main(0, nullptr);
}

void Parser::parseArithExpr() {
//    std::stack<char> S;
//    std::vector<char> res;
//    char cur;
//    int a = 10, b;
//    while ((cur = lexer.getChar()) != '\n') {
//        if ('A' <= cur && cur <= 'Z') {
//            res.push_back(cur);
//        } else {
//            if (S.empty())
//                S.push(cur);
//            else if (cur == '(')
//                S.push(cur);
//            else if (cur == ')') {
//                while (S.top() != '(') {
//                    res.push_back(S.top());
//                    S.pop();
//                }
//                S.pop(); // 여는 괄호 pop
//            } else {
//                while (!isHigher(cur, S.top())) {
//                    cout << S.top();
//                    S.pop();
//                    if (S.empty()) {
//                        break;
//                    }
//                }
//                S.push(cur);
//            }
//        }
//    }
}