; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; REQUIRES: aarch64-registered-target

; RUN: opt -passes='lower-matrix-intrinsics' -matrix-print-after-transpose-opt -disable-output %s 2>&1 | FileCheck %s

target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "aarch64-apple-ios"

; k * A^T
define void @kat(ptr %Aptr, double %k, ptr %C) {
; CHECK-LABEL: @kat(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = load <9 x double>, ptr [[APTR:%.*]], align 128
; CHECK-NEXT:    [[VECK:%.*]] = insertelement <9 x double> poison, double [[K:%.*]], i64 0
; CHECK-NEXT:    [[SPLAT:%.*]] = shufflevector <9 x double> [[VECK]], <9 x double> poison, <9 x i32> zeroinitializer
; CHECK-NEXT:    [[AT:%.*]] = call <9 x double> @llvm.matrix.transpose.v9f64(<9 x double> [[A]], i32 3, i32 3)
; CHECK-NEXT:    [[MUL:%.*]] = call <9 x double> @llvm.matrix.multiply.v9f64.v9f64.v9f64(<9 x double> [[SPLAT]], <9 x double> [[AT]], i32 3, i32 3, i32 3)
; CHECK-NEXT:    store <9 x double> [[MUL]], ptr [[C:%.*]], align 128
; CHECK-NEXT:    ret void
;
entry:
  %a = load <9 x double>, ptr %Aptr
  %veck = insertelement <9 x double> poison, double %k, i64 0
  %splat = shufflevector <9 x double> %veck, <9 x double> poison, <9 x i32> zeroinitializer
  %at = call <9 x double> @llvm.matrix.transpose.v9f64.v9f64(<9 x double> %a, i32 3, i32 3)
  %mul = call <9 x double> @llvm.matrix.multiply.v9f64.v9f64.v9f64(<9 x double> %splat, <9 x double> %at, i32 3, i32 3, i32 3)
  store <9 x double> %mul, ptr %C
  ret void
}

; (k * A)^T -> A^T * k
define void @ka_t(ptr %Aptr, double %k, ptr %C) {
; CHECK-LABEL: @ka_t(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = load <9 x double>, ptr [[APTR:%.*]], align 128
; CHECK-NEXT:    [[VECK:%.*]] = insertelement <9 x double> poison, double [[K:%.*]], i64 0
; CHECK-NEXT:    [[SPLAT:%.*]] = shufflevector <9 x double> [[VECK]], <9 x double> poison, <9 x i32> zeroinitializer
; CHECK-NEXT:    [[A_T:%.*]] = call <9 x double> @llvm.matrix.transpose.v9f64(<9 x double> [[A]], i32 3, i32 3)
; CHECK-NEXT:    [[MMUL:%.*]] = call <9 x double> @llvm.matrix.multiply.v9f64.v9f64.v9f64(<9 x double> [[A_T]], <9 x double> [[SPLAT]], i32 3, i32 3, i32 3)
; CHECK-NEXT:    store <9 x double> [[MMUL]], ptr [[C:%.*]], align 128
; CHECK-NEXT:    ret void
;
entry:
  %a = load <9 x double>, ptr %Aptr
  %veck = insertelement <9 x double> poison, double %k, i64 0
  %splat = shufflevector <9 x double> %veck, <9 x double> poison, <9 x i32> zeroinitializer
  %mul = call <9 x double> @llvm.matrix.multiply.v9f64.v9f64.v9f64(<9 x double> %splat, <9 x double> %a, i32 3, i32 3, i32 3)
  %t = call <9 x double> @llvm.matrix.transpose.v9f64.v9f64(<9 x double> %mul, i32 3, i32 3)
  store <9 x double> %t, ptr %C
  ret void
}

; (k * A)^T -> A^T * k with fmul
define void @ka_t_fmul(ptr %Aptr, double %k, ptr %C) {
; CHECK-LABEL: @ka_t_fmul(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = load <9 x double>, ptr [[APTR:%.*]], align 128
; CHECK-NEXT:    [[VECK:%.*]] = insertelement <9 x double> poison, double [[K:%.*]], i64 0
; CHECK-NEXT:    [[SPLAT:%.*]] = shufflevector <9 x double> [[VECK]], <9 x double> poison, <9 x i32> zeroinitializer
; CHECK-NEXT:    [[A_T:%.*]] = call <9 x double> @llvm.matrix.transpose.v9f64(<9 x double> [[A]], i32 3, i32 3)
; CHECK-NEXT:    [[MMUL:%.*]] = fmul <9 x double> [[SPLAT]], [[A_T]]
; CHECK-NEXT:    store <9 x double> [[MMUL]], ptr [[C:%.*]], align 128
; CHECK-NEXT:    ret void
;
entry:
  %a = load <9 x double>, ptr %Aptr
  %veck = insertelement <9 x double> poison, double %k, i64 0
  %splat = shufflevector <9 x double> %veck, <9 x double> poison, <9 x i32> zeroinitializer
  %mul = fmul <9 x double> %splat, %a
  %t = call <9 x double> @llvm.matrix.transpose.v9f64.v9f64(<9 x double> %mul, i32 3, i32 3)
  store <9 x double> %t, ptr %C
  ret void
}

; (k * A)^T -> A^T * k with mul (non-fp types)
define void @ka_t_mul(ptr %Aptr, i32 %k, ptr %C) {
; CHECK-LABEL: @ka_t_mul(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = load <9 x i32>, ptr [[APTR:%.*]], align 64
; CHECK-NEXT:    [[VECK:%.*]] = insertelement <9 x i32> poison, i32 [[K:%.*]], i64 0
; CHECK-NEXT:    [[SPLAT:%.*]] = shufflevector <9 x i32> [[VECK]], <9 x i32> poison, <9 x i32> zeroinitializer
; CHECK-NEXT:    [[A_T:%.*]] = call <9 x i32> @llvm.matrix.transpose.v9i32(<9 x i32> [[A]], i32 3, i32 3)
; CHECK-NEXT:    [[MMUL:%.*]] = mul <9 x i32> [[SPLAT]], [[A_T]]
; CHECK-NEXT:    store <9 x i32> [[MMUL]], ptr [[C:%.*]], align 64
; CHECK-NEXT:    ret void
;
entry:
  %a = load <9 x i32>, ptr %Aptr
  %veck = insertelement <9 x i32> poison, i32 %k, i64 0
  %splat = shufflevector <9 x i32> %veck, <9 x i32> poison, <9 x i32> zeroinitializer
  %mul = mul <9 x i32> %splat, %a
  %t = call <9 x i32> @llvm.matrix.transpose.v9i32.v9i32(<9 x i32> %mul, i32 3, i32 3)
  store <9 x i32> %t, ptr %C
  ret void
}

; A^T + B^T -> (A + B)^T
define void @at_plus_bt(ptr %Aptr, ptr %Bptr, ptr %C) {
; CHECK-LABEL: @at_plus_bt(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = load <9 x double>, ptr [[APTR:%.*]], align 128
; CHECK-NEXT:    [[B:%.*]] = load <9 x double>, ptr [[BPTR:%.*]], align 128
; CHECK-NEXT:    [[MFADD:%.*]] = fadd <9 x double> [[A]], [[B]]
; CHECK-NEXT:    [[MFADD_T:%.*]] = call <9 x double> @llvm.matrix.transpose.v9f64(<9 x double> [[MFADD]], i32 3, i32 3)
; CHECK-NEXT:    store <9 x double> [[MFADD_T]], ptr [[C:%.*]], align 128
; CHECK-NEXT:    ret void
;
entry:
  %a = load <9 x double>, ptr %Aptr
  %b = load <9 x double>, ptr %Bptr
  %at = call <9 x double> @llvm.matrix.transpose.v9f64.v9f64(<9 x double> %a, i32 3, i32 3)
  %bt = call <9 x double> @llvm.matrix.transpose.v9f64.v9f64(<9 x double> %b, i32 3, i32 3)
  %fadd = fadd <9 x double> %at, %bt
  store <9 x double> %fadd, ptr %C
  ret void
}

; (A + B)^T -> A^T + B^T -> (A + B)^T
define void @a_plus_b_t(ptr %Aptr, ptr %Bptr, ptr %C) {
; CHECK-LABEL: @a_plus_b_t(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = load <9 x double>, ptr [[APTR:%.*]], align 128
; CHECK-NEXT:    [[B:%.*]] = load <9 x double>, ptr [[BPTR:%.*]], align 128
; CHECK-NEXT:    [[MFADD1:%.*]] = fadd <9 x double> [[A]], [[B]]
; CHECK-NEXT:    [[MFADD_T:%.*]] = call <9 x double> @llvm.matrix.transpose.v9f64(<9 x double> [[MFADD1]], i32 3, i32 3)
; CHECK-NEXT:    store <9 x double> [[MFADD_T]], ptr [[C:%.*]], align 128
; CHECK-NEXT:    ret void
;
entry:
  %a = load <9 x double>, ptr %Aptr
  %b = load <9 x double>, ptr %Bptr
  %fadd = fadd <9 x double> %a, %b
  %t = call <9 x double> @llvm.matrix.transpose.v9f64.v9f64(<9 x double> %fadd, i32 3, i32 3)
  store <9 x double> %t, ptr %C
  ret void
}

; A^T * B^T + C^T * D^T -> (B * A + D * C)^T
define void @atbt_plus_ctdt(ptr %Aptr, ptr %Bptr, ptr %Cptr, ptr %Dptr, ptr %E) {
; CHECK-LABEL: @atbt_plus_ctdt(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = load <9 x double>, ptr [[APTR:%.*]], align 128
; CHECK-NEXT:    [[B:%.*]] = load <9 x double>, ptr [[BPTR:%.*]], align 128
; CHECK-NEXT:    [[C:%.*]] = load <9 x double>, ptr [[CPTR:%.*]], align 128
; CHECK-NEXT:    [[D:%.*]] = load <9 x double>, ptr [[DPTR:%.*]], align 128
; CHECK-NEXT:    [[TMP0:%.*]] = call <9 x double> @llvm.matrix.multiply.v9f64.v9f64.v9f64(<9 x double> [[B]], <9 x double> [[A]], i32 3, i32 3, i32 3)
; CHECK-NEXT:    [[TMP1:%.*]] = call <9 x double> @llvm.matrix.multiply.v9f64.v9f64.v9f64(<9 x double> [[D]], <9 x double> [[C]], i32 3, i32 3, i32 3)
; CHECK-NEXT:    [[MFADD:%.*]] = fadd <9 x double> [[TMP0]], [[TMP1]]
; CHECK-NEXT:    [[MFADD_T:%.*]] = call <9 x double> @llvm.matrix.transpose.v9f64(<9 x double> [[MFADD]], i32 3, i32 3)
; CHECK-NEXT:    store <9 x double> [[MFADD_T]], ptr [[E:%.*]], align 128
; CHECK-NEXT:    ret void
;
entry:
  %a = load <9 x double>, ptr %Aptr
  %b = load <9 x double>, ptr %Bptr
  %c = load <9 x double>, ptr %Cptr
  %d = load <9 x double>, ptr %Dptr
  %at = call <9 x double> @llvm.matrix.transpose.v9f64.v9f64(<9 x double> %a, i32 3, i32 3)
  %bt = call <9 x double> @llvm.matrix.transpose.v9f64.v9f64(<9 x double> %b, i32 3, i32 3)
  %ct = call <9 x double> @llvm.matrix.transpose.v9f64.v9f64(<9 x double> %c, i32 3, i32 3)
  %dt = call <9 x double> @llvm.matrix.transpose.v9f64.v9f64(<9 x double> %d, i32 3, i32 3)
  %atbt = call <9 x double> @llvm.matrix.multiply.v9f64.v9f64.v9f64(<9 x double> %at, <9 x double> %bt, i32 3, i32 3, i32 3)
  %ctdt = call <9 x double> @llvm.matrix.multiply.v9f64.v9f64.v9f64(<9 x double> %ct, <9 x double> %dt, i32 3, i32 3, i32 3)
  %fadd = fadd <9 x double> %atbt, %ctdt
  store <9 x double> %fadd, ptr %E
  ret void
}

; -(A^T) + B^T
define void @negat_plus_bt(ptr %Aptr, ptr %Bptr, ptr %C) {
; CHECK-LABEL: @negat_plus_bt(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = load <9 x double>, ptr [[APTR:%.*]], align 128
; CHECK-NEXT:    [[B:%.*]] = load <9 x double>, ptr [[BPTR:%.*]], align 128
; CHECK-NEXT:    [[AT:%.*]] = call <9 x double> @llvm.matrix.transpose.v9f64(<9 x double> [[A]], i32 3, i32 3)
; CHECK-NEXT:    [[NEGAT:%.*]] = fneg <9 x double> [[AT]]
; CHECK-NEXT:    [[BT:%.*]] = call <9 x double> @llvm.matrix.transpose.v9f64(<9 x double> [[B]], i32 3, i32 3)
; CHECK-NEXT:    [[FADD:%.*]] = fadd <9 x double> [[NEGAT]], [[BT]]
; CHECK-NEXT:    store <9 x double> [[FADD]], ptr [[C:%.*]], align 128
; CHECK-NEXT:    ret void
;
entry:
  %a = load <9 x double>, ptr %Aptr
  %b = load <9 x double>, ptr %Bptr
  %at = call <9 x double> @llvm.matrix.transpose.v9f64.v9f64(<9 x double> %a, i32 3, i32 3)
  %negat = fneg <9 x double> %at
  %bt = call <9 x double> @llvm.matrix.transpose.v9f64.v9f64(<9 x double> %b, i32 3, i32 3)
  %fadd = fadd <9 x double> %negat, %bt
  store <9 x double> %fadd, ptr %C
  ret void
}

; (A^T * B^T + k * C^T * D^T)^T -> (B * A) + (D * C * k)
define void @atbt_plus_kctdt_t(ptr %Aptr, ptr %Bptr, ptr %Cptr, ptr %Dptr, double %k, ptr %E) {
; CHECK-LABEL: @atbt_plus_kctdt_t(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = load <9 x double>, ptr [[APTR:%.*]], align 128
; CHECK-NEXT:    [[B:%.*]] = load <9 x double>, ptr [[BPTR:%.*]], align 128
; CHECK-NEXT:    [[C:%.*]] = load <9 x double>, ptr [[CPTR:%.*]], align 128
; CHECK-NEXT:    [[D:%.*]] = load <9 x double>, ptr [[DPTR:%.*]], align 128
; CHECK-NEXT:    [[VECK:%.*]] = insertelement <9 x double> poison, double [[K:%.*]], i64 0
; CHECK-NEXT:    [[SPLAT:%.*]] = shufflevector <9 x double> [[VECK]], <9 x double> poison, <9 x i32> zeroinitializer
; CHECK-NEXT:    [[MMUL2:%.*]] = call <9 x double> @llvm.matrix.multiply.v9f64.v9f64.v9f64(<9 x double> [[B]], <9 x double> [[A]], i32 3, i32 3, i32 3)
; CHECK-NEXT:    [[MMUL1:%.*]] = call <9 x double> @llvm.matrix.multiply.v9f64.v9f64.v9f64(<9 x double> [[C]], <9 x double> [[SPLAT]], i32 3, i32 3, i32 3)
; CHECK-NEXT:    [[MMUL:%.*]] = call <9 x double> @llvm.matrix.multiply.v9f64.v9f64.v9f64(<9 x double> [[D]], <9 x double> [[MMUL1]], i32 3, i32 3, i32 3)
; CHECK-NEXT:    [[MFADD:%.*]] = fadd <9 x double> [[MMUL2]], [[MMUL]]
; CHECK-NEXT:    store <9 x double> [[MFADD]], ptr [[E:%.*]], align 128
; CHECK-NEXT:    ret void
;
entry:
  %a = load <9 x double>, ptr %Aptr
  %b = load <9 x double>, ptr %Bptr
  %c = load <9 x double>, ptr %Cptr
  %d = load <9 x double>, ptr %Dptr
  %at = call <9 x double> @llvm.matrix.transpose.v9f64.v9f64(<9 x double> %a, i32 3, i32 3)
  %bt = call <9 x double> @llvm.matrix.transpose.v9f64.v9f64(<9 x double> %b, i32 3, i32 3)
  %ct = call <9 x double> @llvm.matrix.transpose.v9f64.v9f64(<9 x double> %c, i32 3, i32 3)
  %dt = call <9 x double> @llvm.matrix.transpose.v9f64.v9f64(<9 x double> %d, i32 3, i32 3)
  %atbt = call <9 x double> @llvm.matrix.multiply.v9f64.v9f64.v9f64(<9 x double> %at, <9 x double> %bt, i32 3, i32 3, i32 3)
  %veck = insertelement <9 x double> poison, double %k, i64 0
  %splat = shufflevector <9 x double> %veck, <9 x double> poison, <9 x i32> zeroinitializer
  %kct = call <9 x double> @llvm.matrix.multiply.v9f64.v9f64.v9f64(<9 x double> %splat, <9 x double> %ct, i32 3, i32 3, i32 3)
  %kctdt = call <9 x double> @llvm.matrix.multiply.v9f64.v9f64.v9f64(<9 x double> %kct, <9 x double> %dt, i32 3, i32 3, i32 3)
  %fadd = fadd <9 x double> %atbt, %kctdt
  %t = call <9 x double> @llvm.matrix.transpose.v9f64.v9f64(<9 x double> %fadd, i32 3, i32 3)
  store <9 x double> %t, ptr %E
  ret void
}

; (A^T * (k * B^T))^T => (B * k) * A
define void @atkbt_t(ptr %Aptr, ptr %Bptr, double %k, ptr %C) {
; CHECK-LABEL: @atkbt_t(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = load <9 x double>, ptr [[APTR:%.*]], align 128
; CHECK-NEXT:    [[B:%.*]] = load <9 x double>, ptr [[BPTR:%.*]], align 128
; CHECK-NEXT:    [[VECK:%.*]] = insertelement <9 x double> poison, double [[K:%.*]], i64 0
; CHECK-NEXT:    [[SPLAT:%.*]] = shufflevector <9 x double> [[VECK]], <9 x double> poison, <9 x i32> zeroinitializer
; CHECK-NEXT:    [[MMUL1:%.*]] = call <9 x double> @llvm.matrix.multiply.v9f64.v9f64.v9f64(<9 x double> [[B]], <9 x double> [[SPLAT]], i32 3, i32 3, i32 3)
; CHECK-NEXT:    [[MMUL:%.*]] = call <9 x double> @llvm.matrix.multiply.v9f64.v9f64.v9f64(<9 x double> [[MMUL1]], <9 x double> [[A]], i32 3, i32 3, i32 3)
; CHECK-NEXT:    store <9 x double> [[MMUL]], ptr [[C:%.*]], align 128
; CHECK-NEXT:    ret void
;
entry:
  %a = load <9 x double>, ptr %Aptr
  %b = load <9 x double>, ptr %Bptr
  %at = call <9 x double> @llvm.matrix.transpose.v9f64.v9f64(<9 x double> %a, i32 3, i32 3)
  %bt = call <9 x double> @llvm.matrix.transpose.v9f64.v9f64(<9 x double> %b, i32 3, i32 3)
  %veck = insertelement <9 x double> poison, double %k, i64 0
  %splat = shufflevector <9 x double> %veck, <9 x double> poison, <9 x i32> zeroinitializer
  %kbt = call <9 x double> @llvm.matrix.multiply.v9f64.v9f64.v9f64(<9 x double> %splat, <9 x double> %bt, i32 3, i32 3, i32 3)
  %atkbt = call <9 x double> @llvm.matrix.multiply.v9f64.v9f64.v9f64(<9 x double> %at, <9 x double> %kbt, i32 3, i32 3, i32 3)
  %t = call <9 x double> @llvm.matrix.transpose.v9f64.v9f64(<9 x double> %atkbt, i32 3, i32 3)
  store <9 x double> %t, ptr %C
  ret void
}

declare <9 x double> @llvm.matrix.multiply.v9f64.v9f64.v9f64(<9 x double>, <9 x double>, i32, i32, i32)
declare <9 x double> @llvm.matrix.transpose.v9f64.v9f64(<9 x double>, i32, i32)
declare <9 x i32> @llvm.matrix.transpose.v9i32.v9i32(<9 x i32>, i32, i32)
