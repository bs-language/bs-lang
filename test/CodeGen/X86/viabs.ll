; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+sse2     | FileCheck %s --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+ssse3    | FileCheck %s --check-prefix=SSSE3
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+sse4.1   | FileCheck %s --check-prefix=SSE41
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx      | FileCheck %s --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx2     | FileCheck %s --check-prefix=AVX2
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx512vl --show-mc-encoding | FileCheck %s --check-prefixes=AVX512,AVX512F
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx512vl,+avx512bw --show-mc-encoding | FileCheck %s --check-prefixes=AVX512,AVX512BW

define <4 x i32> @test_abs_gt_v4i32(<4 x i32> %a) nounwind {
; SSE2-LABEL: test_abs_gt_v4i32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa %xmm0, %xmm1
; SSE2-NEXT:    psrad $31, %xmm1
; SSE2-NEXT:    pxor %xmm1, %xmm0
; SSE2-NEXT:    psubd %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSSE3-LABEL: test_abs_gt_v4i32:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    pabsd %xmm0, %xmm0
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: test_abs_gt_v4i32:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pabsd %xmm0, %xmm0
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test_abs_gt_v4i32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpabsd %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_abs_gt_v4i32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpabsd %xmm0, %xmm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test_abs_gt_v4i32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpabsd %xmm0, %xmm0 # EVEX TO VEX Compression encoding: [0xc4,0xe2,0x79,0x1e,0xc0]
; AVX512-NEXT:    retq # encoding: [0xc3]
  %tmp1neg = sub <4 x i32> zeroinitializer, %a
  %b = icmp sgt <4 x i32> %a, <i32 -1, i32 -1, i32 -1, i32 -1>
  %abs = select <4 x i1> %b, <4 x i32> %a, <4 x i32> %tmp1neg
  ret <4 x i32> %abs
}

define <4 x i32> @test_abs_ge_v4i32(<4 x i32> %a) nounwind {
; SSE2-LABEL: test_abs_ge_v4i32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa %xmm0, %xmm1
; SSE2-NEXT:    psrad $31, %xmm1
; SSE2-NEXT:    pxor %xmm1, %xmm0
; SSE2-NEXT:    psubd %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSSE3-LABEL: test_abs_ge_v4i32:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    pabsd %xmm0, %xmm0
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: test_abs_ge_v4i32:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pabsd %xmm0, %xmm0
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test_abs_ge_v4i32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpabsd %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_abs_ge_v4i32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpabsd %xmm0, %xmm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test_abs_ge_v4i32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpabsd %xmm0, %xmm0 # EVEX TO VEX Compression encoding: [0xc4,0xe2,0x79,0x1e,0xc0]
; AVX512-NEXT:    retq # encoding: [0xc3]
  %tmp1neg = sub <4 x i32> zeroinitializer, %a
  %b = icmp sge <4 x i32> %a, zeroinitializer
  %abs = select <4 x i1> %b, <4 x i32> %a, <4 x i32> %tmp1neg
  ret <4 x i32> %abs
}

define <8 x i16> @test_abs_gt_v8i16(<8 x i16> %a) nounwind {
; SSE2-LABEL: test_abs_gt_v8i16:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pxor %xmm1, %xmm1
; SSE2-NEXT:    psubw %xmm0, %xmm1
; SSE2-NEXT:    pmaxsw %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSSE3-LABEL: test_abs_gt_v8i16:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    pabsw %xmm0, %xmm0
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: test_abs_gt_v8i16:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pabsw %xmm0, %xmm0
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test_abs_gt_v8i16:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpabsw %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_abs_gt_v8i16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpabsw %xmm0, %xmm0
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: test_abs_gt_v8i16:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpabsw %xmm0, %xmm0 # encoding: [0xc4,0xe2,0x79,0x1d,0xc0]
; AVX512F-NEXT:    retq # encoding: [0xc3]
;
; AVX512BW-LABEL: test_abs_gt_v8i16:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpabsw %xmm0, %xmm0 # EVEX TO VEX Compression encoding: [0xc4,0xe2,0x79,0x1d,0xc0]
; AVX512BW-NEXT:    retq # encoding: [0xc3]
  %tmp1neg = sub <8 x i16> zeroinitializer, %a
  %b = icmp sgt <8 x i16> %a, zeroinitializer
  %abs = select <8 x i1> %b, <8 x i16> %a, <8 x i16> %tmp1neg
  ret <8 x i16> %abs
}

define <16 x i8> @test_abs_lt_v16i8(<16 x i8> %a) nounwind {
; SSE2-LABEL: test_abs_lt_v16i8:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pxor %xmm1, %xmm1
; SSE2-NEXT:    psubb %xmm0, %xmm1
; SSE2-NEXT:    pminub %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSSE3-LABEL: test_abs_lt_v16i8:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    pabsb %xmm0, %xmm0
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: test_abs_lt_v16i8:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pabsb %xmm0, %xmm0
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test_abs_lt_v16i8:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpabsb %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_abs_lt_v16i8:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpabsb %xmm0, %xmm0
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: test_abs_lt_v16i8:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpabsb %xmm0, %xmm0 # encoding: [0xc4,0xe2,0x79,0x1c,0xc0]
; AVX512F-NEXT:    retq # encoding: [0xc3]
;
; AVX512BW-LABEL: test_abs_lt_v16i8:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpabsb %xmm0, %xmm0 # EVEX TO VEX Compression encoding: [0xc4,0xe2,0x79,0x1c,0xc0]
; AVX512BW-NEXT:    retq # encoding: [0xc3]
  %tmp1neg = sub <16 x i8> zeroinitializer, %a
  %b = icmp slt <16 x i8> %a, zeroinitializer
  %abs = select <16 x i1> %b, <16 x i8> %tmp1neg, <16 x i8> %a
  ret <16 x i8> %abs
}

