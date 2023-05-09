//
// Created by zihasoo on 2023-05-08.
//

#ifndef LLVM_UTIL_H
#define LLVM_UTIL_H

#include <utility>
#include <string>
#include "Lexer.h"


void logError(std::pair<int, int> loc, const std::string &symbol, const std::string &msg);

void logSymbol(std::pair<int, int> loc, const std::string &symbol, Lexer::Token token);

std::string tokenToString(Lexer::Token);

std::string indentByDigit(int num);

std::string tilde(int count);

#endif //LLVM_UTIL_H
