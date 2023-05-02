; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -mtriple=x86_64-pc-linux  -mattr=+avx -interleaved-access -S | FileCheck %s

; This file tests the function `llvm::lowerInterleavedLoad/Store`.

define <4 x double> @load_factorf64_4(ptr %ptr) {
; CHECK-LABEL: @load_factorf64_4(
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr <4 x double>, ptr [[PTR:%.*]], i32 0
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x double>, ptr [[TMP1]], align 16
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr <4 x double>, ptr [[PTR]], i32 1
; CHECK-NEXT:    [[TMP4:%.*]] = load <4 x double>, ptr [[TMP3]], align 16
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr <4 x double>, ptr [[PTR]], i32 2
; CHECK-NEXT:    [[TMP6:%.*]] = load <4 x double>, ptr [[TMP5]], align 16
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr <4 x double>, ptr [[PTR]], i32 3
; CHECK-NEXT:    [[TMP8:%.*]] = load <4 x double>, ptr [[TMP7]], align 16
; CHECK-NEXT:    [[TMP9:%.*]] = shufflevector <4 x double> [[TMP2]], <4 x double> [[TMP6]], <4 x i32> <i32 0, i32 1, i32 4, i32 5>
; CHECK-NEXT:    [[TMP10:%.*]] = shufflevector <4 x double> [[TMP4]], <4 x double> [[TMP8]], <4 x i32> <i32 0, i32 1, i32 4, i32 5>
; CHECK-NEXT:    [[TMP11:%.*]] = shufflevector <4 x double> [[TMP2]], <4 x double> [[TMP6]], <4 x i32> <i32 2, i32 3, i32 6, i32 7>
; CHECK-NEXT:    [[TMP12:%.*]] = shufflevector <4 x double> [[TMP4]], <4 x double> [[TMP8]], <4 x i32> <i32 2, i32 3, i32 6, i32 7>
; CHECK-NEXT:    [[TMP13:%.*]] = shufflevector <4 x double> [[TMP9]], <4 x double> [[TMP10]], <4 x i32> <i32 0, i32 4, i32 2, i32 6>
; CHECK-NEXT:    [[TMP14:%.*]] = shufflevector <4 x double> [[TMP11]], <4 x double> [[TMP12]], <4 x i32> <i32 0, i32 4, i32 2, i32 6>
; CHECK-NEXT:    [[TMP15:%.*]] = shufflevector <4 x double> [[TMP9]], <4 x double> [[TMP10]], <4 x i32> <i32 1, i32 5, i32 3, i32 7>
; CHECK-NEXT:    [[TMP16:%.*]] = shufflevector <4 x double> [[TMP11]], <4 x double> [[TMP12]], <4 x i32> <i32 1, i32 5, i32 3, i32 7>
; CHECK-NEXT:    [[ADD1:%.*]] = fadd <4 x double> [[TMP13]], [[TMP15]]
; CHECK-NEXT:    [[ADD2:%.*]] = fadd <4 x double> [[ADD1]], [[TMP14]]
; CHECK-NEXT:    [[ADD3:%.*]] = fadd <4 x double> [[ADD2]], [[TMP16]]
; CHECK-NEXT:    ret <4 x double> [[ADD3]]
;
  %wide.vec = load <16 x double>, ptr %ptr, align 16
  %strided.v0 = shufflevector <16 x double> %wide.vec, <16 x double> poison, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %strided.v1 = shufflevector <16 x double> %wide.vec, <16 x double> poison, <4 x i32> <i32 1, i32 5, i32 9, i32 13>
  %strided.v2 = shufflevector <16 x double> %wide.vec, <16 x double> poison, <4 x i32> <i32 2, i32 6, i32 10, i32 14>
  %strided.v3 = shufflevector <16 x double> %wide.vec, <16 x double> poison, <4 x i32> <i32 3, i32 7, i32 11, i32 15>
  %add1 = fadd <4 x double> %strided.v0, %strided.v1
  %add2 = fadd <4 x double> %add1, %strided.v2
  %add3 = fadd <4 x double> %add2, %strided.v3
  ret <4 x double> %add3
}

define <4 x i64> @load_factori64_4(ptr %ptr) {
; CHECK-LABEL: @load_factori64_4(
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr <4 x i64>, ptr [[PTR:%.*]], i32 0
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x i64>, ptr [[TMP1]], align 16
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr <4 x i64>, ptr [[PTR]], i32 1
; CHECK-NEXT:    [[TMP4:%.*]] = load <4 x i64>, ptr [[TMP3]], align 16
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr <4 x i64>, ptr [[PTR]], i32 2
; CHECK-NEXT:    [[TMP6:%.*]] = load <4 x i64>, ptr [[TMP5]], align 16
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr <4 x i64>, ptr [[PTR]], i32 3
; CHECK-NEXT:    [[TMP8:%.*]] = load <4 x i64>, ptr [[TMP7]], align 16
; CHECK-NEXT:    [[TMP9:%.*]] = shufflevector <4 x i64> [[TMP2]], <4 x i64> [[TMP6]], <4 x i32> <i32 0, i32 1, i32 4, i32 5>
; CHECK-NEXT:    [[TMP10:%.*]] = shufflevector <4 x i64> [[TMP4]], <4 x i64> [[TMP8]], <4 x i32> <i32 0, i32 1, i32 4, i32 5>
; CHECK-NEXT:    [[TMP11:%.*]] = shufflevector <4 x i64> [[TMP2]], <4 x i64> [[TMP6]], <4 x i32> <i32 2, i32 3, i32 6, i32 7>
; CHECK-NEXT:    [[TMP12:%.*]] = shufflevector <4 x i64> [[TMP4]], <4 x i64> [[TMP8]], <4 x i32> <i32 2, i32 3, i32 6, i32 7>
; CHECK-NEXT:    [[TMP13:%.*]] = shufflevector <4 x i64> [[TMP9]], <4 x i64> [[TMP10]], <4 x i32> <i32 0, i32 4, i32 2, i32 6>
; CHECK-NEXT:    [[TMP14:%.*]] = shufflevector <4 x i64> [[TMP11]], <4 x i64> [[TMP12]], <4 x i32> <i32 0, i32 4, i32 2, i32 6>
; CHECK-NEXT:    [[TMP15:%.*]] = shufflevector <4 x i64> [[TMP9]], <4 x i64> [[TMP10]], <4 x i32> <i32 1, i32 5, i32 3, i32 7>
; CHECK-NEXT:    [[TMP16:%.*]] = shufflevector <4 x i64> [[TMP11]], <4 x i64> [[TMP12]], <4 x i32> <i32 1, i32 5, i32 3, i32 7>
; CHECK-NEXT:    [[ADD1:%.*]] = add <4 x i64> [[TMP13]], [[TMP15]]
; CHECK-NEXT:    [[ADD2:%.*]] = add <4 x i64> [[ADD1]], [[TMP14]]
; CHECK-NEXT:    [[ADD3:%.*]] = add <4 x i64> [[ADD2]], [[TMP16]]
; CHECK-NEXT:    ret <4 x i64> [[ADD3]]
;
  %wide.vec = load <16 x i64>, ptr %ptr, align 16
  %strided.v0 = shufflevector <16 x i64> %wide.vec, <16 x i64> poison, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %strided.v1 = shufflevector <16 x i64> %wide.vec, <16 x i64> poison, <4 x i32> <i32 1, i32 5, i32 9, i32 13>
  %strided.v2 = shufflevector <16 x i64> %wide.vec, <16 x i64> poison, <4 x i32> <i32 2, i32 6, i32 10, i32 14>
  %strided.v3 = shufflevector <16 x i64> %wide.vec, <16 x i64> poison, <4 x i32> <i32 3, i32 7, i32 11, i32 15>
  %add1 = add <4 x i64> %strided.v0, %strided.v1
  %add2 = add <4 x i64> %add1, %strided.v2
  %add3 = add <4 x i64> %add2, %strided.v3
  ret <4 x i64> %add3
}

define <4 x double> @load_factorf64_1(ptr %ptr) {
; CHECK-LABEL: @load_factorf64_1(
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr <4 x double>, ptr [[PTR:%.*]], i32 0
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x double>, ptr [[TMP1]], align 16
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr <4 x double>, ptr [[PTR]], i32 1
; CHECK-NEXT:    [[TMP4:%.*]] = load <4 x double>, ptr [[TMP3]], align 16
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr <4 x double>, ptr [[PTR]], i32 2
; CHECK-NEXT:    [[TMP6:%.*]] = load <4 x double>, ptr [[TMP5]], align 16
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr <4 x double>, ptr [[PTR]], i32 3
; CHECK-NEXT:    [[TMP8:%.*]] = load <4 x double>, ptr [[TMP7]], align 16
; CHECK-NEXT:    [[TMP9:%.*]] = shufflevector <4 x double> [[TMP2]], <4 x double> [[TMP6]], <4 x i32> <i32 0, i32 1, i32 4, i32 5>
; CHECK-NEXT:    [[TMP10:%.*]] = shufflevector <4 x double> [[TMP4]], <4 x double> [[TMP8]], <4 x i32> <i32 0, i32 1, i32 4, i32 5>
; CHECK-NEXT:    [[TMP11:%.*]] = shufflevector <4 x double> [[TMP2]], <4 x double> [[TMP6]], <4 x i32> <i32 2, i32 3, i32 6, i32 7>
; CHECK-NEXT:    [[TMP12:%.*]] = shufflevector <4 x double> [[TMP4]], <4 x double> [[TMP8]], <4 x i32> <i32 2, i32 3, i32 6, i32 7>
; CHECK-NEXT:    [[TMP13:%.*]] = shufflevector <4 x double> [[TMP9]], <4 x double> [[TMP10]], <4 x i32> <i32 0, i32 4, i32 2, i32 6>
; CHECK-NEXT:    [[TMP14:%.*]] = shufflevector <4 x double> [[TMP11]], <4 x double> [[TMP12]], <4 x i32> <i32 0, i32 4, i32 2, i32 6>
; CHECK-NEXT:    [[TMP15:%.*]] = shufflevector <4 x double> [[TMP9]], <4 x double> [[TMP10]], <4 x i32> <i32 1, i32 5, i32 3, i32 7>
; CHECK-NEXT:    [[TMP16:%.*]] = shufflevector <4 x double> [[TMP11]], <4 x double> [[TMP12]], <4 x i32> <i32 1, i32 5, i32 3, i32 7>
; CHECK-NEXT:    [[MUL:%.*]] = fmul <4 x double> [[TMP13]], [[TMP13]]
; CHECK-NEXT:    ret <4 x double> [[MUL]]
;
  %wide.vec = load <16 x double>, ptr %ptr, align 16
  %strided.v0 = shufflevector <16 x double> %wide.vec, <16 x double> poison, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %strided.v3 = shufflevector <16 x double> %wide.vec, <16 x double> poison, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  %mul = fmul <4 x double> %strided.v0, %strided.v3
  ret <4 x double> %mul
}

define void @store_factorf64_4(ptr %ptr, <4 x double> %v0, <4 x double> %v1, <4 x double> %v2, <4 x double> %v3) {
; CHECK-LABEL: @store_factorf64_4(
; CHECK-NEXT:    [[S0:%.*]] = shufflevector <4 x double> [[V0:%.*]], <4 x double> [[V1:%.*]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    [[S1:%.*]] = shufflevector <4 x double> [[V2:%.*]], <4 x double> [[V3:%.*]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <8 x double> [[S0]], <8 x double> [[S1]], <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <8 x double> [[S0]], <8 x double> [[S1]], <4 x i32> <i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    [[TMP3:%.*]] = shufflevector <8 x double> [[S0]], <8 x double> [[S1]], <4 x i32> <i32 8, i32 9, i32 10, i32 11>
; CHECK-NEXT:    [[TMP4:%.*]] = shufflevector <8 x double> [[S0]], <8 x double> [[S1]], <4 x i32> <i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:    [[TMP5:%.*]] = shufflevector <4 x double> [[TMP1]], <4 x double> [[TMP3]], <4 x i32> <i32 0, i32 1, i32 4, i32 5>
; CHECK-NEXT:    [[TMP6:%.*]] = shufflevector <4 x double> [[TMP2]], <4 x double> [[TMP4]], <4 x i32> <i32 0, i32 1, i32 4, i32 5>
; CHECK-NEXT:    [[TMP7:%.*]] = shufflevector <4 x double> [[TMP1]], <4 x double> [[TMP3]], <4 x i32> <i32 2, i32 3, i32 6, i32 7>
; CHECK-NEXT:    [[TMP8:%.*]] = shufflevector <4 x double> [[TMP2]], <4 x double> [[TMP4]], <4 x i32> <i32 2, i32 3, i32 6, i32 7>
; CHECK-NEXT:    [[TMP9:%.*]] = shufflevector <4 x double> [[TMP5]], <4 x double> [[TMP6]], <4 x i32> <i32 0, i32 4, i32 2, i32 6>
; CHECK-NEXT:    [[TMP10:%.*]] = shufflevector <4 x double> [[TMP7]], <4 x double> [[TMP8]], <4 x i32> <i32 0, i32 4, i32 2, i32 6>
; CHECK-NEXT:    [[TMP11:%.*]] = shufflevector <4 x double> [[TMP5]], <4 x double> [[TMP6]], <4 x i32> <i32 1, i32 5, i32 3, i32 7>
; CHECK-NEXT:    [[TMP12:%.*]] = shufflevector <4 x double> [[TMP7]], <4 x double> [[TMP8]], <4 x i32> <i32 1, i32 5, i32 3, i32 7>
; CHECK-NEXT:    [[TMP13:%.*]] = shufflevector <4 x double> [[TMP9]], <4 x double> [[TMP11]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    [[TMP14:%.*]] = shufflevector <4 x double> [[TMP10]], <4 x double> [[TMP12]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    [[TMP15:%.*]] = shufflevector <8 x double> [[TMP13]], <8 x double> [[TMP14]], <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:    store <16 x double> [[TMP15]], ptr [[PTR:%.*]], align 16
; CHECK-NEXT:    ret void
;
  %s0 = shufflevector <4 x double> %v0, <4 x double> %v1, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %s1 = shufflevector <4 x double> %v2, <4 x double> %v3, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %interleaved.vec = shufflevector <8 x double> %s0, <8 x double> %s1, <16 x i32> <i32 0, i32 4, i32 8, i32 12, i32 1, i32 5, i32 9, i32 13, i32 2, i32 6, i32 10, i32 14, i32 3, i32 7, i32 11, i32 15>
  store <16 x double> %interleaved.vec, ptr %ptr, align 16
  ret void
}

define void @store_factori64_4(ptr %ptr, <4 x i64> %v0, <4 x i64> %v1, <4 x i64> %v2, <4 x i64> %v3) {
; CHECK-LABEL: @store_factori64_4(
; CHECK-NEXT:    [[S0:%.*]] = shufflevector <4 x i64> [[V0:%.*]], <4 x i64> [[V1:%.*]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    [[S1:%.*]] = shufflevector <4 x i64> [[V2:%.*]], <4 x i64> [[V3:%.*]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <8 x i64> [[S0]], <8 x i64> [[S1]], <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <8 x i64> [[S0]], <8 x i64> [[S1]], <4 x i32> <i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    [[TMP3:%.*]] = shufflevector <8 x i64> [[S0]], <8 x i64> [[S1]], <4 x i32> <i32 8, i32 9, i32 10, i32 11>
; CHECK-NEXT:    [[TMP4:%.*]] = shufflevector <8 x i64> [[S0]], <8 x i64> [[S1]], <4 x i32> <i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:    [[TMP5:%.*]] = shufflevector <4 x i64> [[TMP1]], <4 x i64> [[TMP3]], <4 x i32> <i32 0, i32 1, i32 4, i32 5>
; CHECK-NEXT:    [[TMP6:%.*]] = shufflevector <4 x i64> [[TMP2]], <4 x i64> [[TMP4]], <4 x i32> <i32 0, i32 1, i32 4, i32 5>
; CHECK-NEXT:    [[TMP7:%.*]] = shufflevector <4 x i64> [[TMP1]], <4 x i64> [[TMP3]], <4 x i32> <i32 2, i32 3, i32 6, i32 7>
; CHECK-NEXT:    [[TMP8:%.*]] = shufflevector <4 x i64> [[TMP2]], <4 x i64> [[TMP4]], <4 x i32> <i32 2, i32 3, i32 6, i32 7>
; CHECK-NEXT:    [[TMP9:%.*]] = shufflevector <4 x i64> [[TMP5]], <4 x i64> [[TMP6]], <4 x i32> <i32 0, i32 4, i32 2, i32 6>
; CHECK-NEXT:    [[TMP10:%.*]] = shufflevector <4 x i64> [[TMP7]], <4 x i64> [[TMP8]], <4 x i32> <i32 0, i32 4, i32 2, i32 6>
; CHECK-NEXT:    [[TMP11:%.*]] = shufflevector <4 x i64> [[TMP5]], <4 x i64> [[TMP6]], <4 x i32> <i32 1, i32 5, i32 3, i32 7>
; CHECK-NEXT:    [[TMP12:%.*]] = shufflevector <4 x i64> [[TMP7]], <4 x i64> [[TMP8]], <4 x i32> <i32 1, i32 5, i32 3, i32 7>
; CHECK-NEXT:    [[TMP13:%.*]] = shufflevector <4 x i64> [[TMP9]], <4 x i64> [[TMP11]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    [[TMP14:%.*]] = shufflevector <4 x i64> [[TMP10]], <4 x i64> [[TMP12]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    [[TMP15:%.*]] = shufflevector <8 x i64> [[TMP13]], <8 x i64> [[TMP14]], <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:    store <16 x i64> [[TMP15]], ptr [[PTR:%.*]], align 16
; CHECK-NEXT:    ret void
;
  %s0 = shufflevector <4 x i64> %v0, <4 x i64> %v1, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %s1 = shufflevector <4 x i64> %v2, <4 x i64> %v3, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %interleaved.vec = shufflevector <8 x i64> %s0, <8 x i64> %s1, <16 x i32> <i32 0, i32 4, i32 8, i32 12, i32 1, i32 5, i32 9, i32 13, i32 2, i32 6, i32 10, i32 14, i32 3, i32 7, i32 11, i32 15>
  store <16 x i64> %interleaved.vec, ptr %ptr, align 16
  ret void
}

define void @store_factorf64_4_revMask(ptr %ptr, <4 x double> %v0, <4 x double> %v1, <4 x double> %v2, <4 x double> %v3) {
; CHECK-LABEL: @store_factorf64_4_revMask(
; CHECK-NEXT:    [[S0:%.*]] = shufflevector <4 x double> [[V0:%.*]], <4 x double> [[V1:%.*]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    [[S1:%.*]] = shufflevector <4 x double> [[V2:%.*]], <4 x double> [[V3:%.*]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <8 x double> [[S0]], <8 x double> [[S1]], <4 x i32> <i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <8 x double> [[S0]], <8 x double> [[S1]], <4 x i32> <i32 8, i32 9, i32 10, i32 11>
; CHECK-NEXT:    [[TMP3:%.*]] = shufflevector <8 x double> [[S0]], <8 x double> [[S1]], <4 x i32> <i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    [[TMP4:%.*]] = shufflevector <8 x double> [[S0]], <8 x double> [[S1]], <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:    [[TMP5:%.*]] = shufflevector <4 x double> [[TMP1]], <4 x double> [[TMP3]], <4 x i32> <i32 0, i32 1, i32 4, i32 5>
; CHECK-NEXT:    [[TMP6:%.*]] = shufflevector <4 x double> [[TMP2]], <4 x double> [[TMP4]], <4 x i32> <i32 0, i32 1, i32 4, i32 5>
; CHECK-NEXT:    [[TMP7:%.*]] = shufflevector <4 x double> [[TMP1]], <4 x double> [[TMP3]], <4 x i32> <i32 2, i32 3, i32 6, i32 7>
; CHECK-NEXT:    [[TMP8:%.*]] = shufflevector <4 x double> [[TMP2]], <4 x double> [[TMP4]], <4 x i32> <i32 2, i32 3, i32 6, i32 7>
; CHECK-NEXT:    [[TMP9:%.*]] = shufflevector <4 x double> [[TMP5]], <4 x double> [[TMP6]], <4 x i32> <i32 0, i32 4, i32 2, i32 6>
; CHECK-NEXT:    [[TMP10:%.*]] = shufflevector <4 x double> [[TMP7]], <4 x double> [[TMP8]], <4 x i32> <i32 0, i32 4, i32 2, i32 6>
; CHECK-NEXT:    [[TMP11:%.*]] = shufflevector <4 x double> [[TMP5]], <4 x double> [[TMP6]], <4 x i32> <i32 1, i32 5, i32 3, i32 7>
; CHECK-NEXT:    [[TMP12:%.*]] = shufflevector <4 x double> [[TMP7]], <4 x double> [[TMP8]], <4 x i32> <i32 1, i32 5, i32 3, i32 7>
; CHECK-NEXT:    [[TMP13:%.*]] = shufflevector <4 x double> [[TMP9]], <4 x double> [[TMP11]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    [[TMP14:%.*]] = shufflevector <4 x double> [[TMP10]], <4 x double> [[TMP12]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    [[TMP15:%.*]] = shufflevector <8 x double> [[TMP13]], <8 x double> [[TMP14]], <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:    store <16 x double> [[TMP15]], ptr [[PTR:%.*]], align 16
; CHECK-NEXT:    ret void
;
  %s0 = shufflevector <4 x double> %v0, <4 x double> %v1, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %s1 = shufflevector <4 x double> %v2, <4 x double> %v3, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %interleaved.vec = shufflevector <8 x double> %s0, <8 x double> %s1, <16 x i32> <i32 12, i32 8, i32 4, i32 0, i32 13, i32 9, i32 5, i32 1, i32 14, i32 10, i32 6, i32 2, i32 15, i32 11, i32 7, i32 3>
  store <16 x double> %interleaved.vec, ptr %ptr, align 16
  ret void
}

define void @store_factorf64_4_arbitraryMask(ptr %ptr, <16 x double> %v0, <16 x double> %v1, <16 x double> %v2, <16 x double> %v3) {
; CHECK-LABEL: @store_factorf64_4_arbitraryMask(
; CHECK-NEXT:    [[S0:%.*]] = shufflevector <16 x double> [[V0:%.*]], <16 x double> [[V1:%.*]], <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
; CHECK-NEXT:    [[S1:%.*]] = shufflevector <16 x double> [[V2:%.*]], <16 x double> [[V3:%.*]], <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <32 x double> [[S0]], <32 x double> [[S1]], <4 x i32> <i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <32 x double> [[S0]], <32 x double> [[S1]], <4 x i32> <i32 32, i32 33, i32 34, i32 35>
; CHECK-NEXT:    [[TMP3:%.*]] = shufflevector <32 x double> [[S0]], <32 x double> [[S1]], <4 x i32> <i32 16, i32 17, i32 18, i32 19>
; CHECK-NEXT:    [[TMP4:%.*]] = shufflevector <32 x double> [[S0]], <32 x double> [[S1]], <4 x i32> <i32 8, i32 9, i32 10, i32 11>
; CHECK-NEXT:    [[TMP5:%.*]] = shufflevector <4 x double> [[TMP1]], <4 x double> [[TMP3]], <4 x i32> <i32 0, i32 1, i32 4, i32 5>
; CHECK-NEXT:    [[TMP6:%.*]] = shufflevector <4 x double> [[TMP2]], <4 x double> [[TMP4]], <4 x i32> <i32 0, i32 1, i32 4, i32 5>
; CHECK-NEXT:    [[TMP7:%.*]] = shufflevector <4 x double> [[TMP1]], <4 x double> [[TMP3]], <4 x i32> <i32 2, i32 3, i32 6, i32 7>
; CHECK-NEXT:    [[TMP8:%.*]] = shufflevector <4 x double> [[TMP2]], <4 x double> [[TMP4]], <4 x i32> <i32 2, i32 3, i32 6, i32 7>
; CHECK-NEXT:    [[TMP9:%.*]] = shufflevector <4 x double> [[TMP5]], <4 x double> [[TMP6]], <4 x i32> <i32 0, i32 4, i32 2, i32 6>
; CHECK-NEXT:    [[TMP10:%.*]] = shufflevector <4 x double> [[TMP7]], <4 x double> [[TMP8]], <4 x i32> <i32 0, i32 4, i32 2, i32 6>
; CHECK-NEXT:    [[TMP11:%.*]] = shufflevector <4 x double> [[TMP5]], <4 x double> [[TMP6]], <4 x i32> <i32 1, i32 5, i32 3, i32 7>
; CHECK-NEXT:    [[TMP12:%.*]] = shufflevector <4 x double> [[TMP7]], <4 x double> [[TMP8]], <4 x i32> <i32 1, i32 5, i32 3, i32 7>
; CHECK-NEXT:    [[TMP13:%.*]] = shufflevector <4 x double> [[TMP9]], <4 x double> [[TMP11]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    [[TMP14:%.*]] = shufflevector <4 x double> [[TMP10]], <4 x double> [[TMP12]], <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
; CHECK-NEXT:    [[TMP15:%.*]] = shufflevector <8 x double> [[TMP13]], <8 x double> [[TMP14]], <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:    store <16 x double> [[TMP15]], ptr [[PTR:%.*]], align 16
; CHECK-NEXT:    ret void
;
  %s0 = shufflevector <16 x double> %v0, <16 x double> %v1, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %s1 = shufflevector <16 x double> %v2, <16 x double> %v3, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  %interleaved.vec = shufflevector <32 x double> %s0, <32 x double> %s1, <16 x i32> <i32 4, i32 32, i32 16, i32 8, i32 5, i32 33, i32 17, i32 9, i32 6, i32 34, i32 18, i32 10, i32 7, i32 35, i32 19, i32 11>
  store <16 x double> %interleaved.vec, ptr %ptr, align 16
  ret void
}

; This verifies whether the test passes and does not hit any assertions.
; Today, X86InterleavedAccess could have handled this case and
; generate transposed sequence by extending the current implementation
; which would be creating dummy vectors of undef. But it decided not to
; optimize these cases where the load-size is less than Factor * NumberOfElements.
; Because a better sequence can easily be generated by CG.

@a = local_unnamed_addr global <4 x double> zeroinitializer, align 32
; Function Attrs: norecurse nounwind readonly uwtable
define <4 x double> @test_unhandled(<4 x double> %b) {
; CHECK-LABEL: @test_unhandled(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <4 x double>, ptr @a, align 32
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <4 x double> [[TMP0]], <4 x double> poison, <4 x i32> <i32 3, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    [[SHUFFLE:%.*]] = shufflevector <4 x double> [[TMP1]], <4 x double> [[B:%.*]], <4 x i32> <i32 0, i32 4, i32 0, i32 0>
; CHECK-NEXT:    ret <4 x double> [[SHUFFLE]]
;
entry:
  %0 = load <4 x double>, ptr @a, align 32
  %1 = shufflevector <4 x double> %0, <4 x double> poison, <4 x i32> <i32 3, i32 undef, i32 undef, i32 undef>
  %shuffle = shufflevector <4 x double> %1, <4 x double> %b, <4 x i32> <i32 0, i32 4, i32 0, i32 0>
  ret <4 x double> %shuffle
}
