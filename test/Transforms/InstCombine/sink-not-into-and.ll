; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

; Transform
;   z = ~(x & y)
; into:
;   z = ~(~x | ~y)
; iff both x and y are free to invert.

declare void @use1(i1)

; Most basic positive test
define i1 @t0(i32 %v0, i32 %v1, i32 %v2, i32 %v3) {
; CHECK-LABEL: @t0(
; CHECK-NEXT:    [[I1:%.*]] = icmp ne i32 [[V0:%.*]], [[V1:%.*]]
; CHECK-NEXT:    [[I2:%.*]] = icmp ne i32 [[V2:%.*]], [[V3:%.*]]
; CHECK-NEXT:    [[I3_NOT:%.*]] = or i1 [[I2]], [[I1]]
; CHECK-NEXT:    ret i1 [[I3_NOT]]
;
  %i1 = icmp eq i32 %v0, %v1
  %i2 = icmp eq i32 %v2, %v3
  %i3 = and i1 %i2, %i1
  %i4 = xor i1 %i3, -1
  ret i1 %i4
}

; All operands must be invertible
define i1 @n1(i1 %i1, i32 %v2, i32 %v3) {
; CHECK-LABEL: @n1(
; CHECK-NEXT:    [[I2:%.*]] = icmp eq i32 [[V2:%.*]], [[V3:%.*]]
; CHECK-NEXT:    [[I3:%.*]] = and i1 [[I2]], [[I1:%.*]]
; CHECK-NEXT:    [[I4:%.*]] = xor i1 [[I3]], true
; CHECK-NEXT:    ret i1 [[I4]]
;
  %i2 = icmp eq i32 %v2, %v3
  %i3 = and i1 %i2, %i1
  %i4 = xor i1 %i3, -1
  ret i1 %i4
}
define i1 @n2(i32 %v0, i32 %v1, i1 %i2) {
; CHECK-LABEL: @n2(
; CHECK-NEXT:    [[I1:%.*]] = icmp eq i32 [[V0:%.*]], [[V1:%.*]]
; CHECK-NEXT:    [[I3:%.*]] = and i1 [[I1]], [[I2:%.*]]
; CHECK-NEXT:    [[I4:%.*]] = xor i1 [[I3]], true
; CHECK-NEXT:    ret i1 [[I4]]
;
  %i1 = icmp eq i32 %v0, %v1
  %i3 = and i1 %i2, %i1
  %i4 = xor i1 %i3, -1
  ret i1 %i4
}
define i1 @n3(i1 %i1, i1 %i2) {
; CHECK-LABEL: @n3(
; CHECK-NEXT:    [[I3:%.*]] = and i1 [[I2:%.*]], [[I1:%.*]]
; CHECK-NEXT:    [[I4:%.*]] = xor i1 [[I3]], true
; CHECK-NEXT:    ret i1 [[I4]]
;
  %i3 = and i1 %i2, %i1
  %i4 = xor i1 %i3, -1
  ret i1 %i4
}

; All other uses of operands must be invertible
define i1 @n4(i32 %v0, i32 %v1, i32 %v2, i32 %v3) {
; CHECK-LABEL: @n4(
; CHECK-NEXT:    [[I1:%.*]] = icmp eq i32 [[V0:%.*]], [[V1:%.*]]
; CHECK-NEXT:    [[I2:%.*]] = icmp eq i32 [[V2:%.*]], [[V3:%.*]]
; CHECK-NEXT:    call void @use1(i1 [[I1]])
; CHECK-NEXT:    [[I3:%.*]] = and i1 [[I2]], [[I1]]
; CHECK-NEXT:    [[I4:%.*]] = xor i1 [[I3]], true
; CHECK-NEXT:    ret i1 [[I4]]
;
  %i1 = icmp eq i32 %v0, %v1
  %i2 = icmp eq i32 %v2, %v3
  call void @use1(i1 %i1)
  %i3 = and i1 %i2, %i1
  %i4 = xor i1 %i3, -1
  ret i1 %i4
}
define i1 @n5(i32 %v0, i32 %v1, i32 %v2, i32 %v3) {
; CHECK-LABEL: @n5(
; CHECK-NEXT:    [[I1:%.*]] = icmp eq i32 [[V0:%.*]], [[V1:%.*]]
; CHECK-NEXT:    [[I2:%.*]] = icmp eq i32 [[V2:%.*]], [[V3:%.*]]
; CHECK-NEXT:    call void @use1(i1 [[I2]])
; CHECK-NEXT:    [[I3:%.*]] = and i1 [[I2]], [[I1]]
; CHECK-NEXT:    [[I4:%.*]] = xor i1 [[I3]], true
; CHECK-NEXT:    ret i1 [[I4]]
;
  %i1 = icmp eq i32 %v0, %v1
  %i2 = icmp eq i32 %v2, %v3
  call void @use1(i1 %i2)
  %i3 = and i1 %i2, %i1
  %i4 = xor i1 %i3, -1
  ret i1 %i4
}
define i1 @n6(i32 %v0, i32 %v1, i32 %v2, i32 %v3) {
; CHECK-LABEL: @n6(
; CHECK-NEXT:    [[I1:%.*]] = icmp eq i32 [[V0:%.*]], [[V1:%.*]]
; CHECK-NEXT:    [[I2:%.*]] = icmp eq i32 [[V2:%.*]], [[V3:%.*]]
; CHECK-NEXT:    call void @use1(i1 [[I1]])
; CHECK-NEXT:    call void @use1(i1 [[I2]])
; CHECK-NEXT:    [[I3:%.*]] = and i1 [[I2]], [[I1]]
; CHECK-NEXT:    [[I4:%.*]] = xor i1 [[I3]], true
; CHECK-NEXT:    ret i1 [[I4]]
;
  %i1 = icmp eq i32 %v0, %v1
  %i2 = icmp eq i32 %v2, %v3
  call void @use1(i1 %i1)
  call void @use1(i1 %i2)
  %i3 = and i1 %i2, %i1
  %i4 = xor i1 %i3, -1
  ret i1 %i4
}

; Hands have invertible uses
define i1 @t7(i32 %v0, i32 %v1, i32 %v2, i32 %v3) {
; CHECK-LABEL: @t7(
; CHECK-NEXT:    [[I1:%.*]] = icmp ne i32 [[V0:%.*]], [[V1:%.*]]
; CHECK-NEXT:    call void @use1(i1 [[I1]])
; CHECK-NEXT:    [[I2:%.*]] = icmp ne i32 [[V2:%.*]], [[V3:%.*]]
; CHECK-NEXT:    [[I3_NOT:%.*]] = or i1 [[I2]], [[I1]]
; CHECK-NEXT:    ret i1 [[I3_NOT]]
;
  %i1 = icmp eq i32 %v0, %v1
  %i1.not = xor i1 %i1, -1
  call void @use1(i1 %i1.not)
  %i2 = icmp eq i32 %v2, %v3
  %i3 = and i1 %i2, %i1
  %i4 = xor i1 %i3, -1
  ret i1 %i4
}
define i1 @t8(i32 %v0, i32 %v1, i32 %v2, i32 %v3) {
; CHECK-LABEL: @t8(
; CHECK-NEXT:    [[I1:%.*]] = icmp ne i32 [[V0:%.*]], [[V1:%.*]]
; CHECK-NEXT:    [[I2:%.*]] = icmp ne i32 [[V2:%.*]], [[V3:%.*]]
; CHECK-NEXT:    call void @use1(i1 [[I2]])
; CHECK-NEXT:    [[I3_NOT:%.*]] = or i1 [[I2]], [[I1]]
; CHECK-NEXT:    ret i1 [[I3_NOT]]
;
  %i1 = icmp eq i32 %v0, %v1
  %i2 = icmp eq i32 %v2, %v3
  %i2.not = xor i1 %i2, -1
  call void @use1(i1 %i2.not)
  %i3 = and i1 %i2, %i1
  %i4 = xor i1 %i3, -1
  ret i1 %i4
}
define i1 @t9(i32 %v0, i32 %v1, i32 %v2, i32 %v3) {
; CHECK-LABEL: @t9(
; CHECK-NEXT:    [[I1:%.*]] = icmp ne i32 [[V0:%.*]], [[V1:%.*]]
; CHECK-NEXT:    call void @use1(i1 [[I1]])
; CHECK-NEXT:    [[I2:%.*]] = icmp ne i32 [[V2:%.*]], [[V3:%.*]]
; CHECK-NEXT:    call void @use1(i1 [[I2]])
; CHECK-NEXT:    [[I3_NOT:%.*]] = or i1 [[I2]], [[I1]]
; CHECK-NEXT:    ret i1 [[I3_NOT]]
;
  %i1 = icmp eq i32 %v0, %v1
  %i1.not = xor i1 %i1, -1
  call void @use1(i1 %i1.not)
  %i2 = icmp eq i32 %v2, %v3
  %i2.not = xor i1 %i2, -1
  call void @use1(i1 %i2.not)
  %i3 = and i1 %i2, %i1
  %i4 = xor i1 %i3, -1
  ret i1 %i4
}

; Select can have other uses

; Not all uses can be adapted
define i1 @n10(i32 %v0, i32 %v1, i32 %v2, i32 %v3) {
; CHECK-LABEL: @n10(
; CHECK-NEXT:    [[I1:%.*]] = icmp eq i32 [[V0:%.*]], [[V1:%.*]]
; CHECK-NEXT:    [[I2:%.*]] = icmp eq i32 [[V2:%.*]], [[V3:%.*]]
; CHECK-NEXT:    [[I3:%.*]] = and i1 [[I2]], [[I1]]
; CHECK-NEXT:    call void @use1(i1 [[I3]])
; CHECK-NEXT:    [[I4:%.*]] = xor i1 [[I3]], true
; CHECK-NEXT:    ret i1 [[I4]]
;
  %i1 = icmp eq i32 %v0, %v1
  %i2 = icmp eq i32 %v2, %v3
  %i3 = and i1 %i2, %i1
  call void @use1(i1 %i3)
  %i4 = xor i1 %i3, -1
  ret i1 %i4
}

; All other uses can be adapted.
define i1 @t11(i32 %v0, i32 %v1, i32 %v2, i32 %v3, i1 %v4, i1 %v5) {
; CHECK-LABEL: @t11(
; CHECK-NEXT:    [[I1:%.*]] = icmp ne i32 [[V0:%.*]], [[V1:%.*]]
; CHECK-NEXT:    [[I2:%.*]] = icmp ne i32 [[V2:%.*]], [[V3:%.*]]
; CHECK-NEXT:    [[I3_NOT:%.*]] = or i1 [[I2]], [[I1]]
; CHECK-NEXT:    [[I5:%.*]] = select i1 [[I3_NOT]], i1 [[V5:%.*]], i1 [[V4:%.*]]
; CHECK-NEXT:    call void @use1(i1 [[I5]])
; CHECK-NEXT:    ret i1 [[I3_NOT]]
;
  %i1 = icmp eq i32 %v0, %v1
  %i2 = icmp eq i32 %v2, %v3
  %i3 = and i1 %i2, %i1
  %i4 = xor i1 %i3, -1
  %i5 = select i1 %i3, i1 %v4, i1 %v5
  call void @use1(i1 %i5)
  ret i1 %i4
}
