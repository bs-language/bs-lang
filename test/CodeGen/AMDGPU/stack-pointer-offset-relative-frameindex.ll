; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -march=amdgcn -mcpu=gfx1010 -verify-machineinstrs | FileCheck -check-prefix=MUBUF %s
; RUN: llc < %s -march=amdgcn -mcpu=gfx1010 -mattr=+enable-flat-scratch -verify-machineinstrs | FileCheck -check-prefix=FLATSCR %s
; RUN: llc < %s -march=amdgcn -mcpu=gfx1100 -amdgpu-enable-delay-alu=0 -verify-machineinstrs | FileCheck -check-prefix=MUBUF11 %s
; RUN: llc < %s -march=amdgcn -mcpu=gfx1100 -amdgpu-enable-delay-alu=0 -mattr=+enable-flat-scratch -verify-machineinstrs | FileCheck -check-prefix=FLATSCR11 %s

; During instruction selection, we use immediate const zero for soffset in
; MUBUF stack accesses and let eliminateFrameIndex to fix up this field to use
; the correct frame register whenever required.
define amdgpu_kernel void @kernel_background_evaluate(ptr addrspace(5) %kg, ptr addrspace(1) %input, ptr addrspace(1) %output, i32 %i) {
; MUBUF-LABEL: kernel_background_evaluate:
; MUBUF:       ; %bb.0: ; %entry
; MUBUF-NEXT:    s_load_dword s0, s[0:1], 0x24
; MUBUF-NEXT:    s_mov_b32 s36, SCRATCH_RSRC_DWORD0
; MUBUF-NEXT:    s_mov_b32 s37, SCRATCH_RSRC_DWORD1
; MUBUF-NEXT:    s_mov_b32 s38, -1
; MUBUF-NEXT:    s_mov_b32 s39, 0x31c16000
; MUBUF-NEXT:    s_add_u32 s36, s36, s3
; MUBUF-NEXT:    s_addc_u32 s37, s37, 0
; MUBUF-NEXT:    v_mov_b32_e32 v1, 0x2000
; MUBUF-NEXT:    v_mov_b32_e32 v2, 0x4000
; MUBUF-NEXT:    v_mov_b32_e32 v3, 0
; MUBUF-NEXT:    v_mov_b32_e32 v4, 0x400000
; MUBUF-NEXT:    s_mov_b32 s32, 0xc0000
; MUBUF-NEXT:    s_getpc_b64 s[4:5]
; MUBUF-NEXT:    s_add_u32 s4, s4, svm_eval_nodes@rel32@lo+4
; MUBUF-NEXT:    s_addc_u32 s5, s5, svm_eval_nodes@rel32@hi+12
; MUBUF-NEXT:    s_waitcnt lgkmcnt(0)
; MUBUF-NEXT:    v_mov_b32_e32 v0, s0
; MUBUF-NEXT:    s_mov_b64 s[0:1], s[36:37]
; MUBUF-NEXT:    s_mov_b64 s[2:3], s[38:39]
; MUBUF-NEXT:    s_swappc_b64 s[30:31], s[4:5]
; MUBUF-NEXT:    v_cmp_ne_u32_e32 vcc_lo, 0, v0
; MUBUF-NEXT:    s_and_saveexec_b32 s0, vcc_lo
; MUBUF-NEXT:    s_cbranch_execz .LBB0_2
; MUBUF-NEXT:  ; %bb.1: ; %if.then4.i
; MUBUF-NEXT:    v_add_nc_u32_e64 v0, 4, 0x4000
; MUBUF-NEXT:    s_mov_b32 s0, 0x41c64e6d
; MUBUF-NEXT:    s_clause 0x1
; MUBUF-NEXT:    buffer_load_dword v1, v0, s[36:39], 0 offen
; MUBUF-NEXT:    buffer_load_dword v2, v0, s[36:39], 0 offen offset:4
; MUBUF-NEXT:    s_waitcnt vmcnt(0)
; MUBUF-NEXT:    v_add_nc_u32_e32 v0, v2, v1
; MUBUF-NEXT:    v_mad_u64_u32 v[0:1], s0, v0, s0, 0x3039
; MUBUF-NEXT:    buffer_store_dword v0, v0, s[36:39], 0 offen
; MUBUF-NEXT:  .LBB0_2: ; %shader_eval_surface.exit
; MUBUF-NEXT:    s_endpgm
;
; FLATSCR-LABEL: kernel_background_evaluate:
; FLATSCR:       ; %bb.0: ; %entry
; FLATSCR-NEXT:    s_add_u32 s2, s2, s5
; FLATSCR-NEXT:    s_movk_i32 s32, 0x6000
; FLATSCR-NEXT:    s_addc_u32 s3, s3, 0
; FLATSCR-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_LO), s2
; FLATSCR-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_HI), s3
; FLATSCR-NEXT:    s_load_dword s2, s[0:1], 0x24
; FLATSCR-NEXT:    v_mov_b32_e32 v1, 0x2000
; FLATSCR-NEXT:    v_mov_b32_e32 v2, 0x4000
; FLATSCR-NEXT:    v_mov_b32_e32 v3, 0
; FLATSCR-NEXT:    v_mov_b32_e32 v4, 0x400000
; FLATSCR-NEXT:    s_getpc_b64 s[0:1]
; FLATSCR-NEXT:    s_add_u32 s0, s0, svm_eval_nodes@rel32@lo+4
; FLATSCR-NEXT:    s_addc_u32 s1, s1, svm_eval_nodes@rel32@hi+12
; FLATSCR-NEXT:    s_waitcnt lgkmcnt(0)
; FLATSCR-NEXT:    v_mov_b32_e32 v0, s2
; FLATSCR-NEXT:    s_swappc_b64 s[30:31], s[0:1]
; FLATSCR-NEXT:    v_cmp_ne_u32_e32 vcc_lo, 0, v0
; FLATSCR-NEXT:    s_and_saveexec_b32 s0, vcc_lo
; FLATSCR-NEXT:    s_cbranch_execz .LBB0_2
; FLATSCR-NEXT:  ; %bb.1: ; %if.then4.i
; FLATSCR-NEXT:    s_movk_i32 vcc_lo, 0x4000
; FLATSCR-NEXT:    s_mov_b32 s0, 0x41c64e6d
; FLATSCR-NEXT:    scratch_load_dwordx2 v[0:1], off, vcc_lo offset:4
; FLATSCR-NEXT:    s_waitcnt vmcnt(0)
; FLATSCR-NEXT:    v_add_nc_u32_e32 v0, v1, v0
; FLATSCR-NEXT:    v_mad_u64_u32 v[0:1], s0, v0, s0, 0x3039
; FLATSCR-NEXT:    scratch_store_dword off, v0, s0
; FLATSCR-NEXT:  .LBB0_2: ; %shader_eval_surface.exit
; FLATSCR-NEXT:    s_endpgm
;
; MUBUF11-LABEL: kernel_background_evaluate:
; MUBUF11:       ; %bb.0: ; %entry
; MUBUF11-NEXT:    s_load_b32 s2, s[0:1], 0x24
; MUBUF11-NEXT:    v_mov_b32_e32 v1, 0x2000
; MUBUF11-NEXT:    v_dual_mov_b32 v2, 0x4000 :: v_dual_mov_b32 v3, 0
; MUBUF11-NEXT:    v_mov_b32_e32 v4, 0x400000
; MUBUF11-NEXT:    s_movk_i32 s32, 0x6000
; MUBUF11-NEXT:    s_getpc_b64 s[0:1]
; MUBUF11-NEXT:    s_add_u32 s0, s0, svm_eval_nodes@rel32@lo+4
; MUBUF11-NEXT:    s_addc_u32 s1, s1, svm_eval_nodes@rel32@hi+12
; MUBUF11-NEXT:    s_waitcnt lgkmcnt(0)
; MUBUF11-NEXT:    v_mov_b32_e32 v0, s2
; MUBUF11-NEXT:    s_swappc_b64 s[30:31], s[0:1]
; MUBUF11-NEXT:    s_mov_b32 s0, exec_lo
; MUBUF11-NEXT:    v_cmpx_ne_u32_e32 0, v0
; MUBUF11-NEXT:    s_cbranch_execz .LBB0_2
; MUBUF11-NEXT:  ; %bb.1: ; %if.then4.i
; MUBUF11-NEXT:    s_movk_i32 vcc_lo, 0x4000
; MUBUF11-NEXT:    s_mov_b32 s0, 0x41c64e6d
; MUBUF11-NEXT:    scratch_load_b64 v[0:1], off, vcc_lo offset:4
; MUBUF11-NEXT:    s_waitcnt vmcnt(0)
; MUBUF11-NEXT:    v_add_nc_u32_e32 v2, v1, v0
; MUBUF11-NEXT:    v_mad_u64_u32 v[0:1], null, v2, s0, 0x3039
; MUBUF11-NEXT:    scratch_store_b32 off, v0, s0
; MUBUF11-NEXT:  .LBB0_2: ; %shader_eval_surface.exit
; MUBUF11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; MUBUF11-NEXT:    s_endpgm
;
; FLATSCR11-LABEL: kernel_background_evaluate:
; FLATSCR11:       ; %bb.0: ; %entry
; FLATSCR11-NEXT:    s_load_b32 s2, s[0:1], 0x24
; FLATSCR11-NEXT:    v_mov_b32_e32 v1, 0x2000
; FLATSCR11-NEXT:    v_dual_mov_b32 v2, 0x4000 :: v_dual_mov_b32 v3, 0
; FLATSCR11-NEXT:    v_mov_b32_e32 v4, 0x400000
; FLATSCR11-NEXT:    s_movk_i32 s32, 0x6000
; FLATSCR11-NEXT:    s_getpc_b64 s[0:1]
; FLATSCR11-NEXT:    s_add_u32 s0, s0, svm_eval_nodes@rel32@lo+4
; FLATSCR11-NEXT:    s_addc_u32 s1, s1, svm_eval_nodes@rel32@hi+12
; FLATSCR11-NEXT:    s_waitcnt lgkmcnt(0)
; FLATSCR11-NEXT:    v_mov_b32_e32 v0, s2
; FLATSCR11-NEXT:    s_swappc_b64 s[30:31], s[0:1]
; FLATSCR11-NEXT:    s_mov_b32 s0, exec_lo
; FLATSCR11-NEXT:    v_cmpx_ne_u32_e32 0, v0
; FLATSCR11-NEXT:    s_cbranch_execz .LBB0_2
; FLATSCR11-NEXT:  ; %bb.1: ; %if.then4.i
; FLATSCR11-NEXT:    s_movk_i32 vcc_lo, 0x4000
; FLATSCR11-NEXT:    s_mov_b32 s0, 0x41c64e6d
; FLATSCR11-NEXT:    scratch_load_b64 v[0:1], off, vcc_lo offset:4
; FLATSCR11-NEXT:    s_waitcnt vmcnt(0)
; FLATSCR11-NEXT:    v_add_nc_u32_e32 v2, v1, v0
; FLATSCR11-NEXT:    v_mad_u64_u32 v[0:1], null, v2, s0, 0x3039
; FLATSCR11-NEXT:    scratch_store_b32 off, v0, s0
; FLATSCR11-NEXT:  .LBB0_2: ; %shader_eval_surface.exit
; FLATSCR11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; FLATSCR11-NEXT:    s_endpgm
entry:
  %sd = alloca < 1339 x i32>, align 8192, addrspace(5)
  %state = alloca <4 x i32>, align 16, addrspace(5)
  %rslt = call i32 @svm_eval_nodes(ptr addrspace(5) %kg, ptr addrspace(5) %sd, ptr addrspace(5) %state, i32 0, i32 4194304)
  %cmp = icmp eq i32 %rslt, 0
  br i1 %cmp, label %shader_eval_surface.exit, label %if.then4.i

