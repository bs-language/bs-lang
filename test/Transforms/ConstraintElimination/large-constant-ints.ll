; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=constraint-elimination -S %s | FileCheck %s

declare void @use(i1)

define void @test_unsigned_too_large(i128 %x) {
; CHECK-LABEL: @test_unsigned_too_large(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C_1:%.*]] = icmp ule i128 [[X:%.*]], 12345678901234123123123
; CHECK-NEXT:    br i1 [[C_1]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[C_2:%.*]] = icmp ult i128 [[X]], -12345678901234123123123
; CHECK-NEXT:    call void @use(i1 [[C_2]])
; CHECK-NEXT:    [[C_3:%.*]] = icmp uge i128 [[X]], -12345678901234123123123
; CHECK-NEXT:    call void @use(i1 [[C_3]])
; CHECK-NEXT:    [[C_4:%.*]] = icmp uge i128 [[X]], -12345678901234123123123
; CHECK-NEXT:    call void @use(i1 [[C_4]])
; CHECK-NEXT:    ret void
; CHECK:       bb2:
; CHECK-NEXT:    ret void
;
entry:
  %c.1 = icmp ule i128 %x, 12345678901234123123123
  br i1 %c.1, label %bb1, label %bb2

bb1:
  %c.2 = icmp ult i128 %x, -12345678901234123123123
  call void @use(i1 %c.2)
  %c.3 = icmp uge i128 %x, -12345678901234123123123
  call void @use(i1 %c.3)
  %c.4 = icmp uge i128 %x, -12345678901234123123123
  call void @use(i1 %c.4)
  ret void

bb2:
  ret void
}

define void @test_signed_too_large(i128 %x) {
; CHECK-LABEL: @test_signed_too_large(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C_1:%.*]] = icmp sle i128 [[X:%.*]], 12345678901234123123123
; CHECK-NEXT:    br i1 [[C_1]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[C_2:%.*]] = icmp slt i128 [[X]], -12345678901234123123123
; CHECK-NEXT:    call void @use(i1 [[C_2]])
; CHECK-NEXT:    [[C_3:%.*]] = icmp sge i128 [[X]], -12345678901234123123123
; CHECK-NEXT:    call void @use(i1 [[C_3]])
; CHECK-NEXT:    [[C_4:%.*]] = icmp sge i128 [[X]], -12345678901234123123123
; CHECK-NEXT:    call void @use(i1 [[C_4]])
; CHECK-NEXT:    ret void
; CHECK:       bb2:
; CHECK-NEXT:    ret void
;
entry:
  %c.1 = icmp sle i128 %x, 12345678901234123123123
  br i1 %c.1, label %bb1, label %bb2

bb1:
  %c.2 = icmp slt i128 %x, -12345678901234123123123
  call void @use(i1 %c.2)
  %c.3 = icmp sge i128 %x, -12345678901234123123123
  call void @use(i1 %c.3)
  %c.4 = icmp sge i128 %x, -12345678901234123123123
  call void @use(i1 %c.4)
  ret void

bb2:
  ret void
}

