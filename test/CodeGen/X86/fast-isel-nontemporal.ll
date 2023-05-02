; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -verify-machineinstrs -mtriple=x86_64-unknown-unknown -mattr=+mmx,+sse2 -fast-isel -O0 | FileCheck %s --check-prefixes=ALL,SSE,SSE2
; RUN: llc < %s -verify-machineinstrs -mtriple=x86_64-unknown-unknown -mattr=+mmx,+sse4a -fast-isel -O0 | FileCheck %s --check-prefixes=ALL,SSE,SSE4A
; RUN: llc < %s -verify-machineinstrs -mtriple=x86_64-unknown-unknown -mattr=+mmx,+sse4.1 -fast-isel -O0 | FileCheck %s --check-prefixes=ALL,SSE,SSE41
; RUN: llc < %s -verify-machineinstrs -mtriple=x86_64-unknown-unknown -mattr=+mmx,+avx -fast-isel -O0 | FileCheck %s --check-prefixes=ALL,AVX,AVX1
; RUN: llc < %s -verify-machineinstrs -mtriple=x86_64-unknown-unknown -mattr=+mmx,+avx2 -fast-isel -O0 | FileCheck %s --check-prefixes=ALL,AVX,AVX2
; RUN: llc < %s -verify-machineinstrs -mtriple=x86_64-unknown-unknown -mattr=+mmx,+avx512vl -fast-isel -O0 | FileCheck %s --check-prefixes=ALL,AVX512
; RUN: llc < %s -verify-machineinstrs -mtriple=x86_64-unknown-unknown -mattr=+mmx,+avx512f -fast-isel -O0 | FileCheck %s --check-prefixes=ALL,AVX512
; RUN: llc < %s -verify-machineinstrs -mtriple=x86_64-unknown-unknown -mattr=+mmx,+avx512bw -fast-isel -O0 | FileCheck %s --check-prefixes=ALL,AVX512

;
; Scalar Stores
;

define void @test_nti32(ptr nocapture %ptr, i32 %X) {
; ALL-LABEL: test_nti32:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    movntil %esi, (%rdi)
; ALL-NEXT:    retq
entry:
  store i32 %X, ptr %ptr, align 4, !nontemporal !1
  ret void
}

define void @test_nti64(ptr nocapture %ptr, i64 %X) {
; ALL-LABEL: test_nti64:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    movntiq %rsi, (%rdi)
; ALL-NEXT:    retq
entry:
  store i64 %X, ptr %ptr, align 8, !nontemporal !1
  ret void
}

define void @test_ntfloat(ptr nocapture %ptr, float %X) {
; SSE2-LABEL: test_ntfloat:
; SSE2:       # %bb.0: # %entry
; SSE2-NEXT:    movss %xmm0, (%rdi)
; SSE2-NEXT:    retq
;
; SSE4A-LABEL: test_ntfloat:
; SSE4A:       # %bb.0: # %entry
; SSE4A-NEXT:    movntss %xmm0, (%rdi)
; SSE4A-NEXT:    retq
;
; SSE41-LABEL: test_ntfloat:
; SSE41:       # %bb.0: # %entry
; SSE41-NEXT:    movss %xmm0, (%rdi)
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_ntfloat:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovss %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_ntfloat:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovss %xmm0, (%rdi)
; AVX512-NEXT:    retq
entry:
  store float %X, ptr %ptr, align 4, !nontemporal !1
  ret void
}

define void @test_ntdouble(ptr nocapture %ptr, double %X) {
; SSE2-LABEL: test_ntdouble:
; SSE2:       # %bb.0: # %entry
; SSE2-NEXT:    movsd %xmm0, (%rdi)
; SSE2-NEXT:    retq
;
; SSE4A-LABEL: test_ntdouble:
; SSE4A:       # %bb.0: # %entry
; SSE4A-NEXT:    movntsd %xmm0, (%rdi)
; SSE4A-NEXT:    retq
;
; SSE41-LABEL: test_ntdouble:
; SSE41:       # %bb.0: # %entry
; SSE41-NEXT:    movsd %xmm0, (%rdi)
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_ntdouble:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovsd %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_ntdouble:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovsd %xmm0, (%rdi)
; AVX512-NEXT:    retq
entry:
  store double %X, ptr %ptr, align 8, !nontemporal !1
  ret void
}

;
; MMX Store
;

define void @test_mmx(ptr nocapture %a0, ptr nocapture %a1) {
; ALL-LABEL: test_mmx:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    movq (%rdi), %mm0
; ALL-NEXT:    psrlq $3, %mm0
; ALL-NEXT:    movntq %mm0, (%rsi)
; ALL-NEXT:    retq
entry:
  %0 = load x86_mmx, ptr %a0
  %1 = call x86_mmx @llvm.x86.mmx.psrli.q(x86_mmx %0, i32 3)
  store x86_mmx %1, ptr %a1, align 8, !nontemporal !1
  ret void
}
declare x86_mmx @llvm.x86.mmx.psrli.q(x86_mmx, i32) nounwind readnone

;
; 128-bit Vector Stores
;

define void @test_nt4xfloat(ptr nocapture %ptr, <4 x float> %X) {
; SSE-LABEL: test_nt4xfloat:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_nt4xfloat:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovntps %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_nt4xfloat:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntps %xmm0, (%rdi)
; AVX512-NEXT:    retq
entry:
  store <4 x float> %X, ptr %ptr, align 16, !nontemporal !1
  ret void
}

