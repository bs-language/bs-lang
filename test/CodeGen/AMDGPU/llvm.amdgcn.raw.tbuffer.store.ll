; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
;RUN: llc < %s -march=amdgcn -mcpu=verde -verify-machineinstrs | FileCheck -check-prefixes=PREGFX10 %s
;RUN: llc < %s -march=amdgcn -mcpu=tonga -verify-machineinstrs | FileCheck -check-prefixes=PREGFX10 %s
;RUN: llc < %s -march=amdgcn -mcpu=gfx1010 -verify-machineinstrs | FileCheck -check-prefixes=GFX10 %s
;RUN: llc < %s -march=amdgcn -mcpu=gfx1100 -verify-machineinstrs | FileCheck -check-prefixes=GFX11 %s

define amdgpu_ps void @tbuffer_store(<4 x i32> inreg, <4 x float>, <4 x float>, <4 x float>) {
; PREGFX10-LABEL: tbuffer_store:
; PREGFX10:       ; %bb.0: ; %main_body
; PREGFX10-NEXT:    tbuffer_store_format_xyzw v[0:3], off, s[0:3], 0 format:[BUF_DATA_FORMAT_16_16_16_16,BUF_NUM_FORMAT_USCALED]
; PREGFX10-NEXT:    tbuffer_store_format_xyzw v[4:7], off, s[0:3], 0 format:[BUF_DATA_FORMAT_32_32_32,BUF_NUM_FORMAT_SSCALED] glc
; PREGFX10-NEXT:    tbuffer_store_format_xyzw v[8:11], off, s[0:3], 0 format:[BUF_DATA_FORMAT_32_32_32_32,BUF_NUM_FORMAT_UINT] slc
; PREGFX10-NEXT:    tbuffer_store_format_xyzw v[8:11], off, s[0:3], 0 format:[BUF_DATA_FORMAT_32_32_32_32,BUF_NUM_FORMAT_UINT] glc
; PREGFX10-NEXT:    s_endpgm
;
; GFX10-LABEL: tbuffer_store:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    tbuffer_store_format_xyzw v[0:3], off, s[0:3], 0 format:[BUF_FMT_10_10_10_2_UNORM]
; GFX10-NEXT:    tbuffer_store_format_xyzw v[4:7], off, s[0:3], 0 format:[BUF_FMT_8_8_8_8_SINT] glc
; GFX10-NEXT:    tbuffer_store_format_xyzw v[8:11], off, s[0:3], 0 format:78 slc
; GFX10-NEXT:    tbuffer_store_format_xyzw v[8:11], off, s[0:3], 0 format:78 glc dlc
; GFX10-NEXT:    s_endpgm
;
; GFX11-LABEL: tbuffer_store:
; GFX11:       ; %bb.0: ; %main_body
; GFX11-NEXT:    s_clause 0x3
; GFX11-NEXT:    tbuffer_store_format_xyzw v[0:3], off, s[0:3], 0 format:[BUF_FMT_8_8_8_8_USCALED]
; GFX11-NEXT:    tbuffer_store_format_xyzw v[4:7], off, s[0:3], 0 format:[BUF_FMT_32_32_32_32_UINT] glc
; GFX11-NEXT:    tbuffer_store_format_xyzw v[8:11], off, s[0:3], 0 format:78 slc
; GFX11-NEXT:    tbuffer_store_format_xyzw v[8:11], off, s[0:3], 0 format:78 glc dlc
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
main_body:
  %in1 = bitcast <4 x float> %1 to <4 x i32>
  %in2 = bitcast <4 x float> %2 to <4 x i32>
  %in3 = bitcast <4 x float> %3 to <4 x i32>
  call void @llvm.amdgcn.raw.tbuffer.store.v4i32(<4 x i32> %in1, <4 x i32> %0, i32 0, i32 0, i32 44, i32 0)
  call void @llvm.amdgcn.raw.tbuffer.store.v4i32(<4 x i32> %in2, <4 x i32> %0, i32 0, i32 0, i32 61, i32 1)
  call void @llvm.amdgcn.raw.tbuffer.store.v4i32(<4 x i32> %in3, <4 x i32> %0, i32 0, i32 0, i32 78, i32 2)
  call void @llvm.amdgcn.raw.tbuffer.store.v4f32(<4 x float> %3, <4 x i32> %0, i32 0, i32 0, i32 78, i32 5)
  ret void
}

