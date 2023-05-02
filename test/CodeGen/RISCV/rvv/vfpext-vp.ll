; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+d,+zfh,+experimental-zvfh,+v -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -mtriple=riscv64 -mattr=+d,+zfh,+experimental-zvfh,+v -verify-machineinstrs < %s | FileCheck %s

declare <vscale x 2 x float> @llvm.vp.fpext.nxv2f32.nxv2f16(<vscale x 2 x half>, <vscale x 2 x i1>, i32)

define <vscale x 2 x float> @vfpext_nxv2f16_nxv2f32(<vscale x 2 x half> %a, <vscale x 2 x i1> %m, i32 zeroext %vl) {
; CHECK-LABEL: vfpext_nxv2f16_nxv2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, ta, ma
; CHECK-NEXT:    vfwcvt.f.f.v v9, v8, v0.t
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x float> @llvm.vp.fpext.nxv2f32.nxv2f16(<vscale x 2 x half> %a, <vscale x 2 x i1> %m, i32 %vl)
  ret <vscale x 2 x float> %v
}

define <vscale x 2 x float> @vfpext_nxv2f16_nxv2f32_unmasked(<vscale x 2 x half> %a, i32 zeroext %vl) {
; CHECK-LABEL: vfpext_nxv2f16_nxv2f32_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, ta, ma
; CHECK-NEXT:    vfwcvt.f.f.v v9, v8
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x float> @llvm.vp.fpext.nxv2f32.nxv2f16(<vscale x 2 x half> %a, <vscale x 2 x i1> shufflevector (<vscale x 2 x i1> insertelement (<vscale x 2 x i1> undef, i1 true, i32 0), <vscale x 2 x i1> undef, <vscale x 2 x i32> zeroinitializer), i32 %vl)
  ret <vscale x 2 x float> %v
}

declare <vscale x 2 x double> @llvm.vp.fpext.nxv2f64.nxv2f16(<vscale x 2 x half>, <vscale x 2 x i1>, i32)

define <vscale x 2 x double> @vfpext_nxv2f16_nxv2f64(<vscale x 2 x half> %a, <vscale x 2 x i1> %m, i32 zeroext %vl) {
; CHECK-LABEL: vfpext_nxv2f16_nxv2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, ta, ma
; CHECK-NEXT:    vfwcvt.f.f.v v10, v8, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e32, m1, ta, ma
; CHECK-NEXT:    vfwcvt.f.f.v v8, v10, v0.t
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x double> @llvm.vp.fpext.nxv2f64.nxv2f16(<vscale x 2 x half> %a, <vscale x 2 x i1> %m, i32 %vl)
  ret <vscale x 2 x double> %v
}

define <vscale x 2 x double> @vfpext_nxv2f16_nxv2f64_unmasked(<vscale x 2 x half> %a, i32 zeroext %vl) {
; CHECK-LABEL: vfpext_nxv2f16_nxv2f64_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, ta, ma
; CHECK-NEXT:    vfwcvt.f.f.v v10, v8
; CHECK-NEXT:    vsetvli zero, zero, e32, m1, ta, ma
; CHECK-NEXT:    vfwcvt.f.f.v v8, v10
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x double> @llvm.vp.fpext.nxv2f64.nxv2f16(<vscale x 2 x half> %a, <vscale x 2 x i1> shufflevector (<vscale x 2 x i1> insertelement (<vscale x 2 x i1> undef, i1 true, i32 0), <vscale x 2 x i1> undef, <vscale x 2 x i32> zeroinitializer), i32 %vl)
  ret <vscale x 2 x double> %v
}

declare <vscale x 2 x double> @llvm.vp.fpext.nxv2f64.nxv2f32(<vscale x 2 x float>, <vscale x 2 x i1>, i32)

