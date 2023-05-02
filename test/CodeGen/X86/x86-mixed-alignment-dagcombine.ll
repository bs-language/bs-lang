; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc  -mtriple=x86_64-apple-macosx10.9.0  -mcpu=core2 -mattr=+64bit,+sse2 < %s | FileCheck %s

; DAGCombine may choose to rewrite 2 loads feeding a select as a select of
; addresses feeding a load. This test ensures that when it does that it creates
; a load with alignment equivalent to the most restrictive source load.

declare void @sink(<2 x double>)

define void @test1(i1 %cmp) align 2 {
; CHECK-LABEL: test1:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    subq $40, %rsp
; CHECK-NEXT:    .cfi_def_cfa_offset 48
; CHECK-NEXT:    testb $1, %dil
; CHECK-NEXT:    movq %rsp, %rax
; CHECK-NEXT:    leaq {{[0-9]+}}(%rsp), %rcx
; CHECK-NEXT:    cmovneq %rax, %rcx
; CHECK-NEXT:    movups (%rcx), %xmm0
; CHECK-NEXT:    callq _sink
; CHECK-NEXT:    addq $40, %rsp
; CHECK-NEXT:    retq
  %1 = alloca  <2 x double>, align 16
  %2 = alloca  <2 x double>, align 8

  %val = load <2 x double>, ptr %1, align 16
  %val2 = load <2 x double>, ptr %2, align 8
  %val3 = select i1 %cmp, <2 x double> %val, <2 x double> %val2
  call void @sink(<2 x double> %val3)
  ret void
}

define void @test2(i1 %cmp) align 2 {
; CHECK-LABEL: test2:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    subq $40, %rsp
; CHECK-NEXT:    .cfi_def_cfa_offset 48
; CHECK-NEXT:    testb $1, %dil
; CHECK-NEXT:    movq %rsp, %rax
; CHECK-NEXT:    leaq {{[0-9]+}}(%rsp), %rcx
; CHECK-NEXT:    cmovneq %rax, %rcx
; CHECK-NEXT:    movaps (%rcx), %xmm0
; CHECK-NEXT:    callq _sink
; CHECK-NEXT:    addq $40, %rsp
; CHECK-NEXT:    retq
  %1 = alloca  <2 x double>, align 16
  %2 = alloca  <2 x double>, align 8

  %val = load <2 x double>, ptr %1, align 16
  %val2 = load <2 x double>, ptr %2, align 16
  %val3 = select i1 %cmp, <2 x double> %val, <2 x double> %val2
  call void @sink(<2 x double> %val3)
  ret void
}
