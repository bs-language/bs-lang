; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s  -passes="print<cost-model>" 2>&1 -disable-output -mtriple=arm64-apple-ios -mcpu=cyclone | FileCheck %s --check-prefix=CHECK-THROUGHPUT
; RUN: opt < %s  -passes="print<cost-model>" 2>&1 -disable-output -cost-kind=code-size -mtriple=aarch64-- | FileCheck %s --check-prefix=CHECK-SIZE
target datalayout = "e-p:32:32:32-i1:8:32-i8:8:32-i16:16:32-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:32:64-v128:32:128-a0:0:32-n32-S32"

define void @op() {
  ; Logical and/or - select's cost must be equivalent to that of binop
; CHECK-THROUGHPUT-LABEL: 'op'
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sand = select i1 undef, i1 undef, i1 false
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %band = and i1 undef, undef
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sor = select i1 undef, i1 true, i1 undef
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %bor = or i1 undef, undef
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-SIZE-LABEL: 'op'
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sand = select i1 undef, i1 undef, i1 false
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %band = and i1 undef, undef
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sor = select i1 undef, i1 true, i1 undef
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %bor = or i1 undef, undef
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
  %sand = select i1 undef, i1 undef, i1 false
  %band = and i1 undef, undef
  %sor = select i1 undef, i1 true, i1 undef
  %bor = or i1 undef, undef

  ret void
}

define void @vecop() {
; CHECK-THROUGHPUT-LABEL: 'vecop'
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sand = select <4 x i1> undef, <4 x i1> undef, <4 x i1> zeroinitializer
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %band = and <4 x i1> undef, undef
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sor = select <4 x i1> undef, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i1> undef
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %bor = or <4 x i1> undef, undef
; CHECK-THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-SIZE-LABEL: 'vecop'
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sand = select <4 x i1> undef, <4 x i1> undef, <4 x i1> zeroinitializer
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %band = and <4 x i1> undef, undef
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %sor = select <4 x i1> undef, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i1> undef
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %bor = or <4 x i1> undef, undef
; CHECK-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
  %sand = select <4 x i1> undef, <4 x i1> undef, <4 x i1> <i1 false, i1 false, i1 false, i1 false>
  %band = and <4 x i1> undef, undef
  %sor = select <4 x i1> undef, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i1> undef
  %bor = or <4 x i1> undef, undef

  ret void
}