define <vscale x 2 x double> @vfpext_nxv2f32_nxv2f64(<vscale x 2 x float> %a, <vscale x 2 x i1> %m, i32 zeroext %vl) {
; CHECK-LABEL: vfpext_nxv2f32_nxv2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, ma
; CHECK-NEXT:    vfwcvt.f.f.v v10, v8, v0.t
; CHECK-NEXT:    vmv2r.v v8, v10
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x double> @llvm.vp.fpext.nxv2f64.nxv2f32(<vscale x 2 x float> %a, <vscale x 2 x i1> %m, i32 %vl)
  ret <vscale x 2 x double> %v
}

define <vscale x 2 x double> @vfpext_nxv2f32_nxv2f64_unmasked(<vscale x 2 x float> %a, i32 zeroext %vl) {
; CHECK-LABEL: vfpext_nxv2f32_nxv2f64_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, ma
; CHECK-NEXT:    vfwcvt.f.f.v v10, v8
; CHECK-NEXT:    vmv2r.v v8, v10
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x double> @llvm.vp.fpext.nxv2f64.nxv2f32(<vscale x 2 x float> %a, <vscale x 2 x i1> shufflevector (<vscale x 2 x i1> insertelement (<vscale x 2 x i1> undef, i1 true, i32 0), <vscale x 2 x i1> undef, <vscale x 2 x i32> zeroinitializer), i32 %vl)
  ret <vscale x 2 x double> %v
}

declare <vscale x 7 x double> @llvm.vp.fpext.nxv7f64.nxv7f32(<vscale x 7 x float>, <vscale x 7 x i1>, i32)

define <vscale x 7 x double> @vfpext_nxv7f32_nxv7f64(<vscale x 7 x float> %a, <vscale x 7 x i1> %m, i32 zeroext %vl) {
; CHECK-LABEL: vfpext_nxv7f32_nxv7f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m4, ta, ma
; CHECK-NEXT:    vfwcvt.f.f.v v16, v8, v0.t
; CHECK-NEXT:    vmv8r.v v8, v16
; CHECK-NEXT:    ret
  %v = call <vscale x 7 x double> @llvm.vp.fpext.nxv7f64.nxv7f32(<vscale x 7 x float> %a, <vscale x 7 x i1> %m, i32 %vl)
  ret <vscale x 7 x double> %v
}

declare <vscale x 32 x float> @llvm.vp.fpext.nxv32f32.nxv32f16(<vscale x 32 x half>, <vscale x 32 x i1>, i32)

define <vscale x 32 x float> @vfpext_nxv32f16_nxv32f32(<vscale x 32 x half> %a, <vscale x 32 x i1> %m, i32 zeroext %vl) {
; CHECK-LABEL: vfpext_nxv32f16_nxv32f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v24, v0
; CHECK-NEXT:    csrr a1, vlenb
; CHECK-NEXT:    srli a2, a1, 2
; CHECK-NEXT:    vsetvli a3, zero, e8, mf2, ta, ma
; CHECK-NEXT:    vslidedown.vx v0, v0, a2
; CHECK-NEXT:    slli a1, a1, 1
; CHECK-NEXT:    sub a2, a0, a1
; CHECK-NEXT:    sltu a3, a0, a2
; CHECK-NEXT:    addi a3, a3, -1
; CHECK-NEXT:    and a2, a3, a2
; CHECK-NEXT:    vsetvli zero, a2, e16, m4, ta, ma
; CHECK-NEXT:    vfwcvt.f.f.v v16, v12, v0.t
; CHECK-NEXT:    bltu a0, a1, .LBB7_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    mv a0, a1
; CHECK-NEXT:  .LBB7_2:
; CHECK-NEXT:    vsetvli zero, a0, e16, m4, ta, ma
; CHECK-NEXT:    vmv1r.v v0, v24
; CHECK-NEXT:    vfwcvt.f.f.v v24, v8, v0.t
; CHECK-NEXT:    vmv8r.v v8, v24
; CHECK-NEXT:    ret
  %v = call <vscale x 32 x float> @llvm.vp.fpext.nxv32f32.nxv32f16(<vscale x 32 x half> %a, <vscale x 32 x i1> %m, i32 %vl)
  ret <vscale x 32 x float> %v
}
