; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avxvnniint8  --show-mc-encoding | FileCheck %s --check-prefixes=X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avxvnniint8  --show-mc-encoding | FileCheck %s --check-prefixes=X64


declare <4 x i32> @llvm.x86.avx2.vpdpbssd.128(<4 x i32>, <4 x i32>, <4 x i32>)

define <4 x i32>@test_int_x86_avx2_vpdpbssd_128(<4 x i32> %x0, <4 x i32> %x1, ptr %x2p, <4 x i32> %x4) {
; X86-LABEL: test_int_x86_avx2_vpdpbssd_128:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    vmovaps %xmm0, %xmm3 # encoding: [0xc5,0xf8,0x28,0xd8]
; X86-NEXT:    vpdpbssd (%eax), %xmm1, %xmm3 # encoding: [0xc4,0xe2,0x73,0x50,0x18]
; X86-NEXT:    vpdpbssd %xmm2, %xmm1, %xmm0 # encoding: [0xc4,0xe2,0x73,0x50,0xc2]
; X86-NEXT:    vpaddd %xmm0, %xmm3, %xmm0 # encoding: [0xc5,0xe1,0xfe,0xc0]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx2_vpdpbssd_128:
; X64:       # %bb.0:
; X64-NEXT:    vmovaps %xmm0, %xmm3 # encoding: [0xc5,0xf8,0x28,0xd8]
; X64-NEXT:    vpdpbssd (%rdi), %xmm1, %xmm3 # encoding: [0xc4,0xe2,0x73,0x50,0x1f]
; X64-NEXT:    vpdpbssd %xmm2, %xmm1, %xmm0 # encoding: [0xc4,0xe2,0x73,0x50,0xc2]
; X64-NEXT:    vpaddd %xmm0, %xmm3, %xmm0 # encoding: [0xc5,0xe1,0xfe,0xc0]
; X64-NEXT:    retq # encoding: [0xc3]
  %x2 = load <4 x i32>, ptr %x2p
  %1 = call <4 x i32> @llvm.x86.avx2.vpdpbssd.128(<4 x i32> %x0, <4 x i32> %x1, <4 x i32> %x2)
  %2 = call <4 x i32> @llvm.x86.avx2.vpdpbssd.128(<4 x i32> %x0, <4 x i32> %x1, <4 x i32> %x4)
  %res = add <4 x i32> %1, %2
  ret <4 x i32> %res
}

declare <4 x i32> @llvm.x86.avx2.vpdpbssds.128(<4 x i32>, <4 x i32>, <4 x i32>)

define <4 x i32>@test_int_x86_avx2_vpdpbssds_128(<4 x i32> %x0, <4 x i32> %x1, ptr %x2p, <4 x i32> %x4) {
; X86-LABEL: test_int_x86_avx2_vpdpbssds_128:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    vmovaps %xmm0, %xmm3 # encoding: [0xc5,0xf8,0x28,0xd8]
; X86-NEXT:    vpdpbssds (%eax), %xmm1, %xmm3 # encoding: [0xc4,0xe2,0x73,0x51,0x18]
; X86-NEXT:    vpdpbssds %xmm2, %xmm1, %xmm0 # encoding: [0xc4,0xe2,0x73,0x51,0xc2]
; X86-NEXT:    vpaddd %xmm0, %xmm3, %xmm0 # encoding: [0xc5,0xe1,0xfe,0xc0]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx2_vpdpbssds_128:
; X64:       # %bb.0:
; X64-NEXT:    vmovaps %xmm0, %xmm3 # encoding: [0xc5,0xf8,0x28,0xd8]
; X64-NEXT:    vpdpbssds (%rdi), %xmm1, %xmm3 # encoding: [0xc4,0xe2,0x73,0x51,0x1f]
; X64-NEXT:    vpdpbssds %xmm2, %xmm1, %xmm0 # encoding: [0xc4,0xe2,0x73,0x51,0xc2]
; X64-NEXT:    vpaddd %xmm0, %xmm3, %xmm0 # encoding: [0xc5,0xe1,0xfe,0xc0]
; X64-NEXT:    retq # encoding: [0xc3]
  %x2 = load <4 x i32>, ptr %x2p
  %1 = call <4 x i32> @llvm.x86.avx2.vpdpbssds.128(<4 x i32> %x0, <4 x i32> %x1, <4 x i32> %x2)
  %2 = call <4 x i32> @llvm.x86.avx2.vpdpbssds.128(<4 x i32> %x0, <4 x i32> %x1, <4 x i32> %x4)
  %res = add <4 x i32> %1, %2
  ret <4 x i32> %res
}

