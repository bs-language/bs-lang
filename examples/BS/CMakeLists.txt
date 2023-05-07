set(LLVM_LINK_COMPONENTS
        Core
        Support
        nativecodegen
        OrcJIT
        MC
        )

add_llvm_example(bsc
        bsc.cpp
        Lexer.cpp
        Lexer.h
        AST.cpp
        AST.h
        Parser.cpp
        Parser.h
        )
