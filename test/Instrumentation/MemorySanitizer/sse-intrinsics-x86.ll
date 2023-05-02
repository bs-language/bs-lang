; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt %s -S -passes=msan 2>&1 | FileCheck %s

target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define <4 x float> @test_x86_sse_cmp_ps(<4 x float> %a0, <4 x float> %a1) #0 {
; CHECK-LABEL: @test_x86_sse_cmp_ps(
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x i32>, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 16) to ptr), align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    [[TMP3:%.*]] = or <4 x i32> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = icmp ne <4 x i32> [[TMP3]], zeroinitializer
; CHECK-NEXT:    [[TMP5:%.*]] = sext <4 x i1> [[TMP4]] to <4 x i32>
; CHECK-NEXT:    [[RES:%.*]] = call <4 x float> @llvm.x86.sse.cmp.ps(<4 x float> [[A0:%.*]], <4 x float> [[A1:%.*]], i8 7)
; CHECK-NEXT:    store <4 x i32> [[TMP5]], ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret <4 x float> [[RES]]
;
  %res = call <4 x float> @llvm.x86.sse.cmp.ps(<4 x float> %a0, <4 x float> %a1, i8 7) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.sse.cmp.ps(<4 x float>, <4 x float>, i8) nounwind readnone


define <4 x float> @test_x86_sse_cmp_ss(<4 x float> %a0, <4 x float> %a1) #0 {
; CHECK-LABEL: @test_x86_sse_cmp_ss(
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x i32>, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 16) to ptr), align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    [[TMP3:%.*]] = or <4 x i32> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <4 x i32> [[TMP3]], i64 0
; CHECK-NEXT:    [[TMP5:%.*]] = icmp ne i32 [[TMP4]], 0
; CHECK-NEXT:    [[TMP6:%.*]] = sext i1 [[TMP5]] to i128
; CHECK-NEXT:    [[TMP7:%.*]] = bitcast i128 [[TMP6]] to <4 x i32>
; CHECK-NEXT:    [[RES:%.*]] = call <4 x float> @llvm.x86.sse.cmp.ss(<4 x float> [[A0:%.*]], <4 x float> [[A1:%.*]], i8 7)
; CHECK-NEXT:    store <4 x i32> [[TMP7]], ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret <4 x float> [[RES]]
;
  %res = call <4 x float> @llvm.x86.sse.cmp.ss(<4 x float> %a0, <4 x float> %a1, i8 7) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.sse.cmp.ss(<4 x float>, <4 x float>, i8) nounwind readnone


define i32 @test_x86_sse_comieq_ss(<4 x float> %a0, <4 x float> %a1) #0 {
; CHECK-LABEL: @test_x86_sse_comieq_ss(
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x i32>, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 16) to ptr), align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    [[TMP3:%.*]] = or <4 x i32> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <4 x i32> [[TMP3]], i64 0
; CHECK-NEXT:    [[TMP5:%.*]] = icmp ne i32 [[TMP4]], 0
; CHECK-NEXT:    [[TMP6:%.*]] = sext i1 [[TMP5]] to i32
; CHECK-NEXT:    [[RES:%.*]] = call i32 @llvm.x86.sse.comieq.ss(<4 x float> [[A0:%.*]], <4 x float> [[A1:%.*]])
; CHECK-NEXT:    store i32 [[TMP6]], ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret i32 [[RES]]
;
  %res = call i32 @llvm.x86.sse.comieq.ss(<4 x float> %a0, <4 x float> %a1) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse.comieq.ss(<4 x float>, <4 x float>) nounwind readnone