declare <8 x i32> @llvm.x86.avx2.vpdpbssd.256(<8 x i32>, <8 x i32>, <8 x i32>)

define <8 x i32>@test_int_x86_avx2_vpdpbssd_256(<8 x i32> %x0, <8 x i32> %x1, ptr %x2p, <8 x i32> %x4) {
; X86-LABEL: test_int_x86_avx2_vpdpbssd_256:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    vmovaps %ymm0, %ymm3 # encoding: [0xc5,0xfc,0x28,0xd8]
; X86-NEXT:    vpdpbssd (%eax), %ymm1, %ymm3 # encoding: [0xc4,0xe2,0x77,0x50,0x18]
; X86-NEXT:    vpdpbssd %ymm2, %ymm1, %ymm0 # encoding: [0xc4,0xe2,0x77,0x50,0xc2]
; X86-NEXT:    vpaddd %ymm0, %ymm3, %ymm0 # encoding: [0xc5,0xe5,0xfe,0xc0]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx2_vpdpbssd_256:
; X64:       # %bb.0:
; X64-NEXT:    vmovaps %ymm0, %ymm3 # encoding: [0xc5,0xfc,0x28,0xd8]
; X64-NEXT:    vpdpbssd (%rdi), %ymm1, %ymm3 # encoding: [0xc4,0xe2,0x77,0x50,0x1f]
; X64-NEXT:    vpdpbssd %ymm2, %ymm1, %ymm0 # encoding: [0xc4,0xe2,0x77,0x50,0xc2]
; X64-NEXT:    vpaddd %ymm0, %ymm3, %ymm0 # encoding: [0xc5,0xe5,0xfe,0xc0]
; X64-NEXT:    retq # encoding: [0xc3]
  %x2 = load <8 x i32>, ptr %x2p
  %1 = call <8 x i32> @llvm.x86.avx2.vpdpbssd.256(<8 x i32> %x0, <8 x i32> %x1, <8 x i32> %x2)
  %2 = call <8 x i32> @llvm.x86.avx2.vpdpbssd.256(<8 x i32> %x0, <8 x i32> %x1, <8 x i32> %x4)
  %res = add <8 x i32> %1, %2
  ret <8 x i32> %res
}

declare <8 x i32> @llvm.x86.avx2.vpdpbssds.256(<8 x i32>, <8 x i32>, <8 x i32>)

define <8 x i32>@test_int_x86_avx2_vpdpbssds_256(<8 x i32> %x0, <8 x i32> %x1, ptr %x2p, <8 x i32> %x4) {
; X86-LABEL: test_int_x86_avx2_vpdpbssds_256:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    vmovaps %ymm0, %ymm3 # encoding: [0xc5,0xfc,0x28,0xd8]
; X86-NEXT:    vpdpbssds (%eax), %ymm1, %ymm3 # encoding: [0xc4,0xe2,0x77,0x51,0x18]
; X86-NEXT:    vpdpbssds %ymm2, %ymm1, %ymm0 # encoding: [0xc4,0xe2,0x77,0x51,0xc2]
; X86-NEXT:    vpaddd %ymm0, %ymm3, %ymm0 # encoding: [0xc5,0xe5,0xfe,0xc0]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx2_vpdpbssds_256:
; X64:       # %bb.0:
; X64-NEXT:    vmovaps %ymm0, %ymm3 # encoding: [0xc5,0xfc,0x28,0xd8]
; X64-NEXT:    vpdpbssds (%rdi), %ymm1, %ymm3 # encoding: [0xc4,0xe2,0x77,0x51,0x1f]
; X64-NEXT:    vpdpbssds %ymm2, %ymm1, %ymm0 # encoding: [0xc4,0xe2,0x77,0x51,0xc2]
; X64-NEXT:    vpaddd %ymm0, %ymm3, %ymm0 # encoding: [0xc5,0xe5,0xfe,0xc0]
; X64-NEXT:    retq # encoding: [0xc3]
  %x2 = load <8 x i32>, ptr %x2p
  %1 = call <8 x i32> @llvm.x86.avx2.vpdpbssds.256(<8 x i32> %x0, <8 x i32> %x1, <8 x i32> %x2)
  %2 = call <8 x i32> @llvm.x86.avx2.vpdpbssds.256(<8 x i32> %x0, <8 x i32> %x1, <8 x i32> %x4)
  %res = add <8 x i32> %1, %2
  ret <8 x i32> %res
}

