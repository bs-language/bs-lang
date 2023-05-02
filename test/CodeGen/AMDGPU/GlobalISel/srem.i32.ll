; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -amdgpu-codegenprepare-disable-idiv-expansion=1 -mtriple=amdgcn-amd-amdpal < %s | FileCheck -check-prefixes=CHECK,GISEL %s
; RUN: llc -global-isel -amdgpu-codegenprepare-disable-idiv-expansion=0 -mtriple=amdgcn-amd-amdpal < %s | FileCheck -check-prefixes=CHECK,CGP %s

; The same 32-bit expansion is implemented in the legalizer and in AMDGPUCodeGenPrepare.

define i32 @v_srem_i32(i32 %num, i32 %den) {
; GISEL-LABEL: v_srem_i32:
; GISEL:       ; %bb.0:
; GISEL-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GISEL-NEXT:    v_ashrrev_i32_e32 v2, 31, v0
; GISEL-NEXT:    v_ashrrev_i32_e32 v3, 31, v1
; GISEL-NEXT:    v_add_i32_e32 v0, vcc, v0, v2
; GISEL-NEXT:    v_add_i32_e32 v1, vcc, v1, v3
; GISEL-NEXT:    v_xor_b32_e32 v0, v0, v2
; GISEL-NEXT:    v_xor_b32_e32 v1, v1, v3
; GISEL-NEXT:    v_cvt_f32_u32_e32 v3, v1
; GISEL-NEXT:    v_sub_i32_e32 v4, vcc, 0, v1
; GISEL-NEXT:    v_rcp_iflag_f32_e32 v3, v3
; GISEL-NEXT:    v_mul_f32_e32 v3, 0x4f7ffffe, v3
; GISEL-NEXT:    v_cvt_u32_f32_e32 v3, v3
; GISEL-NEXT:    v_mul_lo_u32 v4, v4, v3
; GISEL-NEXT:    v_mul_hi_u32 v4, v3, v4
; GISEL-NEXT:    v_add_i32_e32 v3, vcc, v3, v4
; GISEL-NEXT:    v_mul_hi_u32 v3, v0, v3
; GISEL-NEXT:    v_mul_lo_u32 v3, v3, v1
; GISEL-NEXT:    v_sub_i32_e32 v0, vcc, v0, v3
; GISEL-NEXT:    v_sub_i32_e32 v3, vcc, v0, v1
; GISEL-NEXT:    v_cmp_ge_u32_e32 vcc, v0, v1
; GISEL-NEXT:    v_cndmask_b32_e32 v0, v0, v3, vcc
; GISEL-NEXT:    v_sub_i32_e32 v3, vcc, v0, v1
; GISEL-NEXT:    v_cmp_ge_u32_e32 vcc, v0, v1
; GISEL-NEXT:    v_cndmask_b32_e32 v0, v0, v3, vcc
; GISEL-NEXT:    v_xor_b32_e32 v0, v0, v2
; GISEL-NEXT:    v_sub_i32_e32 v0, vcc, v0, v2
; GISEL-NEXT:    s_setpc_b64 s[30:31]
;
; CGP-LABEL: v_srem_i32:
; CGP:       ; %bb.0:
; CGP-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CGP-NEXT:    v_ashrrev_i32_e32 v2, 31, v0
; CGP-NEXT:    v_ashrrev_i32_e32 v3, 31, v1
; CGP-NEXT:    v_add_i32_e32 v0, vcc, v0, v2
; CGP-NEXT:    v_add_i32_e32 v1, vcc, v1, v3
; CGP-NEXT:    v_xor_b32_e32 v0, v0, v2
; CGP-NEXT:    v_xor_b32_e32 v1, v1, v3
; CGP-NEXT:    v_cvt_f32_u32_e32 v3, v1
; CGP-NEXT:    v_sub_i32_e32 v4, vcc, 0, v1
; CGP-NEXT:    v_rcp_f32_e32 v3, v3
; CGP-NEXT:    v_mul_f32_e32 v3, 0x4f7ffffe, v3
; CGP-NEXT:    v_cvt_u32_f32_e32 v3, v3
; CGP-NEXT:    v_mul_lo_u32 v4, v4, v3
; CGP-NEXT:    v_mul_hi_u32 v4, v3, v4
; CGP-NEXT:    v_add_i32_e32 v3, vcc, v3, v4
; CGP-NEXT:    v_mul_hi_u32 v3, v0, v3
; CGP-NEXT:    v_mul_lo_u32 v3, v3, v1
; CGP-NEXT:    v_sub_i32_e32 v0, vcc, v0, v3
; CGP-NEXT:    v_sub_i32_e32 v3, vcc, v0, v1
; CGP-NEXT:    v_cmp_ge_u32_e32 vcc, v0, v1
; CGP-NEXT:    v_cndmask_b32_e32 v0, v0, v3, vcc
; CGP-NEXT:    v_sub_i32_e32 v3, vcc, v0, v1
; CGP-NEXT:    v_cmp_ge_u32_e32 vcc, v0, v1
; CGP-NEXT:    v_cndmask_b32_e32 v0, v0, v3, vcc
; CGP-NEXT:    v_xor_b32_e32 v0, v0, v2
; CGP-NEXT:    v_sub_i32_e32 v0, vcc, v0, v2
; CGP-NEXT:    s_setpc_b64 s[30:31]
  %result = srem i32 %num, %den
  ret i32 %result
}

; FIXME: This is a workaround for not handling uniform VGPR case.
declare i32 @llvm.amdgcn.readfirstlane(i32)

define amdgpu_ps i32 @s_srem_i32(i32 inreg %num, i32 inreg %den) {
; GISEL-LABEL: s_srem_i32:
; GISEL:       ; %bb.0:
; GISEL-NEXT:    s_ashr_i32 s2, s0, 31
; GISEL-NEXT:    s_ashr_i32 s3, s1, 31
; GISEL-NEXT:    s_add_i32 s0, s0, s2
; GISEL-NEXT:    s_add_i32 s1, s1, s3
; GISEL-NEXT:    s_xor_b32 s0, s0, s2
; GISEL-NEXT:    s_xor_b32 s1, s1, s3
; GISEL-NEXT:    v_cvt_f32_u32_e32 v0, s1
; GISEL-NEXT:    s_sub_i32 s3, 0, s1
; GISEL-NEXT:    v_rcp_iflag_f32_e32 v0, v0
; GISEL-NEXT:    v_mul_f32_e32 v0, 0x4f7ffffe, v0
; GISEL-NEXT:    v_cvt_u32_f32_e32 v0, v0
; GISEL-NEXT:    v_mul_lo_u32 v1, s3, v0
; GISEL-NEXT:    v_mul_hi_u32 v1, v0, v1
; GISEL-NEXT:    v_add_i32_e32 v0, vcc, v0, v1
; GISEL-NEXT:    v_mul_hi_u32 v0, s0, v0
; GISEL-NEXT:    v_mul_lo_u32 v0, v0, s1
; GISEL-NEXT:    v_sub_i32_e32 v0, vcc, s0, v0
; GISEL-NEXT:    v_subrev_i32_e32 v1, vcc, s1, v0
; GISEL-NEXT:    v_cmp_le_u32_e32 vcc, s1, v0
; GISEL-NEXT:    v_cndmask_b32_e32 v0, v0, v1, vcc
; GISEL-NEXT:    v_subrev_i32_e32 v1, vcc, s1, v0
; GISEL-NEXT:    v_cmp_le_u32_e32 vcc, s1, v0
; GISEL-NEXT:    v_cndmask_b32_e32 v0, v0, v1, vcc
; GISEL-NEXT:    v_xor_b32_e32 v0, s2, v0
; GISEL-NEXT:    v_subrev_i32_e32 v0, vcc, s2, v0
; GISEL-NEXT:    v_readfirstlane_b32 s0, v0
; GISEL-NEXT:    ; return to shader part epilog
;
; CGP-LABEL: s_srem_i32:
; CGP:       ; %bb.0:
; CGP-NEXT:    s_ashr_i32 s2, s0, 31
; CGP-NEXT:    s_ashr_i32 s3, s1, 31
; CGP-NEXT:    s_add_i32 s0, s0, s2
; CGP-NEXT:    s_add_i32 s1, s1, s3
; CGP-NEXT:    s_xor_b32 s0, s0, s2
; CGP-NEXT:    s_xor_b32 s1, s1, s3
; CGP-NEXT:    v_cvt_f32_u32_e32 v0, s1
; CGP-NEXT:    s_sub_i32 s3, 0, s1
; CGP-NEXT:    v_rcp_f32_e32 v0, v0
; CGP-NEXT:    v_mul_f32_e32 v0, 0x4f7ffffe, v0
; CGP-NEXT:    v_cvt_u32_f32_e32 v0, v0
; CGP-NEXT:    v_mul_lo_u32 v1, s3, v0
; CGP-NEXT:    v_mul_hi_u32 v1, v0, v1
; CGP-NEXT:    v_add_i32_e32 v0, vcc, v0, v1
; CGP-NEXT:    v_mul_hi_u32 v0, s0, v0
; CGP-NEXT:    v_mul_lo_u32 v0, v0, s1
; CGP-NEXT:    v_sub_i32_e32 v0, vcc, s0, v0
; CGP-NEXT:    v_subrev_i32_e32 v1, vcc, s1, v0
; CGP-NEXT:    v_cmp_le_u32_e32 vcc, s1, v0
; CGP-NEXT:    v_cndmask_b32_e32 v0, v0, v1, vcc
; CGP-NEXT:    v_subrev_i32_e32 v1, vcc, s1, v0
; CGP-NEXT:    v_cmp_le_u32_e32 vcc, s1, v0
; CGP-NEXT:    v_cndmask_b32_e32 v0, v0, v1, vcc
; CGP-NEXT:    v_xor_b32_e32 v0, s2, v0
; CGP-NEXT:    v_subrev_i32_e32 v0, vcc, s2, v0
; CGP-NEXT:    v_readfirstlane_b32 s0, v0
; CGP-NEXT:    ; return to shader part epilog
  %result = srem i32 %num, %den
  %readlane = call i32 @llvm.amdgcn.readfirstlane(i32 %result)
  ret i32 %readlane
}

