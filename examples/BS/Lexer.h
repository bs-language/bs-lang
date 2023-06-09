
#ifndef LLVM_LEXER_H
#define LLVM_LEXER_H

#include <fstream>
#include <iostream>
#include <string>
#include <utility>
#include <set>

class Lexer {
    int lastChar = ' ';
    std::string lastWord;
    std::istream *inputSource;
    std::pair<int, int> curLocation = {1, 1}; //row, col
    std::set<std::string> unaryOpSet = {"++", "--"};
    std::set<std::string> binaryOpSet = {"*", "/", "%", "+", "-", "<", ">",">=","<=", "==", "!=", "+=", "-=", "*=", "/=", "%=", ":=" };
    std::set<std::string> etcOpSet = {"(", ")", "[", "]", "{", "}", "->", ".", ",", ";", "\"","\'","\\"};

    void advance(); //현재 입력 스트림에서 한 글자 얻고 위치 기록
public:
    enum Token {
        tok_eof,

        // keyword
        tok_fn,
        tok_import,

        // primary
        tok_identifier,
        tok_int,
        tok_float,

        // control
        tok_if,
        tok_else,
        tok_for,
        tok_in,

        // operators
        tok_unary,
        tok_binary,
        tok_etcop,

        //undefined
        tok_undefined
    };

    Lexer() = default;

    Lexer(const std::string &);

    ~Lexer();

    void setInputSource(const std::string &);

    Token getToken(); //현재 입력 스트림에서 토큰 타입(enum) 얻기

    std::string getWord(); //getToken 함수로부터 얻어진 단어 (string) 반환

    std::pair<int,int> getLocation();
};

#endif // LLVM_LEXER_H
