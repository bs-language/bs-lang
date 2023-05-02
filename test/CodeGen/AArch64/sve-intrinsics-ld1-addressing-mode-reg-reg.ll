; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sve < %s | FileCheck %s

;
; LD1B
;

define <vscale x 16 x i8> @ld1b_i8(<vscale x 16 x i1> %pg, ptr %a, i64 %index) {
; CHECK-LABEL: ld1b_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ld1b { z0.b }, p0/z, [x0, x1]
; CHECK-NEXT:    ret
  %base = getelementptr i8, ptr %a, i64 %index
  %load = call <vscale x 16 x i8> @llvm.aarch64.sve.ld1.nxv16i8(<vscale x 16 x i1> %pg, ptr %base)
  ret <vscale x 16 x i8> %load
}

define <vscale x 8 x i16> @ld1b_h(<vscale x 8 x i1> %pred, ptr %a, i64 %index) {
; CHECK-LABEL: ld1b_h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ld1b { z0.h }, p0/z, [x0, x1]
; CHECK-NEXT:    ret
  %base = getelementptr i8, ptr %a, i64 %index
  %load = call <vscale x 8 x i8> @llvm.aarch64.sve.ld1.nxv8i8(<vscale x 8 x i1> %pred, ptr %base)
  %res = zext <vscale x 8 x i8> %load to <vscale x 8 x i16>
  ret <vscale x 8 x i16> %res
}

define <vscale x 8 x i16> @ld1sb_h(<vscale x 8 x i1> %pred, ptr %a, i64 %index) {
; CHECK-LABEL: ld1sb_h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ld1sb { z0.h }, p0/z, [x0, x1]
; CHECK-NEXT:    ret
  %base = getelementptr i8, ptr %a, i64 %index
  %load = call <vscale x 8 x i8> @llvm.aarch64.sve.ld1.nxv8i8(<vscale x 8 x i1> %pred, ptr %base)
  %res = sext <vscale x 8 x i8> %load to <vscale x 8 x i16>
  ret <vscale x 8 x i16> %res
}

define <vscale x 4 x i32> @ld1b_s(<vscale x 4 x i1> %pred, ptr %a, i64 %index) {
; CHECK-LABEL: ld1b_s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ld1b { z0.s }, p0/z, [x0, x1]
; CHECK-NEXT:    ret
  %base = getelementptr i8, ptr %a, i64 %index
  %load = call <vscale x 4 x i8> @llvm.aarch64.sve.ld1.nxv4i8(<vscale x 4 x i1> %pred, ptr %base)
  %res = zext <vscale x 4 x i8> %load to <vscale x 4 x i32>
  ret <vscale x 4 x i32> %res
}

define <vscale x 4 x i32> @ld1sb_s(<vscale x 4 x i1> %pred, ptr %a, i64 %index) {
; CHECK-LABEL: ld1sb_s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ld1sb { z0.s }, p0/z, [x0, x1]
; CHECK-NEXT:    ret
  %base = getelementptr i8, ptr %a, i64 %index
  %load = call <vscale x 4 x i8> @llvm.aarch64.sve.ld1.nxv4i8(<vscale x 4 x i1> %pred, ptr %base)
  %res = sext <vscale x 4 x i8> %load to <vscale x 4 x i32>
  ret <vscale x 4 x i32> %res
}

define <vscale x 2 x i64> @ld1b_d(<vscale x 2 x i1> %pred, ptr %a, i64 %index) {
; CHECK-LABEL: ld1b_d:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ld1b { z0.d }, p0/z, [x0, x1]
; CHECK-NEXT:    ret
  %base = getelementptr i8, ptr %a, i64 %index
  %load = call <vscale x 2 x i8> @llvm.aarch64.sve.ld1.nxv2i8(<vscale x 2 x i1> %pred, ptr %base)
  %res = zext <vscale x 2 x i8> %load to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %res
}

define <vscale x 2 x i64> @ld1sb_d(<vscale x 2 x i1> %pred, ptr %a, i64 %index) {
; CHECK-LABEL: ld1sb_d:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ld1sb { z0.d }, p0/z, [x0, x1]
; CHECK-NEXT:    ret
  %base = getelementptr i8, ptr %a, i64 %index
  %load = call <vscale x 2 x i8> @llvm.aarch64.sve.ld1.nxv2i8(<vscale x 2 x i1> %pred, ptr %base)
  %res = sext <vscale x 2 x i8> %load to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %res
}

;
; LD1H
;

