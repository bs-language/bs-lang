; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=amdgcn -mcpu=gfx1100 -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -global-isel -march=amdgcn -mcpu=gfx1100 -verify-machineinstrs < %s | FileCheck %s

declare { i32, i32 } @llvm.amdgcn.ds.bvh.stack.rtn(i32, i32, <4 x i32>, i32 immarg)

define amdgpu_gs void @test_ds_bvh_stack(i32 %addr, i32 %data0, <4 x i32> %data1, ptr addrspace(1) %out) {
; CHECK-LABEL: test_ds_bvh_stack:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ds_bvh_stack_rtn_b32 v1, v0, v1, v[2:5]
; CHECK-NEXT:    s_waitcnt lgkmcnt(0)
; CHECK-NEXT:    v_add_nc_u32_e32 v0, v1, v0
; CHECK-NEXT:    global_store_b32 v[6:7], v0, off
; CHECK-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; CHECK-NEXT:    s_endpgm
  %pair = call { i32, i32 } @llvm.amdgcn.ds.bvh.stack.rtn(i32 %addr, i32 %data0, <4 x i32> %data1, i32 0)
  %vdst = extractvalue { i32, i32 } %pair, 0
  %newaddr = extractvalue { i32, i32 } %pair, 1
  %res = add i32 %vdst, %newaddr
  store i32 %res, ptr addrspace(1) %out, align 4
  ret void
}

define amdgpu_gs void @test_ds_bvh_stack_1(i32 %addr, i32 %data0, <4 x i32> %data1, ptr addrspace(1) %out) {
; CHECK-LABEL: test_ds_bvh_stack_1:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ds_bvh_stack_rtn_b32 v1, v0, v1, v[2:5] offset:1
; CHECK-NEXT:    s_waitcnt lgkmcnt(0)
; CHECK-NEXT:    v_add_nc_u32_e32 v0, v1, v0
; CHECK-NEXT:    global_store_b32 v[6:7], v0, off
; CHECK-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; CHECK-NEXT:    s_endpgm
  %pair = call { i32, i32 } @llvm.amdgcn.ds.bvh.stack.rtn(i32 %addr, i32 %data0, <4 x i32> %data1, i32 1)
  %vdst = extractvalue { i32, i32 } %pair, 0
  %newaddr = extractvalue { i32, i32 } %pair, 1
  %res = add i32 %vdst, %newaddr
  store i32 %res, ptr addrspace(1) %out, align 4
  ret void
}