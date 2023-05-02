; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=riscv32 -mattr=+v,+zfh,+experimental-zvfh | FileCheck -check-prefixes=CHECK,RV32 %s
; RUN: llc < %s -mtriple=riscv64 -mattr=+v,+zfh,+experimental-zvfh | FileCheck -check-prefixes=CHECK,RV64 %s

; Integers

define <32 x i1> @vector_interleave_v32i1_v16i1(<16 x i1> %a, <16 x i1> %b) {
; RV32-LABEL: vector_interleave_v32i1_v16i1:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -64
; RV32-NEXT:    .cfi_def_cfa_offset 64
; RV32-NEXT:    sw ra, 60(sp) # 4-byte Folded Spill
; RV32-NEXT:    sw s0, 56(sp) # 4-byte Folded Spill
; RV32-NEXT:    .cfi_offset ra, -4
; RV32-NEXT:    .cfi_offset s0, -8
; RV32-NEXT:    addi s0, sp, 64
; RV32-NEXT:    .cfi_def_cfa s0, 0
; RV32-NEXT:    andi sp, sp, -32
; RV32-NEXT:    vsetivli zero, 16, e8, m1, ta, ma
; RV32-NEXT:    vfirst.m a0, v8
; RV32-NEXT:    seqz a0, a0
; RV32-NEXT:    sb a0, 1(sp)
; RV32-NEXT:    vfirst.m a0, v0
; RV32-NEXT:    seqz a0, a0
; RV32-NEXT:    sb a0, 0(sp)
; RV32-NEXT:    vsetivli zero, 0, e16, mf4, ta, ma
; RV32-NEXT:    vmv.x.s a0, v8
; RV32-NEXT:    slli a1, a0, 16
; RV32-NEXT:    srli a1, a1, 31
; RV32-NEXT:    sb a1, 31(sp)
; RV32-NEXT:    vmv.x.s a1, v0
; RV32-NEXT:    slli a2, a1, 16
; RV32-NEXT:    srli a2, a2, 31
; RV32-NEXT:    sb a2, 30(sp)
; RV32-NEXT:    slli a2, a0, 17
; RV32-NEXT:    srli a2, a2, 31
; RV32-NEXT:    sb a2, 29(sp)
; RV32-NEXT:    slli a2, a1, 17
; RV32-NEXT:    srli a2, a2, 31
; RV32-NEXT:    sb a2, 28(sp)
; RV32-NEXT:    slli a2, a0, 18
; RV32-NEXT:    srli a2, a2, 31
; RV32-NEXT:    sb a2, 27(sp)
; RV32-NEXT:    slli a2, a1, 18
; RV32-NEXT:    srli a2, a2, 31
; RV32-NEXT:    sb a2, 26(sp)
; RV32-NEXT:    slli a2, a0, 19
; RV32-NEXT:    srli a2, a2, 31
; RV32-NEXT:    sb a2, 25(sp)
; RV32-NEXT:    slli a2, a1, 19
; RV32-NEXT:    srli a2, a2, 31
; RV32-NEXT:    sb a2, 24(sp)
; RV32-NEXT:    slli a2, a0, 20
; RV32-NEXT:    srli a2, a2, 31
; RV32-NEXT:    sb a2, 23(sp)
; RV32-NEXT:    slli a2, a1, 20
; RV32-NEXT:    srli a2, a2, 31
; RV32-NEXT:    sb a2, 22(sp)
; RV32-NEXT:    slli a2, a0, 21
; RV32-NEXT:    srli a2, a2, 31
; RV32-NEXT:    sb a2, 21(sp)
; RV32-NEXT:    slli a2, a1, 21
; RV32-NEXT:    srli a2, a2, 31
; RV32-NEXT:    sb a2, 20(sp)
; RV32-NEXT:    slli a2, a0, 22
; RV32-NEXT:    srli a2, a2, 31
; RV32-NEXT:    sb a2, 19(sp)
; RV32-NEXT:    slli a2, a1, 22
; RV32-NEXT:    srli a2, a2, 31
; RV32-NEXT:    sb a2, 18(sp)
; RV32-NEXT:    slli a2, a0, 23
; RV32-NEXT:    srli a2, a2, 31
; RV32-NEXT:    sb a2, 17(sp)
; RV32-NEXT:    slli a2, a1, 23
; RV32-NEXT:    srli a2, a2, 31
; RV32-NEXT:    sb a2, 16(sp)
; RV32-NEXT:    slli a2, a0, 24
; RV32-NEXT:    srli a2, a2, 31
; RV32-NEXT:    sb a2, 15(sp)
; RV32-NEXT:    slli a2, a1, 24
; RV32-NEXT:    srli a2, a2, 31
; RV32-NEXT:    sb a2, 14(sp)
; RV32-NEXT:    slli a2, a0, 25
; RV32-NEXT:    srli a2, a2, 31
; RV32-NEXT:    sb a2, 13(sp)
; RV32-NEXT:    slli a2, a1, 25
; RV32-NEXT:    srli a2, a2, 31
; RV32-NEXT:    sb a2, 12(sp)
; RV32-NEXT:    slli a2, a0, 26
; RV32-NEXT:    srli a2, a2, 31
; RV32-NEXT:    sb a2, 11(sp)
; RV32-NEXT:    slli a2, a1, 26
; RV32-NEXT:    srli a2, a2, 31
; RV32-NEXT:    sb a2, 10(sp)
; RV32-NEXT:    slli a2, a0, 27
; RV32-NEXT:    srli a2, a2, 31
; RV32-NEXT:    sb a2, 9(sp)
; RV32-NEXT:    slli a2, a1, 27
; RV32-NEXT:    srli a2, a2, 31
; RV32-NEXT:    sb a2, 8(sp)
; RV32-NEXT:    slli a2, a0, 28
; RV32-NEXT:    srli a2, a2, 31
; RV32-NEXT:    sb a2, 7(sp)
; RV32-NEXT:    slli a2, a1, 28
; RV32-NEXT:    srli a2, a2, 31
; RV32-NEXT:    sb a2, 6(sp)
; RV32-NEXT:    slli a2, a0, 29
; RV32-NEXT:    srli a2, a2, 31
; RV32-NEXT:    sb a2, 5(sp)
; RV32-NEXT:    slli a2, a1, 29
; RV32-NEXT:    srli a2, a2, 31
; RV32-NEXT:    sb a2, 4(sp)
; RV32-NEXT:    slli a0, a0, 30
; RV32-NEXT:    srli a0, a0, 31
; RV32-NEXT:    sb a0, 3(sp)
; RV32-NEXT:    slli a1, a1, 30
; RV32-NEXT:    srli a1, a1, 31
; RV32-NEXT:    sb a1, 2(sp)
; RV32-NEXT:    li a0, 32
; RV32-NEXT:    mv a1, sp
; RV32-NEXT:    vsetvli zero, a0, e8, m2, ta, ma
; RV32-NEXT:    vle8.v v8, (a1)
; RV32-NEXT:    vand.vi v8, v8, 1
; RV32-NEXT:    vmsne.vi v0, v8, 0
; RV32-NEXT:    addi sp, s0, -64
; RV32-NEXT:    lw ra, 60(sp) # 4-byte Folded Reload
; RV32-NEXT:    lw s0, 56(sp) # 4-byte Folded Reload
; RV32-NEXT:    addi sp, sp, 64
; RV32-NEXT:    ret
;
; RV64-LABEL: vector_interleave_v32i1_v16i1:
; RV64:       # %bb.0:
; RV64-NEXT:    addi sp, sp, -64
; RV64-NEXT:    .cfi_def_cfa_offset 64
; RV64-NEXT:    sd ra, 56(sp) # 8-byte Folded Spill
; RV64-NEXT:    sd s0, 48(sp) # 8-byte Folded Spill
; RV64-NEXT:    .cfi_offset ra, -8
; RV64-NEXT:    .cfi_offset s0, -16
; RV64-NEXT:    addi s0, sp, 64
; RV64-NEXT:    .cfi_def_cfa s0, 0
; RV64-NEXT:    andi sp, sp, -32
; RV64-NEXT:    vsetivli zero, 16, e8, m1, ta, ma
; RV64-NEXT:    vfirst.m a0, v8
; RV64-NEXT:    seqz a0, a0
; RV64-NEXT:    sb a0, 1(sp)
; RV64-NEXT:    vfirst.m a0, v0
; RV64-NEXT:    seqz a0, a0
; RV64-NEXT:    sb a0, 0(sp)
; RV64-NEXT:    vsetivli zero, 0, e16, mf4, ta, ma
; RV64-NEXT:    vmv.x.s a0, v8
; RV64-NEXT:    slli a1, a0, 48
; RV64-NEXT:    srli a1, a1, 63
; RV64-NEXT:    sb a1, 31(sp)
; RV64-NEXT:    vmv.x.s a1, v0
; RV64-NEXT:    slli a2, a1, 48
; RV64-NEXT:    srli a2, a2, 63
; RV64-NEXT:    sb a2, 30(sp)
; RV64-NEXT:    slli a2, a0, 49
; RV64-NEXT:    srli a2, a2, 63
; RV64-NEXT:    sb a2, 29(sp)
; RV64-NEXT:    slli a2, a1, 49
; RV64-NEXT:    srli a2, a2, 63
; RV64-NEXT:    sb a2, 28(sp)
; RV64-NEXT:    slli a2, a0, 50
; RV64-NEXT:    srli a2, a2, 63
; RV64-NEXT:    sb a2, 27(sp)
; RV64-NEXT:    slli a2, a1, 50
; RV64-NEXT:    srli a2, a2, 63
; RV64-NEXT:    sb a2, 26(sp)
; RV64-NEXT:    slli a2, a0, 51
; RV64-NEXT:    srli a2, a2, 63
; RV64-NEXT:    sb a2, 25(sp)
; RV64-NEXT:    slli a2, a1, 51
; RV64-NEXT:    srli a2, a2, 63
; RV64-NEXT:    sb a2, 24(sp)
; RV64-NEXT:    slli a2, a0, 52
; RV64-NEXT:    srli a2, a2, 63
; RV64-NEXT:    sb a2, 23(sp)
; RV64-NEXT:    slli a2, a1, 52
; RV64-NEXT:    srli a2, a2, 63
; RV64-NEXT:    sb a2, 22(sp)
; RV64-NEXT:    slli a2, a0, 53
; RV64-NEXT:    srli a2, a2, 63
; RV64-NEXT:    sb a2, 21(sp)
; RV64-NEXT:    slli a2, a1, 53
; RV64-NEXT:    srli a2, a2, 63
; RV64-NEXT:    sb a2, 20(sp)
; RV64-NEXT:    slli a2, a0, 54
; RV64-NEXT:    srli a2, a2, 63
; RV64-NEXT:    sb a2, 19(sp)
; RV64-NEXT:    slli a2, a1, 54
; RV64-NEXT:    srli a2, a2, 63
; RV64-NEXT:    sb a2, 18(sp)
; RV64-NEXT:    slli a2, a0, 55
; RV64-NEXT:    srli a2, a2, 63
; RV64-NEXT:    sb a2, 17(sp)
; RV64-NEXT:    slli a2, a1, 55
; RV64-NEXT:    srli a2, a2, 63
; RV64-NEXT:    sb a2, 16(sp)
; RV64-NEXT:    slli a2, a0, 56
; RV64-NEXT:    srli a2, a2, 63
; RV64-NEXT:    sb a2, 15(sp)
; RV64-NEXT:    slli a2, a1, 56
; RV64-NEXT:    srli a2, a2, 63
; RV64-NEXT:    sb a2, 14(sp)
; RV64-NEXT:    slli a2, a0, 57
; RV64-NEXT:    srli a2, a2, 63
; RV64-NEXT:    sb a2, 13(sp)
; RV64-NEXT:    slli a2, a1, 57
; RV64-NEXT:    srli a2, a2, 63
; RV64-NEXT:    sb a2, 12(sp)
; RV64-NEXT:    slli a2, a0, 58
; RV64-NEXT:    srli a2, a2, 63
; RV64-NEXT:    sb a2, 11(sp)
; RV64-NEXT:    slli a2, a1, 58
; RV64-NEXT:    srli a2, a2, 63
; RV64-NEXT:    sb a2, 10(sp)
; RV64-NEXT:    slli a2, a0, 59
; RV64-NEXT:    srli a2, a2, 63
; RV64-NEXT:    sb a2, 9(sp)
; RV64-NEXT:    slli a2, a1, 59
; RV64-NEXT:    srli a2, a2, 63
; RV64-NEXT:    sb a2, 8(sp)
; RV64-NEXT:    slli a2, a0, 60
; RV64-NEXT:    srli a2, a2, 63
; RV64-NEXT:    sb a2, 7(sp)
; RV64-NEXT:    slli a2, a1, 60
; RV64-NEXT:    srli a2, a2, 63
; RV64-NEXT:    sb a2, 6(sp)
; RV64-NEXT:    slli a2, a0, 61
; RV64-NEXT:    srli a2, a2, 63
; RV64-NEXT:    sb a2, 5(sp)
; RV64-NEXT:    slli a2, a1, 61
; RV64-NEXT:    srli a2, a2, 63
; RV64-NEXT:    sb a2, 4(sp)
; RV64-NEXT:    slli a0, a0, 62
; RV64-NEXT:    srli a0, a0, 63
; RV64-NEXT:    sb a0, 3(sp)
; RV64-NEXT:    slli a1, a1, 62
; RV64-NEXT:    srli a1, a1, 63
; RV64-NEXT:    sb a1, 2(sp)
; RV64-NEXT:    li a0, 32
; RV64-NEXT:    mv a1, sp
; RV64-NEXT:    vsetvli zero, a0, e8, m2, ta, ma
; RV64-NEXT:    vle8.v v8, (a1)
; RV64-NEXT:    vand.vi v8, v8, 1
; RV64-NEXT:    vmsne.vi v0, v8, 0
; RV64-NEXT:    addi sp, s0, -64
; RV64-NEXT:    ld ra, 56(sp) # 8-byte Folded Reload
; RV64-NEXT:    ld s0, 48(sp) # 8-byte Folded Reload
; RV64-NEXT:    addi sp, sp, 64
; RV64-NEXT:    ret
	   %res = call <32 x i1> @llvm.experimental.vector.interleave2.v32i1(<16 x i1> %a, <16 x i1> %b)
	   ret <32 x i1> %res
}

