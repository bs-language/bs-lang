; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel=0 -march=amdgcn -mcpu=gfx900 < %s | FileCheck %s -check-prefixes=GFX9,GFX9-SDAG
; RUN: llc -global-isel=1 -march=amdgcn -mcpu=gfx900 < %s | FileCheck %s -check-prefixes=GFX9,GFX9-GISEL
; RUN: llc -global-isel=0 -march=amdgcn -mcpu=gfx1010 < %s | FileCheck %s -check-prefixes=GFX10,GFX10-SDAG
; RUN: llc -global-isel=1 -march=amdgcn -mcpu=gfx1010 < %s | FileCheck %s -check-prefixes=GFX10,GFX10-GISEL

declare half @llvm.fma.f16(half, half, half)
declare half @llvm.maxnum.f16(half, half)

define half @test_fma(half %x, half %y, half %z) {
; GFX9-LABEL: test_fma:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_fma_f16 v0, v0, v1, v2
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: test_fma:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_fma_f16 v0, v0, v1, v2
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %r = call half @llvm.fma.f16(half %x, half %y, half %z)
  ret half %r
}

; GFX10+ has v_fmac_f16.
define half @test_fmac(half %x, half %y, half %z) {
; GFX9-LABEL: test_fmac:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_fma_f16 v0, v1, v2, v0
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: test_fmac:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_fmac_f16_e32 v0, v1, v2
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %r = call half @llvm.fma.f16(half %y, half %z, half %x)
  ret half %r
}

; GFX10+ has v_fmaak_f16.
define half @test_fmaak(half %x, half %y, half %z) {
; GFX9-SDAG-LABEL: test_fmaak:
; GFX9-SDAG:       ; %bb.0:
; GFX9-SDAG-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-SDAG-NEXT:    s_movk_i32 s4, 0x4200
; GFX9-SDAG-NEXT:    v_fma_f16 v0, v0, v1, s4
; GFX9-SDAG-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-GISEL-LABEL: test_fmaak:
; GFX9-GISEL:       ; %bb.0:
; GFX9-GISEL-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-GISEL-NEXT:    v_mov_b32_e32 v2, 0x4200
; GFX9-GISEL-NEXT:    v_fma_f16 v0, v0, v1, v2
; GFX9-GISEL-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: test_fmaak:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_fmaak_f16 v0, v0, v1, 0x4200
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %r = call half @llvm.fma.f16(half %x, half %y, half 0xH4200)
  ret half %r
}

; GFX10+ has v_fmamk_f16.
define half @test_fmamk(half %x, half %y, half %z) {
; GFX9-SDAG-LABEL: test_fmamk:
; GFX9-SDAG:       ; %bb.0:
; GFX9-SDAG-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-SDAG-NEXT:    s_movk_i32 s4, 0x4200
; GFX9-SDAG-NEXT:    v_fma_f16 v0, v0, s4, v2
; GFX9-SDAG-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-GISEL-LABEL: test_fmamk:
; GFX9-GISEL:       ; %bb.0:
; GFX9-GISEL-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-GISEL-NEXT:    v_mov_b32_e32 v1, 0x4200
; GFX9-GISEL-NEXT:    v_fma_f16 v0, v0, v1, v2
; GFX9-GISEL-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: test_fmamk:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_fmamk_f16 v0, v0, 0x4200, v2
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %r = call half @llvm.fma.f16(half %x, half 0xH4200, half %z)
  ret half %r
}

