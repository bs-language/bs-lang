; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=r600 -mcpu=cayman < %s | FileCheck %s

define amdgpu_kernel void @addrspacecast_flat_to_global(ptr addrspace(1) %out, ptr %src.ptr) {
; CHECK-LABEL: addrspacecast_flat_to_global:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ALU 2, @4, KC0[CB0:0-32], KC1[]
; CHECK-NEXT:    MEM_RAT_CACHELESS STORE_DWORD T1.X, T0.X
; CHECK-NEXT:    CF_END
; CHECK-NEXT:    PAD
; CHECK-NEXT:    ALU clause starting at 4:
; CHECK-NEXT:     LSHR * T0.X, KC0[2].Y, literal.x,
; CHECK-NEXT:    2(2.802597e-45), 0(0.000000e+00)
; CHECK-NEXT:     MOV * T1.X, KC0[2].Z,
  %cast = addrspacecast ptr %src.ptr to ptr addrspace(1)
  store ptr addrspace(1) %cast, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @addrspacecast_global_to_flat(ptr addrspace(1) %out, ptr addrspace(1) %src.ptr) {
; CHECK-LABEL: addrspacecast_global_to_flat:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ALU 2, @4, KC0[CB0:0-32], KC1[]
; CHECK-NEXT:    MEM_RAT_CACHELESS STORE_DWORD T1.X, T0.X
; CHECK-NEXT:    CF_END
; CHECK-NEXT:    PAD
; CHECK-NEXT:    ALU clause starting at 4:
; CHECK-NEXT:     LSHR * T0.X, KC0[2].Y, literal.x,
; CHECK-NEXT:    2(2.802597e-45), 0(0.000000e+00)
; CHECK-NEXT:     MOV * T1.X, KC0[2].Z,
  %cast = addrspacecast ptr addrspace(1) %src.ptr to ptr
  store ptr %cast, ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @addrspacecast_flat_null_to_local(ptr addrspace(1) %out) {
; CHECK-LABEL: addrspacecast_flat_null_to_local:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ALU 3, @4, KC0[CB0:0-32], KC1[]
; CHECK-NEXT:    MEM_RAT_CACHELESS STORE_DWORD T0.X, T1.X
; CHECK-NEXT:    CF_END
; CHECK-NEXT:    PAD
; CHECK-NEXT:    ALU clause starting at 4:
; CHECK-NEXT:     MOV * T0.X, literal.x,
; CHECK-NEXT:    -1(nan), 0(0.000000e+00)
; CHECK-NEXT:     LSHR * T1.X, KC0[2].Y, literal.x,
; CHECK-NEXT:    2(2.802597e-45), 0(0.000000e+00)
  store ptr addrspace(3) addrspacecast (ptr null to ptr addrspace(3)), ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @addrspacecast_flat_null_to_global(ptr addrspace(1) %out) {
; CHECK-LABEL: addrspacecast_flat_null_to_global:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ALU 3, @4, KC0[CB0:0-32], KC1[]
; CHECK-NEXT:    MEM_RAT_CACHELESS STORE_DWORD T0.X, T1.X
; CHECK-NEXT:    CF_END
; CHECK-NEXT:    PAD
; CHECK-NEXT:    ALU clause starting at 4:
; CHECK-NEXT:     MOV * T0.X, literal.x,
; CHECK-NEXT:    0(0.000000e+00), 0(0.000000e+00)
; CHECK-NEXT:     LSHR * T1.X, KC0[2].Y, literal.x,
; CHECK-NEXT:    2(2.802597e-45), 0(0.000000e+00)
  store ptr addrspace(1) addrspacecast (ptr null to ptr addrspace(1)), ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @addrspacecast_flat_undef_to_local(ptr addrspace(1) %out) {
; CHECK-LABEL: addrspacecast_flat_undef_to_local:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    CF_END
; CHECK-NEXT:    PAD
  store ptr addrspace(3) addrspacecast (ptr undef to ptr addrspace(3)), ptr addrspace(1) %out
  ret void
}

define amdgpu_kernel void @addrspacecast_flat_poison_to_local(ptr addrspace(1) %out) {
; CHECK-LABEL: addrspacecast_flat_poison_to_local:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    CF_END
; CHECK-NEXT:    PAD
  store ptr addrspace(3) addrspacecast (ptr poison to ptr addrspace(3)), ptr addrspace(1) %out
  ret void
}