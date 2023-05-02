; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=amdgcn -verify-machineinstrs < %s | FileCheck %s --check-prefixes=SI
; RUN: llc -march=amdgcn -mcpu=tonga -mattr=-flat-for-global -verify-machineinstrs < %s | FileCheck %s --check-prefixes=VI
; RUN: llc -march=r600 -mcpu=redwood < %s | FileCheck %s --check-prefixes=EG

declare float @llvm.fabs.f32(float) #1

define amdgpu_kernel void @fp_to_sint_i32(ptr addrspace(1) %out, float %in) {
; SI-LABEL: fp_to_sint_i32:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dword s4, s[0:1], 0xb
; SI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x9
; SI-NEXT:    s_mov_b32 s3, 0xf000
; SI-NEXT:    s_mov_b32 s2, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    v_cvt_i32_f32_e32 v0, s4
; SI-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: fp_to_sint_i32:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dword s2, s[0:1], 0x2c
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; VI-NEXT:    s_mov_b32 s3, 0xf000
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_cvt_i32_f32_e32 v0, s2
; VI-NEXT:    s_mov_b32 s2, -1
; VI-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; VI-NEXT:    s_endpgm
;
; EG-LABEL: fp_to_sint_i32:
; EG:       ; %bb.0:
; EG-NEXT:    ALU 3, @4, KC0[CB0:0-32], KC1[]
; EG-NEXT:    MEM_RAT_CACHELESS STORE_RAW T0.X, T1.X, 1
; EG-NEXT:    CF_END
; EG-NEXT:    PAD
; EG-NEXT:    ALU clause starting at 4:
; EG-NEXT:     TRUNC * T0.W, KC0[2].Z,
; EG-NEXT:     FLT_TO_INT T0.X, PV.W,
; EG-NEXT:     LSHR * T1.X, KC0[2].Y, literal.x,
; EG-NEXT:    2(2.802597e-45), 0(0.000000e+00)
  %conv = fptosi float %in to i32
  store i32 %conv, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @fp_to_sint_i32_fabs(ptr addrspace(1) %out, float %in) {
; SI-LABEL: fp_to_sint_i32_fabs:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dword s4, s[0:1], 0xb
; SI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x9
; SI-NEXT:    s_mov_b32 s3, 0xf000
; SI-NEXT:    s_mov_b32 s2, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    v_cvt_i32_f32_e64 v0, |s4|
; SI-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: fp_to_sint_i32_fabs:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dword s2, s[0:1], 0x2c
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; VI-NEXT:    s_mov_b32 s3, 0xf000
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_cvt_i32_f32_e64 v0, |s2|
; VI-NEXT:    s_mov_b32 s2, -1
; VI-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; VI-NEXT:    s_endpgm
;
; EG-LABEL: fp_to_sint_i32_fabs:
; EG:       ; %bb.0:
; EG-NEXT:    ALU 3, @4, KC0[CB0:0-32], KC1[]
; EG-NEXT:    MEM_RAT_CACHELESS STORE_RAW T0.X, T1.X, 1
; EG-NEXT:    CF_END
; EG-NEXT:    PAD
; EG-NEXT:    ALU clause starting at 4:
; EG-NEXT:     TRUNC * T0.W, |KC0[2].Z|,
; EG-NEXT:     FLT_TO_INT T0.X, PV.W,
; EG-NEXT:     LSHR * T1.X, KC0[2].Y, literal.x,
; EG-NEXT:    2(2.802597e-45), 0(0.000000e+00)
  %in.fabs = call float @llvm.fabs.f32(float %in)
  %conv = fptosi float %in.fabs to i32
  store i32 %conv, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @fp_to_sint_v2i32(ptr addrspace(1) %out, <2 x float> %in) {
; SI-LABEL: fp_to_sint_v2i32:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b32 s4, s0
; SI-NEXT:    s_mov_b32 s5, s1
; SI-NEXT:    v_cvt_i32_f32_e32 v1, s3
; SI-NEXT:    v_cvt_i32_f32_e32 v0, s2
; SI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: fp_to_sint_v2i32:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; VI-NEXT:    s_mov_b32 s7, 0xf000
; VI-NEXT:    s_mov_b32 s6, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_cvt_i32_f32_e32 v1, s3
; VI-NEXT:    v_cvt_i32_f32_e32 v0, s2
; VI-NEXT:    s_mov_b32 s4, s0
; VI-NEXT:    s_mov_b32 s5, s1
; VI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[4:7], 0
; VI-NEXT:    s_endpgm
;
; EG-LABEL: fp_to_sint_v2i32:
; EG:       ; %bb.0:
; EG-NEXT:    ALU 5, @4, KC0[CB0:0-32], KC1[]
; EG-NEXT:    MEM_RAT_CACHELESS STORE_RAW T0.XY, T1.X, 1
; EG-NEXT:    CF_END
; EG-NEXT:    PAD
; EG-NEXT:    ALU clause starting at 4:
; EG-NEXT:     TRUNC * T0.W, KC0[3].X,
; EG-NEXT:     FLT_TO_INT T0.Y, PV.W,
; EG-NEXT:     TRUNC * T0.W, KC0[2].W,
; EG-NEXT:     FLT_TO_INT T0.X, PV.W,
; EG-NEXT:     LSHR * T1.X, KC0[2].Y, literal.x,
; EG-NEXT:    2(2.802597e-45), 0(0.000000e+00)
  %result = fptosi <2 x float> %in to <2 x i32>
  store <2 x i32> %result, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @fp_to_sint_v4i32(ptr addrspace(1) %out, ptr addrspace(1) %in) {
; SI-LABEL: fp_to_sint_v4i32:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_load_dwordx4 s[4:7], s[2:3], 0x0
; SI-NEXT:    s_mov_b32 s3, 0xf000
; SI-NEXT:    s_mov_b32 s2, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    v_cvt_i32_f32_e32 v3, s7
; SI-NEXT:    v_cvt_i32_f32_e32 v2, s6
; SI-NEXT:    v_cvt_i32_f32_e32 v1, s5
; SI-NEXT:    v_cvt_i32_f32_e32 v0, s4
; SI-NEXT:    buffer_store_dwordx4 v[0:3], off, s[0:3], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: fp_to_sint_v4i32:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_load_dwordx4 s[4:7], s[2:3], 0x0
; VI-NEXT:    s_mov_b32 s3, 0xf000
; VI-NEXT:    s_mov_b32 s2, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_cvt_i32_f32_e32 v3, s7
; VI-NEXT:    v_cvt_i32_f32_e32 v2, s6
; VI-NEXT:    v_cvt_i32_f32_e32 v1, s5
; VI-NEXT:    v_cvt_i32_f32_e32 v0, s4
; VI-NEXT:    buffer_store_dwordx4 v[0:3], off, s[0:3], 0
; VI-NEXT:    s_endpgm
;
; EG-LABEL: fp_to_sint_v4i32:
; EG:       ; %bb.0:
; EG-NEXT:    ALU 0, @8, KC0[CB0:0-32], KC1[]
; EG-NEXT:    TEX 0 @6
; EG-NEXT:    ALU 9, @9, KC0[CB0:0-32], KC1[]
; EG-NEXT:    MEM_RAT_CACHELESS STORE_RAW T0.XYZW, T1.X, 1
; EG-NEXT:    CF_END
; EG-NEXT:    PAD
; EG-NEXT:    Fetch clause starting at 6:
; EG-NEXT:     VTX_READ_128 T0.XYZW, T0.X, 0, #1
; EG-NEXT:    ALU clause starting at 8:
; EG-NEXT:     MOV * T0.X, KC0[2].Z,
; EG-NEXT:    ALU clause starting at 9:
; EG-NEXT:     TRUNC T0.W, T0.W,
; EG-NEXT:     TRUNC * T1.W, T0.Z,
; EG-NEXT:     FLT_TO_INT * T0.W, PV.W,
; EG-NEXT:     FLT_TO_INT T0.Z, T1.W,
; EG-NEXT:     TRUNC * T1.W, T0.Y,
; EG-NEXT:     FLT_TO_INT T0.Y, PV.W,
; EG-NEXT:     TRUNC * T1.W, T0.X,
; EG-NEXT:     FLT_TO_INT T0.X, PV.W,
; EG-NEXT:     LSHR * T1.X, KC0[2].Y, literal.x,
; EG-NEXT:    2(2.802597e-45), 0(0.000000e+00)
  %value = load <4 x float>, ptr addrspace(1) %in
  %result = fptosi <4 x float> %value to <4 x i32>
  store <4 x i32> %result, ptr addrspace(1) %out
  ret void
}

; Check that the compiler doesn't crash with a "cannot select" error
define amdgpu_kernel void @fp_to_sint_i64 (ptr addrspace(1) %out, float %in) {
; SI-LABEL: fp_to_sint_i64:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_load_dword s0, s[0:1], 0xb
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_mov_b32 s1, 0x2f800000
; SI-NEXT:    s_mov_b32 s2, 0xcf800000
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    v_trunc_f32_e32 v0, s0
; SI-NEXT:    v_mul_f32_e64 v1, |v0|, s1
; SI-NEXT:    v_ashrrev_i32_e32 v2, 31, v0
; SI-NEXT:    v_floor_f32_e32 v1, v1
; SI-NEXT:    v_cvt_u32_f32_e32 v3, v1
; SI-NEXT:    v_fma_f32 v0, v1, s2, |v0|
; SI-NEXT:    v_cvt_u32_f32_e32 v0, v0
; SI-NEXT:    v_xor_b32_e32 v1, v3, v2
; SI-NEXT:    v_xor_b32_e32 v0, v0, v2
; SI-NEXT:    v_sub_i32_e32 v0, vcc, v0, v2
; SI-NEXT:    v_subb_u32_e32 v1, vcc, v1, v2, vcc
; SI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: fp_to_sint_i64:
; VI:       ; %bb.0: ; %entry
; VI-NEXT:    s_load_dword s2, s[0:1], 0x2c
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; VI-NEXT:    s_mov_b32 s4, 0x2f800000
; VI-NEXT:    s_mov_b32 s5, 0xcf800000
; VI-NEXT:    s_mov_b32 s3, 0xf000
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_trunc_f32_e32 v0, s2
; VI-NEXT:    v_mul_f32_e64 v1, |v0|, s4
; VI-NEXT:    v_floor_f32_e32 v1, v1
; VI-NEXT:    v_fma_f32 v2, v1, s5, |v0|
; VI-NEXT:    v_cvt_u32_f32_e32 v2, v2
; VI-NEXT:    v_cvt_u32_f32_e32 v1, v1
; VI-NEXT:    v_ashrrev_i32_e32 v3, 31, v0
; VI-NEXT:    s_mov_b32 s2, -1
; VI-NEXT:    v_xor_b32_e32 v0, v2, v3
; VI-NEXT:    v_xor_b32_e32 v1, v1, v3
; VI-NEXT:    v_sub_u32_e32 v0, vcc, v0, v3
; VI-NEXT:    v_subb_u32_e32 v1, vcc, v1, v3, vcc
; VI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[0:3], 0
; VI-NEXT:    s_endpgm
;
; EG-LABEL: fp_to_sint_i64:
; EG:       ; %bb.0: ; %entry
; EG-NEXT:    ALU 40, @4, KC0[CB0:0-32], KC1[]
; EG-NEXT:    MEM_RAT_CACHELESS STORE_RAW T0.XY, T1.X, 1
; EG-NEXT:    CF_END
; EG-NEXT:    PAD
; EG-NEXT:    ALU clause starting at 4:
; EG-NEXT:     MOV * T0.W, literal.x,
; EG-NEXT:    8(1.121039e-44), 0(0.000000e+00)
; EG-NEXT:     BFE_UINT T0.W, KC0[2].Z, literal.x, PV.W,
; EG-NEXT:     AND_INT * T1.W, KC0[2].Z, literal.y,
; EG-NEXT:    23(3.222986e-44), 8388607(1.175494e-38)
; EG-NEXT:     OR_INT T1.W, PS, literal.x,
; EG-NEXT:     ADD_INT * T2.W, PV.W, literal.y,
; EG-NEXT:    8388608(1.175494e-38), -150(nan)
; EG-NEXT:     ADD_INT T0.X, T0.W, literal.x,
; EG-NEXT:     SUB_INT T0.Y, literal.y, T0.W,
; EG-NEXT:     AND_INT T0.Z, PS, literal.z,
; EG-NEXT:     NOT_INT T0.W, PS,
; EG-NEXT:     LSHR * T3.W, PV.W, 1,
; EG-NEXT:    -127(nan), 150(2.101948e-43)
; EG-NEXT:    31(4.344025e-44), 0(0.000000e+00)
; EG-NEXT:     BIT_ALIGN_INT T1.X, 0.0, PS, PV.W,
; EG-NEXT:     LSHL T1.Y, T1.W, PV.Z,
; EG-NEXT:     AND_INT T0.Z, T2.W, literal.x, BS:VEC_120/SCL_212
; EG-NEXT:     BIT_ALIGN_INT T0.W, 0.0, T1.W, PV.Y, BS:VEC_021/SCL_122
; EG-NEXT:     AND_INT * T1.W, PV.Y, literal.x,
; EG-NEXT:    32(4.484155e-44), 0(0.000000e+00)
; EG-NEXT:     CNDE_INT T0.Y, PS, PV.W, 0.0,
; EG-NEXT:     CNDE_INT T1.Z, PV.Z, PV.Y, 0.0,
; EG-NEXT:     CNDE_INT T0.W, PV.Z, PV.X, PV.Y,
; EG-NEXT:     SETGT_INT * T1.W, T0.X, literal.x,
; EG-NEXT:    23(3.222986e-44), 0(0.000000e+00)
; EG-NEXT:     CNDE_INT T0.Z, PS, 0.0, PV.W,
; EG-NEXT:     CNDE_INT T0.W, PS, PV.Y, PV.Z,
; EG-NEXT:     ASHR * T1.W, KC0[2].Z, literal.x,
; EG-NEXT:    31(4.344025e-44), 0(0.000000e+00)
; EG-NEXT:     XOR_INT T0.W, PV.W, PS,
; EG-NEXT:     XOR_INT * T2.W, PV.Z, PS,
; EG-NEXT:     SUB_INT T2.W, PS, T1.W,
; EG-NEXT:     SUBB_UINT * T3.W, PV.W, T1.W,
; EG-NEXT:     SUB_INT T2.W, PV.W, PS,
; EG-NEXT:     SETGT_INT * T3.W, 0.0, T0.X,
; EG-NEXT:     CNDE_INT T0.Y, PS, PV.W, 0.0,
; EG-NEXT:     SUB_INT * T0.W, T0.W, T1.W,
; EG-NEXT:     CNDE_INT T0.X, T3.W, PV.W, 0.0,
; EG-NEXT:     LSHR * T1.X, KC0[2].Y, literal.x,
; EG-NEXT:    2(2.802597e-45), 0(0.000000e+00)
entry:
  %0 = fptosi float %in to i64
  store i64 %0, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @fp_to_sint_v2i64(ptr addrspace(1) %out, <2 x float> %x) {
; SI-LABEL: fp_to_sint_v2i64:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_mov_b32 s8, 0x2f800000
; SI-NEXT:    s_mov_b32 s9, 0xcf800000
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b32 s4, s0
; SI-NEXT:    s_mov_b32 s5, s1
; SI-NEXT:    v_trunc_f32_e32 v0, s3
; SI-NEXT:    v_trunc_f32_e32 v1, s2
; SI-NEXT:    v_mul_f32_e64 v2, |v0|, s8
; SI-NEXT:    v_ashrrev_i32_e32 v3, 31, v0
; SI-NEXT:    v_mul_f32_e64 v4, |v1|, s8
; SI-NEXT:    v_ashrrev_i32_e32 v5, 31, v1
; SI-NEXT:    v_floor_f32_e32 v2, v2
; SI-NEXT:    v_floor_f32_e32 v4, v4
; SI-NEXT:    v_cvt_u32_f32_e32 v6, v2
; SI-NEXT:    v_fma_f32 v0, v2, s9, |v0|
; SI-NEXT:    v_cvt_u32_f32_e32 v2, v4
; SI-NEXT:    v_fma_f32 v1, v4, s9, |v1|
; SI-NEXT:    v_cvt_u32_f32_e32 v0, v0
; SI-NEXT:    v_xor_b32_e32 v4, v6, v3
; SI-NEXT:    v_cvt_u32_f32_e32 v1, v1
; SI-NEXT:    v_xor_b32_e32 v6, v2, v5
; SI-NEXT:    v_xor_b32_e32 v0, v0, v3
; SI-NEXT:    v_xor_b32_e32 v1, v1, v5
; SI-NEXT:    v_sub_i32_e32 v2, vcc, v0, v3
; SI-NEXT:    v_subb_u32_e32 v3, vcc, v4, v3, vcc
; SI-NEXT:    v_sub_i32_e32 v0, vcc, v1, v5
; SI-NEXT:    v_subb_u32_e32 v1, vcc, v6, v5, vcc
; SI-NEXT:    buffer_store_dwordx4 v[0:3], off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: fp_to_sint_v2i64:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; VI-NEXT:    s_mov_b32 s8, 0x2f800000
; VI-NEXT:    s_mov_b32 s7, 0xf000
; VI-NEXT:    s_mov_b32 s6, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_trunc_f32_e32 v0, s3
; VI-NEXT:    v_mul_f32_e64 v1, |v0|, s8
; VI-NEXT:    s_mov_b32 s4, s0
; VI-NEXT:    v_floor_f32_e32 v1, v1
; VI-NEXT:    s_mov_b32 s0, 0xcf800000
; VI-NEXT:    v_fma_f32 v2, v1, s0, |v0|
; VI-NEXT:    v_trunc_f32_e32 v4, s2
; VI-NEXT:    v_cvt_u32_f32_e32 v2, v2
; VI-NEXT:    v_mul_f32_e64 v3, |v4|, s8
; VI-NEXT:    v_cvt_u32_f32_e32 v1, v1
; VI-NEXT:    v_floor_f32_e32 v3, v3
; VI-NEXT:    v_cvt_u32_f32_e32 v5, v3
; VI-NEXT:    v_fma_f32 v3, v3, s0, |v4|
; VI-NEXT:    v_ashrrev_i32_e32 v0, 31, v0
; VI-NEXT:    v_cvt_u32_f32_e32 v6, v3
; VI-NEXT:    v_xor_b32_e32 v2, v2, v0
; VI-NEXT:    v_xor_b32_e32 v1, v1, v0
; VI-NEXT:    v_sub_u32_e32 v2, vcc, v2, v0
; VI-NEXT:    v_subb_u32_e32 v3, vcc, v1, v0, vcc
; VI-NEXT:    v_ashrrev_i32_e32 v1, 31, v4
; VI-NEXT:    v_xor_b32_e32 v0, v6, v1
; VI-NEXT:    v_xor_b32_e32 v4, v5, v1
; VI-NEXT:    v_sub_u32_e32 v0, vcc, v0, v1
; VI-NEXT:    s_mov_b32 s5, s1
; VI-NEXT:    v_subb_u32_e32 v1, vcc, v4, v1, vcc
; VI-NEXT:    buffer_store_dwordx4 v[0:3], off, s[4:7], 0
; VI-NEXT:    s_endpgm
;
; EG-LABEL: fp_to_sint_v2i64:
; EG:       ; %bb.0:
; EG-NEXT:    ALU 75, @4, KC0[CB0:0-32], KC1[]
; EG-NEXT:    MEM_RAT_CACHELESS STORE_RAW T1.XYZW, T0.X, 1
; EG-NEXT:    CF_END
; EG-NEXT:    PAD
; EG-NEXT:    ALU clause starting at 4:
; EG-NEXT:     MOV * T0.W, literal.x,
; EG-NEXT:    8(1.121039e-44), 0(0.000000e+00)
; EG-NEXT:     BFE_UINT * T1.W, KC0[2].W, literal.x, PV.W,
; EG-NEXT:    23(3.222986e-44), 0(0.000000e+00)
; EG-NEXT:     AND_INT T0.Z, KC0[2].W, literal.x,
; EG-NEXT:     BFE_UINT T0.W, KC0[3].X, literal.y, T0.W,
; EG-NEXT:     ADD_INT * T2.W, PV.W, literal.z,
; EG-NEXT:    8388607(1.175494e-38), 23(3.222986e-44)
; EG-NEXT:    -150(nan), 0(0.000000e+00)
; EG-NEXT:     SUB_INT T0.X, literal.x, PV.W,
; EG-NEXT:     SUB_INT T0.Y, literal.x, T1.W,
; EG-NEXT:     AND_INT T1.Z, PS, literal.y,
; EG-NEXT:     OR_INT T3.W, PV.Z, literal.z,
; EG-NEXT:     AND_INT * T4.W, KC0[3].X, literal.w,
; EG-NEXT:    150(2.101948e-43), 31(4.344025e-44)
; EG-NEXT:    8388608(1.175494e-38), 8388607(1.175494e-38)
; EG-NEXT:     OR_INT T1.X, PS, literal.x,
; EG-NEXT:     LSHL T1.Y, PV.W, PV.Z,
; EG-NEXT:     AND_INT T0.Z, T2.W, literal.y,
; EG-NEXT:     BIT_ALIGN_INT T4.W, 0.0, PV.W, PV.Y,
; EG-NEXT:     AND_INT * T5.W, PV.Y, literal.y,
; EG-NEXT:    8388608(1.175494e-38), 32(4.484155e-44)
; EG-NEXT:     CNDE_INT T2.X, PS, PV.W, 0.0,
; EG-NEXT:     CNDE_INT T0.Y, PV.Z, PV.Y, 0.0,
; EG-NEXT:     ADD_INT T1.Z, T0.W, literal.x,
; EG-NEXT:     BIT_ALIGN_INT T4.W, 0.0, PV.X, T0.X,
; EG-NEXT:     AND_INT * T5.W, T0.X, literal.y,
; EG-NEXT:    -150(nan), 32(4.484155e-44)
; EG-NEXT:     CNDE_INT T0.X, PS, PV.W, 0.0,
; EG-NEXT:     NOT_INT T2.Y, T2.W,
; EG-NEXT:     AND_INT T2.Z, PV.Z, literal.x,
; EG-NEXT:     NOT_INT T2.W, PV.Z,
; EG-NEXT:     LSHR * T4.W, T1.X, 1,
; EG-NEXT:    31(4.344025e-44), 0(0.000000e+00)
; EG-NEXT:     LSHR T3.X, T3.W, 1,
; EG-NEXT:     ADD_INT T3.Y, T0.W, literal.x, BS:VEC_120/SCL_212
; EG-NEXT:     BIT_ALIGN_INT T3.Z, 0.0, PS, PV.W,
; EG-NEXT:     LSHL T0.W, T1.X, PV.Z,
; EG-NEXT:     AND_INT * T2.W, T1.Z, literal.y,
; EG-NEXT:    -127(nan), 32(4.484155e-44)
; EG-NEXT:     CNDE_INT T1.X, PS, PV.W, 0.0,
; EG-NEXT:     CNDE_INT T4.Y, PS, PV.Z, PV.W,
; EG-NEXT:     SETGT_INT T1.Z, PV.Y, literal.x,
; EG-NEXT:     BIT_ALIGN_INT T0.W, 0.0, PV.X, T2.Y,
; EG-NEXT:     ADD_INT * T1.W, T1.W, literal.y,
; EG-NEXT:    23(3.222986e-44), -127(nan)
; EG-NEXT:     CNDE_INT T3.X, T0.Z, PV.W, T1.Y,
; EG-NEXT:     SETGT_INT T1.Y, PS, literal.x,
; EG-NEXT:     CNDE_INT T0.Z, PV.Z, 0.0, PV.Y,
; EG-NEXT:     CNDE_INT T0.W, PV.Z, T0.X, PV.X,
; EG-NEXT:     ASHR * T2.W, KC0[3].X, literal.y,
; EG-NEXT:    23(3.222986e-44), 31(4.344025e-44)
; EG-NEXT:     XOR_INT T0.X, PV.W, PS,
; EG-NEXT:     XOR_INT T2.Y, PV.Z, PS,
; EG-NEXT:     CNDE_INT T0.Z, PV.Y, 0.0, PV.X,
; EG-NEXT:     CNDE_INT T0.W, PV.Y, T2.X, T0.Y,
; EG-NEXT:     ASHR * T3.W, KC0[2].W, literal.x,
; EG-NEXT:    31(4.344025e-44), 0(0.000000e+00)
; EG-NEXT:     XOR_INT T0.Y, PV.W, PS,
; EG-NEXT:     XOR_INT T0.Z, PV.Z, PS,
; EG-NEXT:     SUB_INT T0.W, PV.Y, T2.W,
; EG-NEXT:     SUBB_UINT * T4.W, PV.X, T2.W,
; EG-NEXT:     SUB_INT T1.Y, PV.W, PS,
; EG-NEXT:     SETGT_INT T1.Z, 0.0, T3.Y,
; EG-NEXT:     SUB_INT T0.W, PV.Z, T3.W,
; EG-NEXT:     SUBB_UINT * T4.W, PV.Y, T3.W,
; EG-NEXT:     SUB_INT T0.Z, PV.W, PS,
; EG-NEXT:     SETGT_INT T0.W, 0.0, T1.W,
; EG-NEXT:     CNDE_INT * T1.W, PV.Z, PV.Y, 0.0,
; EG-NEXT:     CNDE_INT T1.Y, PV.W, PV.Z, 0.0,
; EG-NEXT:     SUB_INT * T2.W, T0.X, T2.W,
; EG-NEXT:     CNDE_INT T1.Z, T1.Z, PV.W, 0.0,
; EG-NEXT:     SUB_INT * T2.W, T0.Y, T3.W,
; EG-NEXT:     CNDE_INT T1.X, T0.W, PV.W, 0.0,
; EG-NEXT:     LSHR * T0.X, KC0[2].Y, literal.x,
; EG-NEXT:    2(2.802597e-45), 0(0.000000e+00)
  %conv = fptosi <2 x float> %x to <2 x i64>
  store <2 x i64> %conv, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @fp_to_sint_v4i64(ptr addrspace(1) %out, <4 x float> %x) {
; SI-LABEL: fp_to_sint_v4i64:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0xd
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_mov_b32 s8, 0x2f800000
; SI-NEXT:    s_mov_b32 s9, 0xcf800000
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    v_trunc_f32_e32 v0, s1
; SI-NEXT:    v_trunc_f32_e32 v1, s0
; SI-NEXT:    v_trunc_f32_e32 v2, s3
; SI-NEXT:    v_trunc_f32_e32 v3, s2
; SI-NEXT:    v_mul_f32_e64 v4, |v0|, s8
; SI-NEXT:    v_ashrrev_i32_e32 v5, 31, v0
; SI-NEXT:    v_mul_f32_e64 v6, |v1|, s8
; SI-NEXT:    v_ashrrev_i32_e32 v7, 31, v1
; SI-NEXT:    v_mul_f32_e64 v8, |v2|, s8
; SI-NEXT:    v_ashrrev_i32_e32 v9, 31, v2
; SI-NEXT:    v_mul_f32_e64 v10, |v3|, s8
; SI-NEXT:    v_ashrrev_i32_e32 v11, 31, v3
; SI-NEXT:    v_floor_f32_e32 v4, v4
; SI-NEXT:    v_floor_f32_e32 v6, v6
; SI-NEXT:    v_floor_f32_e32 v8, v8
; SI-NEXT:    v_floor_f32_e32 v10, v10
; SI-NEXT:    v_cvt_u32_f32_e32 v12, v4
; SI-NEXT:    v_fma_f32 v0, v4, s9, |v0|
; SI-NEXT:    v_cvt_u32_f32_e32 v4, v6
; SI-NEXT:    v_fma_f32 v1, v6, s9, |v1|
; SI-NEXT:    v_cvt_u32_f32_e32 v6, v8
; SI-NEXT:    v_fma_f32 v2, v8, s9, |v2|
; SI-NEXT:    v_cvt_u32_f32_e32 v8, v10
; SI-NEXT:    v_fma_f32 v3, v10, s9, |v3|
; SI-NEXT:    v_cvt_u32_f32_e32 v0, v0
; SI-NEXT:    v_xor_b32_e32 v10, v12, v5
; SI-NEXT:    v_cvt_u32_f32_e32 v1, v1
; SI-NEXT:    v_xor_b32_e32 v4, v4, v7
; SI-NEXT:    v_cvt_u32_f32_e32 v2, v2
; SI-NEXT:    v_xor_b32_e32 v12, v6, v9
; SI-NEXT:    v_cvt_u32_f32_e32 v3, v3
; SI-NEXT:    v_xor_b32_e32 v8, v8, v11
; SI-NEXT:    v_xor_b32_e32 v0, v0, v5
; SI-NEXT:    v_xor_b32_e32 v1, v1, v7
; SI-NEXT:    v_xor_b32_e32 v6, v2, v9
; SI-NEXT:    v_xor_b32_e32 v13, v3, v11
; SI-NEXT:    v_sub_i32_e32 v2, vcc, v0, v5
; SI-NEXT:    v_subb_u32_e32 v3, vcc, v10, v5, vcc
; SI-NEXT:    v_sub_i32_e32 v0, vcc, v1, v7
; SI-NEXT:    v_subb_u32_e32 v1, vcc, v4, v7, vcc
; SI-NEXT:    v_sub_i32_e32 v6, vcc, v6, v9
; SI-NEXT:    v_subb_u32_e32 v7, vcc, v12, v9, vcc
; SI-NEXT:    v_sub_i32_e32 v4, vcc, v13, v11
; SI-NEXT:    v_subb_u32_e32 v5, vcc, v8, v11, vcc
; SI-NEXT:    buffer_store_dwordx4 v[4:7], off, s[4:7], 0 offset:16
; SI-NEXT:    buffer_store_dwordx4 v[0:3], off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: fp_to_sint_v4i64:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x34
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; VI-NEXT:    s_mov_b32 s8, 0x2f800000
; VI-NEXT:    s_mov_b32 s9, 0xcf800000
; VI-NEXT:    s_mov_b32 s3, 0xf000
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_trunc_f32_e32 v0, s5
; VI-NEXT:    v_mul_f32_e64 v1, |v0|, s8
; VI-NEXT:    v_floor_f32_e32 v1, v1
; VI-NEXT:    v_fma_f32 v2, v1, s9, |v0|
; VI-NEXT:    v_cvt_u32_f32_e32 v2, v2
; VI-NEXT:    v_trunc_f32_e32 v4, s4
; VI-NEXT:    v_cvt_u32_f32_e32 v1, v1
; VI-NEXT:    v_mul_f32_e64 v3, |v4|, s8
; VI-NEXT:    v_floor_f32_e32 v3, v3
; VI-NEXT:    v_ashrrev_i32_e32 v0, 31, v0
; VI-NEXT:    v_cvt_u32_f32_e32 v5, v3
; VI-NEXT:    v_fma_f32 v3, v3, s9, |v4|
; VI-NEXT:    v_xor_b32_e32 v2, v2, v0
; VI-NEXT:    v_cvt_u32_f32_e32 v6, v3
; VI-NEXT:    v_xor_b32_e32 v1, v1, v0
; VI-NEXT:    v_sub_u32_e32 v2, vcc, v2, v0
; VI-NEXT:    v_subb_u32_e32 v3, vcc, v1, v0, vcc
; VI-NEXT:    v_ashrrev_i32_e32 v1, 31, v4
; VI-NEXT:    v_xor_b32_e32 v4, v5, v1
; VI-NEXT:    v_trunc_f32_e32 v5, s7
; VI-NEXT:    v_xor_b32_e32 v0, v6, v1
; VI-NEXT:    v_mul_f32_e64 v6, |v5|, s8
; VI-NEXT:    v_floor_f32_e32 v6, v6
; VI-NEXT:    v_cvt_u32_f32_e32 v7, v6
; VI-NEXT:    v_fma_f32 v6, v6, s9, |v5|
; VI-NEXT:    v_cvt_u32_f32_e32 v6, v6
; VI-NEXT:    v_sub_u32_e32 v0, vcc, v0, v1
; VI-NEXT:    v_subb_u32_e32 v1, vcc, v4, v1, vcc
; VI-NEXT:    v_ashrrev_i32_e32 v4, 31, v5
; VI-NEXT:    v_trunc_f32_e32 v8, s6
; VI-NEXT:    v_xor_b32_e32 v5, v6, v4
; VI-NEXT:    v_mul_f32_e64 v6, |v8|, s8
; VI-NEXT:    v_floor_f32_e32 v6, v6
; VI-NEXT:    v_cvt_u32_f32_e32 v9, v6
; VI-NEXT:    v_fma_f32 v6, v6, s9, |v8|
; VI-NEXT:    v_cvt_u32_f32_e32 v10, v6
; VI-NEXT:    v_xor_b32_e32 v7, v7, v4
; VI-NEXT:    v_sub_u32_e32 v6, vcc, v5, v4
; VI-NEXT:    v_ashrrev_i32_e32 v5, 31, v8
; VI-NEXT:    v_subb_u32_e32 v7, vcc, v7, v4, vcc
; VI-NEXT:    v_xor_b32_e32 v4, v10, v5
; VI-NEXT:    v_xor_b32_e32 v8, v9, v5
; VI-NEXT:    v_sub_u32_e32 v4, vcc, v4, v5
; VI-NEXT:    s_mov_b32 s2, -1
; VI-NEXT:    v_subb_u32_e32 v5, vcc, v8, v5, vcc
; VI-NEXT:    buffer_store_dwordx4 v[4:7], off, s[0:3], 0 offset:16
; VI-NEXT:    buffer_store_dwordx4 v[0:3], off, s[0:3], 0
; VI-NEXT:    s_endpgm
;
; EG-LABEL: fp_to_sint_v4i64:
; EG:       ; %bb.0:
; EG-NEXT:    ALU 101, @6, KC0[CB0:0-32], KC1[]
; EG-NEXT:    ALU 54, @108, KC0[CB0:0-32], KC1[]
; EG-NEXT:    MEM_RAT_CACHELESS STORE_RAW T4.XYZW, T0.X, 0
; EG-NEXT:    MEM_RAT_CACHELESS STORE_RAW T6.XYZW, T2.X, 1
; EG-NEXT:    CF_END
; EG-NEXT:    PAD
; EG-NEXT:    ALU clause starting at 6:
; EG-NEXT:     MOV * T0.W, literal.x,
; EG-NEXT:    8(1.121039e-44), 0(0.000000e+00)
; EG-NEXT:     BFE_UINT T1.W, KC0[4].X, literal.x, PV.W,
; EG-NEXT:     AND_INT * T2.W, KC0[4].X, literal.y,
; EG-NEXT:    23(3.222986e-44), 8388607(1.175494e-38)
; EG-NEXT:     OR_INT T0.Z, PS, literal.x,
; EG-NEXT:     BFE_UINT T2.W, KC0[3].Z, literal.y, T0.W,
; EG-NEXT:     ADD_INT * T3.W, PV.W, literal.z,
; EG-NEXT:    8388608(1.175494e-38), 23(3.222986e-44)
; EG-NEXT:    -150(nan), 0(0.000000e+00)
; EG-NEXT:     ADD_INT T0.Y, PV.W, literal.x,
; EG-NEXT:     AND_INT T1.Z, PS, literal.y,
; EG-NEXT:     NOT_INT T4.W, PS,
; EG-NEXT:     LSHR * T5.W, PV.Z, 1,
; EG-NEXT:    -127(nan), 31(4.344025e-44)
; EG-NEXT:     ADD_INT T0.X, T1.W, literal.x,
; EG-NEXT:     BIT_ALIGN_INT T1.Y, 0.0, PS, PV.W,
; EG-NEXT:     AND_INT T2.Z, T3.W, literal.y, BS:VEC_201
; EG-NEXT:     LSHL T3.W, T0.Z, PV.Z,
; EG-NEXT:     SUB_INT * T1.W, literal.z, T1.W,
; EG-NEXT:    -127(nan), 32(4.484155e-44)
; EG-NEXT:    150(2.101948e-43), 0(0.000000e+00)
; EG-NEXT:     AND_INT T1.X, PS, literal.x,
; EG-NEXT:     BIT_ALIGN_INT T2.Y, 0.0, T0.Z, PS,
; EG-NEXT:     AND_INT T0.Z, KC0[3].Z, literal.y,
; EG-NEXT:     CNDE_INT T1.W, PV.Z, PV.Y, PV.W,
; EG-NEXT:     SETGT_INT * T4.W, PV.X, literal.z,
; EG-NEXT:    32(4.484155e-44), 8388607(1.175494e-38)
; EG-NEXT:    23(3.222986e-44), 0(0.000000e+00)
; EG-NEXT:     CNDE_INT T2.X, PS, 0.0, PV.W,
; EG-NEXT:     OR_INT T1.Y, PV.Z, literal.x,
; EG-NEXT:     ADD_INT T0.Z, T2.W, literal.y,
; EG-NEXT:     CNDE_INT T1.W, PV.X, PV.Y, 0.0,
; EG-NEXT:     CNDE_INT * T3.W, T2.Z, T3.W, 0.0,
; EG-NEXT:    8388608(1.175494e-38), -150(nan)
; EG-NEXT:     CNDE_INT T1.X, T4.W, PV.W, PS,
; EG-NEXT:     ASHR T2.Y, KC0[4].X, literal.x,
; EG-NEXT:     AND_INT T1.Z, PV.Z, literal.x,
; EG-NEXT:     NOT_INT T1.W, PV.Z,
; EG-NEXT:     LSHR * T3.W, PV.Y, 1,
; EG-NEXT:    31(4.344025e-44), 0(0.000000e+00)
; EG-NEXT:     BIT_ALIGN_INT T3.X, 0.0, PS, PV.W,
; EG-NEXT:     LSHL T3.Y, T1.Y, PV.Z,
; EG-NEXT:     XOR_INT T1.Z, PV.X, PV.Y,
; EG-NEXT:     XOR_INT T1.W, T2.X, PV.Y,
; EG-NEXT:     SUB_INT * T2.W, literal.x, T2.W,
; EG-NEXT:    150(2.101948e-43), 0(0.000000e+00)
; EG-NEXT:     AND_INT T1.X, T0.Z, literal.x,
; EG-NEXT:     AND_INT T4.Y, PS, literal.x,
; EG-NEXT:     BIT_ALIGN_INT T0.Z, 0.0, T1.Y, PS, BS:VEC_021/SCL_122
; EG-NEXT:     SUB_INT T1.W, PV.W, T2.Y,
; EG-NEXT:     SUBB_UINT * T2.W, PV.Z, T2.Y,
; EG-NEXT:    32(4.484155e-44), 0(0.000000e+00)
; EG-NEXT:     SUB_INT T2.X, PV.W, PS,
; EG-NEXT:     CNDE_INT T1.Y, PV.Y, PV.Z, 0.0,
; EG-NEXT:     CNDE_INT T0.Z, PV.X, T3.Y, 0.0,
; EG-NEXT:     CNDE_INT T1.W, PV.X, T3.X, T3.Y, BS:VEC_021/SCL_122
; EG-NEXT:     SETGT_INT * T2.W, T0.Y, literal.x,
; EG-NEXT:    23(3.222986e-44), 0(0.000000e+00)
; EG-NEXT:     BFE_UINT T1.X, KC0[3].W, literal.x, T0.W,
; EG-NEXT:     AND_INT T3.Y, KC0[3].W, literal.y,
; EG-NEXT:     CNDE_INT T2.Z, PS, 0.0, PV.W,
; EG-NEXT:     CNDE_INT T1.W, PS, PV.Y, PV.Z,
; EG-NEXT:     ASHR * T2.W, KC0[3].Z, literal.z,
; EG-NEXT:    23(3.222986e-44), 8388607(1.175494e-38)
; EG-NEXT:    31(4.344025e-44), 0(0.000000e+00)
; EG-NEXT:     BFE_UINT T3.X, KC0[3].Y, literal.x, T0.W,
; EG-NEXT:     XOR_INT T1.Y, PV.W, PS,
; EG-NEXT:     XOR_INT T0.Z, PV.Z, PS,
; EG-NEXT:     OR_INT T0.W, PV.Y, literal.y,
; EG-NEXT:     SUB_INT * T1.W, literal.z, PV.X,
; EG-NEXT:    23(3.222986e-44), 8388608(1.175494e-38)
; EG-NEXT:    150(2.101948e-43), 0(0.000000e+00)
; EG-NEXT:     AND_INT T4.X, KC0[3].Y, literal.x,
; EG-NEXT:     AND_INT T3.Y, PS, literal.y,
; EG-NEXT:     BIT_ALIGN_INT T2.Z, 0.0, PV.W, PS,
; EG-NEXT:     SUB_INT T1.W, PV.Z, T2.W,
; EG-NEXT:     SUBB_UINT * T3.W, PV.Y, T2.W,
; EG-NEXT:    8388607(1.175494e-38), 32(4.484155e-44)
; EG-NEXT:     SUB_INT T5.X, PV.W, PS,
; EG-NEXT:     SETGT_INT T0.Y, 0.0, T0.Y,
; EG-NEXT:     CNDE_INT T0.Z, PV.Y, PV.Z, 0.0,
; EG-NEXT:     OR_INT T1.W, PV.X, literal.x,
; EG-NEXT:     ADD_INT * T3.W, T3.X, literal.y,
; EG-NEXT:    8388608(1.175494e-38), -150(nan)
; EG-NEXT:     ADD_INT T4.X, T3.X, literal.x,
; EG-NEXT:     SUB_INT T3.Y, literal.y, T3.X,
; EG-NEXT:     AND_INT T2.Z, PS, literal.z,
; EG-NEXT:     NOT_INT T4.W, PS,
; EG-NEXT:     LSHR * T5.W, PV.W, 1,
; EG-NEXT:    -127(nan), 150(2.101948e-43)
; EG-NEXT:    31(4.344025e-44), 0(0.000000e+00)
; EG-NEXT:     BIT_ALIGN_INT T3.X, 0.0, PS, PV.W,
; EG-NEXT:     LSHL T4.Y, T1.W, PV.Z,
; EG-NEXT:     AND_INT T2.Z, T3.W, literal.x, BS:VEC_120/SCL_212
; EG-NEXT:     BIT_ALIGN_INT T1.W, 0.0, T1.W, PV.Y, BS:VEC_021/SCL_122
; EG-NEXT:     AND_INT * T3.W, PV.Y, literal.x,
; EG-NEXT:    32(4.484155e-44), 0(0.000000e+00)
; EG-NEXT:     ADD_INT T6.X, T1.X, literal.x,
; EG-NEXT:     CNDE_INT T3.Y, PS, PV.W, 0.0,
; EG-NEXT:     CNDE_INT * T3.Z, PV.Z, PV.Y, 0.0,
; EG-NEXT:    -150(nan), 0(0.000000e+00)
; EG-NEXT:    ALU clause starting at 108:
; EG-NEXT:     CNDE_INT T1.W, T2.Z, T3.X, T4.Y,
; EG-NEXT:     SETGT_INT * T3.W, T4.X, literal.x,
; EG-NEXT:    23(3.222986e-44), 0(0.000000e+00)
; EG-NEXT:     CNDE_INT T3.X, PS, 0.0, PV.W,
; EG-NEXT:     CNDE_INT T3.Y, PS, T3.Y, T3.Z,
; EG-NEXT:     AND_INT T2.Z, T6.X, literal.x,
; EG-NEXT:     NOT_INT T1.W, T6.X,
; EG-NEXT:     LSHR * T3.W, T0.W, 1,
; EG-NEXT:    31(4.344025e-44), 0(0.000000e+00)
; EG-NEXT:     ASHR T7.X, KC0[3].Y, literal.x,
; EG-NEXT:     ADD_INT T4.Y, T1.X, literal.y,
; EG-NEXT:     BIT_ALIGN_INT T3.Z, 0.0, PS, PV.W,
; EG-NEXT:     LSHL T0.W, T0.W, PV.Z,
; EG-NEXT:     AND_INT * T1.W, T6.X, literal.z,
; EG-NEXT:    31(4.344025e-44), -127(nan)
; EG-NEXT:    32(4.484155e-44), 0(0.000000e+00)
; EG-NEXT:     CNDE_INT T1.X, PS, PV.W, 0.0,
; EG-NEXT:     CNDE_INT T5.Y, PS, PV.Z, PV.W,
; EG-NEXT:     SETGT_INT T2.Z, PV.Y, literal.x,
; EG-NEXT:     XOR_INT T0.W, T3.Y, PV.X,
; EG-NEXT:     XOR_INT * T1.W, T3.X, PV.X,
; EG-NEXT:    23(3.222986e-44), 0(0.000000e+00)
; EG-NEXT:     SUB_INT T3.X, PS, T7.X,
; EG-NEXT:     SUBB_UINT T3.Y, PV.W, T7.X,
; EG-NEXT:     CNDE_INT T3.Z, PV.Z, 0.0, PV.Y,
; EG-NEXT:     CNDE_INT T1.W, PV.Z, T0.Z, PV.X,
; EG-NEXT:     ASHR * T3.W, KC0[3].W, literal.x,
; EG-NEXT:    31(4.344025e-44), 0(0.000000e+00)
; EG-NEXT:     XOR_INT T1.X, PV.W, PS,
; EG-NEXT:     XOR_INT T5.Y, PV.Z, PS,
; EG-NEXT:     SUB_INT T0.Z, PV.X, PV.Y,
; EG-NEXT:     SETGT_INT T1.W, 0.0, T4.X, BS:VEC_021/SCL_122
; EG-NEXT:     CNDE_INT * T6.W, T0.Y, T5.X, 0.0,
; EG-NEXT:     SETGT_INT T0.X, 0.0, T0.X,
; EG-NEXT:     CNDE_INT T6.Y, PV.W, PV.Z, 0.0,
; EG-NEXT:     SUB_INT T0.Z, T1.Y, T2.W, BS:VEC_021/SCL_122
; EG-NEXT:     SUB_INT T2.W, PV.Y, T3.W,
; EG-NEXT:     SUBB_UINT * T4.W, PV.X, T3.W,
; EG-NEXT:     SUB_INT T3.X, PV.W, PS,
; EG-NEXT:     SETGT_INT T1.Y, 0.0, T4.Y,
; EG-NEXT:     CNDE_INT T6.Z, T0.Y, PV.Z, 0.0,
; EG-NEXT:     SUB_INT T0.W, T0.W, T7.X, BS:VEC_021/SCL_122
; EG-NEXT:     CNDE_INT * T4.W, PV.X, T2.X, 0.0,
; EG-NEXT:     CNDE_INT T6.X, T1.W, PV.W, 0.0,
; EG-NEXT:     CNDE_INT T4.Y, PV.Y, PV.X, 0.0,
; EG-NEXT:     SUB_INT T0.W, T1.Z, T2.Y,
; EG-NEXT:     LSHR * T2.X, KC0[2].Y, literal.x,
; EG-NEXT:    2(2.802597e-45), 0(0.000000e+00)
; EG-NEXT:     CNDE_INT T4.Z, T0.X, PV.W, 0.0,
; EG-NEXT:     SUB_INT * T0.W, T1.X, T3.W, BS:VEC_120/SCL_212
; EG-NEXT:     CNDE_INT T4.X, T1.Y, PV.W, 0.0,
; EG-NEXT:     ADD_INT * T0.W, KC0[2].Y, literal.x,
; EG-NEXT:    16(2.242078e-44), 0(0.000000e+00)
; EG-NEXT:     LSHR * T0.X, PV.W, literal.x,
; EG-NEXT:    2(2.802597e-45), 0(0.000000e+00)
  %conv = fptosi <4 x float> %x to <4 x i64>
  store <4 x i64> %conv, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @fp_to_uint_f32_to_i1(ptr addrspace(1) %out, float %in) #0 {
; SI-LABEL: fp_to_uint_f32_to_i1:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dword s4, s[0:1], 0xb
; SI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x9
; SI-NEXT:    s_mov_b32 s3, 0xf000
; SI-NEXT:    s_mov_b32 s2, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    v_cmp_eq_f32_e64 s[4:5], -1.0, s4
; SI-NEXT:    v_cndmask_b32_e64 v0, 0, 1, s[4:5]
; SI-NEXT:    buffer_store_byte v0, off, s[0:3], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: fp_to_uint_f32_to_i1:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dword s4, s[0:1], 0x2c
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; VI-NEXT:    s_mov_b32 s3, 0xf000
; VI-NEXT:    s_mov_b32 s2, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_cmp_eq_f32_e64 s[4:5], -1.0, s4
; VI-NEXT:    v_cndmask_b32_e64 v0, 0, 1, s[4:5]
; VI-NEXT:    buffer_store_byte v0, off, s[0:3], 0
; VI-NEXT:    s_endpgm
;
; EG-LABEL: fp_to_uint_f32_to_i1:
; EG:       ; %bb.0:
; EG-NEXT:    ALU 12, @4, KC0[CB0:0-32], KC1[]
; EG-NEXT:    MEM_RAT MSKOR T0.XW, T1.X
; EG-NEXT:    CF_END
; EG-NEXT:    PAD
; EG-NEXT:    ALU clause starting at 4:
; EG-NEXT:     AND_INT T0.W, KC0[2].Y, literal.x,
; EG-NEXT:     SETE_DX10 * T1.W, KC0[2].Z, literal.y,
; EG-NEXT:    3(4.203895e-45), -1082130432(-1.000000e+00)
; EG-NEXT:     AND_INT T1.W, PS, 1,
; EG-NEXT:     LSHL * T0.W, PV.W, literal.x,
; EG-NEXT:    3(4.203895e-45), 0(0.000000e+00)
; EG-NEXT:     LSHL T0.X, PV.W, PS,
; EG-NEXT:     LSHL * T0.W, literal.x, PS,
; EG-NEXT:    255(3.573311e-43), 0(0.000000e+00)
; EG-NEXT:     MOV T0.Y, 0.0,
; EG-NEXT:     MOV * T0.Z, 0.0,
; EG-NEXT:     LSHR * T1.X, KC0[2].Y, literal.x,
; EG-NEXT:    2(2.802597e-45), 0(0.000000e+00)
  %conv = fptosi float %in to i1
  store i1 %conv, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @fp_to_uint_fabs_f32_to_i1(ptr addrspace(1) %out, float %in) #0 {
; SI-LABEL: fp_to_uint_fabs_f32_to_i1:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dword s4, s[0:1], 0xb
; SI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x9
; SI-NEXT:    s_mov_b32 s3, 0xf000
; SI-NEXT:    s_mov_b32 s2, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    v_cmp_eq_f32_e64 s[4:5], -1.0, |s4|
; SI-NEXT:    v_cndmask_b32_e64 v0, 0, 1, s[4:5]
; SI-NEXT:    buffer_store_byte v0, off, s[0:3], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: fp_to_uint_fabs_f32_to_i1:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dword s4, s[0:1], 0x2c
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; VI-NEXT:    s_mov_b32 s3, 0xf000
; VI-NEXT:    s_mov_b32 s2, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_cmp_eq_f32_e64 s[4:5], -1.0, |s4|
; VI-NEXT:    v_cndmask_b32_e64 v0, 0, 1, s[4:5]
; VI-NEXT:    buffer_store_byte v0, off, s[0:3], 0
; VI-NEXT:    s_endpgm
;
; EG-LABEL: fp_to_uint_fabs_f32_to_i1:
; EG:       ; %bb.0:
; EG-NEXT:    ALU 12, @4, KC0[CB0:0-32], KC1[]
; EG-NEXT:    MEM_RAT MSKOR T0.XW, T1.X
; EG-NEXT:    CF_END
; EG-NEXT:    PAD
; EG-NEXT:    ALU clause starting at 4:
; EG-NEXT:     AND_INT T0.W, KC0[2].Y, literal.x,
; EG-NEXT:     SETE_DX10 * T1.W, |KC0[2].Z|, literal.y,
; EG-NEXT:    3(4.203895e-45), -1082130432(-1.000000e+00)
; EG-NEXT:     AND_INT T1.W, PS, 1,
; EG-NEXT:     LSHL * T0.W, PV.W, literal.x,
; EG-NEXT:    3(4.203895e-45), 0(0.000000e+00)
; EG-NEXT:     LSHL T0.X, PV.W, PS,
; EG-NEXT:     LSHL * T0.W, literal.x, PS,
; EG-NEXT:    255(3.573311e-43), 0(0.000000e+00)
; EG-NEXT:     MOV T0.Y, 0.0,
; EG-NEXT:     MOV * T0.Z, 0.0,
; EG-NEXT:     LSHR * T1.X, KC0[2].Y, literal.x,
; EG-NEXT:    2(2.802597e-45), 0(0.000000e+00)
  %in.fabs = call float @llvm.fabs.f32(float %in)
  %conv = fptosi float %in.fabs to i1
  store i1 %conv, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @fp_to_sint_f32_i16(ptr addrspace(1) %out, float %in) #0 {
; SI-LABEL: fp_to_sint_f32_i16:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dword s4, s[0:1], 0xb
; SI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x9
; SI-NEXT:    s_mov_b32 s3, 0xf000
; SI-NEXT:    s_mov_b32 s2, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    v_cvt_i32_f32_e32 v0, s4
; SI-NEXT:    buffer_store_short v0, off, s[0:3], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: fp_to_sint_f32_i16:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dword s2, s[0:1], 0x2c
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; VI-NEXT:    s_mov_b32 s3, 0xf000
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_cvt_i32_f32_e32 v0, s2
; VI-NEXT:    s_mov_b32 s2, -1
; VI-NEXT:    buffer_store_short v0, off, s[0:3], 0
; VI-NEXT:    s_endpgm
;
; EG-LABEL: fp_to_sint_f32_i16:
; EG:       ; %bb.0:
; EG-NEXT:    ALU 13, @4, KC0[CB0:0-32], KC1[]
; EG-NEXT:    MEM_RAT MSKOR T0.XW, T1.X
; EG-NEXT:    CF_END
; EG-NEXT:    PAD
; EG-NEXT:    ALU clause starting at 4:
; EG-NEXT:     TRUNC T0.W, KC0[2].Z,
; EG-NEXT:     AND_INT * T1.W, KC0[2].Y, literal.x,
; EG-NEXT:    3(4.203895e-45), 0(0.000000e+00)
; EG-NEXT:     FLT_TO_INT * T0.W, PV.W,
; EG-NEXT:     AND_INT T0.W, PV.W, literal.x,
; EG-NEXT:     LSHL * T1.W, T1.W, literal.y,
; EG-NEXT:    65535(9.183409e-41), 3(4.203895e-45)
; EG-NEXT:     LSHL T0.X, PV.W, PS,
; EG-NEXT:     LSHL * T0.W, literal.x, PS,
; EG-NEXT:    65535(9.183409e-41), 0(0.000000e+00)
; EG-NEXT:     MOV T0.Y, 0.0,
; EG-NEXT:     MOV * T0.Z, 0.0,
; EG-NEXT:     LSHR * T1.X, KC0[2].Y, literal.x,
; EG-NEXT:    2(2.802597e-45), 0(0.000000e+00)
  %sint = fptosi float %in to i16
  store i16 %sint, ptr addrspace(1) %out
  ret void
}

attributes #0 = { nounwind }
attributes #1 = { nounwind readnone }
