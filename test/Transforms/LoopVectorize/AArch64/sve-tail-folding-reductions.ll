; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -opaque-pointers=0 -S -hints-allow-reordering=false -passes=loop-vectorize -prefer-predicate-over-epilogue=predicate-else-scalar-epilogue \
; RUN:   < %s | FileCheck %s --check-prefix=CHECK
; RUN: opt -opaque-pointers=0 -S -hints-allow-reordering=false -passes=loop-vectorize -prefer-predicate-over-epilogue=predicate-else-scalar-epilogue \
; RUN:   -prefer-inloop-reductions < %s | FileCheck %s --check-prefix=CHECK-IN-LOOP

target triple = "aarch64-unknown-linux-gnu"

define i32 @add_reduction_i32(i32* %ptr, i64 %n) #0 {
; CHECK-LABEL: @add_reduction_i32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[UMAX:%.*]] = call i64 @llvm.umax.i64(i64 [[N:%.*]], i64 1)
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[TMP0:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP1:%.*]] = mul i64 [[TMP0]], 4
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP3:%.*]] = mul i64 [[TMP2]], 4
; CHECK-NEXT:    [[TMP4:%.*]] = sub i64 [[TMP3]], 1
; CHECK-NEXT:    [[N_RND_UP:%.*]] = add i64 [[UMAX]], [[TMP4]]
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[N_RND_UP]], [[TMP1]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[N_RND_UP]], [[N_MOD_VF]]
; CHECK-NEXT:    [[TMP5:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP6:%.*]] = mul i64 [[TMP5]], 4
; CHECK-NEXT:    [[TMP7:%.*]] = sub i64 [[UMAX]], [[TMP6]]
; CHECK-NEXT:    [[TMP8:%.*]] = icmp ugt i64 [[UMAX]], [[TMP6]]
; CHECK-NEXT:    [[TMP9:%.*]] = select i1 [[TMP8]], i64 [[TMP7]], i64 0
; CHECK-NEXT:    [[ACTIVE_LANE_MASK_ENTRY:%.*]] = call <vscale x 4 x i1> @llvm.get.active.lane.mask.nxv4i1.i64(i64 0, i64 [[UMAX]])
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX1:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT2:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[ACTIVE_LANE_MASK:%.*]] = phi <vscale x 4 x i1> [ [[ACTIVE_LANE_MASK_ENTRY]], [[VECTOR_PH]] ], [ [[ACTIVE_LANE_MASK_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_PHI:%.*]] = phi <vscale x 4 x i32> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP15:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP10:%.*]] = add i64 [[INDEX1]], 0
; CHECK-NEXT:    [[TMP11:%.*]] = getelementptr i32, i32* [[PTR:%.*]], i64 [[TMP10]]
; CHECK-NEXT:    [[TMP12:%.*]] = getelementptr i32, i32* [[TMP11]], i32 0
; CHECK-NEXT:    [[TMP13:%.*]] = bitcast i32* [[TMP12]] to <vscale x 4 x i32>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <vscale x 4 x i32> @llvm.masked.load.nxv4i32.p0nxv4i32(<vscale x 4 x i32>* [[TMP13]], i32 4, <vscale x 4 x i1> [[ACTIVE_LANE_MASK]], <vscale x 4 x i32> poison)
; CHECK-NEXT:    [[TMP14:%.*]] = add <vscale x 4 x i32> [[VEC_PHI]], [[WIDE_MASKED_LOAD]]
; CHECK-NEXT:    [[TMP15]] = select <vscale x 4 x i1> [[ACTIVE_LANE_MASK]], <vscale x 4 x i32> [[TMP14]], <vscale x 4 x i32> [[VEC_PHI]]
; CHECK-NEXT:    [[ACTIVE_LANE_MASK_NEXT]] = call <vscale x 4 x i1> @llvm.get.active.lane.mask.nxv4i1.i64(i64 [[INDEX1]], i64 [[TMP9]])
; CHECK-NEXT:    [[TMP16:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP17:%.*]] = mul i64 [[TMP16]], 4
; CHECK-NEXT:    [[INDEX_NEXT2]] = add i64 [[INDEX1]], [[TMP17]]
; CHECK-NEXT:    [[TMP18:%.*]] = xor <vscale x 4 x i1> [[ACTIVE_LANE_MASK_NEXT]], shufflevector (<vscale x 4 x i1> insertelement (<vscale x 4 x i1> poison, i1 true, i64 0), <vscale x 4 x i1> poison, <vscale x 4 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP19:%.*]] = extractelement <vscale x 4 x i1> [[TMP18]], i32 0
; CHECK-NEXT:    br i1 [[TMP19]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[TMP20:%.*]] = call i32 @llvm.vector.reduce.add.nxv4i32(<vscale x 4 x i32> [[TMP15]])
; CHECK-NEXT:    br i1 true, label [[WHILE_END_LOOPEXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[BC_MERGE_RDX:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[TMP20]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    br label [[WHILE_BODY:%.*]]
; CHECK:       while.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ [[INDEX_NEXT:%.*]], [[WHILE_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[RED:%.*]] = phi i32 [ [[RED_NEXT:%.*]], [[WHILE_BODY]] ], [ [[BC_MERGE_RDX]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i32, i32* [[PTR]], i64 [[INDEX]]
; CHECK-NEXT:    [[VAL:%.*]] = load i32, i32* [[GEP]], align 4
; CHECK-NEXT:    [[RED_NEXT]] = add i32 [[RED]], [[VAL]]
; CHECK-NEXT:    [[INDEX_NEXT]] = add nsw i64 [[INDEX]], 1
; CHECK-NEXT:    [[CMP10:%.*]] = icmp ult i64 [[INDEX_NEXT]], [[N]]
; CHECK-NEXT:    br i1 [[CMP10]], label [[WHILE_BODY]], label [[WHILE_END_LOOPEXIT]], !llvm.loop [[LOOP3:![0-9]+]]
; CHECK:       while.end.loopexit:
; CHECK-NEXT:    [[RED_NEXT_LCSSA:%.*]] = phi i32 [ [[RED_NEXT]], [[WHILE_BODY]] ], [ [[TMP20]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    ret i32 [[RED_NEXT_LCSSA]]
;
; CHECK-IN-LOOP-LABEL: @add_reduction_i32(
; CHECK-IN-LOOP-NEXT:  entry:
; CHECK-IN-LOOP-NEXT:    [[UMAX:%.*]] = call i64 @llvm.umax.i64(i64 [[N:%.*]], i64 1)
; CHECK-IN-LOOP-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK-IN-LOOP:       vector.ph:
; CHECK-IN-LOOP-NEXT:    [[TMP0:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-IN-LOOP-NEXT:    [[TMP1:%.*]] = mul i64 [[TMP0]], 4
; CHECK-IN-LOOP-NEXT:    [[TMP2:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-IN-LOOP-NEXT:    [[TMP3:%.*]] = mul i64 [[TMP2]], 4
; CHECK-IN-LOOP-NEXT:    [[TMP4:%.*]] = sub i64 [[TMP3]], 1
; CHECK-IN-LOOP-NEXT:    [[N_RND_UP:%.*]] = add i64 [[UMAX]], [[TMP4]]
; CHECK-IN-LOOP-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[N_RND_UP]], [[TMP1]]
; CHECK-IN-LOOP-NEXT:    [[N_VEC:%.*]] = sub i64 [[N_RND_UP]], [[N_MOD_VF]]
; CHECK-IN-LOOP-NEXT:    [[TMP5:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-IN-LOOP-NEXT:    [[TMP6:%.*]] = mul i64 [[TMP5]], 4
; CHECK-IN-LOOP-NEXT:    [[TMP7:%.*]] = sub i64 [[UMAX]], [[TMP6]]
; CHECK-IN-LOOP-NEXT:    [[TMP8:%.*]] = icmp ugt i64 [[UMAX]], [[TMP6]]
; CHECK-IN-LOOP-NEXT:    [[TMP9:%.*]] = select i1 [[TMP8]], i64 [[TMP7]], i64 0
; CHECK-IN-LOOP-NEXT:    [[ACTIVE_LANE_MASK_ENTRY:%.*]] = call <vscale x 4 x i1> @llvm.get.active.lane.mask.nxv4i1.i64(i64 0, i64 [[UMAX]])
; CHECK-IN-LOOP-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK-IN-LOOP:       vector.body:
; CHECK-IN-LOOP-NEXT:    [[INDEX1:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT2:%.*]], [[VECTOR_BODY]] ]
; CHECK-IN-LOOP-NEXT:    [[ACTIVE_LANE_MASK:%.*]] = phi <vscale x 4 x i1> [ [[ACTIVE_LANE_MASK_ENTRY]], [[VECTOR_PH]] ], [ [[ACTIVE_LANE_MASK_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-IN-LOOP-NEXT:    [[VEC_PHI:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[TMP16:%.*]], [[VECTOR_BODY]] ]
; CHECK-IN-LOOP-NEXT:    [[TMP10:%.*]] = add i64 [[INDEX1]], 0
; CHECK-IN-LOOP-NEXT:    [[TMP11:%.*]] = getelementptr i32, i32* [[PTR:%.*]], i64 [[TMP10]]
; CHECK-IN-LOOP-NEXT:    [[TMP12:%.*]] = getelementptr i32, i32* [[TMP11]], i32 0
; CHECK-IN-LOOP-NEXT:    [[TMP13:%.*]] = bitcast i32* [[TMP12]] to <vscale x 4 x i32>*
; CHECK-IN-LOOP-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <vscale x 4 x i32> @llvm.masked.load.nxv4i32.p0nxv4i32(<vscale x 4 x i32>* [[TMP13]], i32 4, <vscale x 4 x i1> [[ACTIVE_LANE_MASK]], <vscale x 4 x i32> poison)
; CHECK-IN-LOOP-NEXT:    [[TMP14:%.*]] = select <vscale x 4 x i1> [[ACTIVE_LANE_MASK]], <vscale x 4 x i32> [[WIDE_MASKED_LOAD]], <vscale x 4 x i32> zeroinitializer
; CHECK-IN-LOOP-NEXT:    [[TMP15:%.*]] = call i32 @llvm.vector.reduce.add.nxv4i32(<vscale x 4 x i32> [[TMP14]])
; CHECK-IN-LOOP-NEXT:    [[TMP16]] = add i32 [[TMP15]], [[VEC_PHI]]
; CHECK-IN-LOOP-NEXT:    [[ACTIVE_LANE_MASK_NEXT]] = call <vscale x 4 x i1> @llvm.get.active.lane.mask.nxv4i1.i64(i64 [[INDEX1]], i64 [[TMP9]])
; CHECK-IN-LOOP-NEXT:    [[TMP17:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-IN-LOOP-NEXT:    [[TMP18:%.*]] = mul i64 [[TMP17]], 4
; CHECK-IN-LOOP-NEXT:    [[INDEX_NEXT2]] = add i64 [[INDEX1]], [[TMP18]]
; CHECK-IN-LOOP-NEXT:    [[TMP19:%.*]] = xor <vscale x 4 x i1> [[ACTIVE_LANE_MASK_NEXT]], shufflevector (<vscale x 4 x i1> insertelement (<vscale x 4 x i1> poison, i1 true, i64 0), <vscale x 4 x i1> poison, <vscale x 4 x i32> zeroinitializer)
; CHECK-IN-LOOP-NEXT:    [[TMP20:%.*]] = extractelement <vscale x 4 x i1> [[TMP19]], i32 0
; CHECK-IN-LOOP-NEXT:    br i1 [[TMP20]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK-IN-LOOP:       middle.block:
; CHECK-IN-LOOP-NEXT:    br i1 true, label [[WHILE_END_LOOPEXIT:%.*]], label [[SCALAR_PH]]
; CHECK-IN-LOOP:       scalar.ph:
; CHECK-IN-LOOP-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-IN-LOOP-NEXT:    [[BC_MERGE_RDX:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[TMP16]], [[MIDDLE_BLOCK]] ]
; CHECK-IN-LOOP-NEXT:    br label [[WHILE_BODY:%.*]]
; CHECK-IN-LOOP:       while.body:
; CHECK-IN-LOOP-NEXT:    [[INDEX:%.*]] = phi i64 [ [[INDEX_NEXT:%.*]], [[WHILE_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-IN-LOOP-NEXT:    [[RED:%.*]] = phi i32 [ [[RED_NEXT:%.*]], [[WHILE_BODY]] ], [ [[BC_MERGE_RDX]], [[SCALAR_PH]] ]
; CHECK-IN-LOOP-NEXT:    [[GEP:%.*]] = getelementptr i32, i32* [[PTR]], i64 [[INDEX]]
; CHECK-IN-LOOP-NEXT:    [[VAL:%.*]] = load i32, i32* [[GEP]], align 4
; CHECK-IN-LOOP-NEXT:    [[RED_NEXT]] = add i32 [[RED]], [[VAL]]
; CHECK-IN-LOOP-NEXT:    [[INDEX_NEXT]] = add nsw i64 [[INDEX]], 1
; CHECK-IN-LOOP-NEXT:    [[CMP10:%.*]] = icmp ult i64 [[INDEX_NEXT]], [[N]]
; CHECK-IN-LOOP-NEXT:    br i1 [[CMP10]], label [[WHILE_BODY]], label [[WHILE_END_LOOPEXIT]], !llvm.loop [[LOOP3:![0-9]+]]
; CHECK-IN-LOOP:       while.end.loopexit:
; CHECK-IN-LOOP-NEXT:    [[RED_NEXT_LCSSA:%.*]] = phi i32 [ [[RED_NEXT]], [[WHILE_BODY]] ], [ [[TMP16]], [[MIDDLE_BLOCK]] ]
; CHECK-IN-LOOP-NEXT:    ret i32 [[RED_NEXT_LCSSA]]
;
entry:
  br label %while.body

while.body:                                       ; preds = %while.body, %entry
  %index = phi i64 [ %index.next, %while.body ], [ 0, %entry ]
  %red = phi i32 [ %red.next, %while.body ], [ 0, %entry ]
  %gep = getelementptr i32, i32* %ptr, i64 %index
  %val = load i32, i32* %gep
  %red.next = add i32 %red, %val
  %index.next = add nsw i64 %index, 1
  %cmp10 = icmp ult i64 %index.next, %n
  br i1 %cmp10, label %while.body, label %while.end.loopexit, !llvm.loop !0

while.end.loopexit:                               ; preds = %while.body
  ret i32 %red.next
}

define float @add_reduction_f32(float* %ptr, i64 %n) #0 {
; CHECK-LABEL: @add_reduction_f32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[UMAX:%.*]] = call i64 @llvm.umax.i64(i64 [[N:%.*]], i64 1)
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[TMP0:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP1:%.*]] = mul i64 [[TMP0]], 4
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP3:%.*]] = mul i64 [[TMP2]], 4
; CHECK-NEXT:    [[TMP4:%.*]] = sub i64 [[TMP3]], 1
; CHECK-NEXT:    [[N_RND_UP:%.*]] = add i64 [[UMAX]], [[TMP4]]
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[N_RND_UP]], [[TMP1]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[N_RND_UP]], [[N_MOD_VF]]
; CHECK-NEXT:    [[TMP5:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP6:%.*]] = mul i64 [[TMP5]], 4
; CHECK-NEXT:    [[TMP7:%.*]] = sub i64 [[UMAX]], [[TMP6]]
; CHECK-NEXT:    [[TMP8:%.*]] = icmp ugt i64 [[UMAX]], [[TMP6]]
; CHECK-NEXT:    [[TMP9:%.*]] = select i1 [[TMP8]], i64 [[TMP7]], i64 0
; CHECK-NEXT:    [[ACTIVE_LANE_MASK_ENTRY:%.*]] = call <vscale x 4 x i1> @llvm.get.active.lane.mask.nxv4i1.i64(i64 0, i64 [[UMAX]])
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX1:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT2:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[ACTIVE_LANE_MASK:%.*]] = phi <vscale x 4 x i1> [ [[ACTIVE_LANE_MASK_ENTRY]], [[VECTOR_PH]] ], [ [[ACTIVE_LANE_MASK_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_PHI:%.*]] = phi float [ 0.000000e+00, [[VECTOR_PH]] ], [ [[TMP15:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP10:%.*]] = add i64 [[INDEX1]], 0
; CHECK-NEXT:    [[TMP11:%.*]] = getelementptr float, float* [[PTR:%.*]], i64 [[TMP10]]
; CHECK-NEXT:    [[TMP12:%.*]] = getelementptr float, float* [[TMP11]], i32 0
; CHECK-NEXT:    [[TMP13:%.*]] = bitcast float* [[TMP12]] to <vscale x 4 x float>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <vscale x 4 x float> @llvm.masked.load.nxv4f32.p0nxv4f32(<vscale x 4 x float>* [[TMP13]], i32 4, <vscale x 4 x i1> [[ACTIVE_LANE_MASK]], <vscale x 4 x float> poison)
; CHECK-NEXT:    [[TMP14:%.*]] = select <vscale x 4 x i1> [[ACTIVE_LANE_MASK]], <vscale x 4 x float> [[WIDE_MASKED_LOAD]], <vscale x 4 x float> shufflevector (<vscale x 4 x float> insertelement (<vscale x 4 x float> poison, float -0.000000e+00, i64 0), <vscale x 4 x float> poison, <vscale x 4 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP15]] = call float @llvm.vector.reduce.fadd.nxv4f32(float [[VEC_PHI]], <vscale x 4 x float> [[TMP14]])
; CHECK-NEXT:    [[ACTIVE_LANE_MASK_NEXT]] = call <vscale x 4 x i1> @llvm.get.active.lane.mask.nxv4i1.i64(i64 [[INDEX1]], i64 [[TMP9]])
; CHECK-NEXT:    [[TMP16:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP17:%.*]] = mul i64 [[TMP16]], 4
; CHECK-NEXT:    [[INDEX_NEXT2]] = add i64 [[INDEX1]], [[TMP17]]
; CHECK-NEXT:    [[TMP18:%.*]] = xor <vscale x 4 x i1> [[ACTIVE_LANE_MASK_NEXT]], shufflevector (<vscale x 4 x i1> insertelement (<vscale x 4 x i1> poison, i1 true, i64 0), <vscale x 4 x i1> poison, <vscale x 4 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP19:%.*]] = extractelement <vscale x 4 x i1> [[TMP18]], i32 0
; CHECK-NEXT:    br i1 [[TMP19]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP4:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    br i1 true, label [[WHILE_END_LOOPEXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[BC_MERGE_RDX:%.*]] = phi float [ 0.000000e+00, [[ENTRY]] ], [ [[TMP15]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    br label [[WHILE_BODY:%.*]]
; CHECK:       while.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ [[INDEX_NEXT:%.*]], [[WHILE_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[RED:%.*]] = phi float [ [[RED_NEXT:%.*]], [[WHILE_BODY]] ], [ [[BC_MERGE_RDX]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr float, float* [[PTR]], i64 [[INDEX]]
; CHECK-NEXT:    [[VAL:%.*]] = load float, float* [[GEP]], align 4
; CHECK-NEXT:    [[RED_NEXT]] = fadd float [[RED]], [[VAL]]
; CHECK-NEXT:    [[INDEX_NEXT]] = add nsw i64 [[INDEX]], 1
; CHECK-NEXT:    [[CMP10:%.*]] = icmp ult i64 [[INDEX_NEXT]], [[N]]
; CHECK-NEXT:    br i1 [[CMP10]], label [[WHILE_BODY]], label [[WHILE_END_LOOPEXIT]], !llvm.loop [[LOOP5:![0-9]+]]
; CHECK:       while.end.loopexit:
; CHECK-NEXT:    [[RED_NEXT_LCSSA:%.*]] = phi float [ [[RED_NEXT]], [[WHILE_BODY]] ], [ [[TMP15]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    ret float [[RED_NEXT_LCSSA]]
;
; CHECK-IN-LOOP-LABEL: @add_reduction_f32(
; CHECK-IN-LOOP-NEXT:  entry:
; CHECK-IN-LOOP-NEXT:    [[UMAX:%.*]] = call i64 @llvm.umax.i64(i64 [[N:%.*]], i64 1)
; CHECK-IN-LOOP-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK-IN-LOOP:       vector.ph:
; CHECK-IN-LOOP-NEXT:    [[TMP0:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-IN-LOOP-NEXT:    [[TMP1:%.*]] = mul i64 [[TMP0]], 4
; CHECK-IN-LOOP-NEXT:    [[TMP2:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-IN-LOOP-NEXT:    [[TMP3:%.*]] = mul i64 [[TMP2]], 4
; CHECK-IN-LOOP-NEXT:    [[TMP4:%.*]] = sub i64 [[TMP3]], 1
; CHECK-IN-LOOP-NEXT:    [[N_RND_UP:%.*]] = add i64 [[UMAX]], [[TMP4]]
; CHECK-IN-LOOP-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[N_RND_UP]], [[TMP1]]
; CHECK-IN-LOOP-NEXT:    [[N_VEC:%.*]] = sub i64 [[N_RND_UP]], [[N_MOD_VF]]
; CHECK-IN-LOOP-NEXT:    [[TMP5:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-IN-LOOP-NEXT:    [[TMP6:%.*]] = mul i64 [[TMP5]], 4
; CHECK-IN-LOOP-NEXT:    [[TMP7:%.*]] = sub i64 [[UMAX]], [[TMP6]]
; CHECK-IN-LOOP-NEXT:    [[TMP8:%.*]] = icmp ugt i64 [[UMAX]], [[TMP6]]
; CHECK-IN-LOOP-NEXT:    [[TMP9:%.*]] = select i1 [[TMP8]], i64 [[TMP7]], i64 0
; CHECK-IN-LOOP-NEXT:    [[ACTIVE_LANE_MASK_ENTRY:%.*]] = call <vscale x 4 x i1> @llvm.get.active.lane.mask.nxv4i1.i64(i64 0, i64 [[UMAX]])
; CHECK-IN-LOOP-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK-IN-LOOP:       vector.body:
; CHECK-IN-LOOP-NEXT:    [[INDEX1:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT2:%.*]], [[VECTOR_BODY]] ]
; CHECK-IN-LOOP-NEXT:    [[ACTIVE_LANE_MASK:%.*]] = phi <vscale x 4 x i1> [ [[ACTIVE_LANE_MASK_ENTRY]], [[VECTOR_PH]] ], [ [[ACTIVE_LANE_MASK_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-IN-LOOP-NEXT:    [[VEC_PHI:%.*]] = phi float [ 0.000000e+00, [[VECTOR_PH]] ], [ [[TMP15:%.*]], [[VECTOR_BODY]] ]
; CHECK-IN-LOOP-NEXT:    [[TMP10:%.*]] = add i64 [[INDEX1]], 0
; CHECK-IN-LOOP-NEXT:    [[TMP11:%.*]] = getelementptr float, float* [[PTR:%.*]], i64 [[TMP10]]
; CHECK-IN-LOOP-NEXT:    [[TMP12:%.*]] = getelementptr float, float* [[TMP11]], i32 0
; CHECK-IN-LOOP-NEXT:    [[TMP13:%.*]] = bitcast float* [[TMP12]] to <vscale x 4 x float>*
; CHECK-IN-LOOP-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <vscale x 4 x float> @llvm.masked.load.nxv4f32.p0nxv4f32(<vscale x 4 x float>* [[TMP13]], i32 4, <vscale x 4 x i1> [[ACTIVE_LANE_MASK]], <vscale x 4 x float> poison)
; CHECK-IN-LOOP-NEXT:    [[TMP14:%.*]] = select <vscale x 4 x i1> [[ACTIVE_LANE_MASK]], <vscale x 4 x float> [[WIDE_MASKED_LOAD]], <vscale x 4 x float> shufflevector (<vscale x 4 x float> insertelement (<vscale x 4 x float> poison, float -0.000000e+00, i64 0), <vscale x 4 x float> poison, <vscale x 4 x i32> zeroinitializer)
; CHECK-IN-LOOP-NEXT:    [[TMP15]] = call float @llvm.vector.reduce.fadd.nxv4f32(float [[VEC_PHI]], <vscale x 4 x float> [[TMP14]])
; CHECK-IN-LOOP-NEXT:    [[ACTIVE_LANE_MASK_NEXT]] = call <vscale x 4 x i1> @llvm.get.active.lane.mask.nxv4i1.i64(i64 [[INDEX1]], i64 [[TMP9]])
; CHECK-IN-LOOP-NEXT:    [[TMP16:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-IN-LOOP-NEXT:    [[TMP17:%.*]] = mul i64 [[TMP16]], 4
; CHECK-IN-LOOP-NEXT:    [[INDEX_NEXT2]] = add i64 [[INDEX1]], [[TMP17]]
; CHECK-IN-LOOP-NEXT:    [[TMP18:%.*]] = xor <vscale x 4 x i1> [[ACTIVE_LANE_MASK_NEXT]], shufflevector (<vscale x 4 x i1> insertelement (<vscale x 4 x i1> poison, i1 true, i64 0), <vscale x 4 x i1> poison, <vscale x 4 x i32> zeroinitializer)
; CHECK-IN-LOOP-NEXT:    [[TMP19:%.*]] = extractelement <vscale x 4 x i1> [[TMP18]], i32 0
; CHECK-IN-LOOP-NEXT:    br i1 [[TMP19]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP4:![0-9]+]]
; CHECK-IN-LOOP:       middle.block:
; CHECK-IN-LOOP-NEXT:    br i1 true, label [[WHILE_END_LOOPEXIT:%.*]], label [[SCALAR_PH]]
; CHECK-IN-LOOP:       scalar.ph:
; CHECK-IN-LOOP-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-IN-LOOP-NEXT:    [[BC_MERGE_RDX:%.*]] = phi float [ 0.000000e+00, [[ENTRY]] ], [ [[TMP15]], [[MIDDLE_BLOCK]] ]
; CHECK-IN-LOOP-NEXT:    br label [[WHILE_BODY:%.*]]
; CHECK-IN-LOOP:       while.body:
; CHECK-IN-LOOP-NEXT:    [[INDEX:%.*]] = phi i64 [ [[INDEX_NEXT:%.*]], [[WHILE_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-IN-LOOP-NEXT:    [[RED:%.*]] = phi float [ [[RED_NEXT:%.*]], [[WHILE_BODY]] ], [ [[BC_MERGE_RDX]], [[SCALAR_PH]] ]
; CHECK-IN-LOOP-NEXT:    [[GEP:%.*]] = getelementptr float, float* [[PTR]], i64 [[INDEX]]
; CHECK-IN-LOOP-NEXT:    [[VAL:%.*]] = load float, float* [[GEP]], align 4
; CHECK-IN-LOOP-NEXT:    [[RED_NEXT]] = fadd float [[RED]], [[VAL]]
; CHECK-IN-LOOP-NEXT:    [[INDEX_NEXT]] = add nsw i64 [[INDEX]], 1
; CHECK-IN-LOOP-NEXT:    [[CMP10:%.*]] = icmp ult i64 [[INDEX_NEXT]], [[N]]
; CHECK-IN-LOOP-NEXT:    br i1 [[CMP10]], label [[WHILE_BODY]], label [[WHILE_END_LOOPEXIT]], !llvm.loop [[LOOP5:![0-9]+]]
; CHECK-IN-LOOP:       while.end.loopexit:
; CHECK-IN-LOOP-NEXT:    [[RED_NEXT_LCSSA:%.*]] = phi float [ [[RED_NEXT]], [[WHILE_BODY]] ], [ [[TMP15]], [[MIDDLE_BLOCK]] ]
; CHECK-IN-LOOP-NEXT:    ret float [[RED_NEXT_LCSSA]]
;
entry:
  br label %while.body

while.body:                                       ; preds = %while.body, %entry
  %index = phi i64 [ %index.next, %while.body ], [ 0, %entry ]
  %red = phi float [ %red.next, %while.body ], [ 0.000000, %entry ]
  %gep = getelementptr float, float* %ptr, i64 %index
  %val = load float, float* %gep
  %red.next = fadd float %red, %val
  %index.next = add nsw i64 %index, 1
  %cmp10 = icmp ult i64 %index.next, %n
  br i1 %cmp10, label %while.body, label %while.end.loopexit, !llvm.loop !0

while.end.loopexit:                               ; preds = %while.body
  ret float %red.next
}

define i32 @cond_xor_reduction(i32* noalias %a, i32* noalias %cond, i64 %N) #0 {
; CHECK-LABEL: @cond_xor_reduction(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[TMP0:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP1:%.*]] = mul i64 [[TMP0]], 4
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP3:%.*]] = mul i64 [[TMP2]], 4
; CHECK-NEXT:    [[TMP4:%.*]] = sub i64 [[TMP3]], 1
; CHECK-NEXT:    [[N_RND_UP:%.*]] = add i64 [[N:%.*]], [[TMP4]]
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[N_RND_UP]], [[TMP1]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[N_RND_UP]], [[N_MOD_VF]]
; CHECK-NEXT:    [[TMP5:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP6:%.*]] = mul i64 [[TMP5]], 4
; CHECK-NEXT:    [[TMP7:%.*]] = sub i64 [[N]], [[TMP6]]
; CHECK-NEXT:    [[TMP8:%.*]] = icmp ugt i64 [[N]], [[TMP6]]
; CHECK-NEXT:    [[TMP9:%.*]] = select i1 [[TMP8]], i64 [[TMP7]], i64 0
; CHECK-NEXT:    [[ACTIVE_LANE_MASK_ENTRY:%.*]] = call <vscale x 4 x i1> @llvm.get.active.lane.mask.nxv4i1.i64(i64 0, i64 [[N]])
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[ACTIVE_LANE_MASK:%.*]] = phi <vscale x 4 x i1> [ [[ACTIVE_LANE_MASK_ENTRY]], [[VECTOR_PH]] ], [ [[ACTIVE_LANE_MASK_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_PHI:%.*]] = phi <vscale x 4 x i32> [ insertelement (<vscale x 4 x i32> zeroinitializer, i32 7, i32 0), [[VECTOR_PH]] ], [ [[TMP22:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP10:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP11:%.*]] = getelementptr inbounds i32, i32* [[COND:%.*]], i64 [[TMP10]]
; CHECK-NEXT:    [[TMP12:%.*]] = getelementptr inbounds i32, i32* [[TMP11]], i32 0
; CHECK-NEXT:    [[TMP13:%.*]] = bitcast i32* [[TMP12]] to <vscale x 4 x i32>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <vscale x 4 x i32> @llvm.masked.load.nxv4i32.p0nxv4i32(<vscale x 4 x i32>* [[TMP13]], i32 4, <vscale x 4 x i1> [[ACTIVE_LANE_MASK]], <vscale x 4 x i32> poison)
; CHECK-NEXT:    [[TMP14:%.*]] = icmp eq <vscale x 4 x i32> [[WIDE_MASKED_LOAD]], shufflevector (<vscale x 4 x i32> insertelement (<vscale x 4 x i32> poison, i32 5, i64 0), <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP15:%.*]] = getelementptr i32, i32* [[A:%.*]], i64 [[TMP10]]
; CHECK-NEXT:    [[TMP16:%.*]] = select <vscale x 4 x i1> [[ACTIVE_LANE_MASK]], <vscale x 4 x i1> [[TMP14]], <vscale x 4 x i1> zeroinitializer
; CHECK-NEXT:    [[TMP17:%.*]] = getelementptr i32, i32* [[TMP15]], i32 0
; CHECK-NEXT:    [[TMP18:%.*]] = bitcast i32* [[TMP17]] to <vscale x 4 x i32>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD1:%.*]] = call <vscale x 4 x i32> @llvm.masked.load.nxv4i32.p0nxv4i32(<vscale x 4 x i32>* [[TMP18]], i32 4, <vscale x 4 x i1> [[TMP16]], <vscale x 4 x i32> poison)
; CHECK-NEXT:    [[TMP19:%.*]] = xor <vscale x 4 x i32> [[VEC_PHI]], [[WIDE_MASKED_LOAD1]]
; CHECK-NEXT:    [[TMP20:%.*]] = xor <vscale x 4 x i1> [[TMP14]], shufflevector (<vscale x 4 x i1> insertelement (<vscale x 4 x i1> poison, i1 true, i64 0), <vscale x 4 x i1> poison, <vscale x 4 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP21:%.*]] = select <vscale x 4 x i1> [[ACTIVE_LANE_MASK]], <vscale x 4 x i1> [[TMP20]], <vscale x 4 x i1> zeroinitializer
; CHECK-NEXT:    [[PREDPHI:%.*]] = select <vscale x 4 x i1> [[TMP16]], <vscale x 4 x i32> [[TMP19]], <vscale x 4 x i32> [[VEC_PHI]]
; CHECK-NEXT:    [[TMP22]] = select <vscale x 4 x i1> [[ACTIVE_LANE_MASK]], <vscale x 4 x i32> [[PREDPHI]], <vscale x 4 x i32> [[VEC_PHI]]
; CHECK-NEXT:    [[ACTIVE_LANE_MASK_NEXT]] = call <vscale x 4 x i1> @llvm.get.active.lane.mask.nxv4i1.i64(i64 [[INDEX]], i64 [[TMP9]])
; CHECK-NEXT:    [[TMP23:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP24:%.*]] = mul i64 [[TMP23]], 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], [[TMP24]]
; CHECK-NEXT:    [[TMP25:%.*]] = xor <vscale x 4 x i1> [[ACTIVE_LANE_MASK_NEXT]], shufflevector (<vscale x 4 x i1> insertelement (<vscale x 4 x i1> poison, i1 true, i64 0), <vscale x 4 x i1> poison, <vscale x 4 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP26:%.*]] = extractelement <vscale x 4 x i1> [[TMP25]], i32 0
; CHECK-NEXT:    br i1 [[TMP26]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP6:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[TMP27:%.*]] = call i32 @llvm.vector.reduce.xor.nxv4i32(<vscale x 4 x i32> [[TMP22]])
; CHECK-NEXT:    br i1 true, label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[BC_MERGE_RDX:%.*]] = phi i32 [ 7, [[ENTRY]] ], [ [[TMP27]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[FOR_INC:%.*]] ]
; CHECK-NEXT:    [[RDX:%.*]] = phi i32 [ [[BC_MERGE_RDX]], [[SCALAR_PH]] ], [ [[RES:%.*]], [[FOR_INC]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[COND]], i64 [[IV]]
; CHECK-NEXT:    [[TMP28:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i32 [[TMP28]], 5
; CHECK-NEXT:    br i1 [[TOBOOL]], label [[IF_THEN:%.*]], label [[FOR_INC]]
; CHECK:       if.then:
; CHECK-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[IV]]
; CHECK-NEXT:    [[TMP29:%.*]] = load i32, i32* [[ARRAYIDX2]], align 4
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[RDX]], [[TMP29]]
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[RES]] = phi i32 [ [[RDX]], [[FOR_BODY]] ], [ [[XOR]], [[IF_THEN]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[IV_NEXT]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop [[LOOP7:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    [[RES_LCSSA:%.*]] = phi i32 [ [[RES]], [[FOR_INC]] ], [ [[TMP27]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    ret i32 [[RES_LCSSA]]
;
; CHECK-IN-LOOP-LABEL: @cond_xor_reduction(
; CHECK-IN-LOOP-NEXT:  entry:
; CHECK-IN-LOOP-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK-IN-LOOP:       vector.ph:
; CHECK-IN-LOOP-NEXT:    [[TMP0:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-IN-LOOP-NEXT:    [[TMP1:%.*]] = mul i64 [[TMP0]], 4
; CHECK-IN-LOOP-NEXT:    [[TMP2:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-IN-LOOP-NEXT:    [[TMP3:%.*]] = mul i64 [[TMP2]], 4
; CHECK-IN-LOOP-NEXT:    [[TMP4:%.*]] = sub i64 [[TMP3]], 1
; CHECK-IN-LOOP-NEXT:    [[N_RND_UP:%.*]] = add i64 [[N:%.*]], [[TMP4]]
; CHECK-IN-LOOP-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[N_RND_UP]], [[TMP1]]
; CHECK-IN-LOOP-NEXT:    [[N_VEC:%.*]] = sub i64 [[N_RND_UP]], [[N_MOD_VF]]
; CHECK-IN-LOOP-NEXT:    [[TMP5:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-IN-LOOP-NEXT:    [[TMP6:%.*]] = mul i64 [[TMP5]], 4
; CHECK-IN-LOOP-NEXT:    [[TMP7:%.*]] = sub i64 [[N]], [[TMP6]]
; CHECK-IN-LOOP-NEXT:    [[TMP8:%.*]] = icmp ugt i64 [[N]], [[TMP6]]
; CHECK-IN-LOOP-NEXT:    [[TMP9:%.*]] = select i1 [[TMP8]], i64 [[TMP7]], i64 0
; CHECK-IN-LOOP-NEXT:    [[ACTIVE_LANE_MASK_ENTRY:%.*]] = call <vscale x 4 x i1> @llvm.get.active.lane.mask.nxv4i1.i64(i64 0, i64 [[N]])
; CHECK-IN-LOOP-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK-IN-LOOP:       vector.body:
; CHECK-IN-LOOP-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-IN-LOOP-NEXT:    [[ACTIVE_LANE_MASK:%.*]] = phi <vscale x 4 x i1> [ [[ACTIVE_LANE_MASK_ENTRY]], [[VECTOR_PH]] ], [ [[ACTIVE_LANE_MASK_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-IN-LOOP-NEXT:    [[VEC_PHI:%.*]] = phi i32 [ 7, [[VECTOR_PH]] ], [ [[TMP21:%.*]], [[VECTOR_BODY]] ]
; CHECK-IN-LOOP-NEXT:    [[TMP10:%.*]] = add i64 [[INDEX]], 0
; CHECK-IN-LOOP-NEXT:    [[TMP11:%.*]] = getelementptr inbounds i32, i32* [[COND:%.*]], i64 [[TMP10]]
; CHECK-IN-LOOP-NEXT:    [[TMP12:%.*]] = getelementptr inbounds i32, i32* [[TMP11]], i32 0
; CHECK-IN-LOOP-NEXT:    [[TMP13:%.*]] = bitcast i32* [[TMP12]] to <vscale x 4 x i32>*
; CHECK-IN-LOOP-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <vscale x 4 x i32> @llvm.masked.load.nxv4i32.p0nxv4i32(<vscale x 4 x i32>* [[TMP13]], i32 4, <vscale x 4 x i1> [[ACTIVE_LANE_MASK]], <vscale x 4 x i32> poison)
; CHECK-IN-LOOP-NEXT:    [[TMP14:%.*]] = icmp eq <vscale x 4 x i32> [[WIDE_MASKED_LOAD]], shufflevector (<vscale x 4 x i32> insertelement (<vscale x 4 x i32> poison, i32 5, i64 0), <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer)
; CHECK-IN-LOOP-NEXT:    [[TMP15:%.*]] = getelementptr i32, i32* [[A:%.*]], i64 [[TMP10]]
; CHECK-IN-LOOP-NEXT:    [[TMP16:%.*]] = select <vscale x 4 x i1> [[ACTIVE_LANE_MASK]], <vscale x 4 x i1> [[TMP14]], <vscale x 4 x i1> zeroinitializer
; CHECK-IN-LOOP-NEXT:    [[TMP17:%.*]] = getelementptr i32, i32* [[TMP15]], i32 0
; CHECK-IN-LOOP-NEXT:    [[TMP18:%.*]] = bitcast i32* [[TMP17]] to <vscale x 4 x i32>*
; CHECK-IN-LOOP-NEXT:    [[WIDE_MASKED_LOAD1:%.*]] = call <vscale x 4 x i32> @llvm.masked.load.nxv4i32.p0nxv4i32(<vscale x 4 x i32>* [[TMP18]], i32 4, <vscale x 4 x i1> [[TMP16]], <vscale x 4 x i32> poison)
; CHECK-IN-LOOP-NEXT:    [[TMP19:%.*]] = select <vscale x 4 x i1> [[TMP16]], <vscale x 4 x i32> [[WIDE_MASKED_LOAD1]], <vscale x 4 x i32> zeroinitializer
; CHECK-IN-LOOP-NEXT:    [[TMP20:%.*]] = call i32 @llvm.vector.reduce.xor.nxv4i32(<vscale x 4 x i32> [[TMP19]])
; CHECK-IN-LOOP-NEXT:    [[TMP21]] = xor i32 [[TMP20]], [[VEC_PHI]]
; CHECK-IN-LOOP-NEXT:    [[ACTIVE_LANE_MASK_NEXT]] = call <vscale x 4 x i1> @llvm.get.active.lane.mask.nxv4i1.i64(i64 [[INDEX]], i64 [[TMP9]])
; CHECK-IN-LOOP-NEXT:    [[TMP22:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-IN-LOOP-NEXT:    [[TMP23:%.*]] = mul i64 [[TMP22]], 4
; CHECK-IN-LOOP-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], [[TMP23]]
; CHECK-IN-LOOP-NEXT:    [[TMP24:%.*]] = xor <vscale x 4 x i1> [[ACTIVE_LANE_MASK_NEXT]], shufflevector (<vscale x 4 x i1> insertelement (<vscale x 4 x i1> poison, i1 true, i64 0), <vscale x 4 x i1> poison, <vscale x 4 x i32> zeroinitializer)
; CHECK-IN-LOOP-NEXT:    [[TMP25:%.*]] = extractelement <vscale x 4 x i1> [[TMP24]], i32 0
; CHECK-IN-LOOP-NEXT:    br i1 [[TMP25]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP6:![0-9]+]]
; CHECK-IN-LOOP:       middle.block:
; CHECK-IN-LOOP-NEXT:    br i1 true, label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK-IN-LOOP:       scalar.ph:
; CHECK-IN-LOOP-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-IN-LOOP-NEXT:    [[BC_MERGE_RDX:%.*]] = phi i32 [ 7, [[ENTRY]] ], [ [[TMP21]], [[MIDDLE_BLOCK]] ]
; CHECK-IN-LOOP-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK-IN-LOOP:       for.body:
; CHECK-IN-LOOP-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[FOR_INC:%.*]] ]
; CHECK-IN-LOOP-NEXT:    [[RDX:%.*]] = phi i32 [ [[BC_MERGE_RDX]], [[SCALAR_PH]] ], [ [[RES:%.*]], [[FOR_INC]] ]
; CHECK-IN-LOOP-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[COND]], i64 [[IV]]
; CHECK-IN-LOOP-NEXT:    [[TMP26:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; CHECK-IN-LOOP-NEXT:    [[TOBOOL:%.*]] = icmp eq i32 [[TMP26]], 5
; CHECK-IN-LOOP-NEXT:    br i1 [[TOBOOL]], label [[IF_THEN:%.*]], label [[FOR_INC]]
; CHECK-IN-LOOP:       if.then:
; CHECK-IN-LOOP-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds i32, i32* [[A]], i64 [[IV]]
; CHECK-IN-LOOP-NEXT:    [[TMP27:%.*]] = load i32, i32* [[ARRAYIDX2]], align 4
; CHECK-IN-LOOP-NEXT:    [[XOR:%.*]] = xor i32 [[RDX]], [[TMP27]]
; CHECK-IN-LOOP-NEXT:    br label [[FOR_INC]]
; CHECK-IN-LOOP:       for.inc:
; CHECK-IN-LOOP-NEXT:    [[RES]] = phi i32 [ [[RDX]], [[FOR_BODY]] ], [ [[XOR]], [[IF_THEN]] ]
; CHECK-IN-LOOP-NEXT:    [[IV_NEXT]] = add i64 [[IV]], 1
; CHECK-IN-LOOP-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[IV_NEXT]], [[N]]
; CHECK-IN-LOOP-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop [[LOOP7:![0-9]+]]
; CHECK-IN-LOOP:       for.end:
; CHECK-IN-LOOP-NEXT:    [[RES_LCSSA:%.*]] = phi i32 [ [[RES]], [[FOR_INC]] ], [ [[TMP21]], [[MIDDLE_BLOCK]] ]
; CHECK-IN-LOOP-NEXT:    ret i32 [[RES_LCSSA]]
;
entry:
  br label %for.body

for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.inc ]
  %rdx = phi i32 [ 7, %entry ], [ %res, %for.inc ]
  %arrayidx = getelementptr inbounds i32, i32* %cond, i64 %iv
  %0 = load i32, i32* %arrayidx
  %tobool = icmp eq i32 %0, 5
  br i1 %tobool, label %if.then, label %for.inc

if.then:
  %arrayidx2 = getelementptr inbounds i32, i32* %a, i64 %iv
  %1 = load i32, i32* %arrayidx2
  %xor = xor i32 %rdx, %1
  br label %for.inc

for.inc:
  %res = phi i32 [ %rdx, %for.body ], [ %xor, %if.then ]
  %iv.next = add i64 %iv, 1
  %exitcond.not = icmp eq i64 %iv.next, %N
  br i1 %exitcond.not, label %for.end, label %for.body, !llvm.loop !0

for.end:
  ret i32 %res
}

!0 = distinct !{!0, !1, !2}
!1 = !{!"llvm.loop.vectorize.width", i32 4}
!2 = !{!"llvm.loop.vectorize.scalable.enable", i1 true}
!3 = distinct !{!3, !4}
!4 = !{!"llvm.loop.vectorize.width", i32 4}

attributes #0 = { "target-features"="+sve" }
