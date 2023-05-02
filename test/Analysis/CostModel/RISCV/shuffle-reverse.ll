; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -passes="print<cost-model>" 2>&1 -disable-output -mtriple=riscv32 -mattr=+v,+f,+d,+zfh,+experimental-zvfh -riscv-v-vector-bits-min=-1 | FileCheck %s
; Check that we don't crash querying costs when vectors are not enabled.
; RUN: opt -passes="print<cost-model>" 2>&1 -disable-output -mtriple=riscv32

; Verify the cost model for reverse shuffles.
;
define void @reverse() {
;
; CHECK-LABEL: 'reverse'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v2i8 = shufflevector <2 x i8> undef, <2 x i8> undef, <2 x i32> <i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v4i8 = shufflevector <4 x i8> undef, <4 x i8> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v8i8 = shufflevector <8 x i8> undef, <8 x i8> undef, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v16i8 = shufflevector <16 x i8> undef, <16 x i8> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v2i16 = shufflevector <2 x i16> undef, <2 x i16> undef, <2 x i32> <i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v4i16 = shufflevector <4 x i16> undef, <4 x i16> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v8i16 = shufflevector <8 x i16> undef, <8 x i16> undef, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v16i16 = shufflevector <16 x i16> undef, <16 x i16> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v2i32 = shufflevector <2 x i32> undef, <2 x i32> undef, <2 x i32> <i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v4i32 = shufflevector <4 x i32> undef, <4 x i32> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v8i32 = shufflevector <8 x i32> undef, <8 x i32> undef, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v2i64 = shufflevector <2 x i64> undef, <2 x i64> undef, <2 x i32> <i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v4i64 = shufflevector <4 x i64> undef, <4 x i64> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v2f16 = shufflevector <2 x half> undef, <2 x half> undef, <2 x i32> <i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v4f16 = shufflevector <4 x half> undef, <4 x half> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v8f16 = shufflevector <8 x half> undef, <8 x half> undef, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v16f16 = shufflevector <16 x half> undef, <16 x half> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v2f32 = shufflevector <2 x float> undef, <2 x float> undef, <2 x i32> <i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v4f32 = shufflevector <4 x float> undef, <4 x float> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v8f32 = shufflevector <8 x float> undef, <8 x float> undef, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v2f64 = shufflevector <2 x double> undef, <2 x double> undef, <2 x i32> <i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v4f64 = shufflevector <4 x double> undef, <4 x double> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
  %v2i8 = shufflevector <2 x i8> undef, <2 x i8> undef, <2 x i32> <i32 1, i32 0>
  %v4i8 = shufflevector <4 x i8> undef, <4 x i8> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
  %v8i8 = shufflevector <8 x i8> undef, <8 x i8> undef, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %v16i8 = shufflevector <16 x i8> undef, <16 x i8> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>

  %v2i16 = shufflevector <2 x i16> undef, <2 x i16> undef, <2 x i32> <i32 1, i32 0>
  %v4i16 = shufflevector <4 x i16> undef, <4 x i16> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
  %v8i16 = shufflevector <8 x i16> undef, <8 x i16> undef, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %v16i16 = shufflevector <16 x i16> undef, <16 x i16> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>

  %v2i32 = shufflevector <2 x i32> undef, <2 x i32> undef, <2 x i32> <i32 1, i32 0>
  %v4i32 = shufflevector <4 x i32> undef, <4 x i32> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
  %v8i32 = shufflevector <8 x i32> undef, <8 x i32> undef, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>

  %v2i64 = shufflevector <2 x i64> undef, <2 x i64> undef, <2 x i32> <i32 1, i32 0>
  %v4i64 = shufflevector <4 x i64> undef, <4 x i64> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>

  %v2f16 = shufflevector <2 x half> undef, <2 x half> undef, <2 x i32> <i32 1, i32 0>
  %v4f16 = shufflevector <4 x half> undef, <4 x half> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
  %v8f16 = shufflevector <8 x half> undef, <8 x half> undef, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %v16f16 = shufflevector <16 x half> undef, <16 x half> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>

  %v2f32 = shufflevector <2 x float> undef, <2 x float> undef, <2 x i32> <i32 1, i32 0>
  %v4f32 = shufflevector <4 x float> undef, <4 x float> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
  %v8f32 = shufflevector <8 x float> undef, <8 x float> undef, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>

  %v2f64 = shufflevector <2 x double> undef, <2 x double> undef, <2 x i32> <i32 1, i32 0>
  %v4f64 = shufflevector <4 x double> undef, <4 x double> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 0>

  ret void
}