define <4 x i32> @test_abs_le_v4i32(<4 x i32> %a) nounwind {
; SSE2-LABEL: test_abs_le_v4i32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa %xmm0, %xmm1
; SSE2-NEXT:    psrad $31, %xmm1
; SSE2-NEXT:    pxor %xmm1, %xmm0
; SSE2-NEXT:    psubd %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSSE3-LABEL: test_abs_le_v4i32:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    pabsd %xmm0, %xmm0
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: test_abs_le_v4i32:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pabsd %xmm0, %xmm0
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test_abs_le_v4i32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpabsd %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_abs_le_v4i32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpabsd %xmm0, %xmm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test_abs_le_v4i32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpabsd %xmm0, %xmm0 # EVEX TO VEX Compression encoding: [0xc4,0xe2,0x79,0x1e,0xc0]
; AVX512-NEXT:    retq # encoding: [0xc3]
  %tmp1neg = sub <4 x i32> zeroinitializer, %a
  %b = icmp sle <4 x i32> %a, zeroinitializer
  %abs = select <4 x i1> %b, <4 x i32> %tmp1neg, <4 x i32> %a
  ret <4 x i32> %abs
}

define <8 x i32> @test_abs_gt_v8i32(<8 x i32> %a) nounwind {
; SSE2-LABEL: test_abs_gt_v8i32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa %xmm0, %xmm2
; SSE2-NEXT:    psrad $31, %xmm2
; SSE2-NEXT:    pxor %xmm2, %xmm0
; SSE2-NEXT:    psubd %xmm2, %xmm0
; SSE2-NEXT:    movdqa %xmm1, %xmm2
; SSE2-NEXT:    psrad $31, %xmm2
; SSE2-NEXT:    pxor %xmm2, %xmm1
; SSE2-NEXT:    psubd %xmm2, %xmm1
; SSE2-NEXT:    retq
;
; SSSE3-LABEL: test_abs_gt_v8i32:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    pabsd %xmm0, %xmm0
; SSSE3-NEXT:    pabsd %xmm1, %xmm1
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: test_abs_gt_v8i32:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pabsd %xmm0, %xmm0
; SSE41-NEXT:    pabsd %xmm1, %xmm1
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test_abs_gt_v8i32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpabsd %xmm0, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpabsd %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_abs_gt_v8i32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpabsd %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test_abs_gt_v8i32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpabsd %ymm0, %ymm0 # EVEX TO VEX Compression encoding: [0xc4,0xe2,0x7d,0x1e,0xc0]
; AVX512-NEXT:    retq # encoding: [0xc3]
  %tmp1neg = sub <8 x i32> zeroinitializer, %a
  %b = icmp sgt <8 x i32> %a, <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>
  %abs = select <8 x i1> %b, <8 x i32> %a, <8 x i32> %tmp1neg
  ret <8 x i32> %abs
}

define <8 x i32> @test_abs_ge_v8i32(<8 x i32> %a) nounwind {
; SSE2-LABEL: test_abs_ge_v8i32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa %xmm0, %xmm2
; SSE2-NEXT:    psrad $31, %xmm2
; SSE2-NEXT:    pxor %xmm2, %xmm0
; SSE2-NEXT:    psubd %xmm2, %xmm0
; SSE2-NEXT:    movdqa %xmm1, %xmm2
; SSE2-NEXT:    psrad $31, %xmm2
; SSE2-NEXT:    pxor %xmm2, %xmm1
; SSE2-NEXT:    psubd %xmm2, %xmm1
; SSE2-NEXT:    retq
;
; SSSE3-LABEL: test_abs_ge_v8i32:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    pabsd %xmm0, %xmm0
; SSSE3-NEXT:    pabsd %xmm1, %xmm1
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: test_abs_ge_v8i32:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pabsd %xmm0, %xmm0
; SSE41-NEXT:    pabsd %xmm1, %xmm1
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test_abs_ge_v8i32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpabsd %xmm0, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpabsd %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_abs_ge_v8i32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpabsd %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test_abs_ge_v8i32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpabsd %ymm0, %ymm0 # EVEX TO VEX Compression encoding: [0xc4,0xe2,0x7d,0x1e,0xc0]
; AVX512-NEXT:    retq # encoding: [0xc3]
  %tmp1neg = sub <8 x i32> zeroinitializer, %a
  %b = icmp sge <8 x i32> %a, zeroinitializer
  %abs = select <8 x i1> %b, <8 x i32> %a, <8 x i32> %tmp1neg
  ret <8 x i32> %abs
}