define i32 @test_x86_sse_comige_ss(<4 x float> %a0, <4 x float> %a1) #0 {
; CHECK-LABEL: @test_x86_sse_comige_ss(
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x i32>, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 16) to ptr), align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    [[TMP3:%.*]] = or <4 x i32> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <4 x i32> [[TMP3]], i64 0
; CHECK-NEXT:    [[TMP5:%.*]] = icmp ne i32 [[TMP4]], 0
; CHECK-NEXT:    [[TMP6:%.*]] = sext i1 [[TMP5]] to i32
; CHECK-NEXT:    [[RES:%.*]] = call i32 @llvm.x86.sse.comige.ss(<4 x float> [[A0:%.*]], <4 x float> [[A1:%.*]])
; CHECK-NEXT:    store i32 [[TMP6]], ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret i32 [[RES]]
;
  %res = call i32 @llvm.x86.sse.comige.ss(<4 x float> %a0, <4 x float> %a1) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse.comige.ss(<4 x float>, <4 x float>) nounwind readnone


define i32 @test_x86_sse_comigt_ss(<4 x float> %a0, <4 x float> %a1) #0 {
; CHECK-LABEL: @test_x86_sse_comigt_ss(
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x i32>, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 16) to ptr), align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    [[TMP3:%.*]] = or <4 x i32> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <4 x i32> [[TMP3]], i64 0
; CHECK-NEXT:    [[TMP5:%.*]] = icmp ne i32 [[TMP4]], 0
; CHECK-NEXT:    [[TMP6:%.*]] = sext i1 [[TMP5]] to i32
; CHECK-NEXT:    [[RES:%.*]] = call i32 @llvm.x86.sse.comigt.ss(<4 x float> [[A0:%.*]], <4 x float> [[A1:%.*]])
; CHECK-NEXT:    store i32 [[TMP6]], ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret i32 [[RES]]
;
  %res = call i32 @llvm.x86.sse.comigt.ss(<4 x float> %a0, <4 x float> %a1) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse.comigt.ss(<4 x float>, <4 x float>) nounwind readnone


define i32 @test_x86_sse_comile_ss(<4 x float> %a0, <4 x float> %a1) #0 {
; CHECK-LABEL: @test_x86_sse_comile_ss(
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x i32>, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 16) to ptr), align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    [[TMP3:%.*]] = or <4 x i32> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <4 x i32> [[TMP3]], i64 0
; CHECK-NEXT:    [[TMP5:%.*]] = icmp ne i32 [[TMP4]], 0
; CHECK-NEXT:    [[TMP6:%.*]] = sext i1 [[TMP5]] to i32
; CHECK-NEXT:    [[RES:%.*]] = call i32 @llvm.x86.sse.comile.ss(<4 x float> [[A0:%.*]], <4 x float> [[A1:%.*]])
; CHECK-NEXT:    store i32 [[TMP6]], ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret i32 [[RES]]
;
  %res = call i32 @llvm.x86.sse.comile.ss(<4 x float> %a0, <4 x float> %a1) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse.comile.ss(<4 x float>, <4 x float>) nounwind readnone


define i32 @test_x86_sse_comilt_ss(<4 x float> %a0, <4 x float> %a1) #0 {
; CHECK-LABEL: @test_x86_sse_comilt_ss(
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x i32>, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 16) to ptr), align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    [[TMP3:%.*]] = or <4 x i32> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <4 x i32> [[TMP3]], i64 0
; CHECK-NEXT:    [[TMP5:%.*]] = icmp ne i32 [[TMP4]], 0
; CHECK-NEXT:    [[TMP6:%.*]] = sext i1 [[TMP5]] to i32
; CHECK-NEXT:    [[RES:%.*]] = call i32 @llvm.x86.sse.comilt.ss(<4 x float> [[A0:%.*]], <4 x float> [[A1:%.*]])
; CHECK-NEXT:    store i32 [[TMP6]], ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret i32 [[RES]]
;
  %res = call i32 @llvm.x86.sse.comilt.ss(<4 x float> %a0, <4 x float> %a1) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse.comilt.ss(<4 x float>, <4 x float>) nounwind readnone


