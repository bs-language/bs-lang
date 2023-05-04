//
// Created by zihasoo on 2023-05-04.
//

#ifndef LLVM_LEXER_H
#define LLVM_LEXER_H

#include <fstream>
#include <iostream>
#include <string>

class Lexer {
  enum Token {
    tok_eof = -1,

    // keyword
    tok_fn = -2,
    tok_import = -3,

    // primary
    tok_identifier = -4,
    tok_number = -5,
    tok_type = -6,

    // control
    tok_if = -7,
    tok_then = -8,
    tok_else = -9,
    tok_for = -10,
    tok_in = -11,

    // operators
    tok_binary = -12,
    tok_unary = -13,
  };

  int LastChar = ' ';
  std::istream* inputSource;

public:
  Lexer(const std::string&);
  ~Lexer();

  int getToken();

};

#endif // LLVM_LEXER_H
