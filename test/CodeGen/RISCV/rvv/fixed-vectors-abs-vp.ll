; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py ; RUN: llc -mtriple=riscv32 -mattr=+d,+zfh,+experimental-zvfh,+v,+m -target-abi=ilp32d -riscv-v-vector-bits-min=128 \
; RUN:   -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK
; RUN: llc -mtriple=riscv64 -mattr=+d,+zfh,+experimental-zvfh,+v,+m -target-abi=lp64d -riscv-v-vector-bits-min=128 \
; RUN:   -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK

declare <2 x i8> @llvm.vp.abs.v2i8(<2 x i8>, i1 immarg, <2 x i1>, i32)

define <2 x i8> @vp_abs_v2i8(<2 x i8> %va, <2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v2i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, mf8, ta, ma
; CHECK-NEXT:    vrsub.vi v9, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v9, v0.t
; CHECK-NEXT:    ret
  %v = call <2 x i8> @llvm.vp.abs.v2i8(<2 x i8> %va, i1 false, <2 x i1> %m, i32 %evl)
  ret <2 x i8> %v
}

define <2 x i8> @vp_abs_v2i8_unmasked(<2 x i8> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v2i8_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e8, mf8, ta, ma
; CHECK-NEXT:    vmset.m v0
; CHECK-NEXT:    vsetvli zero, a0, e8, mf8, ta, ma
; CHECK-NEXT:    vrsub.vi v9, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v9, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <2 x i1> poison, i1 true, i32 0
  %m = shufflevector <2 x i1> %head, <2 x i1> poison, <2 x i32> zeroinitializer
  %v = call <2 x i8> @llvm.vp.abs.v2i8(<2 x i8> %va, i1 false, <2 x i1> %m, i32 %evl)
  ret <2 x i8> %v
}

declare <4 x i8> @llvm.vp.abs.v4i8(<4 x i8>, i1 immarg, <4 x i1>, i32)

define <4 x i8> @vp_abs_v4i8(<4 x i8> %va, <4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v4i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, mf4, ta, ma
; CHECK-NEXT:    vrsub.vi v9, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v9, v0.t
; CHECK-NEXT:    ret
  %v = call <4 x i8> @llvm.vp.abs.v4i8(<4 x i8> %va, i1 false, <4 x i1> %m, i32 %evl)
  ret <4 x i8> %v
}

define <4 x i8> @vp_abs_v4i8_unmasked(<4 x i8> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v4i8_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e8, mf4, ta, ma
; CHECK-NEXT:    vmset.m v0
; CHECK-NEXT:    vsetvli zero, a0, e8, mf4, ta, ma
; CHECK-NEXT:    vrsub.vi v9, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v9, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <4 x i1> poison, i1 true, i32 0
  %m = shufflevector <4 x i1> %head, <4 x i1> poison, <4 x i32> zeroinitializer
  %v = call <4 x i8> @llvm.vp.abs.v4i8(<4 x i8> %va, i1 false, <4 x i1> %m, i32 %evl)
  ret <4 x i8> %v
}

declare <8 x i8> @llvm.vp.abs.v8i8(<8 x i8>, i1 immarg, <8 x i1>, i32)

define <8 x i8> @vp_abs_v8i8(<8 x i8> %va, <8 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v8i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, mf2, ta, ma
; CHECK-NEXT:    vrsub.vi v9, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v9, v0.t
; CHECK-NEXT:    ret
  %v = call <8 x i8> @llvm.vp.abs.v8i8(<8 x i8> %va, i1 false, <8 x i1> %m, i32 %evl)
  ret <8 x i8> %v
}

define <8 x i8> @vp_abs_v8i8_unmasked(<8 x i8> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v8i8_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, ma
; CHECK-NEXT:    vmset.m v0
; CHECK-NEXT:    vsetvli zero, a0, e8, mf2, ta, ma
; CHECK-NEXT:    vrsub.vi v9, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v9, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <8 x i1> poison, i1 true, i32 0
  %m = shufflevector <8 x i1> %head, <8 x i1> poison, <8 x i32> zeroinitializer
  %v = call <8 x i8> @llvm.vp.abs.v8i8(<8 x i8> %va, i1 false, <8 x i1> %m, i32 %evl)
  ret <8 x i8> %v
}

