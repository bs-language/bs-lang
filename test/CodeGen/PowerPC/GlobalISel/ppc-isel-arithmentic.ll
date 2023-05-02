; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple ppc64le-linux -ppc-asm-full-reg-names -global-isel -o - < %s \
; RUN:     | FileCheck %s

define i8 @test_addi8(i8 %a, i8 %b) {
; CHECK-LABEL: test_addi8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    add r3, r3, r4
; CHECK-NEXT:    blr
  %res = add i8 %a, %b
  ret i8 %res
}

define i16 @test_addi16(i16 %a, i16 %b) {
; CHECK-LABEL: test_addi16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    add r3, r3, r4
; CHECK-NEXT:    blr
  %res = add i16 %a, %b
  ret i16 %res
}

define i32 @test_addi32(i32 %a, i32 %b) {
; CHECK-LABEL: test_addi32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    add r3, r3, r4
; CHECK-NEXT:    blr
  %res = add i32 %a, %b
  ret i32 %res
}

define i64 @test_addi64(i64 %a, i64 %b) {
; CHECK-LABEL: test_addi64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    add r3, r3, r4
; CHECK-NEXT:    blr
  %res = add i64 %a, %b
  ret i64 %res
}

define i8 @test_subi8(i8 %a, i8 %b) {
; CHECK-LABEL: test_subi8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    sub r3, r3, r4
; CHECK-NEXT:    blr
  %res = sub i8 %a, %b
  ret i8 %res
}

define i16 @test_subi16(i16 %a, i16 %b) {
; CHECK-LABEL: test_subi16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    sub r3, r3, r4
; CHECK-NEXT:    blr
  %res = sub i16 %a, %b
  ret i16 %res
}

define i32 @test_subi32(i32 %a, i32 %b) {
; CHECK-LABEL: test_subi32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    sub r3, r3, r4
; CHECK-NEXT:    blr
  %res = sub i32 %a, %b
  ret i32 %res
}

define i64 @test_subi64(i64 %a, i64 %b) {
; CHECK-LABEL: test_subi64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    sub r3, r3, r4
; CHECK-NEXT:    blr
  %res = sub i64 %a, %b
  ret i64 %res
}
