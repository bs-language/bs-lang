; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes='require<loops>,jump-threading,verify<loops>' < %s | FileCheck %s

%"type1" = type { i8 }
%"type2" = type opaque

define dso_local ptr @func2(ptr %this, ptr) {
; CHECK-LABEL: @func2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[WHILE_COND:%.*]]
; CHECK:       select.unfold:
; CHECK-NEXT:    br label [[WHILE_COND]]
; CHECK:       while.cond:
; CHECK-NEXT:    [[MONTH_0:%.*]] = phi i32 [ undef, [[ENTRY:%.*]] ], [ [[CALL2:%.*]], [[FUNC1_EXIT:%.*]] ], [ [[ADD:%.*]], [[SELECT_UNFOLD:%.*]] ]
; CHECK-NEXT:    switch i32 [[MONTH_0]], label [[IF_END_I:%.*]] [
; CHECK-NEXT:    i32 4, label [[FUNC1_EXIT]]
; CHECK-NEXT:    i32 1, label [[FUNC1_EXIT]]
; CHECK-NEXT:    ]
; CHECK:       if.end.i:
; CHECK-NEXT:    br label [[FUNC1_EXIT]]
; CHECK:       func1.exit:
; CHECK-NEXT:    [[RETVAL_0_I:%.*]] = phi i32 [ 9, [[IF_END_I]] ], [ 0, [[WHILE_COND]] ], [ 0, [[WHILE_COND]] ]
; CHECK-NEXT:    [[CALL2]] = tail call signext i32 @func3(i32 signext [[RETVAL_0_I]], i32 signext 1, i32 signext 3)
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[CALL2]], 1
; CHECK-NEXT:    [[ADD]] = add nsw i32 [[CALL2]], 2
; CHECK-NEXT:    br i1 [[CMP]], label [[SELECT_UNFOLD]], label [[WHILE_COND]]
;
entry:
  br label %while.cond

while.cond:                                       ; preds = %func1.exit, %entry
  %month.0 = phi i32 [ undef, %entry ], [ %month.0.be, %func1.exit ]
  switch i32 %month.0, label %if.end.i [
    i32 4, label %func1.exit
    i32 1, label %func1.exit
  ]

if.end.i:                                         ; preds = %while.cond
  br label %func1.exit

func1.exit:                  ; preds = %if.end.i, %while.cond, %while.cond
  %retval.0.i = phi i32 [ 9, %if.end.i ], [ 0, %while.cond ], [ 0, %while.cond ]
  %call2 = tail call signext i32 @func3(i32 signext %retval.0.i, i32 signext 1, i32 signext 3)
  %cmp = icmp slt i32 %call2, 1
  %add = add nsw i32 %call2, 2
  %month.0.be = select i1 %cmp, i32 %add, i32 %call2
  br label %while.cond
}

declare i32 @func3(i32, i32, i32)

