; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=riscv64 -mattr=+v | FileCheck %s

define <vscale x 2 x i32> @vwadd_tu(<vscale x 2 x i8> %arg, <vscale x 2 x i32> %arg1, i32 signext %arg2) {
; CHECK-LABEL: vwadd_tu:
; CHECK:       # %bb.0: # %bb
; CHECK-NEXT:    slli a0, a0, 32
; CHECK-NEXT:    srli a0, a0, 32
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, ta, ma
; CHECK-NEXT:    vsext.vf2 v10, v8
; CHECK-NEXT:    vsetvli zero, zero, e16, mf2, tu, ma
; CHECK-NEXT:    vwadd.wv v9, v9, v10
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
bb:
  %tmp = call <vscale x 2 x i32> @llvm.vp.sext.nxv2i32.nxv2i8(<vscale x 2 x i8> %arg, <vscale x 2 x i1> shufflevector (<vscale x 2 x i1> insertelement (<vscale x 2 x i1> poison, i1 true, i32 0), <vscale x 2 x i1> poison, <vscale x 2 x i32> zeroinitializer), i32 %arg2)
  %tmp3 = call <vscale x 2 x i32> @llvm.vp.add.nxv2i32(<vscale x 2 x i32> %arg1, <vscale x 2 x i32> %tmp, <vscale x 2 x i1> shufflevector (<vscale x 2 x i1> insertelement (<vscale x 2 x i1> poison, i1 true, i32 0), <vscale x 2 x i1> poison, <vscale x 2 x i32> zeroinitializer), i32 %arg2)
  %tmp4 = call <vscale x 2 x i32> @llvm.vp.merge.nxv2i32(<vscale x 2 x i1> shufflevector (<vscale x 2 x i1> insertelement (<vscale x 2 x i1> poison, i1 true, i32 0), <vscale x 2 x i1> poison, <vscale x 2 x i32> zeroinitializer), <vscale x 2 x i32> %tmp3, <vscale x 2 x i32> %arg1, i32 %arg2)
  ret <vscale x 2 x i32> %tmp4
}

define <vscale x 2 x i32> @vwaddu_tu(<vscale x 2 x i8> %arg, <vscale x 2 x i32> %arg1, i32 signext %arg2) {
; CHECK-LABEL: vwaddu_tu:
; CHECK:       # %bb.0: # %bb
; CHECK-NEXT:    slli a0, a0, 32
; CHECK-NEXT:    srli a0, a0, 32
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, ta, ma
; CHECK-NEXT:    vzext.vf2 v10, v8
; CHECK-NEXT:    vsetvli zero, zero, e16, mf2, tu, ma
; CHECK-NEXT:    vwaddu.wv v9, v9, v10
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
bb:
  %tmp = call <vscale x 2 x i32> @llvm.vp.zext.nxv2i32.nxv2i8(<vscale x 2 x i8> %arg, <vscale x 2 x i1> shufflevector (<vscale x 2 x i1> insertelement (<vscale x 2 x i1> poison, i1 true, i32 0), <vscale x 2 x i1> poison, <vscale x 2 x i32> zeroinitializer), i32 %arg2)
  %tmp3 = call <vscale x 2 x i32> @llvm.vp.add.nxv2i32(<vscale x 2 x i32> %arg1, <vscale x 2 x i32> %tmp, <vscale x 2 x i1> shufflevector (<vscale x 2 x i1> insertelement (<vscale x 2 x i1> poison, i1 true, i32 0), <vscale x 2 x i1> poison, <vscale x 2 x i32> zeroinitializer), i32 %arg2)
  %tmp4 = call <vscale x 2 x i32> @llvm.vp.merge.nxv2i32(<vscale x 2 x i1> shufflevector (<vscale x 2 x i1> insertelement (<vscale x 2 x i1> poison, i1 true, i32 0), <vscale x 2 x i1> poison, <vscale x 2 x i32> zeroinitializer), <vscale x 2 x i32> %tmp3, <vscale x 2 x i32> %arg1, i32 %arg2)
  ret <vscale x 2 x i32> %tmp4
}

declare <vscale x 2 x i32> @llvm.vp.sext.nxv2i32.nxv2i8(<vscale x 2 x i8>, <vscale x 2 x i1>, i32)
declare <vscale x 2 x i32> @llvm.vp.zext.nxv2i32.nxv2i8(<vscale x 2 x i8>, <vscale x 2 x i1>, i32)
declare <vscale x 2 x i32> @llvm.vp.add.nxv2i32(<vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i1>, i32)
declare <vscale x 2 x i32> @llvm.vp.merge.nxv2i32(<vscale x 2 x i1>, <vscale x 2 x i32>, <vscale x 2 x i32>, i32)
