; RUN: not llvm-as < %s 2>&1 | FileCheck %s

; CHECK: <stdin>:[[@LINE+1]]:34: error: expected '('{{$}}
define void @test_byval(ptr byval) {
  ret void
}
