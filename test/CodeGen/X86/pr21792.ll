; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-linux -mcpu=corei7 | FileCheck %s

; This fixes a missing cases in the MI scheduler's constrainLocalCopy exposed by
; PR21792

@stuff = external dso_local constant [256 x double], align 16

define void @func(<4 x float> %vx) {
; CHECK-LABEL: func:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; CHECK-NEXT:    movd %xmm0, %eax
; CHECK-NEXT:    leaq stuff(%rax), %rdi
; CHECK-NEXT:    pextrd $1, %xmm0, %r9d
; CHECK-NEXT:    leaq stuff(%r9), %rsi
; CHECK-NEXT:    pextrd $2, %xmm0, %ecx
; CHECK-NEXT:    pextrd $3, %xmm0, %r8d
; CHECK-NEXT:    leaq stuff(%rcx), %rdx
; CHECK-NEXT:    leaq stuff(%r8), %rcx
; CHECK-NEXT:    leaq stuff+8(%rax), %r8
; CHECK-NEXT:    leaq stuff+8(%r9), %r9
; CHECK-NEXT:    callq toto@PLT
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
entry:
  %tmp2 = bitcast <4 x float> %vx to <2 x i64>
  %and.i = and <2 x i64> %tmp2, <i64 8727373547504, i64 8727373547504>
  %tmp3 = bitcast <2 x i64> %and.i to <4 x i32>
  %index.sroa.0.0.vec.extract = extractelement <4 x i32> %tmp3, i32 0
  %idx.ext = sext i32 %index.sroa.0.0.vec.extract to i64
  %add.ptr = getelementptr inbounds i8, ptr @stuff, i64 %idx.ext
  %index.sroa.0.4.vec.extract = extractelement <4 x i32> %tmp3, i32 1
  %idx.ext5 = sext i32 %index.sroa.0.4.vec.extract to i64
  %add.ptr6 = getelementptr inbounds i8, ptr @stuff, i64 %idx.ext5
  %index.sroa.0.8.vec.extract = extractelement <4 x i32> %tmp3, i32 2
  %idx.ext14 = sext i32 %index.sroa.0.8.vec.extract to i64
  %add.ptr15 = getelementptr inbounds i8, ptr @stuff, i64 %idx.ext14
  %index.sroa.0.12.vec.extract = extractelement <4 x i32> %tmp3, i32 3
  %idx.ext19 = sext i32 %index.sroa.0.12.vec.extract to i64
  %add.ptr20 = getelementptr inbounds i8, ptr @stuff, i64 %idx.ext19
  %add.ptr46 = getelementptr inbounds i8, ptr getelementptr inbounds ([256 x double], ptr @stuff, i64 0, i64 1), i64 %idx.ext
  %add.ptr51 = getelementptr inbounds i8, ptr getelementptr inbounds ([256 x double], ptr @stuff, i64 0, i64 1), i64 %idx.ext5
  call void @toto(ptr %add.ptr, ptr %add.ptr6, ptr %add.ptr15, ptr %add.ptr20, ptr %add.ptr46, ptr %add.ptr51)
  ret void
}

declare void @toto(ptr, ptr, ptr, ptr, ptr, ptr)