define i1 @add_decomp_i80(i80 %a) {
; CHECK-LABEL: @add_decomp_i80(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i80 [[A:%.*]], -1973801615886922022913
; CHECK-NEXT:    [[C:%.*]] = icmp ult i80 [[ADD]], 1346612317380797267967
; CHECK-NEXT:    br i1 [[C]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[ADD_1:%.*]] = add nsw i80 [[A]], -1973801615886922022913
; CHECK-NEXT:    [[C_1:%.*]] = icmp ult i80 [[ADD_1]], 1346612317380797267967
; CHECK-NEXT:    ret i1 [[C_1]]
; CHECK:       else:
; CHECK-NEXT:    ret i1 false
;
entry:
  %add = add nsw i80 %a, -1973801615886922022913
  %c = icmp ult i80 %add, 1346612317380797267967
  br i1 %c, label %then, label %else

then:
  %add.1 = add nsw i80 %a, -1973801615886922022913
  %c.1 = icmp ult i80 %add.1, 1346612317380797267967
  ret i1 %c.1

else:
  ret i1 false
}

define i1 @sub_decomp_i80(i80 %a) {
; CHECK-LABEL: @sub_decomp_i80(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SUB:%.*]] = sub nuw i80 [[A:%.*]], 1973801615886922022913
; CHECK-NEXT:    [[C:%.*]] = icmp ult i80 [[SUB]], 1346612317380797267967
; CHECK-NEXT:    br i1 [[C]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[SUB_1:%.*]] = sub nuw i80 [[A]], 1973801615886922022913
; CHECK-NEXT:    [[C_1:%.*]] = icmp ult i80 [[SUB_1]], 1346612317380797267967
; CHECK-NEXT:    ret i1 true
; CHECK:       else:
; CHECK-NEXT:    ret i1 false
;
entry:
  %sub = sub nuw i80 %a, 1973801615886922022913
  %c = icmp ult i80 %sub, 1346612317380797267967
  br i1 %c, label %then, label %else

then:
  %sub.1 = sub nuw i80 %a, 1973801615886922022913
  %c.1 = icmp ult i80 %sub.1, 1346612317380797267967
  ret i1 %c.1

else:
  ret i1 false
}

define i1 @gep_decomp_i80(ptr %a) {
; CHECK-LABEL: @gep_decomp_i80(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds i8, ptr [[A:%.*]], i80 1973801615886922022913
; CHECK-NEXT:    [[C:%.*]] = icmp eq ptr [[GEP]], null
; CHECK-NEXT:    br i1 [[C]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[GEP_1:%.*]] = getelementptr inbounds i8, ptr [[A]], i80 1973801615886922022913
; CHECK-NEXT:    [[C_1:%.*]] = icmp eq ptr [[GEP_1]], null
; CHECK-NEXT:    ret i1 true
; CHECK:       else:
; CHECK-NEXT:    ret i1 false
;
entry:
  %gep = getelementptr inbounds i8, ptr %a, i80 1973801615886922022913
  %c = icmp eq ptr %gep, null
  br i1 %c, label %then, label %else

then:
  %gep.1 = getelementptr inbounds i8, ptr %a, i80 1973801615886922022913
  %c.1 = icmp eq ptr %gep.1, null
  ret i1 %c.1

else:
  ret i1 false
}

define i1 @gep_zext_shl_decomp_i80(ptr %a, i80 %v) {
; CHECK-LABEL: @gep_zext_shl_decomp_i80(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SHL:%.*]] = shl nuw i80 [[V:%.*]], 1973801615886922022913
; CHECK-NEXT:    [[EXT:%.*]] = zext i80 [[SHL]] to i128
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds i8, ptr [[A:%.*]], i128 [[EXT]]
; CHECK-NEXT:    [[C:%.*]] = icmp eq ptr [[GEP]], null
; CHECK-NEXT:    br i1 [[C]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[SHL_1:%.*]] = shl nuw i80 [[V]], 1973801615886922022913
; CHECK-NEXT:    [[EXT_1:%.*]] = zext i80 [[SHL_1]] to i128
; CHECK-NEXT:    [[GEP_1:%.*]] = getelementptr inbounds i8, ptr [[A]], i128 [[EXT_1]]
; CHECK-NEXT:    [[C_1:%.*]] = icmp eq ptr [[GEP_1]], null
; CHECK-NEXT:    ret i1 [[C_1]]
; CHECK:       else:
; CHECK-NEXT:    ret i1 false
;
entry:
  %shl = shl nuw i80 %v, 1973801615886922022913
  %ext = zext i80 %shl to i128
  %gep = getelementptr inbounds i8, ptr %a, i128 %ext
  %c = icmp eq ptr %gep, null
  br i1 %c, label %then, label %else

then:
  %shl.1 = shl nuw i80 %v, 1973801615886922022913
  %ext.1 = zext i80 %shl.1 to i128
  %gep.1 = getelementptr inbounds i8, ptr %a, i128 %ext.1
  %c.1 = icmp eq ptr %gep.1, null
  ret i1 %c.1

else:
  ret i1 false
}