declare <16 x i8> @llvm.vp.abs.v16i8(<16 x i8>, i1 immarg, <16 x i1>, i32)

define <16 x i8> @vp_abs_v16i8(<16 x i8> %va, <16 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v16i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, m1, ta, ma
; CHECK-NEXT:    vrsub.vi v9, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v9, v0.t
; CHECK-NEXT:    ret
  %v = call <16 x i8> @llvm.vp.abs.v16i8(<16 x i8> %va, i1 false, <16 x i1> %m, i32 %evl)
  ret <16 x i8> %v
}

define <16 x i8> @vp_abs_v16i8_unmasked(<16 x i8> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v16i8_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e8, m1, ta, ma
; CHECK-NEXT:    vmset.m v0
; CHECK-NEXT:    vsetvli zero, a0, e8, m1, ta, ma
; CHECK-NEXT:    vrsub.vi v9, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v9, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <16 x i1> poison, i1 true, i32 0
  %m = shufflevector <16 x i1> %head, <16 x i1> poison, <16 x i32> zeroinitializer
  %v = call <16 x i8> @llvm.vp.abs.v16i8(<16 x i8> %va, i1 false, <16 x i1> %m, i32 %evl)
  ret <16 x i8> %v
}

declare <2 x i16> @llvm.vp.abs.v2i16(<2 x i16>, i1 immarg, <2 x i1>, i32)

define <2 x i16> @vp_abs_v2i16(<2 x i16> %va, <2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e16, mf4, ta, ma
; CHECK-NEXT:    vrsub.vi v9, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v9, v0.t
; CHECK-NEXT:    ret
  %v = call <2 x i16> @llvm.vp.abs.v2i16(<2 x i16> %va, i1 false, <2 x i1> %m, i32 %evl)
  ret <2 x i16> %v
}

define <2 x i16> @vp_abs_v2i16_unmasked(<2 x i16> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v2i16_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e8, mf8, ta, ma
; CHECK-NEXT:    vmset.m v0
; CHECK-NEXT:    vsetvli zero, a0, e16, mf4, ta, ma
; CHECK-NEXT:    vrsub.vi v9, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v9, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <2 x i1> poison, i1 true, i32 0
  %m = shufflevector <2 x i1> %head, <2 x i1> poison, <2 x i32> zeroinitializer
  %v = call <2 x i16> @llvm.vp.abs.v2i16(<2 x i16> %va, i1 false, <2 x i1> %m, i32 %evl)
  ret <2 x i16> %v
}

declare <4 x i16> @llvm.vp.abs.v4i16(<4 x i16>, i1 immarg, <4 x i1>, i32)

define <4 x i16> @vp_abs_v4i16(<4 x i16> %va, <4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, ta, ma
; CHECK-NEXT:    vrsub.vi v9, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v9, v0.t
; CHECK-NEXT:    ret
  %v = call <4 x i16> @llvm.vp.abs.v4i16(<4 x i16> %va, i1 false, <4 x i1> %m, i32 %evl)
  ret <4 x i16> %v
}

define <4 x i16> @vp_abs_v4i16_unmasked(<4 x i16> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v4i16_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e8, mf4, ta, ma
; CHECK-NEXT:    vmset.m v0
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, ta, ma
; CHECK-NEXT:    vrsub.vi v9, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v9, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <4 x i1> poison, i1 true, i32 0
  %m = shufflevector <4 x i1> %head, <4 x i1> poison, <4 x i32> zeroinitializer
  %v = call <4 x i16> @llvm.vp.abs.v4i16(<4 x i16> %va, i1 false, <4 x i1> %m, i32 %evl)
  ret <4 x i16> %v
}

declare <8 x i16> @llvm.vp.abs.v8i16(<8 x i16>, i1 immarg, <8 x i1>, i32)

