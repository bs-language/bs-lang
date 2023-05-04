#include "Lexer.h"

Lexer::Lexer(const std::string & inputSourceName) {
  if(inputSourceName == ""){
    inputSource = &std::cin;
  }
  else{
    inputSource = new std::ifstream(inputSourceName);
  }
}

Lexer::~Lexer() {
  if(inputSource != &std::cin){
    delete inputSource;
  }
}


int Lexer::getToken() {
  while (LastChar == ' '){
    LastChar = inputSource->get();
  }
  if(isalpha(LastChar)){
    
  }
}