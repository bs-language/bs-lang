set(LLVM_LINK_COMPONENTS
        Core
        Support
        nativecodegen
        MC
        )

add_llvm_example(bsc
        bsc.cpp
        )