define amdgpu_ps void @tbuffer_store_immoffs(<4 x i32> inreg, <4 x float>) {
; PREGFX10-LABEL: tbuffer_store_immoffs:
; PREGFX10:       ; %bb.0: ; %main_body
; PREGFX10-NEXT:    tbuffer_store_format_xyzw v[0:3], off, s[0:3], 0 format:[BUF_DATA_FORMAT_16_16,BUF_NUM_FORMAT_FLOAT] offset:42
; PREGFX10-NEXT:    s_endpgm
;
; GFX10-LABEL: tbuffer_store_immoffs:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    tbuffer_store_format_xyzw v[0:3], off, s[0:3], 0 format:117 offset:42
; GFX10-NEXT:    s_endpgm
;
; GFX11-LABEL: tbuffer_store_immoffs:
; GFX11:       ; %bb.0: ; %main_body
; GFX11-NEXT:    tbuffer_store_format_xyzw v[0:3], off, s[0:3], 0 format:117 offset:42
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
main_body:
  %in1 = bitcast <4 x float> %1 to <4 x i32>
  call void @llvm.amdgcn.raw.tbuffer.store.v4i32(<4 x i32> %in1, <4 x i32> %0, i32 42, i32 0, i32 117, i32 0)
  ret void
}

define amdgpu_ps void @tbuffer_store_scalar_and_imm_offs(<4 x i32> inreg, <4 x float> %vdata, i32 inreg %soffset) {
; PREGFX10-LABEL: tbuffer_store_scalar_and_imm_offs:
; PREGFX10:       ; %bb.0: ; %main_body
; PREGFX10-NEXT:    tbuffer_store_format_xyzw v[0:3], off, s[0:3], s4 format:[BUF_DATA_FORMAT_16_16,BUF_NUM_FORMAT_FLOAT] offset:42
; PREGFX10-NEXT:    s_endpgm
;
; GFX10-LABEL: tbuffer_store_scalar_and_imm_offs:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    tbuffer_store_format_xyzw v[0:3], off, s[0:3], s4 format:117 offset:42
; GFX10-NEXT:    s_endpgm
;
; GFX11-LABEL: tbuffer_store_scalar_and_imm_offs:
; GFX11:       ; %bb.0: ; %main_body
; GFX11-NEXT:    tbuffer_store_format_xyzw v[0:3], off, s[0:3], s4 format:117 offset:42
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
main_body:
  %in1 = bitcast <4 x float> %vdata to <4 x i32>
  call void @llvm.amdgcn.raw.tbuffer.store.v4i32(<4 x i32> %in1, <4 x i32> %0, i32 42, i32 %soffset, i32 117, i32 0)
  ret void
}

define amdgpu_ps void @buffer_store_ofs(<4 x i32> inreg, <4 x float> %vdata, i32 %voffset) {
; PREGFX10-LABEL: buffer_store_ofs:
; PREGFX10:       ; %bb.0: ; %main_body
; PREGFX10-NEXT:    tbuffer_store_format_xyzw v[0:3], v4, s[0:3], 0 format:[BUF_DATA_FORMAT_8_8,BUF_NUM_FORMAT_FLOAT] offen
; PREGFX10-NEXT:    s_endpgm
;
; GFX10-LABEL: buffer_store_ofs:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    tbuffer_store_format_xyzw v[0:3], v4, s[0:3], 0 format:115 offen
; GFX10-NEXT:    s_endpgm
;
; GFX11-LABEL: buffer_store_ofs:
; GFX11:       ; %bb.0: ; %main_body
; GFX11-NEXT:    tbuffer_store_format_xyzw v[0:3], v4, s[0:3], 0 format:115 offen
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
main_body:
  %in1 = bitcast <4 x float> %vdata to <4 x i32>
  call void @llvm.amdgcn.raw.tbuffer.store.v4i32(<4 x i32> %in1, <4 x i32> %0, i32 %voffset, i32 0, i32 115, i32 0)
  ret void
}