define <16 x i16> @vector_interleave_v16i16_v8i16(<8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: vector_interleave_v16i16_v8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e16, m1, ta, ma
; CHECK-NEXT:    vwaddu.vv v10, v8, v9
; CHECK-NEXT:    li a0, -1
; CHECK-NEXT:    vwmaccu.vx v10, a0, v9
; CHECK-NEXT:    vmv2r.v v8, v10
; CHECK-NEXT:    ret
	   %res = call <16 x i16> @llvm.experimental.vector.interleave2.v16i16(<8 x i16> %a, <8 x i16> %b)
	   ret <16 x i16> %res
}

define <8 x i32> @vector_interleave_v8i32_v4i32(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: vector_interleave_v8i32_v4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; CHECK-NEXT:    vwaddu.vv v10, v8, v9
; CHECK-NEXT:    li a0, -1
; CHECK-NEXT:    vwmaccu.vx v10, a0, v9
; CHECK-NEXT:    vmv2r.v v8, v10
; CHECK-NEXT:    ret
	   %res = call <8 x i32> @llvm.experimental.vector.interleave2.v8i32(<4 x i32> %a, <4 x i32> %b)
	   ret <8 x i32> %res
}

define <4 x i64> @vector_interleave_v4i64_v2i64(<2 x i64> %a, <2 x i64> %b) {
; RV32-LABEL: vector_interleave_v4i64_v2i64:
; RV32:       # %bb.0:
; RV32-NEXT:    vmv1r.v v10, v9
; RV32-NEXT:    vsetivli zero, 8, e32, m2, ta, ma
; RV32-NEXT:    vmv.v.i v12, 0
; RV32-NEXT:    vsetivli zero, 2, e64, m2, tu, ma
; RV32-NEXT:    vslideup.vi v12, v8, 0
; RV32-NEXT:    vsetivli zero, 4, e64, m2, tu, ma
; RV32-NEXT:    vslideup.vi v12, v10, 2
; RV32-NEXT:    lui a0, %hi(.LCPI3_0)
; RV32-NEXT:    addi a0, a0, %lo(.LCPI3_0)
; RV32-NEXT:    vsetvli zero, zero, e64, m2, ta, ma
; RV32-NEXT:    vle16.v v10, (a0)
; RV32-NEXT:    vrgatherei16.vv v8, v12, v10
; RV32-NEXT:    ret
;
; RV64-LABEL: vector_interleave_v4i64_v2i64:
; RV64:       # %bb.0:
; RV64-NEXT:    vmv1r.v v10, v9
; RV64-NEXT:    vsetivli zero, 4, e64, m2, ta, ma
; RV64-NEXT:    vmv.v.i v12, 0
; RV64-NEXT:    vsetivli zero, 2, e64, m2, tu, ma
; RV64-NEXT:    vslideup.vi v12, v8, 0
; RV64-NEXT:    vsetivli zero, 4, e64, m2, tu, ma
; RV64-NEXT:    vslideup.vi v12, v10, 2
; RV64-NEXT:    lui a0, %hi(.LCPI3_0)
; RV64-NEXT:    addi a0, a0, %lo(.LCPI3_0)
; RV64-NEXT:    vsetvli zero, zero, e64, m2, ta, ma
; RV64-NEXT:    vle64.v v10, (a0)
; RV64-NEXT:    vrgather.vv v8, v12, v10
; RV64-NEXT:    ret
	   %res = call <4 x i64> @llvm.experimental.vector.interleave2.v4i64(<2 x i64> %a, <2 x i64> %b)
	   ret <4 x i64> %res
}