define <8 x i16> @vp_abs_v8i16(<8 x i16> %va, <8 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e16, m1, ta, ma
; CHECK-NEXT:    vrsub.vi v9, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v9, v0.t
; CHECK-NEXT:    ret
  %v = call <8 x i16> @llvm.vp.abs.v8i16(<8 x i16> %va, i1 false, <8 x i1> %m, i32 %evl)
  ret <8 x i16> %v
}

define <8 x i16> @vp_abs_v8i16_unmasked(<8 x i16> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v8i16_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, ma
; CHECK-NEXT:    vmset.m v0
; CHECK-NEXT:    vsetvli zero, a0, e16, m1, ta, ma
; CHECK-NEXT:    vrsub.vi v9, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v9, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <8 x i1> poison, i1 true, i32 0
  %m = shufflevector <8 x i1> %head, <8 x i1> poison, <8 x i32> zeroinitializer
  %v = call <8 x i16> @llvm.vp.abs.v8i16(<8 x i16> %va, i1 false, <8 x i1> %m, i32 %evl)
  ret <8 x i16> %v
}

declare <16 x i16> @llvm.vp.abs.v16i16(<16 x i16>, i1 immarg, <16 x i1>, i32)

define <16 x i16> @vp_abs_v16i16(<16 x i16> %va, <16 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v16i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e16, m2, ta, ma
; CHECK-NEXT:    vrsub.vi v10, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v10, v0.t
; CHECK-NEXT:    ret
  %v = call <16 x i16> @llvm.vp.abs.v16i16(<16 x i16> %va, i1 false, <16 x i1> %m, i32 %evl)
  ret <16 x i16> %v
}

define <16 x i16> @vp_abs_v16i16_unmasked(<16 x i16> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v16i16_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e8, m1, ta, ma
; CHECK-NEXT:    vmset.m v0
; CHECK-NEXT:    vsetvli zero, a0, e16, m2, ta, ma
; CHECK-NEXT:    vrsub.vi v10, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v10, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <16 x i1> poison, i1 true, i32 0
  %m = shufflevector <16 x i1> %head, <16 x i1> poison, <16 x i32> zeroinitializer
  %v = call <16 x i16> @llvm.vp.abs.v16i16(<16 x i16> %va, i1 false, <16 x i1> %m, i32 %evl)
  ret <16 x i16> %v
}

declare <2 x i32> @llvm.vp.abs.v2i32(<2 x i32>, i1 immarg, <2 x i1>, i32)

define <2 x i32> @vp_abs_v2i32(<2 x i32> %va, <2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, mf2, ta, ma
; CHECK-NEXT:    vrsub.vi v9, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v9, v0.t
; CHECK-NEXT:    ret
  %v = call <2 x i32> @llvm.vp.abs.v2i32(<2 x i32> %va, i1 false, <2 x i1> %m, i32 %evl)
  ret <2 x i32> %v
}

define <2 x i32> @vp_abs_v2i32_unmasked(<2 x i32> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v2i32_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e8, mf8, ta, ma
; CHECK-NEXT:    vmset.m v0
; CHECK-NEXT:    vsetvli zero, a0, e32, mf2, ta, ma
; CHECK-NEXT:    vrsub.vi v9, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v9, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <2 x i1> poison, i1 true, i32 0
  %m = shufflevector <2 x i1> %head, <2 x i1> poison, <2 x i32> zeroinitializer
  %v = call <2 x i32> @llvm.vp.abs.v2i32(<2 x i32> %va, i1 false, <2 x i1> %m, i32 %evl)
  ret <2 x i32> %v
}

declare <4 x i32> @llvm.vp.abs.v4i32(<4 x i32>, i1 immarg, <4 x i1>, i32)

define <4 x i32> @vp_abs_v4i32(<4 x i32> %va, <4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, ma
; CHECK-NEXT:    vrsub.vi v9, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v9, v0.t
; CHECK-NEXT:    ret
  %v = call <4 x i32> @llvm.vp.abs.v4i32(<4 x i32> %va, i1 false, <4 x i1> %m, i32 %evl)
  ret <4 x i32> %v
}

