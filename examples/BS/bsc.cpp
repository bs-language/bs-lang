#include "Parser.h"

int main(int argc, char **argv) {
  auto parser = Parser(argc, argv);
  parser.addMainFunction();

  return 0;
}