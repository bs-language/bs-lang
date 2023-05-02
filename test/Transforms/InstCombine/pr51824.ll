; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

; OSS-Fuzz: https://bugs.chromium.org/p/oss-fuzz/issues/detail?id=38057
define void @PR51824(<4 x i16> %idxs, ptr %ptr, i1 %c1, ptr %ptr2) {
; CHECK-LABEL: @PR51824(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[BB:%.*]]
; CHECK:       BB:
; CHECK-NEXT:    br i1 [[C1:%.*]], label [[BB]], label [[BB1:%.*]]
; CHECK:       BB1:
; CHECK-NEXT:    ret void
;
entry:
  %C7 = icmp sgt i1 false, true
  %B2 = lshr i16 -32768, 0
  %C1 = icmp uge i16 %B2, %B2
  %E9 = extractelement <4 x i16> zeroinitializer, i16 %B2
  %I2 = insertelement <4 x i16> poison, i16 %E9, i16 0
  %i = sext <4 x i16> %I2 to <4 x i32>
  %i1 = getelementptr inbounds i64, ptr null, <4 x i32> %i
  %i2 = ptrtoint <4 x ptr> %i1 to <4 x i32>
  %E2 = extractelement <4 x i32> %i2, i16 0
  br label %BB

BB:                                               ; preds = %BB, %entry
  %A15 = alloca <4 x i32>, align 16
  %L2 = load <4 x i32>, ptr %A15, align 16
  %G1 = getelementptr i64, ptr null, i32 %E2
  %i3 = getelementptr inbounds i64, ptr %G1, <4 x i16> %idxs
  %i4 = ptrtoint <4 x ptr> %i3 to <4 x i32>
  %E22 = extractelement <4 x i32> %L2, i1 false
  %E8 = extractelement <4 x i32> %i4, i1 false
  %I10 = insertelement <4 x i32> undef, i32 undef, i32 %E8
  %I19 = insertelement <4 x i32> %I10, i32 %E22, i16 0
  %S7 = shufflevector <4 x i32> %I19, <4 x i32> %L2, <4 x i32> poison
  %I8 = insertelement <4 x i32> %I19, i32 0, i1 %C1
  %E10 = extractelement <4 x i32> %I8, i1 poison
  store i32 %E10, ptr %ptr, align 4
  br i1 %c1, label %BB, label %BB1

BB1:                                              ; preds = %BB
  %S8 = shufflevector <4 x i32> %I10, <4 x i32> %S7, <4 x i32> undef
  store <4 x i32> %S8, ptr %ptr2, align 16
  ret void
}
