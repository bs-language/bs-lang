; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=indvars < %s | FileCheck %s

; Do not rewrite the user outside the loop because we must keep the instruction
; inside the loop due to store. Rewrite doesn't give us any profit.
define void @f(i32 %length.i.88, i32 %length.i, ptr %tmp12, i32 %tmp10, ptr %tmp8) {
; CHECK-LABEL: @f(
; CHECK-NEXT:  not_zero11.preheader:
; CHECK-NEXT:    [[TMP13:%.*]] = icmp ugt i32 [[LENGTH_I:%.*]], [[LENGTH_I_88:%.*]]
; CHECK-NEXT:    [[TMP14:%.*]] = select i1 [[TMP13]], i32 [[LENGTH_I_88]], i32 [[LENGTH_I]]
; CHECK-NEXT:    [[TMP15:%.*]] = icmp sgt i32 [[TMP14]], 0
; CHECK-NEXT:    br i1 [[TMP15]], label [[NOT_ZERO11_PREHEADER1:%.*]], label [[NOT_ZERO11_POSTLOOP:%.*]]
; CHECK:       not_zero11.preheader1:
; CHECK-NEXT:    br label [[NOT_ZERO11:%.*]]
; CHECK:       not_zero11:
; CHECK-NEXT:    [[V_1:%.*]] = phi i32 [ [[TMP22:%.*]], [[NOT_ZERO11]] ], [ 0, [[NOT_ZERO11_PREHEADER1]] ]
; CHECK-NEXT:    [[TMP16:%.*]] = zext i32 [[V_1]] to i64
; CHECK-NEXT:    [[TMP17:%.*]] = getelementptr inbounds i8, ptr [[TMP8:%.*]], i64 [[TMP16]]
; CHECK-NEXT:    [[TMP18:%.*]] = load i8, ptr [[TMP17]], align 1
; CHECK-NEXT:    [[TMP19:%.*]] = zext i8 [[TMP18]] to i32
; CHECK-NEXT:    [[TMP20:%.*]] = or i32 [[TMP19]], [[TMP10:%.*]]
; CHECK-NEXT:    [[TMP21:%.*]] = trunc i32 [[TMP20]] to i8
; CHECK-NEXT:    [[ADDR22:%.*]] = getelementptr inbounds i8, ptr [[TMP12:%.*]], i64 [[TMP16]]
; CHECK-NEXT:    store i8 [[TMP21]], ptr [[ADDR22]], align 1
; CHECK-NEXT:    [[TMP22]] = add nuw nsw i32 [[V_1]], 1
; CHECK-NEXT:    [[TMP23:%.*]] = icmp slt i32 [[TMP22]], [[TMP14]]
; CHECK-NEXT:    br i1 [[TMP23]], label [[NOT_ZERO11]], label [[MAIN_EXIT_SELECTOR:%.*]]
; CHECK:       main.exit.selector:
; CHECK-NEXT:    [[TMP22_LCSSA:%.*]] = phi i32 [ [[TMP22]], [[NOT_ZERO11]] ]
; CHECK-NEXT:    [[TMP24:%.*]] = icmp slt i32 [[TMP22_LCSSA]], [[LENGTH_I]]
; CHECK-NEXT:    br i1 [[TMP24]], label [[NOT_ZERO11_POSTLOOP]], label [[LEAVE:%.*]]
; CHECK:       leave:
; CHECK-NEXT:    ret void
; CHECK:       not_zero11.postloop:
; CHECK-NEXT:    ret void
;
not_zero11.preheader:
  %tmp13 = icmp ugt i32 %length.i, %length.i.88
  %tmp14 = select i1 %tmp13, i32 %length.i.88, i32 %length.i
  %tmp15 = icmp sgt i32 %tmp14, 0
  br i1 %tmp15, label %not_zero11, label %not_zero11.postloop

not_zero11:
  %v_1 = phi i32 [ %tmp22, %not_zero11 ], [ 0, %not_zero11.preheader ]
  %tmp16 = zext i32 %v_1 to i64
  %tmp17 = getelementptr inbounds i8, ptr %tmp8, i64 %tmp16
  %tmp18 = load i8, ptr %tmp17, align 1
  %tmp19 = zext i8 %tmp18 to i32
  %tmp20 = or i32 %tmp19, %tmp10
  %tmp21 = trunc i32 %tmp20 to i8
  %addr22 = getelementptr inbounds i8, ptr %tmp12, i64 %tmp16
  store i8 %tmp21, ptr %addr22, align 1
  %tmp22 = add nuw nsw i32 %v_1, 1
  %tmp23 = icmp slt i32 %tmp22, %tmp14
  br i1 %tmp23, label %not_zero11, label %main.exit.selector

main.exit.selector:
  %tmp24 = icmp slt i32 %tmp22, %length.i
  br i1 %tmp24, label %not_zero11.postloop, label %leave

leave:
  ret void

not_zero11.postloop:
  ret void
}

; Rewrite the user outside the loop because there is no hard users inside the loop.
define void @f1(i32 %length.i.88, i32 %length.i, ptr %tmp12, i32 %tmp10, ptr %tmp8) {
; CHECK-LABEL: @f1(
; CHECK-NEXT:  not_zero11.preheader:
; CHECK-NEXT:    [[TMP13:%.*]] = icmp ugt i32 [[LENGTH_I:%.*]], [[LENGTH_I_88:%.*]]
; CHECK-NEXT:    [[TMP14:%.*]] = select i1 [[TMP13]], i32 [[LENGTH_I_88]], i32 [[LENGTH_I]]
; CHECK-NEXT:    [[TMP15:%.*]] = icmp sgt i32 [[TMP14]], 0
; CHECK-NEXT:    br i1 [[TMP15]], label [[NOT_ZERO11_PREHEADER1:%.*]], label [[NOT_ZERO11_POSTLOOP:%.*]]
; CHECK:       not_zero11.preheader1:
; CHECK-NEXT:    br label [[NOT_ZERO11:%.*]]
; CHECK:       not_zero11:
; CHECK-NEXT:    [[V_1:%.*]] = phi i32 [ [[TMP22:%.*]], [[NOT_ZERO11]] ], [ 0, [[NOT_ZERO11_PREHEADER1]] ]
; CHECK-NEXT:    [[TMP16:%.*]] = zext i32 [[V_1]] to i64
; CHECK-NEXT:    [[TMP17:%.*]] = getelementptr inbounds i8, ptr [[TMP8:%.*]], i64 [[TMP16]]
; CHECK-NEXT:    [[TMP18:%.*]] = load i8, ptr [[TMP17]], align 1
; CHECK-NEXT:    [[TMP19:%.*]] = zext i8 [[TMP18]] to i32
; CHECK-NEXT:    [[TMP20:%.*]] = or i32 [[TMP19]], [[TMP10:%.*]]
; CHECK-NEXT:    [[TMP21:%.*]] = trunc i32 [[TMP20]] to i8
; CHECK-NEXT:    [[ADDR22:%.*]] = getelementptr inbounds i8, ptr [[TMP12:%.*]], i64 [[TMP16]]
; CHECK-NEXT:    [[TMP22]] = add nuw nsw i32 [[V_1]], 1
; CHECK-NEXT:    br i1 false, label [[NOT_ZERO11]], label [[MAIN_EXIT_SELECTOR:%.*]]
; CHECK:       main.exit.selector:
; CHECK-NEXT:    [[TMP24:%.*]] = icmp slt i32 [[TMP14]], [[LENGTH_I]]
; CHECK-NEXT:    br i1 [[TMP24]], label [[NOT_ZERO11_POSTLOOP]], label [[LEAVE:%.*]]
; CHECK:       leave:
; CHECK-NEXT:    ret void
; CHECK:       not_zero11.postloop:
; CHECK-NEXT:    ret void
;
not_zero11.preheader:
  %tmp13 = icmp ugt i32 %length.i, %length.i.88
  %tmp14 = select i1 %tmp13, i32 %length.i.88, i32 %length.i
  %tmp15 = icmp sgt i32 %tmp14, 0
  br i1 %tmp15, label %not_zero11, label %not_zero11.postloop

not_zero11:
  %v_1 = phi i32 [ %tmp22, %not_zero11 ], [ 0, %not_zero11.preheader ]
  %tmp16 = zext i32 %v_1 to i64
  %tmp17 = getelementptr inbounds i8, ptr %tmp8, i64 %tmp16
  %tmp18 = load i8, ptr %tmp17, align 1
  %tmp19 = zext i8 %tmp18 to i32
  %tmp20 = or i32 %tmp19, %tmp10
  %tmp21 = trunc i32 %tmp20 to i8
  %addr22 = getelementptr inbounds i8, ptr %tmp12, i64 %tmp16
  %tmp22 = add nuw nsw i32 %v_1, 1
  %tmp23 = icmp slt i32 %tmp22, %tmp14
  br i1 %tmp23, label %not_zero11, label %main.exit.selector

main.exit.selector:
  %tmp24 = icmp slt i32 %tmp22, %length.i
  br i1 %tmp24, label %not_zero11.postloop, label %leave

leave:
  ret void

not_zero11.postloop:
  ret void
}