define <2 x i32> @v_srem_v2i32(<2 x i32> %num, <2 x i32> %den) {
; GISEL-LABEL: v_srem_v2i32:
; GISEL:       ; %bb.0:
; GISEL-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GISEL-NEXT:    v_ashrrev_i32_e32 v4, 31, v0
; GISEL-NEXT:    v_ashrrev_i32_e32 v5, 31, v2
; GISEL-NEXT:    v_ashrrev_i32_e32 v6, 31, v1
; GISEL-NEXT:    v_ashrrev_i32_e32 v7, 31, v3
; GISEL-NEXT:    v_add_i32_e32 v0, vcc, v0, v4
; GISEL-NEXT:    v_add_i32_e32 v2, vcc, v2, v5
; GISEL-NEXT:    v_add_i32_e32 v1, vcc, v1, v6
; GISEL-NEXT:    v_add_i32_e32 v3, vcc, v3, v7
; GISEL-NEXT:    v_xor_b32_e32 v0, v0, v4
; GISEL-NEXT:    v_xor_b32_e32 v2, v2, v5
; GISEL-NEXT:    v_xor_b32_e32 v1, v1, v6
; GISEL-NEXT:    v_xor_b32_e32 v3, v3, v7
; GISEL-NEXT:    v_cvt_f32_u32_e32 v5, v2
; GISEL-NEXT:    v_sub_i32_e32 v7, vcc, 0, v2
; GISEL-NEXT:    v_cvt_f32_u32_e32 v8, v3
; GISEL-NEXT:    v_sub_i32_e32 v9, vcc, 0, v3
; GISEL-NEXT:    v_rcp_iflag_f32_e32 v5, v5
; GISEL-NEXT:    v_rcp_iflag_f32_e32 v8, v8
; GISEL-NEXT:    v_mul_f32_e32 v5, 0x4f7ffffe, v5
; GISEL-NEXT:    v_mul_f32_e32 v8, 0x4f7ffffe, v8
; GISEL-NEXT:    v_cvt_u32_f32_e32 v5, v5
; GISEL-NEXT:    v_cvt_u32_f32_e32 v8, v8
; GISEL-NEXT:    v_mul_lo_u32 v7, v7, v5
; GISEL-NEXT:    v_mul_lo_u32 v9, v9, v8
; GISEL-NEXT:    v_mul_hi_u32 v7, v5, v7
; GISEL-NEXT:    v_mul_hi_u32 v9, v8, v9
; GISEL-NEXT:    v_add_i32_e32 v5, vcc, v5, v7
; GISEL-NEXT:    v_add_i32_e32 v7, vcc, v8, v9
; GISEL-NEXT:    v_mul_hi_u32 v5, v0, v5
; GISEL-NEXT:    v_mul_hi_u32 v7, v1, v7
; GISEL-NEXT:    v_mul_lo_u32 v5, v5, v2
; GISEL-NEXT:    v_mul_lo_u32 v7, v7, v3
; GISEL-NEXT:    v_sub_i32_e32 v0, vcc, v0, v5
; GISEL-NEXT:    v_sub_i32_e32 v1, vcc, v1, v7
; GISEL-NEXT:    v_sub_i32_e32 v5, vcc, v0, v2
; GISEL-NEXT:    v_sub_i32_e32 v7, vcc, v1, v3
; GISEL-NEXT:    v_cmp_ge_u32_e32 vcc, v0, v2
; GISEL-NEXT:    v_cndmask_b32_e32 v0, v0, v5, vcc
; GISEL-NEXT:    v_cmp_ge_u32_e32 vcc, v1, v3
; GISEL-NEXT:    v_cndmask_b32_e32 v1, v1, v7, vcc
; GISEL-NEXT:    v_sub_i32_e32 v5, vcc, v0, v2
; GISEL-NEXT:    v_sub_i32_e32 v7, vcc, v1, v3
; GISEL-NEXT:    v_cmp_ge_u32_e32 vcc, v0, v2
; GISEL-NEXT:    v_cndmask_b32_e32 v0, v0, v5, vcc
; GISEL-NEXT:    v_cmp_ge_u32_e32 vcc, v1, v3
; GISEL-NEXT:    v_cndmask_b32_e32 v1, v1, v7, vcc
; GISEL-NEXT:    v_xor_b32_e32 v0, v0, v4
; GISEL-NEXT:    v_xor_b32_e32 v1, v1, v6
; GISEL-NEXT:    v_sub_i32_e32 v0, vcc, v0, v4
; GISEL-NEXT:    v_sub_i32_e32 v1, vcc, v1, v6
; GISEL-NEXT:    s_setpc_b64 s[30:31]
;
; CGP-LABEL: v_srem_v2i32:
; CGP:       ; %bb.0:
; CGP-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CGP-NEXT:    v_ashrrev_i32_e32 v4, 31, v0
; CGP-NEXT:    v_ashrrev_i32_e32 v5, 31, v2
; CGP-NEXT:    v_ashrrev_i32_e32 v6, 31, v1
; CGP-NEXT:    v_ashrrev_i32_e32 v7, 31, v3
; CGP-NEXT:    v_add_i32_e32 v0, vcc, v0, v4
; CGP-NEXT:    v_add_i32_e32 v2, vcc, v2, v5
; CGP-NEXT:    v_add_i32_e32 v1, vcc, v1, v6
; CGP-NEXT:    v_add_i32_e32 v3, vcc, v3, v7
; CGP-NEXT:    v_xor_b32_e32 v0, v0, v4
; CGP-NEXT:    v_xor_b32_e32 v2, v2, v5
; CGP-NEXT:    v_xor_b32_e32 v1, v1, v6
; CGP-NEXT:    v_xor_b32_e32 v3, v3, v7
; CGP-NEXT:    v_cvt_f32_u32_e32 v5, v2
; CGP-NEXT:    v_sub_i32_e32 v7, vcc, 0, v2
; CGP-NEXT:    v_cvt_f32_u32_e32 v8, v3
; CGP-NEXT:    v_sub_i32_e32 v9, vcc, 0, v3
; CGP-NEXT:    v_rcp_f32_e32 v5, v5
; CGP-NEXT:    v_rcp_f32_e32 v8, v8
; CGP-NEXT:    v_mul_f32_e32 v5, 0x4f7ffffe, v5
; CGP-NEXT:    v_mul_f32_e32 v8, 0x4f7ffffe, v8
; CGP-NEXT:    v_cvt_u32_f32_e32 v5, v5
; CGP-NEXT:    v_cvt_u32_f32_e32 v8, v8
; CGP-NEXT:    v_mul_lo_u32 v7, v7, v5
; CGP-NEXT:    v_mul_lo_u32 v9, v9, v8
; CGP-NEXT:    v_mul_hi_u32 v7, v5, v7
; CGP-NEXT:    v_mul_hi_u32 v9, v8, v9
; CGP-NEXT:    v_add_i32_e32 v5, vcc, v5, v7
; CGP-NEXT:    v_add_i32_e32 v7, vcc, v8, v9
; CGP-NEXT:    v_mul_hi_u32 v5, v0, v5
; CGP-NEXT:    v_mul_hi_u32 v7, v1, v7
; CGP-NEXT:    v_mul_lo_u32 v5, v5, v2
; CGP-NEXT:    v_mul_lo_u32 v7, v7, v3
; CGP-NEXT:    v_sub_i32_e32 v0, vcc, v0, v5
; CGP-NEXT:    v_sub_i32_e32 v1, vcc, v1, v7
; CGP-NEXT:    v_sub_i32_e32 v5, vcc, v0, v2
; CGP-NEXT:    v_sub_i32_e32 v7, vcc, v1, v3
; CGP-NEXT:    v_cmp_ge_u32_e32 vcc, v0, v2
; CGP-NEXT:    v_cndmask_b32_e32 v0, v0, v5, vcc
; CGP-NEXT:    v_cmp_ge_u32_e32 vcc, v1, v3
; CGP-NEXT:    v_cndmask_b32_e32 v1, v1, v7, vcc
; CGP-NEXT:    v_sub_i32_e32 v5, vcc, v0, v2
; CGP-NEXT:    v_sub_i32_e32 v7, vcc, v1, v3
; CGP-NEXT:    v_cmp_ge_u32_e32 vcc, v0, v2
; CGP-NEXT:    v_cndmask_b32_e32 v0, v0, v5, vcc
; CGP-NEXT:    v_cmp_ge_u32_e32 vcc, v1, v3
; CGP-NEXT:    v_cndmask_b32_e32 v1, v1, v7, vcc
; CGP-NEXT:    v_xor_b32_e32 v0, v0, v4
; CGP-NEXT:    v_xor_b32_e32 v1, v1, v6
; CGP-NEXT:    v_sub_i32_e32 v0, vcc, v0, v4
; CGP-NEXT:    v_sub_i32_e32 v1, vcc, v1, v6
; CGP-NEXT:    s_setpc_b64 s[30:31]
  %result = srem <2 x i32> %num, %den
  ret <2 x i32> %result
}