declare <32 x i1> @llvm.experimental.vector.interleave2.v32i1(<16 x i1>, <16 x i1>)
declare <16 x i16> @llvm.experimental.vector.interleave2.v16i16(<8 x i16>, <8 x i16>)
declare <8 x i32> @llvm.experimental.vector.interleave2.v8i32(<4 x i32>, <4 x i32>)
declare <4 x i64> @llvm.experimental.vector.interleave2.v4i64(<2 x i64>, <2 x i64>)

; Floats

define <4 x half> @vector_interleave_v4f16_v2f16(<2 x half> %a, <2 x half> %b) {
; CHECK-LABEL: vector_interleave_v4f16_v2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e16, mf4, ta, ma
; CHECK-NEXT:    vwaddu.vv v10, v8, v9
; CHECK-NEXT:    li a0, -1
; CHECK-NEXT:    vwmaccu.vx v10, a0, v9
; CHECK-NEXT:    vmv1r.v v8, v10
; CHECK-NEXT:    ret
	   %res = call <4 x half> @llvm.experimental.vector.interleave2.v4f16(<2 x half> %a, <2 x half> %b)
	   ret <4 x half> %res
}

define <8 x half> @vector_interleave_v8f16_v4f16(<4 x half> %a, <4 x half> %b) {
; CHECK-LABEL: vector_interleave_v8f16_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e16, mf2, ta, ma
; CHECK-NEXT:    vwaddu.vv v10, v8, v9
; CHECK-NEXT:    li a0, -1
; CHECK-NEXT:    vwmaccu.vx v10, a0, v9
; CHECK-NEXT:    vmv1r.v v8, v10
; CHECK-NEXT:    ret
	   %res = call <8 x half> @llvm.experimental.vector.interleave2.v8f16(<4 x half> %a, <4 x half> %b)
	   ret <8 x half> %res
}

