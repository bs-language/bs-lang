//
// Created by zihasoo on 2023-05-07.
//

#ifndef LLVM_AST_H
#define LLVM_AST_H

class AST {
    virtual void genCode() = 0;

    virtual ~AST() = 0;
};

#endif // LLVM_AST_H