define i32 @v_srem_i32_pow2k_denom(i32 %num) {
; CHECK-LABEL: v_srem_i32_pow2k_denom:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CHECK-NEXT:    s_movk_i32 s4, 0x1000
; CHECK-NEXT:    v_ashrrev_i32_e32 v1, 31, v0
; CHECK-NEXT:    v_rcp_iflag_f32_e32 v2, 0x45800000
; CHECK-NEXT:    v_mov_b32_e32 v3, 0xfffff000
; CHECK-NEXT:    v_add_i32_e32 v0, vcc, v0, v1
; CHECK-NEXT:    v_mul_f32_e32 v2, 0x4f7ffffe, v2
; CHECK-NEXT:    v_xor_b32_e32 v0, v0, v1
; CHECK-NEXT:    v_cvt_u32_f32_e32 v2, v2
; CHECK-NEXT:    v_mul_lo_u32 v3, v2, v3
; CHECK-NEXT:    v_mul_hi_u32 v3, v2, v3
; CHECK-NEXT:    v_add_i32_e32 v2, vcc, v2, v3
; CHECK-NEXT:    v_mul_hi_u32 v2, v0, v2
; CHECK-NEXT:    v_lshlrev_b32_e32 v2, 12, v2
; CHECK-NEXT:    v_sub_i32_e32 v0, vcc, v0, v2
; CHECK-NEXT:    v_subrev_i32_e32 v2, vcc, s4, v0
; CHECK-NEXT:    v_cmp_le_u32_e32 vcc, s4, v0
; CHECK-NEXT:    v_cndmask_b32_e32 v0, v0, v2, vcc
; CHECK-NEXT:    v_subrev_i32_e32 v2, vcc, s4, v0
; CHECK-NEXT:    v_cmp_le_u32_e32 vcc, s4, v0
; CHECK-NEXT:    v_cndmask_b32_e32 v0, v0, v2, vcc
; CHECK-NEXT:    v_xor_b32_e32 v0, v0, v1
; CHECK-NEXT:    v_sub_i32_e32 v0, vcc, v0, v1
; CHECK-NEXT:    s_setpc_b64 s[30:31]
  %result = srem i32 %num, 4096
  ret i32 %result
}

