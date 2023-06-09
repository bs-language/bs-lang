; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 2
; RUN: opt < %s -passes=slp-vectorizer -S -mtriple=riscv64 -mattr=+v,+f \
; RUN:     -riscv-v-vector-bits-min=-1 -riscv-v-slp-max-vf=0 \
; RUN:     | FileCheck %s
; RUN: opt < %s -passes=slp-vectorizer -S -mtriple=riscv64 -mattr=+v,+f \
; RUN:     | FileCheck %s --check-prefix=DEFAULT

define void @fp_add(ptr %dst, ptr %p, ptr %q) {
; CHECK-LABEL: define void @fp_add
; CHECK-SAME: (ptr [[DST:%.*]], ptr [[P:%.*]], ptr [[Q:%.*]]) #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <4 x float>, ptr [[P]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x float>, ptr [[Q]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = fadd <4 x float> [[TMP0]], [[TMP1]]
; CHECK-NEXT:    store <4 x float> [[TMP2]], ptr [[DST]], align 4
; CHECK-NEXT:    ret void
;
; DEFAULT-LABEL: define void @fp_add
; DEFAULT-SAME: (ptr [[DST:%.*]], ptr [[P:%.*]], ptr [[Q:%.*]]) #[[ATTR0:[0-9]+]] {
; DEFAULT-NEXT:  entry:
; DEFAULT-NEXT:    [[E0:%.*]] = load float, ptr [[P]], align 4
; DEFAULT-NEXT:    [[PE1:%.*]] = getelementptr inbounds float, ptr [[P]], i64 1
; DEFAULT-NEXT:    [[E1:%.*]] = load float, ptr [[PE1]], align 4
; DEFAULT-NEXT:    [[PE2:%.*]] = getelementptr inbounds float, ptr [[P]], i64 2
; DEFAULT-NEXT:    [[E2:%.*]] = load float, ptr [[PE2]], align 4
; DEFAULT-NEXT:    [[PE3:%.*]] = getelementptr inbounds float, ptr [[P]], i64 3
; DEFAULT-NEXT:    [[E3:%.*]] = load float, ptr [[PE3]], align 4
; DEFAULT-NEXT:    [[F0:%.*]] = load float, ptr [[Q]], align 4
; DEFAULT-NEXT:    [[PF1:%.*]] = getelementptr inbounds float, ptr [[Q]], i64 1
; DEFAULT-NEXT:    [[F1:%.*]] = load float, ptr [[PF1]], align 4
; DEFAULT-NEXT:    [[PF2:%.*]] = getelementptr inbounds float, ptr [[Q]], i64 2
; DEFAULT-NEXT:    [[F2:%.*]] = load float, ptr [[PF2]], align 4
; DEFAULT-NEXT:    [[PF3:%.*]] = getelementptr inbounds float, ptr [[Q]], i64 3
; DEFAULT-NEXT:    [[F3:%.*]] = load float, ptr [[PF3]], align 4
; DEFAULT-NEXT:    [[A0:%.*]] = fadd float [[E0]], [[F0]]
; DEFAULT-NEXT:    [[A1:%.*]] = fadd float [[E1]], [[F1]]
; DEFAULT-NEXT:    [[A2:%.*]] = fadd float [[E2]], [[F2]]
; DEFAULT-NEXT:    [[A3:%.*]] = fadd float [[E3]], [[F3]]
; DEFAULT-NEXT:    store float [[A0]], ptr [[DST]], align 4
; DEFAULT-NEXT:    [[PA1:%.*]] = getelementptr inbounds float, ptr [[DST]], i64 1
; DEFAULT-NEXT:    store float [[A1]], ptr [[PA1]], align 4
; DEFAULT-NEXT:    [[PA2:%.*]] = getelementptr inbounds float, ptr [[DST]], i64 2
; DEFAULT-NEXT:    store float [[A2]], ptr [[PA2]], align 4
; DEFAULT-NEXT:    [[PA3:%.*]] = getelementptr inbounds float, ptr [[DST]], i64 3
; DEFAULT-NEXT:    store float [[A3]], ptr [[PA3]], align 4
; DEFAULT-NEXT:    ret void
;
entry:
  %e0 = load float, ptr %p, align 4
  %pe1 = getelementptr inbounds float, ptr %p, i64 1
  %e1 = load float, ptr %pe1, align 4
  %pe2 = getelementptr inbounds float, ptr %p, i64 2
  %e2 = load float, ptr %pe2, align 4
  %pe3 = getelementptr inbounds float, ptr %p, i64 3
  %e3 = load float, ptr %pe3, align 4

  %f0 = load float, ptr %q, align 4
  %pf1 = getelementptr inbounds float, ptr %q, i64 1
  %f1 = load float, ptr %pf1, align 4
  %pf2 = getelementptr inbounds float, ptr %q, i64 2
  %f2 = load float, ptr %pf2, align 4
  %pf3 = getelementptr inbounds float, ptr %q, i64 3
  %f3 = load float, ptr %pf3, align 4

  %a0 = fadd float %e0, %f0
  %a1 = fadd float %e1, %f1
  %a2 = fadd float %e2, %f2
  %a3 = fadd float %e3, %f3

  store float %a0, ptr %dst, align 4
  %pa1 = getelementptr inbounds float, ptr %dst, i64 1
  store float %a1, ptr %pa1, align 4
  %pa2 = getelementptr inbounds float, ptr %dst, i64 2
  store float %a2, ptr %pa2, align 4
  %pa3 = getelementptr inbounds float, ptr %dst, i64 3
  store float %a3, ptr %pa3, align 4

  ret void
}

