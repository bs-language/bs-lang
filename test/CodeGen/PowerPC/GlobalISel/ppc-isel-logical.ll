; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple ppc64le-linux -ppc-asm-full-reg-names -global-isel -o - < %s \
; RUN:     | FileCheck %s

define i64 @test_andi64(i64 %a, i64 %b) {
; CHECK-LABEL: test_andi64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    and r3, r3, r4
; CHECK-NEXT:    blr
  %res = and i64 %a, %b
  ret i64 %res
}

define i64 @test_nandi64(i64 %a, i64 %b) {
; CHECK-LABEL: test_nandi64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    nand r3, r3, r4
; CHECK-NEXT:    blr
  %and = and i64 %a, %b
  %neg = xor i64 %and, -1
  ret i64 %neg
}

define i64 @test_andci64(i64 %a, i64 %b) {
; CHECK-LABEL: test_andci64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    andc r3, r3, r4
; CHECK-NEXT:    blr
  %neg = xor i64 %b, -1
  %and = and i64 %a, %neg
  ret i64 %and
}

define i64 @test_ori64(i64 %a, i64 %b) {
; CHECK-LABEL: test_ori64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    or r3, r3, r4
; CHECK-NEXT:    blr
  %res = or i64 %a, %b
  ret i64 %res
}

define i64 @test_orci64(i64 %a, i64 %b) {
; CHECK-LABEL: test_orci64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    orc r3, r3, r4
; CHECK-NEXT:    blr
  %neg = xor i64 %b, -1
  %or = or i64 %a, %neg
  ret i64 %or
}

define i64 @test_nori64(i64 %a, i64 %b) {
; CHECK-LABEL: test_nori64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    nor r3, r3, r4
; CHECK-NEXT:    blr
  %or = or i64 %a, %b
  %neg = xor i64 %or, -1
  ret i64 %neg
}

define i64 @test_xori64(i64 %a, i64 %b) {
; CHECK-LABEL: test_xori64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xor r3, r3, r4
; CHECK-NEXT:    blr
  %res = xor i64 %a, %b
  ret i64 %res
}
