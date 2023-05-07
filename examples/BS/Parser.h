
#ifndef LLVM_PARSER_H
#define LLVM_PARSER_H

#include <memory>
#include <map>

#include "llvm/IR/Module.h"
#include "llvm/Support/CommandLine.h"

#include "Lexer.h"

using namespace llvm;

class Parser {
  //LLVM API
  std::unique_ptr<LLVMContext> Context{new LLVMContext()};
  std::unique_ptr<Module> MainModule{new Module("bs main module", *Context)};

  //커멘드 옵션
  cl::opt<std::string> InputFilename{cl::Positional, cl::desc("Input filename (.bs)")};
  cl::opt<std::string> OutputFilename{"o", cl::desc("Output filename")};
  cl::opt<bool> JIT{"jit", cl::desc("Run program Just-In-Time")};

  //연산자 우선순위 맵
  std::map<char,int> opPrecedenceMap{{'=',0},{''}};

  //렉서
  Lexer lexer;

public:
  Parser(int, char **);
  ~Parser();
  void addMainFunction();
  void compileToObj();
  void runLLJIT();

  void parseArithExpr();

};

#endif // LLVM_PARSER_H