define <4 x i32> @vp_abs_v4i32_unmasked(<4 x i32> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v4i32_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e8, mf4, ta, ma
; CHECK-NEXT:    vmset.m v0
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, ma
; CHECK-NEXT:    vrsub.vi v9, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v9, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <4 x i1> poison, i1 true, i32 0
  %m = shufflevector <4 x i1> %head, <4 x i1> poison, <4 x i32> zeroinitializer
  %v = call <4 x i32> @llvm.vp.abs.v4i32(<4 x i32> %va, i1 false, <4 x i1> %m, i32 %evl)
  ret <4 x i32> %v
}

declare <8 x i32> @llvm.vp.abs.v8i32(<8 x i32>, i1 immarg, <8 x i1>, i32)

define <8 x i32> @vp_abs_v8i32(<8 x i32> %va, <8 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v8i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m2, ta, ma
; CHECK-NEXT:    vrsub.vi v10, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v10, v0.t
; CHECK-NEXT:    ret
  %v = call <8 x i32> @llvm.vp.abs.v8i32(<8 x i32> %va, i1 false, <8 x i1> %m, i32 %evl)
  ret <8 x i32> %v
}

define <8 x i32> @vp_abs_v8i32_unmasked(<8 x i32> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v8i32_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, ma
; CHECK-NEXT:    vmset.m v0
; CHECK-NEXT:    vsetvli zero, a0, e32, m2, ta, ma
; CHECK-NEXT:    vrsub.vi v10, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v10, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <8 x i1> poison, i1 true, i32 0
  %m = shufflevector <8 x i1> %head, <8 x i1> poison, <8 x i32> zeroinitializer
  %v = call <8 x i32> @llvm.vp.abs.v8i32(<8 x i32> %va, i1 false, <8 x i1> %m, i32 %evl)
  ret <8 x i32> %v
}

declare <16 x i32> @llvm.vp.abs.v16i32(<16 x i32>, i1 immarg, <16 x i1>, i32)

define <16 x i32> @vp_abs_v16i32(<16 x i32> %va, <16 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v16i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m4, ta, ma
; CHECK-NEXT:    vrsub.vi v12, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v12, v0.t
; CHECK-NEXT:    ret
  %v = call <16 x i32> @llvm.vp.abs.v16i32(<16 x i32> %va, i1 false, <16 x i1> %m, i32 %evl)
  ret <16 x i32> %v
}

define <16 x i32> @vp_abs_v16i32_unmasked(<16 x i32> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v16i32_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e8, m1, ta, ma
; CHECK-NEXT:    vmset.m v0
; CHECK-NEXT:    vsetvli zero, a0, e32, m4, ta, ma
; CHECK-NEXT:    vrsub.vi v12, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v12, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <16 x i1> poison, i1 true, i32 0
  %m = shufflevector <16 x i1> %head, <16 x i1> poison, <16 x i32> zeroinitializer
  %v = call <16 x i32> @llvm.vp.abs.v16i32(<16 x i32> %va, i1 false, <16 x i1> %m, i32 %evl)
  ret <16 x i32> %v
}

declare <2 x i64> @llvm.vp.abs.v2i64(<2 x i64>, i1 immarg, <2 x i1>, i32)

define <2 x i64> @vp_abs_v2i64(<2 x i64> %va, <2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, ma
; CHECK-NEXT:    vrsub.vi v9, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v9, v0.t
; CHECK-NEXT:    ret
  %v = call <2 x i64> @llvm.vp.abs.v2i64(<2 x i64> %va, i1 false, <2 x i1> %m, i32 %evl)
  ret <2 x i64> %v
}

define <2 x i64> @vp_abs_v2i64_unmasked(<2 x i64> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v2i64_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e8, mf8, ta, ma
; CHECK-NEXT:    vmset.m v0
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, ma
; CHECK-NEXT:    vrsub.vi v9, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v9, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <2 x i1> poison, i1 true, i32 0
  %m = shufflevector <2 x i1> %head, <2 x i1> poison, <2 x i32> zeroinitializer
  %v = call <2 x i64> @llvm.vp.abs.v2i64(<2 x i64> %va, i1 false, <2 x i1> %m, i32 %evl)
  ret <2 x i64> %v
}