define <2 x i32> @v_srem_v2i32_pow2k_denom(<2 x i32> %num) {
; GISEL-LABEL: v_srem_v2i32_pow2k_denom:
; GISEL:       ; %bb.0:
; GISEL-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GISEL-NEXT:    v_ashrrev_i32_e32 v2, 31, v0
; GISEL-NEXT:    s_add_i32 s4, 0, 0x1000
; GISEL-NEXT:    v_ashrrev_i32_e32 v3, 31, v1
; GISEL-NEXT:    v_add_i32_e32 v0, vcc, v0, v2
; GISEL-NEXT:    v_cvt_f32_u32_e32 v4, s4
; GISEL-NEXT:    s_sub_i32 s5, 0, s4
; GISEL-NEXT:    v_add_i32_e32 v1, vcc, v1, v3
; GISEL-NEXT:    v_xor_b32_e32 v0, v0, v2
; GISEL-NEXT:    v_rcp_iflag_f32_e32 v4, v4
; GISEL-NEXT:    v_xor_b32_e32 v1, v1, v3
; GISEL-NEXT:    v_mul_f32_e32 v5, 0x4f7ffffe, v4
; GISEL-NEXT:    v_mul_f32_e32 v4, 0x4f7ffffe, v4
; GISEL-NEXT:    v_cvt_u32_f32_e32 v5, v5
; GISEL-NEXT:    v_cvt_u32_f32_e32 v4, v4
; GISEL-NEXT:    v_mul_lo_u32 v6, s5, v5
; GISEL-NEXT:    v_mul_lo_u32 v7, s5, v4
; GISEL-NEXT:    v_mul_hi_u32 v6, v5, v6
; GISEL-NEXT:    v_mul_hi_u32 v7, v4, v7
; GISEL-NEXT:    v_add_i32_e32 v5, vcc, v5, v6
; GISEL-NEXT:    v_add_i32_e32 v4, vcc, v4, v7
; GISEL-NEXT:    v_mul_hi_u32 v5, v0, v5
; GISEL-NEXT:    v_mul_hi_u32 v4, v1, v4
; GISEL-NEXT:    v_mul_lo_u32 v5, v5, s4
; GISEL-NEXT:    v_mul_lo_u32 v4, v4, s4
; GISEL-NEXT:    v_sub_i32_e32 v0, vcc, v0, v5
; GISEL-NEXT:    v_sub_i32_e32 v1, vcc, v1, v4
; GISEL-NEXT:    v_subrev_i32_e32 v4, vcc, s4, v0
; GISEL-NEXT:    v_subrev_i32_e32 v5, vcc, s4, v1
; GISEL-NEXT:    v_cmp_le_u32_e32 vcc, s4, v0
; GISEL-NEXT:    v_cndmask_b32_e32 v0, v0, v4, vcc
; GISEL-NEXT:    v_cmp_le_u32_e32 vcc, s4, v1
; GISEL-NEXT:    v_cndmask_b32_e32 v1, v1, v5, vcc
; GISEL-NEXT:    v_subrev_i32_e32 v4, vcc, s4, v0
; GISEL-NEXT:    v_subrev_i32_e32 v5, vcc, s4, v1
; GISEL-NEXT:    v_cmp_le_u32_e32 vcc, s4, v0
; GISEL-NEXT:    v_cndmask_b32_e32 v0, v0, v4, vcc
; GISEL-NEXT:    v_cmp_le_u32_e32 vcc, s4, v1
; GISEL-NEXT:    v_cndmask_b32_e32 v1, v1, v5, vcc
; GISEL-NEXT:    v_xor_b32_e32 v0, v0, v2
; GISEL-NEXT:    v_xor_b32_e32 v1, v1, v3
; GISEL-NEXT:    v_sub_i32_e32 v0, vcc, v0, v2
; GISEL-NEXT:    v_sub_i32_e32 v1, vcc, v1, v3
; GISEL-NEXT:    s_setpc_b64 s[30:31]
;
; CGP-LABEL: v_srem_v2i32_pow2k_denom:
; CGP:       ; %bb.0:
; CGP-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CGP-NEXT:    s_movk_i32 s4, 0x1000
; CGP-NEXT:    v_ashrrev_i32_e32 v2, 31, v0
; CGP-NEXT:    v_rcp_iflag_f32_e32 v3, 0x45800000
; CGP-NEXT:    s_movk_i32 s5, 0xf000
; CGP-NEXT:    v_mov_b32_e32 v4, 0xfffff000
; CGP-NEXT:    v_mov_b32_e32 v5, 0x1000
; CGP-NEXT:    v_ashrrev_i32_e32 v6, 31, v1
; CGP-NEXT:    v_rcp_iflag_f32_e32 v7, 0x45800000
; CGP-NEXT:    v_add_i32_e32 v0, vcc, v0, v2
; CGP-NEXT:    v_mul_f32_e32 v3, 0x4f7ffffe, v3
; CGP-NEXT:    v_add_i32_e32 v1, vcc, v1, v6
; CGP-NEXT:    v_mul_f32_e32 v7, 0x4f7ffffe, v7
; CGP-NEXT:    v_xor_b32_e32 v0, v0, v2
; CGP-NEXT:    v_cvt_u32_f32_e32 v3, v3
; CGP-NEXT:    v_xor_b32_e32 v1, v1, v6
; CGP-NEXT:    v_cvt_u32_f32_e32 v7, v7
; CGP-NEXT:    v_mul_lo_u32 v8, v3, s5
; CGP-NEXT:    v_mul_lo_u32 v4, v7, v4
; CGP-NEXT:    v_mul_hi_u32 v8, v3, v8
; CGP-NEXT:    v_mul_hi_u32 v4, v7, v4
; CGP-NEXT:    v_add_i32_e32 v3, vcc, v3, v8
; CGP-NEXT:    v_add_i32_e32 v4, vcc, v7, v4
; CGP-NEXT:    v_mul_hi_u32 v3, v0, v3
; CGP-NEXT:    v_mul_hi_u32 v4, v1, v4
; CGP-NEXT:    v_lshlrev_b32_e32 v3, 12, v3
; CGP-NEXT:    v_lshlrev_b32_e32 v4, 12, v4
; CGP-NEXT:    v_sub_i32_e32 v0, vcc, v0, v3
; CGP-NEXT:    v_sub_i32_e32 v1, vcc, v1, v4
; CGP-NEXT:    v_subrev_i32_e32 v3, vcc, s4, v0
; CGP-NEXT:    v_subrev_i32_e32 v4, vcc, 0x1000, v1
; CGP-NEXT:    v_cmp_le_u32_e32 vcc, s4, v0
; CGP-NEXT:    v_cndmask_b32_e32 v0, v0, v3, vcc
; CGP-NEXT:    v_cmp_ge_u32_e32 vcc, v1, v5
; CGP-NEXT:    v_cndmask_b32_e32 v1, v1, v4, vcc
; CGP-NEXT:    v_subrev_i32_e32 v3, vcc, s4, v0
; CGP-NEXT:    v_subrev_i32_e32 v4, vcc, 0x1000, v1
; CGP-NEXT:    v_cmp_le_u32_e32 vcc, s4, v0
; CGP-NEXT:    v_cndmask_b32_e32 v0, v0, v3, vcc
; CGP-NEXT:    v_cmp_ge_u32_e32 vcc, v1, v5
; CGP-NEXT:    v_cndmask_b32_e32 v1, v1, v4, vcc
; CGP-NEXT:    v_xor_b32_e32 v0, v0, v2
; CGP-NEXT:    v_xor_b32_e32 v1, v1, v6
; CGP-NEXT:    v_sub_i32_e32 v0, vcc, v0, v2
; CGP-NEXT:    v_sub_i32_e32 v1, vcc, v1, v6
; CGP-NEXT:    s_setpc_b64 s[30:31]
  %result = srem <2 x i32> %num, <i32 4096, i32 4096>
  ret <2 x i32> %result
}

define i32 @v_srem_i32_oddk_denom(i32 %num) {
; CHECK-LABEL: v_srem_i32_oddk_denom:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CHECK-NEXT:    s_mov_b32 s4, 0x12d8fb
; CHECK-NEXT:    v_ashrrev_i32_e32 v1, 31, v0
; CHECK-NEXT:    v_rcp_iflag_f32_e32 v2, 0x4996c7d8
; CHECK-NEXT:    v_mov_b32_e32 v3, 0xffed2705
; CHECK-NEXT:    v_add_i32_e32 v0, vcc, v0, v1
; CHECK-NEXT:    v_mul_f32_e32 v2, 0x4f7ffffe, v2
; CHECK-NEXT:    v_xor_b32_e32 v0, v0, v1
; CHECK-NEXT:    v_cvt_u32_f32_e32 v2, v2
; CHECK-NEXT:    v_mul_lo_u32 v3, v2, v3
; CHECK-NEXT:    v_mul_hi_u32 v3, v2, v3
; CHECK-NEXT:    v_add_i32_e32 v2, vcc, v2, v3
; CHECK-NEXT:    v_mul_hi_u32 v2, v0, v2
; CHECK-NEXT:    v_mul_lo_u32 v2, v2, s4
; CHECK-NEXT:    v_sub_i32_e32 v0, vcc, v0, v2
; CHECK-NEXT:    v_subrev_i32_e32 v2, vcc, s4, v0
; CHECK-NEXT:    v_cmp_le_u32_e32 vcc, s4, v0
; CHECK-NEXT:    v_cndmask_b32_e32 v0, v0, v2, vcc
; CHECK-NEXT:    v_subrev_i32_e32 v2, vcc, s4, v0
; CHECK-NEXT:    v_cmp_le_u32_e32 vcc, s4, v0
; CHECK-NEXT:    v_cndmask_b32_e32 v0, v0, v2, vcc
; CHECK-NEXT:    v_xor_b32_e32 v0, v0, v1
; CHECK-NEXT:    v_sub_i32_e32 v0, vcc, v0, v1
; CHECK-NEXT:    s_setpc_b64 s[30:31]
  %result = srem i32 %num, 1235195
  ret i32 %result
}

