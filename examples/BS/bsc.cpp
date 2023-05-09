#include "Parser.h"
#include "util.h"

int main(int argc, char **argv) {

    auto lexer = Lexer("test.bs");

    Lexer::Token cur = Lexer::tok_undefined;

    while (cur != Lexer::tok_eof) {
        cur = lexer.getToken();
        logError(lexer.getLocation(), lexer.getWord(), tokenToString(cur));
    }

    return 0;
}
