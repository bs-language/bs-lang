; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -passes="print<cost-model>" 2>&1 -disable-output -S -mtriple=riscv64 -mattr=+v,+f,+d,+zfh,+experimental-zvfh | FileCheck %s

define void  @broadcast() #0{
; CHECK-LABEL: 'broadcast'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %zero = shufflevector <vscale x 1 x half> undef, <vscale x 1 x half> undef, <vscale x 1 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = shufflevector <vscale x 2 x half> undef, <vscale x 2 x half> undef, <vscale x 2 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %2 = shufflevector <vscale x 4 x half> undef, <vscale x 4 x half> undef, <vscale x 4 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %3 = shufflevector <vscale x 8 x half> undef, <vscale x 8 x half> undef, <vscale x 8 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %4 = shufflevector <vscale x 16 x half> undef, <vscale x 16 x half> undef, <vscale x 16 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %5 = shufflevector <vscale x 32 x half> undef, <vscale x 32 x half> undef, <vscale x 32 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %6 = shufflevector <vscale x 1 x float> undef, <vscale x 1 x float> undef, <vscale x 1 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %7 = shufflevector <vscale x 2 x float> undef, <vscale x 2 x float> undef, <vscale x 2 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %8 = shufflevector <vscale x 4 x float> undef, <vscale x 4 x float> undef, <vscale x 4 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %9 = shufflevector <vscale x 8 x float> undef, <vscale x 8 x float> undef, <vscale x 8 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %10 = shufflevector <vscale x 16 x float> undef, <vscale x 16 x float> undef, <vscale x 16 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %11 = shufflevector <vscale x 1 x double> undef, <vscale x 1 x double> undef, <vscale x 1 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %12 = shufflevector <vscale x 2 x double> undef, <vscale x 2 x double> undef, <vscale x 2 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %13 = shufflevector <vscale x 4 x double> undef, <vscale x 4 x double> undef, <vscale x 4 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %14 = shufflevector <vscale x 8 x double> undef, <vscale x 8 x double> undef, <vscale x 8 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %15 = shufflevector <vscale x 1 x i8> undef, <vscale x 1 x i8> undef, <vscale x 1 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %16 = shufflevector <vscale x 2 x i8> undef, <vscale x 2 x i8> undef, <vscale x 2 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %17 = shufflevector <vscale x 4 x i8> undef, <vscale x 4 x i8> undef, <vscale x 4 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %18 = shufflevector <vscale x 8 x i8> undef, <vscale x 8 x i8> undef, <vscale x 8 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %19 = shufflevector <vscale x 16 x i8> undef, <vscale x 16 x i8> undef, <vscale x 16 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %20 = shufflevector <vscale x 32 x i8> undef, <vscale x 32 x i8> undef, <vscale x 32 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %21 = shufflevector <vscale x 64 x i8> undef, <vscale x 64 x i8> undef, <vscale x 64 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %22 = shufflevector <vscale x 1 x i16> undef, <vscale x 1 x i16> undef, <vscale x 1 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %23 = shufflevector <vscale x 2 x i16> undef, <vscale x 2 x i16> undef, <vscale x 2 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %24 = shufflevector <vscale x 4 x i16> undef, <vscale x 4 x i16> undef, <vscale x 4 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %25 = shufflevector <vscale x 8 x i16> undef, <vscale x 8 x i16> undef, <vscale x 8 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %26 = shufflevector <vscale x 16 x i16> undef, <vscale x 16 x i16> undef, <vscale x 16 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %27 = shufflevector <vscale x 32 x i16> undef, <vscale x 32 x i16> undef, <vscale x 32 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %28 = shufflevector <vscale x 1 x i32> undef, <vscale x 1 x i32> undef, <vscale x 1 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %29 = shufflevector <vscale x 2 x i32> undef, <vscale x 2 x i32> undef, <vscale x 2 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %30 = shufflevector <vscale x 4 x i32> undef, <vscale x 4 x i32> undef, <vscale x 4 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %31 = shufflevector <vscale x 8 x i32> undef, <vscale x 8 x i32> undef, <vscale x 8 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %32 = shufflevector <vscale x 16 x i32> undef, <vscale x 16 x i32> undef, <vscale x 16 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %33 = shufflevector <vscale x 1 x i64> undef, <vscale x 1 x i64> undef, <vscale x 1 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %34 = shufflevector <vscale x 2 x i64> undef, <vscale x 2 x i64> undef, <vscale x 2 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %35 = shufflevector <vscale x 4 x i64> undef, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %36 = shufflevector <vscale x 8 x i64> undef, <vscale x 8 x i64> undef, <vscale x 8 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %37 = shufflevector <vscale x 1 x i1> undef, <vscale x 1 x i1> undef, <vscale x 1 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %38 = shufflevector <vscale x 2 x i1> undef, <vscale x 2 x i1> undef, <vscale x 2 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %39 = shufflevector <vscale x 4 x i1> undef, <vscale x 4 x i1> undef, <vscale x 4 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %40 = shufflevector <vscale x 8 x i1> undef, <vscale x 8 x i1> undef, <vscale x 8 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %41 = shufflevector <vscale x 16 x i1> undef, <vscale x 16 x i1> undef, <vscale x 16 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 24 for instruction: %42 = shufflevector <vscale x 32 x i1> undef, <vscale x 32 x i1> undef, <vscale x 32 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 48 for instruction: %43 = shufflevector <vscale x 64 x i1> undef, <vscale x 64 x i1> undef, <vscale x 64 x i32> zeroinitializer
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
  %zero = shufflevector <vscale x 1 x half> undef, <vscale x 1 x half> undef, <vscale x 1 x i32> zeroinitializer
  %1 = shufflevector <vscale x 2 x half> undef, <vscale x 2 x half> undef, <vscale x 2 x i32> zeroinitializer
  %2 = shufflevector <vscale x 4 x half> undef, <vscale x 4 x half> undef, <vscale x 4 x i32> zeroinitializer
  %3 = shufflevector <vscale x 8 x half> undef, <vscale x 8 x half> undef, <vscale x 8 x i32> zeroinitializer
  %4 = shufflevector <vscale x 16 x half> undef, <vscale x 16 x half> undef, <vscale x 16 x i32> zeroinitializer
  %5 = shufflevector <vscale x 32 x half> undef, <vscale x 32 x half> undef, <vscale x 32 x i32> zeroinitializer

  %6 = shufflevector <vscale x 1 x float> undef, <vscale x 1 x float> undef, <vscale x 1 x i32> zeroinitializer
  %7 = shufflevector <vscale x 2 x float> undef, <vscale x 2 x float> undef, <vscale x 2 x i32> zeroinitializer
  %8 = shufflevector <vscale x 4 x float> undef, <vscale x 4 x float> undef, <vscale x 4 x i32> zeroinitializer
  %9 = shufflevector <vscale x 8 x float> undef, <vscale x 8 x float> undef, <vscale x 8 x i32> zeroinitializer
  %10 = shufflevector <vscale x 16 x float> undef, <vscale x 16 x float> undef, <vscale x 16 x i32> zeroinitializer

  %11 = shufflevector <vscale x 1 x double> undef, <vscale x 1 x double> undef, <vscale x 1 x i32> zeroinitializer
  %12 = shufflevector <vscale x 2 x double> undef, <vscale x 2 x double> undef, <vscale x 2 x i32> zeroinitializer
  %13 = shufflevector <vscale x 4 x double> undef, <vscale x 4 x double> undef, <vscale x 4 x i32> zeroinitializer
  %14 = shufflevector <vscale x 8 x double> undef, <vscale x 8 x double> undef, <vscale x 8 x i32> zeroinitializer

  %15 = shufflevector <vscale x 1 x i8> undef, <vscale x 1 x i8> undef, <vscale x 1 x i32> zeroinitializer
  %16 = shufflevector <vscale x 2 x i8> undef, <vscale x 2 x i8> undef, <vscale x 2 x i32> zeroinitializer
  %17 = shufflevector <vscale x 4 x i8> undef, <vscale x 4 x i8> undef, <vscale x 4 x i32> zeroinitializer
  %18 = shufflevector <vscale x 8 x i8> undef, <vscale x 8 x i8> undef, <vscale x 8 x i32> zeroinitializer
  %19 = shufflevector <vscale x 16 x i8> undef, <vscale x 16 x i8> undef, <vscale x 16 x i32> zeroinitializer
  %20 = shufflevector <vscale x 32 x i8> undef, <vscale x 32 x i8> undef, <vscale x 32 x i32> zeroinitializer
  %21 = shufflevector <vscale x 64 x i8> undef, <vscale x 64 x i8> undef, <vscale x 64 x i32> zeroinitializer

  %22 = shufflevector <vscale x 1 x i16> undef, <vscale x 1 x i16> undef, <vscale x 1 x i32> zeroinitializer
  %23 = shufflevector <vscale x 2 x i16> undef, <vscale x 2 x i16> undef, <vscale x 2 x i32> zeroinitializer
  %24 = shufflevector <vscale x 4 x i16> undef, <vscale x 4 x i16> undef, <vscale x 4 x i32> zeroinitializer
  %25 = shufflevector <vscale x 8 x i16> undef, <vscale x 8 x i16> undef, <vscale x 8 x i32> zeroinitializer
  %26 = shufflevector <vscale x 16 x i16> undef, <vscale x 16 x i16> undef, <vscale x 16 x i32> zeroinitializer
  %27 = shufflevector <vscale x 32 x i16> undef, <vscale x 32 x i16> undef, <vscale x 32 x i32> zeroinitializer

  %28 = shufflevector <vscale x 1 x i32> undef, <vscale x 1 x i32> undef, <vscale x 1 x i32> zeroinitializer
  %29 = shufflevector <vscale x 2 x i32> undef, <vscale x 2 x i32> undef, <vscale x 2 x i32> zeroinitializer
  %30 = shufflevector <vscale x 4 x i32> undef, <vscale x 4 x i32> undef, <vscale x 4 x i32> zeroinitializer
  %31 = shufflevector <vscale x 8 x i32> undef, <vscale x 8 x i32> undef, <vscale x 8 x i32> zeroinitializer
  %32 = shufflevector <vscale x 16 x i32> undef, <vscale x 16 x i32> undef, <vscale x 16 x i32> zeroinitializer

  %33 = shufflevector <vscale x 1 x i64> undef, <vscale x 1 x i64> undef, <vscale x 1 x i32> zeroinitializer
  %34 = shufflevector <vscale x 2 x i64> undef, <vscale x 2 x i64> undef, <vscale x 2 x i32> zeroinitializer
  %35 = shufflevector <vscale x 4 x i64> undef, <vscale x 4 x i64> undef, <vscale x 4 x i32> zeroinitializer
  %36 = shufflevector <vscale x 8 x i64> undef, <vscale x 8 x i64> undef, <vscale x 8 x i32> zeroinitializer

  %37 = shufflevector <vscale x 1 x i1> undef, <vscale x 1 x i1> undef, <vscale x 1 x i32> zeroinitializer
  %38 = shufflevector <vscale x 2 x i1> undef, <vscale x 2 x i1> undef, <vscale x 2 x i32> zeroinitializer
  %39 = shufflevector <vscale x 4 x i1> undef, <vscale x 4 x i1> undef, <vscale x 4 x i32> zeroinitializer
  %40 = shufflevector <vscale x 8 x i1> undef, <vscale x 8 x i1> undef, <vscale x 8 x i32> zeroinitializer
  %41 = shufflevector <vscale x 16 x i1> undef, <vscale x 16 x i1> undef, <vscale x 16 x i32> zeroinitializer
  %42 = shufflevector <vscale x 32 x i1> undef, <vscale x 32 x i1> undef, <vscale x 32 x i32> zeroinitializer
  %43 = shufflevector <vscale x 64 x i1> undef, <vscale x 64 x i1> undef, <vscale x 64 x i32> zeroinitializer
  ret void
}
