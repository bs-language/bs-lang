//
// Created by zihasoo on 2023-05-08.
//

#ifndef LLVM_UTIL_H
#define LLVM_UTIL_H

#include <utility>
#include <string>
#include "Lexer.h"

void logError(std::pair<int,int>, const std::string&, const std::string&);

std::string tokenToString(Lexer::Token);

#endif //LLVM_UTIL_H
