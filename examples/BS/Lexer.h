
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
  std::string LastWord;
  std::istream* InputSource;

public:
  Lexer() = default;
  Lexer(const std::string&);
  ~Lexer();

  void setInputSource(const std::string&);

  Token getToken(); //현재 입력 스트림에서 토큰 타입(enum) 얻기
  int getChar(); //현재 입력 스트림에서 한 글자 얻기 (수식 및 기타 연산용)
  std::string getWord(); //getToken 함수로부터 얻어진 단어 (string) 반환
};

#endif // LLVM_LEXER_H
