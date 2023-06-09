#include "Lexer.h"
#include "util.h"

bool isnum(int c) {
    return ('0' <= c && c <= '9') || c == '.';
}

Lexer::Lexer(const std::string &InputSourceName) {
    setInputSource(InputSourceName);
}

Lexer::~Lexer() {
    if (inputSource != &std::cin) {
        delete inputSource;
    }
}

void Lexer::setInputSource(const std::string &InputSourceName) {
    lastWord.reserve(30);
    if (InputSourceName.empty()) {
        inputSource = &std::cin;
    } else {
        inputSource = new std::ifstream(InputSourceName);
    }
}

void Lexer::advance() {
    lastChar = inputSource->get();
    if (lastChar == '\n' || lastChar == '\r') {
        curLocation.first++;
        curLocation.second = 1;
    } else {
        curLocation.second++;
    }
}

Lexer::Token Lexer::getToken() {
    lastWord.clear();
    while (isspace(lastChar)) {
        advance();
    }
    if (isalpha(lastChar)) {
        while (isalnum(lastChar)) {
            lastWord.push_back(lastChar);
            advance();
        }
        if (lastWord == "fn") {
            return tok_fn;
        }
        if (lastWord == "import") {
            return tok_import;
        }
        if (lastWord == "if") {
            return tok_if;
        }
        if (lastWord == "else") {
            return tok_else;
        }
        if (lastWord == "for") {
            return tok_for;
        }
        if (lastWord == "in") {
            return tok_in;
        }
        if (lastWord == "and" || lastWord == "or" || lastWord == "not") {
            return tok_binary;
        }

        return tok_identifier;
    }

    if (isnum(lastChar)) {
        bool flt = false, err = false;
        while (isnum(lastChar)) {
            if (lastChar == '.') {
                if (flt) err = true;
                else flt = true;
            }
            lastWord.push_back(lastChar);
            advance();
        }
        if(err){
            logError(curLocation, lastWord, "Invalid point on floating constant");
            return tok_undefined;
        }
        return flt ? tok_float : tok_int;
    }

    if (lastChar == EOF) {
        return tok_eof;
    }

    lastWord.push_back(lastChar);
    advance();
    if (!isspace(lastChar) && !isalnum(lastChar) && lastChar != EOF) {
        lastWord.push_back(lastChar);

        if (unaryOpSet.find(lastWord) != unaryOpSet.end()) {
            advance();
            return tok_unary;
        }

        if (binaryOpSet.find(lastWord) != binaryOpSet.end()) {
            advance();
            return tok_binary;
        }

        if (etcOpSet.find(lastWord) != etcOpSet.end()) {
            advance();
            return tok_etcop;
        }

        lastWord.pop_back();
    }
    if (unaryOpSet.find(lastWord) != unaryOpSet.end()) {
        return tok_unary;
    }

    if (binaryOpSet.find(lastWord) != binaryOpSet.end()) {
        return tok_binary;
    }

    if (etcOpSet.find(lastWord) != etcOpSet.end()) {
        return tok_etcop;
    }

    //logError(curLocation, lastWord, "undefined token");
    return tok_undefined;
}

std::string Lexer::getWord() {
    return lastWord;
}

std::pair<int, int> Lexer::getLocation() {
    return curLocation;
}

