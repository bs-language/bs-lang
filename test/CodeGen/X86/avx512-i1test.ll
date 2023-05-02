; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mattr=+avx512f | FileCheck %s
; RUN: llc < %s -mattr=+avx512f -mattr=+avx512vl -mattr=+avx512bw -mattr=+avx512dq | FileCheck %s

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define void @func() {
; CHECK-LABEL: func:
; CHECK:       # %bb.0: # %bb1
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    testb %al, %al
; CHECK-NEXT:    je .LBB0_1
; CHECK-NEXT:  # %bb.4: # %L_30
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB0_1: # %bb56
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB0_2: # %bb33
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    testb %al, %al
; CHECK-NEXT:    jne .LBB0_2
; CHECK-NEXT:  # %bb.3: # %bb35
; CHECK-NEXT:    # in Loop: Header=BB0_2 Depth=1
; CHECK-NEXT:    testb %al, %al
; CHECK-NEXT:    jmp .LBB0_2
bb1:
  br i1 undef, label %L_10, label %L_10

L_10:                                             ; preds = %bb1, %bb1
  br i1 undef, label %L_30, label %bb56

bb56:                                             ; preds = %L_10
  br label %bb33

bb33:                                             ; preds = %bb51, %bb56
  %r111 = load i64, ptr undef, align 8
  br i1 undef, label %bb51, label %bb35

bb35:                                             ; preds = %bb33
  br i1 undef, label %L_19, label %bb37

bb37:                                             ; preds = %bb35
  %r128 = and i64 %r111, 576460752303423488
  %phitmp = icmp eq i64 %r128, 0
  br label %L_19

L_19:                                             ; preds = %bb37, %bb35
  %"$V_S25.0" = phi i1 [ %phitmp, %bb37 ], [ true, %bb35 ]
  br i1 undef, label %bb51, label %bb42

bb42:                                             ; preds = %L_19
  %r136 = select i1 %"$V_S25.0", ptr undef, ptr undef
  br label %bb51

bb51:                                             ; preds = %bb42, %L_19, %bb33
  br i1 false, label %L_30, label %bb33

L_30:                                             ; preds = %bb51, %L_10
  ret void
}

; The following test generates suboptimal code on AVX-512
; PR 28175
define i64 @func2(i1 zeroext %i, i32 %j) {
; CHECK-LABEL: func2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    testl %esi, %esi
; CHECK-NEXT:    jne bar # TAILCALL
; CHECK-NEXT:  # %bb.1: # %if.end
; CHECK-NEXT:    movzbl %dil, %eax
; CHECK-NEXT:    orq $-2, %rax
; CHECK-NEXT:    retq
entry:
  %tobool = icmp eq i32 %j, 0
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  %call = tail call i64 @bar()
  br label %return

if.end:                                           ; preds = %entry
  %conv = zext i1 %i to i64
  %or = or i64 %conv, -2
  br label %return

return:                                           ; preds = %if.end, %if.then
  %or.sink = phi i64 [ %or, %if.end ], [ %call, %if.then ]
  ret i64 %or.sink
}

declare dso_local i64 @bar()
