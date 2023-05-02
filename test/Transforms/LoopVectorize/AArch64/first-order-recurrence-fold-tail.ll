; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=loop-vectorize -force-vector-width=4 -force-vector-interleave=1 -prefer-predicate-over-epilogue=predicate-else-scalar-epilogue -mcpu=neoverse-v1 -S %s | FileCheck %s

target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

define i32 @test_phi_iterator_invalidation(ptr %A, ptr noalias %B) {
; CHECK-LABEL: @test_phi_iterator_invalidation(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[ACTIVE_LANE_MASK_ENTRY:%.*]] = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i64(i64 0, i64 1002)
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[PRED_LOAD_CONTINUE6:%.*]] ]
; CHECK-NEXT:    [[ACTIVE_LANE_MASK:%.*]] = phi <4 x i1> [ [[ACTIVE_LANE_MASK_ENTRY]], [[VECTOR_PH]] ], [ [[ACTIVE_LANE_MASK_NEXT:%.*]], [[PRED_LOAD_CONTINUE6]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <4 x i64> [ <i64 0, i64 1, i64 2, i64 3>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[PRED_LOAD_CONTINUE6]] ]
; CHECK-NEXT:    [[VECTOR_RECUR:%.*]] = phi <4 x i16> [ <i16 poison, i16 poison, i16 poison, i16 0>, [[VECTOR_PH]] ], [ [[TMP24:%.*]], [[PRED_LOAD_CONTINUE6]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add <4 x i64> [[VEC_IND]], <i64 1, i64 1, i64 1, i64 1>
; CHECK-NEXT:    [[TMP1:%.*]] = extractelement <4 x i1> [[ACTIVE_LANE_MASK]], i32 0
; CHECK-NEXT:    br i1 [[TMP1]], label [[PRED_LOAD_IF:%.*]], label [[PRED_LOAD_CONTINUE:%.*]]
; CHECK:       pred.load.if:
; CHECK-NEXT:    [[TMP2:%.*]] = extractelement <4 x i64> [[TMP0]], i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr i32, ptr [[A:%.*]], i64 [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = load i16, ptr [[TMP3]], align 2
; CHECK-NEXT:    [[TMP5:%.*]] = insertelement <4 x i16> poison, i16 [[TMP4]], i32 0
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE]]
; CHECK:       pred.load.continue:
; CHECK-NEXT:    [[TMP6:%.*]] = phi <4 x i16> [ poison, [[VECTOR_BODY]] ], [ [[TMP5]], [[PRED_LOAD_IF]] ]
; CHECK-NEXT:    [[TMP7:%.*]] = extractelement <4 x i1> [[ACTIVE_LANE_MASK]], i32 1
; CHECK-NEXT:    br i1 [[TMP7]], label [[PRED_LOAD_IF1:%.*]], label [[PRED_LOAD_CONTINUE2:%.*]]
; CHECK:       pred.load.if1:
; CHECK-NEXT:    [[TMP8:%.*]] = extractelement <4 x i64> [[TMP0]], i32 1
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr i32, ptr [[A]], i64 [[TMP8]]
; CHECK-NEXT:    [[TMP10:%.*]] = load i16, ptr [[TMP9]], align 2
; CHECK-NEXT:    [[TMP11:%.*]] = insertelement <4 x i16> [[TMP6]], i16 [[TMP10]], i32 1
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE2]]
; CHECK:       pred.load.continue2:
; CHECK-NEXT:    [[TMP12:%.*]] = phi <4 x i16> [ [[TMP6]], [[PRED_LOAD_CONTINUE]] ], [ [[TMP11]], [[PRED_LOAD_IF1]] ]
; CHECK-NEXT:    [[TMP13:%.*]] = extractelement <4 x i1> [[ACTIVE_LANE_MASK]], i32 2
; CHECK-NEXT:    br i1 [[TMP13]], label [[PRED_LOAD_IF3:%.*]], label [[PRED_LOAD_CONTINUE4:%.*]]
; CHECK:       pred.load.if3:
; CHECK-NEXT:    [[TMP14:%.*]] = extractelement <4 x i64> [[TMP0]], i32 2
; CHECK-NEXT:    [[TMP15:%.*]] = getelementptr i32, ptr [[A]], i64 [[TMP14]]
; CHECK-NEXT:    [[TMP16:%.*]] = load i16, ptr [[TMP15]], align 2
; CHECK-NEXT:    [[TMP17:%.*]] = insertelement <4 x i16> [[TMP12]], i16 [[TMP16]], i32 2
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE4]]
; CHECK:       pred.load.continue4:
; CHECK-NEXT:    [[TMP18:%.*]] = phi <4 x i16> [ [[TMP12]], [[PRED_LOAD_CONTINUE2]] ], [ [[TMP17]], [[PRED_LOAD_IF3]] ]
; CHECK-NEXT:    [[TMP19:%.*]] = extractelement <4 x i1> [[ACTIVE_LANE_MASK]], i32 3
; CHECK-NEXT:    br i1 [[TMP19]], label [[PRED_LOAD_IF5:%.*]], label [[PRED_LOAD_CONTINUE6]]
; CHECK:       pred.load.if5:
; CHECK-NEXT:    [[TMP20:%.*]] = extractelement <4 x i64> [[TMP0]], i32 3
; CHECK-NEXT:    [[TMP21:%.*]] = getelementptr i32, ptr [[A]], i64 [[TMP20]]
; CHECK-NEXT:    [[TMP22:%.*]] = load i16, ptr [[TMP21]], align 2
; CHECK-NEXT:    [[TMP23:%.*]] = insertelement <4 x i16> [[TMP18]], i16 [[TMP22]], i32 3
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE6]]
; CHECK:       pred.load.continue6:
; CHECK-NEXT:    [[TMP24]] = phi <4 x i16> [ [[TMP18]], [[PRED_LOAD_CONTINUE4]] ], [ [[TMP23]], [[PRED_LOAD_IF5]] ]
; CHECK-NEXT:    [[TMP25:%.*]] = shufflevector <4 x i16> [[VECTOR_RECUR]], <4 x i16> [[TMP24]], <4 x i32> <i32 3, i32 4, i32 5, i32 6>
; CHECK-NEXT:    [[TMP26:%.*]] = sext <4 x i16> [[TMP25]] to <4 x i32>
; CHECK-NEXT:    [[TMP27:%.*]] = extractelement <4 x i64> [[TMP0]], i32 0
; CHECK-NEXT:    [[TMP28:%.*]] = getelementptr i32, ptr [[B:%.*]], i64 [[TMP27]]
; CHECK-NEXT:    [[TMP29:%.*]] = getelementptr i32, ptr [[TMP28]], i32 0
; CHECK-NEXT:    call void @llvm.masked.store.v4i32.p0(<4 x i32> [[TMP26]], ptr [[TMP29]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK]])
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 4
; CHECK-NEXT:    [[ACTIVE_LANE_MASK_NEXT]] = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i64(i64 [[INDEX_NEXT]], i64 1002)
; CHECK-NEXT:    [[TMP30:%.*]] = xor <4 x i1> [[ACTIVE_LANE_MASK_NEXT]], <i1 true, i1 true, i1 true, i1 true>
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <4 x i64> [[VEC_IND]], <i64 4, i64 4, i64 4, i64 4>
; CHECK-NEXT:    [[TMP31:%.*]] = extractelement <4 x i1> [[TMP30]], i32 0
; CHECK-NEXT:    br i1 [[TMP31]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[VECTOR_RECUR_EXTRACT:%.*]] = extractelement <4 x i16> [[TMP24]], i32 3
; CHECK-NEXT:    [[VECTOR_RECUR_EXTRACT_FOR_PHI:%.*]] = extractelement <4 x i16> [[TMP24]], i32 2
; CHECK-NEXT:    br i1 true, label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[SCALAR_RECUR_INIT:%.*]] = phi i16 [ 0, [[ENTRY:%.*]] ], [ [[VECTOR_RECUR_EXTRACT]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 1004, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY]] ]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[SCALAR_RECUR:%.*]] = phi i16 [ [[SCALAR_RECUR_INIT]], [[SCALAR_PH]] ], [ [[FOR_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[SEXT:%.*]] = sext i16 [[SCALAR_RECUR]] to i32
; CHECK-NEXT:    [[IV_NEXT]] = add i64 [[IV]], 1
; CHECK-NEXT:    [[GEP_A:%.*]] = getelementptr i32, ptr [[A]], i64 [[IV_NEXT]]
; CHECK-NEXT:    [[FOR_NEXT]] = load i16, ptr [[GEP_A]], align 2
; CHECK-NEXT:    [[GEP_B:%.*]] = getelementptr i32, ptr [[B]], i64 [[IV_NEXT]]
; CHECK-NEXT:    store i32 [[SEXT]], ptr [[GEP_B]], align 4
; CHECK-NEXT:    [[EC:%.*]] = icmp eq i64 [[IV]], 1001
; CHECK-NEXT:    br i1 [[EC]], label [[EXIT]], label [[LOOP]], !llvm.loop [[LOOP3:![0-9]+]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 0
;
entry:
  br label %loop

loop:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop ]
  %for = phi i16 [ 0, %entry ], [ %for.next, %loop ]
  %sext = sext i16 %for to i32
  %iv.next = add i64 %iv, 1
  %gep.A = getelementptr i32, ptr %A, i64 %iv.next
  %for.next = load i16, ptr %gep.A, align 2
  %gep.B = getelementptr i32, ptr %B, i64 %iv.next
  store i32 %sext, ptr %gep.B
  %ec = icmp eq i64 %iv, 1001
  br i1 %ec, label %exit, label %loop

exit:
  ret i32 0
}