define <vscale x 8 x i16> @ld1h_i16(<vscale x 8 x i1> %pg, ptr %a, i64 %index) {
; CHECK-LABEL: ld1h_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ld1h { z0.h }, p0/z, [x0, x1, lsl #1]
; CHECK-NEXT:    ret
  %base = getelementptr i16, ptr %a, i64 %index
  %load = call <vscale x 8 x i16> @llvm.aarch64.sve.ld1.nxv8i16(<vscale x 8 x i1> %pg, ptr %base)
  ret <vscale x 8 x i16> %load
}

define <vscale x 8 x half> @ld1h_f16(<vscale x 8 x i1> %pg, ptr %a, i64 %index) {
; CHECK-LABEL: ld1h_f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ld1h { z0.h }, p0/z, [x0, x1, lsl #1]
; CHECK-NEXT:    ret
  %base = getelementptr half, ptr %a, i64 %index
  %load = call <vscale x 8 x half> @llvm.aarch64.sve.ld1.nxv8f16(<vscale x 8 x i1> %pg, ptr %base)
  ret <vscale x 8 x half> %load
}

define <vscale x 8 x bfloat> @ld1h_bf16(<vscale x 8 x i1> %pg, ptr %a, i64 %index) #0 {
; CHECK-LABEL: ld1h_bf16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ld1h { z0.h }, p0/z, [x0, x1, lsl #1]
; CHECK-NEXT:    ret
  %base = getelementptr bfloat, ptr %a, i64 %index
  %load = call <vscale x 8 x bfloat> @llvm.aarch64.sve.ld1.nxv8bf16(<vscale x 8 x i1> %pg, ptr %base)
  ret <vscale x 8 x bfloat> %load
}

define <vscale x 4 x i32> @ld1h_s(<vscale x 4 x i1> %pred, ptr %a, i64 %index) {
; CHECK-LABEL: ld1h_s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ld1h { z0.s }, p0/z, [x0, x1, lsl #1]
; CHECK-NEXT:    ret
  %base = getelementptr i16, ptr %a, i64 %index
  %load = call <vscale x 4 x i16> @llvm.aarch64.sve.ld1.nxv4i16(<vscale x 4 x i1> %pred, ptr %base)
  %res = zext <vscale x 4 x i16> %load to <vscale x 4 x i32>
  ret <vscale x 4 x i32> %res
}

define <vscale x 4 x i32> @ld1sh_s(<vscale x 4 x i1> %pred, ptr %a, i64 %index) {
; CHECK-LABEL: ld1sh_s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ld1sh { z0.s }, p0/z, [x0, x1, lsl #1]
; CHECK-NEXT:    ret
  %base = getelementptr i16, ptr %a, i64 %index
  %load = call <vscale x 4 x i16> @llvm.aarch64.sve.ld1.nxv4i16(<vscale x 4 x i1> %pred, ptr %base)
  %res = sext <vscale x 4 x i16> %load to <vscale x 4 x i32>
  ret <vscale x 4 x i32> %res
}

define <vscale x 2 x i64> @ld1h_d(<vscale x 2 x i1> %pred, ptr %a, i64 %index) {
; CHECK-LABEL: ld1h_d:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ld1h { z0.d }, p0/z, [x0, x1, lsl #1]
; CHECK-NEXT:    ret
  %base = getelementptr i16, ptr %a, i64 %index
  %load = call <vscale x 2 x i16> @llvm.aarch64.sve.ld1.nxv2i16(<vscale x 2 x i1> %pred, ptr %base)
  %res = zext <vscale x 2 x i16> %load to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %res
}

define <vscale x 2 x i64> @ld1sh_d(<vscale x 2 x i1> %pred, ptr %a, i64 %index) {
; CHECK-LABEL: ld1sh_d:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ld1sh { z0.d }, p0/z, [x0, x1, lsl #1]
; CHECK-NEXT:    ret
  %base = getelementptr i16, ptr %a, i64 %index
  %load = call <vscale x 2 x i16> @llvm.aarch64.sve.ld1.nxv2i16(<vscale x 2 x i1> %pred, ptr %base)
  %res = sext <vscale x 2 x i16> %load to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %res
}

;
; LD1W
;

define<vscale x 4 x i32> @ld1w(<vscale x 4 x i1> %pg, ptr %a, i64 %index) {
; CHECK-LABEL: ld1w
; CHECK: ld1w { z0.s }, p0/z, [x0, x1, lsl #2]
; CHECK-NEXT: ret
  %base = getelementptr i32, ptr %a, i64 %index
  %load = call <vscale x 4 x i32> @llvm.aarch64.sve.ld1.nxv4i32(<vscale x 4 x i1> %pg, ptr %base)
  ret <vscale x 4 x i32> %load
}

define<vscale x 4 x float> @ld1w_f32(<vscale x 4 x i1> %pg, ptr %a, i64 %index) {
; CHECK-LABEL: ld1w_f32
; CHECK: ld1w { z0.s }, p0/z, [x0, x1, lsl #2]
; CHECK-NEXT: ret
  %base = getelementptr float, ptr %a, i64 %index
  %load = call <vscale x 4 x float> @llvm.aarch64.sve.ld1.nxv4f32(<vscale x 4 x i1> %pg, ptr %base)
  ret <vscale x 4 x float> %load
}

define <vscale x 2 x i64> @ld1w_d(<vscale x 2 x i1> %pred, ptr %a, i64 %index) {
; CHECK-LABEL: ld1w_d:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ld1w { z0.d }, p0/z, [x0, x1, lsl #2]
; CHECK-NEXT:    ret
  %base = getelementptr i32, ptr %a, i64 %index
  %load = call <vscale x 2 x i32> @llvm.aarch64.sve.ld1.nxv2i32(<vscale x 2 x i1> %pred, ptr %base)
  %res = zext <vscale x 2 x i32> %load to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %res
}

define <vscale x 2 x i64> @ld1sw_d(<vscale x 2 x i1> %pred, ptr %a, i64 %index) {
; CHECK-LABEL: ld1sw_d:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ld1sw { z0.d }, p0/z, [x0, x1, lsl #2]
; CHECK-NEXT:    ret
  %base = getelementptr i32, ptr %a, i64 %index
  %load = call <vscale x 2 x i32> @llvm.aarch64.sve.ld1.nxv2i32(<vscale x 2 x i1> %pred, ptr %base)
  %res = sext <vscale x 2 x i32> %load to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %res
}

;
; LD1D
;

define <vscale x 2 x i64> @ld1d(<vscale x 2 x i1> %pg, ptr %a, i64 %index) {
; CHECK-LABEL: ld1d:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x0, x1, lsl #3]
; CHECK-NEXT:    ret
  %base = getelementptr i64, ptr %a, i64 %index
  %load = call <vscale x 2 x i64> @llvm.aarch64.sve.ld1.nxv2i64(<vscale x 2 x i1> %pg, ptr %base)
  ret <vscale x 2 x i64> %load
}

define <vscale x 2 x double> @ld1d_f64(<vscale x 2 x i1> %pg, ptr %a, i64 %index) {
; CHECK-LABEL: ld1d_f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x0, x1, lsl #3]
; CHECK-NEXT:    ret
  %base = getelementptr double, ptr %a, i64 %index
  %load = call <vscale x 2 x double> @llvm.aarch64.sve.ld1.nxv2f64(<vscale x 2 x i1> %pg, ptr %base)
  ret <vscale x 2 x double> %load
}

declare <vscale x 16 x i8> @llvm.aarch64.sve.ld1.nxv16i8(<vscale x 16 x i1>, ptr)

declare <vscale x 8 x i8> @llvm.aarch64.sve.ld1.nxv8i8(<vscale x 8 x i1>, ptr)
declare <vscale x 8 x i16> @llvm.aarch64.sve.ld1.nxv8i16(<vscale x 8 x i1>, ptr)
declare <vscale x 8 x half> @llvm.aarch64.sve.ld1.nxv8f16(<vscale x 8 x i1>, ptr)
declare <vscale x 8 x bfloat> @llvm.aarch64.sve.ld1.nxv8bf16(<vscale x 8 x i1>, ptr)

declare <vscale x 4 x i8> @llvm.aarch64.sve.ld1.nxv4i8(<vscale x 4 x i1>, ptr)
declare <vscale x 4 x i16> @llvm.aarch64.sve.ld1.nxv4i16(<vscale x 4 x i1>, ptr)
declare <vscale x 4 x i32> @llvm.aarch64.sve.ld1.nxv4i32(<vscale x 4 x i1>, ptr)
declare <vscale x 4 x float> @llvm.aarch64.sve.ld1.nxv4f32(<vscale x 4 x i1>, ptr)

declare <vscale x 2 x i8> @llvm.aarch64.sve.ld1.nxv2i8(<vscale x 2 x i1>, ptr)
declare <vscale x 2 x i16> @llvm.aarch64.sve.ld1.nxv2i16(<vscale x 2 x i1>, ptr)
declare <vscale x 2 x i32> @llvm.aarch64.sve.ld1.nxv2i32(<vscale x 2 x i1>, ptr)
declare <vscale x 2 x i64> @llvm.aarch64.sve.ld1.nxv2i64(<vscale x 2 x i1>, ptr)
declare <vscale x 2 x double> @llvm.aarch64.sve.ld1.nxv2f64(<vscale x 2 x i1>, ptr)

; +bf16 is required for the bfloat version.
attributes #0 = { "target-features"="+sve,+bf16" }
