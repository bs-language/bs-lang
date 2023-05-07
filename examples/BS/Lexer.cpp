#include "Lexer.h"

Lexer::Lexer(const std::string &InputSourceName) {
  setInputSource(InputSourceName);
}

Lexer::~Lexer() {
  if (InputSource != &std::cin) {
    delete InputSource;
  }
}

void Lexer::setInputSource(const std::string &InputSourceName) {
  LastWord.reserve(30);
  if (InputSourceName == "") {
    InputSource = &std::cin;
  } else {
    InputSource = new std::ifstream(InputSourceName);
  }
}

Lexer::Token Lexer::getToken() {
  LastWord.clear();
  while (isspace(LastChar)) {
    LastChar = InputSource->get();
  }
  if (isalpha(LastChar)) {
    while (isalnum(LastChar)) {
      LastWord.push_back(LastChar);
      LastChar = InputSource->get();
    }
    if (LastWord == "fn") {
      return tok_fn;
    }
    if (LastWord == "import") {
      return tok_import;
    }
    return tok_identifier;
  }

  if (LastChar == EOF) {
    return tok_eof;
  } else {
  }
}

int Lexer::getChar() {
  LastChar = InputSource->get();
  return LastChar;
}

std::string Lexer::getWord() { return LastWord; }