define void @test_nt2xdouble(ptr nocapture %ptr, <2 x double> %X) {
; SSE-LABEL: test_nt2xdouble:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movntpd %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_nt2xdouble:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovntpd %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_nt2xdouble:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntpd %xmm0, (%rdi)
; AVX512-NEXT:    retq
entry:
  store <2 x double> %X, ptr %ptr, align 16, !nontemporal !1
  ret void
}

define void @test_nt16xi8(ptr nocapture %ptr, <16 x i8> %X) {
; SSE-LABEL: test_nt16xi8:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movntdq %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_nt16xi8:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovntdq %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_nt16xi8:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntdq %xmm0, (%rdi)
; AVX512-NEXT:    retq
entry:
  store <16 x i8> %X, ptr %ptr, align 16, !nontemporal !1
  ret void
}

define void @test_nt8xi16(ptr nocapture %ptr, <8 x i16> %X) {
; SSE-LABEL: test_nt8xi16:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movntdq %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_nt8xi16:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovntdq %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_nt8xi16:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntdq %xmm0, (%rdi)
; AVX512-NEXT:    retq
entry:
  store <8 x i16> %X, ptr %ptr, align 16, !nontemporal !1
  ret void
}

define void @test_nt4xi32(ptr nocapture %ptr, <4 x i32> %X) {
; SSE-LABEL: test_nt4xi32:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movntdq %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_nt4xi32:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovntdq %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_nt4xi32:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntdq %xmm0, (%rdi)
; AVX512-NEXT:    retq
entry:
  store <4 x i32> %X, ptr %ptr, align 16, !nontemporal !1
  ret void
}