define amdgpu_ps void @buffer_store_x1(<4 x i32> inreg %rsrc, float %data) {
; PREGFX10-LABEL: buffer_store_x1:
; PREGFX10:       ; %bb.0: ; %main_body
; PREGFX10-NEXT:    tbuffer_store_format_x v0, off, s[0:3], 0 format:[BUF_DATA_FORMAT_32_32_32,BUF_NUM_FORMAT_FLOAT]
; PREGFX10-NEXT:    s_endpgm
;
; GFX10-LABEL: buffer_store_x1:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    tbuffer_store_format_x v0, off, s[0:3], 0 format:125
; GFX10-NEXT:    s_endpgm
;
; GFX11-LABEL: buffer_store_x1:
; GFX11:       ; %bb.0: ; %main_body
; GFX11-NEXT:    tbuffer_store_format_x v0, off, s[0:3], 0 format:125
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
main_body:
  %data.i = bitcast float %data to i32
  call void @llvm.amdgcn.raw.tbuffer.store.i32(i32 %data.i, <4 x i32> %rsrc, i32 0, i32 0, i32 125, i32 0)
  ret void
}

define amdgpu_ps void @buffer_store_x2(<4 x i32> inreg %rsrc, <2 x float> %data) {
; PREGFX10-LABEL: buffer_store_x2:
; PREGFX10:       ; %bb.0: ; %main_body
; PREGFX10-NEXT:    tbuffer_store_format_xy v[0:1], off, s[0:3], 0 format:[BUF_NUM_FORMAT_USCALED]
; PREGFX10-NEXT:    s_endpgm
;
; GFX10-LABEL: buffer_store_x2:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    tbuffer_store_format_xy v[0:1], off, s[0:3], 0 format:[BUF_FMT_10_11_11_SSCALED]
; GFX10-NEXT:    s_endpgm
;
; GFX11-LABEL: buffer_store_x2:
; GFX11:       ; %bb.0: ; %main_body
; GFX11-NEXT:    tbuffer_store_format_xy v[0:1], off, s[0:3], 0 format:[BUF_FMT_10_10_10_2_SNORM]
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
main_body:
  %data.i = bitcast <2 x float> %data to <2 x i32>
  call void @llvm.amdgcn.raw.tbuffer.store.v2i32(<2 x i32> %data.i, <4 x i32> %rsrc, i32 0, i32 0, i32 33, i32 0)
  ret void
}

define amdgpu_ps void @buffer_store_voffset_large_12bit(<4 x i32> inreg %rsrc, <4 x float> %data) {
; PREGFX10-LABEL: buffer_store_voffset_large_12bit:
; PREGFX10:       ; %bb.0: ; %main_body
; PREGFX10-NEXT:    tbuffer_store_format_xyzw v[0:3], off, s[0:3], 0 format:[BUF_DATA_FORMAT_RESERVED_15,BUF_NUM_FORMAT_SSCALED] offset:4092
; PREGFX10-NEXT:    s_endpgm
;
; GFX10-LABEL: buffer_store_voffset_large_12bit:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    tbuffer_store_format_xyzw v[0:3], off, s[0:3], 0 format:[BUF_FMT_32_32_SINT] offset:4092
; GFX10-NEXT:    s_endpgm
;
; GFX11-LABEL: buffer_store_voffset_large_12bit:
; GFX11:       ; %bb.0: ; %main_body
; GFX11-NEXT:    tbuffer_store_format_xyzw v[0:3], off, s[0:3], 0 format:[BUF_FMT_32_32_32_32_FLOAT] offset:4092
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
main_body:
  call void @llvm.amdgcn.raw.tbuffer.store.v4f32(<4 x float> %data, <4 x i32> %rsrc, i32 4092, i32 0, i32 63, i32 0)
  ret void
}