define <16 x i16> @test_abs_gt_v16i16(<16 x i16> %a) nounwind {
; SSE2-LABEL: test_abs_gt_v16i16:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pxor %xmm2, %xmm2
; SSE2-NEXT:    pxor %xmm3, %xmm3
; SSE2-NEXT:    psubw %xmm0, %xmm3
; SSE2-NEXT:    pmaxsw %xmm3, %xmm0
; SSE2-NEXT:    psubw %xmm1, %xmm2
; SSE2-NEXT:    pmaxsw %xmm2, %xmm1
; SSE2-NEXT:    retq
;
; SSSE3-LABEL: test_abs_gt_v16i16:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    pabsw %xmm0, %xmm0
; SSSE3-NEXT:    pabsw %xmm1, %xmm1
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: test_abs_gt_v16i16:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pabsw %xmm0, %xmm0
; SSE41-NEXT:    pabsw %xmm1, %xmm1
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test_abs_gt_v16i16:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpabsw %xmm0, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpabsw %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_abs_gt_v16i16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpabsw %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: test_abs_gt_v16i16:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpabsw %ymm0, %ymm0 # encoding: [0xc4,0xe2,0x7d,0x1d,0xc0]
; AVX512F-NEXT:    retq # encoding: [0xc3]
;
; AVX512BW-LABEL: test_abs_gt_v16i16:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpabsw %ymm0, %ymm0 # EVEX TO VEX Compression encoding: [0xc4,0xe2,0x7d,0x1d,0xc0]
; AVX512BW-NEXT:    retq # encoding: [0xc3]
  %tmp1neg = sub <16 x i16> zeroinitializer, %a
  %b = icmp sgt <16 x i16> %a, zeroinitializer
  %abs = select <16 x i1> %b, <16 x i16> %a, <16 x i16> %tmp1neg
  ret <16 x i16> %abs
}

define <32 x i8> @test_abs_lt_v32i8(<32 x i8> %a) nounwind {
; SSE2-LABEL: test_abs_lt_v32i8:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pxor %xmm2, %xmm2
; SSE2-NEXT:    pxor %xmm3, %xmm3
; SSE2-NEXT:    psubb %xmm0, %xmm3
; SSE2-NEXT:    pminub %xmm3, %xmm0
; SSE2-NEXT:    psubb %xmm1, %xmm2
; SSE2-NEXT:    pminub %xmm2, %xmm1
; SSE2-NEXT:    retq
;
; SSSE3-LABEL: test_abs_lt_v32i8:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    pabsb %xmm0, %xmm0
; SSSE3-NEXT:    pabsb %xmm1, %xmm1
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: test_abs_lt_v32i8:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pabsb %xmm0, %xmm0
; SSE41-NEXT:    pabsb %xmm1, %xmm1
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test_abs_lt_v32i8:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpabsb %xmm0, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpabsb %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_abs_lt_v32i8:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpabsb %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: test_abs_lt_v32i8:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpabsb %ymm0, %ymm0 # encoding: [0xc4,0xe2,0x7d,0x1c,0xc0]
; AVX512F-NEXT:    retq # encoding: [0xc3]
;
; AVX512BW-LABEL: test_abs_lt_v32i8:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpabsb %ymm0, %ymm0 # EVEX TO VEX Compression encoding: [0xc4,0xe2,0x7d,0x1c,0xc0]
; AVX512BW-NEXT:    retq # encoding: [0xc3]
  %tmp1neg = sub <32 x i8> zeroinitializer, %a
  %b = icmp slt <32 x i8> %a, zeroinitializer
  %abs = select <32 x i1> %b, <32 x i8> %tmp1neg, <32 x i8> %a
  ret <32 x i8> %abs
}

define <8 x i32> @test_abs_le_v8i32(<8 x i32> %a) nounwind {
; SSE2-LABEL: test_abs_le_v8i32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa %xmm0, %xmm2
; SSE2-NEXT:    psrad $31, %xmm2
; SSE2-NEXT:    pxor %xmm2, %xmm0
; SSE2-NEXT:    psubd %xmm2, %xmm0
; SSE2-NEXT:    movdqa %xmm1, %xmm2
; SSE2-NEXT:    psrad $31, %xmm2
; SSE2-NEXT:    pxor %xmm2, %xmm1
; SSE2-NEXT:    psubd %xmm2, %xmm1
; SSE2-NEXT:    retq
;
; SSSE3-LABEL: test_abs_le_v8i32:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    pabsd %xmm0, %xmm0
; SSSE3-NEXT:    pabsd %xmm1, %xmm1
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: test_abs_le_v8i32:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pabsd %xmm0, %xmm0
; SSE41-NEXT:    pabsd %xmm1, %xmm1
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test_abs_le_v8i32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpabsd %xmm0, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpabsd %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_abs_le_v8i32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpabsd %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test_abs_le_v8i32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpabsd %ymm0, %ymm0 # EVEX TO VEX Compression encoding: [0xc4,0xe2,0x7d,0x1e,0xc0]
; AVX512-NEXT:    retq # encoding: [0xc3]
  %tmp1neg = sub <8 x i32> zeroinitializer, %a
  %b = icmp sle <8 x i32> %a, zeroinitializer
  %abs = select <8 x i1> %b, <8 x i32> %tmp1neg, <8 x i32> %a
  ret <8 x i32> %abs
}

