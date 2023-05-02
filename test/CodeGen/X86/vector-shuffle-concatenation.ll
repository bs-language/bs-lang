; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- -mattr=+sse2 | FileCheck %s --check-prefixes=SSE,SSE2,FALLBACK0
; RUN: llc < %s -mtriple=x86_64-- -mattr=+sse4.2 | FileCheck %s --check-prefixes=SSE,SSE42,FALLBACK1
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx  | FileCheck %s --check-prefixes=AVX,AVX1-ONLY,FALLBACK2
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2 | FileCheck %s --check-prefixes=AVX2,AVX2-SLOW,FALLBACK3
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2,+fast-variable-perlane-shuffle | FileCheck %s --check-prefixes=AVX2,AVX2-FAST-PERLANE,FALLBACK4
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx2,+fast-variable-crosslane-shuffle,+fast-variable-perlane-shuffle | FileCheck %s --check-prefixes=AVX2,AVX2-FAST,FALLBACK5
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx512vl | FileCheck %s --check-prefixes=AVX512F,AVX512F-SLOW,FALLBACK6
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx512vl,+fast-variable-crosslane-shuffle,+fast-variable-perlane-shuffle | FileCheck %s --check-prefixes=AVX512F,AVX512F-FAST,FALLBACK7
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx512vl,+avx512bw | FileCheck %s --check-prefixes=AVX512BW,AVX512BW-SLOW,FALLBACK8
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx512vl,+avx512bw,+fast-variable-crosslane-shuffle,+fast-variable-perlane-shuffle | FileCheck %s --check-prefixes=AVX512BW,AVX512BW-FAST,FALLBACK9