define amdgpu_ps void @buffer_store_voffset_large_13bit(<4 x i32> inreg %rsrc, <4 x float> %data) {
; PREGFX10-LABEL: buffer_store_voffset_large_13bit:
; PREGFX10:       ; %bb.0: ; %main_body
; PREGFX10-NEXT:    v_mov_b32_e32 v4, 0x1000
; PREGFX10-NEXT:    tbuffer_store_format_xyzw v[0:3], v4, s[0:3], 0 format:[BUF_DATA_FORMAT_RESERVED_15,BUF_NUM_FORMAT_SSCALED] offen offset:4092
; PREGFX10-NEXT:    s_endpgm
;
; GFX10-LABEL: buffer_store_voffset_large_13bit:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    v_mov_b32_e32 v4, 0x1000
; GFX10-NEXT:    tbuffer_store_format_xyzw v[0:3], v4, s[0:3], 0 format:[BUF_FMT_32_32_SINT] offen offset:4092
; GFX10-NEXT:    s_endpgm
;
; GFX11-LABEL: buffer_store_voffset_large_13bit:
; GFX11:       ; %bb.0: ; %main_body
; GFX11-NEXT:    v_mov_b32_e32 v4, 0x1000
; GFX11-NEXT:    tbuffer_store_format_xyzw v[0:3], v4, s[0:3], 0 format:[BUF_FMT_32_32_32_32_FLOAT] offen offset:4092
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
main_body:
  call void @llvm.amdgcn.raw.tbuffer.store.v4f32(<4 x float> %data, <4 x i32> %rsrc, i32 8188, i32 0, i32 63, i32 0)
  ret void
}

define amdgpu_ps void @buffer_store_voffset_large_16bit(<4 x i32> inreg %rsrc, <4 x float> %data) {
; PREGFX10-LABEL: buffer_store_voffset_large_16bit:
; PREGFX10:       ; %bb.0: ; %main_body
; PREGFX10-NEXT:    v_mov_b32_e32 v4, 0xf000
; PREGFX10-NEXT:    tbuffer_store_format_xyzw v[0:3], v4, s[0:3], 0 format:[BUF_DATA_FORMAT_RESERVED_15,BUF_NUM_FORMAT_SSCALED] offen offset:4092
; PREGFX10-NEXT:    s_endpgm
;
; GFX10-LABEL: buffer_store_voffset_large_16bit:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    v_mov_b32_e32 v4, 0xf000
; GFX10-NEXT:    tbuffer_store_format_xyzw v[0:3], v4, s[0:3], 0 format:[BUF_FMT_32_32_SINT] offen offset:4092
; GFX10-NEXT:    s_endpgm
;
; GFX11-LABEL: buffer_store_voffset_large_16bit:
; GFX11:       ; %bb.0: ; %main_body
; GFX11-NEXT:    v_mov_b32_e32 v4, 0xf000
; GFX11-NEXT:    tbuffer_store_format_xyzw v[0:3], v4, s[0:3], 0 format:[BUF_FMT_32_32_32_32_FLOAT] offen offset:4092
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
main_body:
  call void @llvm.amdgcn.raw.tbuffer.store.v4f32(<4 x float> %data, <4 x i32> %rsrc, i32 65532, i32 0, i32 63, i32 0)
  ret void
}

