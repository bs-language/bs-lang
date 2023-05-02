; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+SSE2 | FileCheck %s --check-prefix=SSE2-SSSE3
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+SSSE3 | FileCheck %s --check-prefix=SSE2-SSSE3
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefixes=AVX12,AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefixes=AVX12,AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f,+avx512vl | FileCheck %s --check-prefix=AVX512F
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f,+avx512vl,+avx512bw | FileCheck %s --check-prefix=AVX512BW

define i4 @v4i64(<4 x i64> %a, <4 x i64> %b, <4 x i64> %c, <4 x i64> %d) {
; SSE2-SSSE3-LABEL: v4i64:
; SSE2-SSSE3:       # %bb.0:
; SSE2-SSSE3-NEXT:    movdqa {{.*#+}} xmm9 = [2147483648,2147483648]
; SSE2-SSSE3-NEXT:    pxor %xmm9, %xmm3
; SSE2-SSSE3-NEXT:    pxor %xmm9, %xmm1
; SSE2-SSSE3-NEXT:    movdqa %xmm1, %xmm10
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm3, %xmm10
; SSE2-SSSE3-NEXT:    pxor %xmm9, %xmm2
; SSE2-SSSE3-NEXT:    pxor %xmm9, %xmm0
; SSE2-SSSE3-NEXT:    movdqa %xmm0, %xmm8
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm2, %xmm8
; SSE2-SSSE3-NEXT:    movdqa %xmm8, %xmm11
; SSE2-SSSE3-NEXT:    shufps {{.*#+}} xmm11 = xmm11[0,2],xmm10[0,2]
; SSE2-SSSE3-NEXT:    pcmpeqd %xmm3, %xmm1
; SSE2-SSSE3-NEXT:    pcmpeqd %xmm2, %xmm0
; SSE2-SSSE3-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,3],xmm1[1,3]
; SSE2-SSSE3-NEXT:    andps %xmm11, %xmm0
; SSE2-SSSE3-NEXT:    shufps {{.*#+}} xmm8 = xmm8[1,3],xmm10[1,3]
; SSE2-SSSE3-NEXT:    orps %xmm0, %xmm8
; SSE2-SSSE3-NEXT:    pxor %xmm9, %xmm7
; SSE2-SSSE3-NEXT:    pxor %xmm9, %xmm5
; SSE2-SSSE3-NEXT:    movdqa %xmm5, %xmm0
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm7, %xmm0
; SSE2-SSSE3-NEXT:    pxor %xmm9, %xmm6
; SSE2-SSSE3-NEXT:    pxor %xmm9, %xmm4
; SSE2-SSSE3-NEXT:    movdqa %xmm4, %xmm1
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm6, %xmm1
; SSE2-SSSE3-NEXT:    movdqa %xmm1, %xmm2
; SSE2-SSSE3-NEXT:    shufps {{.*#+}} xmm2 = xmm2[0,2],xmm0[0,2]
; SSE2-SSSE3-NEXT:    pcmpeqd %xmm7, %xmm5
; SSE2-SSSE3-NEXT:    pcmpeqd %xmm6, %xmm4
; SSE2-SSSE3-NEXT:    shufps {{.*#+}} xmm4 = xmm4[1,3],xmm5[1,3]
; SSE2-SSSE3-NEXT:    andps %xmm2, %xmm4
; SSE2-SSSE3-NEXT:    shufps {{.*#+}} xmm1 = xmm1[1,3],xmm0[1,3]
; SSE2-SSSE3-NEXT:    orps %xmm4, %xmm1
; SSE2-SSSE3-NEXT:    andps %xmm8, %xmm1
; SSE2-SSSE3-NEXT:    movmskps %xmm1, %eax
; SSE2-SSSE3-NEXT:    # kill: def $al killed $al killed $eax
; SSE2-SSSE3-NEXT:    retq
;
; AVX1-LABEL: v4i64:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm3, %xmm4
; AVX1-NEXT:    vextractf128 $1, %ymm2, %xmm5
; AVX1-NEXT:    vpcmpgtq %xmm4, %xmm5, %xmm4
; AVX1-NEXT:    vpcmpgtq %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vinsertf128 $1, %xmm4, %ymm2, %ymm2
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm3
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm4
; AVX1-NEXT:    vpcmpgtq %xmm3, %xmm4, %xmm3
; AVX1-NEXT:    vpcmpgtq %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm3, %ymm0, %ymm0
; AVX1-NEXT:    vandpd %ymm2, %ymm0, %ymm0
; AVX1-NEXT:    vmovmskpd %ymm0, %eax
; AVX1-NEXT:    # kill: def $al killed $al killed $eax
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v4i64:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpcmpgtq %ymm3, %ymm2, %ymm2
; AVX2-NEXT:    vpcmpgtq %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpand %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vmovmskpd %ymm0, %eax
; AVX2-NEXT:    # kill: def $al killed $al killed $eax
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: v4i64:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpcmpgtq %ymm1, %ymm0, %k1
; AVX512F-NEXT:    vpcmpgtq %ymm3, %ymm2, %k0 {%k1}
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v4i64:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpcmpgtq %ymm1, %ymm0, %k1
; AVX512BW-NEXT:    vpcmpgtq %ymm3, %ymm2, %k0 {%k1}
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    # kill: def $al killed $al killed $eax
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %x0 = icmp sgt <4 x i64> %a, %b
  %x1 = icmp sgt <4 x i64> %c, %d
  %y = and <4 x i1> %x0, %x1
  %res = bitcast <4 x i1> %y to i4
  ret i4 %res
}

define i4 @v4f64(<4 x double> %a, <4 x double> %b, <4 x double> %c, <4 x double> %d) {
; SSE2-SSSE3-LABEL: v4f64:
; SSE2-SSSE3:       # %bb.0:
; SSE2-SSSE3-NEXT:    cmpltpd %xmm1, %xmm3
; SSE2-SSSE3-NEXT:    cmpltpd %xmm0, %xmm2
; SSE2-SSSE3-NEXT:    shufps {{.*#+}} xmm2 = xmm2[0,2],xmm3[0,2]
; SSE2-SSSE3-NEXT:    cmpltpd %xmm5, %xmm7
; SSE2-SSSE3-NEXT:    cmpltpd %xmm4, %xmm6
; SSE2-SSSE3-NEXT:    shufps {{.*#+}} xmm6 = xmm6[0,2],xmm7[0,2]
; SSE2-SSSE3-NEXT:    andps %xmm2, %xmm6
; SSE2-SSSE3-NEXT:    movmskps %xmm6, %eax
; SSE2-SSSE3-NEXT:    # kill: def $al killed $al killed $eax
; SSE2-SSSE3-NEXT:    retq
;
; AVX12-LABEL: v4f64:
; AVX12:       # %bb.0:
; AVX12-NEXT:    vcmpltpd %ymm2, %ymm3, %ymm2
; AVX12-NEXT:    vcmpltpd %ymm0, %ymm1, %ymm0
; AVX12-NEXT:    vandpd %ymm2, %ymm0, %ymm0
; AVX12-NEXT:    vmovmskpd %ymm0, %eax
; AVX12-NEXT:    # kill: def $al killed $al killed $eax
; AVX12-NEXT:    vzeroupper
; AVX12-NEXT:    retq
;
; AVX512F-LABEL: v4f64:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vcmpltpd %ymm0, %ymm1, %k1
; AVX512F-NEXT:    vcmpltpd %ymm2, %ymm3, %k0 {%k1}
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v4f64:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vcmpltpd %ymm0, %ymm1, %k1
; AVX512BW-NEXT:    vcmpltpd %ymm2, %ymm3, %k0 {%k1}
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    # kill: def $al killed $al killed $eax
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %x0 = fcmp ogt <4 x double> %a, %b
  %x1 = fcmp ogt <4 x double> %c, %d
  %y = and <4 x i1> %x0, %x1
  %res = bitcast <4 x i1> %y to i4
  ret i4 %res
}

define i16 @v16i16(<16 x i16> %a, <16 x i16> %b, <16 x i16> %c, <16 x i16> %d) {
; SSE2-SSSE3-LABEL: v16i16:
; SSE2-SSSE3:       # %bb.0:
; SSE2-SSSE3-NEXT:    pcmpgtw %xmm3, %xmm1
; SSE2-SSSE3-NEXT:    pcmpgtw %xmm2, %xmm0
; SSE2-SSSE3-NEXT:    packsswb %xmm1, %xmm0
; SSE2-SSSE3-NEXT:    pcmpgtw %xmm7, %xmm5
; SSE2-SSSE3-NEXT:    pcmpgtw %xmm6, %xmm4
; SSE2-SSSE3-NEXT:    packsswb %xmm5, %xmm4
; SSE2-SSSE3-NEXT:    pand %xmm0, %xmm4
; SSE2-SSSE3-NEXT:    pmovmskb %xmm4, %eax
; SSE2-SSSE3-NEXT:    # kill: def $ax killed $ax killed $eax
; SSE2-SSSE3-NEXT:    retq
;
; AVX1-LABEL: v16i16:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpcmpgtw %xmm1, %xmm0, %xmm4
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpcmpgtw %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpcmpgtw %xmm3, %xmm2, %xmm1
; AVX1-NEXT:    vpand %xmm1, %xmm4, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm3, %xmm3
; AVX1-NEXT:    vextractf128 $1, %ymm2, %xmm2
; AVX1-NEXT:    vpcmpgtw %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vpand %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpacksswb %xmm0, %xmm1, %xmm0
; AVX1-NEXT:    vpmovmskb %xmm0, %eax
; AVX1-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v16i16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpcmpgtw %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpcmpgtw %ymm3, %ymm2, %ymm1
; AVX2-NEXT:    vpand %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vpacksswb %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpmovmskb %xmm0, %eax
; AVX2-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: v16i16:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpcmpgtw %ymm1, %ymm0, %ymm0
; AVX512F-NEXT:    vpcmpgtw %ymm3, %ymm2, %ymm1
; AVX512F-NEXT:    vpand %ymm1, %ymm0, %ymm0
; AVX512F-NEXT:    vpmovsxwd %ymm0, %zmm0
; AVX512F-NEXT:    vptestmd %zmm0, %zmm0, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v16i16:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpcmpgtw %ymm1, %ymm0, %k1
; AVX512BW-NEXT:    vpcmpgtw %ymm3, %ymm2, %k0 {%k1}
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %x0 = icmp sgt <16 x i16> %a, %b
  %x1 = icmp sgt <16 x i16> %c, %d
  %y = and <16 x i1> %x0, %x1
  %res = bitcast <16 x i1> %y to i16
  ret i16 %res
}

define i8 @v8i32_and(<8 x i32> %a, <8 x i32> %b, <8 x i32> %c, <8 x i32> %d) {
; SSE2-SSSE3-LABEL: v8i32_and:
; SSE2-SSSE3:       # %bb.0:
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm3, %xmm1
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm2, %xmm0
; SSE2-SSSE3-NEXT:    packssdw %xmm1, %xmm0
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm7, %xmm5
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm6, %xmm4
; SSE2-SSSE3-NEXT:    packssdw %xmm5, %xmm4
; SSE2-SSSE3-NEXT:    pand %xmm0, %xmm4
; SSE2-SSSE3-NEXT:    packsswb %xmm4, %xmm4
; SSE2-SSSE3-NEXT:    pmovmskb %xmm4, %eax
; SSE2-SSSE3-NEXT:    # kill: def $al killed $al killed $eax
; SSE2-SSSE3-NEXT:    retq
;
; AVX1-LABEL: v8i32_and:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm3, %xmm4
; AVX1-NEXT:    vextractf128 $1, %ymm2, %xmm5
; AVX1-NEXT:    vpcmpgtd %xmm4, %xmm5, %xmm4
; AVX1-NEXT:    vpcmpgtd %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vinsertf128 $1, %xmm4, %ymm2, %ymm2
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm3
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm4
; AVX1-NEXT:    vpcmpgtd %xmm3, %xmm4, %xmm3
; AVX1-NEXT:    vpcmpgtd %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm3, %ymm0, %ymm0
; AVX1-NEXT:    vandps %ymm2, %ymm0, %ymm0
; AVX1-NEXT:    vmovmskps %ymm0, %eax
; AVX1-NEXT:    # kill: def $al killed $al killed $eax
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v8i32_and:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpcmpgtd %ymm3, %ymm2, %ymm2
; AVX2-NEXT:    vpcmpgtd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpand %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vmovmskps %ymm0, %eax
; AVX2-NEXT:    # kill: def $al killed $al killed $eax
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: v8i32_and:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpcmpgtd %ymm1, %ymm0, %k1
; AVX512F-NEXT:    vpcmpgtd %ymm3, %ymm2, %k0 {%k1}
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v8i32_and:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpcmpgtd %ymm1, %ymm0, %k1
; AVX512BW-NEXT:    vpcmpgtd %ymm3, %ymm2, %k0 {%k1}
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    # kill: def $al killed $al killed $eax
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %x0 = icmp sgt <8 x i32> %a, %b
  %x1 = icmp sgt <8 x i32> %c, %d
  %y = and <8 x i1> %x0, %x1
  %res = bitcast <8 x i1> %y to i8
  ret i8 %res
}

; We should see through any bitwise logic op.

define i8 @v8i32_or(<8 x i32> %a, <8 x i32> %b, <8 x i32> %c, <8 x i32> %d) {
; SSE2-SSSE3-LABEL: v8i32_or:
; SSE2-SSSE3:       # %bb.0:
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm3, %xmm1
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm2, %xmm0
; SSE2-SSSE3-NEXT:    packssdw %xmm1, %xmm0
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm7, %xmm5
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm6, %xmm4
; SSE2-SSSE3-NEXT:    packssdw %xmm5, %xmm4
; SSE2-SSSE3-NEXT:    por %xmm0, %xmm4
; SSE2-SSSE3-NEXT:    packsswb %xmm4, %xmm4
; SSE2-SSSE3-NEXT:    pmovmskb %xmm4, %eax
; SSE2-SSSE3-NEXT:    # kill: def $al killed $al killed $eax
; SSE2-SSSE3-NEXT:    retq
;
; AVX1-LABEL: v8i32_or:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm3, %xmm4
; AVX1-NEXT:    vextractf128 $1, %ymm2, %xmm5
; AVX1-NEXT:    vpcmpgtd %xmm4, %xmm5, %xmm4
; AVX1-NEXT:    vpcmpgtd %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vinsertf128 $1, %xmm4, %ymm2, %ymm2
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm3
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm4
; AVX1-NEXT:    vpcmpgtd %xmm3, %xmm4, %xmm3
; AVX1-NEXT:    vpcmpgtd %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm3, %ymm0, %ymm0
; AVX1-NEXT:    vorps %ymm2, %ymm0, %ymm0
; AVX1-NEXT:    vmovmskps %ymm0, %eax
; AVX1-NEXT:    # kill: def $al killed $al killed $eax
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v8i32_or:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpcmpgtd %ymm3, %ymm2, %ymm2
; AVX2-NEXT:    vpcmpgtd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpor %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vmovmskps %ymm0, %eax
; AVX2-NEXT:    # kill: def $al killed $al killed $eax
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: v8i32_or:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpcmpgtd %ymm1, %ymm0, %k0
; AVX512F-NEXT:    vpcmpgtd %ymm3, %ymm2, %k1
; AVX512F-NEXT:    korw %k1, %k0, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v8i32_or:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpcmpgtd %ymm1, %ymm0, %k0
; AVX512BW-NEXT:    vpcmpgtd %ymm3, %ymm2, %k1
; AVX512BW-NEXT:    korw %k1, %k0, %k0
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    # kill: def $al killed $al killed $eax
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %x0 = icmp sgt <8 x i32> %a, %b
  %x1 = icmp sgt <8 x i32> %c, %d
  %y = or <8 x i1> %x0, %x1
  %res = bitcast <8 x i1> %y to i8
  ret i8 %res
}

; We should see through multiple bitwise logic ops.

define i8 @v8i32_or_and(<8 x i32> %a, <8 x i32> %b, <8 x i32> %c, <8 x i32> %d, <8 x i32> %e, <8 x i32> %f) {
; SSE2-SSSE3-LABEL: v8i32_or_and:
; SSE2-SSSE3:       # %bb.0:
; SSE2-SSSE3-NEXT:    movdqa {{[0-9]+}}(%rsp), %xmm8
; SSE2-SSSE3-NEXT:    movdqa {{[0-9]+}}(%rsp), %xmm9
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm3, %xmm1
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm2, %xmm0
; SSE2-SSSE3-NEXT:    packssdw %xmm1, %xmm0
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm5, %xmm7
; SSE2-SSSE3-NEXT:    pcmpgtd %xmm4, %xmm6
; SSE2-SSSE3-NEXT:    packssdw %xmm7, %xmm6
; SSE2-SSSE3-NEXT:    por %xmm0, %xmm6
; SSE2-SSSE3-NEXT:    pcmpeqd {{[0-9]+}}(%rsp), %xmm9
; SSE2-SSSE3-NEXT:    pcmpeqd {{[0-9]+}}(%rsp), %xmm8
; SSE2-SSSE3-NEXT:    packssdw %xmm9, %xmm8
; SSE2-SSSE3-NEXT:    pand %xmm6, %xmm8
; SSE2-SSSE3-NEXT:    packsswb %xmm8, %xmm8
; SSE2-SSSE3-NEXT:    pmovmskb %xmm8, %eax
; SSE2-SSSE3-NEXT:    # kill: def $al killed $al killed $eax
; SSE2-SSSE3-NEXT:    retq
;
; AVX1-LABEL: v8i32_or_and:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm2, %xmm6
; AVX1-NEXT:    vextractf128 $1, %ymm3, %xmm7
; AVX1-NEXT:    vpcmpgtd %xmm6, %xmm7, %xmm6
; AVX1-NEXT:    vpcmpgtd %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vinsertf128 $1, %xmm6, %ymm2, %ymm2
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm3
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm6
; AVX1-NEXT:    vpcmpgtd %xmm3, %xmm6, %xmm3
; AVX1-NEXT:    vpcmpgtd %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm3, %ymm0, %ymm0
; AVX1-NEXT:    vorps %ymm2, %ymm0, %ymm0
; AVX1-NEXT:    vextractf128 $1, %ymm5, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm4, %xmm2
; AVX1-NEXT:    vpcmpeqd %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vpcmpeqd %xmm5, %xmm4, %xmm2
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm2, %ymm1
; AVX1-NEXT:    vandps %ymm1, %ymm0, %ymm0
; AVX1-NEXT:    vmovmskps %ymm0, %eax
; AVX1-NEXT:    # kill: def $al killed $al killed $eax
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v8i32_or_and:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpcmpgtd %ymm2, %ymm3, %ymm2
; AVX2-NEXT:    vpcmpgtd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpor %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vpcmpeqd %ymm5, %ymm4, %ymm1
; AVX2-NEXT:    vpand %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vmovmskps %ymm0, %eax
; AVX2-NEXT:    # kill: def $al killed $al killed $eax
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: v8i32_or_and:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpcmpgtd %ymm1, %ymm0, %k0
; AVX512F-NEXT:    vpcmpgtd %ymm2, %ymm3, %k1
; AVX512F-NEXT:    korw %k1, %k0, %k1
; AVX512F-NEXT:    vpcmpeqd %ymm5, %ymm4, %k0 {%k1}
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v8i32_or_and:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpcmpgtd %ymm1, %ymm0, %k0
; AVX512BW-NEXT:    vpcmpgtd %ymm2, %ymm3, %k1
; AVX512BW-NEXT:    korw %k1, %k0, %k1
; AVX512BW-NEXT:    vpcmpeqd %ymm5, %ymm4, %k0 {%k1}
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    # kill: def $al killed $al killed $eax
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %x0 = icmp sgt <8 x i32> %a, %b
  %x1 = icmp slt <8 x i32> %c, %d
  %x2 = icmp eq <8 x i32> %e, %f
  %y = or <8 x i1> %x0, %x1
  %z = and <8 x i1> %y, %x2
  %res = bitcast <8 x i1> %z to i8
  ret i8 %res
}

; PR61104 - peek through vselect allones operand
; combineBitcastvxi1 may be called before the fold vselect(c,-1,x) --> or(c,x) vXi1 fold

define i8 @v8i32_or_vselect(<8 x i32> %a0, <8 x i32> %a1, <8 x i32> %a2) {
; SSE2-SSSE3-LABEL: v8i32_or_vselect:
; SSE2-SSSE3:       # %bb.0:
; SSE2-SSSE3-NEXT:    pcmpeqd %xmm3, %xmm1
; SSE2-SSSE3-NEXT:    pcmpeqd %xmm2, %xmm0
; SSE2-SSSE3-NEXT:    packssdw %xmm1, %xmm0
; SSE2-SSSE3-NEXT:    packssdw %xmm5, %xmm4
; SSE2-SSSE3-NEXT:    por %xmm0, %xmm4
; SSE2-SSSE3-NEXT:    packsswb %xmm4, %xmm4
; SSE2-SSSE3-NEXT:    pmovmskb %xmm4, %eax
; SSE2-SSSE3-NEXT:    # kill: def $al killed $al killed $eax
; SSE2-SSSE3-NEXT:    retq
;
; AVX1-LABEL: v8i32_or_vselect:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm3
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm4
; AVX1-NEXT:    vpcmpeqd %xmm3, %xmm4, %xmm3
; AVX1-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm3, %ymm0, %ymm0
; AVX1-NEXT:    vorps %ymm2, %ymm0, %ymm0
; AVX1-NEXT:    vmovmskps %ymm0, %eax
; AVX1-NEXT:    # kill: def $al killed $al killed $eax
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v8i32_or_vselect:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpcmpeqd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpor %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vmovmskps %ymm0, %eax
; AVX2-NEXT:    # kill: def $al killed $al killed $eax
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: v8i32_or_vselect:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpcmpeqd %ymm1, %ymm0, %k0
; AVX512F-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; AVX512F-NEXT:    vpcmpgtd %ymm2, %ymm0, %k1
; AVX512F-NEXT:    korw %k1, %k0, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v8i32_or_vselect:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpcmpeqd %ymm1, %ymm0, %k0
; AVX512BW-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; AVX512BW-NEXT:    vpcmpgtd %ymm2, %ymm0, %k1
; AVX512BW-NEXT:    korw %k1, %k0, %k0
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    # kill: def $al killed $al killed $eax
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %cmp = icmp eq <8 x i32> %a0, %a1
  %slt = icmp slt <8 x i32> %a2, zeroinitializer
  %sel = select <8 x i1> %cmp, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i1> %slt
  %res = bitcast <8 x i1> %sel to i8
  ret i8 %res
}

define i8 @v8i32_or_select(<8 x i32> %a0, <8 x i32> %a1, <8 x i32> %a2, <8 x i32> %a3, i1 %a4) {
; SSE2-SSSE3-LABEL: v8i32_or_select:
; SSE2-SSSE3:       # %bb.0:
; SSE2-SSSE3-NEXT:    pcmpeqd %xmm1, %xmm3
; SSE2-SSSE3-NEXT:    pcmpeqd %xmm0, %xmm2
; SSE2-SSSE3-NEXT:    packssdw %xmm3, %xmm2
; SSE2-SSSE3-NEXT:    packssdw %xmm7, %xmm6
; SSE2-SSSE3-NEXT:    testb $1, %dil
; SSE2-SSSE3-NEXT:    jne .LBB7_1
; SSE2-SSSE3-NEXT:  # %bb.2:
; SSE2-SSSE3-NEXT:    pxor %xmm0, %xmm0
; SSE2-SSSE3-NEXT:    jmp .LBB7_3
; SSE2-SSSE3-NEXT:  .LBB7_1:
; SSE2-SSSE3-NEXT:    pcmpeqd %xmm5, %xmm1
; SSE2-SSSE3-NEXT:    pcmpeqd %xmm4, %xmm0
; SSE2-SSSE3-NEXT:    packssdw %xmm1, %xmm0
; SSE2-SSSE3-NEXT:  .LBB7_3:
; SSE2-SSSE3-NEXT:    por %xmm2, %xmm6
; SSE2-SSSE3-NEXT:    por %xmm0, %xmm6
; SSE2-SSSE3-NEXT:    packsswb %xmm6, %xmm6
; SSE2-SSSE3-NEXT:    pmovmskb %xmm6, %eax
; SSE2-SSSE3-NEXT:    # kill: def $al killed $al killed $eax
; SSE2-SSSE3-NEXT:    retq
;
; AVX1-LABEL: v8i32_or_select:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm4
; AVX1-NEXT:    testb $1, %dil
; AVX1-NEXT:    jne .LBB7_1
; AVX1-NEXT:  # %bb.2:
; AVX1-NEXT:    vxorps %xmm2, %xmm2, %xmm2
; AVX1-NEXT:    jmp .LBB7_3
; AVX1-NEXT:  .LBB7_1:
; AVX1-NEXT:    vextractf128 $1, %ymm2, %xmm5
; AVX1-NEXT:    vpcmpeqd %xmm5, %xmm4, %xmm5
; AVX1-NEXT:    vpcmpeqd %xmm2, %xmm0, %xmm2
; AVX1-NEXT:    vinsertf128 $1, %xmm5, %ymm2, %ymm2
; AVX1-NEXT:  .LBB7_3:
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm5
; AVX1-NEXT:    vpcmpeqd %xmm5, %xmm4, %xmm4
; AVX1-NEXT:    vpcmpeqd %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm4, %ymm0, %ymm0
; AVX1-NEXT:    vorps %ymm2, %ymm3, %ymm1
; AVX1-NEXT:    vorps %ymm0, %ymm1, %ymm0
; AVX1-NEXT:    vmovmskps %ymm0, %eax
; AVX1-NEXT:    # kill: def $al killed $al killed $eax
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v8i32_or_select:
; AVX2:       # %bb.0:
; AVX2-NEXT:    testb $1, %dil
; AVX2-NEXT:    jne .LBB7_1
; AVX2-NEXT:  # %bb.2:
; AVX2-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX2-NEXT:    jmp .LBB7_3
; AVX2-NEXT:  .LBB7_1:
; AVX2-NEXT:    vpcmpeqd %ymm2, %ymm0, %ymm2
; AVX2-NEXT:  .LBB7_3:
; AVX2-NEXT:    vpcmpeqd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpor %ymm2, %ymm3, %ymm1
; AVX2-NEXT:    vpor %ymm0, %ymm1, %ymm0
; AVX2-NEXT:    vmovmskps %ymm0, %eax
; AVX2-NEXT:    # kill: def $al killed $al killed $eax
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: v8i32_or_select:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpcmpeqd %ymm1, %ymm0, %k0
; AVX512F-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX512F-NEXT:    vpcmpgtd %ymm3, %ymm1, %k1
; AVX512F-NEXT:    testb $1, %dil
; AVX512F-NEXT:    jne .LBB7_1
; AVX512F-NEXT:  # %bb.2:
; AVX512F-NEXT:    kxorw %k0, %k0, %k2
; AVX512F-NEXT:    jmp .LBB7_3
; AVX512F-NEXT:  .LBB7_1:
; AVX512F-NEXT:    vpcmpeqd %ymm2, %ymm0, %k2
; AVX512F-NEXT:  .LBB7_3:
; AVX512F-NEXT:    korw %k0, %k1, %k0
; AVX512F-NEXT:    korw %k2, %k0, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v8i32_or_select:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpcmpeqd %ymm1, %ymm0, %k0
; AVX512BW-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX512BW-NEXT:    vpcmpgtd %ymm3, %ymm1, %k1
; AVX512BW-NEXT:    testb $1, %dil
; AVX512BW-NEXT:    jne .LBB7_1
; AVX512BW-NEXT:  # %bb.2:
; AVX512BW-NEXT:    kxorw %k0, %k0, %k2
; AVX512BW-NEXT:    jmp .LBB7_3
; AVX512BW-NEXT:  .LBB7_1:
; AVX512BW-NEXT:    vpcmpeqd %ymm2, %ymm0, %k2
; AVX512BW-NEXT:  .LBB7_3:
; AVX512BW-NEXT:    korw %k0, %k1, %k0
; AVX512BW-NEXT:    korw %k2, %k0, %k0
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    # kill: def $al killed $al killed $eax
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %cmp0 = icmp eq <8 x i32> %a0, %a1
  %cmp1 = icmp eq <8 x i32> %a0, %a2
  %cmp2 = icmp slt <8 x i32> %a3, zeroinitializer
  %sel = select i1 %a4, <8 x i1> %cmp1, <8 x i1> zeroinitializer
  %or0 = or <8 x i1> %cmp2, %cmp0
  %or1 = or <8 x i1> %or0, %sel
  %res = bitcast <8 x i1> %or1 to i8
  ret i8 %res
}

define i8 @v8f32_and(<8 x float> %a, <8 x float> %b, <8 x float> %c, <8 x float> %d) {
; SSE2-SSSE3-LABEL: v8f32_and:
; SSE2-SSSE3:       # %bb.0:
; SSE2-SSSE3-NEXT:    cmpltps %xmm1, %xmm3
; SSE2-SSSE3-NEXT:    cmpltps %xmm0, %xmm2
; SSE2-SSSE3-NEXT:    packssdw %xmm3, %xmm2
; SSE2-SSSE3-NEXT:    cmpltps %xmm5, %xmm7
; SSE2-SSSE3-NEXT:    cmpltps %xmm4, %xmm6
; SSE2-SSSE3-NEXT:    packssdw %xmm7, %xmm6
; SSE2-SSSE3-NEXT:    pand %xmm2, %xmm6
; SSE2-SSSE3-NEXT:    packsswb %xmm6, %xmm6
; SSE2-SSSE3-NEXT:    pmovmskb %xmm6, %eax
; SSE2-SSSE3-NEXT:    # kill: def $al killed $al killed $eax
; SSE2-SSSE3-NEXT:    retq
;
; AVX12-LABEL: v8f32_and:
; AVX12:       # %bb.0:
; AVX12-NEXT:    vcmpltps %ymm2, %ymm3, %ymm2
; AVX12-NEXT:    vcmpltps %ymm0, %ymm1, %ymm0
; AVX12-NEXT:    vandps %ymm2, %ymm0, %ymm0
; AVX12-NEXT:    vmovmskps %ymm0, %eax
; AVX12-NEXT:    # kill: def $al killed $al killed $eax
; AVX12-NEXT:    vzeroupper
; AVX12-NEXT:    retq
;
; AVX512F-LABEL: v8f32_and:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vcmpltps %ymm0, %ymm1, %k1
; AVX512F-NEXT:    vcmpltps %ymm2, %ymm3, %k0 {%k1}
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v8f32_and:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vcmpltps %ymm0, %ymm1, %k1
; AVX512BW-NEXT:    vcmpltps %ymm2, %ymm3, %k0 {%k1}
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    # kill: def $al killed $al killed $eax
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %x0 = fcmp ogt <8 x float> %a, %b
  %x1 = fcmp ogt <8 x float> %c, %d
  %y = and <8 x i1> %x0, %x1
  %res = bitcast <8 x i1> %y to i8
  ret i8 %res
}

; We should see through any bitwise logic op.

define i8 @v8f32_xor(<8 x float> %a, <8 x float> %b, <8 x float> %c, <8 x float> %d) {
; SSE2-SSSE3-LABEL: v8f32_xor:
; SSE2-SSSE3:       # %bb.0:
; SSE2-SSSE3-NEXT:    cmpltps %xmm1, %xmm3
; SSE2-SSSE3-NEXT:    cmpltps %xmm0, %xmm2
; SSE2-SSSE3-NEXT:    packssdw %xmm3, %xmm2
; SSE2-SSSE3-NEXT:    cmpltps %xmm5, %xmm7
; SSE2-SSSE3-NEXT:    cmpltps %xmm4, %xmm6
; SSE2-SSSE3-NEXT:    packssdw %xmm7, %xmm6
; SSE2-SSSE3-NEXT:    pxor %xmm2, %xmm6
; SSE2-SSSE3-NEXT:    packsswb %xmm6, %xmm6
; SSE2-SSSE3-NEXT:    pmovmskb %xmm6, %eax
; SSE2-SSSE3-NEXT:    # kill: def $al killed $al killed $eax
; SSE2-SSSE3-NEXT:    retq
;
; AVX12-LABEL: v8f32_xor:
; AVX12:       # %bb.0:
; AVX12-NEXT:    vcmpltps %ymm2, %ymm3, %ymm2
; AVX12-NEXT:    vcmpltps %ymm0, %ymm1, %ymm0
; AVX12-NEXT:    vxorps %ymm2, %ymm0, %ymm0
; AVX12-NEXT:    vmovmskps %ymm0, %eax
; AVX12-NEXT:    # kill: def $al killed $al killed $eax
; AVX12-NEXT:    vzeroupper
; AVX12-NEXT:    retq
;
; AVX512F-LABEL: v8f32_xor:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vcmpltps %ymm0, %ymm1, %k0
; AVX512F-NEXT:    vcmpltps %ymm2, %ymm3, %k1
; AVX512F-NEXT:    kxorw %k1, %k0, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v8f32_xor:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vcmpltps %ymm0, %ymm1, %k0
; AVX512BW-NEXT:    vcmpltps %ymm2, %ymm3, %k1
; AVX512BW-NEXT:    kxorw %k1, %k0, %k0
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    # kill: def $al killed $al killed $eax
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %x0 = fcmp ogt <8 x float> %a, %b
  %x1 = fcmp ogt <8 x float> %c, %d
  %y = xor <8 x i1> %x0, %x1
  %res = bitcast <8 x i1> %y to i8
  ret i8 %res
}

; We should see through multiple bitwise logic ops.

define i8 @v8f32_xor_and(<8 x float> %a, <8 x float> %b, <8 x float> %c, <8 x float> %d, <8 x float> %e, <8 x float> %f) {
; SSE2-SSSE3-LABEL: v8f32_xor_and:
; SSE2-SSSE3:       # %bb.0:
; SSE2-SSSE3-NEXT:    movaps {{[0-9]+}}(%rsp), %xmm8
; SSE2-SSSE3-NEXT:    movaps {{[0-9]+}}(%rsp), %xmm9
; SSE2-SSSE3-NEXT:    cmpnleps %xmm3, %xmm1
; SSE2-SSSE3-NEXT:    cmpnleps %xmm2, %xmm0
; SSE2-SSSE3-NEXT:    packssdw %xmm1, %xmm0
; SSE2-SSSE3-NEXT:    movaps %xmm5, %xmm1
; SSE2-SSSE3-NEXT:    cmpeqps %xmm7, %xmm1
; SSE2-SSSE3-NEXT:    cmpunordps %xmm7, %xmm5
; SSE2-SSSE3-NEXT:    orps %xmm1, %xmm5
; SSE2-SSSE3-NEXT:    movaps %xmm4, %xmm1
; SSE2-SSSE3-NEXT:    cmpeqps %xmm6, %xmm1
; SSE2-SSSE3-NEXT:    cmpunordps %xmm6, %xmm4
; SSE2-SSSE3-NEXT:    orps %xmm1, %xmm4
; SSE2-SSSE3-NEXT:    packssdw %xmm5, %xmm4
; SSE2-SSSE3-NEXT:    pxor %xmm0, %xmm4
; SSE2-SSSE3-NEXT:    cmpltps {{[0-9]+}}(%rsp), %xmm9
; SSE2-SSSE3-NEXT:    cmpltps {{[0-9]+}}(%rsp), %xmm8
; SSE2-SSSE3-NEXT:    packssdw %xmm9, %xmm8
; SSE2-SSSE3-NEXT:    pand %xmm4, %xmm8
; SSE2-SSSE3-NEXT:    packsswb %xmm8, %xmm8
; SSE2-SSSE3-NEXT:    pmovmskb %xmm8, %eax
; SSE2-SSSE3-NEXT:    # kill: def $al killed $al killed $eax
; SSE2-SSSE3-NEXT:    retq
;
; AVX12-LABEL: v8f32_xor_and:
; AVX12:       # %bb.0:
; AVX12-NEXT:    vcmpeq_uqps %ymm3, %ymm2, %ymm2
; AVX12-NEXT:    vcmpnleps %ymm1, %ymm0, %ymm0
; AVX12-NEXT:    vxorps %ymm2, %ymm0, %ymm0
; AVX12-NEXT:    vcmpltps %ymm4, %ymm5, %ymm1
; AVX12-NEXT:    vandps %ymm1, %ymm0, %ymm0
; AVX12-NEXT:    vmovmskps %ymm0, %eax
; AVX12-NEXT:    # kill: def $al killed $al killed $eax
; AVX12-NEXT:    vzeroupper
; AVX12-NEXT:    retq
;
; AVX512F-LABEL: v8f32_xor_and:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vcmpnleps %ymm1, %ymm0, %k0
; AVX512F-NEXT:    vcmpeq_uqps %ymm3, %ymm2, %k1
; AVX512F-NEXT:    kxorw %k1, %k0, %k1
; AVX512F-NEXT:    vcmpltps %ymm4, %ymm5, %k0 {%k1}
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v8f32_xor_and:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vcmpnleps %ymm1, %ymm0, %k0
; AVX512BW-NEXT:    vcmpeq_uqps %ymm3, %ymm2, %k1
; AVX512BW-NEXT:    kxorw %k1, %k0, %k1
; AVX512BW-NEXT:    vcmpltps %ymm4, %ymm5, %k0 {%k1}
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    # kill: def $al killed $al killed $eax
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %x0 = fcmp ugt <8 x float> %a, %b
  %x1 = fcmp ueq <8 x float> %c, %d
  %x2 = fcmp ogt <8 x float> %e, %f
  %y = xor <8 x i1> %x0, %x1
  %z = and <8 x i1> %y, %x2
  %res = bitcast <8 x i1> %z to i8
  ret i8 %res
}

define i32 @v32i8(<32 x i8> %a, <32 x i8> %b, <32 x i8> %c, <32 x i8> %d) {
; SSE2-SSSE3-LABEL: v32i8:
; SSE2-SSSE3:       # %bb.0:
; SSE2-SSSE3-NEXT:    pcmpgtb %xmm2, %xmm0
; SSE2-SSSE3-NEXT:    pcmpgtb %xmm3, %xmm1
; SSE2-SSSE3-NEXT:    pcmpgtb %xmm6, %xmm4
; SSE2-SSSE3-NEXT:    pand %xmm0, %xmm4
; SSE2-SSSE3-NEXT:    pcmpgtb %xmm7, %xmm5
; SSE2-SSSE3-NEXT:    pand %xmm1, %xmm5
; SSE2-SSSE3-NEXT:    pmovmskb %xmm4, %ecx
; SSE2-SSSE3-NEXT:    pmovmskb %xmm5, %eax
; SSE2-SSSE3-NEXT:    shll $16, %eax
; SSE2-SSSE3-NEXT:    orl %ecx, %eax
; SSE2-SSSE3-NEXT:    retq
;
; AVX1-LABEL: v32i8:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm4
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm5
; AVX1-NEXT:    vpcmpgtb %xmm4, %xmm5, %xmm4
; AVX1-NEXT:    vpcmpgtb %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vextractf128 $1, %ymm3, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm2, %xmm5
; AVX1-NEXT:    vpcmpgtb %xmm1, %xmm5, %xmm1
; AVX1-NEXT:    vpand %xmm1, %xmm4, %xmm1
; AVX1-NEXT:    vpcmpgtb %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vpand %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpmovmskb %xmm0, %ecx
; AVX1-NEXT:    vpmovmskb %xmm1, %eax
; AVX1-NEXT:    shll $16, %eax
; AVX1-NEXT:    orl %ecx, %eax
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v32i8:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpcmpgtb %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpcmpgtb %ymm3, %ymm2, %ymm1
; AVX2-NEXT:    vpand %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpmovmskb %ymm0, %eax
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: v32i8:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpcmpgtb %ymm1, %ymm0, %ymm0
; AVX512F-NEXT:    vpcmpgtb %ymm3, %ymm2, %ymm1
; AVX512F-NEXT:    vpand %ymm1, %ymm0, %ymm0
; AVX512F-NEXT:    vpmovmskb %ymm0, %eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v32i8:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpcmpgtb %ymm1, %ymm0, %k1
; AVX512BW-NEXT:    vpcmpgtb %ymm3, %ymm2, %k0 {%k1}
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %x0 = icmp sgt <32 x i8> %a, %b
  %x1 = icmp sgt <32 x i8> %c, %d
  %y = and <32 x i1> %x0, %x1
  %res = bitcast <32 x i1> %y to i32
  ret i32 %res
}