declare <4 x i32> @llvm.x86.avx2.vpdpbsud.128(<4 x i32>, <4 x i32>, <4 x i32>)

define <4 x i32>@test_int_x86_avx2_vpdpbsud_128(<4 x i32> %x0, <4 x i32> %x1, ptr %x2p, <4 x i32> %x4) {
; X86-LABEL: test_int_x86_avx2_vpdpbsud_128:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    vmovaps %xmm0, %xmm3 # encoding: [0xc5,0xf8,0x28,0xd8]
; X86-NEXT:    vpdpbsud (%eax), %xmm1, %xmm3 # encoding: [0xc4,0xe2,0x72,0x50,0x18]
; X86-NEXT:    vpdpbsud %xmm2, %xmm1, %xmm0 # encoding: [0xc4,0xe2,0x72,0x50,0xc2]
; X86-NEXT:    vpaddd %xmm0, %xmm3, %xmm0 # encoding: [0xc5,0xe1,0xfe,0xc0]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx2_vpdpbsud_128:
; X64:       # %bb.0:
; X64-NEXT:    vmovaps %xmm0, %xmm3 # encoding: [0xc5,0xf8,0x28,0xd8]
; X64-NEXT:    vpdpbsud (%rdi), %xmm1, %xmm3 # encoding: [0xc4,0xe2,0x72,0x50,0x1f]
; X64-NEXT:    vpdpbsud %xmm2, %xmm1, %xmm0 # encoding: [0xc4,0xe2,0x72,0x50,0xc2]
; X64-NEXT:    vpaddd %xmm0, %xmm3, %xmm0 # encoding: [0xc5,0xe1,0xfe,0xc0]
; X64-NEXT:    retq # encoding: [0xc3]
  %x2 = load <4 x i32>, ptr %x2p
  %1 = call <4 x i32> @llvm.x86.avx2.vpdpbsud.128(<4 x i32> %x0, <4 x i32> %x1, <4 x i32> %x2)
  %2 = call <4 x i32> @llvm.x86.avx2.vpdpbsud.128(<4 x i32> %x0, <4 x i32> %x1, <4 x i32> %x4)
  %res = add <4 x i32> %1, %2
  ret <4 x i32> %res
}

declare <4 x i32> @llvm.x86.avx2.vpdpbsuds.128(<4 x i32>, <4 x i32>, <4 x i32>)

define <4 x i32>@test_int_x86_avx2_vpdpbsuds_128(<4 x i32> %x0, <4 x i32> %x1, ptr %x2p, <4 x i32> %x4) {
; X86-LABEL: test_int_x86_avx2_vpdpbsuds_128:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    vmovaps %xmm0, %xmm3 # encoding: [0xc5,0xf8,0x28,0xd8]
; X86-NEXT:    vpdpbsuds (%eax), %xmm1, %xmm3 # encoding: [0xc4,0xe2,0x72,0x51,0x18]
; X86-NEXT:    vpdpbsuds %xmm2, %xmm1, %xmm0 # encoding: [0xc4,0xe2,0x72,0x51,0xc2]
; X86-NEXT:    vpaddd %xmm0, %xmm3, %xmm0 # encoding: [0xc5,0xe1,0xfe,0xc0]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx2_vpdpbsuds_128:
; X64:       # %bb.0:
; X64-NEXT:    vmovaps %xmm0, %xmm3 # encoding: [0xc5,0xf8,0x28,0xd8]
; X64-NEXT:    vpdpbsuds (%rdi), %xmm1, %xmm3 # encoding: [0xc4,0xe2,0x72,0x51,0x1f]
; X64-NEXT:    vpdpbsuds %xmm2, %xmm1, %xmm0 # encoding: [0xc4,0xe2,0x72,0x51,0xc2]
; X64-NEXT:    vpaddd %xmm0, %xmm3, %xmm0 # encoding: [0xc5,0xe1,0xfe,0xc0]
; X64-NEXT:    retq # encoding: [0xc3]
  %x2 = load <4 x i32>, ptr %x2p
  %1 = call <4 x i32> @llvm.x86.avx2.vpdpbsuds.128(<4 x i32> %x0, <4 x i32> %x1, <4 x i32> %x2)
  %2 = call <4 x i32> @llvm.x86.avx2.vpdpbsuds.128(<4 x i32> %x0, <4 x i32> %x1, <4 x i32> %x4)
  %res = add <4 x i32> %1, %2
  ret <4 x i32> %res
}