define i32 @test_x86_sse_comineq_ss(<4 x float> %a0, <4 x float> %a1) #0 {
; CHECK-LABEL: @test_x86_sse_comineq_ss(
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x i32>, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 16) to ptr), align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    [[TMP3:%.*]] = or <4 x i32> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <4 x i32> [[TMP3]], i64 0
; CHECK-NEXT:    [[TMP5:%.*]] = icmp ne i32 [[TMP4]], 0
; CHECK-NEXT:    [[TMP6:%.*]] = sext i1 [[TMP5]] to i32
; CHECK-NEXT:    [[RES:%.*]] = call i32 @llvm.x86.sse.comineq.ss(<4 x float> [[A0:%.*]], <4 x float> [[A1:%.*]])
; CHECK-NEXT:    store i32 [[TMP6]], ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret i32 [[RES]]
;
  %res = call i32 @llvm.x86.sse.comineq.ss(<4 x float> %a0, <4 x float> %a1) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse.comineq.ss(<4 x float>, <4 x float>) nounwind readnone


define i32 @test_x86_sse_cvtss2si(<4 x float> %a0) #0 {
; CHECK-LABEL: @test_x86_sse_cvtss2si(
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    [[TMP2:%.*]] = extractelement <4 x i32> [[TMP1]], i32 0
; CHECK-NEXT:    [[_MSCMP:%.*]] = icmp ne i32 [[TMP2]], 0
; CHECK-NEXT:    br i1 [[_MSCMP]], label [[TMP3:%.*]], label [[TMP4:%.*]], !prof [[PROF0:![0-9]+]]
; CHECK:       3:
; CHECK-NEXT:    call void @__msan_warning_noreturn() #[[ATTR5:[0-9]+]]
; CHECK-NEXT:    unreachable
; CHECK:       4:
; CHECK-NEXT:    [[RES:%.*]] = call i32 @llvm.x86.sse.cvtss2si(<4 x float> [[A0:%.*]])
; CHECK-NEXT:    store i32 0, ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret i32 [[RES]]
;
  %res = call i32 @llvm.x86.sse.cvtss2si(<4 x float> %a0) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse.cvtss2si(<4 x float>) nounwind readnone


define i32 @test_x86_sse_cvttss2si(<4 x float> %a0) #0 {
; CHECK-LABEL: @test_x86_sse_cvttss2si(
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    [[TMP2:%.*]] = extractelement <4 x i32> [[TMP1]], i32 0
; CHECK-NEXT:    [[_MSCMP:%.*]] = icmp ne i32 [[TMP2]], 0
; CHECK-NEXT:    br i1 [[_MSCMP]], label [[TMP3:%.*]], label [[TMP4:%.*]], !prof [[PROF0]]
; CHECK:       3:
; CHECK-NEXT:    call void @__msan_warning_noreturn() #[[ATTR5]]
; CHECK-NEXT:    unreachable
; CHECK:       4:
; CHECK-NEXT:    [[RES:%.*]] = call i32 @llvm.x86.sse.cvttss2si(<4 x float> [[A0:%.*]])
; CHECK-NEXT:    store i32 0, ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret i32 [[RES]]
;
  %res = call i32 @llvm.x86.sse.cvttss2si(<4 x float> %a0) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse.cvttss2si(<4 x float>) nounwind readnone


define void @test_x86_sse_ldmxcsr(ptr %a0) #0 {
; CHECK-LABEL: @test_x86_sse_ldmxcsr(
; CHECK-NEXT:    [[TMP1:%.*]] = load i64, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    [[TMP2:%.*]] = ptrtoint ptr [[A0:%.*]] to i64
; CHECK-NEXT:    [[TMP3:%.*]] = xor i64 [[TMP2]], 87960930222080
; CHECK-NEXT:    [[TMP4:%.*]] = inttoptr i64 [[TMP3]] to ptr
; CHECK-NEXT:    [[_LDMXCSR:%.*]] = load i32, ptr [[TMP4]], align 1
; CHECK-NEXT:    [[_MSCMP:%.*]] = icmp ne i64 [[TMP1]], 0
; CHECK-NEXT:    [[_MSCMP1:%.*]] = icmp ne i32 [[_LDMXCSR]], 0
; CHECK-NEXT:    [[_MSOR:%.*]] = or i1 [[_MSCMP]], [[_MSCMP1]]
; CHECK-NEXT:    br i1 [[_MSOR]], label [[TMP5:%.*]], label [[TMP6:%.*]], !prof [[PROF0]]
; CHECK:       5:
; CHECK-NEXT:    call void @__msan_warning_noreturn() #[[ATTR5]]
; CHECK-NEXT:    unreachable
; CHECK:       6:
; CHECK-NEXT:    call void @llvm.x86.sse.ldmxcsr(ptr [[A0]])
; CHECK-NEXT:    ret void
;
  call void @llvm.x86.sse.ldmxcsr(ptr %a0)
  ret void
}
declare void @llvm.x86.sse.ldmxcsr(ptr) nounwind



define <4 x float> @test_x86_sse_max_ps(<4 x float> %a0, <4 x float> %a1) #0 {
; CHECK-LABEL: @test_x86_sse_max_ps(
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x i32>, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 16) to ptr), align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    [[_MSPROP:%.*]] = or <4 x i32> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[RES:%.*]] = call <4 x float> @llvm.x86.sse.max.ps(<4 x float> [[A0:%.*]], <4 x float> [[A1:%.*]])
; CHECK-NEXT:    store <4 x i32> [[_MSPROP]], ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret <4 x float> [[RES]]
;
  %res = call <4 x float> @llvm.x86.sse.max.ps(<4 x float> %a0, <4 x float> %a1) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.sse.max.ps(<4 x float>, <4 x float>) nounwind readnone


