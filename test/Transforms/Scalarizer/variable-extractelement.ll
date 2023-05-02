; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt %s -passes='function(scalarizer,dce)' -S | FileCheck --check-prefix=DEFAULT %s
; RUN: opt %s -passes='function(scalarizer,dce)' -scalarize-variable-insert-extract=false -S | FileCheck --check-prefix=OFF %s
; RUN: opt %s -passes='function(scalarizer,dce)' -scalarize-variable-insert-extract=true -S | FileCheck --check-prefix=DEFAULT %s

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"

; Test that variable extracts scalarized.
define i32 @f1(<4 x i32> %src, i32 %index) {
; DEFAULT-LABEL: @f1(
; DEFAULT-NEXT:    [[INDEX_IS_0:%.*]] = icmp eq i32 [[INDEX:%.*]], 0
; DEFAULT-NEXT:    [[SRC_I0:%.*]] = extractelement <4 x i32> [[SRC:%.*]], i32 0
; DEFAULT-NEXT:    [[RES_UPTO0:%.*]] = select i1 [[INDEX_IS_0]], i32 [[SRC_I0]], i32 poison
; DEFAULT-NEXT:    [[INDEX_IS_1:%.*]] = icmp eq i32 [[INDEX]], 1
; DEFAULT-NEXT:    [[SRC_I1:%.*]] = extractelement <4 x i32> [[SRC]], i32 1
; DEFAULT-NEXT:    [[RES_UPTO1:%.*]] = select i1 [[INDEX_IS_1]], i32 [[SRC_I1]], i32 [[RES_UPTO0]]
; DEFAULT-NEXT:    [[INDEX_IS_2:%.*]] = icmp eq i32 [[INDEX]], 2
; DEFAULT-NEXT:    [[SRC_I2:%.*]] = extractelement <4 x i32> [[SRC]], i32 2
; DEFAULT-NEXT:    [[RES_UPTO2:%.*]] = select i1 [[INDEX_IS_2]], i32 [[SRC_I2]], i32 [[RES_UPTO1]]
; DEFAULT-NEXT:    [[INDEX_IS_3:%.*]] = icmp eq i32 [[INDEX]], 3
; DEFAULT-NEXT:    [[SRC_I3:%.*]] = extractelement <4 x i32> [[SRC]], i32 3
; DEFAULT-NEXT:    [[RES_UPTO3:%.*]] = select i1 [[INDEX_IS_3]], i32 [[SRC_I3]], i32 [[RES_UPTO2]]
; DEFAULT-NEXT:    ret i32 [[RES_UPTO3]]
;
; OFF-LABEL: @f1(
; OFF-NEXT:    [[RES:%.*]] = extractelement <4 x i32> [[SRC:%.*]], i32 [[INDEX:%.*]]
; OFF-NEXT:    ret i32 [[RES]]
;
  %res = extractelement <4 x i32> %src, i32 %index
  ret i32 %res
}

define i32 @f2(ptr %src, i32 %index) {
; DEFAULT-LABEL: @f2(
; DEFAULT-NEXT:    [[VAL0:%.*]] = load <4 x i32>, ptr [[SRC:%.*]], align 16
; DEFAULT-NEXT:    [[VAL0_I0:%.*]] = extractelement <4 x i32> [[VAL0]], i32 0
; DEFAULT-NEXT:    [[VAL1_I0:%.*]] = shl i32 1, [[VAL0_I0]]
; DEFAULT-NEXT:    [[VAL0_I1:%.*]] = extractelement <4 x i32> [[VAL0]], i32 1
; DEFAULT-NEXT:    [[VAL1_I1:%.*]] = shl i32 2, [[VAL0_I1]]
; DEFAULT-NEXT:    [[VAL0_I2:%.*]] = extractelement <4 x i32> [[VAL0]], i32 2
; DEFAULT-NEXT:    [[VAL1_I2:%.*]] = shl i32 3, [[VAL0_I2]]
; DEFAULT-NEXT:    [[VAL0_I3:%.*]] = extractelement <4 x i32> [[VAL0]], i32 3
; DEFAULT-NEXT:    [[VAL1_I3:%.*]] = shl i32 4, [[VAL0_I3]]
; DEFAULT-NEXT:    [[INDEX_IS_0:%.*]] = icmp eq i32 [[INDEX:%.*]], 0
; DEFAULT-NEXT:    [[VAL2_UPTO0:%.*]] = select i1 [[INDEX_IS_0]], i32 [[VAL1_I0]], i32 poison
; DEFAULT-NEXT:    [[INDEX_IS_1:%.*]] = icmp eq i32 [[INDEX]], 1
; DEFAULT-NEXT:    [[VAL2_UPTO1:%.*]] = select i1 [[INDEX_IS_1]], i32 [[VAL1_I1]], i32 [[VAL2_UPTO0]]
; DEFAULT-NEXT:    [[INDEX_IS_2:%.*]] = icmp eq i32 [[INDEX]], 2
; DEFAULT-NEXT:    [[VAL2_UPTO2:%.*]] = select i1 [[INDEX_IS_2]], i32 [[VAL1_I2]], i32 [[VAL2_UPTO1]]
; DEFAULT-NEXT:    [[INDEX_IS_3:%.*]] = icmp eq i32 [[INDEX]], 3
; DEFAULT-NEXT:    [[VAL2_UPTO3:%.*]] = select i1 [[INDEX_IS_3]], i32 [[VAL1_I3]], i32 [[VAL2_UPTO2]]
; DEFAULT-NEXT:    ret i32 [[VAL2_UPTO3]]
;
; OFF-LABEL: @f2(
; OFF-NEXT:    [[VAL0:%.*]] = load <4 x i32>, ptr [[SRC:%.*]], align 16
; OFF-NEXT:    [[VAL0_I0:%.*]] = extractelement <4 x i32> [[VAL0]], i32 0
; OFF-NEXT:    [[VAL1_I0:%.*]] = shl i32 1, [[VAL0_I0]]
; OFF-NEXT:    [[VAL0_I1:%.*]] = extractelement <4 x i32> [[VAL0]], i32 1
; OFF-NEXT:    [[VAL1_I1:%.*]] = shl i32 2, [[VAL0_I1]]
; OFF-NEXT:    [[VAL0_I2:%.*]] = extractelement <4 x i32> [[VAL0]], i32 2
; OFF-NEXT:    [[VAL1_I2:%.*]] = shl i32 3, [[VAL0_I2]]
; OFF-NEXT:    [[VAL0_I3:%.*]] = extractelement <4 x i32> [[VAL0]], i32 3
; OFF-NEXT:    [[VAL1_I3:%.*]] = shl i32 4, [[VAL0_I3]]
; OFF-NEXT:    [[VAL1_UPTO0:%.*]] = insertelement <4 x i32> poison, i32 [[VAL1_I0]], i32 0
; OFF-NEXT:    [[VAL1_UPTO1:%.*]] = insertelement <4 x i32> [[VAL1_UPTO0]], i32 [[VAL1_I1]], i32 1
; OFF-NEXT:    [[VAL1_UPTO2:%.*]] = insertelement <4 x i32> [[VAL1_UPTO1]], i32 [[VAL1_I2]], i32 2
; OFF-NEXT:    [[VAL1:%.*]] = insertelement <4 x i32> [[VAL1_UPTO2]], i32 [[VAL1_I3]], i32 3
; OFF-NEXT:    [[VAL2:%.*]] = extractelement <4 x i32> [[VAL1]], i32 [[INDEX:%.*]]
; OFF-NEXT:    ret i32 [[VAL2]]
;
  %val0 = load <4 x i32> , ptr %src
  %val1 = shl <4 x i32> <i32 1, i32 2, i32 3, i32 4>, %val0
  %val2 = extractelement <4 x i32> %val1, i32 %index
  ret i32 %val2
}
