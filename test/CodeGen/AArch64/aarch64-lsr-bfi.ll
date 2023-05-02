; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-none-linux-gnu < %s -o -| FileCheck %s

define i32 @lsr_bfi(i32 %a) {
; CHECK-LABEL: lsr_bfi:
; CHECK:       // %bb.0:
; CHECK-NEXT:    lsr w8, w0, #20
; CHECK-NEXT:    bfi w0, w8, #4, #4
; CHECK-NEXT:    ret
  %and1 = and i32 %a, -241
  %1 = lshr i32 %a, 16
  %shl = and i32 %1, 240
  %or = or i32 %shl, %and1
  ret i32 %or
}

define i32 @negative_lsr_bfi0(i32 %a) {
; CHECK-LABEL: negative_lsr_bfi0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and w0, w0, #0xffffff0f
; CHECK-NEXT:    ret
  %and1 = and i32 %a, -241
  %1 = lshr i32 %a, 28
  %shl = and i32 %1, 240
  %or = or i32 %shl, %and1
  ret i32 %or
}

define i32 @negative_lsr_bfi1(i32 %a) {
; CHECK-LABEL: negative_lsr_bfi1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    lsr w8, w0, #16
; CHECK-NEXT:    lsr w9, w8, #4
; CHECK-NEXT:    bfi w0, w9, #4, #4
; CHECK-NEXT:    add w0, w0, w8
; CHECK-NEXT:    ret
  %and1 = and i32 %a, -241
  %1 = lshr i32 %a, 16
  %shl = and i32 %1, 240
  %or = or i32 %shl, %and1
  %add = add i32 %or, %1
  ret i32 %add
}

define i64 @lsr_bfix(i64 %a) {
; CHECK-LABEL: lsr_bfix:
; CHECK:       // %bb.0:
; CHECK-NEXT:    lsr x8, x0, #20
; CHECK-NEXT:    bfi x0, x8, #4, #4
; CHECK-NEXT:    ret
  %and1 = and i64 %a, -241
  %1 = lshr i64 %a, 16
  %shl = and i64 %1, 240
  %or = or i64 %shl, %and1
  ret i64 %or
}

define i64 @negative_lsr_bfix0(i64 %a) {
; CHECK-LABEL: negative_lsr_bfix0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and x0, x0, #0xffffffffffffff0f
; CHECK-NEXT:    ret
  %and1 = and i64 %a, -241
  %1 = lshr i64 %a, 60
  %shl = and i64 %1, 240
  %or = or i64 %shl, %and1
  ret i64 %or
}

define i64 @negative_lsr_bfix1(i64 %a) {
; CHECK-LABEL: negative_lsr_bfix1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    lsr x8, x0, #16
; CHECK-NEXT:    lsr x9, x8, #4
; CHECK-NEXT:    bfi x0, x9, #4, #4
; CHECK-NEXT:    add x0, x0, x8
; CHECK-NEXT:    ret
  %and1 = and i64 %a, -241
  %1 = lshr i64 %a, 16
  %shl = and i64 %1, 240
  %or = or i64 %shl, %and1
  %add = add i64 %or, %1
  ret i64 %add
}