; Regression test for a crash caused by D139469.
define i32 @test_D139469_f16(half %arg) {
; GFX9-LABEL: test_D139469_f16:
; GFX9:       ; %bb.0: ; %bb
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mul_f16_e32 v1, 0x291e, v0
; GFX9-NEXT:    s_movk_i32 s4, 0x291e
; GFX9-NEXT:    v_cmp_gt_f16_e32 vcc, 0, v1
; GFX9-NEXT:    v_mov_b32_e32 v1, 0x211e
; GFX9-NEXT:    v_fma_f16 v0, v0, s4, v1
; GFX9-NEXT:    v_cmp_gt_f16_e64 s[4:5], 0, v0
; GFX9-NEXT:    s_or_b64 s[4:5], vcc, s[4:5]
; GFX9-NEXT:    v_cndmask_b32_e64 v0, 0, 1, s[4:5]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-SDAG-LABEL: test_D139469_f16:
; GFX10-SDAG:       ; %bb.0: ; %bb
; GFX10-SDAG-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-SDAG-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-SDAG-NEXT:    v_mov_b32_e32 v1, 0x211e
; GFX10-SDAG-NEXT:    v_mul_f16_e32 v2, 0x291e, v0
; GFX10-SDAG-NEXT:    v_fmac_f16_e32 v1, 0x291e, v0
; GFX10-SDAG-NEXT:    v_cmp_gt_f16_e32 vcc_lo, 0, v2
; GFX10-SDAG-NEXT:    v_cmp_gt_f16_e64 s4, 0, v1
; GFX10-SDAG-NEXT:    s_or_b32 s4, vcc_lo, s4
; GFX10-SDAG-NEXT:    v_cndmask_b32_e64 v0, 0, 1, s4
; GFX10-SDAG-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-GISEL-LABEL: test_D139469_f16:
; GFX10-GISEL:       ; %bb.0: ; %bb
; GFX10-GISEL-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-GISEL-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-GISEL-NEXT:    s_movk_i32 s4, 0x291e
; GFX10-GISEL-NEXT:    v_mul_f16_e32 v1, 0x291e, v0
; GFX10-GISEL-NEXT:    v_fmaak_f16 v0, s4, v0, 0x211e
; GFX10-GISEL-NEXT:    v_cmp_gt_f16_e32 vcc_lo, 0, v1
; GFX10-GISEL-NEXT:    v_cmp_gt_f16_e64 s4, 0, v0
; GFX10-GISEL-NEXT:    s_or_b32 s4, vcc_lo, s4
; GFX10-GISEL-NEXT:    v_cndmask_b32_e64 v0, 0, 1, s4
; GFX10-GISEL-NEXT:    s_setpc_b64 s[30:31]
bb:
  %i = fmul contract half %arg, 0xH291E
  %i1 = fcmp olt half %i, 0xH0000
  %i2 = fadd contract half %i, 0xH211E
  %i3 = fcmp olt half %i2, 0xH0000
  %i4 = or i1 %i1, %i3
  %i5 = zext i1 %i4 to i32
  ret i32 %i5
}