define void @concat_a_to_shuf_of_a(ptr %a.ptr, ptr %dst) {
; SSE-LABEL: concat_a_to_shuf_of_a:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa (%rdi), %xmm0
; SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; SSE-NEXT:    movdqa %xmm0, 16(%rsi)
; SSE-NEXT:    movdqa %xmm1, (%rsi)
; SSE-NEXT:    retq
;
; AVX-LABEL: concat_a_to_shuf_of_a:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovaps (%rdi), %xmm0
; AVX-NEXT:    vshufps {{.*#+}} xmm1 = xmm0[2,3,0,1]
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; AVX-NEXT:    vmovaps %ymm0, (%rsi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX2-LABEL: concat_a_to_shuf_of_a:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovaps (%rdi), %xmm0
; AVX2-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[1,0,0,1]
; AVX2-NEXT:    vmovaps %ymm0, (%rsi)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: concat_a_to_shuf_of_a:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vmovaps (%rdi), %xmm0
; AVX512F-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[1,0,0,1]
; AVX512F-NEXT:    vmovaps %ymm0, (%rsi)
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: concat_a_to_shuf_of_a:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vmovaps (%rdi), %xmm0
; AVX512BW-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[1,0,0,1]
; AVX512BW-NEXT:    vmovaps %ymm0, (%rsi)
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %a = load <2 x i64>, ptr %a.ptr, align 64
  %shuffle = shufflevector <2 x i64> %a, <2 x i64> poison, <2 x i32> <i32 1, i32 0>
  %concat = shufflevector <2 x i64> %shuffle, <2 x i64> %a, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  store <4 x i64> %concat, ptr %dst, align 64
  ret void
}
define void @concat_shuf_of_a_to_a(ptr %a.ptr, ptr %b.ptr, ptr %dst) {
; SSE-LABEL: concat_shuf_of_a_to_a:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa (%rdi), %xmm0
; SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; SSE-NEXT:    movdqa %xmm0, (%rdx)
; SSE-NEXT:    movdqa %xmm1, 16(%rdx)
; SSE-NEXT:    retq
;
; AVX-LABEL: concat_shuf_of_a_to_a:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovaps (%rdi), %xmm0
; AVX-NEXT:    vshufps {{.*#+}} xmm1 = xmm0[2,3,0,1]
; AVX-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX-NEXT:    vmovaps %ymm0, (%rdx)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX2-LABEL: concat_shuf_of_a_to_a:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovaps (%rdi), %xmm0
; AVX2-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[0,1,1,0]
; AVX2-NEXT:    vmovaps %ymm0, (%rdx)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: concat_shuf_of_a_to_a:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vmovaps (%rdi), %xmm0
; AVX512F-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[0,1,1,0]
; AVX512F-NEXT:    vmovaps %ymm0, (%rdx)
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: concat_shuf_of_a_to_a:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vmovaps (%rdi), %xmm0
; AVX512BW-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[0,1,1,0]
; AVX512BW-NEXT:    vmovaps %ymm0, (%rdx)
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %a = load <2 x i64>, ptr %a.ptr, align 64
  %b = load <2 x i64>, ptr %b.ptr, align 64
  %shuffle = shufflevector <2 x i64> %a, <2 x i64> poison, <2 x i32> <i32 1, i32 0>
  %concat = shufflevector <2 x i64> %a, <2 x i64> %shuffle, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  store <4 x i64> %concat, ptr %dst, align 64
  ret void
}

define void @concat_a_to_shuf_of_a_extrause_of_shuf(ptr %a.ptr, ptr %dst, ptr %shuf.escape.ptr) {
; SSE-LABEL: concat_a_to_shuf_of_a_extrause_of_shuf:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa (%rdi), %xmm0
; SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; SSE-NEXT:    movdqa %xmm1, (%rdx)
; SSE-NEXT:    movdqa %xmm0, 16(%rsi)
; SSE-NEXT:    movdqa %xmm1, (%rsi)
; SSE-NEXT:    retq
;
; AVX-LABEL: concat_a_to_shuf_of_a_extrause_of_shuf:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovaps (%rdi), %xmm0
; AVX-NEXT:    vshufps {{.*#+}} xmm1 = xmm0[2,3,0,1]
; AVX-NEXT:    vmovaps %xmm1, (%rdx)
; AVX-NEXT:    vmovaps %xmm0, 16(%rsi)
; AVX-NEXT:    vmovaps %xmm1, (%rsi)
; AVX-NEXT:    retq
;
; AVX2-LABEL: concat_a_to_shuf_of_a_extrause_of_shuf:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovaps (%rdi), %xmm0
; AVX2-NEXT:    vshufps {{.*#+}} xmm1 = xmm0[2,3,0,1]
; AVX2-NEXT:    vmovaps %xmm1, (%rdx)
; AVX2-NEXT:    vmovaps %xmm0, 16(%rsi)
; AVX2-NEXT:    vmovaps %xmm1, (%rsi)
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: concat_a_to_shuf_of_a_extrause_of_shuf:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vmovaps (%rdi), %xmm0
; AVX512F-NEXT:    vshufps {{.*#+}} xmm1 = xmm0[2,3,0,1]
; AVX512F-NEXT:    vmovaps %xmm1, (%rdx)
; AVX512F-NEXT:    vmovaps %xmm0, 16(%rsi)
; AVX512F-NEXT:    vmovaps %xmm1, (%rsi)
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: concat_a_to_shuf_of_a_extrause_of_shuf:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vmovaps (%rdi), %xmm0
; AVX512BW-NEXT:    vshufps {{.*#+}} xmm1 = xmm0[2,3,0,1]
; AVX512BW-NEXT:    vmovaps %xmm1, (%rdx)
; AVX512BW-NEXT:    vmovaps %xmm0, 16(%rsi)
; AVX512BW-NEXT:    vmovaps %xmm1, (%rsi)
; AVX512BW-NEXT:    retq
  %a = load <2 x i64>, ptr %a.ptr, align 64
  %shuffle = shufflevector <2 x i64> %a, <2 x i64> poison, <2 x i32> <i32 1, i32 0>
  store <2 x i64> %shuffle, ptr %shuf.escape.ptr, align 64
  %concat = shufflevector <2 x i64> %shuffle, <2 x i64> %a, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  store <4 x i64> %concat, ptr %dst, align 64
  ret void
}

define void @concat_a_to_shuf_of_ab(ptr %a.ptr, ptr %b.ptr, ptr %dst) {
; SSE2-LABEL: concat_a_to_shuf_of_ab:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movapd (%rdi), %xmm0
; SSE2-NEXT:    movapd (%rsi), %xmm1
; SSE2-NEXT:    movsd {{.*#+}} xmm1 = xmm0[0],xmm1[1]
; SSE2-NEXT:    movapd %xmm0, 16(%rdx)
; SSE2-NEXT:    movapd %xmm1, (%rdx)
; SSE2-NEXT:    retq
;
; SSE42-LABEL: concat_a_to_shuf_of_ab:
; SSE42:       # %bb.0:
; SSE42-NEXT:    movaps (%rdi), %xmm0
; SSE42-NEXT:    movaps (%rsi), %xmm1
; SSE42-NEXT:    blendps {{.*#+}} xmm1 = xmm0[0,1],xmm1[2,3]
; SSE42-NEXT:    movaps %xmm0, 16(%rdx)
; SSE42-NEXT:    movaps %xmm1, (%rdx)
; SSE42-NEXT:    retq
;
; AVX-LABEL: concat_a_to_shuf_of_ab:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovaps (%rdi), %xmm0
; AVX-NEXT:    vblendps {{.*#+}} xmm1 = xmm0[0,1],mem[2,3]
; AVX-NEXT:    vmovaps %xmm0, 16(%rdx)
; AVX-NEXT:    vmovaps %xmm1, (%rdx)
; AVX-NEXT:    retq
;
; AVX2-LABEL: concat_a_to_shuf_of_ab:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovaps (%rdi), %xmm0
; AVX2-NEXT:    vblendps {{.*#+}} xmm1 = xmm0[0,1],mem[2,3]
; AVX2-NEXT:    vmovaps %xmm0, 16(%rdx)
; AVX2-NEXT:    vmovaps %xmm1, (%rdx)
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: concat_a_to_shuf_of_ab:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vmovaps (%rdi), %xmm0
; AVX512F-NEXT:    vblendps {{.*#+}} xmm1 = xmm0[0,1],mem[2,3]
; AVX512F-NEXT:    vmovaps %xmm0, 16(%rdx)
; AVX512F-NEXT:    vmovaps %xmm1, (%rdx)
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: concat_a_to_shuf_of_ab:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vmovaps (%rdi), %xmm0
; AVX512BW-NEXT:    vblendps {{.*#+}} xmm1 = xmm0[0,1],mem[2,3]
; AVX512BW-NEXT:    vmovaps %xmm0, 16(%rdx)
; AVX512BW-NEXT:    vmovaps %xmm1, (%rdx)
; AVX512BW-NEXT:    retq
  %a = load <2 x i64>, ptr %a.ptr, align 64
  %b = load <2 x i64>, ptr %b.ptr, align 64
  %shuffle = shufflevector <2 x i64> %a, <2 x i64> %b, <2 x i32> <i32 0, i32 3>
  %concat = shufflevector <2 x i64> %shuffle, <2 x i64> %a, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  store <4 x i64> %concat, ptr %dst, align 64
  ret void
}
define void @concat_b_to_shuf_of_ab(ptr %a.ptr, ptr %b.ptr, ptr %dst) {
; SSE2-LABEL: concat_b_to_shuf_of_ab:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movaps (%rsi), %xmm0
; SSE2-NEXT:    movaps %xmm0, %xmm1
; SSE2-NEXT:    movlps {{.*#+}} xmm1 = mem[0,1],xmm1[2,3]
; SSE2-NEXT:    movaps %xmm0, 16(%rdx)
; SSE2-NEXT:    movaps %xmm1, (%rdx)
; SSE2-NEXT:    retq
;
; SSE42-LABEL: concat_b_to_shuf_of_ab:
; SSE42:       # %bb.0:
; SSE42-NEXT:    movaps (%rsi), %xmm0
; SSE42-NEXT:    movaps (%rdi), %xmm1
; SSE42-NEXT:    blendps {{.*#+}} xmm1 = xmm1[0,1],xmm0[2,3]
; SSE42-NEXT:    movaps %xmm0, 16(%rdx)
; SSE42-NEXT:    movaps %xmm1, (%rdx)
; SSE42-NEXT:    retq
;
; AVX-LABEL: concat_b_to_shuf_of_ab:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovaps (%rsi), %xmm0
; AVX-NEXT:    vblendps {{.*#+}} xmm1 = mem[0,1],xmm0[2,3]
; AVX-NEXT:    vmovaps %xmm0, 16(%rdx)
; AVX-NEXT:    vmovaps %xmm1, (%rdx)
; AVX-NEXT:    retq
;
; AVX2-LABEL: concat_b_to_shuf_of_ab:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovaps (%rsi), %xmm0
; AVX2-NEXT:    vblendps {{.*#+}} xmm1 = mem[0,1],xmm0[2,3]
; AVX2-NEXT:    vmovaps %xmm0, 16(%rdx)
; AVX2-NEXT:    vmovaps %xmm1, (%rdx)
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: concat_b_to_shuf_of_ab:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vmovaps (%rsi), %xmm0
; AVX512F-NEXT:    vblendps {{.*#+}} xmm1 = mem[0,1],xmm0[2,3]
; AVX512F-NEXT:    vmovaps %xmm0, 16(%rdx)
; AVX512F-NEXT:    vmovaps %xmm1, (%rdx)
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: concat_b_to_shuf_of_ab:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vmovaps (%rsi), %xmm0
; AVX512BW-NEXT:    vblendps {{.*#+}} xmm1 = mem[0,1],xmm0[2,3]
; AVX512BW-NEXT:    vmovaps %xmm0, 16(%rdx)
; AVX512BW-NEXT:    vmovaps %xmm1, (%rdx)
; AVX512BW-NEXT:    retq
  %a = load <2 x i64>, ptr %a.ptr, align 64
  %b = load <2 x i64>, ptr %b.ptr, align 64
  %shuffle = shufflevector <2 x i64> %a, <2 x i64> %b, <2 x i32> <i32 0, i32 3>
  %concat = shufflevector <2 x i64> %shuffle, <2 x i64> %b, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  store <4 x i64> %concat, ptr %dst, align 64
  ret void
}

define void @concat_shuf_of_ab_to_a(ptr %a.ptr, ptr %b.ptr, ptr %dst) {
; SSE2-LABEL: concat_shuf_of_ab_to_a:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movapd (%rdi), %xmm0
; SSE2-NEXT:    movapd (%rsi), %xmm1
; SSE2-NEXT:    movsd {{.*#+}} xmm1 = xmm0[0],xmm1[1]
; SSE2-NEXT:    movapd %xmm0, (%rdx)
; SSE2-NEXT:    movapd %xmm1, 16(%rdx)
; SSE2-NEXT:    retq
;
; SSE42-LABEL: concat_shuf_of_ab_to_a:
; SSE42:       # %bb.0:
; SSE42-NEXT:    movaps (%rdi), %xmm0
; SSE42-NEXT:    movaps (%rsi), %xmm1
; SSE42-NEXT:    blendps {{.*#+}} xmm1 = xmm0[0,1],xmm1[2,3]
; SSE42-NEXT:    movaps %xmm1, 16(%rdx)
; SSE42-NEXT:    movaps %xmm0, (%rdx)
; SSE42-NEXT:    retq
;
; AVX-LABEL: concat_shuf_of_ab_to_a:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovaps (%rdi), %xmm0
; AVX-NEXT:    vblendps {{.*#+}} xmm1 = xmm0[0,1],mem[2,3]
; AVX-NEXT:    vmovaps %xmm1, 16(%rdx)
; AVX-NEXT:    vmovaps %xmm0, (%rdx)
; AVX-NEXT:    retq
;
; AVX2-LABEL: concat_shuf_of_ab_to_a:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovaps (%rdi), %xmm0
; AVX2-NEXT:    vblendps {{.*#+}} xmm1 = xmm0[0,1],mem[2,3]
; AVX2-NEXT:    vmovaps %xmm1, 16(%rdx)
; AVX2-NEXT:    vmovaps %xmm0, (%rdx)
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: concat_shuf_of_ab_to_a:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vmovaps (%rdi), %xmm0
; AVX512F-NEXT:    vblendps {{.*#+}} xmm1 = xmm0[0,1],mem[2,3]
; AVX512F-NEXT:    vmovaps %xmm1, 16(%rdx)
; AVX512F-NEXT:    vmovaps %xmm0, (%rdx)
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: concat_shuf_of_ab_to_a:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vmovaps (%rdi), %xmm0
; AVX512BW-NEXT:    vblendps {{.*#+}} xmm1 = xmm0[0,1],mem[2,3]
; AVX512BW-NEXT:    vmovaps %xmm1, 16(%rdx)
; AVX512BW-NEXT:    vmovaps %xmm0, (%rdx)
; AVX512BW-NEXT:    retq
  %a = load <2 x i64>, ptr %a.ptr, align 64
  %b = load <2 x i64>, ptr %b.ptr, align 64
  %shuffle = shufflevector <2 x i64> %a, <2 x i64> %b, <2 x i32> <i32 0, i32 3>
  %concat = shufflevector <2 x i64> %a, <2 x i64> %shuffle, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  store <4 x i64> %concat, ptr %dst, align 64
  ret void
}
define void @concat_shuf_of_ab_to_b(ptr %a.ptr, ptr %b.ptr, ptr %dst) {
; SSE2-LABEL: concat_shuf_of_ab_to_b:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movaps (%rsi), %xmm0
; SSE2-NEXT:    movaps %xmm0, %xmm1
; SSE2-NEXT:    movlps {{.*#+}} xmm1 = mem[0,1],xmm1[2,3]
; SSE2-NEXT:    movaps %xmm1, 16(%rdx)
; SSE2-NEXT:    movaps %xmm0, (%rdx)
; SSE2-NEXT:    retq
;
; SSE42-LABEL: concat_shuf_of_ab_to_b:
; SSE42:       # %bb.0:
; SSE42-NEXT:    movaps (%rsi), %xmm0
; SSE42-NEXT:    movaps (%rdi), %xmm1
; SSE42-NEXT:    blendps {{.*#+}} xmm1 = xmm1[0,1],xmm0[2,3]
; SSE42-NEXT:    movaps %xmm1, 16(%rdx)
; SSE42-NEXT:    movaps %xmm0, (%rdx)
; SSE42-NEXT:    retq
;
; AVX-LABEL: concat_shuf_of_ab_to_b:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovaps (%rsi), %xmm0
; AVX-NEXT:    vblendps {{.*#+}} xmm1 = mem[0,1],xmm0[2,3]
; AVX-NEXT:    vmovaps %xmm1, 16(%rdx)
; AVX-NEXT:    vmovaps %xmm0, (%rdx)
; AVX-NEXT:    retq
;
; AVX2-LABEL: concat_shuf_of_ab_to_b:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovaps (%rsi), %xmm0
; AVX2-NEXT:    vblendps {{.*#+}} xmm1 = mem[0,1],xmm0[2,3]
; AVX2-NEXT:    vmovaps %xmm1, 16(%rdx)
; AVX2-NEXT:    vmovaps %xmm0, (%rdx)
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: concat_shuf_of_ab_to_b:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vmovaps (%rsi), %xmm0
; AVX512F-NEXT:    vblendps {{.*#+}} xmm1 = mem[0,1],xmm0[2,3]
; AVX512F-NEXT:    vmovaps %xmm1, 16(%rdx)
; AVX512F-NEXT:    vmovaps %xmm0, (%rdx)
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: concat_shuf_of_ab_to_b:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vmovaps (%rsi), %xmm0
; AVX512BW-NEXT:    vblendps {{.*#+}} xmm1 = mem[0,1],xmm0[2,3]
; AVX512BW-NEXT:    vmovaps %xmm1, 16(%rdx)
; AVX512BW-NEXT:    vmovaps %xmm0, (%rdx)
; AVX512BW-NEXT:    retq
  %a = load <2 x i64>, ptr %a.ptr, align 64
  %b = load <2 x i64>, ptr %b.ptr, align 64
  %shuffle = shufflevector <2 x i64> %a, <2 x i64> %b, <2 x i32> <i32 0, i32 3>
  %concat = shufflevector <2 x i64> %b, <2 x i64> %shuffle, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  store <4 x i64> %concat, ptr %dst, align 64
  ret void
}

define void @concat_b_to_shuf_of_a(ptr %a.ptr, ptr %b.ptr, ptr %dst) {
; SSE-LABEL: concat_b_to_shuf_of_a:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps (%rsi), %xmm0
; SSE-NEXT:    pshufd {{.*#+}} xmm1 = mem[2,3,0,1]
; SSE-NEXT:    movaps %xmm0, 16(%rdx)
; SSE-NEXT:    movdqa %xmm1, (%rdx)
; SSE-NEXT:    retq
;
; AVX-LABEL: concat_b_to_shuf_of_a:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovaps (%rsi), %xmm0
; AVX-NEXT:    vpermilps {{.*#+}} xmm1 = mem[2,3,0,1]
; AVX-NEXT:    vmovaps %xmm0, 16(%rdx)
; AVX-NEXT:    vmovaps %xmm1, (%rdx)
; AVX-NEXT:    retq
;
; AVX2-LABEL: concat_b_to_shuf_of_a:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovaps (%rsi), %xmm0
; AVX2-NEXT:    vpermilps {{.*#+}} xmm1 = mem[2,3,0,1]
; AVX2-NEXT:    vmovaps %xmm0, 16(%rdx)
; AVX2-NEXT:    vmovaps %xmm1, (%rdx)
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: concat_b_to_shuf_of_a:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vmovaps (%rsi), %xmm0
; AVX512F-NEXT:    vpermilps {{.*#+}} xmm1 = mem[2,3,0,1]
; AVX512F-NEXT:    vmovaps %xmm0, 16(%rdx)
; AVX512F-NEXT:    vmovaps %xmm1, (%rdx)
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: concat_b_to_shuf_of_a:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vmovaps (%rsi), %xmm0
; AVX512BW-NEXT:    vpermilps {{.*#+}} xmm1 = mem[2,3,0,1]
; AVX512BW-NEXT:    vmovaps %xmm0, 16(%rdx)
; AVX512BW-NEXT:    vmovaps %xmm1, (%rdx)
; AVX512BW-NEXT:    retq
  %a = load <2 x i64>, ptr %a.ptr, align 64
  %b = load <2 x i64>, ptr %b.ptr, align 64
  %shuffle = shufflevector <2 x i64> %a, <2 x i64> poison, <2 x i32> <i32 1, i32 0>
  %concat = shufflevector <2 x i64> %shuffle, <2 x i64> %b, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  store <4 x i64> %concat, ptr %dst, align 64
  ret void
}
define void @concat_shuf_of_a_to_b(ptr %a.ptr, ptr %b.ptr, ptr %dst) {
; SSE-LABEL: concat_shuf_of_a_to_b:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps (%rsi), %xmm0
; SSE-NEXT:    pshufd {{.*#+}} xmm1 = mem[2,3,0,1]
; SSE-NEXT:    movdqa %xmm1, 16(%rdx)
; SSE-NEXT:    movaps %xmm0, (%rdx)
; SSE-NEXT:    retq
;
; AVX-LABEL: concat_shuf_of_a_to_b:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovaps (%rsi), %xmm0
; AVX-NEXT:    vpermilps {{.*#+}} xmm1 = mem[2,3,0,1]
; AVX-NEXT:    vmovaps %xmm1, 16(%rdx)
; AVX-NEXT:    vmovaps %xmm0, (%rdx)
; AVX-NEXT:    retq
;
; AVX2-LABEL: concat_shuf_of_a_to_b:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovaps (%rsi), %xmm0
; AVX2-NEXT:    vpermilps {{.*#+}} xmm1 = mem[2,3,0,1]
; AVX2-NEXT:    vmovaps %xmm1, 16(%rdx)
; AVX2-NEXT:    vmovaps %xmm0, (%rdx)
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: concat_shuf_of_a_to_b:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vmovaps (%rsi), %xmm0
; AVX512F-NEXT:    vpermilps {{.*#+}} xmm1 = mem[2,3,0,1]
; AVX512F-NEXT:    vmovaps %xmm1, 16(%rdx)
; AVX512F-NEXT:    vmovaps %xmm0, (%rdx)
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: concat_shuf_of_a_to_b:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vmovaps (%rsi), %xmm0
; AVX512BW-NEXT:    vpermilps {{.*#+}} xmm1 = mem[2,3,0,1]
; AVX512BW-NEXT:    vmovaps %xmm1, 16(%rdx)
; AVX512BW-NEXT:    vmovaps %xmm0, (%rdx)
; AVX512BW-NEXT:    retq
  %a = load <2 x i64>, ptr %a.ptr, align 64
  %b = load <2 x i64>, ptr %b.ptr, align 64
  %shuffle = shufflevector <2 x i64> %a, <2 x i64> poison, <2 x i32> <i32 1, i32 0>
  %concat = shufflevector <2 x i64> %b, <2 x i64> %shuffle, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  store <4 x i64> %concat, ptr %dst, align 64
  ret void
}

define void @concat_poison_to_shuf_of_a(ptr %a.ptr, ptr %dst) {
; SSE-LABEL: concat_poison_to_shuf_of_a:
; SSE:       # %bb.0:
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = mem[2,3,0,1]
; SSE-NEXT:    movdqa %xmm0, (%rsi)
; SSE-NEXT:    retq
;
; AVX-LABEL: concat_poison_to_shuf_of_a:
; AVX:       # %bb.0:
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = mem[2,3,0,1]
; AVX-NEXT:    vmovaps %xmm0, (%rsi)
; AVX-NEXT:    retq
;
; AVX2-LABEL: concat_poison_to_shuf_of_a:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpermilps {{.*#+}} xmm0 = mem[2,3,0,1]
; AVX2-NEXT:    vmovaps %xmm0, (%rsi)
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: concat_poison_to_shuf_of_a:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpermilps {{.*#+}} xmm0 = mem[2,3,0,1]
; AVX512F-NEXT:    vmovaps %xmm0, (%rsi)
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: concat_poison_to_shuf_of_a:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpermilps {{.*#+}} xmm0 = mem[2,3,0,1]
; AVX512BW-NEXT:    vmovaps %xmm0, (%rsi)
; AVX512BW-NEXT:    retq
  %a = load <2 x i64>, ptr %a.ptr, align 64
  %shuffle = shufflevector <2 x i64> %a, <2 x i64> poison, <2 x i32> <i32 1, i32 0>
  %concat = shufflevector <2 x i64> %shuffle, <2 x i64> poison, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  store <4 x i64> %concat, ptr %dst, align 64
  ret void
}
define void @concat_shuf_of_a_to_poison(ptr %a.ptr, ptr %b.ptr, ptr %dst) {
; SSE-LABEL: concat_shuf_of_a_to_poison:
; SSE:       # %bb.0:
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = mem[2,3,0,1]
; SSE-NEXT:    movdqa %xmm0, 16(%rdx)
; SSE-NEXT:    retq
;
; AVX-LABEL: concat_shuf_of_a_to_poison:
; AVX:       # %bb.0:
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = mem[2,3,0,1]
; AVX-NEXT:    vmovaps %xmm0, 16(%rdx)
; AVX-NEXT:    retq
;
; AVX2-LABEL: concat_shuf_of_a_to_poison:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpermilps {{.*#+}} xmm0 = mem[2,3,0,1]
; AVX2-NEXT:    vmovaps %xmm0, 16(%rdx)
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: concat_shuf_of_a_to_poison:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpermilps {{.*#+}} xmm0 = mem[2,3,0,1]
; AVX512F-NEXT:    vmovaps %xmm0, 16(%rdx)
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: concat_shuf_of_a_to_poison:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpermilps {{.*#+}} xmm0 = mem[2,3,0,1]
; AVX512BW-NEXT:    vmovaps %xmm0, 16(%rdx)
; AVX512BW-NEXT:    retq
  %a = load <2 x i64>, ptr %a.ptr, align 64
  %b = load <2 x i64>, ptr %b.ptr, align 64
  %shuffle = shufflevector <2 x i64> %a, <2 x i64> poison, <2 x i32> <i32 1, i32 0>
  %concat = shufflevector <2 x i64> poison, <2 x i64> %shuffle, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  store <4 x i64> %concat, ptr %dst, align 64
  ret void
}

define void @concat_shuf_of_a_to_itself(ptr %a.ptr, ptr %dst) {
; SSE-LABEL: concat_shuf_of_a_to_itself:
; SSE:       # %bb.0:
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = mem[2,3,0,1]
; SSE-NEXT:    movdqa %xmm0, 16(%rsi)
; SSE-NEXT:    movdqa %xmm0, (%rsi)
; SSE-NEXT:    retq
;
; AVX-LABEL: concat_shuf_of_a_to_itself:
; AVX:       # %bb.0:
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = mem[2,3,0,1]
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; AVX-NEXT:    vmovaps %ymm0, (%rsi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX2-LABEL: concat_shuf_of_a_to_itself:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovaps (%rdi), %xmm0
; AVX2-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[1,0,1,0]
; AVX2-NEXT:    vmovaps %ymm0, (%rsi)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: concat_shuf_of_a_to_itself:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vmovaps (%rdi), %xmm0
; AVX512F-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[1,0,1,0]
; AVX512F-NEXT:    vmovaps %ymm0, (%rsi)
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: concat_shuf_of_a_to_itself:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vmovaps (%rdi), %xmm0
; AVX512BW-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[1,0,1,0]
; AVX512BW-NEXT:    vmovaps %ymm0, (%rsi)
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %a = load <2 x i64>, ptr %a.ptr, align 64
  %shuffle = shufflevector <2 x i64> %a, <2 x i64> poison, <2 x i32> <i32 1, i32 0>
  %concat = shufflevector <2 x i64> %shuffle, <2 x i64> %shuffle, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  store <4 x i64> %concat, ptr %dst, align 64
  ret void
}

define void @concat_aaa_to_shuf_of_a(ptr %a.ptr, ptr %dst) {
; SSE-LABEL: concat_aaa_to_shuf_of_a:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa (%rdi), %xmm0
; SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; SSE-NEXT:    movdqa %xmm0, 32(%rsi)
; SSE-NEXT:    movdqa %xmm0, 48(%rsi)
; SSE-NEXT:    movdqa %xmm0, 16(%rsi)
; SSE-NEXT:    movdqa %xmm1, (%rsi)
; SSE-NEXT:    retq
;
; AVX-LABEL: concat_aaa_to_shuf_of_a:
; AVX:       # %bb.0:
; AVX-NEXT:    vbroadcastf128 {{.*#+}} ymm0 = mem[0,1,0,1]
; AVX-NEXT:    vshufps {{.*#+}} xmm1 = xmm0[2,3,0,1]
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm1
; AVX-NEXT:    vmovaps %ymm0, 32(%rsi)
; AVX-NEXT:    vmovaps %ymm1, (%rsi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX2-LABEL: concat_aaa_to_shuf_of_a:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vbroadcastf128 {{.*#+}} ymm0 = mem[0,1,0,1]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm1 = ymm0[1,0,0,1]
; AVX2-NEXT:    vmovaps %ymm0, 32(%rsi)
; AVX2-NEXT:    vmovaps %ymm1, (%rsi)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: concat_aaa_to_shuf_of_a:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vbroadcasti128 {{.*#+}} ymm0 = mem[0,1,0,1]
; AVX512F-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; AVX512F-NEXT:    vinserti128 $1, %xmm0, %ymm1, %ymm1
; AVX512F-NEXT:    vinserti64x4 $1, %ymm0, %zmm1, %zmm0
; AVX512F-NEXT:    vmovdqa64 %zmm0, (%rsi)
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: concat_aaa_to_shuf_of_a:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vbroadcasti128 {{.*#+}} ymm0 = mem[0,1,0,1]
; AVX512BW-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; AVX512BW-NEXT:    vinserti128 $1, %xmm0, %ymm1, %ymm1
; AVX512BW-NEXT:    vinserti64x4 $1, %ymm0, %zmm1, %zmm0
; AVX512BW-NEXT:    vmovdqa64 %zmm0, (%rsi)
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %a = load <2 x i64>, ptr %a.ptr, align 64
  %shuffle = shufflevector <2 x i64> %a, <2 x i64> poison, <2 x i32> <i32 1, i32 0>
  %concat01 = shufflevector <2 x i64> %shuffle, <2 x i64> %a, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %concat23 = shufflevector <2 x i64> %a, <2 x i64> %a, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %concat = shufflevector <4 x i64> %concat01, <4 x i64> %concat23, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  store <8 x i64> %concat, ptr %dst, align 64
  ret void
}
define void @concat_shuf_of_a_to_aaa(ptr %a.ptr, ptr %dst) {
; SSE-LABEL: concat_shuf_of_a_to_aaa:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa (%rdi), %xmm0
; SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; SSE-NEXT:    movdqa %xmm0, 32(%rsi)
; SSE-NEXT:    movdqa %xmm0, 16(%rsi)
; SSE-NEXT:    movdqa %xmm0, (%rsi)
; SSE-NEXT:    movdqa %xmm1, 48(%rsi)
; SSE-NEXT:    retq
;
; AVX-LABEL: concat_shuf_of_a_to_aaa:
; AVX:       # %bb.0:
; AVX-NEXT:    vbroadcastf128 {{.*#+}} ymm0 = mem[0,1,0,1]
; AVX-NEXT:    vshufps {{.*#+}} xmm1 = xmm0[2,3,0,1]
; AVX-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm1
; AVX-NEXT:    vmovaps %ymm0, (%rsi)
; AVX-NEXT:    vmovaps %ymm1, 32(%rsi)
; AVX-NEXT:    vzeroupper
; AVX-NEXT:    retq
;
; AVX2-LABEL: concat_shuf_of_a_to_aaa:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vbroadcastf128 {{.*#+}} ymm0 = mem[0,1,0,1]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm1 = ymm0[0,1,1,0]
; AVX2-NEXT:    vmovaps %ymm0, (%rsi)
; AVX2-NEXT:    vmovaps %ymm1, 32(%rsi)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: concat_shuf_of_a_to_aaa:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vbroadcasti128 {{.*#+}} ymm0 = mem[0,1,0,1]
; AVX512F-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; AVX512F-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm1
; AVX512F-NEXT:    vinserti64x4 $1, %ymm1, %zmm0, %zmm0
; AVX512F-NEXT:    vmovdqa64 %zmm0, (%rsi)
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: concat_shuf_of_a_to_aaa:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vbroadcasti128 {{.*#+}} ymm0 = mem[0,1,0,1]
; AVX512BW-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; AVX512BW-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm1
; AVX512BW-NEXT:    vinserti64x4 $1, %ymm1, %zmm0, %zmm0
; AVX512BW-NEXT:    vmovdqa64 %zmm0, (%rsi)
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %a = load <2 x i64>, ptr %a.ptr, align 64
  %shuffle = shufflevector <2 x i64> %a, <2 x i64> poison, <2 x i32> <i32 1, i32 0>
  %concat01 = shufflevector <2 x i64> %a, <2 x i64> %a, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %concat23 = shufflevector <2 x i64> %a, <2 x i64> %shuffle, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %concat = shufflevector <4 x i64> %concat01, <4 x i64> %concat23, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  store <8 x i64> %concat, ptr %dst, align 64
  ret void
}
;; NOTE: These prefixes are unused and the list is autogenerated. Do not add tests below this line:
; AVX1-ONLY: {{.*}}
; AVX2-FAST: {{.*}}
; AVX2-FAST-PERLANE: {{.*}}
; AVX2-SLOW: {{.*}}
; AVX512BW-FAST: {{.*}}
; AVX512BW-SLOW: {{.*}}
; AVX512F-FAST: {{.*}}
; AVX512F-SLOW: {{.*}}
; FALLBACK0: {{.*}}
; FALLBACK1: {{.*}}
; FALLBACK2: {{.*}}
; FALLBACK3: {{.*}}
; FALLBACK4: {{.*}}
; FALLBACK5: {{.*}}
; FALLBACK6: {{.*}}
; FALLBACK7: {{.*}}
; FALLBACK8: {{.*}}
; FALLBACK9: {{.*}}