declare <8 x i32> @llvm.x86.avx2.vpdpbsud.256(<8 x i32>, <8 x i32>, <8 x i32>)

define <8 x i32>@test_int_x86_avx2_vpdpbsud_256(<8 x i32> %x0, <8 x i32> %x1, ptr %x2p, <8 x i32> %x4) {
; X86-LABEL: test_int_x86_avx2_vpdpbsud_256:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    vmovaps %ymm0, %ymm3 # encoding: [0xc5,0xfc,0x28,0xd8]
; X86-NEXT:    vpdpbsud (%eax), %ymm1, %ymm3 # encoding: [0xc4,0xe2,0x76,0x50,0x18]
; X86-NEXT:    vpdpbsud %ymm2, %ymm1, %ymm0 # encoding: [0xc4,0xe2,0x76,0x50,0xc2]
; X86-NEXT:    vpaddd %ymm0, %ymm3, %ymm0 # encoding: [0xc5,0xe5,0xfe,0xc0]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx2_vpdpbsud_256:
; X64:       # %bb.0:
; X64-NEXT:    vmovaps %ymm0, %ymm3 # encoding: [0xc5,0xfc,0x28,0xd8]
; X64-NEXT:    vpdpbsud (%rdi), %ymm1, %ymm3 # encoding: [0xc4,0xe2,0x76,0x50,0x1f]
; X64-NEXT:    vpdpbsud %ymm2, %ymm1, %ymm0 # encoding: [0xc4,0xe2,0x76,0x50,0xc2]
; X64-NEXT:    vpaddd %ymm0, %ymm3, %ymm0 # encoding: [0xc5,0xe5,0xfe,0xc0]
; X64-NEXT:    retq # encoding: [0xc3]
  %x2 = load <8 x i32>, ptr %x2p
  %1 = call <8 x i32> @llvm.x86.avx2.vpdpbsud.256(<8 x i32> %x0, <8 x i32> %x1, <8 x i32> %x2)
  %2 = call <8 x i32> @llvm.x86.avx2.vpdpbsud.256(<8 x i32> %x0, <8 x i32> %x1, <8 x i32> %x4)
  %res = add <8 x i32> %1, %2
  ret <8 x i32> %res
}

declare <8 x i32> @llvm.x86.avx2.vpdpbsuds.256(<8 x i32>, <8 x i32>, <8 x i32>)

define <8 x i32>@test_int_x86_avx2_vpdpbsuds_256(<8 x i32> %x0, <8 x i32> %x1, ptr %x2p, <8 x i32> %x4) {
; X86-LABEL: test_int_x86_avx2_vpdpbsuds_256:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    vmovaps %ymm0, %ymm3 # encoding: [0xc5,0xfc,0x28,0xd8]
; X86-NEXT:    vpdpbsuds (%eax), %ymm1, %ymm3 # encoding: [0xc4,0xe2,0x76,0x51,0x18]
; X86-NEXT:    vpdpbsuds %ymm2, %ymm1, %ymm0 # encoding: [0xc4,0xe2,0x76,0x51,0xc2]
; X86-NEXT:    vpaddd %ymm0, %ymm3, %ymm0 # encoding: [0xc5,0xe5,0xfe,0xc0]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx2_vpdpbsuds_256:
; X64:       # %bb.0:
; X64-NEXT:    vmovaps %ymm0, %ymm3 # encoding: [0xc5,0xfc,0x28,0xd8]
; X64-NEXT:    vpdpbsuds (%rdi), %ymm1, %ymm3 # encoding: [0xc4,0xe2,0x76,0x51,0x1f]
; X64-NEXT:    vpdpbsuds %ymm2, %ymm1, %ymm0 # encoding: [0xc4,0xe2,0x76,0x51,0xc2]
; X64-NEXT:    vpaddd %ymm0, %ymm3, %ymm0 # encoding: [0xc5,0xe5,0xfe,0xc0]
; X64-NEXT:    retq # encoding: [0xc3]
  %x2 = load <8 x i32>, ptr %x2p
  %1 = call <8 x i32> @llvm.x86.avx2.vpdpbsuds.256(<8 x i32> %x0, <8 x i32> %x1, <8 x i32> %x2)
  %2 = call <8 x i32> @llvm.x86.avx2.vpdpbsuds.256(<8 x i32> %x0, <8 x i32> %x1, <8 x i32> %x4)
  %res = add <8 x i32> %1, %2
  ret <8 x i32> %res
}

