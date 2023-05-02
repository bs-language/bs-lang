; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -mtriple=aarch64-unknown-linux-gnu -passes="print<cost-model>" -cost-kind=throughput 2>&1 -disable-output | FileCheck %s --check-prefix=THROUGHPUT

; Verify the cost of (vector) multiply instructions.

target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"

define <2 x i8> @t1(<2 x i8> %a, <2 x i8> %b)  {
; THROUGHPUT-LABEL: 't1'
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = mul <2 x i8> %a, %b
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x i8> %1
;
  %1 = mul <2 x i8> %a, %b
  ret <2 x i8> %1
}

define <4 x i8> @t2(<4 x i8> %a, <4 x i8> %b)  {
; THROUGHPUT-LABEL: 't2'
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = mul <4 x i8> %a, %b
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i8> %1
;
  %1 = mul <4 x i8> %a, %b
  ret <4 x i8> %1
}

define <8 x i8> @t3(<8 x i8> %a, <8 x i8> %b)  {
; THROUGHPUT-LABEL: 't3'
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = mul <8 x i8> %a, %b
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i8> %1
;
  %1 = mul <8 x i8> %a, %b
  ret <8 x i8> %1
}

define <16 x i8> @t4(<16 x i8> %a, <16 x i8> %b)  {
; THROUGHPUT-LABEL: 't4'
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = mul <16 x i8> %a, %b
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i8> %1
;
  %1 = mul <16 x i8> %a, %b
  ret <16 x i8> %1
}

define <32 x i8> @t5(<32 x i8> %a, <32 x i8> %b)  {
; THROUGHPUT-LABEL: 't5'
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %1 = mul <32 x i8> %a, %b
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <32 x i8> %1
;
  %1 = mul <32 x i8> %a, %b
  ret <32 x i8> %1
}

define <2 x i16> @t6(<2 x i16> %a, <2 x i16> %b)  {
; THROUGHPUT-LABEL: 't6'
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = mul <2 x i16> %a, %b
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x i16> %1
;
  %1 = mul <2 x i16> %a, %b
  ret <2 x i16> %1
}

define <4 x i16> @t7(<4 x i16> %a, <4 x i16> %b)  {
; THROUGHPUT-LABEL: 't7'
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = mul <4 x i16> %a, %b
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i16> %1
;
  %1 = mul <4 x i16> %a, %b
  ret <4 x i16> %1
}

define <8 x i16> @t8(<8 x i16> %a, <8 x i16> %b)  {
; THROUGHPUT-LABEL: 't8'
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = mul <8 x i16> %a, %b
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i16> %1
;
  %1 = mul <8 x i16> %a, %b
  ret <8 x i16> %1
}

define <16 x i16> @t9(<16 x i16> %a, <16 x i16> %b)  {
; THROUGHPUT-LABEL: 't9'
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %1 = mul <16 x i16> %a, %b
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <16 x i16> %1
;
  %1 = mul <16 x i16> %a, %b
  ret <16 x i16> %1
}

define <2 x i32> @t10(<2 x i32> %a, <2 x i32> %b)  {
; THROUGHPUT-LABEL: 't10'
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = mul <2 x i32> %a, %b
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x i32> %1
;
  %1 = mul <2 x i32> %a, %b
  ret <2 x i32> %1
}

define <4 x i32> @t11(<4 x i32> %a, <4 x i32> %b)  {
; THROUGHPUT-LABEL: 't11'
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = mul <4 x i32> %a, %b
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i32> %1
;
  %1 = mul <4 x i32> %a, %b
  ret <4 x i32> %1
}

define <8 x i32> @t12(<8 x i32> %a, <8 x i32> %b)  {
; THROUGHPUT-LABEL: 't12'
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %1 = mul <8 x i32> %a, %b
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <8 x i32> %1
;
  %1 = mul <8 x i32> %a, %b
  ret <8 x i32> %1
}

define <2 x i64> @t13(<2 x i64> %a, <2 x i64> %b)  {
; THROUGHPUT-LABEL: 't13'
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 14 for instruction: %1 = mul nsw <2 x i64> %a, %b
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <2 x i64> %1
;
  %1 = mul nsw <2 x i64> %a, %b
  ret <2 x i64> %1
}

define <4 x i64> @t14(<4 x i64> %a, <4 x i64> %b)  {
; THROUGHPUT-LABEL: 't14'
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 28 for instruction: %1 = mul nsw <4 x i64> %a, %b
; THROUGHPUT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret <4 x i64> %1
;
  %1 = mul nsw <4 x i64> %a, %b
  ret <4 x i64> %1
}
