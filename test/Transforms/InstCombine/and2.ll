; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

define i1 @test2(i1 %X, i1 %Y) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[A:%.*]] = and i1 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[A]]
;
  %a = and i1 %X, %Y
  %b = and i1 %a, %X
  ret i1 %b
}

define i1 @test2_logical(i1 %X, i1 %Y) {
; CHECK-LABEL: @test2_logical(
; CHECK-NEXT:    [[A:%.*]] = select i1 [[X:%.*]], i1 [[Y:%.*]], i1 false
; CHECK-NEXT:    ret i1 [[A]]
;
  %a = select i1 %X, i1 %Y, i1 false
  %b = select i1 %a, i1 %X, i1 false
  ret i1 %b
}

define i32 @test3(i32 %X, i32 %Y) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[A:%.*]] = and i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[A]]
;
  %a = and i32 %X, %Y
  %b = and i32 %Y, %a
  ret i32 %b
}

define i1 @test7(i32 %i, i1 %b) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i32 [[I:%.*]], 0
; CHECK-NEXT:    [[TMP2:%.*]] = and i1 [[TMP1]], [[B:%.*]]
; CHECK-NEXT:    ret i1 [[TMP2]]
;
  %cmp1 = icmp slt i32 %i, 1
  %cmp2 = icmp sgt i32 %i, -1
  %and1 = and i1 %cmp1, %b
  %and2 = and i1 %and1, %cmp2
  ret i1 %and2
}

define i1 @test7_logical(i32 %i, i1 %b) {
; CHECK-LABEL: @test7_logical(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i32 [[I:%.*]], 0
; CHECK-NEXT:    [[TMP2:%.*]] = select i1 [[TMP1]], i1 [[B:%.*]], i1 false
; CHECK-NEXT:    ret i1 [[TMP2]]
;
  %cmp1 = icmp slt i32 %i, 1
  %cmp2 = icmp sgt i32 %i, -1
  %and1 = select i1 %cmp1, i1 %b, i1 false
  %and2 = select i1 %and1, i1 %cmp2, i1 false
  ret i1 %and2
}

define i1 @test8(i32 %i) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    [[TMP1:%.*]] = add i32 [[I:%.*]], -1
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ult i32 [[TMP1]], 13
; CHECK-NEXT:    ret i1 [[TMP2]]
;
  %cmp1 = icmp ne i32 %i, 0
  %cmp2 = icmp ult i32 %i, 14
  %cond = and i1 %cmp1, %cmp2
  ret i1 %cond
}