define <4 x float> @test_x86_sse_max_ss(<4 x float> %a0, <4 x float> %a1) #0 {
; CHECK-LABEL: @test_x86_sse_max_ss(
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x i32>, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 16) to ptr), align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    [[TMP3:%.*]] = or <4 x i32> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = shufflevector <4 x i32> [[TMP1]], <4 x i32> [[TMP3]], <4 x i32> <i32 4, i32 1, i32 2, i32 3>
; CHECK-NEXT:    [[RES:%.*]] = call <4 x float> @llvm.x86.sse.max.ss(<4 x float> [[A0:%.*]], <4 x float> [[A1:%.*]])
; CHECK-NEXT:    store <4 x i32> [[TMP4]], ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret <4 x float> [[RES]]
;
  %res = call <4 x float> @llvm.x86.sse.max.ss(<4 x float> %a0, <4 x float> %a1) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.sse.max.ss(<4 x float>, <4 x float>) nounwind readnone


define <4 x float> @test_x86_sse_min_ps(<4 x float> %a0, <4 x float> %a1) #0 {
; CHECK-LABEL: @test_x86_sse_min_ps(
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x i32>, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 16) to ptr), align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    [[_MSPROP:%.*]] = or <4 x i32> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[RES:%.*]] = call <4 x float> @llvm.x86.sse.min.ps(<4 x float> [[A0:%.*]], <4 x float> [[A1:%.*]])
; CHECK-NEXT:    store <4 x i32> [[_MSPROP]], ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret <4 x float> [[RES]]
;
  %res = call <4 x float> @llvm.x86.sse.min.ps(<4 x float> %a0, <4 x float> %a1) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.sse.min.ps(<4 x float>, <4 x float>) nounwind readnone


define <4 x float> @test_x86_sse_min_ss(<4 x float> %a0, <4 x float> %a1) #0 {
; CHECK-LABEL: @test_x86_sse_min_ss(
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x i32>, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 16) to ptr), align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    [[TMP3:%.*]] = or <4 x i32> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = shufflevector <4 x i32> [[TMP1]], <4 x i32> [[TMP3]], <4 x i32> <i32 4, i32 1, i32 2, i32 3>
; CHECK-NEXT:    [[RES:%.*]] = call <4 x float> @llvm.x86.sse.min.ss(<4 x float> [[A0:%.*]], <4 x float> [[A1:%.*]])
; CHECK-NEXT:    store <4 x i32> [[TMP4]], ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret <4 x float> [[RES]]
;
  %res = call <4 x float> @llvm.x86.sse.min.ss(<4 x float> %a0, <4 x float> %a1) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.sse.min.ss(<4 x float>, <4 x float>) nounwind readnone