define <4 x float> @vector_interleave_v4f32_v2f32(<2 x float> %a, <2 x float> %b) {
; CHECK-LABEL: vector_interleave_v4f32_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e32, mf2, ta, ma
; CHECK-NEXT:    vwaddu.vv v10, v8, v9
; CHECK-NEXT:    li a0, -1
; CHECK-NEXT:    vwmaccu.vx v10, a0, v9
; CHECK-NEXT:    vmv1r.v v8, v10
; CHECK-NEXT:    ret
	   %res = call <4 x float> @llvm.experimental.vector.interleave2.v4f32(<2 x float> %a, <2 x float> %b)
	   ret <4 x float> %res
}

define <16 x half> @vector_interleave_v16f16_v8f16(<8 x half> %a, <8 x half> %b) {
; CHECK-LABEL: vector_interleave_v16f16_v8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e16, m1, ta, ma
; CHECK-NEXT:    vwaddu.vv v10, v8, v9
; CHECK-NEXT:    li a0, -1
; CHECK-NEXT:    vwmaccu.vx v10, a0, v9
; CHECK-NEXT:    vmv2r.v v8, v10
; CHECK-NEXT:    ret
	   %res = call <16 x half> @llvm.experimental.vector.interleave2.v16f16(<8 x half> %a, <8 x half> %b)
	   ret <16 x half> %res
}