define <2 x i32> @v_srem_v2i32_oddk_denom(<2 x i32> %num) {
; GISEL-LABEL: v_srem_v2i32_oddk_denom:
; GISEL:       ; %bb.0:
; GISEL-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GISEL-NEXT:    v_ashrrev_i32_e32 v2, 31, v0
; GISEL-NEXT:    s_add_i32 s4, 0, 0x12d8fb
; GISEL-NEXT:    v_ashrrev_i32_e32 v3, 31, v1
; GISEL-NEXT:    v_add_i32_e32 v0, vcc, v0, v2
; GISEL-NEXT:    v_cvt_f32_u32_e32 v4, s4
; GISEL-NEXT:    s_sub_i32 s5, 0, s4
; GISEL-NEXT:    v_add_i32_e32 v1, vcc, v1, v3
; GISEL-NEXT:    v_xor_b32_e32 v0, v0, v2
; GISEL-NEXT:    v_rcp_iflag_f32_e32 v4, v4
; GISEL-NEXT:    v_xor_b32_e32 v1, v1, v3
; GISEL-NEXT:    v_mul_f32_e32 v5, 0x4f7ffffe, v4
; GISEL-NEXT:    v_mul_f32_e32 v4, 0x4f7ffffe, v4
; GISEL-NEXT:    v_cvt_u32_f32_e32 v5, v5
; GISEL-NEXT:    v_cvt_u32_f32_e32 v4, v4
; GISEL-NEXT:    v_mul_lo_u32 v6, s5, v5
; GISEL-NEXT:    v_mul_lo_u32 v7, s5, v4
; GISEL-NEXT:    v_mul_hi_u32 v6, v5, v6
; GISEL-NEXT:    v_mul_hi_u32 v7, v4, v7
; GISEL-NEXT:    v_add_i32_e32 v5, vcc, v5, v6
; GISEL-NEXT:    v_add_i32_e32 v4, vcc, v4, v7
; GISEL-NEXT:    v_mul_hi_u32 v5, v0, v5
; GISEL-NEXT:    v_mul_hi_u32 v4, v1, v4
; GISEL-NEXT:    v_mul_lo_u32 v5, v5, s4
; GISEL-NEXT:    v_mul_lo_u32 v4, v4, s4
; GISEL-NEXT:    v_sub_i32_e32 v0, vcc, v0, v5
; GISEL-NEXT:    v_sub_i32_e32 v1, vcc, v1, v4
; GISEL-NEXT:    v_subrev_i32_e32 v4, vcc, s4, v0
; GISEL-NEXT:    v_subrev_i32_e32 v5, vcc, s4, v1
; GISEL-NEXT:    v_cmp_le_u32_e32 vcc, s4, v0
; GISEL-NEXT:    v_cndmask_b32_e32 v0, v0, v4, vcc
; GISEL-NEXT:    v_cmp_le_u32_e32 vcc, s4, v1
; GISEL-NEXT:    v_cndmask_b32_e32 v1, v1, v5, vcc
; GISEL-NEXT:    v_subrev_i32_e32 v4, vcc, s4, v0
; GISEL-NEXT:    v_subrev_i32_e32 v5, vcc, s4, v1
; GISEL-NEXT:    v_cmp_le_u32_e32 vcc, s4, v0
; GISEL-NEXT:    v_cndmask_b32_e32 v0, v0, v4, vcc
; GISEL-NEXT:    v_cmp_le_u32_e32 vcc, s4, v1
; GISEL-NEXT:    v_cndmask_b32_e32 v1, v1, v5, vcc
; GISEL-NEXT:    v_xor_b32_e32 v0, v0, v2
; GISEL-NEXT:    v_xor_b32_e32 v1, v1, v3
; GISEL-NEXT:    v_sub_i32_e32 v0, vcc, v0, v2
; GISEL-NEXT:    v_sub_i32_e32 v1, vcc, v1, v3
; GISEL-NEXT:    s_setpc_b64 s[30:31]
;
; CGP-LABEL: v_srem_v2i32_oddk_denom:
; CGP:       ; %bb.0:
; CGP-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CGP-NEXT:    s_mov_b32 s4, 0x12d8fb
; CGP-NEXT:    v_ashrrev_i32_e32 v2, 31, v0
; CGP-NEXT:    v_rcp_iflag_f32_e32 v3, 0x4996c7d8
; CGP-NEXT:    s_mov_b32 s5, 0xffed2705
; CGP-NEXT:    v_mov_b32_e32 v4, 0xffed2705
; CGP-NEXT:    v_mov_b32_e32 v5, 0x12d8fb
; CGP-NEXT:    v_ashrrev_i32_e32 v6, 31, v1
; CGP-NEXT:    v_rcp_iflag_f32_e32 v7, 0x4996c7d8
; CGP-NEXT:    v_add_i32_e32 v0, vcc, v0, v2
; CGP-NEXT:    v_mul_f32_e32 v3, 0x4f7ffffe, v3
; CGP-NEXT:    v_add_i32_e32 v1, vcc, v1, v6
; CGP-NEXT:    v_mul_f32_e32 v7, 0x4f7ffffe, v7
; CGP-NEXT:    v_xor_b32_e32 v0, v0, v2
; CGP-NEXT:    v_cvt_u32_f32_e32 v3, v3
; CGP-NEXT:    v_xor_b32_e32 v1, v1, v6
; CGP-NEXT:    v_cvt_u32_f32_e32 v7, v7
; CGP-NEXT:    v_mul_lo_u32 v8, v3, s5
; CGP-NEXT:    v_mul_lo_u32 v4, v7, v4
; CGP-NEXT:    v_mul_hi_u32 v8, v3, v8
; CGP-NEXT:    v_mul_hi_u32 v4, v7, v4
; CGP-NEXT:    v_add_i32_e32 v3, vcc, v3, v8
; CGP-NEXT:    v_add_i32_e32 v4, vcc, v7, v4
; CGP-NEXT:    v_mul_hi_u32 v3, v0, v3
; CGP-NEXT:    v_mul_hi_u32 v4, v1, v4
; CGP-NEXT:    v_mul_lo_u32 v3, v3, s4
; CGP-NEXT:    v_mul_lo_u32 v4, v4, s4
; CGP-NEXT:    v_sub_i32_e32 v0, vcc, v0, v3
; CGP-NEXT:    v_sub_i32_e32 v1, vcc, v1, v4
; CGP-NEXT:    v_subrev_i32_e32 v3, vcc, s4, v0
; CGP-NEXT:    v_subrev_i32_e32 v4, vcc, 0x12d8fb, v1
; CGP-NEXT:    v_cmp_le_u32_e32 vcc, s4, v0
; CGP-NEXT:    v_cndmask_b32_e32 v0, v0, v3, vcc
; CGP-NEXT:    v_cmp_ge_u32_e32 vcc, v1, v5
; CGP-NEXT:    v_cndmask_b32_e32 v1, v1, v4, vcc
; CGP-NEXT:    v_subrev_i32_e32 v3, vcc, s4, v0
; CGP-NEXT:    v_subrev_i32_e32 v4, vcc, 0x12d8fb, v1
; CGP-NEXT:    v_cmp_le_u32_e32 vcc, s4, v0
; CGP-NEXT:    v_cndmask_b32_e32 v0, v0, v3, vcc
; CGP-NEXT:    v_cmp_ge_u32_e32 vcc, v1, v5
; CGP-NEXT:    v_cndmask_b32_e32 v1, v1, v4, vcc
; CGP-NEXT:    v_xor_b32_e32 v0, v0, v2
; CGP-NEXT:    v_xor_b32_e32 v1, v1, v6
; CGP-NEXT:    v_sub_i32_e32 v0, vcc, v0, v2
; CGP-NEXT:    v_sub_i32_e32 v1, vcc, v1, v6
; CGP-NEXT:    s_setpc_b64 s[30:31]
  %result = srem <2 x i32> %num, <i32 1235195, i32 1235195>
  ret <2 x i32> %result
}