define i32 @test_x86_sse_movmsk_ps(<4 x float> %a0) #0 {
; CHECK-LABEL: @test_x86_sse_movmsk_ps(
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast <4 x i32> [[TMP1]] to i128
; CHECK-NEXT:    [[_MSCMP:%.*]] = icmp ne i128 [[TMP2]], 0
; CHECK-NEXT:    br i1 [[_MSCMP]], label [[TMP3:%.*]], label [[TMP4:%.*]], !prof [[PROF0]]
; CHECK:       3:
; CHECK-NEXT:    call void @__msan_warning_noreturn() #[[ATTR5]]
; CHECK-NEXT:    unreachable
; CHECK:       4:
; CHECK-NEXT:    [[RES:%.*]] = call i32 @llvm.x86.sse.movmsk.ps(<4 x float> [[A0:%.*]])
; CHECK-NEXT:    store i32 0, ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret i32 [[RES]]
;
  %res = call i32 @llvm.x86.sse.movmsk.ps(<4 x float> %a0) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse.movmsk.ps(<4 x float>) nounwind readnone



define <4 x float> @test_x86_sse_rcp_ps(<4 x float> %a0) #0 {
; CHECK-LABEL: @test_x86_sse_rcp_ps(
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    [[RES:%.*]] = call <4 x float> @llvm.x86.sse.rcp.ps(<4 x float> [[A0:%.*]])
; CHECK-NEXT:    store <4 x i32> [[TMP1]], ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret <4 x float> [[RES]]
;
  %res = call <4 x float> @llvm.x86.sse.rcp.ps(<4 x float> %a0) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.sse.rcp.ps(<4 x float>) nounwind readnone


define <4 x float> @test_x86_sse_rcp_ss(<4 x float> %a0) #0 {
; CHECK-LABEL: @test_x86_sse_rcp_ss(
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    [[RES:%.*]] = call <4 x float> @llvm.x86.sse.rcp.ss(<4 x float> [[A0:%.*]])
; CHECK-NEXT:    store <4 x i32> [[TMP1]], ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret <4 x float> [[RES]]
;
  %res = call <4 x float> @llvm.x86.sse.rcp.ss(<4 x float> %a0) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.sse.rcp.ss(<4 x float>) nounwind readnone


define <4 x float> @test_x86_sse_rsqrt_ps(<4 x float> %a0) #0 {
; CHECK-LABEL: @test_x86_sse_rsqrt_ps(
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    [[RES:%.*]] = call <4 x float> @llvm.x86.sse.rsqrt.ps(<4 x float> [[A0:%.*]])
; CHECK-NEXT:    store <4 x i32> [[TMP1]], ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret <4 x float> [[RES]]
;
  %res = call <4 x float> @llvm.x86.sse.rsqrt.ps(<4 x float> %a0) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.sse.rsqrt.ps(<4 x float>) nounwind readnone


define <4 x float> @test_x86_sse_rsqrt_ss(<4 x float> %a0) #0 {
; CHECK-LABEL: @test_x86_sse_rsqrt_ss(
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    [[RES:%.*]] = call <4 x float> @llvm.x86.sse.rsqrt.ss(<4 x float> [[A0:%.*]])
; CHECK-NEXT:    store <4 x i32> [[TMP1]], ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret <4 x float> [[RES]]
;
  %res = call <4 x float> @llvm.x86.sse.rsqrt.ss(<4 x float> %a0) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.sse.rsqrt.ss(<4 x float>) nounwind readnone


define void @test_x86_sse_stmxcsr(ptr %a0) #0 {
; CHECK-LABEL: @test_x86_sse_stmxcsr(
; CHECK-NEXT:    [[TMP1:%.*]] = load i64, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    [[TMP2:%.*]] = ptrtoint ptr [[A0:%.*]] to i64
; CHECK-NEXT:    [[TMP3:%.*]] = xor i64 [[TMP2]], 87960930222080
; CHECK-NEXT:    [[TMP4:%.*]] = inttoptr i64 [[TMP3]] to ptr
; CHECK-NEXT:    store i32 0, ptr [[TMP4]], align 4
; CHECK-NEXT:    [[_MSCMP:%.*]] = icmp ne i64 [[TMP1]], 0
; CHECK-NEXT:    br i1 [[_MSCMP]], label [[TMP5:%.*]], label [[TMP6:%.*]], !prof [[PROF0]]
; CHECK:       5:
; CHECK-NEXT:    call void @__msan_warning_noreturn() #[[ATTR5]]
; CHECK-NEXT:    unreachable
; CHECK:       6:
; CHECK-NEXT:    call void @llvm.x86.sse.stmxcsr(ptr [[A0]])
; CHECK-NEXT:    ret void
;
  call void @llvm.x86.sse.stmxcsr(ptr %a0)
  ret void
}
declare void @llvm.x86.sse.stmxcsr(ptr) nounwind


define i32 @test_x86_sse_ucomieq_ss(<4 x float> %a0, <4 x float> %a1) #0 {
; CHECK-LABEL: @test_x86_sse_ucomieq_ss(
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x i32>, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 16) to ptr), align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    [[TMP3:%.*]] = or <4 x i32> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <4 x i32> [[TMP3]], i64 0
; CHECK-NEXT:    [[TMP5:%.*]] = icmp ne i32 [[TMP4]], 0
; CHECK-NEXT:    [[TMP6:%.*]] = sext i1 [[TMP5]] to i32
; CHECK-NEXT:    [[RES:%.*]] = call i32 @llvm.x86.sse.ucomieq.ss(<4 x float> [[A0:%.*]], <4 x float> [[A1:%.*]])
; CHECK-NEXT:    store i32 [[TMP6]], ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret i32 [[RES]]
;
  %res = call i32 @llvm.x86.sse.ucomieq.ss(<4 x float> %a0, <4 x float> %a1) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse.ucomieq.ss(<4 x float>, <4 x float>) nounwind readnone


define i32 @test_x86_sse_ucomige_ss(<4 x float> %a0, <4 x float> %a1) #0 {
; CHECK-LABEL: @test_x86_sse_ucomige_ss(
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x i32>, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 16) to ptr), align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    [[TMP3:%.*]] = or <4 x i32> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <4 x i32> [[TMP3]], i64 0
; CHECK-NEXT:    [[TMP5:%.*]] = icmp ne i32 [[TMP4]], 0
; CHECK-NEXT:    [[TMP6:%.*]] = sext i1 [[TMP5]] to i32
; CHECK-NEXT:    [[RES:%.*]] = call i32 @llvm.x86.sse.ucomige.ss(<4 x float> [[A0:%.*]], <4 x float> [[A1:%.*]])
; CHECK-NEXT:    store i32 [[TMP6]], ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret i32 [[RES]]
;
  %res = call i32 @llvm.x86.sse.ucomige.ss(<4 x float> %a0, <4 x float> %a1) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse.ucomige.ss(<4 x float>, <4 x float>) nounwind readnone


define i32 @test_x86_sse_ucomigt_ss(<4 x float> %a0, <4 x float> %a1) #0 {
; CHECK-LABEL: @test_x86_sse_ucomigt_ss(
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x i32>, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 16) to ptr), align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    [[TMP3:%.*]] = or <4 x i32> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <4 x i32> [[TMP3]], i64 0
; CHECK-NEXT:    [[TMP5:%.*]] = icmp ne i32 [[TMP4]], 0
; CHECK-NEXT:    [[TMP6:%.*]] = sext i1 [[TMP5]] to i32
; CHECK-NEXT:    [[RES:%.*]] = call i32 @llvm.x86.sse.ucomigt.ss(<4 x float> [[A0:%.*]], <4 x float> [[A1:%.*]])
; CHECK-NEXT:    store i32 [[TMP6]], ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret i32 [[RES]]
;
  %res = call i32 @llvm.x86.sse.ucomigt.ss(<4 x float> %a0, <4 x float> %a1) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse.ucomigt.ss(<4 x float>, <4 x float>) nounwind readnone


define i32 @test_x86_sse_ucomile_ss(<4 x float> %a0, <4 x float> %a1) #0 {
; CHECK-LABEL: @test_x86_sse_ucomile_ss(
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x i32>, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 16) to ptr), align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    [[TMP3:%.*]] = or <4 x i32> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <4 x i32> [[TMP3]], i64 0
; CHECK-NEXT:    [[TMP5:%.*]] = icmp ne i32 [[TMP4]], 0
; CHECK-NEXT:    [[TMP6:%.*]] = sext i1 [[TMP5]] to i32
; CHECK-NEXT:    [[RES:%.*]] = call i32 @llvm.x86.sse.ucomile.ss(<4 x float> [[A0:%.*]], <4 x float> [[A1:%.*]])
; CHECK-NEXT:    store i32 [[TMP6]], ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret i32 [[RES]]
;
  %res = call i32 @llvm.x86.sse.ucomile.ss(<4 x float> %a0, <4 x float> %a1) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse.ucomile.ss(<4 x float>, <4 x float>) nounwind readnone


define i32 @test_x86_sse_ucomilt_ss(<4 x float> %a0, <4 x float> %a1) #0 {
; CHECK-LABEL: @test_x86_sse_ucomilt_ss(
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x i32>, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 16) to ptr), align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    [[TMP3:%.*]] = or <4 x i32> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <4 x i32> [[TMP3]], i64 0
; CHECK-NEXT:    [[TMP5:%.*]] = icmp ne i32 [[TMP4]], 0
; CHECK-NEXT:    [[TMP6:%.*]] = sext i1 [[TMP5]] to i32
; CHECK-NEXT:    [[RES:%.*]] = call i32 @llvm.x86.sse.ucomilt.ss(<4 x float> [[A0:%.*]], <4 x float> [[A1:%.*]])
; CHECK-NEXT:    store i32 [[TMP6]], ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret i32 [[RES]]
;
  %res = call i32 @llvm.x86.sse.ucomilt.ss(<4 x float> %a0, <4 x float> %a1) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse.ucomilt.ss(<4 x float>, <4 x float>) nounwind readnone


