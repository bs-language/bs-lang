; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+v -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s --check-prefixes=CHECK
; RUN: llc -mtriple=riscv64 -mattr=+v -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s --check-prefixes=CHECK

declare <2 x i1> @llvm.vp.mul.v2i1(<2 x i1>, <2 x i1>, <2 x i1>, i32)

define <2 x i1> @vmul_vv_v2i1(<2 x i1> %va, <2 x i1> %b, <2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vmul_vv_v2i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, mf8, ta, ma
; CHECK-NEXT:    vmand.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <2 x i1> @llvm.vp.mul.v2i1(<2 x i1> %va, <2 x i1> %b, <2 x i1> %m, i32 %evl)
  ret <2 x i1> %v
}

declare <4 x i1> @llvm.vp.mul.v4i1(<4 x i1>, <4 x i1>, <4 x i1>, i32)

define <4 x i1> @vmul_vv_v4i1(<4 x i1> %va, <4 x i1> %b, <4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vmul_vv_v4i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, mf4, ta, ma
; CHECK-NEXT:    vmand.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <4 x i1> @llvm.vp.mul.v4i1(<4 x i1> %va, <4 x i1> %b, <4 x i1> %m, i32 %evl)
  ret <4 x i1> %v
}

declare <8 x i1> @llvm.vp.mul.v8i1(<8 x i1>, <8 x i1>, <8 x i1>, i32)

define <8 x i1> @vmul_vv_v8i1(<8 x i1> %va, <8 x i1> %b, <8 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vmul_vv_v8i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, mf2, ta, ma
; CHECK-NEXT:    vmand.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <8 x i1> @llvm.vp.mul.v8i1(<8 x i1> %va, <8 x i1> %b, <8 x i1> %m, i32 %evl)
  ret <8 x i1> %v
}

declare <16 x i1> @llvm.vp.mul.v16i1(<16 x i1>, <16 x i1>, <16 x i1>, i32)

define <16 x i1> @vmul_vv_v16i1(<16 x i1> %va, <16 x i1> %b, <16 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vmul_vv_v16i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, m1, ta, ma
; CHECK-NEXT:    vmand.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <16 x i1> @llvm.vp.mul.v16i1(<16 x i1> %va, <16 x i1> %b, <16 x i1> %m, i32 %evl)
  ret <16 x i1> %v
}

declare <32 x i1> @llvm.vp.mul.v32i1(<32 x i1>, <32 x i1>, <32 x i1>, i32)

define <32 x i1> @vmul_vv_v32i1(<32 x i1> %va, <32 x i1> %b, <32 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vmul_vv_v32i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, m2, ta, ma
; CHECK-NEXT:    vmand.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <32 x i1> @llvm.vp.mul.v32i1(<32 x i1> %va, <32 x i1> %b, <32 x i1> %m, i32 %evl)
  ret <32 x i1> %v
}

declare <64 x i1> @llvm.vp.mul.v64i1(<64 x i1>, <64 x i1>, <64 x i1>, i32)

define <64 x i1> @vmul_vv_v64i1(<64 x i1> %va, <64 x i1> %b, <64 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vmul_vv_v64i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e8, m4, ta, ma
; CHECK-NEXT:    vmand.mm v0, v0, v8
; CHECK-NEXT:    ret
  %v = call <64 x i1> @llvm.vp.mul.v64i1(<64 x i1> %va, <64 x i1> %b, <64 x i1> %m, i32 %evl)
  ret <64 x i1> %v
}