define i32 @v_srem_i32_pow2_shl_denom(i32 %x, i32 %y) {
; CHECK-LABEL: v_srem_i32_pow2_shl_denom:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CHECK-NEXT:    v_lshl_b32_e32 v1, 0x1000, v1
; CHECK-NEXT:    v_ashrrev_i32_e32 v2, 31, v0
; CHECK-NEXT:    v_ashrrev_i32_e32 v3, 31, v1
; CHECK-NEXT:    v_add_i32_e32 v0, vcc, v0, v2
; CHECK-NEXT:    v_add_i32_e32 v1, vcc, v1, v3
; CHECK-NEXT:    v_xor_b32_e32 v0, v0, v2
; CHECK-NEXT:    v_xor_b32_e32 v1, v1, v3
; CHECK-NEXT:    v_cvt_f32_u32_e32 v3, v1
; CHECK-NEXT:    v_sub_i32_e32 v4, vcc, 0, v1
; CHECK-NEXT:    v_rcp_iflag_f32_e32 v3, v3
; CHECK-NEXT:    v_mul_f32_e32 v3, 0x4f7ffffe, v3
; CHECK-NEXT:    v_cvt_u32_f32_e32 v3, v3
; CHECK-NEXT:    v_mul_lo_u32 v4, v4, v3
; CHECK-NEXT:    v_mul_hi_u32 v4, v3, v4
; CHECK-NEXT:    v_add_i32_e32 v3, vcc, v3, v4
; CHECK-NEXT:    v_mul_hi_u32 v3, v0, v3
; CHECK-NEXT:    v_mul_lo_u32 v3, v3, v1
; CHECK-NEXT:    v_sub_i32_e32 v0, vcc, v0, v3
; CHECK-NEXT:    v_sub_i32_e32 v3, vcc, v0, v1
; CHECK-NEXT:    v_cmp_ge_u32_e32 vcc, v0, v1
; CHECK-NEXT:    v_cndmask_b32_e32 v0, v0, v3, vcc
; CHECK-NEXT:    v_sub_i32_e32 v3, vcc, v0, v1
; CHECK-NEXT:    v_cmp_ge_u32_e32 vcc, v0, v1
; CHECK-NEXT:    v_cndmask_b32_e32 v0, v0, v3, vcc
; CHECK-NEXT:    v_xor_b32_e32 v0, v0, v2
; CHECK-NEXT:    v_sub_i32_e32 v0, vcc, v0, v2
; CHECK-NEXT:    s_setpc_b64 s[30:31]
  %shl.y = shl i32 4096, %y
  %r = srem i32 %x, %shl.y
  ret i32 %r
}

define <2 x i32> @v_srem_v2i32_pow2_shl_denom(<2 x i32> %x, <2 x i32> %y) {
; GISEL-LABEL: v_srem_v2i32_pow2_shl_denom:
; GISEL:       ; %bb.0:
; GISEL-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GISEL-NEXT:    v_lshl_b32_e32 v2, 0x1000, v2
; GISEL-NEXT:    v_lshl_b32_e32 v3, 0x1000, v3
; GISEL-NEXT:    v_ashrrev_i32_e32 v4, 31, v0
; GISEL-NEXT:    v_ashrrev_i32_e32 v5, 31, v1
; GISEL-NEXT:    v_ashrrev_i32_e32 v6, 31, v2
; GISEL-NEXT:    v_add_i32_e32 v0, vcc, v0, v4
; GISEL-NEXT:    v_ashrrev_i32_e32 v7, 31, v3
; GISEL-NEXT:    v_add_i32_e32 v1, vcc, v1, v5
; GISEL-NEXT:    v_add_i32_e32 v2, vcc, v2, v6
; GISEL-NEXT:    v_xor_b32_e32 v0, v0, v4
; GISEL-NEXT:    v_add_i32_e32 v3, vcc, v3, v7
; GISEL-NEXT:    v_xor_b32_e32 v1, v1, v5
; GISEL-NEXT:    v_xor_b32_e32 v2, v2, v6
; GISEL-NEXT:    v_xor_b32_e32 v3, v3, v7
; GISEL-NEXT:    v_cvt_f32_u32_e32 v6, v2
; GISEL-NEXT:    v_sub_i32_e32 v7, vcc, 0, v2
; GISEL-NEXT:    v_cvt_f32_u32_e32 v8, v3
; GISEL-NEXT:    v_sub_i32_e32 v9, vcc, 0, v3
; GISEL-NEXT:    v_rcp_iflag_f32_e32 v6, v6
; GISEL-NEXT:    v_rcp_iflag_f32_e32 v8, v8
; GISEL-NEXT:    v_mul_f32_e32 v6, 0x4f7ffffe, v6
; GISEL-NEXT:    v_mul_f32_e32 v8, 0x4f7ffffe, v8
; GISEL-NEXT:    v_cvt_u32_f32_e32 v6, v6
; GISEL-NEXT:    v_cvt_u32_f32_e32 v8, v8
; GISEL-NEXT:    v_mul_lo_u32 v7, v7, v6
; GISEL-NEXT:    v_mul_lo_u32 v9, v9, v8
; GISEL-NEXT:    v_mul_hi_u32 v7, v6, v7
; GISEL-NEXT:    v_mul_hi_u32 v9, v8, v9
; GISEL-NEXT:    v_add_i32_e32 v6, vcc, v6, v7
; GISEL-NEXT:    v_add_i32_e32 v7, vcc, v8, v9
; GISEL-NEXT:    v_mul_hi_u32 v6, v0, v6
; GISEL-NEXT:    v_mul_hi_u32 v7, v1, v7
; GISEL-NEXT:    v_mul_lo_u32 v6, v6, v2
; GISEL-NEXT:    v_mul_lo_u32 v7, v7, v3
; GISEL-NEXT:    v_sub_i32_e32 v0, vcc, v0, v6
; GISEL-NEXT:    v_sub_i32_e32 v1, vcc, v1, v7
; GISEL-NEXT:    v_sub_i32_e32 v6, vcc, v0, v2
; GISEL-NEXT:    v_sub_i32_e32 v7, vcc, v1, v3
; GISEL-NEXT:    v_cmp_ge_u32_e32 vcc, v0, v2
; GISEL-NEXT:    v_cndmask_b32_e32 v0, v0, v6, vcc
; GISEL-NEXT:    v_cmp_ge_u32_e32 vcc, v1, v3
; GISEL-NEXT:    v_cndmask_b32_e32 v1, v1, v7, vcc
; GISEL-NEXT:    v_sub_i32_e32 v6, vcc, v0, v2
; GISEL-NEXT:    v_sub_i32_e32 v7, vcc, v1, v3
; GISEL-NEXT:    v_cmp_ge_u32_e32 vcc, v0, v2
; GISEL-NEXT:    v_cndmask_b32_e32 v0, v0, v6, vcc
; GISEL-NEXT:    v_cmp_ge_u32_e32 vcc, v1, v3
; GISEL-NEXT:    v_cndmask_b32_e32 v1, v1, v7, vcc
; GISEL-NEXT:    v_xor_b32_e32 v0, v0, v4
; GISEL-NEXT:    v_xor_b32_e32 v1, v1, v5
; GISEL-NEXT:    v_sub_i32_e32 v0, vcc, v0, v4
; GISEL-NEXT:    v_sub_i32_e32 v1, vcc, v1, v5
; GISEL-NEXT:    s_setpc_b64 s[30:31]
;
; CGP-LABEL: v_srem_v2i32_pow2_shl_denom:
; CGP:       ; %bb.0:
; CGP-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CGP-NEXT:    v_lshl_b32_e32 v2, 0x1000, v2
; CGP-NEXT:    v_lshl_b32_e32 v3, 0x1000, v3
; CGP-NEXT:    v_ashrrev_i32_e32 v4, 31, v0
; CGP-NEXT:    v_ashrrev_i32_e32 v5, 31, v1
; CGP-NEXT:    v_ashrrev_i32_e32 v6, 31, v2
; CGP-NEXT:    v_add_i32_e32 v0, vcc, v0, v4
; CGP-NEXT:    v_ashrrev_i32_e32 v7, 31, v3
; CGP-NEXT:    v_add_i32_e32 v1, vcc, v1, v5
; CGP-NEXT:    v_add_i32_e32 v2, vcc, v2, v6
; CGP-NEXT:    v_xor_b32_e32 v0, v0, v4
; CGP-NEXT:    v_add_i32_e32 v3, vcc, v3, v7
; CGP-NEXT:    v_xor_b32_e32 v1, v1, v5
; CGP-NEXT:    v_xor_b32_e32 v2, v2, v6
; CGP-NEXT:    v_xor_b32_e32 v3, v3, v7
; CGP-NEXT:    v_cvt_f32_u32_e32 v6, v2
; CGP-NEXT:    v_sub_i32_e32 v7, vcc, 0, v2
; CGP-NEXT:    v_cvt_f32_u32_e32 v8, v3
; CGP-NEXT:    v_sub_i32_e32 v9, vcc, 0, v3
; CGP-NEXT:    v_rcp_f32_e32 v6, v6
; CGP-NEXT:    v_rcp_f32_e32 v8, v8
; CGP-NEXT:    v_mul_f32_e32 v6, 0x4f7ffffe, v6
; CGP-NEXT:    v_mul_f32_e32 v8, 0x4f7ffffe, v8
; CGP-NEXT:    v_cvt_u32_f32_e32 v6, v6
; CGP-NEXT:    v_cvt_u32_f32_e32 v8, v8
; CGP-NEXT:    v_mul_lo_u32 v7, v7, v6
; CGP-NEXT:    v_mul_lo_u32 v9, v9, v8
; CGP-NEXT:    v_mul_hi_u32 v7, v6, v7
; CGP-NEXT:    v_mul_hi_u32 v9, v8, v9
; CGP-NEXT:    v_add_i32_e32 v6, vcc, v6, v7
; CGP-NEXT:    v_add_i32_e32 v7, vcc, v8, v9
; CGP-NEXT:    v_mul_hi_u32 v6, v0, v6
; CGP-NEXT:    v_mul_hi_u32 v7, v1, v7
; CGP-NEXT:    v_mul_lo_u32 v6, v6, v2
; CGP-NEXT:    v_mul_lo_u32 v7, v7, v3
; CGP-NEXT:    v_sub_i32_e32 v0, vcc, v0, v6
; CGP-NEXT:    v_sub_i32_e32 v1, vcc, v1, v7
; CGP-NEXT:    v_sub_i32_e32 v6, vcc, v0, v2
; CGP-NEXT:    v_sub_i32_e32 v7, vcc, v1, v3
; CGP-NEXT:    v_cmp_ge_u32_e32 vcc, v0, v2
; CGP-NEXT:    v_cndmask_b32_e32 v0, v0, v6, vcc
; CGP-NEXT:    v_cmp_ge_u32_e32 vcc, v1, v3
; CGP-NEXT:    v_cndmask_b32_e32 v1, v1, v7, vcc
; CGP-NEXT:    v_sub_i32_e32 v6, vcc, v0, v2
; CGP-NEXT:    v_sub_i32_e32 v7, vcc, v1, v3
; CGP-NEXT:    v_cmp_ge_u32_e32 vcc, v0, v2
; CGP-NEXT:    v_cndmask_b32_e32 v0, v0, v6, vcc
; CGP-NEXT:    v_cmp_ge_u32_e32 vcc, v1, v3
; CGP-NEXT:    v_cndmask_b32_e32 v1, v1, v7, vcc
; CGP-NEXT:    v_xor_b32_e32 v0, v0, v4
; CGP-NEXT:    v_xor_b32_e32 v1, v1, v5
; CGP-NEXT:    v_sub_i32_e32 v0, vcc, v0, v4
; CGP-NEXT:    v_sub_i32_e32 v1, vcc, v1, v5
; CGP-NEXT:    s_setpc_b64 s[30:31]
  %shl.y = shl <2 x i32> <i32 4096, i32 4096>, %y
  %r = srem <2 x i32> %x, %shl.y
  ret <2 x i32> %r
}