define i32 @test_x86_sse_ucomineq_ss(<4 x float> %a0, <4 x float> %a1) #0 {
; CHECK-LABEL: @test_x86_sse_ucomineq_ss(
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i32>, ptr @__msan_param_tls, align 8
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x i32>, ptr inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 16) to ptr), align 8
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    [[TMP3:%.*]] = or <4 x i32> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <4 x i32> [[TMP3]], i64 0
; CHECK-NEXT:    [[TMP5:%.*]] = icmp ne i32 [[TMP4]], 0
; CHECK-NEXT:    [[TMP6:%.*]] = sext i1 [[TMP5]] to i32
; CHECK-NEXT:    [[RES:%.*]] = call i32 @llvm.x86.sse.ucomineq.ss(<4 x float> [[A0:%.*]], <4 x float> [[A1:%.*]])
; CHECK-NEXT:    store i32 [[TMP6]], ptr @__msan_retval_tls, align 8
; CHECK-NEXT:    ret i32 [[RES]]
;
  %res = call i32 @llvm.x86.sse.ucomineq.ss(<4 x float> %a0, <4 x float> %a1) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse.ucomineq.ss(<4 x float>, <4 x float>) nounwind readnone


define void @sfence() nounwind {
; CHECK-LABEL: @sfence(
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    tail call void @llvm.x86.sse.sfence()
; CHECK-NEXT:    ret void
;
  tail call void @llvm.x86.sse.sfence()
  ret void
}
declare void @llvm.x86.sse.sfence() nounwind

attributes #0 = { sanitize_memory }