declare <4 x i64> @llvm.vp.abs.v4i64(<4 x i64>, i1 immarg, <4 x i1>, i32)

define <4 x i64> @vp_abs_v4i64(<4 x i64> %va, <4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v4i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e64, m2, ta, ma
; CHECK-NEXT:    vrsub.vi v10, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v10, v0.t
; CHECK-NEXT:    ret
  %v = call <4 x i64> @llvm.vp.abs.v4i64(<4 x i64> %va, i1 false, <4 x i1> %m, i32 %evl)
  ret <4 x i64> %v
}

define <4 x i64> @vp_abs_v4i64_unmasked(<4 x i64> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v4i64_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e8, mf4, ta, ma
; CHECK-NEXT:    vmset.m v0
; CHECK-NEXT:    vsetvli zero, a0, e64, m2, ta, ma
; CHECK-NEXT:    vrsub.vi v10, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v10, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <4 x i1> poison, i1 true, i32 0
  %m = shufflevector <4 x i1> %head, <4 x i1> poison, <4 x i32> zeroinitializer
  %v = call <4 x i64> @llvm.vp.abs.v4i64(<4 x i64> %va, i1 false, <4 x i1> %m, i32 %evl)
  ret <4 x i64> %v
}

declare <8 x i64> @llvm.vp.abs.v8i64(<8 x i64>, i1 immarg, <8 x i1>, i32)

define <8 x i64> @vp_abs_v8i64(<8 x i64> %va, <8 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v8i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e64, m4, ta, ma
; CHECK-NEXT:    vrsub.vi v12, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v12, v0.t
; CHECK-NEXT:    ret
  %v = call <8 x i64> @llvm.vp.abs.v8i64(<8 x i64> %va, i1 false, <8 x i1> %m, i32 %evl)
  ret <8 x i64> %v
}

define <8 x i64> @vp_abs_v8i64_unmasked(<8 x i64> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v8i64_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, ma
; CHECK-NEXT:    vmset.m v0
; CHECK-NEXT:    vsetvli zero, a0, e64, m4, ta, ma
; CHECK-NEXT:    vrsub.vi v12, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v12, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <8 x i1> poison, i1 true, i32 0
  %m = shufflevector <8 x i1> %head, <8 x i1> poison, <8 x i32> zeroinitializer
  %v = call <8 x i64> @llvm.vp.abs.v8i64(<8 x i64> %va, i1 false, <8 x i1> %m, i32 %evl)
  ret <8 x i64> %v
}

declare <15 x i64> @llvm.vp.abs.v15i64(<15 x i64>, i1 immarg, <15 x i1>, i32)

define <15 x i64> @vp_abs_v15i64(<15 x i64> %va, <15 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v15i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e64, m8, ta, ma
; CHECK-NEXT:    vrsub.vi v16, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v16, v0.t
; CHECK-NEXT:    ret
  %v = call <15 x i64> @llvm.vp.abs.v15i64(<15 x i64> %va, i1 false, <15 x i1> %m, i32 %evl)
  ret <15 x i64> %v
}

define <15 x i64> @vp_abs_v15i64_unmasked(<15 x i64> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v15i64_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e8, m1, ta, ma
; CHECK-NEXT:    vmset.m v0
; CHECK-NEXT:    vsetvli zero, a0, e64, m8, ta, ma
; CHECK-NEXT:    vrsub.vi v16, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v16, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <15 x i1> poison, i1 true, i32 0
  %m = shufflevector <15 x i1> %head, <15 x i1> poison, <15 x i32> zeroinitializer
  %v = call <15 x i64> @llvm.vp.abs.v15i64(<15 x i64> %va, i1 false, <15 x i1> %m, i32 %evl)
  ret <15 x i64> %v
}

declare <16 x i64> @llvm.vp.abs.v16i64(<16 x i64>, i1 immarg, <16 x i1>, i32)

