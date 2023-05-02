; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=loop-vectorize -mtriple=riscv64 -mattr=+v -S | FileCheck %s

define void @load_store_factor2_i32(ptr %p) {
; CHECK-LABEL: @load_store_factor2_i32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = shl i64 [[TMP0]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr i32, ptr [[P:%.*]], i64 [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr i32, ptr [[TMP2]], i32 0
; CHECK-NEXT:    [[WIDE_VEC:%.*]] = load <16 x i32>, ptr [[TMP3]], align 4
; CHECK-NEXT:    [[STRIDED_VEC:%.*]] = shufflevector <16 x i32> [[WIDE_VEC]], <16 x i32> poison, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
; CHECK-NEXT:    [[STRIDED_VEC1:%.*]] = shufflevector <16 x i32> [[WIDE_VEC]], <16 x i32> poison, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
; CHECK-NEXT:    [[TMP4:%.*]] = add <8 x i32> [[STRIDED_VEC]], <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
; CHECK-NEXT:    [[TMP5:%.*]] = add i64 [[TMP1]], 1
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr i32, ptr [[P]], i64 [[TMP5]]
; CHECK-NEXT:    [[TMP7:%.*]] = add <8 x i32> [[STRIDED_VEC1]], <i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2>
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr i32, ptr [[TMP6]], i32 -1
; CHECK-NEXT:    [[TMP9:%.*]] = shufflevector <8 x i32> [[TMP4]], <8 x i32> [[TMP7]], <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:    [[INTERLEAVED_VEC:%.*]] = shufflevector <16 x i32> [[TMP9]], <16 x i32> poison, <16 x i32> <i32 0, i32 8, i32 1, i32 9, i32 2, i32 10, i32 3, i32 11, i32 4, i32 12, i32 5, i32 13, i32 6, i32 14, i32 7, i32 15>
; CHECK-NEXT:    store <16 x i32> [[INTERLEAVED_VEC]], ptr [[TMP8]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 8
; CHECK-NEXT:    [[TMP10:%.*]] = icmp eq i64 [[INDEX_NEXT]], 1024
; CHECK-NEXT:    br i1 [[TMP10]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 1024, 1024
; CHECK-NEXT:    br i1 [[CMP_N]], label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 1024, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[NEXTI:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[OFFSET0:%.*]] = shl i64 [[I]], 1
; CHECK-NEXT:    [[Q0:%.*]] = getelementptr i32, ptr [[P]], i64 [[OFFSET0]]
; CHECK-NEXT:    [[X0:%.*]] = load i32, ptr [[Q0]], align 4
; CHECK-NEXT:    [[Y0:%.*]] = add i32 [[X0]], 1
; CHECK-NEXT:    store i32 [[Y0]], ptr [[Q0]], align 4
; CHECK-NEXT:    [[OFFSET1:%.*]] = add i64 [[OFFSET0]], 1
; CHECK-NEXT:    [[Q1:%.*]] = getelementptr i32, ptr [[P]], i64 [[OFFSET1]]
; CHECK-NEXT:    [[X1:%.*]] = load i32, ptr [[Q1]], align 4
; CHECK-NEXT:    [[Y1:%.*]] = add i32 [[X1]], 2
; CHECK-NEXT:    store i32 [[Y1]], ptr [[Q1]], align 4
; CHECK-NEXT:    [[NEXTI]] = add i64 [[I]], 1
; CHECK-NEXT:    [[DONE:%.*]] = icmp eq i64 [[NEXTI]], 1024
; CHECK-NEXT:    br i1 [[DONE]], label [[EXIT]], label [[LOOP]], !llvm.loop [[LOOP3:![0-9]+]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop
loop:
  %i = phi i64 [0, %entry], [%nexti, %loop]

  %offset0 = shl i64 %i, 1
  %q0 = getelementptr i32, ptr %p, i64 %offset0
  %x0 = load i32, ptr %q0
  %y0 = add i32 %x0, 1
  store i32 %y0, ptr %q0

  %offset1 = add i64 %offset0, 1
  %q1 = getelementptr i32, ptr %p, i64 %offset1
  %x1 = load i32, ptr %q1
  %y1 = add i32 %x1, 2
  store i32 %y1, ptr %q1

  %nexti = add i64 %i, 1
  %done = icmp eq i64 %nexti, 1024
  br i1 %done, label %exit, label %loop
exit:
  ret void
}

define void @load_store_factor2_i64(ptr %p) {
; CHECK-LABEL: @load_store_factor2_i64(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[NEXTI:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[OFFSET0:%.*]] = shl i64 [[I]], 1
; CHECK-NEXT:    [[Q0:%.*]] = getelementptr i64, ptr [[P:%.*]], i64 [[OFFSET0]]
; CHECK-NEXT:    [[X0:%.*]] = load i64, ptr [[Q0]], align 4
; CHECK-NEXT:    [[Y0:%.*]] = add i64 [[X0]], 1
; CHECK-NEXT:    store i64 [[Y0]], ptr [[Q0]], align 4
; CHECK-NEXT:    [[OFFSET1:%.*]] = add i64 [[OFFSET0]], 1
; CHECK-NEXT:    [[Q1:%.*]] = getelementptr i64, ptr [[P]], i64 [[OFFSET1]]
; CHECK-NEXT:    [[X1:%.*]] = load i64, ptr [[Q1]], align 4
; CHECK-NEXT:    [[Y1:%.*]] = add i64 [[X1]], 2
; CHECK-NEXT:    store i64 [[Y1]], ptr [[Q1]], align 4
; CHECK-NEXT:    [[NEXTI]] = add i64 [[I]], 1
; CHECK-NEXT:    [[DONE:%.*]] = icmp eq i64 [[NEXTI]], 1024
; CHECK-NEXT:    br i1 [[DONE]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop
loop:
  %i = phi i64 [0, %entry], [%nexti, %loop]

  %offset0 = shl i64 %i, 1
  %q0 = getelementptr i64, ptr %p, i64 %offset0
  %x0 = load i64, ptr %q0
  %y0 = add i64 %x0, 1
  store i64 %y0, ptr %q0

  %offset1 = add i64 %offset0, 1
  %q1 = getelementptr i64, ptr %p, i64 %offset1
  %x1 = load i64, ptr %q1
  %y1 = add i64 %x1, 2
  store i64 %y1, ptr %q1

  %nexti = add i64 %i, 1
  %done = icmp eq i64 %nexti, 1024
  br i1 %done, label %exit, label %loop
exit:
  ret void
}

define void @load_store_factor3_i32(ptr %p) {
; CHECK-LABEL: @load_store_factor3_i32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP1:%.*]] = mul i64 [[TMP0]], 4
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 1024, [[TMP1]]
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP3:%.*]] = mul i64 [[TMP2]], 4
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 1024, [[TMP3]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 1024, [[N_MOD_VF]]
; CHECK-NEXT:    [[TMP4:%.*]] = call <vscale x 4 x i64> @llvm.experimental.stepvector.nxv4i64()
; CHECK-NEXT:    [[TMP5:%.*]] = add <vscale x 4 x i64> [[TMP4]], zeroinitializer
; CHECK-NEXT:    [[TMP6:%.*]] = mul <vscale x 4 x i64> [[TMP5]], shufflevector (<vscale x 4 x i64> insertelement (<vscale x 4 x i64> poison, i64 1, i64 0), <vscale x 4 x i64> poison, <vscale x 4 x i32> zeroinitializer)
; CHECK-NEXT:    [[INDUCTION:%.*]] = add <vscale x 4 x i64> zeroinitializer, [[TMP6]]
; CHECK-NEXT:    [[TMP7:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP8:%.*]] = mul i64 [[TMP7]], 4
; CHECK-NEXT:    [[TMP9:%.*]] = mul i64 1, [[TMP8]]
; CHECK-NEXT:    [[DOTSPLATINSERT:%.*]] = insertelement <vscale x 4 x i64> poison, i64 [[TMP9]], i64 0
; CHECK-NEXT:    [[DOTSPLAT:%.*]] = shufflevector <vscale x 4 x i64> [[DOTSPLATINSERT]], <vscale x 4 x i64> poison, <vscale x 4 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <vscale x 4 x i64> [ [[INDUCTION]], [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP10:%.*]] = mul <vscale x 4 x i64> [[VEC_IND]], shufflevector (<vscale x 4 x i64> insertelement (<vscale x 4 x i64> poison, i64 3, i64 0), <vscale x 4 x i64> poison, <vscale x 4 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP11:%.*]] = getelementptr i32, ptr [[P:%.*]], <vscale x 4 x i64> [[TMP10]]
; CHECK-NEXT:    [[WIDE_MASKED_GATHER:%.*]] = call <vscale x 4 x i32> @llvm.masked.gather.nxv4i32.nxv4p0(<vscale x 4 x ptr> [[TMP11]], i32 4, <vscale x 4 x i1> shufflevector (<vscale x 4 x i1> insertelement (<vscale x 4 x i1> poison, i1 true, i64 0), <vscale x 4 x i1> poison, <vscale x 4 x i32> zeroinitializer), <vscale x 4 x i32> poison)
; CHECK-NEXT:    [[TMP12:%.*]] = add <vscale x 4 x i32> [[WIDE_MASKED_GATHER]], shufflevector (<vscale x 4 x i32> insertelement (<vscale x 4 x i32> poison, i32 1, i64 0), <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer)
; CHECK-NEXT:    call void @llvm.masked.scatter.nxv4i32.nxv4p0(<vscale x 4 x i32> [[TMP12]], <vscale x 4 x ptr> [[TMP11]], i32 4, <vscale x 4 x i1> shufflevector (<vscale x 4 x i1> insertelement (<vscale x 4 x i1> poison, i1 true, i64 0), <vscale x 4 x i1> poison, <vscale x 4 x i32> zeroinitializer))
; CHECK-NEXT:    [[TMP13:%.*]] = add <vscale x 4 x i64> [[TMP10]], shufflevector (<vscale x 4 x i64> insertelement (<vscale x 4 x i64> poison, i64 1, i64 0), <vscale x 4 x i64> poison, <vscale x 4 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP14:%.*]] = getelementptr i32, ptr [[P]], <vscale x 4 x i64> [[TMP13]]
; CHECK-NEXT:    [[WIDE_MASKED_GATHER1:%.*]] = call <vscale x 4 x i32> @llvm.masked.gather.nxv4i32.nxv4p0(<vscale x 4 x ptr> [[TMP14]], i32 4, <vscale x 4 x i1> shufflevector (<vscale x 4 x i1> insertelement (<vscale x 4 x i1> poison, i1 true, i64 0), <vscale x 4 x i1> poison, <vscale x 4 x i32> zeroinitializer), <vscale x 4 x i32> poison)
; CHECK-NEXT:    [[TMP15:%.*]] = add <vscale x 4 x i32> [[WIDE_MASKED_GATHER1]], shufflevector (<vscale x 4 x i32> insertelement (<vscale x 4 x i32> poison, i32 2, i64 0), <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer)
; CHECK-NEXT:    call void @llvm.masked.scatter.nxv4i32.nxv4p0(<vscale x 4 x i32> [[TMP15]], <vscale x 4 x ptr> [[TMP14]], i32 4, <vscale x 4 x i1> shufflevector (<vscale x 4 x i1> insertelement (<vscale x 4 x i1> poison, i1 true, i64 0), <vscale x 4 x i1> poison, <vscale x 4 x i32> zeroinitializer))
; CHECK-NEXT:    [[TMP16:%.*]] = add <vscale x 4 x i64> [[TMP13]], shufflevector (<vscale x 4 x i64> insertelement (<vscale x 4 x i64> poison, i64 1, i64 0), <vscale x 4 x i64> poison, <vscale x 4 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP17:%.*]] = getelementptr i32, ptr [[P]], <vscale x 4 x i64> [[TMP16]]
; CHECK-NEXT:    [[WIDE_MASKED_GATHER2:%.*]] = call <vscale x 4 x i32> @llvm.masked.gather.nxv4i32.nxv4p0(<vscale x 4 x ptr> [[TMP17]], i32 4, <vscale x 4 x i1> shufflevector (<vscale x 4 x i1> insertelement (<vscale x 4 x i1> poison, i1 true, i64 0), <vscale x 4 x i1> poison, <vscale x 4 x i32> zeroinitializer), <vscale x 4 x i32> poison)
; CHECK-NEXT:    [[TMP18:%.*]] = add <vscale x 4 x i32> [[WIDE_MASKED_GATHER2]], shufflevector (<vscale x 4 x i32> insertelement (<vscale x 4 x i32> poison, i32 3, i64 0), <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer)
; CHECK-NEXT:    call void @llvm.masked.scatter.nxv4i32.nxv4p0(<vscale x 4 x i32> [[TMP18]], <vscale x 4 x ptr> [[TMP17]], i32 4, <vscale x 4 x i1> shufflevector (<vscale x 4 x i1> insertelement (<vscale x 4 x i1> poison, i1 true, i64 0), <vscale x 4 x i1> poison, <vscale x 4 x i32> zeroinitializer))
; CHECK-NEXT:    [[TMP19:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP20:%.*]] = mul i64 [[TMP19]], 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], [[TMP20]]
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <vscale x 4 x i64> [[VEC_IND]], [[DOTSPLAT]]
; CHECK-NEXT:    [[TMP21:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP21]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP4:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 1024, [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[NEXTI:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[OFFSET0:%.*]] = mul i64 [[I]], 3
; CHECK-NEXT:    [[Q0:%.*]] = getelementptr i32, ptr [[P]], i64 [[OFFSET0]]
; CHECK-NEXT:    [[X0:%.*]] = load i32, ptr [[Q0]], align 4
; CHECK-NEXT:    [[Y0:%.*]] = add i32 [[X0]], 1
; CHECK-NEXT:    store i32 [[Y0]], ptr [[Q0]], align 4
; CHECK-NEXT:    [[OFFSET1:%.*]] = add i64 [[OFFSET0]], 1
; CHECK-NEXT:    [[Q1:%.*]] = getelementptr i32, ptr [[P]], i64 [[OFFSET1]]
; CHECK-NEXT:    [[X1:%.*]] = load i32, ptr [[Q1]], align 4
; CHECK-NEXT:    [[Y1:%.*]] = add i32 [[X1]], 2
; CHECK-NEXT:    store i32 [[Y1]], ptr [[Q1]], align 4
; CHECK-NEXT:    [[OFFSET2:%.*]] = add i64 [[OFFSET1]], 1
; CHECK-NEXT:    [[Q2:%.*]] = getelementptr i32, ptr [[P]], i64 [[OFFSET2]]
; CHECK-NEXT:    [[X2:%.*]] = load i32, ptr [[Q2]], align 4
; CHECK-NEXT:    [[Y2:%.*]] = add i32 [[X2]], 3
; CHECK-NEXT:    store i32 [[Y2]], ptr [[Q2]], align 4
; CHECK-NEXT:    [[NEXTI]] = add i64 [[I]], 1
; CHECK-NEXT:    [[DONE:%.*]] = icmp eq i64 [[NEXTI]], 1024
; CHECK-NEXT:    br i1 [[DONE]], label [[EXIT]], label [[LOOP]], !llvm.loop [[LOOP5:![0-9]+]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop
loop:
  %i = phi i64 [0, %entry], [%nexti, %loop]

  %offset0 = mul i64 %i, 3
  %q0 = getelementptr i32, ptr %p, i64 %offset0
  %x0 = load i32, ptr %q0
  %y0 = add i32 %x0, 1
  store i32 %y0, ptr %q0

  %offset1 = add i64 %offset0, 1
  %q1 = getelementptr i32, ptr %p, i64 %offset1
  %x1 = load i32, ptr %q1
  %y1 = add i32 %x1, 2
  store i32 %y1, ptr %q1

  %offset2 = add i64 %offset1, 1
  %q2 = getelementptr i32, ptr %p, i64 %offset2
  %x2 = load i32, ptr %q2
  %y2 = add i32 %x2, 3
  store i32 %y2, ptr %q2

  %nexti = add i64 %i, 1
  %done = icmp eq i64 %nexti, 1024
  br i1 %done, label %exit, label %loop
exit:
  ret void
}

define void @load_store_factor3_i64(ptr %p) {
; CHECK-LABEL: @load_store_factor3_i64(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[NEXTI:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[OFFSET0:%.*]] = mul i64 [[I]], 3
; CHECK-NEXT:    [[Q0:%.*]] = getelementptr i64, ptr [[P:%.*]], i64 [[OFFSET0]]
; CHECK-NEXT:    [[X0:%.*]] = load i64, ptr [[Q0]], align 4
; CHECK-NEXT:    [[Y0:%.*]] = add i64 [[X0]], 1
; CHECK-NEXT:    store i64 [[Y0]], ptr [[Q0]], align 4
; CHECK-NEXT:    [[OFFSET1:%.*]] = add i64 [[OFFSET0]], 1
; CHECK-NEXT:    [[Q1:%.*]] = getelementptr i64, ptr [[P]], i64 [[OFFSET1]]
; CHECK-NEXT:    [[X1:%.*]] = load i64, ptr [[Q1]], align 4
; CHECK-NEXT:    [[Y1:%.*]] = add i64 [[X1]], 2
; CHECK-NEXT:    store i64 [[Y1]], ptr [[Q1]], align 4
; CHECK-NEXT:    [[OFFSET2:%.*]] = add i64 [[OFFSET1]], 1
; CHECK-NEXT:    [[Q2:%.*]] = getelementptr i64, ptr [[P]], i64 [[OFFSET2]]
; CHECK-NEXT:    [[X2:%.*]] = load i64, ptr [[Q2]], align 4
; CHECK-NEXT:    [[Y2:%.*]] = add i64 [[X2]], 3
; CHECK-NEXT:    store i64 [[Y2]], ptr [[Q2]], align 4
; CHECK-NEXT:    [[NEXTI]] = add i64 [[I]], 1
; CHECK-NEXT:    [[DONE:%.*]] = icmp eq i64 [[NEXTI]], 1024
; CHECK-NEXT:    br i1 [[DONE]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop
loop:
  %i = phi i64 [0, %entry], [%nexti, %loop]

  %offset0 = mul i64 %i, 3
  %q0 = getelementptr i64, ptr %p, i64 %offset0
  %x0 = load i64, ptr %q0
  %y0 = add i64 %x0, 1
  store i64 %y0, ptr %q0

  %offset1 = add i64 %offset0, 1
  %q1 = getelementptr i64, ptr %p, i64 %offset1
  %x1 = load i64, ptr %q1
  %y1 = add i64 %x1, 2
  store i64 %y1, ptr %q1

  %offset2 = add i64 %offset1, 1
  %q2 = getelementptr i64, ptr %p, i64 %offset2
  %x2 = load i64, ptr %q2
  %y2 = add i64 %x2, 3
  store i64 %y2, ptr %q2

  %nexti = add i64 %i, 1
  %done = icmp eq i64 %nexti, 1024
  br i1 %done, label %exit, label %loop
exit:
  ret void
}

define void @load_store_factor8(ptr %p) {
; CHECK-LABEL: @load_store_factor8(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[NEXTI:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[OFFSET0:%.*]] = shl i64 [[I]], 3
; CHECK-NEXT:    [[Q0:%.*]] = getelementptr i64, ptr [[P:%.*]], i64 [[OFFSET0]]
; CHECK-NEXT:    [[X0:%.*]] = load i64, ptr [[Q0]], align 4
; CHECK-NEXT:    [[Y0:%.*]] = add i64 [[X0]], 1
; CHECK-NEXT:    store i64 [[Y0]], ptr [[Q0]], align 4
; CHECK-NEXT:    [[OFFSET1:%.*]] = add i64 [[OFFSET0]], 1
; CHECK-NEXT:    [[Q1:%.*]] = getelementptr i64, ptr [[P]], i64 [[OFFSET1]]
; CHECK-NEXT:    [[X1:%.*]] = load i64, ptr [[Q1]], align 4
; CHECK-NEXT:    [[Y1:%.*]] = add i64 [[X1]], 2
; CHECK-NEXT:    store i64 [[Y1]], ptr [[Q1]], align 4
; CHECK-NEXT:    [[OFFSET2:%.*]] = add i64 [[OFFSET1]], 1
; CHECK-NEXT:    [[Q2:%.*]] = getelementptr i64, ptr [[P]], i64 [[OFFSET2]]
; CHECK-NEXT:    [[X2:%.*]] = load i64, ptr [[Q2]], align 4
; CHECK-NEXT:    [[Y2:%.*]] = add i64 [[X2]], 3
; CHECK-NEXT:    store i64 [[Y2]], ptr [[Q2]], align 4
; CHECK-NEXT:    [[OFFSET3:%.*]] = add i64 [[OFFSET2]], 1
; CHECK-NEXT:    [[Q3:%.*]] = getelementptr i64, ptr [[P]], i64 [[OFFSET3]]
; CHECK-NEXT:    [[X3:%.*]] = load i64, ptr [[Q3]], align 4
; CHECK-NEXT:    [[Y3:%.*]] = add i64 [[X3]], 4
; CHECK-NEXT:    store i64 [[Y3]], ptr [[Q3]], align 4
; CHECK-NEXT:    [[OFFSET4:%.*]] = add i64 [[OFFSET3]], 1
; CHECK-NEXT:    [[Q4:%.*]] = getelementptr i64, ptr [[P]], i64 [[OFFSET4]]
; CHECK-NEXT:    [[X4:%.*]] = load i64, ptr [[Q4]], align 4
; CHECK-NEXT:    [[Y4:%.*]] = add i64 [[X4]], 5
; CHECK-NEXT:    store i64 [[Y4]], ptr [[Q4]], align 4
; CHECK-NEXT:    [[OFFSET5:%.*]] = add i64 [[OFFSET4]], 1
; CHECK-NEXT:    [[Q5:%.*]] = getelementptr i64, ptr [[P]], i64 [[OFFSET5]]
; CHECK-NEXT:    [[X5:%.*]] = load i64, ptr [[Q5]], align 4
; CHECK-NEXT:    [[Y5:%.*]] = add i64 [[X5]], 6
; CHECK-NEXT:    store i64 [[Y5]], ptr [[Q5]], align 4
; CHECK-NEXT:    [[OFFSET6:%.*]] = add i64 [[OFFSET5]], 1
; CHECK-NEXT:    [[Q6:%.*]] = getelementptr i64, ptr [[P]], i64 [[OFFSET6]]
; CHECK-NEXT:    [[X6:%.*]] = load i64, ptr [[Q6]], align 4
; CHECK-NEXT:    [[Y6:%.*]] = add i64 [[X6]], 7
; CHECK-NEXT:    store i64 [[Y6]], ptr [[Q6]], align 4
; CHECK-NEXT:    [[OFFSET7:%.*]] = add i64 [[OFFSET6]], 1
; CHECK-NEXT:    [[Q7:%.*]] = getelementptr i64, ptr [[P]], i64 [[OFFSET7]]
; CHECK-NEXT:    [[X7:%.*]] = load i64, ptr [[Q7]], align 4
; CHECK-NEXT:    [[Y7:%.*]] = add i64 [[X7]], 8
; CHECK-NEXT:    store i64 [[Y7]], ptr [[Q7]], align 4
; CHECK-NEXT:    [[NEXTI]] = add i64 [[I]], 1
; CHECK-NEXT:    [[DONE:%.*]] = icmp eq i64 [[NEXTI]], 1024
; CHECK-NEXT:    br i1 [[DONE]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop
loop:
  %i = phi i64 [0, %entry], [%nexti, %loop]

  %offset0 = shl i64 %i, 3
  %q0 = getelementptr i64, ptr %p, i64 %offset0
  %x0 = load i64, ptr %q0
  %y0 = add i64 %x0, 1
  store i64 %y0, ptr %q0

  %offset1 = add i64 %offset0, 1
  %q1 = getelementptr i64, ptr %p, i64 %offset1
  %x1 = load i64, ptr %q1
  %y1 = add i64 %x1, 2
  store i64 %y1, ptr %q1

  %offset2 = add i64 %offset1, 1
  %q2 = getelementptr i64, ptr %p, i64 %offset2
  %x2 = load i64, ptr %q2
  %y2 = add i64 %x2, 3
  store i64 %y2, ptr %q2

  %offset3 = add i64 %offset2, 1
  %q3 = getelementptr i64, ptr %p, i64 %offset3
  %x3 = load i64, ptr %q3
  %y3 = add i64 %x3, 4
  store i64 %y3, ptr %q3

  %offset4 = add i64 %offset3, 1
  %q4 = getelementptr i64, ptr %p, i64 %offset4
  %x4 = load i64, ptr %q4
  %y4 = add i64 %x4, 5
  store i64 %y4, ptr %q4

  %offset5 = add i64 %offset4, 1
  %q5 = getelementptr i64, ptr %p, i64 %offset5
  %x5 = load i64, ptr %q5
  %y5 = add i64 %x5, 6
  store i64 %y5, ptr %q5

  %offset6 = add i64 %offset5, 1
  %q6 = getelementptr i64, ptr %p, i64 %offset6
  %x6 = load i64, ptr %q6
  %y6 = add i64 %x6, 7
  store i64 %y6, ptr %q6

  %offset7 = add i64 %offset6, 1
  %q7 = getelementptr i64, ptr %p, i64 %offset7
  %x7 = load i64, ptr %q7
  %y7 = add i64 %x7, 8
  store i64 %y7, ptr %q7

  %nexti = add i64 %i, 1
  %done = icmp eq i64 %nexti, 1024
  br i1 %done, label %exit, label %loop
exit:
  ret void
}

define void @combine_load_factor2_i32(ptr noalias %p, ptr noalias %q) {
; CHECK-LABEL: @combine_load_factor2_i32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = add i64 [[INDEX]], 8
; CHECK-NEXT:    [[TMP2:%.*]] = shl i64 [[TMP0]], 1
; CHECK-NEXT:    [[TMP3:%.*]] = shl i64 [[TMP1]], 1
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr i32, ptr [[P:%.*]], i64 [[TMP2]]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr i32, ptr [[P]], i64 [[TMP3]]
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr i32, ptr [[TMP4]], i32 0
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr i32, ptr [[TMP5]], i32 0
; CHECK-NEXT:    [[WIDE_VEC:%.*]] = load <16 x i32>, ptr [[TMP6]], align 4
; CHECK-NEXT:    [[WIDE_VEC1:%.*]] = load <16 x i32>, ptr [[TMP7]], align 4
; CHECK-NEXT:    [[STRIDED_VEC:%.*]] = shufflevector <16 x i32> [[WIDE_VEC]], <16 x i32> poison, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
; CHECK-NEXT:    [[STRIDED_VEC2:%.*]] = shufflevector <16 x i32> [[WIDE_VEC1]], <16 x i32> poison, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
; CHECK-NEXT:    [[STRIDED_VEC3:%.*]] = shufflevector <16 x i32> [[WIDE_VEC]], <16 x i32> poison, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
; CHECK-NEXT:    [[STRIDED_VEC4:%.*]] = shufflevector <16 x i32> [[WIDE_VEC1]], <16 x i32> poison, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
; CHECK-NEXT:    [[TMP8:%.*]] = add <8 x i32> [[STRIDED_VEC]], [[STRIDED_VEC3]]
; CHECK-NEXT:    [[TMP9:%.*]] = add <8 x i32> [[STRIDED_VEC2]], [[STRIDED_VEC4]]
; CHECK-NEXT:    [[TMP10:%.*]] = getelementptr i32, ptr [[Q:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP11:%.*]] = getelementptr i32, ptr [[Q]], i64 [[TMP1]]
; CHECK-NEXT:    [[TMP12:%.*]] = getelementptr i32, ptr [[TMP10]], i32 0
; CHECK-NEXT:    store <8 x i32> [[TMP8]], ptr [[TMP12]], align 4
; CHECK-NEXT:    [[TMP13:%.*]] = getelementptr i32, ptr [[TMP10]], i32 8
; CHECK-NEXT:    store <8 x i32> [[TMP9]], ptr [[TMP13]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 16
; CHECK-NEXT:    [[TMP14:%.*]] = icmp eq i64 [[INDEX_NEXT]], 1024
; CHECK-NEXT:    br i1 [[TMP14]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP6:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 1024, 1024
; CHECK-NEXT:    br i1 [[CMP_N]], label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 1024, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[NEXTI:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[OFFSET0:%.*]] = shl i64 [[I]], 1
; CHECK-NEXT:    [[Q0:%.*]] = getelementptr i32, ptr [[P]], i64 [[OFFSET0]]
; CHECK-NEXT:    [[X0:%.*]] = load i32, ptr [[Q0]], align 4
; CHECK-NEXT:    [[OFFSET1:%.*]] = add i64 [[OFFSET0]], 1
; CHECK-NEXT:    [[Q1:%.*]] = getelementptr i32, ptr [[P]], i64 [[OFFSET1]]
; CHECK-NEXT:    [[X1:%.*]] = load i32, ptr [[Q1]], align 4
; CHECK-NEXT:    [[RES:%.*]] = add i32 [[X0]], [[X1]]
; CHECK-NEXT:    [[DST:%.*]] = getelementptr i32, ptr [[Q]], i64 [[I]]
; CHECK-NEXT:    store i32 [[RES]], ptr [[DST]], align 4
; CHECK-NEXT:    [[NEXTI]] = add i64 [[I]], 1
; CHECK-NEXT:    [[DONE:%.*]] = icmp eq i64 [[NEXTI]], 1024
; CHECK-NEXT:    br i1 [[DONE]], label [[EXIT]], label [[LOOP]], !llvm.loop [[LOOP7:![0-9]+]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop
loop:
  %i = phi i64 [0, %entry], [%nexti, %loop]

  %offset0 = shl i64 %i, 1
  %q0 = getelementptr i32, ptr %p, i64 %offset0
  %x0 = load i32, ptr %q0

  %offset1 = add i64 %offset0, 1
  %q1 = getelementptr i32, ptr %p, i64 %offset1
  %x1 = load i32, ptr %q1

  %res = add i32 %x0, %x1

  %dst = getelementptr i32, ptr %q, i64 %i
  store i32 %res, ptr %dst

  %nexti = add i64 %i, 1
  %done = icmp eq i64 %nexti, 1024
  br i1 %done, label %exit, label %loop
exit:
  ret void
}

define void @combine_load_factor2_i64(ptr noalias %p, ptr noalias %q) {
; CHECK-LABEL: @combine_load_factor2_i64(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = shl i64 [[TMP0]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr i64, ptr [[P:%.*]], i64 [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr i64, ptr [[TMP2]], i32 0
; CHECK-NEXT:    [[WIDE_VEC:%.*]] = load <8 x i64>, ptr [[TMP3]], align 4
; CHECK-NEXT:    [[STRIDED_VEC:%.*]] = shufflevector <8 x i64> [[WIDE_VEC]], <8 x i64> poison, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
; CHECK-NEXT:    [[STRIDED_VEC1:%.*]] = shufflevector <8 x i64> [[WIDE_VEC]], <8 x i64> poison, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
; CHECK-NEXT:    [[TMP4:%.*]] = add <4 x i64> [[STRIDED_VEC]], [[STRIDED_VEC1]]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr i64, ptr [[Q:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr i64, ptr [[TMP5]], i32 0
; CHECK-NEXT:    store <4 x i64> [[TMP4]], ptr [[TMP6]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 4
; CHECK-NEXT:    [[TMP7:%.*]] = icmp eq i64 [[INDEX_NEXT]], 1024
; CHECK-NEXT:    br i1 [[TMP7]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP8:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 1024, 1024
; CHECK-NEXT:    br i1 [[CMP_N]], label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 1024, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[NEXTI:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[OFFSET0:%.*]] = shl i64 [[I]], 1
; CHECK-NEXT:    [[Q0:%.*]] = getelementptr i64, ptr [[P]], i64 [[OFFSET0]]
; CHECK-NEXT:    [[X0:%.*]] = load i64, ptr [[Q0]], align 4
; CHECK-NEXT:    [[OFFSET1:%.*]] = add i64 [[OFFSET0]], 1
; CHECK-NEXT:    [[Q1:%.*]] = getelementptr i64, ptr [[P]], i64 [[OFFSET1]]
; CHECK-NEXT:    [[X1:%.*]] = load i64, ptr [[Q1]], align 4
; CHECK-NEXT:    [[RES:%.*]] = add i64 [[X0]], [[X1]]
; CHECK-NEXT:    [[DST:%.*]] = getelementptr i64, ptr [[Q]], i64 [[I]]
; CHECK-NEXT:    store i64 [[RES]], ptr [[DST]], align 4
; CHECK-NEXT:    [[NEXTI]] = add i64 [[I]], 1
; CHECK-NEXT:    [[DONE:%.*]] = icmp eq i64 [[NEXTI]], 1024
; CHECK-NEXT:    br i1 [[DONE]], label [[EXIT]], label [[LOOP]], !llvm.loop [[LOOP9:![0-9]+]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop
loop:
  %i = phi i64 [0, %entry], [%nexti, %loop]

  %offset0 = shl i64 %i, 1
  %q0 = getelementptr i64, ptr %p, i64 %offset0
  %x0 = load i64, ptr %q0

  %offset1 = add i64 %offset0, 1
  %q1 = getelementptr i64, ptr %p, i64 %offset1
  %x1 = load i64, ptr %q1

  %res = add i64 %x0, %x1

  %dst = getelementptr i64, ptr %q, i64 %i
  store i64 %res, ptr %dst

  %nexti = add i64 %i, 1
  %done = icmp eq i64 %nexti, 1024
  br i1 %done, label %exit, label %loop
exit:
  ret void
}
