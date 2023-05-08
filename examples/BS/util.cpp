
#include "llvm/Support/raw_ostream.h"

#include "util.h"

void logError(std::pair<int, int> loc, const std::string &symbol, const std::string &msg) {
    llvm::errs() << '\n' << "in code line " << loc.first << ", column " << loc.second
    << ", symbol <" << symbol << "> error occurred : "<< msg << '\n';
}

std::string tokenToString(Lexer::Token token) {
    switch (token) {
        case Lexer::tok_eof:
            return "tok_eof";
        case Lexer::tok_fn:
            return "tok_fn";
        case Lexer::tok_import:
            return "tok_import";
        case Lexer::tok_identifier:
            return "tok_identifier";
        case Lexer::tok_int:
            return "tok_int";
        case Lexer::tok_float:
            return "tok_float";
        case Lexer::tok_if:
            return "tok_if";
        case Lexer::tok_else:
            return "tok_else";
        case Lexer::tok_for:
            return "tok_for";
        case Lexer::tok_in:
            return "tok_in";
        case Lexer::tok_unary:
            return "tok_unary";
        case Lexer::tok_binary:
            return "tok_binary";
        case Lexer::tok_etcop:
            return "tok_etcop";
        case Lexer::tok_undefined:
            return "tok_undefined";
    }
}