define <16 x i32> @test_abs_le_16i32(<16 x i32> %a) nounwind {
; SSE2-LABEL: test_abs_le_16i32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa %xmm0, %xmm4
; SSE2-NEXT:    psrad $31, %xmm4
; SSE2-NEXT:    pxor %xmm4, %xmm0
; SSE2-NEXT:    psubd %xmm4, %xmm0
; SSE2-NEXT:    movdqa %xmm1, %xmm4
; SSE2-NEXT:    psrad $31, %xmm4
; SSE2-NEXT:    pxor %xmm4, %xmm1
; SSE2-NEXT:    psubd %xmm4, %xmm1
; SSE2-NEXT:    movdqa %xmm2, %xmm4
; SSE2-NEXT:    psrad $31, %xmm4
; SSE2-NEXT:    pxor %xmm4, %xmm2
; SSE2-NEXT:    psubd %xmm4, %xmm2
; SSE2-NEXT:    movdqa %xmm3, %xmm4
; SSE2-NEXT:    psrad $31, %xmm4
; SSE2-NEXT:    pxor %xmm4, %xmm3
; SSE2-NEXT:    psubd %xmm4, %xmm3
; SSE2-NEXT:    retq
;
; SSSE3-LABEL: test_abs_le_16i32:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    pabsd %xmm0, %xmm0
; SSSE3-NEXT:    pabsd %xmm1, %xmm1
; SSSE3-NEXT:    pabsd %xmm2, %xmm2
; SSSE3-NEXT:    pabsd %xmm3, %xmm3
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: test_abs_le_16i32:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pabsd %xmm0, %xmm0
; SSE41-NEXT:    pabsd %xmm1, %xmm1
; SSE41-NEXT:    pabsd %xmm2, %xmm2
; SSE41-NEXT:    pabsd %xmm3, %xmm3
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test_abs_le_16i32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpabsd %xmm0, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpabsd %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm2, %ymm0
; AVX1-NEXT:    vpabsd %xmm1, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm1
; AVX1-NEXT:    vpabsd %xmm1, %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm2, %ymm1
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_abs_le_16i32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpabsd %ymm0, %ymm0
; AVX2-NEXT:    vpabsd %ymm1, %ymm1
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test_abs_le_16i32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpabsd %zmm0, %zmm0 # encoding: [0x62,0xf2,0x7d,0x48,0x1e,0xc0]
; AVX512-NEXT:    retq # encoding: [0xc3]
  %tmp1neg = sub <16 x i32> zeroinitializer, %a
  %b = icmp sle <16 x i32> %a, zeroinitializer
  %abs = select <16 x i1> %b, <16 x i32> %tmp1neg, <16 x i32> %a
  ret <16 x i32> %abs
}

define <2 x i64> @test_abs_ge_v2i64(<2 x i64> %a) nounwind {
; SSE2-LABEL: test_abs_ge_v2i64:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa %xmm0, %xmm1
; SSE2-NEXT:    psrad $31, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; SSE2-NEXT:    pxor %xmm1, %xmm0
; SSE2-NEXT:    psubq %xmm1, %xmm0
; SSE2-NEXT:    retq
;
; SSSE3-LABEL: test_abs_ge_v2i64:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movdqa %xmm0, %xmm1
; SSSE3-NEXT:    psrad $31, %xmm1
; SSSE3-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; SSSE3-NEXT:    pxor %xmm1, %xmm0
; SSSE3-NEXT:    psubq %xmm1, %xmm0
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: test_abs_ge_v2i64:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pxor %xmm1, %xmm1
; SSE41-NEXT:    psubq %xmm0, %xmm1
; SSE41-NEXT:    blendvpd %xmm0, %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test_abs_ge_v2i64:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX1-NEXT:    vpsubq %xmm0, %xmm1, %xmm1
; AVX1-NEXT:    vblendvpd %xmm0, %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_abs_ge_v2i64:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX2-NEXT:    vpsubq %xmm0, %xmm1, %xmm1
; AVX2-NEXT:    vblendvpd %xmm0, %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test_abs_ge_v2i64:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpabsq %xmm0, %xmm0 # encoding: [0x62,0xf2,0xfd,0x08,0x1f,0xc0]
; AVX512-NEXT:    retq # encoding: [0xc3]
  %tmp1neg = sub <2 x i64> zeroinitializer, %a
  %b = icmp sge <2 x i64> %a, zeroinitializer
  %abs = select <2 x i1> %b, <2 x i64> %a, <2 x i64> %tmp1neg
  ret <2 x i64> %abs
}

