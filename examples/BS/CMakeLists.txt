set(LLVM_LINK_COMPONENTS
        Core
        Support
        nativecodegen
        )

add_llvm_example(bsc
        bsc.cpp
        )