define i32 @v_srem_i32_24bit(i32 %num, i32 %den) {
; GISEL-LABEL: v_srem_i32_24bit:
; GISEL:       ; %bb.0:
; GISEL-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GISEL-NEXT:    v_and_b32_e32 v0, 0xffffff, v0
; GISEL-NEXT:    v_and_b32_e32 v1, 0xffffff, v1
; GISEL-NEXT:    v_ashrrev_i32_e32 v2, 31, v0
; GISEL-NEXT:    v_ashrrev_i32_e32 v3, 31, v1
; GISEL-NEXT:    v_add_i32_e32 v0, vcc, v0, v2
; GISEL-NEXT:    v_add_i32_e32 v1, vcc, v1, v3
; GISEL-NEXT:    v_xor_b32_e32 v0, v0, v2
; GISEL-NEXT:    v_xor_b32_e32 v1, v1, v3
; GISEL-NEXT:    v_cvt_f32_u32_e32 v3, v1
; GISEL-NEXT:    v_sub_i32_e32 v4, vcc, 0, v1
; GISEL-NEXT:    v_rcp_iflag_f32_e32 v3, v3
; GISEL-NEXT:    v_mul_f32_e32 v3, 0x4f7ffffe, v3
; GISEL-NEXT:    v_cvt_u32_f32_e32 v3, v3
; GISEL-NEXT:    v_mul_lo_u32 v4, v4, v3
; GISEL-NEXT:    v_mul_hi_u32 v4, v3, v4
; GISEL-NEXT:    v_add_i32_e32 v3, vcc, v3, v4
; GISEL-NEXT:    v_mul_hi_u32 v3, v0, v3
; GISEL-NEXT:    v_mul_lo_u32 v3, v3, v1
; GISEL-NEXT:    v_sub_i32_e32 v0, vcc, v0, v3
; GISEL-NEXT:    v_sub_i32_e32 v3, vcc, v0, v1
; GISEL-NEXT:    v_cmp_ge_u32_e32 vcc, v0, v1
; GISEL-NEXT:    v_cndmask_b32_e32 v0, v0, v3, vcc
; GISEL-NEXT:    v_sub_i32_e32 v3, vcc, v0, v1
; GISEL-NEXT:    v_cmp_ge_u32_e32 vcc, v0, v1
; GISEL-NEXT:    v_cndmask_b32_e32 v0, v0, v3, vcc
; GISEL-NEXT:    v_xor_b32_e32 v0, v0, v2
; GISEL-NEXT:    v_sub_i32_e32 v0, vcc, v0, v2
; GISEL-NEXT:    s_setpc_b64 s[30:31]
;
; CGP-LABEL: v_srem_i32_24bit:
; CGP:       ; %bb.0:
; CGP-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CGP-NEXT:    v_and_b32_e32 v0, 0xffffff, v0
; CGP-NEXT:    v_and_b32_e32 v1, 0xffffff, v1
; CGP-NEXT:    v_cvt_f32_u32_e32 v2, v1
; CGP-NEXT:    v_sub_i32_e32 v3, vcc, 0, v1
; CGP-NEXT:    v_rcp_f32_e32 v2, v2
; CGP-NEXT:    v_mul_f32_e32 v2, 0x4f7ffffe, v2
; CGP-NEXT:    v_cvt_u32_f32_e32 v2, v2
; CGP-NEXT:    v_mul_lo_u32 v3, v3, v2
; CGP-NEXT:    v_mul_hi_u32 v3, v2, v3
; CGP-NEXT:    v_add_i32_e32 v2, vcc, v2, v3
; CGP-NEXT:    v_mul_hi_u32 v2, v0, v2
; CGP-NEXT:    v_mul_lo_u32 v2, v2, v1
; CGP-NEXT:    v_sub_i32_e32 v0, vcc, v0, v2
; CGP-NEXT:    v_sub_i32_e32 v2, vcc, v0, v1
; CGP-NEXT:    v_cmp_ge_u32_e32 vcc, v0, v1
; CGP-NEXT:    v_cndmask_b32_e32 v0, v0, v2, vcc
; CGP-NEXT:    v_sub_i32_e32 v2, vcc, v0, v1
; CGP-NEXT:    v_cmp_ge_u32_e32 vcc, v0, v1
; CGP-NEXT:    v_cndmask_b32_e32 v0, v0, v2, vcc
; CGP-NEXT:    s_setpc_b64 s[30:31]
  %num.mask = and i32 %num, 16777215
  %den.mask = and i32 %den, 16777215
  %result = srem i32 %num.mask, %den.mask
  ret i32 %result
}