define <4 x i64> @test_abs_gt_v4i64(<4 x i64> %a) nounwind {
; SSE2-LABEL: test_abs_gt_v4i64:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa %xmm0, %xmm2
; SSE2-NEXT:    psrad $31, %xmm2
; SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; SSE2-NEXT:    pxor %xmm2, %xmm0
; SSE2-NEXT:    psubq %xmm2, %xmm0
; SSE2-NEXT:    movdqa %xmm1, %xmm2
; SSE2-NEXT:    psrad $31, %xmm2
; SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; SSE2-NEXT:    pxor %xmm2, %xmm1
; SSE2-NEXT:    psubq %xmm2, %xmm1
; SSE2-NEXT:    retq
;
; SSSE3-LABEL: test_abs_gt_v4i64:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movdqa %xmm0, %xmm2
; SSSE3-NEXT:    psrad $31, %xmm2
; SSSE3-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; SSSE3-NEXT:    pxor %xmm2, %xmm0
; SSSE3-NEXT:    psubq %xmm2, %xmm0
; SSSE3-NEXT:    movdqa %xmm1, %xmm2
; SSSE3-NEXT:    psrad $31, %xmm2
; SSSE3-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[1,1,3,3]
; SSSE3-NEXT:    pxor %xmm2, %xmm1
; SSSE3-NEXT:    psubq %xmm2, %xmm1
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: test_abs_gt_v4i64:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movdqa %xmm0, %xmm2
; SSE41-NEXT:    pxor %xmm3, %xmm3
; SSE41-NEXT:    pxor %xmm4, %xmm4
; SSE41-NEXT:    psubq %xmm0, %xmm4
; SSE41-NEXT:    blendvpd %xmm0, %xmm4, %xmm2
; SSE41-NEXT:    psubq %xmm1, %xmm3
; SSE41-NEXT:    movdqa %xmm1, %xmm0
; SSE41-NEXT:    blendvpd %xmm0, %xmm3, %xmm1
; SSE41-NEXT:    movapd %xmm2, %xmm0
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test_abs_gt_v4i64:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX1-NEXT:    vpsubq %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vpsubq %xmm0, %xmm2, %xmm2
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm2, %ymm1
; AVX1-NEXT:    vblendvpd %ymm0, %ymm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_abs_gt_v4i64:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX2-NEXT:    vpsubq %ymm0, %ymm1, %ymm1
; AVX2-NEXT:    vblendvpd %ymm0, %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test_abs_gt_v4i64:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpabsq %ymm0, %ymm0 # encoding: [0x62,0xf2,0xfd,0x28,0x1f,0xc0]
; AVX512-NEXT:    retq # encoding: [0xc3]
  %tmp1neg = sub <4 x i64> zeroinitializer, %a
  %b = icmp sgt <4 x i64> %a, <i64 -1, i64 -1, i64 -1, i64 -1>
  %abs = select <4 x i1> %b, <4 x i64> %a, <4 x i64> %tmp1neg
  ret <4 x i64> %abs
}

define <8 x i64> @test_abs_le_v8i64(<8 x i64> %a) nounwind {
; SSE2-LABEL: test_abs_le_v8i64:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa %xmm0, %xmm4
; SSE2-NEXT:    psrad $31, %xmm4
; SSE2-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[1,1,3,3]
; SSE2-NEXT:    pxor %xmm4, %xmm0
; SSE2-NEXT:    psubq %xmm4, %xmm0
; SSE2-NEXT:    movdqa %xmm1, %xmm4
; SSE2-NEXT:    psrad $31, %xmm4
; SSE2-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[1,1,3,3]
; SSE2-NEXT:    pxor %xmm4, %xmm1
; SSE2-NEXT:    psubq %xmm4, %xmm1
; SSE2-NEXT:    movdqa %xmm2, %xmm4
; SSE2-NEXT:    psrad $31, %xmm4
; SSE2-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[1,1,3,3]
; SSE2-NEXT:    pxor %xmm4, %xmm2
; SSE2-NEXT:    psubq %xmm4, %xmm2
; SSE2-NEXT:    movdqa %xmm3, %xmm4
; SSE2-NEXT:    psrad $31, %xmm4
; SSE2-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[1,1,3,3]
; SSE2-NEXT:    pxor %xmm4, %xmm3
; SSE2-NEXT:    psubq %xmm4, %xmm3
; SSE2-NEXT:    retq
;
; SSSE3-LABEL: test_abs_le_v8i64:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movdqa %xmm0, %xmm4
; SSSE3-NEXT:    psrad $31, %xmm4
; SSSE3-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[1,1,3,3]
; SSSE3-NEXT:    pxor %xmm4, %xmm0
; SSSE3-NEXT:    psubq %xmm4, %xmm0
; SSSE3-NEXT:    movdqa %xmm1, %xmm4
; SSSE3-NEXT:    psrad $31, %xmm4
; SSSE3-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[1,1,3,3]
; SSSE3-NEXT:    pxor %xmm4, %xmm1
; SSSE3-NEXT:    psubq %xmm4, %xmm1
; SSSE3-NEXT:    movdqa %xmm2, %xmm4
; SSSE3-NEXT:    psrad $31, %xmm4
; SSSE3-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[1,1,3,3]
; SSSE3-NEXT:    pxor %xmm4, %xmm2
; SSSE3-NEXT:    psubq %xmm4, %xmm2
; SSSE3-NEXT:    movdqa %xmm3, %xmm4
; SSSE3-NEXT:    psrad $31, %xmm4
; SSSE3-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[1,1,3,3]
; SSSE3-NEXT:    pxor %xmm4, %xmm3
; SSSE3-NEXT:    psubq %xmm4, %xmm3
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: test_abs_le_v8i64:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movdqa %xmm0, %xmm4
; SSE41-NEXT:    pxor %xmm5, %xmm5
; SSE41-NEXT:    pxor %xmm6, %xmm6
; SSE41-NEXT:    psubq %xmm0, %xmm6
; SSE41-NEXT:    blendvpd %xmm0, %xmm6, %xmm4
; SSE41-NEXT:    pxor %xmm6, %xmm6
; SSE41-NEXT:    psubq %xmm1, %xmm6
; SSE41-NEXT:    movdqa %xmm1, %xmm0
; SSE41-NEXT:    blendvpd %xmm0, %xmm6, %xmm1
; SSE41-NEXT:    pxor %xmm6, %xmm6
; SSE41-NEXT:    psubq %xmm2, %xmm6
; SSE41-NEXT:    movdqa %xmm2, %xmm0
; SSE41-NEXT:    blendvpd %xmm0, %xmm6, %xmm2
; SSE41-NEXT:    psubq %xmm3, %xmm5
; SSE41-NEXT:    movdqa %xmm3, %xmm0
; SSE41-NEXT:    blendvpd %xmm0, %xmm5, %xmm3
; SSE41-NEXT:    movapd %xmm4, %xmm0
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test_abs_le_v8i64:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm2
; AVX1-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX1-NEXT:    vpsubq %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpsubq %xmm0, %xmm3, %xmm4
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm4, %ymm2
; AVX1-NEXT:    vblendvpd %ymm0, %ymm2, %ymm0, %ymm0
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX1-NEXT:    vpsubq %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpsubq %xmm1, %xmm3, %xmm3
; AVX1-NEXT:    vinsertf128 $1, %xmm2, %ymm3, %ymm2
; AVX1-NEXT:    vblendvpd %ymm1, %ymm2, %ymm1, %ymm1
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_abs_le_v8i64:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX2-NEXT:    vpsubq %ymm0, %ymm2, %ymm3
; AVX2-NEXT:    vblendvpd %ymm0, %ymm3, %ymm0, %ymm0
; AVX2-NEXT:    vpsubq %ymm1, %ymm2, %ymm2
; AVX2-NEXT:    vblendvpd %ymm1, %ymm2, %ymm1, %ymm1
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test_abs_le_v8i64:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpabsq %zmm0, %zmm0 # encoding: [0x62,0xf2,0xfd,0x48,0x1f,0xc0]
; AVX512-NEXT:    retq # encoding: [0xc3]
  %tmp1neg = sub <8 x i64> zeroinitializer, %a
  %b = icmp sle <8 x i64> %a, zeroinitializer
  %abs = select <8 x i1> %b, <8 x i64> %tmp1neg, <8 x i64> %a
  ret <8 x i64> %abs
}