declare <4 x i32> @llvm.x86.avx2.vpdpbuud.128(<4 x i32>, <4 x i32>, <4 x i32>)

define <4 x i32>@test_int_x86_avx2_vpdpbuud_128(<4 x i32> %x0, <4 x i32> %x1, ptr %x2p, <4 x i32> %x4) {
; X86-LABEL: test_int_x86_avx2_vpdpbuud_128:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    vmovaps %xmm0, %xmm3 # encoding: [0xc5,0xf8,0x28,0xd8]
; X86-NEXT:    vpdpbuud (%eax), %xmm1, %xmm3 # encoding: [0xc4,0xe2,0x70,0x50,0x18]
; X86-NEXT:    vpdpbuud %xmm2, %xmm1, %xmm0 # encoding: [0xc4,0xe2,0x70,0x50,0xc2]
; X86-NEXT:    vpaddd %xmm0, %xmm3, %xmm0 # encoding: [0xc5,0xe1,0xfe,0xc0]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx2_vpdpbuud_128:
; X64:       # %bb.0:
; X64-NEXT:    vmovaps %xmm0, %xmm3 # encoding: [0xc5,0xf8,0x28,0xd8]
; X64-NEXT:    vpdpbuud (%rdi), %xmm1, %xmm3 # encoding: [0xc4,0xe2,0x70,0x50,0x1f]
; X64-NEXT:    vpdpbuud %xmm2, %xmm1, %xmm0 # encoding: [0xc4,0xe2,0x70,0x50,0xc2]
; X64-NEXT:    vpaddd %xmm0, %xmm3, %xmm0 # encoding: [0xc5,0xe1,0xfe,0xc0]
; X64-NEXT:    retq # encoding: [0xc3]
  %x2 = load <4 x i32>, ptr %x2p
  %1 = call <4 x i32> @llvm.x86.avx2.vpdpbuud.128(<4 x i32> %x0, <4 x i32> %x1, <4 x i32> %x2)
  %2 = call <4 x i32> @llvm.x86.avx2.vpdpbuud.128(<4 x i32> %x0, <4 x i32> %x1, <4 x i32> %x4)
  %res = add <4 x i32> %1, %2
  ret <4 x i32> %res
}

declare <4 x i32> @llvm.x86.avx2.vpdpbuuds.128(<4 x i32>, <4 x i32>, <4 x i32>)

define <4 x i32>@test_int_x86_avx2_vpdpbuuds_128(<4 x i32> %x0, <4 x i32> %x1, ptr %x2p, <4 x i32> %x4) {
; X86-LABEL: test_int_x86_avx2_vpdpbuuds_128:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    vmovaps %xmm0, %xmm3 # encoding: [0xc5,0xf8,0x28,0xd8]
; X86-NEXT:    vpdpbuuds (%eax), %xmm1, %xmm3 # encoding: [0xc4,0xe2,0x70,0x51,0x18]
; X86-NEXT:    vpdpbuuds %xmm2, %xmm1, %xmm0 # encoding: [0xc4,0xe2,0x70,0x51,0xc2]
; X86-NEXT:    vpaddd %xmm0, %xmm3, %xmm0 # encoding: [0xc5,0xe1,0xfe,0xc0]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx2_vpdpbuuds_128:
; X64:       # %bb.0:
; X64-NEXT:    vmovaps %xmm0, %xmm3 # encoding: [0xc5,0xf8,0x28,0xd8]
; X64-NEXT:    vpdpbuuds (%rdi), %xmm1, %xmm3 # encoding: [0xc4,0xe2,0x70,0x51,0x1f]
; X64-NEXT:    vpdpbuuds %xmm2, %xmm1, %xmm0 # encoding: [0xc4,0xe2,0x70,0x51,0xc2]
; X64-NEXT:    vpaddd %xmm0, %xmm3, %xmm0 # encoding: [0xc5,0xe1,0xfe,0xc0]
; X64-NEXT:    retq # encoding: [0xc3]
  %x2 = load <4 x i32>, ptr %x2p
  %1 = call <4 x i32> @llvm.x86.avx2.vpdpbuuds.128(<4 x i32> %x0, <4 x i32> %x1, <4 x i32> %x2)
  %2 = call <4 x i32> @llvm.x86.avx2.vpdpbuuds.128(<4 x i32> %x0, <4 x i32> %x1, <4 x i32> %x4)
  %res = add <4 x i32> %1, %2
  ret <4 x i32> %res
}

