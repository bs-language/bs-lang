
#include "llvm/Support/raw_ostream.h"

#include "util.h"

std::string indentByDigit(int num) {
    std::string ret;
    while (num) {
        ret.push_back(' ');
        num /= 10;
    }
    return ret;
}

std::string tilde(int count){
    std::string ret;
    for (int i = 0; i < count; ++i) {
        ret.push_back('~');
    }
    return ret;
}

void logError(std::pair<int, int> loc, const std::string &symbol, const std::string &msg) {
    llvm::errs() << "test.bs:" << loc.first << ":" << loc.second << ": error: " << msg << '\n'
                 << "    " << loc.first << " | " << symbol << '\n'
                 << "    " << indentByDigit(loc.first) << " | ^" << tilde(symbol.size() - 1) << '\n';
}

void logSymbol(std::pair<int, int> loc, const std::string &symbol, Lexer::Token token) {
    llvm::errs() << "test.bs:" << loc.first << ":" << loc.second
                 << ": token <" << symbol << "> : " << tokenToString(token) << '\n';
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