define <8 x i64> @test_abs_le_v8i64_fold(ptr %a.ptr) nounwind {
; SSE2-LABEL: test_abs_le_v8i64_fold:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqu (%rdi), %xmm0
; SSE2-NEXT:    movdqu 16(%rdi), %xmm1
; SSE2-NEXT:    movdqu 32(%rdi), %xmm2
; SSE2-NEXT:    movdqu 48(%rdi), %xmm3
; SSE2-NEXT:    movdqa %xmm0, %xmm4
; SSE2-NEXT:    psrad $31, %xmm4
; SSE2-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[1,1,3,3]
; SSE2-NEXT:    pxor %xmm4, %xmm0
; SSE2-NEXT:    psubq %xmm4, %xmm0
; SSE2-NEXT:    movdqa %xmm1, %xmm4
; SSE2-NEXT:    psrad $31, %xmm4
; SSE2-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[1,1,3,3]
; SSE2-NEXT:    pxor %xmm4, %xmm1
; SSE2-NEXT:    psubq %xmm4, %xmm1
; SSE2-NEXT:    movdqa %xmm2, %xmm4
; SSE2-NEXT:    psrad $31, %xmm4
; SSE2-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[1,1,3,3]
; SSE2-NEXT:    pxor %xmm4, %xmm2
; SSE2-NEXT:    psubq %xmm4, %xmm2
; SSE2-NEXT:    movdqa %xmm3, %xmm4
; SSE2-NEXT:    psrad $31, %xmm4
; SSE2-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[1,1,3,3]
; SSE2-NEXT:    pxor %xmm4, %xmm3
; SSE2-NEXT:    psubq %xmm4, %xmm3
; SSE2-NEXT:    retq
;
; SSSE3-LABEL: test_abs_le_v8i64_fold:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    movdqu (%rdi), %xmm0
; SSSE3-NEXT:    movdqu 16(%rdi), %xmm1
; SSSE3-NEXT:    movdqu 32(%rdi), %xmm2
; SSSE3-NEXT:    movdqu 48(%rdi), %xmm3
; SSSE3-NEXT:    movdqa %xmm0, %xmm4
; SSSE3-NEXT:    psrad $31, %xmm4
; SSSE3-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[1,1,3,3]
; SSSE3-NEXT:    pxor %xmm4, %xmm0
; SSSE3-NEXT:    psubq %xmm4, %xmm0
; SSSE3-NEXT:    movdqa %xmm1, %xmm4
; SSSE3-NEXT:    psrad $31, %xmm4
; SSSE3-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[1,1,3,3]
; SSSE3-NEXT:    pxor %xmm4, %xmm1
; SSSE3-NEXT:    psubq %xmm4, %xmm1
; SSSE3-NEXT:    movdqa %xmm2, %xmm4
; SSSE3-NEXT:    psrad $31, %xmm4
; SSSE3-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[1,1,3,3]
; SSSE3-NEXT:    pxor %xmm4, %xmm2
; SSSE3-NEXT:    psubq %xmm4, %xmm2
; SSSE3-NEXT:    movdqa %xmm3, %xmm4
; SSSE3-NEXT:    psrad $31, %xmm4
; SSSE3-NEXT:    pshufd {{.*#+}} xmm4 = xmm4[1,1,3,3]
; SSSE3-NEXT:    pxor %xmm4, %xmm3
; SSSE3-NEXT:    psubq %xmm4, %xmm3
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: test_abs_le_v8i64_fold:
; SSE41:       # %bb.0:
; SSE41-NEXT:    movdqu (%rdi), %xmm1
; SSE41-NEXT:    movdqu 16(%rdi), %xmm2
; SSE41-NEXT:    movdqu 32(%rdi), %xmm3
; SSE41-NEXT:    movdqu 48(%rdi), %xmm4
; SSE41-NEXT:    pxor %xmm5, %xmm5
; SSE41-NEXT:    pxor %xmm6, %xmm6
; SSE41-NEXT:    psubq %xmm1, %xmm6
; SSE41-NEXT:    movdqa %xmm1, %xmm0
; SSE41-NEXT:    blendvpd %xmm0, %xmm6, %xmm1
; SSE41-NEXT:    pxor %xmm6, %xmm6
; SSE41-NEXT:    psubq %xmm2, %xmm6
; SSE41-NEXT:    movdqa %xmm2, %xmm0
; SSE41-NEXT:    blendvpd %xmm0, %xmm6, %xmm2
; SSE41-NEXT:    pxor %xmm6, %xmm6
; SSE41-NEXT:    psubq %xmm3, %xmm6
; SSE41-NEXT:    movdqa %xmm3, %xmm0
; SSE41-NEXT:    blendvpd %xmm0, %xmm6, %xmm3
; SSE41-NEXT:    psubq %xmm4, %xmm5
; SSE41-NEXT:    movdqa %xmm4, %xmm0
; SSE41-NEXT:    blendvpd %xmm0, %xmm5, %xmm4
; SSE41-NEXT:    movapd %xmm1, %xmm0
; SSE41-NEXT:    movapd %xmm2, %xmm1
; SSE41-NEXT:    movapd %xmm3, %xmm2
; SSE41-NEXT:    movapd %xmm4, %xmm3
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test_abs_le_v8i64_fold:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovupd (%rdi), %ymm0
; AVX1-NEXT:    vmovupd 32(%rdi), %ymm1
; AVX1-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX1-NEXT:    vpsubq 16(%rdi), %xmm2, %xmm3
; AVX1-NEXT:    vpsubq (%rdi), %xmm2, %xmm4
; AVX1-NEXT:    vinsertf128 $1, %xmm3, %ymm4, %ymm3
; AVX1-NEXT:    vblendvpd %ymm0, %ymm3, %ymm0, %ymm0
; AVX1-NEXT:    vpsubq 48(%rdi), %xmm2, %xmm3
; AVX1-NEXT:    vpsubq 32(%rdi), %xmm2, %xmm2
; AVX1-NEXT:    vinsertf128 $1, %xmm3, %ymm2, %ymm2
; AVX1-NEXT:    vblendvpd %ymm1, %ymm2, %ymm1, %ymm1
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_abs_le_v8i64_fold:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vmovdqu (%rdi), %ymm0
; AVX2-NEXT:    vmovdqu 32(%rdi), %ymm1
; AVX2-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX2-NEXT:    vpsubq %ymm0, %ymm2, %ymm3
; AVX2-NEXT:    vblendvpd %ymm0, %ymm3, %ymm0, %ymm0
; AVX2-NEXT:    vpsubq %ymm1, %ymm2, %ymm2
; AVX2-NEXT:    vblendvpd %ymm1, %ymm2, %ymm1, %ymm1
; AVX2-NEXT:    retq
;
; AVX512-LABEL: test_abs_le_v8i64_fold:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vpabsq (%rdi), %zmm0 # encoding: [0x62,0xf2,0xfd,0x48,0x1f,0x07]
; AVX512-NEXT:    retq # encoding: [0xc3]
  %a = load <8 x i64>, ptr %a.ptr, align 8
  %tmp1neg = sub <8 x i64> zeroinitializer, %a
  %b = icmp sle <8 x i64> %a, zeroinitializer
  %abs = select <8 x i1> %b, <8 x i64> %tmp1neg, <8 x i64> %a
  ret <8 x i64> %abs
}

define <64 x i8> @test_abs_lt_v64i8(<64 x i8> %a) nounwind {
; SSE2-LABEL: test_abs_lt_v64i8:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pxor %xmm4, %xmm4
; SSE2-NEXT:    pxor %xmm5, %xmm5
; SSE2-NEXT:    psubb %xmm0, %xmm5
; SSE2-NEXT:    pminub %xmm5, %xmm0
; SSE2-NEXT:    pxor %xmm5, %xmm5
; SSE2-NEXT:    psubb %xmm1, %xmm5
; SSE2-NEXT:    pminub %xmm5, %xmm1
; SSE2-NEXT:    pxor %xmm5, %xmm5
; SSE2-NEXT:    psubb %xmm2, %xmm5
; SSE2-NEXT:    pminub %xmm5, %xmm2
; SSE2-NEXT:    psubb %xmm3, %xmm4
; SSE2-NEXT:    pminub %xmm4, %xmm3
; SSE2-NEXT:    retq
;
; SSSE3-LABEL: test_abs_lt_v64i8:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    pabsb %xmm0, %xmm0
; SSSE3-NEXT:    pabsb %xmm1, %xmm1
; SSSE3-NEXT:    pabsb %xmm2, %xmm2
; SSSE3-NEXT:    pabsb %xmm3, %xmm3
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: test_abs_lt_v64i8:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pabsb %xmm0, %xmm0
; SSE41-NEXT:    pabsb %xmm1, %xmm1
; SSE41-NEXT:    pabsb %xmm2, %xmm2
; SSE41-NEXT:    pabsb %xmm3, %xmm3
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test_abs_lt_v64i8:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpabsb %xmm0, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpabsb %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm2, %ymm0
; AVX1-NEXT:    vpabsb %xmm1, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm1
; AVX1-NEXT:    vpabsb %xmm1, %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm2, %ymm1
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_abs_lt_v64i8:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpabsb %ymm0, %ymm0
; AVX2-NEXT:    vpabsb %ymm1, %ymm1
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: test_abs_lt_v64i8:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpabsb %ymm0, %ymm1 # encoding: [0xc4,0xe2,0x7d,0x1c,0xc8]
; AVX512F-NEXT:    vextracti64x4 $1, %zmm0, %ymm0 # encoding: [0x62,0xf3,0xfd,0x48,0x3b,0xc0,0x01]
; AVX512F-NEXT:    vpabsb %ymm0, %ymm0 # encoding: [0xc4,0xe2,0x7d,0x1c,0xc0]
; AVX512F-NEXT:    vinserti64x4 $1, %ymm0, %zmm1, %zmm0 # encoding: [0x62,0xf3,0xf5,0x48,0x3a,0xc0,0x01]
; AVX512F-NEXT:    retq # encoding: [0xc3]
;
; AVX512BW-LABEL: test_abs_lt_v64i8:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpabsb %zmm0, %zmm0 # encoding: [0x62,0xf2,0x7d,0x48,0x1c,0xc0]
; AVX512BW-NEXT:    retq # encoding: [0xc3]
  %tmp1neg = sub <64 x i8> zeroinitializer, %a
  %b = icmp slt <64 x i8> %a, zeroinitializer
  %abs = select <64 x i1> %b, <64 x i8> %tmp1neg, <64 x i8> %a
  ret <64 x i8> %abs
}

define <32 x i16> @test_abs_gt_v32i16(<32 x i16> %a) nounwind {
; SSE2-LABEL: test_abs_gt_v32i16:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pxor %xmm4, %xmm4
; SSE2-NEXT:    pxor %xmm5, %xmm5
; SSE2-NEXT:    psubw %xmm0, %xmm5
; SSE2-NEXT:    pmaxsw %xmm5, %xmm0
; SSE2-NEXT:    pxor %xmm5, %xmm5
; SSE2-NEXT:    psubw %xmm1, %xmm5
; SSE2-NEXT:    pmaxsw %xmm5, %xmm1
; SSE2-NEXT:    pxor %xmm5, %xmm5
; SSE2-NEXT:    psubw %xmm2, %xmm5
; SSE2-NEXT:    pmaxsw %xmm5, %xmm2
; SSE2-NEXT:    psubw %xmm3, %xmm4
; SSE2-NEXT:    pmaxsw %xmm4, %xmm3
; SSE2-NEXT:    retq
;
; SSSE3-LABEL: test_abs_gt_v32i16:
; SSSE3:       # %bb.0:
; SSSE3-NEXT:    pabsw %xmm0, %xmm0
; SSSE3-NEXT:    pabsw %xmm1, %xmm1
; SSSE3-NEXT:    pabsw %xmm2, %xmm2
; SSSE3-NEXT:    pabsw %xmm3, %xmm3
; SSSE3-NEXT:    retq
;
; SSE41-LABEL: test_abs_gt_v32i16:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pabsw %xmm0, %xmm0
; SSE41-NEXT:    pabsw %xmm1, %xmm1
; SSE41-NEXT:    pabsw %xmm2, %xmm2
; SSE41-NEXT:    pabsw %xmm3, %xmm3
; SSE41-NEXT:    retq
;
; AVX1-LABEL: test_abs_gt_v32i16:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpabsw %xmm0, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpabsw %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm2, %ymm0
; AVX1-NEXT:    vpabsw %xmm1, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm1
; AVX1-NEXT:    vpabsw %xmm1, %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm2, %ymm1
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_abs_gt_v32i16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpabsw %ymm0, %ymm0
; AVX2-NEXT:    vpabsw %ymm1, %ymm1
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: test_abs_gt_v32i16:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpabsw %ymm0, %ymm1 # encoding: [0xc4,0xe2,0x7d,0x1d,0xc8]
; AVX512F-NEXT:    vextracti64x4 $1, %zmm0, %ymm0 # encoding: [0x62,0xf3,0xfd,0x48,0x3b,0xc0,0x01]
; AVX512F-NEXT:    vpabsw %ymm0, %ymm0 # encoding: [0xc4,0xe2,0x7d,0x1d,0xc0]
; AVX512F-NEXT:    vinserti64x4 $1, %ymm0, %zmm1, %zmm0 # encoding: [0x62,0xf3,0xf5,0x48,0x3a,0xc0,0x01]
; AVX512F-NEXT:    retq # encoding: [0xc3]
;
; AVX512BW-LABEL: test_abs_gt_v32i16:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpabsw %zmm0, %zmm0 # encoding: [0x62,0xf2,0x7d,0x48,0x1d,0xc0]
; AVX512BW-NEXT:    retq # encoding: [0xc3]
  %tmp1neg = sub <32 x i16> zeroinitializer, %a
  %b = icmp sgt <32 x i16> %a, zeroinitializer
  %abs = select <32 x i1> %b, <32 x i16> %a, <32 x i16> %tmp1neg
  ret <32 x i16> %abs
}
