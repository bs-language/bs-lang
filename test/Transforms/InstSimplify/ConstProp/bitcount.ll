; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instsimplify -S | FileCheck %s

declare i31 @llvm.ctpop.i31(i31 %val)
declare i32 @llvm.cttz.i32(i32 %val, i1)
declare i33 @llvm.ctlz.i33(i33 %val, i1)
declare <2 x i31> @llvm.ctpop.v2i31(<2 x i31> %val)
declare <2 x i32> @llvm.cttz.v2i32(<2 x i32> %val, i1)
declare <2 x i33> @llvm.ctlz.v2i33(<2 x i33> %val, i1)

define i31 @ctpop_const() {
; CHECK-LABEL: @ctpop_const(
; CHECK-NEXT:    ret i31 12
;
  %x = call i31 @llvm.ctpop.i31(i31 12415124)
  ret i31 %x
}

define i32 @cttz_const() {
; CHECK-LABEL: @cttz_const(
; CHECK-NEXT:    ret i32 1
;
  %x = call i32 @llvm.cttz.i32(i32 87359874, i1 true)
  ret i32 %x
}

define i33 @ctlz_const() {
; CHECK-LABEL: @ctlz_const(
; CHECK-NEXT:    ret i33 6
;
  %x = call i33 @llvm.ctlz.i33(i33 87359874, i1 true)
  ret i33 %x
}

define i31 @ctpop_zero() {
; CHECK-LABEL: @ctpop_zero(
; CHECK-NEXT:    ret i31 0
;
  %x = call i31 @llvm.ctpop.i31(i31 0)
  ret i31 %x
}

define i32 @cttz_zero_defined() {
; CHECK-LABEL: @cttz_zero_defined(
; CHECK-NEXT:    ret i32 32
;
  %x = call i32 @llvm.cttz.i32(i32 0, i1 false)
  ret i32 %x
}

define i32 @cttz_zero_is_poison() {
; CHECK-LABEL: @cttz_zero_is_poison(
; CHECK-NEXT:    ret i32 poison
;
  %x = call i32 @llvm.cttz.i32(i32 0, i1 true)
  ret i32 %x
}

define i33 @ctlz_zero_defined() {
; CHECK-LABEL: @ctlz_zero_defined(
; CHECK-NEXT:    ret i33 33
;
  %x = call i33 @llvm.ctlz.i33(i33 0, i1 false)
  ret i33 %x
}

define i33 @ctlz_zero_is_poison() {
; CHECK-LABEL: @ctlz_zero_is_poison(
; CHECK-NEXT:    ret i33 poison
;
  %x = call i33 @llvm.ctlz.i33(i33 0, i1 true)
  ret i33 %x
}

define i31 @ctpop_undef() {
; CHECK-LABEL: @ctpop_undef(
; CHECK-NEXT:    ret i31 0
;
  %x = call i31 @llvm.ctpop.i31(i31 undef)
  ret i31 %x
}

define i32 @cttz_undef_defined() {
; CHECK-LABEL: @cttz_undef_defined(
; CHECK-NEXT:    ret i32 0
;
  %x = call i32 @llvm.cttz.i32(i32 undef, i1 false)
  ret i32 %x
}

define i32 @cttz_undef_zero_is_poison() {
; CHECK-LABEL: @cttz_undef_zero_is_poison(
; CHECK-NEXT:    ret i32 poison
;
  %x = call i32 @llvm.cttz.i32(i32 undef, i1 true)
  ret i32 %x
}

define i33 @ctlz_undef_defined() {
; CHECK-LABEL: @ctlz_undef_defined(
; CHECK-NEXT:    ret i33 0
;
  %x = call i33 @llvm.ctlz.i33(i33 undef, i1 false)
  ret i33 %x
}

define i33 @ctlz_undef_zero_is_poison() {
; CHECK-LABEL: @ctlz_undef_zero_is_poison(
; CHECK-NEXT:    ret i33 poison
;
  %x = call i33 @llvm.ctlz.i33(i33 undef, i1 true)
  ret i33 %x
}

define <2 x i31> @ctpop_vector() {
; CHECK-LABEL: @ctpop_vector(
; CHECK-NEXT:    ret <2 x i31> <i31 8, i31 1>
;
  %x = call <2 x i31> @llvm.ctpop.v2i31(<2 x i31> <i31 255, i31 16>)
  ret <2 x i31> %x
}

define <2 x i31> @ctpop_vector_undef() {
; CHECK-LABEL: @ctpop_vector_undef(
; CHECK-NEXT:    ret <2 x i31> zeroinitializer
;
  %x = call <2 x i31> @llvm.ctpop.v2i31(<2 x i31> <i31 0, i31 undef>)
  ret <2 x i31> %x
}

define <2 x i32> @cttz_vector() {
; CHECK-LABEL: @cttz_vector(
; CHECK-NEXT:    ret <2 x i32> <i32 0, i32 4>
;
  %x = call <2 x i32> @llvm.cttz.v2i32(<2 x i32> <i32 255, i32 16>, i1 true)
  ret <2 x i32> %x
}

define <2 x i32> @cttz_vector_undef_defined() {
; CHECK-LABEL: @cttz_vector_undef_defined(
; CHECK-NEXT:    ret <2 x i32> <i32 32, i32 0>
;
  %x = call <2 x i32> @llvm.cttz.v2i32(<2 x i32> <i32 0, i32 undef>, i1 false)
  ret <2 x i32> %x
}

define <2 x i32> @cttz_vector_undef_zero_is_poison() {
; CHECK-LABEL: @cttz_vector_undef_zero_is_poison(
; CHECK-NEXT:    ret <2 x i32> poison
;
  %x = call <2 x i32> @llvm.cttz.v2i32(<2 x i32> <i32 0, i32 undef>, i1 true)
  ret <2 x i32> %x
}

define <2 x i33> @ctlz_vector() {
; CHECK-LABEL: @ctlz_vector(
; CHECK-NEXT:    ret <2 x i33> <i33 25, i33 28>
;
  %x = call <2 x i33> @llvm.ctlz.v2i33(<2 x i33> <i33 255, i33 16>, i1 true)
  ret <2 x i33> %x
}

define <2 x i33> @ctlz_vector_undef_defined() {
; CHECK-LABEL: @ctlz_vector_undef_defined(
; CHECK-NEXT:    ret <2 x i33> <i33 33, i33 0>
;
  %x = call <2 x i33> @llvm.ctlz.v2i33(<2 x i33> <i33 0, i33 undef>, i1 false)
  ret <2 x i33> %x
}

define <2 x i33> @ctlz_vector_undef_zero_is_poison() {
; CHECK-LABEL: @ctlz_vector_undef_zero_is_poison(
; CHECK-NEXT:    ret <2 x i33> poison
;
  %x = call <2 x i33> @llvm.ctlz.v2i33(<2 x i33> <i33 0, i33 undef>, i1 true)
  ret <2 x i33> %x
}