define i1 @test8_logical(i32 %i) {
; CHECK-LABEL: @test8_logical(
; CHECK-NEXT:    [[TMP1:%.*]] = add i32 [[I:%.*]], -1
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ult i32 [[TMP1]], 13
; CHECK-NEXT:    ret i1 [[TMP2]]
;
  %cmp1 = icmp ne i32 %i, 0
  %cmp2 = icmp ult i32 %i, 14
  %cond = select i1 %cmp1, i1 %cmp2, i1 false
  ret i1 %cond
}

define <2 x i1> @test8vec(<2 x i32> %i) {
; CHECK-LABEL: @test8vec(
; CHECK-NEXT:    [[TMP1:%.*]] = add <2 x i32> [[I:%.*]], <i32 -1, i32 -1>
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ult <2 x i32> [[TMP1]], <i32 13, i32 13>
; CHECK-NEXT:    ret <2 x i1> [[TMP2]]
;
  %cmp1 = icmp ne <2 x i32> %i, zeroinitializer
  %cmp2 = icmp ult <2 x i32> %i, <i32 14, i32 14>
  %cond = and <2 x i1> %cmp1, %cmp2
  ret <2 x i1> %cond
}

; combine -x & 1 into x & 1
define i64 @test9(i64 %x) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:    [[AND:%.*]] = and i64 [[X:%.*]], 1
; CHECK-NEXT:    ret i64 [[AND]]
;
  %sub = sub nsw i64 0, %x
  %and = and i64 %sub, 1
  ret i64 %and
}

; combine -x & 1 into x & 1
define <2 x i64> @test9vec(<2 x i64> %x) {
; CHECK-LABEL: @test9vec(
; CHECK-NEXT:    [[AND:%.*]] = and <2 x i64> [[X:%.*]], <i64 1, i64 1>
; CHECK-NEXT:    ret <2 x i64> [[AND]]
;
  %sub = sub nsw <2 x i64> <i64 0, i64 0>, %x
  %and = and <2 x i64> %sub, <i64 1, i64 1>
  ret <2 x i64> %and
}

define i64 @test10(i64 %x) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    [[TMP1:%.*]] = and i64 [[X:%.*]], -2
; CHECK-NEXT:    [[ADD:%.*]] = sub i64 0, [[TMP1]]
; CHECK-NEXT:    ret i64 [[ADD]]
;
  %sub = sub nsw i64 0, %x
  %and = and i64 %sub, 1
  %add = add i64 %sub, %and
  ret i64 %add
}

; (1 << x) & 1 --> zext(x == 0)

define i8 @and1_shl1_is_cmp_eq_0(i8 %x) {
; CHECK-LABEL: @and1_shl1_is_cmp_eq_0(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i8 [[X:%.*]], 0
; CHECK-NEXT:    [[AND:%.*]] = zext i1 [[TMP1]] to i8
; CHECK-NEXT:    ret i8 [[AND]]
;
  %sh = shl i8 1, %x
  %and = and i8 %sh, 1
  ret i8 %and
}

; Don't do it if the shift has another use.

define i8 @and1_shl1_is_cmp_eq_0_multiuse(i8 %x) {
; CHECK-LABEL: @and1_shl1_is_cmp_eq_0_multiuse(
; CHECK-NEXT:    [[SH:%.*]] = shl nuw i8 1, [[X:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and i8 [[SH]], 1
; CHECK-NEXT:    [[ADD:%.*]] = add nuw i8 [[SH]], [[AND]]
; CHECK-NEXT:    ret i8 [[ADD]]
;
  %sh = shl i8 1, %x
  %and = and i8 %sh, 1
  %add = add i8 %sh, %and
  ret i8 %add
}

; (1 << x) & 1 --> zext(x == 0)

define <2 x i8> @and1_shl1_is_cmp_eq_0_vec(<2 x i8> %x) {
; CHECK-LABEL: @and1_shl1_is_cmp_eq_0_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq <2 x i8> [[X:%.*]], zeroinitializer
; CHECK-NEXT:    [[AND:%.*]] = zext <2 x i1> [[TMP1]] to <2 x i8>
; CHECK-NEXT:    ret <2 x i8> [[AND]]
;
  %sh = shl <2 x i8> <i8 1, i8 1>, %x
  %and = and <2 x i8> %sh, <i8 1, i8 1>
  ret <2 x i8> %and
}

define <2 x i8> @and1_shl1_is_cmp_eq_0_vec_undef(<2 x i8> %x) {
; CHECK-LABEL: @and1_shl1_is_cmp_eq_0_vec_undef(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq <2 x i8> [[X:%.*]], zeroinitializer
; CHECK-NEXT:    [[AND:%.*]] = zext <2 x i1> [[TMP1]] to <2 x i8>
; CHECK-NEXT:    ret <2 x i8> [[AND]]
;
  %sh = shl <2 x i8> <i8 1, i8 undef>, %x
  %and = and <2 x i8> %sh, <i8 1, i8 undef>
  ret <2 x i8> %and
}

; The mask is unnecessary.

define i8 @and1_lshr1_is_cmp_eq_0(i8 %x) {
; CHECK-LABEL: @and1_lshr1_is_cmp_eq_0(
; CHECK-NEXT:    [[SH:%.*]] = lshr i8 1, [[X:%.*]]
; CHECK-NEXT:    ret i8 [[SH]]
;
  %sh = lshr i8 1, %x
  %and = and i8 %sh, 1
  ret i8 %and
}

define i8 @and1_lshr1_is_cmp_eq_0_multiuse(i8 %x) {
; CHECK-LABEL: @and1_lshr1_is_cmp_eq_0_multiuse(
; CHECK-NEXT:    [[SH:%.*]] = lshr i8 1, [[X:%.*]]
; CHECK-NEXT:    [[ADD:%.*]] = shl nuw nsw i8 [[SH]], 1
; CHECK-NEXT:    ret i8 [[ADD]]
;
  %sh = lshr i8 1, %x
  %and = and i8 %sh, 1
  %add = add i8 %sh, %and
  ret i8 %add
}

; The mask is unnecessary.

define <2 x i8> @and1_lshr1_is_cmp_eq_0_vec(<2 x i8> %x) {
; CHECK-LABEL: @and1_lshr1_is_cmp_eq_0_vec(
; CHECK-NEXT:    [[SH:%.*]] = lshr <2 x i8> <i8 1, i8 1>, [[X:%.*]]
; CHECK-NEXT:    ret <2 x i8> [[SH]]
;
  %sh = lshr <2 x i8> <i8 1, i8 1>, %x
  %and = and <2 x i8> %sh, <i8 1, i8 1>
  ret <2 x i8> %and
}

define <2 x i8> @and1_lshr1_is_cmp_eq_0_vec_undef(<2 x i8> %x) {
; CHECK-LABEL: @and1_lshr1_is_cmp_eq_0_vec_undef(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq <2 x i8> [[X:%.*]], zeroinitializer
; CHECK-NEXT:    [[AND:%.*]] = zext <2 x i1> [[TMP1]] to <2 x i8>
; CHECK-NEXT:    ret <2 x i8> [[AND]]
;
  %sh = lshr <2 x i8> <i8 1, i8 undef>, %x
  %and = and <2 x i8> %sh, <i8 1, i8 undef>
  ret <2 x i8> %and
}

; The add in this test is unnecessary because the LSBs of the LHS are 0 and the 'and' only consumes bits from those LSBs. It doesn't matter what happens to the upper bits.
define i32 @test11(i32 %a, i32 %b) {
; CHECK-LABEL: @test11(
; CHECK-NEXT:    [[X:%.*]] = shl i32 [[A:%.*]], 8
; CHECK-NEXT:    [[Z:%.*]] = and i32 [[B:%.*]], 128
; CHECK-NEXT:    [[W:%.*]] = mul i32 [[Z]], [[X]]
; CHECK-NEXT:    ret i32 [[W]]
;
  %x = shl i32 %a, 8
  %y = add i32 %x, %b
  %z = and i32 %y, 128
  %w = mul i32 %z, %x ; to keep the shift from being removed
  ret i32 %w
}

; The add in this test is unnecessary because the LSBs of the RHS are 0 and the 'and' only consumes bits from those LSBs. It doesn't matter what happens to the upper bits.
define i32 @test12(i32 %a, i32 %b) {
; CHECK-LABEL: @test12(
; CHECK-NEXT:    [[X:%.*]] = shl i32 [[A:%.*]], 8
; CHECK-NEXT:    [[Z:%.*]] = and i32 [[B:%.*]], 128
; CHECK-NEXT:    [[W:%.*]] = mul i32 [[Z]], [[X]]
; CHECK-NEXT:    ret i32 [[W]]
;
  %x = shl i32 %a, 8
  %y = add i32 %b, %x
  %z = and i32 %y, 128
  %w = mul i32 %z, %x ; to keep the shift from being removed
  ret i32 %w
}

; The sub in this test is unnecessary because the LSBs of the RHS are 0 and the 'and' only consumes bits from those LSBs. It doesn't matter what happens to the upper bits.
define i32 @test13(i32 %a, i32 %b) {
; CHECK-LABEL: @test13(
; CHECK-NEXT:    [[X:%.*]] = shl i32 [[A:%.*]], 8
; CHECK-NEXT:    [[Z:%.*]] = and i32 [[B:%.*]], 128
; CHECK-NEXT:    [[W:%.*]] = mul i32 [[Z]], [[X]]
; CHECK-NEXT:    ret i32 [[W]]
;
  %x = shl i32 %a, 8
  %y = sub i32 %b, %x
  %z = and i32 %y, 128
  %w = mul i32 %z, %x ; to keep the shift from being removed
  ret i32 %w
}

; The sub in this test cannot be removed because we need to keep the negation of %b. TODO: But we should be able to replace the LHS of it with a 0.
define i32 @test14(i32 %a, i32 %b) {
; CHECK-LABEL: @test14(
; CHECK-NEXT:    [[X:%.*]] = shl i32 [[A:%.*]], 8
; CHECK-NEXT:    [[Y:%.*]] = sub i32 0, [[B:%.*]]
; CHECK-NEXT:    [[Z:%.*]] = and i32 [[Y]], 128
; CHECK-NEXT:    [[W:%.*]] = mul i32 [[Z]], [[X]]
; CHECK-NEXT:    ret i32 [[W]]
;
  %x = shl i32 %a, 8
  %y = sub i32 %x, %b
  %z = and i32 %y, 128
  %w = mul i32 %z, %x ; to keep the shift from being removed
  ret i32 %w
}
