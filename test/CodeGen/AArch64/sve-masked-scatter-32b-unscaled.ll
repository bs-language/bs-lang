; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sve < %s | FileCheck %s

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; unscaled unpacked 32-bit offsets
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

define void @masked_scatter_nxv2i8_sext_offsets(<vscale x 2 x i8> %data, ptr %base, <vscale x 2 x i32> %i32offsets, <vscale x 2 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv2i8_sext_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1b { z0.d }, p0, [x0, z1.d, sxtw]
; CHECK-NEXT:    ret
  %offsets = sext <vscale x 2 x i32> %i32offsets to <vscale x 2 x i64>
  %byte_ptrs = getelementptr i8, ptr %base, <vscale x 2 x i64> %offsets
  %ptrs = bitcast <vscale x 2 x ptr> %byte_ptrs to <vscale x 2 x ptr>
  call void @llvm.masked.scatter.nxv2i8(<vscale x 2 x i8> %data, <vscale x 2 x ptr> %ptrs, i32 0, <vscale x 2 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv2i16_sext_offsets(<vscale x 2 x i16> %data, ptr %base, <vscale x 2 x i32> %i32offsets, <vscale x 2 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv2i16_sext_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1h { z0.d }, p0, [x0, z1.d, sxtw]
; CHECK-NEXT:    ret
  %offsets = sext <vscale x 2 x i32> %i32offsets to <vscale x 2 x i64>
  %byte_ptrs = getelementptr i8, ptr %base, <vscale x 2 x i64> %offsets
  %ptrs = bitcast <vscale x 2 x ptr> %byte_ptrs to <vscale x 2 x ptr>
  call void @llvm.masked.scatter.nxv2i16(<vscale x 2 x i16> %data, <vscale x 2 x ptr> %ptrs, i32 0, <vscale x 2 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv2i32_sext_offsets(<vscale x 2 x i32> %data, ptr %base, <vscale x 2 x i32> %i32offsets, <vscale x 2 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv2i32_sext_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1w { z0.d }, p0, [x0, z1.d, sxtw]
; CHECK-NEXT:    ret
  %offsets = sext <vscale x 2 x i32> %i32offsets to <vscale x 2 x i64>
  %byte_ptrs = getelementptr i8, ptr %base, <vscale x 2 x i64> %offsets
  %ptrs = bitcast <vscale x 2 x ptr> %byte_ptrs to <vscale x 2 x ptr>
  call void @llvm.masked.scatter.nxv2i32(<vscale x 2 x i32> %data, <vscale x 2 x ptr> %ptrs, i32 0, <vscale x 2 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv2i64_sext_offsets(<vscale x 2 x i64> %data, ptr %base, <vscale x 2 x i32> %i32offsets, <vscale x 2 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv2i64_sext_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1d { z0.d }, p0, [x0, z1.d, sxtw]
; CHECK-NEXT:    ret
  %offsets = sext <vscale x 2 x i32> %i32offsets to <vscale x 2 x i64>
  %byte_ptrs = getelementptr i8, ptr %base, <vscale x 2 x i64> %offsets
  %ptrs = bitcast <vscale x 2 x ptr> %byte_ptrs to <vscale x 2 x ptr>
  call void @llvm.masked.scatter.nxv2i64(<vscale x 2 x i64> %data, <vscale x 2 x ptr> %ptrs, i32 0, <vscale x 2 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv2f16_sext_offsets(<vscale x 2 x half> %data, ptr %base, <vscale x 2 x i32> %i32offsets, <vscale x 2 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv2f16_sext_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1h { z0.d }, p0, [x0, z1.d, sxtw]
; CHECK-NEXT:    ret
  %offsets = sext <vscale x 2 x i32> %i32offsets to <vscale x 2 x i64>
  %byte_ptrs = getelementptr i8, ptr %base, <vscale x 2 x i64> %offsets
  %ptrs = bitcast <vscale x 2 x ptr> %byte_ptrs to <vscale x 2 x ptr>
  call void @llvm.masked.scatter.nxv2f16(<vscale x 2 x half> %data, <vscale x 2 x ptr> %ptrs, i32 0, <vscale x 2 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv2bf16_sext_offsets(<vscale x 2 x bfloat> %data, ptr %base, <vscale x 2 x i32> %i32offsets, <vscale x 2 x i1> %masks) nounwind #0 {
; CHECK-LABEL: masked_scatter_nxv2bf16_sext_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1h { z0.d }, p0, [x0, z1.d, sxtw]
; CHECK-NEXT:    ret
  %offsets = sext <vscale x 2 x i32> %i32offsets to <vscale x 2 x i64>
  %byte_ptrs = getelementptr i8, ptr %base, <vscale x 2 x i64> %offsets
  %ptrs = bitcast <vscale x 2 x ptr> %byte_ptrs to <vscale x 2 x ptr>
  call void @llvm.masked.scatter.nxv2bf16(<vscale x 2 x bfloat> %data, <vscale x 2 x ptr> %ptrs, i32 0, <vscale x 2 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv2f32_sext_offsets(<vscale x 2 x float> %data, ptr %base, <vscale x 2 x i32> %i32offsets, <vscale x 2 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv2f32_sext_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1w { z0.d }, p0, [x0, z1.d, sxtw]
; CHECK-NEXT:    ret
  %offsets = sext <vscale x 2 x i32> %i32offsets to <vscale x 2 x i64>
  %byte_ptrs = getelementptr i8, ptr %base, <vscale x 2 x i64> %offsets
  %ptrs = bitcast <vscale x 2 x ptr> %byte_ptrs to <vscale x 2 x ptr>
  call void @llvm.masked.scatter.nxv2f32(<vscale x 2 x float> %data, <vscale x 2 x ptr> %ptrs, i32 0, <vscale x 2 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv2f64_sext_offsets(<vscale x 2 x double> %data, ptr %base, <vscale x 2 x i32> %i32offsets, <vscale x 2 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv2f64_sext_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1d { z0.d }, p0, [x0, z1.d, sxtw]
; CHECK-NEXT:    ret
  %offsets = sext <vscale x 2 x i32> %i32offsets to <vscale x 2 x i64>
  %byte_ptrs = getelementptr i8, ptr %base, <vscale x 2 x i64> %offsets
  %ptrs = bitcast <vscale x 2 x ptr> %byte_ptrs to <vscale x 2 x ptr>
  call void @llvm.masked.scatter.nxv2f64(<vscale x 2 x double> %data, <vscale x 2 x ptr> %ptrs, i32 0, <vscale x 2 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv2i8_zext_offsets(<vscale x 2 x i8> %data, ptr %base, <vscale x 2 x i32> %i32offsets, <vscale x 2 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv2i8_zext_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1b { z0.d }, p0, [x0, z1.d, uxtw]
; CHECK-NEXT:    ret
  %offsets = zext <vscale x 2 x i32> %i32offsets to <vscale x 2 x i64>
  %byte_ptrs = getelementptr i8, ptr %base, <vscale x 2 x i64> %offsets
  %ptrs = bitcast <vscale x 2 x ptr> %byte_ptrs to <vscale x 2 x ptr>
  call void @llvm.masked.scatter.nxv2i8(<vscale x 2 x i8> %data, <vscale x 2 x ptr> %ptrs, i32 0, <vscale x 2 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv2i16_zext_offsets(<vscale x 2 x i16> %data, ptr %base, <vscale x 2 x i32> %i32offsets, <vscale x 2 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv2i16_zext_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1h { z0.d }, p0, [x0, z1.d, uxtw]
; CHECK-NEXT:    ret
  %offsets = zext <vscale x 2 x i32> %i32offsets to <vscale x 2 x i64>
  %byte_ptrs = getelementptr i8, ptr %base, <vscale x 2 x i64> %offsets
  %ptrs = bitcast <vscale x 2 x ptr> %byte_ptrs to <vscale x 2 x ptr>
  call void @llvm.masked.scatter.nxv2i16(<vscale x 2 x i16> %data, <vscale x 2 x ptr> %ptrs, i32 0, <vscale x 2 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv2i32_zext_offsets(<vscale x 2 x i32> %data, ptr %base, <vscale x 2 x i32> %i32offsets, <vscale x 2 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv2i32_zext_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1w { z0.d }, p0, [x0, z1.d, uxtw]
; CHECK-NEXT:    ret
  %offsets = zext <vscale x 2 x i32> %i32offsets to <vscale x 2 x i64>
  %byte_ptrs = getelementptr i8, ptr %base, <vscale x 2 x i64> %offsets
  %ptrs = bitcast <vscale x 2 x ptr> %byte_ptrs to <vscale x 2 x ptr>
  call void @llvm.masked.scatter.nxv2i32(<vscale x 2 x i32> %data, <vscale x 2 x ptr> %ptrs, i32 0, <vscale x 2 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv2i64_zext_offsets(<vscale x 2 x i64> %data, ptr %base, <vscale x 2 x i32> %i32offsets, <vscale x 2 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv2i64_zext_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1d { z0.d }, p0, [x0, z1.d, uxtw]
; CHECK-NEXT:    ret
  %offsets = zext <vscale x 2 x i32> %i32offsets to <vscale x 2 x i64>
  %byte_ptrs = getelementptr i8, ptr %base, <vscale x 2 x i64> %offsets
  %ptrs = bitcast <vscale x 2 x ptr> %byte_ptrs to <vscale x 2 x ptr>
  call void @llvm.masked.scatter.nxv2i64(<vscale x 2 x i64> %data, <vscale x 2 x ptr> %ptrs, i32 0, <vscale x 2 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv2f16_zext_offsets(<vscale x 2 x half> %data, ptr %base, <vscale x 2 x i32> %i32offsets, <vscale x 2 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv2f16_zext_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1h { z0.d }, p0, [x0, z1.d, uxtw]
; CHECK-NEXT:    ret
  %offsets = zext <vscale x 2 x i32> %i32offsets to <vscale x 2 x i64>
  %byte_ptrs = getelementptr i8, ptr %base, <vscale x 2 x i64> %offsets
  %ptrs = bitcast <vscale x 2 x ptr> %byte_ptrs to <vscale x 2 x ptr>
  call void @llvm.masked.scatter.nxv2f16(<vscale x 2 x half> %data, <vscale x 2 x ptr> %ptrs, i32 0, <vscale x 2 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv2bf16_zext_offsets(<vscale x 2 x bfloat> %data, ptr %base, <vscale x 2 x i32> %i32offsets, <vscale x 2 x i1> %masks) nounwind #0 {
; CHECK-LABEL: masked_scatter_nxv2bf16_zext_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1h { z0.d }, p0, [x0, z1.d, uxtw]
; CHECK-NEXT:    ret
  %offsets = zext <vscale x 2 x i32> %i32offsets to <vscale x 2 x i64>
  %byte_ptrs = getelementptr i8, ptr %base, <vscale x 2 x i64> %offsets
  %ptrs = bitcast <vscale x 2 x ptr> %byte_ptrs to <vscale x 2 x ptr>
  call void @llvm.masked.scatter.nxv2bf16(<vscale x 2 x bfloat> %data, <vscale x 2 x ptr> %ptrs, i32 0, <vscale x 2 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv2f32_zext_offsets(<vscale x 2 x float> %data, ptr %base, <vscale x 2 x i32> %i32offsets, <vscale x 2 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv2f32_zext_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1w { z0.d }, p0, [x0, z1.d, uxtw]
; CHECK-NEXT:    ret
  %offsets = zext <vscale x 2 x i32> %i32offsets to <vscale x 2 x i64>
  %byte_ptrs = getelementptr i8, ptr %base, <vscale x 2 x i64> %offsets
  %ptrs = bitcast <vscale x 2 x ptr> %byte_ptrs to <vscale x 2 x ptr>
  call void @llvm.masked.scatter.nxv2f32(<vscale x 2 x float> %data, <vscale x 2 x ptr> %ptrs, i32 0, <vscale x 2 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv2f64_zext_offsets(<vscale x 2 x double> %data, ptr %base, <vscale x 2 x i32> %i32offsets, <vscale x 2 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv2f64_zext_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1d { z0.d }, p0, [x0, z1.d, uxtw]
; CHECK-NEXT:    ret
  %offsets = zext <vscale x 2 x i32> %i32offsets to <vscale x 2 x i64>
  %byte_ptrs = getelementptr i8, ptr %base, <vscale x 2 x i64> %offsets
  %ptrs = bitcast <vscale x 2 x ptr> %byte_ptrs to <vscale x 2 x ptr>
  call void @llvm.masked.scatter.nxv2f64(<vscale x 2 x double> %data, <vscale x 2 x ptr> %ptrs, i32 0, <vscale x 2 x i1> %masks)
  ret void
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; unscaled packed 32-bit offsets
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
define void @masked_scatter_nxv4i8_sext_offsets(<vscale x 4 x i8> %data, ptr %base, <vscale x 4 x i32> %i32offsets, <vscale x 4 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv4i8_sext_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1b { z0.s }, p0, [x0, z1.s, sxtw]
; CHECK-NEXT:    ret
  %offsets = sext <vscale x 4 x i32> %i32offsets to <vscale x 4 x i64>
  %byte_ptrs = getelementptr i8, ptr %base, <vscale x 4 x i64> %offsets
  %ptrs = bitcast <vscale x 4 x ptr> %byte_ptrs to <vscale x 4 x ptr>
  call void @llvm.masked.scatter.nxv4i8(<vscale x 4 x i8> %data, <vscale x 4 x ptr> %ptrs, i32 0, <vscale x 4 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv4i16_sext_offsets(<vscale x 4 x i16> %data, ptr %base, <vscale x 4 x i32> %i32offsets, <vscale x 4 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv4i16_sext_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1h { z0.s }, p0, [x0, z1.s, sxtw]
; CHECK-NEXT:    ret
  %offsets = sext <vscale x 4 x i32> %i32offsets to <vscale x 4 x i64>
  %byte_ptrs = getelementptr i8, ptr %base, <vscale x 4 x i64> %offsets
  %ptrs = bitcast <vscale x 4 x ptr> %byte_ptrs to <vscale x 4 x ptr>
  call void @llvm.masked.scatter.nxv4i16(<vscale x 4 x i16> %data, <vscale x 4 x ptr> %ptrs, i32 0, <vscale x 4 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv4i32_sext_offsets(<vscale x 4 x i32> %data, ptr %base, <vscale x 4 x i32> %i32offsets, <vscale x 4 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv4i32_sext_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1w { z0.s }, p0, [x0, z1.s, sxtw]
; CHECK-NEXT:    ret
  %offsets = sext <vscale x 4 x i32> %i32offsets to <vscale x 4 x i64>
  %byte_ptrs = getelementptr i8, ptr %base, <vscale x 4 x i64> %offsets
  %ptrs = bitcast <vscale x 4 x ptr> %byte_ptrs to <vscale x 4 x ptr>
  call void @llvm.masked.scatter.nxv4i32(<vscale x 4 x i32> %data, <vscale x 4 x ptr> %ptrs, i32 0, <vscale x 4 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv4f16_sext_offsets(<vscale x 4 x half> %data, ptr %base, <vscale x 4 x i32> %i32offsets, <vscale x 4 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv4f16_sext_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1h { z0.s }, p0, [x0, z1.s, sxtw]
; CHECK-NEXT:    ret
  %offsets = sext <vscale x 4 x i32> %i32offsets to <vscale x 4 x i64>
  %byte_ptrs = getelementptr i8, ptr %base, <vscale x 4 x i64> %offsets
  %ptrs = bitcast <vscale x 4 x ptr> %byte_ptrs to <vscale x 4 x ptr>
  call void @llvm.masked.scatter.nxv4f16(<vscale x 4 x half> %data, <vscale x 4 x ptr> %ptrs, i32 0, <vscale x 4 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv4bf16_sext_offsets(<vscale x 4 x bfloat> %data, ptr %base, <vscale x 4 x i32> %i32offsets, <vscale x 4 x i1> %masks) nounwind #0 {
; CHECK-LABEL: masked_scatter_nxv4bf16_sext_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1h { z0.s }, p0, [x0, z1.s, sxtw]
; CHECK-NEXT:    ret
  %offsets = sext <vscale x 4 x i32> %i32offsets to <vscale x 4 x i64>
  %byte_ptrs = getelementptr i8, ptr %base, <vscale x 4 x i64> %offsets
  %ptrs = bitcast <vscale x 4 x ptr> %byte_ptrs to <vscale x 4 x ptr>
  call void @llvm.masked.scatter.nxv4bf16(<vscale x 4 x bfloat> %data, <vscale x 4 x ptr> %ptrs, i32 0, <vscale x 4 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv4f32_sext_offsets(<vscale x 4 x float> %data, ptr %base, <vscale x 4 x i32> %i32offsets, <vscale x 4 x i1> %masks) nounwind #0 {
; CHECK-LABEL: masked_scatter_nxv4f32_sext_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1w { z0.s }, p0, [x0, z1.s, sxtw]
; CHECK-NEXT:    ret
  %offsets = sext <vscale x 4 x i32> %i32offsets to <vscale x 4 x i64>
  %byte_ptrs = getelementptr i8, ptr %base, <vscale x 4 x i64> %offsets
  %ptrs = bitcast <vscale x 4 x ptr> %byte_ptrs to <vscale x 4 x ptr>
  call void @llvm.masked.scatter.nxv4f32(<vscale x 4 x float> %data, <vscale x 4 x ptr> %ptrs, i32 0, <vscale x 4 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv4i8_zext_offsets(<vscale x 4 x i8> %data, ptr %base, <vscale x 4 x i32> %i32offsets, <vscale x 4 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv4i8_zext_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1b { z0.s }, p0, [x0, z1.s, uxtw]
; CHECK-NEXT:    ret
  %offsets = zext <vscale x 4 x i32> %i32offsets to <vscale x 4 x i64>
  %byte_ptrs = getelementptr i8, ptr %base, <vscale x 4 x i64> %offsets
  %ptrs = bitcast <vscale x 4 x ptr> %byte_ptrs to <vscale x 4 x ptr>
  call void @llvm.masked.scatter.nxv4i8(<vscale x 4 x i8> %data, <vscale x 4 x ptr> %ptrs, i32 0, <vscale x 4 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv4i16_zext_offsets(<vscale x 4 x i16> %data, ptr %base, <vscale x 4 x i32> %i32offsets, <vscale x 4 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv4i16_zext_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1h { z0.s }, p0, [x0, z1.s, uxtw]
; CHECK-NEXT:    ret
  %offsets = zext <vscale x 4 x i32> %i32offsets to <vscale x 4 x i64>
  %byte_ptrs = getelementptr i8, ptr %base, <vscale x 4 x i64> %offsets
  %ptrs = bitcast <vscale x 4 x ptr> %byte_ptrs to <vscale x 4 x ptr>
  call void @llvm.masked.scatter.nxv4i16(<vscale x 4 x i16> %data, <vscale x 4 x ptr> %ptrs, i32 0, <vscale x 4 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv4i32_zext_offsets(<vscale x 4 x i32> %data, ptr %base, <vscale x 4 x i32> %i32offsets, <vscale x 4 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv4i32_zext_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1w { z0.s }, p0, [x0, z1.s, uxtw]
; CHECK-NEXT:    ret
  %offsets = zext <vscale x 4 x i32> %i32offsets to <vscale x 4 x i64>
  %byte_ptrs = getelementptr i8, ptr %base, <vscale x 4 x i64> %offsets
  %ptrs = bitcast <vscale x 4 x ptr> %byte_ptrs to <vscale x 4 x ptr>
  call void @llvm.masked.scatter.nxv4i32(<vscale x 4 x i32> %data, <vscale x 4 x ptr> %ptrs, i32 0, <vscale x 4 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv4f16_zext_offsets(<vscale x 4 x half> %data, ptr %base, <vscale x 4 x i32> %i32offsets, <vscale x 4 x i1> %masks) nounwind {
; CHECK-LABEL: masked_scatter_nxv4f16_zext_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1h { z0.s }, p0, [x0, z1.s, uxtw]
; CHECK-NEXT:    ret
  %offsets = zext <vscale x 4 x i32> %i32offsets to <vscale x 4 x i64>
  %byte_ptrs = getelementptr i8, ptr %base, <vscale x 4 x i64> %offsets
  %ptrs = bitcast <vscale x 4 x ptr> %byte_ptrs to <vscale x 4 x ptr>
  call void @llvm.masked.scatter.nxv4f16(<vscale x 4 x half> %data, <vscale x 4 x ptr> %ptrs, i32 0, <vscale x 4 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv4bf16_zext_offsets(<vscale x 4 x bfloat> %data, ptr %base, <vscale x 4 x i32> %i32offsets, <vscale x 4 x i1> %masks) nounwind #0 {
; CHECK-LABEL: masked_scatter_nxv4bf16_zext_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1h { z0.s }, p0, [x0, z1.s, uxtw]
; CHECK-NEXT:    ret
  %offsets = zext <vscale x 4 x i32> %i32offsets to <vscale x 4 x i64>
  %byte_ptrs = getelementptr i8, ptr %base, <vscale x 4 x i64> %offsets
  %ptrs = bitcast <vscale x 4 x ptr> %byte_ptrs to <vscale x 4 x ptr>
  call void @llvm.masked.scatter.nxv4bf16(<vscale x 4 x bfloat> %data, <vscale x 4 x ptr> %ptrs, i32 0, <vscale x 4 x i1> %masks)
  ret void
}

define void @masked_scatter_nxv4f32_zext_offsets(<vscale x 4 x float> %data, ptr %base, <vscale x 4 x i32> %i32offsets, <vscale x 4 x i1> %masks) nounwind #0 {
; CHECK-LABEL: masked_scatter_nxv4f32_zext_offsets:
; CHECK:       // %bb.0:
; CHECK-NEXT:    st1w { z0.s }, p0, [x0, z1.s, uxtw]
; CHECK-NEXT:    ret
  %offsets = zext <vscale x 4 x i32> %i32offsets to <vscale x 4 x i64>
  %byte_ptrs = getelementptr i8, ptr %base, <vscale x 4 x i64> %offsets
  %ptrs = bitcast <vscale x 4 x ptr> %byte_ptrs to <vscale x 4 x ptr>
  call void @llvm.masked.scatter.nxv4f32(<vscale x 4 x float> %data, <vscale x 4 x ptr> %ptrs, i32 0, <vscale x 4 x i1> %masks)
  ret void
}

declare void @llvm.masked.scatter.nxv2f16(<vscale x 2 x half>, <vscale x 2 x ptr>, i32, <vscale x 2 x i1>)
declare void @llvm.masked.scatter.nxv4f16(<vscale x 4 x half>, <vscale x 4 x ptr>, i32, <vscale x 4 x i1>)
declare void @llvm.masked.scatter.nxv4bf16(<vscale x 4 x bfloat>, <vscale x 4 x ptr>, i32, <vscale x 4 x i1>)
declare void @llvm.masked.scatter.nxv4f32(<vscale x 4 x float>, <vscale x 4 x ptr>, i32, <vscale x 4 x i1>)
declare void @llvm.masked.scatter.nxv2bf16(<vscale x 2 x bfloat>, <vscale x 2 x ptr>, i32, <vscale x 2 x i1>)
declare void @llvm.masked.scatter.nxv2f32(<vscale x 2 x float>, <vscale x 2 x ptr>, i32, <vscale x 2 x i1>)
declare void @llvm.masked.scatter.nxv2f64(<vscale x 2 x double>, <vscale x 2 x ptr>, i32, <vscale x 2 x i1>)
declare void @llvm.masked.scatter.nxv2i16(<vscale x 2 x i16>, <vscale x 2 x ptr>, i32, <vscale x 2 x i1>)
declare void @llvm.masked.scatter.nxv2i32(<vscale x 2 x i32>, <vscale x 2 x ptr>, i32, <vscale x 2 x i1>)
declare void @llvm.masked.scatter.nxv2i64(<vscale x 2 x i64>, <vscale x 2 x ptr>, i32, <vscale x 2 x i1>)
declare void @llvm.masked.scatter.nxv2i8(<vscale x 2 x i8>, <vscale x 2 x ptr>, i32, <vscale x 2 x i1>)
declare void @llvm.masked.scatter.nxv4i16(<vscale x 4 x i16>, <vscale x 4 x ptr>, i32, <vscale x 4 x i1>)
declare void @llvm.masked.scatter.nxv4i32(<vscale x 4 x i32>, <vscale x 4 x ptr>, i32, <vscale x 4 x i1>)
declare void @llvm.masked.scatter.nxv4i8(<vscale x 4 x i8>, <vscale x 4 x ptr>, i32, <vscale x 4 x i1>)
attributes #0 = { "target-features"="+sve,+bf16" }