define <2 x i32> @v_srem_v2i32_24bit(<2 x i32> %num, <2 x i32> %den) {
; GISEL-LABEL: v_srem_v2i32_24bit:
; GISEL:       ; %bb.0:
; GISEL-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GISEL-NEXT:    v_and_b32_e32 v0, 0xffffff, v0
; GISEL-NEXT:    v_and_b32_e32 v1, 0xffffff, v1
; GISEL-NEXT:    v_and_b32_e32 v2, 0xffffff, v2
; GISEL-NEXT:    v_and_b32_e32 v3, 0xffffff, v3
; GISEL-NEXT:    v_ashrrev_i32_e32 v4, 31, v0
; GISEL-NEXT:    v_ashrrev_i32_e32 v5, 31, v2
; GISEL-NEXT:    v_ashrrev_i32_e32 v6, 31, v1
; GISEL-NEXT:    v_ashrrev_i32_e32 v7, 31, v3
; GISEL-NEXT:    v_add_i32_e32 v0, vcc, v0, v4
; GISEL-NEXT:    v_add_i32_e32 v2, vcc, v2, v5
; GISEL-NEXT:    v_add_i32_e32 v1, vcc, v1, v6
; GISEL-NEXT:    v_add_i32_e32 v3, vcc, v3, v7
; GISEL-NEXT:    v_xor_b32_e32 v0, v0, v4
; GISEL-NEXT:    v_xor_b32_e32 v2, v2, v5
; GISEL-NEXT:    v_xor_b32_e32 v1, v1, v6
; GISEL-NEXT:    v_xor_b32_e32 v3, v3, v7
; GISEL-NEXT:    v_cvt_f32_u32_e32 v5, v2
; GISEL-NEXT:    v_sub_i32_e32 v7, vcc, 0, v2
; GISEL-NEXT:    v_cvt_f32_u32_e32 v8, v3
; GISEL-NEXT:    v_sub_i32_e32 v9, vcc, 0, v3
; GISEL-NEXT:    v_rcp_iflag_f32_e32 v5, v5
; GISEL-NEXT:    v_rcp_iflag_f32_e32 v8, v8
; GISEL-NEXT:    v_mul_f32_e32 v5, 0x4f7ffffe, v5
; GISEL-NEXT:    v_mul_f32_e32 v8, 0x4f7ffffe, v8
; GISEL-NEXT:    v_cvt_u32_f32_e32 v5, v5
; GISEL-NEXT:    v_cvt_u32_f32_e32 v8, v8
; GISEL-NEXT:    v_mul_lo_u32 v7, v7, v5
; GISEL-NEXT:    v_mul_lo_u32 v9, v9, v8
; GISEL-NEXT:    v_mul_hi_u32 v7, v5, v7
; GISEL-NEXT:    v_mul_hi_u32 v9, v8, v9
; GISEL-NEXT:    v_add_i32_e32 v5, vcc, v5, v7
; GISEL-NEXT:    v_add_i32_e32 v7, vcc, v8, v9
; GISEL-NEXT:    v_mul_hi_u32 v5, v0, v5
; GISEL-NEXT:    v_mul_hi_u32 v7, v1, v7
; GISEL-NEXT:    v_mul_lo_u32 v5, v5, v2
; GISEL-NEXT:    v_mul_lo_u32 v7, v7, v3
; GISEL-NEXT:    v_sub_i32_e32 v0, vcc, v0, v5
; GISEL-NEXT:    v_sub_i32_e32 v1, vcc, v1, v7
; GISEL-NEXT:    v_sub_i32_e32 v5, vcc, v0, v2
; GISEL-NEXT:    v_sub_i32_e32 v7, vcc, v1, v3
; GISEL-NEXT:    v_cmp_ge_u32_e32 vcc, v0, v2
; GISEL-NEXT:    v_cndmask_b32_e32 v0, v0, v5, vcc
; GISEL-NEXT:    v_cmp_ge_u32_e32 vcc, v1, v3
; GISEL-NEXT:    v_cndmask_b32_e32 v1, v1, v7, vcc
; GISEL-NEXT:    v_sub_i32_e32 v5, vcc, v0, v2
; GISEL-NEXT:    v_sub_i32_e32 v7, vcc, v1, v3
; GISEL-NEXT:    v_cmp_ge_u32_e32 vcc, v0, v2
; GISEL-NEXT:    v_cndmask_b32_e32 v0, v0, v5, vcc
; GISEL-NEXT:    v_cmp_ge_u32_e32 vcc, v1, v3
; GISEL-NEXT:    v_cndmask_b32_e32 v1, v1, v7, vcc
; GISEL-NEXT:    v_xor_b32_e32 v0, v0, v4
; GISEL-NEXT:    v_xor_b32_e32 v1, v1, v6
; GISEL-NEXT:    v_sub_i32_e32 v0, vcc, v0, v4
; GISEL-NEXT:    v_sub_i32_e32 v1, vcc, v1, v6
; GISEL-NEXT:    s_setpc_b64 s[30:31]
;
; CGP-LABEL: v_srem_v2i32_24bit:
; CGP:       ; %bb.0:
; CGP-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CGP-NEXT:    v_and_b32_e32 v0, 0xffffff, v0
; CGP-NEXT:    v_and_b32_e32 v1, 0xffffff, v1
; CGP-NEXT:    v_and_b32_e32 v2, 0xffffff, v2
; CGP-NEXT:    v_and_b32_e32 v3, 0xffffff, v3
; CGP-NEXT:    v_cvt_f32_u32_e32 v4, v2
; CGP-NEXT:    v_sub_i32_e32 v5, vcc, 0, v2
; CGP-NEXT:    v_cvt_f32_u32_e32 v6, v3
; CGP-NEXT:    v_sub_i32_e32 v7, vcc, 0, v3
; CGP-NEXT:    v_rcp_f32_e32 v4, v4
; CGP-NEXT:    v_rcp_f32_e32 v6, v6
; CGP-NEXT:    v_mul_f32_e32 v4, 0x4f7ffffe, v4
; CGP-NEXT:    v_mul_f32_e32 v6, 0x4f7ffffe, v6
; CGP-NEXT:    v_cvt_u32_f32_e32 v4, v4
; CGP-NEXT:    v_cvt_u32_f32_e32 v6, v6
; CGP-NEXT:    v_mul_lo_u32 v5, v5, v4
; CGP-NEXT:    v_mul_lo_u32 v7, v7, v6
; CGP-NEXT:    v_mul_hi_u32 v5, v4, v5
; CGP-NEXT:    v_mul_hi_u32 v7, v6, v7
; CGP-NEXT:    v_add_i32_e32 v4, vcc, v4, v5
; CGP-NEXT:    v_add_i32_e32 v5, vcc, v6, v7
; CGP-NEXT:    v_mul_hi_u32 v4, v0, v4
; CGP-NEXT:    v_mul_hi_u32 v5, v1, v5
; CGP-NEXT:    v_mul_lo_u32 v4, v4, v2
; CGP-NEXT:    v_mul_lo_u32 v5, v5, v3
; CGP-NEXT:    v_sub_i32_e32 v0, vcc, v0, v4
; CGP-NEXT:    v_sub_i32_e32 v1, vcc, v1, v5
; CGP-NEXT:    v_sub_i32_e32 v4, vcc, v0, v2
; CGP-NEXT:    v_sub_i32_e32 v5, vcc, v1, v3
; CGP-NEXT:    v_cmp_ge_u32_e32 vcc, v0, v2
; CGP-NEXT:    v_cndmask_b32_e32 v0, v0, v4, vcc
; CGP-NEXT:    v_cmp_ge_u32_e32 vcc, v1, v3
; CGP-NEXT:    v_cndmask_b32_e32 v1, v1, v5, vcc
; CGP-NEXT:    v_sub_i32_e32 v4, vcc, v0, v2
; CGP-NEXT:    v_sub_i32_e32 v5, vcc, v1, v3
; CGP-NEXT:    v_cmp_ge_u32_e32 vcc, v0, v2
; CGP-NEXT:    v_cndmask_b32_e32 v0, v0, v4, vcc
; CGP-NEXT:    v_cmp_ge_u32_e32 vcc, v1, v3
; CGP-NEXT:    v_cndmask_b32_e32 v1, v1, v5, vcc
; CGP-NEXT:    s_setpc_b64 s[30:31]
  %num.mask = and <2 x i32> %num, <i32 16777215, i32 16777215>
  %den.mask = and <2 x i32> %den, <i32 16777215, i32 16777215>
  %result = srem <2 x i32> %num.mask, %den.mask
  ret <2 x i32> %result
}