if.then4.i:                                       ; preds = %entry
  %rng_hash.i.i = getelementptr inbounds < 4 x i32>, ptr addrspace(5) %state, i32 0, i32 1
  %tmp0 = load i32, ptr addrspace(5) %rng_hash.i.i, align 4
  %rng_offset.i.i = getelementptr inbounds <4 x i32>, ptr addrspace(5) %state, i32 0, i32 2
  %tmp1 = load i32, ptr addrspace(5) %rng_offset.i.i, align 4
  %add.i.i = add i32 %tmp1, %tmp0
  %add1.i.i = add i32 %add.i.i, 0
  %mul.i.i.i.i = mul i32 %add1.i.i, 1103515245
  %add.i.i.i.i = add i32 %mul.i.i.i.i, 12345
  store i32 %add.i.i.i.i, ptr addrspace(5) undef, align 16
  br label %shader_eval_surface.exit

shader_eval_surface.exit:                         ; preds = %entry
  ret void
}

declare hidden i32 @svm_eval_nodes(ptr addrspace(5), ptr addrspace(5), ptr addrspace(5), i32, i32) local_unnamed_addr #0

attributes #0 = { nounwind "amdgpu-no-dispatch-id" "amdgpu-no-dispatch-ptr" "amdgpu-no-implicitarg-ptr" "amdgpu-no-queue-ptr" "amdgpu-no-workgroup-id-x" "amdgpu-no-workgroup-id-y" "amdgpu-no-workgroup-id-z" "amdgpu-no-workitem-id-x" "amdgpu-no-workitem-id-y" "amdgpu-no-workitem-id-z" }