declare <8 x i32> @llvm.x86.avx2.vpdpbuud.256(<8 x i32>, <8 x i32>, <8 x i32>)

define <8 x i32>@test_int_x86_avx2_vpdpbuud_256(<8 x i32> %x0, <8 x i32> %x1, ptr %x2p, <8 x i32> %x4) {
; X86-LABEL: test_int_x86_avx2_vpdpbuud_256:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    vmovaps %ymm0, %ymm3 # encoding: [0xc5,0xfc,0x28,0xd8]
; X86-NEXT:    vpdpbuud (%eax), %ymm1, %ymm3 # encoding: [0xc4,0xe2,0x74,0x50,0x18]
; X86-NEXT:    vpdpbuud %ymm2, %ymm1, %ymm0 # encoding: [0xc4,0xe2,0x74,0x50,0xc2]
; X86-NEXT:    vpaddd %ymm0, %ymm3, %ymm0 # encoding: [0xc5,0xe5,0xfe,0xc0]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx2_vpdpbuud_256:
; X64:       # %bb.0:
; X64-NEXT:    vmovaps %ymm0, %ymm3 # encoding: [0xc5,0xfc,0x28,0xd8]
; X64-NEXT:    vpdpbuud (%rdi), %ymm1, %ymm3 # encoding: [0xc4,0xe2,0x74,0x50,0x1f]
; X64-NEXT:    vpdpbuud %ymm2, %ymm1, %ymm0 # encoding: [0xc4,0xe2,0x74,0x50,0xc2]
; X64-NEXT:    vpaddd %ymm0, %ymm3, %ymm0 # encoding: [0xc5,0xe5,0xfe,0xc0]
; X64-NEXT:    retq # encoding: [0xc3]
  %x2 = load <8 x i32>, ptr %x2p
  %1 = call <8 x i32> @llvm.x86.avx2.vpdpbuud.256(<8 x i32> %x0, <8 x i32> %x1, <8 x i32> %x2)
  %2 = call <8 x i32> @llvm.x86.avx2.vpdpbuud.256(<8 x i32> %x0, <8 x i32> %x1, <8 x i32> %x4)
  %res = add <8 x i32> %1, %2
  ret <8 x i32> %res
}

declare <8 x i32> @llvm.x86.avx2.vpdpbuuds.256(<8 x i32>, <8 x i32>, <8 x i32>)

define <8 x i32>@test_int_x86_avx2_vpdpbuuds_256(<8 x i32> %x0, <8 x i32> %x1, ptr %x2p, <8 x i32> %x4) {
; X86-LABEL: test_int_x86_avx2_vpdpbuuds_256:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    vmovaps %ymm0, %ymm3 # encoding: [0xc5,0xfc,0x28,0xd8]
; X86-NEXT:    vpdpbuuds (%eax), %ymm1, %ymm3 # encoding: [0xc4,0xe2,0x74,0x51,0x18]
; X86-NEXT:    vpdpbuuds %ymm2, %ymm1, %ymm0 # encoding: [0xc4,0xe2,0x74,0x51,0xc2]
; X86-NEXT:    vpaddd %ymm0, %ymm3, %ymm0 # encoding: [0xc5,0xe5,0xfe,0xc0]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_int_x86_avx2_vpdpbuuds_256:
; X64:       # %bb.0:
; X64-NEXT:    vmovaps %ymm0, %ymm3 # encoding: [0xc5,0xfc,0x28,0xd8]
; X64-NEXT:    vpdpbuuds (%rdi), %ymm1, %ymm3 # encoding: [0xc4,0xe2,0x74,0x51,0x1f]
; X64-NEXT:    vpdpbuuds %ymm2, %ymm1, %ymm0 # encoding: [0xc4,0xe2,0x74,0x51,0xc2]
; X64-NEXT:    vpaddd %ymm0, %ymm3, %ymm0 # encoding: [0xc5,0xe5,0xfe,0xc0]
; X64-NEXT:    retq # encoding: [0xc3]
  %x2 = load <8 x i32>, ptr %x2p
  %1 = call <8 x i32> @llvm.x86.avx2.vpdpbuuds.256(<8 x i32> %x0, <8 x i32> %x1, <8 x i32> %x2)
  %2 = call <8 x i32> @llvm.x86.avx2.vpdpbuuds.256(<8 x i32> %x0, <8 x i32> %x1, <8 x i32> %x4)
  %res = add <8 x i32> %1, %2
  ret <8 x i32> %res
}