define amdgpu_ps void @buffer_store_voffset_large_23bit(<4 x i32> inreg %rsrc, <4 x float> %data) {
; PREGFX10-LABEL: buffer_store_voffset_large_23bit:
; PREGFX10:       ; %bb.0: ; %main_body
; PREGFX10-NEXT:    v_mov_b32_e32 v4, 0x7ff000
; PREGFX10-NEXT:    tbuffer_store_format_xyzw v[0:3], v4, s[0:3], 0 format:[BUF_DATA_FORMAT_RESERVED_15,BUF_NUM_FORMAT_SSCALED] offen offset:4092
; PREGFX10-NEXT:    s_endpgm
;
; GFX10-LABEL: buffer_store_voffset_large_23bit:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    v_mov_b32_e32 v4, 0x7ff000
; GFX10-NEXT:    tbuffer_store_format_xyzw v[0:3], v4, s[0:3], 0 format:[BUF_FMT_32_32_SINT] offen offset:4092
; GFX10-NEXT:    s_endpgm
;
; GFX11-LABEL: buffer_store_voffset_large_23bit:
; GFX11:       ; %bb.0: ; %main_body
; GFX11-NEXT:    v_mov_b32_e32 v4, 0x7ff000
; GFX11-NEXT:    tbuffer_store_format_xyzw v[0:3], v4, s[0:3], 0 format:[BUF_FMT_32_32_32_32_FLOAT] offen offset:4092
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
main_body:
  call void @llvm.amdgcn.raw.tbuffer.store.v4f32(<4 x float> %data, <4 x i32> %rsrc, i32 8388604, i32 0, i32 63, i32 0)
  ret void
}

define amdgpu_ps void @buffer_store_voffset_large_24bit(<4 x i32> inreg %rsrc, <4 x float> %data) {
; PREGFX10-LABEL: buffer_store_voffset_large_24bit:
; PREGFX10:       ; %bb.0: ; %main_body
; PREGFX10-NEXT:    v_mov_b32_e32 v4, 0xfff000
; PREGFX10-NEXT:    tbuffer_store_format_xyzw v[0:3], v4, s[0:3], 0 format:[BUF_DATA_FORMAT_RESERVED_15,BUF_NUM_FORMAT_SSCALED] offen offset:4092
; PREGFX10-NEXT:    s_endpgm
;
; GFX10-LABEL: buffer_store_voffset_large_24bit:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    v_mov_b32_e32 v4, 0xfff000
; GFX10-NEXT:    tbuffer_store_format_xyzw v[0:3], v4, s[0:3], 0 format:[BUF_FMT_32_32_SINT] offen offset:4092
; GFX10-NEXT:    s_endpgm
;
; GFX11-LABEL: buffer_store_voffset_large_24bit:
; GFX11:       ; %bb.0: ; %main_body
; GFX11-NEXT:    v_mov_b32_e32 v4, 0xfff000
; GFX11-NEXT:    tbuffer_store_format_xyzw v[0:3], v4, s[0:3], 0 format:[BUF_FMT_32_32_32_32_FLOAT] offen offset:4092
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
main_body:
  call void @llvm.amdgcn.raw.tbuffer.store.v4f32(<4 x float> %data, <4 x i32> %rsrc, i32 16777212, i32 0, i32 63, i32 0)
  ret void
}

declare void @llvm.amdgcn.raw.tbuffer.store.i32(i32, <4 x i32>, i32, i32, i32, i32) #0
declare void @llvm.amdgcn.raw.tbuffer.store.v2i32(<2 x i32>, <4 x i32>, i32, i32, i32, i32) #0
declare void @llvm.amdgcn.raw.tbuffer.store.v4i32(<4 x i32>, <4 x i32>, i32, i32, i32, i32) #0
declare void @llvm.amdgcn.raw.tbuffer.store.v4f32(<4 x float>, <4 x i32>, i32, i32, i32, i32) #0
attributes #0 = { nounwind }
attributes #1 = { nounwind readonly }