define <2 x i32> @test_D139469_v2f16(<2 x half> %arg) {
; GFX9-SDAG-LABEL: test_D139469_v2f16:
; GFX9-SDAG:       ; %bb.0: ; %bb
; GFX9-SDAG-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-SDAG-NEXT:    s_movk_i32 s4, 0x291e
; GFX9-SDAG-NEXT:    v_pk_mul_f16 v1, v0, s4 op_sel_hi:[1,0]
; GFX9-SDAG-NEXT:    v_mov_b32_e32 v2, 0
; GFX9-SDAG-NEXT:    v_cmp_gt_f16_e32 vcc, 0, v1
; GFX9-SDAG-NEXT:    v_cmp_lt_f16_sdwa s[6:7], v1, v2 src0_sel:WORD_1 src1_sel:DWORD
; GFX9-SDAG-NEXT:    v_mov_b32_e32 v1, 0x211e
; GFX9-SDAG-NEXT:    v_pk_fma_f16 v0, v0, s4, v1 op_sel_hi:[1,0,0]
; GFX9-SDAG-NEXT:    v_cmp_gt_f16_e64 s[4:5], 0, v0
; GFX9-SDAG-NEXT:    v_cmp_lt_f16_sdwa s[8:9], v0, v2 src0_sel:WORD_1 src1_sel:DWORD
; GFX9-SDAG-NEXT:    s_or_b64 s[4:5], vcc, s[4:5]
; GFX9-SDAG-NEXT:    v_cndmask_b32_e64 v0, 0, 1, s[4:5]
; GFX9-SDAG-NEXT:    s_or_b64 s[4:5], s[6:7], s[8:9]
; GFX9-SDAG-NEXT:    v_cndmask_b32_e64 v1, 0, 1, s[4:5]
; GFX9-SDAG-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-GISEL-LABEL: test_D139469_v2f16:
; GFX9-GISEL:       ; %bb.0: ; %bb
; GFX9-GISEL-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-GISEL-NEXT:    s_mov_b32 s4, 0x291e291e
; GFX9-GISEL-NEXT:    s_mov_b32 s8, 0
; GFX9-GISEL-NEXT:    v_pk_mul_f16 v1, v0, s4
; GFX9-GISEL-NEXT:    v_cmp_gt_f16_e32 vcc, 0, v1
; GFX9-GISEL-NEXT:    v_cmp_lt_f16_sdwa s[6:7], v1, s8 src0_sel:WORD_1 src1_sel:DWORD
; GFX9-GISEL-NEXT:    v_mov_b32_e32 v1, 0x211e211e
; GFX9-GISEL-NEXT:    v_pk_fma_f16 v0, v0, s4, v1
; GFX9-GISEL-NEXT:    v_cmp_gt_f16_e64 s[4:5], 0, v0
; GFX9-GISEL-NEXT:    v_cmp_lt_f16_sdwa s[8:9], v0, s8 src0_sel:WORD_1 src1_sel:DWORD
; GFX9-GISEL-NEXT:    s_or_b64 s[4:5], vcc, s[4:5]
; GFX9-GISEL-NEXT:    v_cndmask_b32_e64 v0, 0, 1, s[4:5]
; GFX9-GISEL-NEXT:    s_or_b64 s[4:5], s[6:7], s[8:9]
; GFX9-GISEL-NEXT:    v_cndmask_b32_e64 v1, 0, 1, s[4:5]
; GFX9-GISEL-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-SDAG-LABEL: test_D139469_v2f16:
; GFX10-SDAG:       ; %bb.0: ; %bb
; GFX10-SDAG-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-SDAG-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-SDAG-NEXT:    s_movk_i32 s4, 0x211e
; GFX10-SDAG-NEXT:    v_pk_mul_f16 v1, 0x291e, v0 op_sel_hi:[0,1]
; GFX10-SDAG-NEXT:    v_pk_fma_f16 v0, 0x291e, v0, s4 op_sel_hi:[0,1,0]
; GFX10-SDAG-NEXT:    v_mov_b32_e32 v2, 0
; GFX10-SDAG-NEXT:    v_cmp_gt_f16_e32 vcc_lo, 0, v1
; GFX10-SDAG-NEXT:    v_cmp_gt_f16_e64 s4, 0, v0
; GFX10-SDAG-NEXT:    v_cmp_lt_f16_sdwa s5, v1, v2 src0_sel:WORD_1 src1_sel:DWORD
; GFX10-SDAG-NEXT:    v_cmp_lt_f16_sdwa s6, v0, v2 src0_sel:WORD_1 src1_sel:DWORD
; GFX10-SDAG-NEXT:    s_or_b32 s4, vcc_lo, s4
; GFX10-SDAG-NEXT:    v_cndmask_b32_e64 v0, 0, 1, s4
; GFX10-SDAG-NEXT:    s_or_b32 s4, s5, s6
; GFX10-SDAG-NEXT:    v_cndmask_b32_e64 v1, 0, 1, s4
; GFX10-SDAG-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-GISEL-LABEL: test_D139469_v2f16:
; GFX10-GISEL:       ; %bb.0: ; %bb
; GFX10-GISEL-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-GISEL-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-GISEL-NEXT:    s_mov_b32 s4, 0x291e291e
; GFX10-GISEL-NEXT:    v_pk_mul_f16 v1, v0, 0x291e op_sel_hi:[1,0]
; GFX10-GISEL-NEXT:    v_pk_fma_f16 v0, v0, s4, 0x211e op_sel_hi:[1,1,0]
; GFX10-GISEL-NEXT:    s_mov_b32 s5, 0
; GFX10-GISEL-NEXT:    v_cmp_gt_f16_e32 vcc_lo, 0, v1
; GFX10-GISEL-NEXT:    v_cmp_gt_f16_e64 s4, 0, v0
; GFX10-GISEL-NEXT:    v_cmp_lt_f16_sdwa s6, v1, s5 src0_sel:WORD_1 src1_sel:DWORD
; GFX10-GISEL-NEXT:    v_cmp_lt_f16_sdwa s5, v0, s5 src0_sel:WORD_1 src1_sel:DWORD
; GFX10-GISEL-NEXT:    s_or_b32 s4, vcc_lo, s4
; GFX10-GISEL-NEXT:    v_cndmask_b32_e64 v0, 0, 1, s4
; GFX10-GISEL-NEXT:    s_or_b32 s4, s6, s5
; GFX10-GISEL-NEXT:    v_cndmask_b32_e64 v1, 0, 1, s4
; GFX10-GISEL-NEXT:    s_setpc_b64 s[30:31]
bb:
  %i = fmul contract <2 x half> %arg, <half 0xH291E, half 0xH291E>
  %i1 = fcmp olt <2 x half> %i, <half 0xH0000, half 0xH0000>
  %i2 = fadd contract <2 x half> %i, <half 0xH211E, half 0xH211E>
  %i3 = fcmp olt <2 x half> %i2, <half 0xH0000, half 0xH0000>
  %i4 = or <2 x i1> %i1, %i3
  %i5 = zext <2 x i1> %i4 to <2 x i32>
  ret <2 x i32> %i5
}