define <16 x i64> @vp_abs_v16i64(<16 x i64> %va, <16 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v16i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e64, m8, ta, ma
; CHECK-NEXT:    vrsub.vi v16, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v16, v0.t
; CHECK-NEXT:    ret
  %v = call <16 x i64> @llvm.vp.abs.v16i64(<16 x i64> %va, i1 false, <16 x i1> %m, i32 %evl)
  ret <16 x i64> %v
}

define <16 x i64> @vp_abs_v16i64_unmasked(<16 x i64> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v16i64_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e8, m1, ta, ma
; CHECK-NEXT:    vmset.m v0
; CHECK-NEXT:    vsetvli zero, a0, e64, m8, ta, ma
; CHECK-NEXT:    vrsub.vi v16, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v16, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <16 x i1> poison, i1 true, i32 0
  %m = shufflevector <16 x i1> %head, <16 x i1> poison, <16 x i32> zeroinitializer
  %v = call <16 x i64> @llvm.vp.abs.v16i64(<16 x i64> %va, i1 false, <16 x i1> %m, i32 %evl)
  ret <16 x i64> %v
}

declare <32 x i64> @llvm.vp.abs.v32i64(<32 x i64>, i1 immarg, <32 x i1>, i32)

define <32 x i64> @vp_abs_v32i64(<32 x i64> %va, <32 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v32i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e8, mf4, ta, ma
; CHECK-NEXT:    li a2, 16
; CHECK-NEXT:    vslidedown.vi v1, v0, 2
; CHECK-NEXT:    mv a1, a0
; CHECK-NEXT:    bltu a0, a2, .LBB34_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    li a1, 16
; CHECK-NEXT:  .LBB34_2:
; CHECK-NEXT:    vsetvli zero, a1, e64, m8, ta, ma
; CHECK-NEXT:    vrsub.vi v24, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v24, v0.t
; CHECK-NEXT:    addi a1, a0, -16
; CHECK-NEXT:    sltu a0, a0, a1
; CHECK-NEXT:    addi a0, a0, -1
; CHECK-NEXT:    and a0, a0, a1
; CHECK-NEXT:    vsetvli zero, a0, e64, m8, ta, ma
; CHECK-NEXT:    vmv1r.v v0, v1
; CHECK-NEXT:    vrsub.vi v24, v16, 0, v0.t
; CHECK-NEXT:    vmax.vv v16, v16, v24, v0.t
; CHECK-NEXT:    ret
  %v = call <32 x i64> @llvm.vp.abs.v32i64(<32 x i64> %va, i1 false, <32 x i1> %m, i32 %evl)
  ret <32 x i64> %v
}

define <32 x i64> @vp_abs_v32i64_unmasked(<32 x i64> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_abs_v32i64_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e8, m1, ta, ma
; CHECK-NEXT:    li a2, 16
; CHECK-NEXT:    vmset.m v0
; CHECK-NEXT:    mv a1, a0
; CHECK-NEXT:    bltu a0, a2, .LBB35_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    li a1, 16
; CHECK-NEXT:  .LBB35_2:
; CHECK-NEXT:    vsetvli zero, a1, e64, m8, ta, ma
; CHECK-NEXT:    vrsub.vi v24, v8, 0, v0.t
; CHECK-NEXT:    vmax.vv v8, v8, v24, v0.t
; CHECK-NEXT:    addi a1, a0, -16
; CHECK-NEXT:    sltu a0, a0, a1
; CHECK-NEXT:    addi a0, a0, -1
; CHECK-NEXT:    and a0, a0, a1
; CHECK-NEXT:    vsetvli zero, a0, e64, m8, ta, ma
; CHECK-NEXT:    vrsub.vi v24, v16, 0, v0.t
; CHECK-NEXT:    vmax.vv v16, v16, v24, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <32 x i1> poison, i1 true, i32 0
  %m = shufflevector <32 x i1> %head, <32 x i1> poison, <32 x i32> zeroinitializer
  %v = call <32 x i64> @llvm.vp.abs.v32i64(<32 x i64> %va, i1 false, <32 x i1> %m, i32 %evl)
  ret <32 x i64> %v
}