define void @fp_sub(ptr %dst, ptr %p) {
; CHECK-LABEL: define void @fp_sub
; CHECK-SAME: (ptr [[DST:%.*]], ptr [[P:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <4 x float>, ptr [[P]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = fsub <4 x float> [[TMP0]], <float 3.000000e+00, float 3.000000e+00, float 3.000000e+00, float 3.000000e+00>
; CHECK-NEXT:    store <4 x float> [[TMP1]], ptr [[DST]], align 4
; CHECK-NEXT:    ret void
;
; DEFAULT-LABEL: define void @fp_sub
; DEFAULT-SAME: (ptr [[DST:%.*]], ptr [[P:%.*]]) #[[ATTR0]] {
; DEFAULT-NEXT:  entry:
; DEFAULT-NEXT:    [[E0:%.*]] = load float, ptr [[P]], align 4
; DEFAULT-NEXT:    [[PE1:%.*]] = getelementptr inbounds float, ptr [[P]], i64 1
; DEFAULT-NEXT:    [[E1:%.*]] = load float, ptr [[PE1]], align 4
; DEFAULT-NEXT:    [[PE2:%.*]] = getelementptr inbounds float, ptr [[P]], i64 2
; DEFAULT-NEXT:    [[E2:%.*]] = load float, ptr [[PE2]], align 4
; DEFAULT-NEXT:    [[PE3:%.*]] = getelementptr inbounds float, ptr [[P]], i64 3
; DEFAULT-NEXT:    [[E3:%.*]] = load float, ptr [[PE3]], align 4
; DEFAULT-NEXT:    [[A0:%.*]] = fsub float [[E0]], 3.000000e+00
; DEFAULT-NEXT:    [[A1:%.*]] = fsub float [[E1]], 3.000000e+00
; DEFAULT-NEXT:    [[A2:%.*]] = fsub float [[E2]], 3.000000e+00
; DEFAULT-NEXT:    [[A3:%.*]] = fsub float [[E3]], 3.000000e+00
; DEFAULT-NEXT:    store float [[A0]], ptr [[DST]], align 4
; DEFAULT-NEXT:    [[PA1:%.*]] = getelementptr inbounds float, ptr [[DST]], i64 1
; DEFAULT-NEXT:    store float [[A1]], ptr [[PA1]], align 4
; DEFAULT-NEXT:    [[PA2:%.*]] = getelementptr inbounds float, ptr [[DST]], i64 2
; DEFAULT-NEXT:    store float [[A2]], ptr [[PA2]], align 4
; DEFAULT-NEXT:    [[PA3:%.*]] = getelementptr inbounds float, ptr [[DST]], i64 3
; DEFAULT-NEXT:    store float [[A3]], ptr [[PA3]], align 4
; DEFAULT-NEXT:    ret void
;
entry:
  %e0 = load float, ptr %p, align 4
  %pe1 = getelementptr inbounds float, ptr %p, i64 1
  %e1 = load float, ptr %pe1, align 4
  %pe2 = getelementptr inbounds float, ptr %p, i64 2
  %e2 = load float, ptr %pe2, align 4
  %pe3 = getelementptr inbounds float, ptr %p, i64 3
  %e3 = load float, ptr %pe3, align 4

  %a0 = fsub float %e0, 3.0
  %a1 = fsub float %e1, 3.0
  %a2 = fsub float %e2, 3.0
  %a3 = fsub float %e3, 3.0

  store float %a0, ptr %dst, align 4
  %pa1 = getelementptr inbounds float, ptr %dst, i64 1
  store float %a1, ptr %pa1, align 4
  %pa2 = getelementptr inbounds float, ptr %dst, i64 2
  store float %a2, ptr %pa2, align 4
  %pa3 = getelementptr inbounds float, ptr %dst, i64 3
  store float %a3, ptr %pa3, align 4

  ret void
}

define void @fp_mul(ptr %dst, ptr %p, ptr %q) {
; CHECK-LABEL: define void @fp_mul
; CHECK-SAME: (ptr [[DST:%.*]], ptr [[P:%.*]], ptr [[Q:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <4 x float>, ptr [[P]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x float>, ptr [[Q]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = fmul <4 x float> [[TMP0]], [[TMP1]]
; CHECK-NEXT:    store <4 x float> [[TMP2]], ptr [[DST]], align 4
; CHECK-NEXT:    ret void
;
; DEFAULT-LABEL: define void @fp_mul
; DEFAULT-SAME: (ptr [[DST:%.*]], ptr [[P:%.*]], ptr [[Q:%.*]]) #[[ATTR0]] {
; DEFAULT-NEXT:  entry:
; DEFAULT-NEXT:    [[E0:%.*]] = load float, ptr [[P]], align 4
; DEFAULT-NEXT:    [[PE1:%.*]] = getelementptr inbounds float, ptr [[P]], i64 1
; DEFAULT-NEXT:    [[E1:%.*]] = load float, ptr [[PE1]], align 4
; DEFAULT-NEXT:    [[PE2:%.*]] = getelementptr inbounds float, ptr [[P]], i64 2
; DEFAULT-NEXT:    [[E2:%.*]] = load float, ptr [[PE2]], align 4
; DEFAULT-NEXT:    [[PE3:%.*]] = getelementptr inbounds float, ptr [[P]], i64 3
; DEFAULT-NEXT:    [[E3:%.*]] = load float, ptr [[PE3]], align 4
; DEFAULT-NEXT:    [[F0:%.*]] = load float, ptr [[Q]], align 4
; DEFAULT-NEXT:    [[PF1:%.*]] = getelementptr inbounds float, ptr [[Q]], i64 1
; DEFAULT-NEXT:    [[F1:%.*]] = load float, ptr [[PF1]], align 4
; DEFAULT-NEXT:    [[PF2:%.*]] = getelementptr inbounds float, ptr [[Q]], i64 2
; DEFAULT-NEXT:    [[F2:%.*]] = load float, ptr [[PF2]], align 4
; DEFAULT-NEXT:    [[PF3:%.*]] = getelementptr inbounds float, ptr [[Q]], i64 3
; DEFAULT-NEXT:    [[F3:%.*]] = load float, ptr [[PF3]], align 4
; DEFAULT-NEXT:    [[A0:%.*]] = fmul float [[E0]], [[F0]]
; DEFAULT-NEXT:    [[A1:%.*]] = fmul float [[E1]], [[F1]]
; DEFAULT-NEXT:    [[A2:%.*]] = fmul float [[E2]], [[F2]]
; DEFAULT-NEXT:    [[A3:%.*]] = fmul float [[E3]], [[F3]]
; DEFAULT-NEXT:    store float [[A0]], ptr [[DST]], align 4
; DEFAULT-NEXT:    [[PA1:%.*]] = getelementptr inbounds float, ptr [[DST]], i64 1
; DEFAULT-NEXT:    store float [[A1]], ptr [[PA1]], align 4
; DEFAULT-NEXT:    [[PA2:%.*]] = getelementptr inbounds float, ptr [[DST]], i64 2
; DEFAULT-NEXT:    store float [[A2]], ptr [[PA2]], align 4
; DEFAULT-NEXT:    [[PA3:%.*]] = getelementptr inbounds float, ptr [[DST]], i64 3
; DEFAULT-NEXT:    store float [[A3]], ptr [[PA3]], align 4
; DEFAULT-NEXT:    ret void
;
entry:
  %e0 = load float, ptr %p, align 4
  %pe1 = getelementptr inbounds float, ptr %p, i64 1
  %e1 = load float, ptr %pe1, align 4
  %pe2 = getelementptr inbounds float, ptr %p, i64 2
  %e2 = load float, ptr %pe2, align 4
  %pe3 = getelementptr inbounds float, ptr %p, i64 3
  %e3 = load float, ptr %pe3, align 4

  %f0 = load float, ptr %q, align 4
  %pf1 = getelementptr inbounds float, ptr %q, i64 1
  %f1 = load float, ptr %pf1, align 4
  %pf2 = getelementptr inbounds float, ptr %q, i64 2
  %f2 = load float, ptr %pf2, align 4
  %pf3 = getelementptr inbounds float, ptr %q, i64 3
  %f3 = load float, ptr %pf3, align 4

  %a0 = fmul float %e0, %f0
  %a1 = fmul float %e1, %f1
  %a2 = fmul float %e2, %f2
  %a3 = fmul float %e3, %f3

  store float %a0, ptr %dst, align 4
  %pa1 = getelementptr inbounds float, ptr %dst, i64 1
  store float %a1, ptr %pa1, align 4
  %pa2 = getelementptr inbounds float, ptr %dst, i64 2
  store float %a2, ptr %pa2, align 4
  %pa3 = getelementptr inbounds float, ptr %dst, i64 3
  store float %a3, ptr %pa3, align 4

  ret void
}

define void @fp_div(ptr %dst, ptr %p) {
; CHECK-LABEL: define void @fp_div
; CHECK-SAME: (ptr [[DST:%.*]], ptr [[P:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <4 x float>, ptr [[P]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = fdiv <4 x float> [[TMP0]], <float 1.050000e+01, float 1.050000e+01, float 1.050000e+01, float 1.050000e+01>
; CHECK-NEXT:    store <4 x float> [[TMP1]], ptr [[DST]], align 4
; CHECK-NEXT:    ret void
;
; DEFAULT-LABEL: define void @fp_div
; DEFAULT-SAME: (ptr [[DST:%.*]], ptr [[P:%.*]]) #[[ATTR0]] {
; DEFAULT-NEXT:  entry:
; DEFAULT-NEXT:    [[E0:%.*]] = load float, ptr [[P]], align 4
; DEFAULT-NEXT:    [[PE1:%.*]] = getelementptr inbounds float, ptr [[P]], i64 1
; DEFAULT-NEXT:    [[E1:%.*]] = load float, ptr [[PE1]], align 4
; DEFAULT-NEXT:    [[PE2:%.*]] = getelementptr inbounds float, ptr [[P]], i64 2
; DEFAULT-NEXT:    [[E2:%.*]] = load float, ptr [[PE2]], align 4
; DEFAULT-NEXT:    [[PE3:%.*]] = getelementptr inbounds float, ptr [[P]], i64 3
; DEFAULT-NEXT:    [[E3:%.*]] = load float, ptr [[PE3]], align 4
; DEFAULT-NEXT:    [[A0:%.*]] = fdiv float [[E0]], 1.050000e+01
; DEFAULT-NEXT:    [[A1:%.*]] = fdiv float [[E1]], 1.050000e+01
; DEFAULT-NEXT:    [[A2:%.*]] = fdiv float [[E2]], 1.050000e+01
; DEFAULT-NEXT:    [[A3:%.*]] = fdiv float [[E3]], 1.050000e+01
; DEFAULT-NEXT:    store float [[A0]], ptr [[DST]], align 4
; DEFAULT-NEXT:    [[PA1:%.*]] = getelementptr inbounds float, ptr [[DST]], i64 1
; DEFAULT-NEXT:    store float [[A1]], ptr [[PA1]], align 4
; DEFAULT-NEXT:    [[PA2:%.*]] = getelementptr inbounds float, ptr [[DST]], i64 2
; DEFAULT-NEXT:    store float [[A2]], ptr [[PA2]], align 4
; DEFAULT-NEXT:    [[PA3:%.*]] = getelementptr inbounds float, ptr [[DST]], i64 3
; DEFAULT-NEXT:    store float [[A3]], ptr [[PA3]], align 4
; DEFAULT-NEXT:    ret void
;
entry:
  %e0 = load float, ptr %p, align 4
  %pe1 = getelementptr inbounds float, ptr %p, i64 1
  %e1 = load float, ptr %pe1, align 4
  %pe2 = getelementptr inbounds float, ptr %p, i64 2
  %e2 = load float, ptr %pe2, align 4
  %pe3 = getelementptr inbounds float, ptr %p, i64 3
  %e3 = load float, ptr %pe3, align 4

  %a0 = fdiv float %e0, 10.5
  %a1 = fdiv float %e1, 10.5
  %a2 = fdiv float %e2, 10.5
  %a3 = fdiv float %e3, 10.5

  store float %a0, ptr %dst, align 4
  %pa1 = getelementptr inbounds float, ptr %dst, i64 1
  store float %a1, ptr %pa1, align 4
  %pa2 = getelementptr inbounds float, ptr %dst, i64 2
  store float %a2, ptr %pa2, align 4
  %pa3 = getelementptr inbounds float, ptr %dst, i64 3
  store float %a3, ptr %pa3, align 4

  ret void
}

declare float @llvm.maxnum.f32(float, float)

define void @fp_max(ptr %dst, ptr %p, ptr %q) {
; CHECK-LABEL: define void @fp_max
; CHECK-SAME: (ptr [[DST:%.*]], ptr [[P:%.*]], ptr [[Q:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <4 x float>, ptr [[P]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x float>, ptr [[Q]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = call <4 x float> @llvm.maxnum.v4f32(<4 x float> [[TMP0]], <4 x float> [[TMP1]])
; CHECK-NEXT:    store <4 x float> [[TMP2]], ptr [[DST]], align 4
; CHECK-NEXT:    ret void
;
; DEFAULT-LABEL: define void @fp_max
; DEFAULT-SAME: (ptr [[DST:%.*]], ptr [[P:%.*]], ptr [[Q:%.*]]) #[[ATTR0]] {
; DEFAULT-NEXT:  entry:
; DEFAULT-NEXT:    [[E0:%.*]] = load float, ptr [[P]], align 4
; DEFAULT-NEXT:    [[PE1:%.*]] = getelementptr inbounds float, ptr [[P]], i64 1
; DEFAULT-NEXT:    [[E1:%.*]] = load float, ptr [[PE1]], align 4
; DEFAULT-NEXT:    [[PE2:%.*]] = getelementptr inbounds float, ptr [[P]], i64 2
; DEFAULT-NEXT:    [[E2:%.*]] = load float, ptr [[PE2]], align 4
; DEFAULT-NEXT:    [[PE3:%.*]] = getelementptr inbounds float, ptr [[P]], i64 3
; DEFAULT-NEXT:    [[E3:%.*]] = load float, ptr [[PE3]], align 4
; DEFAULT-NEXT:    [[F0:%.*]] = load float, ptr [[Q]], align 4
; DEFAULT-NEXT:    [[PF1:%.*]] = getelementptr inbounds float, ptr [[Q]], i64 1
; DEFAULT-NEXT:    [[F1:%.*]] = load float, ptr [[PF1]], align 4
; DEFAULT-NEXT:    [[PF2:%.*]] = getelementptr inbounds float, ptr [[Q]], i64 2
; DEFAULT-NEXT:    [[F2:%.*]] = load float, ptr [[PF2]], align 4
; DEFAULT-NEXT:    [[PF3:%.*]] = getelementptr inbounds float, ptr [[Q]], i64 3
; DEFAULT-NEXT:    [[F3:%.*]] = load float, ptr [[PF3]], align 4
; DEFAULT-NEXT:    [[A0:%.*]] = tail call float @llvm.maxnum.f32(float [[E0]], float [[F0]])
; DEFAULT-NEXT:    [[A1:%.*]] = tail call float @llvm.maxnum.f32(float [[E1]], float [[F1]])
; DEFAULT-NEXT:    [[A2:%.*]] = tail call float @llvm.maxnum.f32(float [[E2]], float [[F2]])
; DEFAULT-NEXT:    [[A3:%.*]] = tail call float @llvm.maxnum.f32(float [[E3]], float [[F3]])
; DEFAULT-NEXT:    store float [[A0]], ptr [[DST]], align 4
; DEFAULT-NEXT:    [[PA1:%.*]] = getelementptr inbounds float, ptr [[DST]], i64 1
; DEFAULT-NEXT:    store float [[A1]], ptr [[PA1]], align 4
; DEFAULT-NEXT:    [[PA2:%.*]] = getelementptr inbounds float, ptr [[DST]], i64 2
; DEFAULT-NEXT:    store float [[A2]], ptr [[PA2]], align 4
; DEFAULT-NEXT:    [[PA3:%.*]] = getelementptr inbounds float, ptr [[DST]], i64 3
; DEFAULT-NEXT:    store float [[A3]], ptr [[PA3]], align 4
; DEFAULT-NEXT:    ret void
;
entry:
  %e0 = load float, ptr %p, align 4
  %pe1 = getelementptr inbounds float, ptr %p, i64 1
  %e1 = load float, ptr %pe1, align 4
  %pe2 = getelementptr inbounds float, ptr %p, i64 2
  %e2 = load float, ptr %pe2, align 4
  %pe3 = getelementptr inbounds float, ptr %p, i64 3
  %e3 = load float, ptr %pe3, align 4

  %f0 = load float, ptr %q, align 4
  %pf1 = getelementptr inbounds float, ptr %q, i64 1
  %f1 = load float, ptr %pf1, align 4
  %pf2 = getelementptr inbounds float, ptr %q, i64 2
  %f2 = load float, ptr %pf2, align 4
  %pf3 = getelementptr inbounds float, ptr %q, i64 3
  %f3 = load float, ptr %pf3, align 4

  %a0 = tail call float @llvm.maxnum.f32(float %e0, float %f0)
  %a1 = tail call float @llvm.maxnum.f32(float %e1, float %f1)
  %a2 = tail call float @llvm.maxnum.f32(float %e2, float %f2)
  %a3 = tail call float @llvm.maxnum.f32(float %e3, float %f3)

  store float %a0, ptr %dst, align 4
  %pa1 = getelementptr inbounds float, ptr %dst, i64 1
  store float %a1, ptr %pa1, align 4
  %pa2 = getelementptr inbounds float, ptr %dst, i64 2
  store float %a2, ptr %pa2, align 4
  %pa3 = getelementptr inbounds float, ptr %dst, i64 3
  store float %a3, ptr %pa3, align 4

  ret void
}

declare float @llvm.minnum.f32(float, float)

define void @fp_min(ptr %dst, ptr %p) {
; CHECK-LABEL: define void @fp_min
; CHECK-SAME: (ptr [[DST:%.*]], ptr [[P:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <4 x float>, ptr [[P]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = call <4 x float> @llvm.minnum.v4f32(<4 x float> [[TMP0]], <4 x float> <float 1.250000e+00, float 1.250000e+00, float 1.250000e+00, float 1.250000e+00>)
; CHECK-NEXT:    store <4 x float> [[TMP1]], ptr [[DST]], align 4
; CHECK-NEXT:    ret void
;
; DEFAULT-LABEL: define void @fp_min
; DEFAULT-SAME: (ptr [[DST:%.*]], ptr [[P:%.*]]) #[[ATTR0]] {
; DEFAULT-NEXT:  entry:
; DEFAULT-NEXT:    [[E0:%.*]] = load float, ptr [[P]], align 4
; DEFAULT-NEXT:    [[PE1:%.*]] = getelementptr inbounds float, ptr [[P]], i64 1
; DEFAULT-NEXT:    [[E1:%.*]] = load float, ptr [[PE1]], align 4
; DEFAULT-NEXT:    [[PE2:%.*]] = getelementptr inbounds float, ptr [[P]], i64 2
; DEFAULT-NEXT:    [[E2:%.*]] = load float, ptr [[PE2]], align 4
; DEFAULT-NEXT:    [[PE3:%.*]] = getelementptr inbounds float, ptr [[P]], i64 3
; DEFAULT-NEXT:    [[E3:%.*]] = load float, ptr [[PE3]], align 4
; DEFAULT-NEXT:    [[A0:%.*]] = tail call float @llvm.minnum.f32(float [[E0]], float 1.250000e+00)
; DEFAULT-NEXT:    [[A1:%.*]] = tail call float @llvm.minnum.f32(float [[E1]], float 1.250000e+00)
; DEFAULT-NEXT:    [[A2:%.*]] = tail call float @llvm.minnum.f32(float [[E2]], float 1.250000e+00)
; DEFAULT-NEXT:    [[A3:%.*]] = tail call float @llvm.minnum.f32(float [[E3]], float 1.250000e+00)
; DEFAULT-NEXT:    store float [[A0]], ptr [[DST]], align 4
; DEFAULT-NEXT:    [[PA1:%.*]] = getelementptr inbounds float, ptr [[DST]], i64 1
; DEFAULT-NEXT:    store float [[A1]], ptr [[PA1]], align 4
; DEFAULT-NEXT:    [[PA2:%.*]] = getelementptr inbounds float, ptr [[DST]], i64 2
; DEFAULT-NEXT:    store float [[A2]], ptr [[PA2]], align 4
; DEFAULT-NEXT:    [[PA3:%.*]] = getelementptr inbounds float, ptr [[DST]], i64 3
; DEFAULT-NEXT:    store float [[A3]], ptr [[PA3]], align 4
; DEFAULT-NEXT:    ret void
;
entry:
  %e0 = load float, ptr %p, align 4
  %pe1 = getelementptr inbounds float, ptr %p, i64 1
  %e1 = load float, ptr %pe1, align 4
  %pe2 = getelementptr inbounds float, ptr %p, i64 2
  %e2 = load float, ptr %pe2, align 4
  %pe3 = getelementptr inbounds float, ptr %p, i64 3
  %e3 = load float, ptr %pe3, align 4

  %a0 = tail call float @llvm.minnum.f32(float %e0, float 1.25)
  %a1 = tail call float @llvm.minnum.f32(float %e1, float 1.25)
  %a2 = tail call float @llvm.minnum.f32(float %e2, float 1.25)
  %a3 = tail call float @llvm.minnum.f32(float %e3, float 1.25)

  store float %a0, ptr %dst, align 4
  %pa1 = getelementptr inbounds float, ptr %dst, i64 1
  store float %a1, ptr %pa1, align 4
  %pa2 = getelementptr inbounds float, ptr %dst, i64 2
  store float %a2, ptr %pa2, align 4
  %pa3 = getelementptr inbounds float, ptr %dst, i64 3
  store float %a3, ptr %pa3, align 4

  ret void
}

declare i32 @llvm.fptosi.sat.i32.f32(float)

define void @fp_convert(ptr %dst, ptr %p) {
; CHECK-LABEL: define void @fp_convert
; CHECK-SAME: (ptr [[DST:%.*]], ptr [[P:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <4 x float>, ptr [[P]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = call <4 x i32> @llvm.fptosi.sat.v4i32.v4f32(<4 x float> [[TMP0]])
; CHECK-NEXT:    store <4 x i32> [[TMP1]], ptr [[DST]], align 4
; CHECK-NEXT:    ret void
;
; DEFAULT-LABEL: define void @fp_convert
; DEFAULT-SAME: (ptr [[DST:%.*]], ptr [[P:%.*]]) #[[ATTR0]] {
; DEFAULT-NEXT:  entry:
; DEFAULT-NEXT:    [[E0:%.*]] = load float, ptr [[P]], align 4
; DEFAULT-NEXT:    [[PE1:%.*]] = getelementptr inbounds float, ptr [[P]], i64 1
; DEFAULT-NEXT:    [[E1:%.*]] = load float, ptr [[PE1]], align 4
; DEFAULT-NEXT:    [[PE2:%.*]] = getelementptr inbounds float, ptr [[P]], i64 2
; DEFAULT-NEXT:    [[E2:%.*]] = load float, ptr [[PE2]], align 4
; DEFAULT-NEXT:    [[PE3:%.*]] = getelementptr inbounds float, ptr [[P]], i64 3
; DEFAULT-NEXT:    [[E3:%.*]] = load float, ptr [[PE3]], align 4
; DEFAULT-NEXT:    [[A0:%.*]] = tail call i32 @llvm.fptosi.sat.i32.f32(float [[E0]])
; DEFAULT-NEXT:    [[A1:%.*]] = tail call i32 @llvm.fptosi.sat.i32.f32(float [[E1]])
; DEFAULT-NEXT:    [[A2:%.*]] = tail call i32 @llvm.fptosi.sat.i32.f32(float [[E2]])
; DEFAULT-NEXT:    [[A3:%.*]] = tail call i32 @llvm.fptosi.sat.i32.f32(float [[E3]])
; DEFAULT-NEXT:    store i32 [[A0]], ptr [[DST]], align 4
; DEFAULT-NEXT:    [[PA1:%.*]] = getelementptr inbounds i32, ptr [[DST]], i64 1
; DEFAULT-NEXT:    store i32 [[A1]], ptr [[PA1]], align 4
; DEFAULT-NEXT:    [[PA2:%.*]] = getelementptr inbounds i32, ptr [[DST]], i64 2
; DEFAULT-NEXT:    store i32 [[A2]], ptr [[PA2]], align 4
; DEFAULT-NEXT:    [[PA3:%.*]] = getelementptr inbounds i32, ptr [[DST]], i64 3
; DEFAULT-NEXT:    store i32 [[A3]], ptr [[PA3]], align 4
; DEFAULT-NEXT:    ret void
;
entry:
  %e0 = load float, ptr %p, align 4
  %pe1 = getelementptr inbounds float, ptr %p, i64 1
  %e1 = load float, ptr %pe1, align 4
  %pe2 = getelementptr inbounds float, ptr %p, i64 2
  %e2 = load float, ptr %pe2, align 4
  %pe3 = getelementptr inbounds float, ptr %p, i64 3
  %e3 = load float, ptr %pe3, align 4

  %a0 = tail call i32 @llvm.fptosi.sat.i32.f32(float %e0)
  %a1 = tail call i32 @llvm.fptosi.sat.i32.f32(float %e1)
  %a2 = tail call i32 @llvm.fptosi.sat.i32.f32(float %e2)
  %a3 = tail call i32 @llvm.fptosi.sat.i32.f32(float %e3)

  store i32 %a0, ptr %dst, align 4
  %pa1 = getelementptr inbounds i32, ptr %dst, i64 1
  store i32 %a1, ptr %pa1, align 4
  %pa2 = getelementptr inbounds i32, ptr %dst, i64 2
  store i32 %a2, ptr %pa2, align 4
  %pa3 = getelementptr inbounds i32, ptr %dst, i64 3
  store i32 %a3, ptr %pa3, align 4

  ret void
}