define i1 @gep_zext_add_decomp_i80(ptr %a, i80 %v) {
; CHECK-LABEL: @gep_zext_add_decomp_i80(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i80 [[V:%.*]], 1973801615886922022913
; CHECK-NEXT:    [[EXT:%.*]] = zext i80 [[ADD]] to i128
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds i8, ptr [[A:%.*]], i128 [[EXT]]
; CHECK-NEXT:    [[C:%.*]] = icmp eq ptr [[GEP]], null
; CHECK-NEXT:    br i1 [[C]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[ADD_1:%.*]] = add nsw i80 [[V]], 1973801615886922022913
; CHECK-NEXT:    [[EXT_1:%.*]] = zext i80 [[ADD_1]] to i128
; CHECK-NEXT:    [[GEP_1:%.*]] = getelementptr inbounds i8, ptr [[A]], i128 [[EXT_1]]
; CHECK-NEXT:    [[C_1:%.*]] = icmp eq ptr [[GEP_1]], null
; CHECK-NEXT:    ret i1 [[C_1]]
; CHECK:       else:
; CHECK-NEXT:    ret i1 false
;
entry:
  %add = add nsw i80 %v, 1973801615886922022913
  %ext = zext i80 %add to i128
  %gep = getelementptr inbounds i8, ptr %a, i128 %ext
  %c = icmp eq ptr %gep, null
  br i1 %c, label %then, label %else

then:
  %add.1 = add nsw i80 %v, 1973801615886922022913
  %ext.1 = zext i80 %add.1 to i128
  %gep.1 = getelementptr inbounds i8, ptr %a, i128 %ext.1
  %c.1 = icmp eq ptr %gep.1, null
  ret i1 %c.1

else:
  ret i1 false
}

define i1 @gep_shl_decomp_i80(ptr %a, i80 %v) {
; CHECK-LABEL: @gep_shl_decomp_i80(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SHL:%.*]] = shl nuw i80 [[V:%.*]], 1973801615886922022913
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds i8, ptr [[A:%.*]], i80 [[SHL]]
; CHECK-NEXT:    [[C:%.*]] = icmp eq ptr [[GEP]], null
; CHECK-NEXT:    br i1 [[C]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[SHL_1:%.*]] = shl nuw i80 [[V]], 1973801615886922022913
; CHECK-NEXT:    [[GEP_1:%.*]] = getelementptr inbounds i8, ptr [[A]], i80 [[SHL_1]]
; CHECK-NEXT:    [[C_1:%.*]] = icmp eq ptr [[GEP_1]], null
; CHECK-NEXT:    ret i1 [[C_1]]
; CHECK:       else:
; CHECK-NEXT:    ret i1 false
;
entry:
  %shl = shl nuw i80 %v, 1973801615886922022913
  %gep = getelementptr inbounds i8, ptr %a, i80 %shl
  %c = icmp eq ptr %gep, null
  br i1 %c, label %then, label %else

then:
  %shl.1 = shl nuw i80 %v, 1973801615886922022913
  %gep.1 = getelementptr inbounds i8, ptr %a, i80 %shl.1
  %c.1 = icmp eq ptr %gep.1, null
  ret i1 %c.1

else:
  ret i1 false
}