define void @test_nt2xi64(ptr nocapture %ptr, <2 x i64> %X) {
; SSE-LABEL: test_nt2xi64:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movntdq %xmm0, (%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_nt2xi64:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovntdq %xmm0, (%rdi)
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_nt2xi64:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntdq %xmm0, (%rdi)
; AVX512-NEXT:    retq
entry:
  store <2 x i64> %X, ptr %ptr, align 16, !nontemporal !1
  ret void
}

;
; 128-bit Vector Loads
;

define <4 x float> @test_load_nt4xfloat(ptr nocapture %ptr) {
; SSE2-LABEL: test_load_nt4xfloat:
; SSE2:       # %bb.0: # %entry
; SSE2-NEXT:    movaps (%rdi), %xmm0
; SSE2-NEXT:    retq
;
; SSE4A-LABEL: test_load_nt4xfloat:
; SSE4A:       # %bb.0: # %entry
; SSE4A-NEXT:    movaps (%rdi), %xmm0
; SSE4A-NEXT:    retq
;
; SSE41-LABEL: test_load_nt4xfloat:
; SSE41:       # %bb.0: # %entry
; SSE41-NEXT:    movntdqa (%rdi), %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_load_nt4xfloat:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovntdqa (%rdi), %xmm0
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_load_nt4xfloat:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntdqa (%rdi), %xmm0
; AVX512-NEXT:    retq
entry:
  %0 = load <4 x float>, ptr %ptr, align 16, !nontemporal !1
  ret <4 x float> %0
}

define <2 x double> @test_load_nt2xdouble(ptr nocapture %ptr) {
; SSE2-LABEL: test_load_nt2xdouble:
; SSE2:       # %bb.0: # %entry
; SSE2-NEXT:    movapd (%rdi), %xmm0
; SSE2-NEXT:    retq
;
; SSE4A-LABEL: test_load_nt2xdouble:
; SSE4A:       # %bb.0: # %entry
; SSE4A-NEXT:    movapd (%rdi), %xmm0
; SSE4A-NEXT:    retq
;
; SSE41-LABEL: test_load_nt2xdouble:
; SSE41:       # %bb.0: # %entry
; SSE41-NEXT:    movntdqa (%rdi), %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_load_nt2xdouble:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovntdqa (%rdi), %xmm0
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_load_nt2xdouble:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntdqa (%rdi), %xmm0
; AVX512-NEXT:    retq
entry:
  %0 = load <2 x double>, ptr %ptr, align 16, !nontemporal !1
  ret <2 x double> %0
}

define <16 x i8> @test_load_nt16xi8(ptr nocapture %ptr) {
; SSE2-LABEL: test_load_nt16xi8:
; SSE2:       # %bb.0: # %entry
; SSE2-NEXT:    movdqa (%rdi), %xmm0
; SSE2-NEXT:    retq
;
; SSE4A-LABEL: test_load_nt16xi8:
; SSE4A:       # %bb.0: # %entry
; SSE4A-NEXT:    movdqa (%rdi), %xmm0
; SSE4A-NEXT:    retq
;
; SSE41-LABEL: test_load_nt16xi8:
; SSE41:       # %bb.0: # %entry
; SSE41-NEXT:    movntdqa (%rdi), %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_load_nt16xi8:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovntdqa (%rdi), %xmm0
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_load_nt16xi8:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntdqa (%rdi), %xmm0
; AVX512-NEXT:    retq
entry:
  %0 = load <16 x i8>, ptr %ptr, align 16, !nontemporal !1
  ret <16 x i8> %0
}

define <8 x i16> @test_load_nt8xi16(ptr nocapture %ptr) {
; SSE2-LABEL: test_load_nt8xi16:
; SSE2:       # %bb.0: # %entry
; SSE2-NEXT:    movdqa (%rdi), %xmm0
; SSE2-NEXT:    retq
;
; SSE4A-LABEL: test_load_nt8xi16:
; SSE4A:       # %bb.0: # %entry
; SSE4A-NEXT:    movdqa (%rdi), %xmm0
; SSE4A-NEXT:    retq
;
; SSE41-LABEL: test_load_nt8xi16:
; SSE41:       # %bb.0: # %entry
; SSE41-NEXT:    movntdqa (%rdi), %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_load_nt8xi16:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovntdqa (%rdi), %xmm0
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_load_nt8xi16:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntdqa (%rdi), %xmm0
; AVX512-NEXT:    retq
entry:
  %0 = load <8 x i16>, ptr %ptr, align 16, !nontemporal !1
  ret <8 x i16> %0
}

define <4 x i32> @test_load_nt4xi32(ptr nocapture %ptr) {
; SSE2-LABEL: test_load_nt4xi32:
; SSE2:       # %bb.0: # %entry
; SSE2-NEXT:    movdqa (%rdi), %xmm0
; SSE2-NEXT:    retq
;
; SSE4A-LABEL: test_load_nt4xi32:
; SSE4A:       # %bb.0: # %entry
; SSE4A-NEXT:    movdqa (%rdi), %xmm0
; SSE4A-NEXT:    retq
;
; SSE41-LABEL: test_load_nt4xi32:
; SSE41:       # %bb.0: # %entry
; SSE41-NEXT:    movntdqa (%rdi), %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_load_nt4xi32:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovntdqa (%rdi), %xmm0
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_load_nt4xi32:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntdqa (%rdi), %xmm0
; AVX512-NEXT:    retq
entry:
  %0 = load <4 x i32>, ptr %ptr, align 16, !nontemporal !1
  ret <4 x i32> %0
}

define <2 x i64> @test_load_nt2xi64(ptr nocapture %ptr) {
; SSE2-LABEL: test_load_nt2xi64:
; SSE2:       # %bb.0: # %entry
; SSE2-NEXT:    movdqa (%rdi), %xmm0
; SSE2-NEXT:    retq
;
; SSE4A-LABEL: test_load_nt2xi64:
; SSE4A:       # %bb.0: # %entry
; SSE4A-NEXT:    movdqa (%rdi), %xmm0
; SSE4A-NEXT:    retq
;
; SSE41-LABEL: test_load_nt2xi64:
; SSE41:       # %bb.0: # %entry
; SSE41-NEXT:    movntdqa (%rdi), %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: test_load_nt2xi64:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovntdqa (%rdi), %xmm0
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_load_nt2xi64:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntdqa (%rdi), %xmm0
; AVX512-NEXT:    retq
entry:
  %0 = load <2 x i64>, ptr %ptr, align 16, !nontemporal !1
  ret <2 x i64> %0
}

;
; 256-bit Vector Stores
;

define void @test_nt8xfloat(ptr nocapture %ptr, <8 x float> %X) {
; SSE-LABEL: test_nt8xfloat:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    movntps %xmm1, 16(%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_nt8xfloat:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovntps %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_nt8xfloat:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntps %ymm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
entry:
  store <8 x float> %X, ptr %ptr, align 32, !nontemporal !1
  ret void
}

define void @test_nt4xdouble(ptr nocapture %ptr, <4 x double> %X) {
; SSE-LABEL: test_nt4xdouble:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movntpd %xmm0, (%rdi)
; SSE-NEXT:    movntpd %xmm1, 16(%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_nt4xdouble:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovntpd %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_nt4xdouble:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntpd %ymm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
entry:
  store <4 x double> %X, ptr %ptr, align 32, !nontemporal !1
  ret void
}

define void @test_nt32xi8(ptr nocapture %ptr, <32 x i8> %X) {
; SSE-LABEL: test_nt32xi8:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movntdq %xmm0, (%rdi)
; SSE-NEXT:    movntdq %xmm1, 16(%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_nt32xi8:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovntdq %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_nt32xi8:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntdq %ymm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
entry:
  store <32 x i8> %X, ptr %ptr, align 32, !nontemporal !1
  ret void
}

define void @test_nt16xi16(ptr nocapture %ptr, <16 x i16> %X) {
; SSE-LABEL: test_nt16xi16:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movntdq %xmm0, (%rdi)
; SSE-NEXT:    movntdq %xmm1, 16(%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_nt16xi16:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovntdq %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_nt16xi16:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntdq %ymm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
entry:
  store <16 x i16> %X, ptr %ptr, align 32, !nontemporal !1
  ret void
}

define void @test_nt8xi32(ptr nocapture %ptr, <8 x i32> %X) {
; SSE-LABEL: test_nt8xi32:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movntdq %xmm0, (%rdi)
; SSE-NEXT:    movntdq %xmm1, 16(%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_nt8xi32:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovntdq %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_nt8xi32:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntdq %ymm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
entry:
  store <8 x i32> %X, ptr %ptr, align 32, !nontemporal !1
  ret void
}

define void @test_nt4xi64(ptr nocapture %ptr, <4 x i64> %X) {
; SSE-LABEL: test_nt4xi64:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movntdq %xmm0, (%rdi)
; SSE-NEXT:    movntdq %xmm1, 16(%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_nt4xi64:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovntdq %ymm0, (%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_nt4xi64:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntdq %ymm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
entry:
  store <4 x i64> %X, ptr %ptr, align 32, !nontemporal !1
  ret void
}

;
; 256-bit Vector Loads
;

define <8 x float> @test_load_nt8xfloat(ptr nocapture %ptr) {
; SSE2-LABEL: test_load_nt8xfloat:
; SSE2:       # %bb.0: # %entry
; SSE2-NEXT:    movaps (%rdi), %xmm0
; SSE2-NEXT:    movaps 16(%rdi), %xmm1
; SSE2-NEXT:    retq
;
; SSE4A-LABEL: test_load_nt8xfloat:
; SSE4A:       # %bb.0: # %entry
; SSE4A-NEXT:    movaps (%rdi), %xmm0
; SSE4A-NEXT:    movaps 16(%rdi), %xmm1
; SSE4A-NEXT:    retq
;
; SSE41-LABEL: test_load_nt8xfloat:
; SSE41:       # %bb.0: # %entry
; SSE41-NEXT:    movntdqa (%rdi), %xmm0
; SSE41-NEXT:    movntdqa 16(%rdi), %xmm1
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test_load_nt8xfloat:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    vmovntdqa (%rdi), %xmm1
; AVX1-NEXT:    # implicit-def: $ymm0
; AVX1-NEXT:    vmovaps %xmm1, %xmm0
; AVX1-NEXT:    vmovntdqa 16(%rdi), %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_load_nt8xfloat:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    vmovntdqa (%rdi), %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test_load_nt8xfloat:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntdqa (%rdi), %ymm0
; AVX512-NEXT:    retq
entry:
  %0 = load <8 x float>, ptr %ptr, align 32, !nontemporal !1
  ret <8 x float> %0
}

define <4 x double> @test_load_nt4xdouble(ptr nocapture %ptr) {
; SSE2-LABEL: test_load_nt4xdouble:
; SSE2:       # %bb.0: # %entry
; SSE2-NEXT:    movapd (%rdi), %xmm0
; SSE2-NEXT:    movapd 16(%rdi), %xmm1
; SSE2-NEXT:    retq
;
; SSE4A-LABEL: test_load_nt4xdouble:
; SSE4A:       # %bb.0: # %entry
; SSE4A-NEXT:    movapd (%rdi), %xmm0
; SSE4A-NEXT:    movapd 16(%rdi), %xmm1
; SSE4A-NEXT:    retq
;
; SSE41-LABEL: test_load_nt4xdouble:
; SSE41:       # %bb.0: # %entry
; SSE41-NEXT:    movntdqa (%rdi), %xmm0
; SSE41-NEXT:    movntdqa 16(%rdi), %xmm1
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test_load_nt4xdouble:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    vmovntdqa (%rdi), %xmm1
; AVX1-NEXT:    # implicit-def: $ymm0
; AVX1-NEXT:    vmovaps %xmm1, %xmm0
; AVX1-NEXT:    vmovntdqa 16(%rdi), %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_load_nt4xdouble:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    vmovntdqa (%rdi), %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test_load_nt4xdouble:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntdqa (%rdi), %ymm0
; AVX512-NEXT:    retq
entry:
  %0 = load <4 x double>, ptr %ptr, align 32, !nontemporal !1
  ret <4 x double> %0
}

define <32 x i8> @test_load_nt32xi8(ptr nocapture %ptr) {
; SSE2-LABEL: test_load_nt32xi8:
; SSE2:       # %bb.0: # %entry
; SSE2-NEXT:    movaps (%rdi), %xmm0
; SSE2-NEXT:    movaps 16(%rdi), %xmm1
; SSE2-NEXT:    retq
;
; SSE4A-LABEL: test_load_nt32xi8:
; SSE4A:       # %bb.0: # %entry
; SSE4A-NEXT:    movaps (%rdi), %xmm0
; SSE4A-NEXT:    movaps 16(%rdi), %xmm1
; SSE4A-NEXT:    retq
;
; SSE41-LABEL: test_load_nt32xi8:
; SSE41:       # %bb.0: # %entry
; SSE41-NEXT:    movntdqa (%rdi), %xmm0
; SSE41-NEXT:    movntdqa 16(%rdi), %xmm1
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test_load_nt32xi8:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    vmovntdqa (%rdi), %xmm1
; AVX1-NEXT:    # implicit-def: $ymm0
; AVX1-NEXT:    vmovaps %xmm1, %xmm0
; AVX1-NEXT:    vmovntdqa 16(%rdi), %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_load_nt32xi8:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    vmovntdqa (%rdi), %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test_load_nt32xi8:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntdqa (%rdi), %ymm0
; AVX512-NEXT:    retq
entry:
  %0 = load <32 x i8>, ptr %ptr, align 32, !nontemporal !1
  ret <32 x i8> %0
}

define <16 x i16> @test_load_nt16xi16(ptr nocapture %ptr) {
; SSE2-LABEL: test_load_nt16xi16:
; SSE2:       # %bb.0: # %entry
; SSE2-NEXT:    movaps (%rdi), %xmm0
; SSE2-NEXT:    movaps 16(%rdi), %xmm1
; SSE2-NEXT:    retq
;
; SSE4A-LABEL: test_load_nt16xi16:
; SSE4A:       # %bb.0: # %entry
; SSE4A-NEXT:    movaps (%rdi), %xmm0
; SSE4A-NEXT:    movaps 16(%rdi), %xmm1
; SSE4A-NEXT:    retq
;
; SSE41-LABEL: test_load_nt16xi16:
; SSE41:       # %bb.0: # %entry
; SSE41-NEXT:    movntdqa (%rdi), %xmm0
; SSE41-NEXT:    movntdqa 16(%rdi), %xmm1
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test_load_nt16xi16:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    vmovntdqa (%rdi), %xmm1
; AVX1-NEXT:    # implicit-def: $ymm0
; AVX1-NEXT:    vmovaps %xmm1, %xmm0
; AVX1-NEXT:    vmovntdqa 16(%rdi), %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_load_nt16xi16:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    vmovntdqa (%rdi), %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test_load_nt16xi16:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntdqa (%rdi), %ymm0
; AVX512-NEXT:    retq
entry:
  %0 = load <16 x i16>, ptr %ptr, align 32, !nontemporal !1
  ret <16 x i16> %0
}

define <8 x i32> @test_load_nt8xi32(ptr nocapture %ptr) {
; SSE2-LABEL: test_load_nt8xi32:
; SSE2:       # %bb.0: # %entry
; SSE2-NEXT:    movaps (%rdi), %xmm0
; SSE2-NEXT:    movaps 16(%rdi), %xmm1
; SSE2-NEXT:    retq
;
; SSE4A-LABEL: test_load_nt8xi32:
; SSE4A:       # %bb.0: # %entry
; SSE4A-NEXT:    movaps (%rdi), %xmm0
; SSE4A-NEXT:    movaps 16(%rdi), %xmm1
; SSE4A-NEXT:    retq
;
; SSE41-LABEL: test_load_nt8xi32:
; SSE41:       # %bb.0: # %entry
; SSE41-NEXT:    movntdqa (%rdi), %xmm0
; SSE41-NEXT:    movntdqa 16(%rdi), %xmm1
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test_load_nt8xi32:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    vmovntdqa (%rdi), %xmm1
; AVX1-NEXT:    # implicit-def: $ymm0
; AVX1-NEXT:    vmovaps %xmm1, %xmm0
; AVX1-NEXT:    vmovntdqa 16(%rdi), %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_load_nt8xi32:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    vmovntdqa (%rdi), %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test_load_nt8xi32:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntdqa (%rdi), %ymm0
; AVX512-NEXT:    retq
entry:
  %0 = load <8 x i32>, ptr %ptr, align 32, !nontemporal !1
  ret <8 x i32> %0
}

define <4 x i64> @test_load_nt4xi64(ptr nocapture %ptr) {
; SSE2-LABEL: test_load_nt4xi64:
; SSE2:       # %bb.0: # %entry
; SSE2-NEXT:    movaps (%rdi), %xmm0
; SSE2-NEXT:    movaps 16(%rdi), %xmm1
; SSE2-NEXT:    retq
;
; SSE4A-LABEL: test_load_nt4xi64:
; SSE4A:       # %bb.0: # %entry
; SSE4A-NEXT:    movaps (%rdi), %xmm0
; SSE4A-NEXT:    movaps 16(%rdi), %xmm1
; SSE4A-NEXT:    retq
;
; SSE41-LABEL: test_load_nt4xi64:
; SSE41:       # %bb.0: # %entry
; SSE41-NEXT:    movntdqa (%rdi), %xmm0
; SSE41-NEXT:    movntdqa 16(%rdi), %xmm1
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test_load_nt4xi64:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    vmovntdqa (%rdi), %xmm1
; AVX1-NEXT:    # implicit-def: $ymm0
; AVX1-NEXT:    vmovaps %xmm1, %xmm0
; AVX1-NEXT:    vmovntdqa 16(%rdi), %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_load_nt4xi64:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    vmovntdqa (%rdi), %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test_load_nt4xi64:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntdqa (%rdi), %ymm0
; AVX512-NEXT:    retq
entry:
  %0 = load <4 x i64>, ptr %ptr, align 32, !nontemporal !1
  ret <4 x i64> %0
}

;
; 512-bit Vector Stores
;

define void @test_nt16xfloat(ptr nocapture %ptr, <16 x float> %X) {
; SSE-LABEL: test_nt16xfloat:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movntps %xmm0, (%rdi)
; SSE-NEXT:    movntps %xmm1, 16(%rdi)
; SSE-NEXT:    movntps %xmm2, 32(%rdi)
; SSE-NEXT:    movntps %xmm3, 48(%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_nt16xfloat:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovntps %ymm0, (%rdi)
; AVX-NEXT:    vmovntps %ymm1, 32(%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_nt16xfloat:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntps %zmm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
entry:
  store <16 x float> %X, ptr %ptr, align 64, !nontemporal !1
  ret void
}

define void @test_nt8xdouble(ptr nocapture %ptr, <8 x double> %X) {
; SSE-LABEL: test_nt8xdouble:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movntpd %xmm0, (%rdi)
; SSE-NEXT:    movntpd %xmm1, 16(%rdi)
; SSE-NEXT:    movntpd %xmm2, 32(%rdi)
; SSE-NEXT:    movntpd %xmm3, 48(%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_nt8xdouble:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovntpd %ymm0, (%rdi)
; AVX-NEXT:    vmovntpd %ymm1, 32(%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_nt8xdouble:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntpd %zmm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
entry:
  store <8 x double> %X, ptr %ptr, align 64, !nontemporal !1
  ret void
}

define void @test_nt64xi8(ptr nocapture %ptr, <64 x i8> %X) {
; SSE-LABEL: test_nt64xi8:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movntdq %xmm0, (%rdi)
; SSE-NEXT:    movntdq %xmm1, 16(%rdi)
; SSE-NEXT:    movntdq %xmm2, 32(%rdi)
; SSE-NEXT:    movntdq %xmm3, 48(%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_nt64xi8:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovntdq %ymm0, (%rdi)
; AVX-NEXT:    vmovntdq %ymm1, 32(%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_nt64xi8:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntdq %zmm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq

entry:
  store <64 x i8> %X, ptr %ptr, align 64, !nontemporal !1
  ret void
}

define void @test_nt32xi16(ptr nocapture %ptr, <32 x i16> %X) {
; SSE-LABEL: test_nt32xi16:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movntdq %xmm0, (%rdi)
; SSE-NEXT:    movntdq %xmm1, 16(%rdi)
; SSE-NEXT:    movntdq %xmm2, 32(%rdi)
; SSE-NEXT:    movntdq %xmm3, 48(%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_nt32xi16:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovntdq %ymm0, (%rdi)
; AVX-NEXT:    vmovntdq %ymm1, 32(%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_nt32xi16:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntdq %zmm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq

entry:
  store <32 x i16> %X, ptr %ptr, align 64, !nontemporal !1
  ret void
}

define void @test_nt16xi32(ptr nocapture %ptr, <16 x i32> %X) {
; SSE-LABEL: test_nt16xi32:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movntdq %xmm0, (%rdi)
; SSE-NEXT:    movntdq %xmm1, 16(%rdi)
; SSE-NEXT:    movntdq %xmm2, 32(%rdi)
; SSE-NEXT:    movntdq %xmm3, 48(%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_nt16xi32:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovntdq %ymm0, (%rdi)
; AVX-NEXT:    vmovntdq %ymm1, 32(%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_nt16xi32:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntdq %zmm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
entry:
  store <16 x i32> %X, ptr %ptr, align 64, !nontemporal !1
  ret void
}

define void @test_nt8xi64(ptr nocapture %ptr, <8 x i64> %X) {
; SSE-LABEL: test_nt8xi64:
; SSE:       # %bb.0: # %entry
; SSE-NEXT:    movntdq %xmm0, (%rdi)
; SSE-NEXT:    movntdq %xmm1, 16(%rdi)
; SSE-NEXT:    movntdq %xmm2, 32(%rdi)
; SSE-NEXT:    movntdq %xmm3, 48(%rdi)
; SSE-NEXT:    retq
;
; AVX-LABEL: test_nt8xi64:
; AVX:       # %bb.0: # %entry
; AVX-NEXT:    vmovntdq %ymm0, (%rdi)
; AVX-NEXT:    vmovntdq %ymm1, 32(%rdi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX512-LABEL: test_nt8xi64:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntdq %zmm0, (%rdi)
; AVX512-NEXT:    vzeroupper
; AVX512-NEXT:    retq
entry:
  store <8 x i64> %X, ptr %ptr, align 64, !nontemporal !1
  ret void
}

;
; 512-bit Vector Loads
;

define <16 x float> @test_load_nt16xfloat(ptr nocapture %ptr) {
; SSE2-LABEL: test_load_nt16xfloat:
; SSE2:       # %bb.0: # %entry
; SSE2-NEXT:    movaps (%rdi), %xmm0
; SSE2-NEXT:    movaps 16(%rdi), %xmm1
; SSE2-NEXT:    movaps 32(%rdi), %xmm2
; SSE2-NEXT:    movaps 48(%rdi), %xmm3
; SSE2-NEXT:    retq
;
; SSE4A-LABEL: test_load_nt16xfloat:
; SSE4A:       # %bb.0: # %entry
; SSE4A-NEXT:    movaps (%rdi), %xmm0
; SSE4A-NEXT:    movaps 16(%rdi), %xmm1
; SSE4A-NEXT:    movaps 32(%rdi), %xmm2
; SSE4A-NEXT:    movaps 48(%rdi), %xmm3
; SSE4A-NEXT:    retq
;
; SSE41-LABEL: test_load_nt16xfloat:
; SSE41:       # %bb.0: # %entry
; SSE41-NEXT:    movntdqa (%rdi), %xmm0
; SSE41-NEXT:    movntdqa 16(%rdi), %xmm1
; SSE41-NEXT:    movntdqa 32(%rdi), %xmm2
; SSE41-NEXT:    movntdqa 48(%rdi), %xmm3
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test_load_nt16xfloat:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    vmovntdqa (%rdi), %xmm1
; AVX1-NEXT:    # implicit-def: $ymm0
; AVX1-NEXT:    vmovaps %xmm1, %xmm0
; AVX1-NEXT:    vmovntdqa 16(%rdi), %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    vmovntdqa 32(%rdi), %xmm2
; AVX1-NEXT:    # implicit-def: $ymm1
; AVX1-NEXT:    vmovaps %xmm2, %xmm1
; AVX1-NEXT:    vmovntdqa 48(%rdi), %xmm2
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm1, %ymm1
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_load_nt16xfloat:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    vmovntdqa (%rdi), %ymm0
; AVX2-NEXT:    vmovntdqa 32(%rdi), %ymm1
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test_load_nt16xfloat:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntdqa (%rdi), %zmm0
; AVX512-NEXT:    retq
entry:
  %0 = load <16 x float>, ptr %ptr, align 64, !nontemporal !1
  ret <16 x float> %0
}

define <8 x double> @test_load_nt8xdouble(ptr nocapture %ptr) {
; SSE2-LABEL: test_load_nt8xdouble:
; SSE2:       # %bb.0: # %entry
; SSE2-NEXT:    movapd (%rdi), %xmm0
; SSE2-NEXT:    movapd 16(%rdi), %xmm1
; SSE2-NEXT:    movapd 32(%rdi), %xmm2
; SSE2-NEXT:    movapd 48(%rdi), %xmm3
; SSE2-NEXT:    retq
;
; SSE4A-LABEL: test_load_nt8xdouble:
; SSE4A:       # %bb.0: # %entry
; SSE4A-NEXT:    movapd (%rdi), %xmm0
; SSE4A-NEXT:    movapd 16(%rdi), %xmm1
; SSE4A-NEXT:    movapd 32(%rdi), %xmm2
; SSE4A-NEXT:    movapd 48(%rdi), %xmm3
; SSE4A-NEXT:    retq
;
; SSE41-LABEL: test_load_nt8xdouble:
; SSE41:       # %bb.0: # %entry
; SSE41-NEXT:    movntdqa (%rdi), %xmm0
; SSE41-NEXT:    movntdqa 16(%rdi), %xmm1
; SSE41-NEXT:    movntdqa 32(%rdi), %xmm2
; SSE41-NEXT:    movntdqa 48(%rdi), %xmm3
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test_load_nt8xdouble:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    vmovntdqa (%rdi), %xmm1
; AVX1-NEXT:    # implicit-def: $ymm0
; AVX1-NEXT:    vmovaps %xmm1, %xmm0
; AVX1-NEXT:    vmovntdqa 16(%rdi), %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    vmovntdqa 32(%rdi), %xmm2
; AVX1-NEXT:    # implicit-def: $ymm1
; AVX1-NEXT:    vmovaps %xmm2, %xmm1
; AVX1-NEXT:    vmovntdqa 48(%rdi), %xmm2
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm1, %ymm1
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_load_nt8xdouble:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    vmovntdqa (%rdi), %ymm0
; AVX2-NEXT:    vmovntdqa 32(%rdi), %ymm1
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test_load_nt8xdouble:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntdqa (%rdi), %zmm0
; AVX512-NEXT:    retq
entry:
  %0 = load <8 x double>, ptr %ptr, align 64, !nontemporal !1
  ret <8 x double> %0
}

define <64 x i8> @test_load_nt64xi8(ptr nocapture %ptr) {
; SSE2-LABEL: test_load_nt64xi8:
; SSE2:       # %bb.0: # %entry
; SSE2-NEXT:    movaps (%rdi), %xmm0
; SSE2-NEXT:    movaps 16(%rdi), %xmm1
; SSE2-NEXT:    movaps 32(%rdi), %xmm2
; SSE2-NEXT:    movaps 48(%rdi), %xmm3
; SSE2-NEXT:    retq
;
; SSE4A-LABEL: test_load_nt64xi8:
; SSE4A:       # %bb.0: # %entry
; SSE4A-NEXT:    movaps (%rdi), %xmm0
; SSE4A-NEXT:    movaps 16(%rdi), %xmm1
; SSE4A-NEXT:    movaps 32(%rdi), %xmm2
; SSE4A-NEXT:    movaps 48(%rdi), %xmm3
; SSE4A-NEXT:    retq
;
; SSE41-LABEL: test_load_nt64xi8:
; SSE41:       # %bb.0: # %entry
; SSE41-NEXT:    movntdqa (%rdi), %xmm0
; SSE41-NEXT:    movntdqa 16(%rdi), %xmm1
; SSE41-NEXT:    movntdqa 32(%rdi), %xmm2
; SSE41-NEXT:    movntdqa 48(%rdi), %xmm3
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test_load_nt64xi8:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    vmovntdqa (%rdi), %xmm1
; AVX1-NEXT:    # implicit-def: $ymm0
; AVX1-NEXT:    vmovaps %xmm1, %xmm0
; AVX1-NEXT:    vmovntdqa 16(%rdi), %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    vmovntdqa 32(%rdi), %xmm2
; AVX1-NEXT:    # implicit-def: $ymm1
; AVX1-NEXT:    vmovaps %xmm2, %xmm1
; AVX1-NEXT:    vmovntdqa 48(%rdi), %xmm2
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm1, %ymm1
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_load_nt64xi8:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    vmovntdqa (%rdi), %ymm0
; AVX2-NEXT:    vmovntdqa 32(%rdi), %ymm1
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test_load_nt64xi8:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntdqa (%rdi), %zmm0
; AVX512-NEXT:    retq
entry:
  %0 = load <64 x i8>, ptr %ptr, align 64, !nontemporal !1
  ret <64 x i8> %0
}

define <32 x i16> @test_load_nt32xi16(ptr nocapture %ptr) {
; SSE2-LABEL: test_load_nt32xi16:
; SSE2:       # %bb.0: # %entry
; SSE2-NEXT:    movaps (%rdi), %xmm0
; SSE2-NEXT:    movaps 16(%rdi), %xmm1
; SSE2-NEXT:    movaps 32(%rdi), %xmm2
; SSE2-NEXT:    movaps 48(%rdi), %xmm3
; SSE2-NEXT:    retq
;
; SSE4A-LABEL: test_load_nt32xi16:
; SSE4A:       # %bb.0: # %entry
; SSE4A-NEXT:    movaps (%rdi), %xmm0
; SSE4A-NEXT:    movaps 16(%rdi), %xmm1
; SSE4A-NEXT:    movaps 32(%rdi), %xmm2
; SSE4A-NEXT:    movaps 48(%rdi), %xmm3
; SSE4A-NEXT:    retq
;
; SSE41-LABEL: test_load_nt32xi16:
; SSE41:       # %bb.0: # %entry
; SSE41-NEXT:    movntdqa (%rdi), %xmm0
; SSE41-NEXT:    movntdqa 16(%rdi), %xmm1
; SSE41-NEXT:    movntdqa 32(%rdi), %xmm2
; SSE41-NEXT:    movntdqa 48(%rdi), %xmm3
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test_load_nt32xi16:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    vmovntdqa (%rdi), %xmm1
; AVX1-NEXT:    # implicit-def: $ymm0
; AVX1-NEXT:    vmovaps %xmm1, %xmm0
; AVX1-NEXT:    vmovntdqa 16(%rdi), %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    vmovntdqa 32(%rdi), %xmm2
; AVX1-NEXT:    # implicit-def: $ymm1
; AVX1-NEXT:    vmovaps %xmm2, %xmm1
; AVX1-NEXT:    vmovntdqa 48(%rdi), %xmm2
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm1, %ymm1
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_load_nt32xi16:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    vmovntdqa (%rdi), %ymm0
; AVX2-NEXT:    vmovntdqa 32(%rdi), %ymm1
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test_load_nt32xi16:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntdqa (%rdi), %zmm0
; AVX512-NEXT:    retq
entry:
  %0 = load <32 x i16>, ptr %ptr, align 64, !nontemporal !1
  ret <32 x i16> %0
}

define <16 x i32> @test_load_nt16xi32(ptr nocapture %ptr) {
; SSE2-LABEL: test_load_nt16xi32:
; SSE2:       # %bb.0: # %entry
; SSE2-NEXT:    movaps (%rdi), %xmm0
; SSE2-NEXT:    movaps 16(%rdi), %xmm1
; SSE2-NEXT:    movaps 32(%rdi), %xmm2
; SSE2-NEXT:    movaps 48(%rdi), %xmm3
; SSE2-NEXT:    retq
;
; SSE4A-LABEL: test_load_nt16xi32:
; SSE4A:       # %bb.0: # %entry
; SSE4A-NEXT:    movaps (%rdi), %xmm0
; SSE4A-NEXT:    movaps 16(%rdi), %xmm1
; SSE4A-NEXT:    movaps 32(%rdi), %xmm2
; SSE4A-NEXT:    movaps 48(%rdi), %xmm3
; SSE4A-NEXT:    retq
;
; SSE41-LABEL: test_load_nt16xi32:
; SSE41:       # %bb.0: # %entry
; SSE41-NEXT:    movntdqa (%rdi), %xmm0
; SSE41-NEXT:    movntdqa 16(%rdi), %xmm1
; SSE41-NEXT:    movntdqa 32(%rdi), %xmm2
; SSE41-NEXT:    movntdqa 48(%rdi), %xmm3
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test_load_nt16xi32:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    vmovntdqa (%rdi), %xmm1
; AVX1-NEXT:    # implicit-def: $ymm0
; AVX1-NEXT:    vmovaps %xmm1, %xmm0
; AVX1-NEXT:    vmovntdqa 16(%rdi), %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    vmovntdqa 32(%rdi), %xmm2
; AVX1-NEXT:    # implicit-def: $ymm1
; AVX1-NEXT:    vmovaps %xmm2, %xmm1
; AVX1-NEXT:    vmovntdqa 48(%rdi), %xmm2
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm1, %ymm1
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_load_nt16xi32:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    vmovntdqa (%rdi), %ymm0
; AVX2-NEXT:    vmovntdqa 32(%rdi), %ymm1
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test_load_nt16xi32:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntdqa (%rdi), %zmm0
; AVX512-NEXT:    retq
entry:
  %0 = load <16 x i32>, ptr %ptr, align 64, !nontemporal !1
  ret <16 x i32> %0
}

define <8 x i64> @test_load_nt8xi64(ptr nocapture %ptr) {
; SSE2-LABEL: test_load_nt8xi64:
; SSE2:       # %bb.0: # %entry
; SSE2-NEXT:    movaps (%rdi), %xmm0
; SSE2-NEXT:    movaps 16(%rdi), %xmm1
; SSE2-NEXT:    movaps 32(%rdi), %xmm2
; SSE2-NEXT:    movaps 48(%rdi), %xmm3
; SSE2-NEXT:    retq
;
; SSE4A-LABEL: test_load_nt8xi64:
; SSE4A:       # %bb.0: # %entry
; SSE4A-NEXT:    movaps (%rdi), %xmm0
; SSE4A-NEXT:    movaps 16(%rdi), %xmm1
; SSE4A-NEXT:    movaps 32(%rdi), %xmm2
; SSE4A-NEXT:    movaps 48(%rdi), %xmm3
; SSE4A-NEXT:    retq
;
; SSE41-LABEL: test_load_nt8xi64:
; SSE41:       # %bb.0: # %entry
; SSE41-NEXT:    movntdqa (%rdi), %xmm0
; SSE41-NEXT:    movntdqa 16(%rdi), %xmm1
; SSE41-NEXT:    movntdqa 32(%rdi), %xmm2
; SSE41-NEXT:    movntdqa 48(%rdi), %xmm3
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test_load_nt8xi64:
; AVX1:       # %bb.0: # %entry
; AVX1-NEXT:    vmovntdqa (%rdi), %xmm1
; AVX1-NEXT:    # implicit-def: $ymm0
; AVX1-NEXT:    vmovaps %xmm1, %xmm0
; AVX1-NEXT:    vmovntdqa 16(%rdi), %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    vmovntdqa 32(%rdi), %xmm2
; AVX1-NEXT:    # implicit-def: $ymm1
; AVX1-NEXT:    vmovaps %xmm2, %xmm1
; AVX1-NEXT:    vmovntdqa 48(%rdi), %xmm2
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm1, %ymm1
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_load_nt8xi64:
; AVX2:       # %bb.0: # %entry
; AVX2-NEXT:    vmovntdqa (%rdi), %ymm0
; AVX2-NEXT:    vmovntdqa 32(%rdi), %ymm1
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test_load_nt8xi64:
; AVX512:       # %bb.0: # %entry
; AVX512-NEXT:    vmovntdqa (%rdi), %zmm0
; AVX512-NEXT:    retq
entry:
  %0 = load <8 x i64>, ptr %ptr, align 64, !nontemporal !1
  ret <8 x i64> %0
}

!1 = !{i32 1}