define <8 x float> @vector_interleave_v8f32_v4f32(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: vector_interleave_v8f32_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; CHECK-NEXT:    vwaddu.vv v10, v8, v9
; CHECK-NEXT:    li a0, -1
; CHECK-NEXT:    vwmaccu.vx v10, a0, v9
; CHECK-NEXT:    vmv2r.v v8, v10
; CHECK-NEXT:    ret
	   %res = call <8 x float> @llvm.experimental.vector.interleave2.v8f32(<4 x float> %a, <4 x float> %b)
	   ret <8 x float> %res
}

define <4 x double> @vector_interleave_v4f64_v2f64(<2 x double> %a, <2 x double> %b) {
; RV32-LABEL: vector_interleave_v4f64_v2f64:
; RV32:       # %bb.0:
; RV32-NEXT:    vmv1r.v v10, v9
; RV32-NEXT:    vsetivli zero, 4, e64, m2, ta, ma
; RV32-NEXT:    vmv.v.i v12, 0
; RV32-NEXT:    vsetivli zero, 2, e64, m2, tu, ma
; RV32-NEXT:    vslideup.vi v12, v8, 0
; RV32-NEXT:    vsetivli zero, 4, e64, m2, tu, ma
; RV32-NEXT:    vslideup.vi v12, v10, 2
; RV32-NEXT:    lui a0, %hi(.LCPI9_0)
; RV32-NEXT:    addi a0, a0, %lo(.LCPI9_0)
; RV32-NEXT:    vsetvli zero, zero, e64, m2, ta, ma
; RV32-NEXT:    vle16.v v10, (a0)
; RV32-NEXT:    vrgatherei16.vv v8, v12, v10
; RV32-NEXT:    ret
;
; RV64-LABEL: vector_interleave_v4f64_v2f64:
; RV64:       # %bb.0:
; RV64-NEXT:    vmv1r.v v10, v9
; RV64-NEXT:    vsetivli zero, 4, e64, m2, ta, ma
; RV64-NEXT:    vmv.v.i v12, 0
; RV64-NEXT:    vsetivli zero, 2, e64, m2, tu, ma
; RV64-NEXT:    vslideup.vi v12, v8, 0
; RV64-NEXT:    vsetivli zero, 4, e64, m2, tu, ma
; RV64-NEXT:    vslideup.vi v12, v10, 2
; RV64-NEXT:    lui a0, %hi(.LCPI9_0)
; RV64-NEXT:    addi a0, a0, %lo(.LCPI9_0)
; RV64-NEXT:    vsetvli zero, zero, e64, m2, ta, ma
; RV64-NEXT:    vle64.v v10, (a0)
; RV64-NEXT:    vrgather.vv v8, v12, v10
; RV64-NEXT:    ret
	   %res = call <4 x double> @llvm.experimental.vector.interleave2.v4f64(<2 x double> %a, <2 x double> %b)
	   ret <4 x double> %res
}


declare <4 x half> @llvm.experimental.vector.interleave2.v4f16(<2 x half>, <2 x half>)
declare <8 x half> @llvm.experimental.vector.interleave2.v8f16(<4 x half>, <4 x half>)
declare <4 x float> @llvm.experimental.vector.interleave2.v4f32(<2 x float>, <2 x float>)
declare <16 x half> @llvm.experimental.vector.interleave2.v16f16(<8 x half>, <8 x half>)
declare <8 x float> @llvm.experimental.vector.interleave2.v8f32(<4 x float>, <4 x float>)
declare <4 x double> @llvm.experimental.vector.interleave2.v4f64(<2 x double>, <2 x double>)
