; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+zfh,+experimental-zfa,+experimental-zvfh,+v -target-abi ilp32d -verify-machineinstrs < %s \
; RUN:   | FileCheck %s --check-prefixes=CHECK
; RUN: llc -mtriple=riscv64 -mattr=+zfh,+experimental-zfa,+experimental-zvfh,+v -target-abi lp64d -verify-machineinstrs < %s \
; RUN:   | FileCheck %s --check-prefixes=CHECK

define <vscale x 8 x half> @vsplat_f16_0p625() {
; CHECK-LABEL: vsplat_f16_0p625:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fli.h ft0, 0.625
; CHECK-NEXT:    vsetvli a0, zero, e16, m2, ta, ma
; CHECK-NEXT:    vfmv.v.f v8, ft0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x half> poison, half 0.625, i32 0
  %splat = shufflevector <vscale x 8 x half> %head, <vscale x 8 x half> poison, <vscale x 8 x i32> zeroinitializer
  ret <vscale x 8 x half> %splat
}

define <vscale x 8 x float> @vsplat_f32_0p75() {
; CHECK-LABEL: vsplat_f32_0p75:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fli.s ft0, 0.75
; CHECK-NEXT:    vsetvli a0, zero, e32, m4, ta, ma
; CHECK-NEXT:    vfmv.v.f v8, ft0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x float> poison, float 0.75, i32 0
  %splat = shufflevector <vscale x 8 x float> %head, <vscale x 8 x float> poison, <vscale x 8 x i32> zeroinitializer
  ret <vscale x 8 x float> %splat
}

define <vscale x 8 x double> @vsplat_f64_neg1() {
; CHECK-LABEL: vsplat_f64_neg1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fli.d ft0, -1.0
; CHECK-NEXT:    vsetvli a0, zero, e64, m8, ta, ma
; CHECK-NEXT:    vfmv.v.f v8, ft0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x double> poison, double -1.0, i32 0
  %splat = shufflevector <vscale x 8 x double> %head, <vscale x 8 x double> poison, <vscale x 8 x i32> zeroinitializer
  ret <vscale x 8 x double> %splat
}