define i1 @gep_add_decomp_i80(ptr %a, i80 %v) {
; CHECK-LABEL: @gep_add_decomp_i80(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i80 [[V:%.*]], 1973801615886922022913
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds i8, ptr [[A:%.*]], i80 [[ADD]]
; CHECK-NEXT:    [[C:%.*]] = icmp eq ptr [[GEP]], null
; CHECK-NEXT:    br i1 [[C]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[ADD_1:%.*]] = add nsw i80 [[V]], 1973801615886922022913
; CHECK-NEXT:    [[GEP_1:%.*]] = getelementptr inbounds i8, ptr [[A]], i80 [[ADD_1]]
; CHECK-NEXT:    [[C_1:%.*]] = icmp eq ptr [[GEP_1]], null
; CHECK-NEXT:    ret i1 [[C_1]]
; CHECK:       else:
; CHECK-NEXT:    ret i1 false
;
entry:
  %add = add nsw i80 %v, 1973801615886922022913
  %gep = getelementptr inbounds i8, ptr %a, i80 %add
  %c = icmp eq ptr %gep, null
  br i1 %c, label %then, label %else

then:
  %add.1 = add nsw i80 %v, 1973801615886922022913
  %gep.1 = getelementptr inbounds i8, ptr %a, i80 %add.1
  %c.1 = icmp eq ptr %gep.1, null
  ret i1 %c.1

else:
  ret i1 false
}

define i1 @add_nuw_decomp_recursive() {
; CHECK-LABEL: @add_nuw_decomp_recursive(
; CHECK-NEXT:    [[ADD:%.*]] = add nuw nsw i64 -9223372036854775808, 10
; CHECK-NEXT:    [[CMP:%.*]] = icmp uge i64 [[ADD]], 10
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %add = add nuw nsw i64 -9223372036854775808, 10
  %cmp = icmp uge i64 %add, 10
  ret i1 %cmp
}

define i1 @add_minus_one_decomp_recursive() {
; CHECK-LABEL: @add_minus_one_decomp_recursive(
; CHECK-NEXT:    [[ADD:%.*]] = add i64 -9223372036854775808, -1
; CHECK-NEXT:    [[CMP:%.*]] = icmp uge i64 [[ADD]], 10
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %add = add i64 -9223372036854775808, -1
  %cmp = icmp uge i64 %add, 10
  ret i1 %cmp
}

define i1 @gep_decomp_large_index_31_bits(ptr %a) {
; CHECK-LABEL: @gep_decomp_large_index_31_bits(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[GEP_1:%.*]] = getelementptr inbounds i64, ptr [[A:%.*]], i64 2147483646
; CHECK-NEXT:    [[GEP_2:%.*]] = getelementptr inbounds i64, ptr [[A]], i64 2147483647
; CHECK-NEXT:    [[NE:%.*]] = icmp ne ptr [[GEP_1]], [[GEP_2]]
; CHECK-NEXT:    call void @llvm.assume(i1 [[NE]])
; CHECK-NEXT:    [[CMP_ULE:%.*]] = icmp ule ptr [[GEP_1]], [[GEP_2]]
; CHECK-NEXT:    [[CMP_UGE:%.*]] = icmp uge ptr [[GEP_1]], [[GEP_2]]
; CHECK-NEXT:    [[RES:%.*]] = xor i1 true, false
; CHECK-NEXT:    ret i1 [[RES]]
;
entry:
  %gep.1 = getelementptr inbounds i64, ptr %a, i64 2147483646
  %gep.2 = getelementptr inbounds i64, ptr %a, i64 2147483647
  %ne = icmp ne ptr %gep.1, %gep.2
  call void @llvm.assume(i1 %ne)
  %cmp.ule = icmp ule ptr %gep.1, %gep.2
  %cmp.uge = icmp uge ptr %gep.1, %gep.2
  %res = xor i1 true, false
  ret i1 %res
}

define i1 @gep_decomp_large_index_63_bits(ptr %a) {
; CHECK-LABEL: @gep_decomp_large_index_63_bits(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[GEP_1:%.*]] = getelementptr inbounds i64, ptr [[A:%.*]], i64 9223372036854775804
; CHECK-NEXT:    [[GEP_2:%.*]] = getelementptr inbounds i64, ptr [[A]], i64 9223372036854775805
; CHECK-NEXT:    [[NE:%.*]] = icmp ne ptr [[GEP_1]], [[GEP_2]]
; CHECK-NEXT:    call void @llvm.assume(i1 [[NE]])
; CHECK-NEXT:    [[CMP_ULE:%.*]] = icmp ule ptr [[GEP_1]], [[GEP_2]]
; CHECK-NEXT:    [[CMP_UGE:%.*]] = icmp uge ptr [[GEP_1]], [[GEP_2]]
; CHECK-NEXT:    [[RES:%.*]] = xor i1 true, true
; CHECK-NEXT:    ret i1 [[RES]]
;
entry:
  %gep.1 = getelementptr inbounds i64, ptr %a, i64 9223372036854775804
  %gep.2 = getelementptr inbounds i64, ptr %a, i64 9223372036854775805
  %ne = icmp ne ptr %gep.1, %gep.2
  call void @llvm.assume(i1 %ne)
  %cmp.ule = icmp ule ptr %gep.1, %gep.2
  %cmp.uge = icmp uge ptr %gep.1, %gep.2
  %res = xor i1 %cmp.ule, %cmp.ule
  ret i1 %res
}

define i1 @gep_decomp_large_index_63_bits_chained_overflow(ptr %a) {
; CHECK-LABEL: @gep_decomp_large_index_63_bits_chained_overflow(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[GEP_1:%.*]] = getelementptr inbounds i64, ptr [[A:%.*]], i64 9223372036854775804
; CHECK-NEXT:    [[GEP_2:%.*]] = getelementptr inbounds ptr, ptr [[A]], i64 1152921504606846976
; CHECK-NEXT:    [[GEP_3:%.*]] = getelementptr inbounds i64, ptr [[GEP_2]], i64 1152921504606846976
; CHECK-NEXT:    [[NE:%.*]] = icmp ne ptr [[GEP_1]], [[GEP_3]]
; CHECK-NEXT:    call void @llvm.assume(i1 [[NE]])
; CHECK-NEXT:    [[CMP_ULE:%.*]] = icmp ule ptr [[GEP_1]], [[GEP_3]]
; CHECK-NEXT:    [[CMP_UGE:%.*]] = icmp uge ptr [[GEP_1]], [[GEP_3]]
; CHECK-NEXT:    [[RES:%.*]] = xor i1 true, true
; CHECK-NEXT:    ret i1 [[RES]]
;
entry:
  %gep.1 = getelementptr inbounds i64, ptr %a, i64 9223372036854775804
  %gep.2 = getelementptr inbounds ptr, ptr %a, i64 1152921504606846976
  %gep.3 = getelementptr inbounds i64, ptr %gep.2, i64 1152921504606846976
  %ne = icmp ne ptr %gep.1, %gep.3
  call void @llvm.assume(i1 %ne)
  %cmp.ule = icmp ule ptr %gep.1, %gep.3
  %cmp.uge = icmp uge ptr %gep.1, %gep.3
  %res = xor i1 %cmp.ule, %cmp.ule
  ret i1 %res
}

%struct = type { [128 x i64], [2 x i32] }

define i1 @gep_decomp_large_index_63_bits_overflow_struct(ptr %a) {
; CHECK-LABEL: @gep_decomp_large_index_63_bits_overflow_struct(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[GEP_1:%.*]] = getelementptr inbounds i64, ptr [[A:%.*]], i64 9223372036854775804
; CHECK-NEXT:    [[GEP_2:%.*]] = getelementptr inbounds [[STRUCT:%.*]], ptr [[A]], i64 8937376004704240, i32 1, i32 1
; CHECK-NEXT:    [[NE:%.*]] = icmp ne ptr [[GEP_1]], [[GEP_2]]
; CHECK-NEXT:    call void @llvm.assume(i1 [[NE]])
; CHECK-NEXT:    [[CMP_ULE:%.*]] = icmp ule ptr [[GEP_1]], [[GEP_2]]
; CHECK-NEXT:    [[CMP_UGE:%.*]] = icmp uge ptr [[GEP_1]], [[GEP_2]]
; CHECK-NEXT:    [[RES:%.*]] = xor i1 false, false
; CHECK-NEXT:    ret i1 [[RES]]
;
entry:
  %gep.1 = getelementptr inbounds i64, ptr %a, i64 9223372036854775804
  %gep.2 = getelementptr inbounds %struct, ptr %a, i64 8937376004704240, i32 1, i32 1
  %ne = icmp ne ptr %gep.1, %gep.2
  call void @llvm.assume(i1 %ne)
  %cmp.ule = icmp ule ptr %gep.1, %gep.2
  %cmp.uge = icmp uge ptr %gep.1, %gep.2
  %res = xor i1 %cmp.ule, %cmp.ule
  ret i1 %res
}

declare void @llvm.assume(i1)
