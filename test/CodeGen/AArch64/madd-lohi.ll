; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=arm64-apple-ios7.0 %s -o - | FileCheck %s
; RUN: llc -mtriple=aarch64_be-linux-gnu %s -o - | FileCheck --check-prefix=CHECK-BE %s

define i128 @test_128bitmul(i128 %lhs, i128 %rhs) {
; CHECK-LABEL: test_128bitmul:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    umulh x8, x0, x2
; CHECK-NEXT:    madd x8, x0, x3, x8
; CHECK-NEXT:    mul x0, x0, x2
; CHECK-NEXT:    madd x1, x1, x2, x8
; CHECK-NEXT:    ret
;
; CHECK-BE-LABEL: test_128bitmul:
; CHECK-BE:       // %bb.0:
; CHECK-BE-NEXT:    umulh x8, x1, x3
; CHECK-BE-NEXT:    madd x8, x1, x2, x8
; CHECK-BE-NEXT:    mul x1, x1, x3
; CHECK-BE-NEXT:    madd x0, x0, x3, x8
; CHECK-BE-NEXT:    ret


  %prod = mul i128 %lhs, %rhs
  ret i128 %prod
}
