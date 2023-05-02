; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc --mtriple=loongarch32 < %s | FileCheck %s --check-prefix=LA32
; RUN: llc --mtriple=loongarch64 < %s | FileCheck %s --check-prefix=LA64

;; Exercise the 'add' LLVM IR: https://llvm.org/docs/LangRef.html#add-instruction

define i1 @add_i1(i1 %x, i1 %y) {
; LA32-LABEL: add_i1:
; LA32:       # %bb.0:
; LA32-NEXT:    add.w $a0, $a0, $a1
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i1:
; LA64:       # %bb.0:
; LA64-NEXT:    add.d $a0, $a0, $a1
; LA64-NEXT:    ret
  %add = add i1 %x, %y
  ret i1 %add
}

define i8 @add_i8(i8 %x, i8 %y) {
; LA32-LABEL: add_i8:
; LA32:       # %bb.0:
; LA32-NEXT:    add.w $a0, $a0, $a1
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i8:
; LA64:       # %bb.0:
; LA64-NEXT:    add.d $a0, $a0, $a1
; LA64-NEXT:    ret
  %add = add i8 %x, %y
  ret i8 %add
}

define i16 @add_i16(i16 %x, i16 %y) {
; LA32-LABEL: add_i16:
; LA32:       # %bb.0:
; LA32-NEXT:    add.w $a0, $a0, $a1
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i16:
; LA64:       # %bb.0:
; LA64-NEXT:    add.d $a0, $a0, $a1
; LA64-NEXT:    ret
  %add = add i16 %x, %y
  ret i16 %add
}

define i32 @add_i32(i32 %x, i32 %y) {
; LA32-LABEL: add_i32:
; LA32:       # %bb.0:
; LA32-NEXT:    add.w $a0, $a0, $a1
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i32:
; LA64:       # %bb.0:
; LA64-NEXT:    add.d $a0, $a0, $a1
; LA64-NEXT:    ret
  %add = add i32 %x, %y
  ret i32 %add
}

;; Match the pattern:
;; def : PatGprGpr_32<add, ADD_W>;
define signext i32 @add_i32_sext(i32 %x, i32 %y) {
; LA32-LABEL: add_i32_sext:
; LA32:       # %bb.0:
; LA32-NEXT:    add.w $a0, $a0, $a1
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i32_sext:
; LA64:       # %bb.0:
; LA64-NEXT:    add.w $a0, $a0, $a1
; LA64-NEXT:    ret
  %add = add i32 %x, %y
  ret i32 %add
}

define i64 @add_i64(i64 %x, i64 %y) {
; LA32-LABEL: add_i64:
; LA32:       # %bb.0:
; LA32-NEXT:    add.w $a1, $a1, $a3
; LA32-NEXT:    add.w $a2, $a0, $a2
; LA32-NEXT:    sltu $a0, $a2, $a0
; LA32-NEXT:    add.w $a1, $a1, $a0
; LA32-NEXT:    move $a0, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i64:
; LA64:       # %bb.0:
; LA64-NEXT:    add.d $a0, $a0, $a1
; LA64-NEXT:    ret
  %add = add i64 %x, %y
  ret i64 %add
}

define i1 @add_i1_3(i1 %x) {
; LA32-LABEL: add_i1_3:
; LA32:       # %bb.0:
; LA32-NEXT:    addi.w $a0, $a0, 1
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i1_3:
; LA64:       # %bb.0:
; LA64-NEXT:    addi.d $a0, $a0, 1
; LA64-NEXT:    ret
  %add = add i1 %x, 3
  ret i1 %add
}

define i8 @add_i8_3(i8 %x) {
; LA32-LABEL: add_i8_3:
; LA32:       # %bb.0:
; LA32-NEXT:    addi.w $a0, $a0, 3
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i8_3:
; LA64:       # %bb.0:
; LA64-NEXT:    addi.d $a0, $a0, 3
; LA64-NEXT:    ret
  %add = add i8 %x, 3
  ret i8 %add
}

define i16 @add_i16_3(i16 %x) {
; LA32-LABEL: add_i16_3:
; LA32:       # %bb.0:
; LA32-NEXT:    addi.w $a0, $a0, 3
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i16_3:
; LA64:       # %bb.0:
; LA64-NEXT:    addi.d $a0, $a0, 3
; LA64-NEXT:    ret
  %add = add i16 %x, 3
  ret i16 %add
}

define i32 @add_i32_3(i32 %x) {
; LA32-LABEL: add_i32_3:
; LA32:       # %bb.0:
; LA32-NEXT:    addi.w $a0, $a0, 3
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i32_3:
; LA64:       # %bb.0:
; LA64-NEXT:    addi.d $a0, $a0, 3
; LA64-NEXT:    ret
  %add = add i32 %x, 3
  ret i32 %add
}

;; Match the pattern:
;; def : PatGprImm_32<add, ADDI_W, simm12>;
define signext i32 @add_i32_3_sext(i32 %x) {
; LA32-LABEL: add_i32_3_sext:
; LA32:       # %bb.0:
; LA32-NEXT:    addi.w $a0, $a0, 3
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i32_3_sext:
; LA64:       # %bb.0:
; LA64-NEXT:    addi.w $a0, $a0, 3
; LA64-NEXT:    ret
  %add = add i32 %x, 3
  ret i32 %add
}

define i64 @add_i64_3(i64 %x) {
; LA32-LABEL: add_i64_3:
; LA32:       # %bb.0:
; LA32-NEXT:    addi.w $a2, $a0, 3
; LA32-NEXT:    sltu $a0, $a2, $a0
; LA32-NEXT:    add.w $a1, $a1, $a0
; LA32-NEXT:    move $a0, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i64_3:
; LA64:       # %bb.0:
; LA64-NEXT:    addi.d $a0, $a0, 3
; LA64-NEXT:    ret
  %add = add i64 %x, 3
  ret i64 %add
}

;; Check that `addu16i.d` is emitted for these cases.

define i32 @add_i32_0x12340000(i32 %x) {
; LA32-LABEL: add_i32_0x12340000:
; LA32:       # %bb.0:
; LA32-NEXT:    lu12i.w $a1, 74560
; LA32-NEXT:    add.w $a0, $a0, $a1
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i32_0x12340000:
; LA64:       # %bb.0:
; LA64-NEXT:    addu16i.d $a0, $a0, 4660
; LA64-NEXT:    ret
  %add = add i32 %x, 305397760
  ret i32 %add
}

define signext i32 @add_i32_0x12340000_sext(i32 %x) {
; LA32-LABEL: add_i32_0x12340000_sext:
; LA32:       # %bb.0:
; LA32-NEXT:    lu12i.w $a1, 74560
; LA32-NEXT:    add.w $a0, $a0, $a1
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i32_0x12340000_sext:
; LA64:       # %bb.0:
; LA64-NEXT:    addu16i.d $a0, $a0, 4660
; LA64-NEXT:    addi.w $a0, $a0, 0
; LA64-NEXT:    ret
  %add = add i32 %x, 305397760
  ret i32 %add
}

define i64 @add_i64_0x12340000(i64 %x) {
; LA32-LABEL: add_i64_0x12340000:
; LA32:       # %bb.0:
; LA32-NEXT:    lu12i.w $a2, 74560
; LA32-NEXT:    add.w $a2, $a0, $a2
; LA32-NEXT:    sltu $a0, $a2, $a0
; LA32-NEXT:    add.w $a1, $a1, $a0
; LA32-NEXT:    move $a0, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i64_0x12340000:
; LA64:       # %bb.0:
; LA64-NEXT:    addu16i.d $a0, $a0, 4660
; LA64-NEXT:    ret
  %add = add i64 %x, 305397760
  ret i64 %add
}

define i32 @add_i32_0x7fff0000(i32 %x) {
; LA32-LABEL: add_i32_0x7fff0000:
; LA32:       # %bb.0:
; LA32-NEXT:    lu12i.w $a1, 524272
; LA32-NEXT:    add.w $a0, $a0, $a1
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i32_0x7fff0000:
; LA64:       # %bb.0:
; LA64-NEXT:    addu16i.d $a0, $a0, 32767
; LA64-NEXT:    ret
  %add = add i32 %x, 2147418112
  ret i32 %add
}

define signext i32 @add_i32_0x7fff0000_sext(i32 %x) {
; LA32-LABEL: add_i32_0x7fff0000_sext:
; LA32:       # %bb.0:
; LA32-NEXT:    lu12i.w $a1, 524272
; LA32-NEXT:    add.w $a0, $a0, $a1
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i32_0x7fff0000_sext:
; LA64:       # %bb.0:
; LA64-NEXT:    addu16i.d $a0, $a0, 32767
; LA64-NEXT:    addi.w $a0, $a0, 0
; LA64-NEXT:    ret
  %add = add i32 %x, 2147418112
  ret i32 %add
}

define i64 @add_i64_0x7fff0000(i64 %x) {
; LA32-LABEL: add_i64_0x7fff0000:
; LA32:       # %bb.0:
; LA32-NEXT:    lu12i.w $a2, 524272
; LA32-NEXT:    add.w $a2, $a0, $a2
; LA32-NEXT:    sltu $a0, $a2, $a0
; LA32-NEXT:    add.w $a1, $a1, $a0
; LA32-NEXT:    move $a0, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i64_0x7fff0000:
; LA64:       # %bb.0:
; LA64-NEXT:    addu16i.d $a0, $a0, 32767
; LA64-NEXT:    ret
  %add = add i64 %x, 2147418112
  ret i64 %add
}

define i32 @add_i32_minus_0x80000000(i32 %x) {
; LA32-LABEL: add_i32_minus_0x80000000:
; LA32:       # %bb.0:
; LA32-NEXT:    lu12i.w $a1, -524288
; LA32-NEXT:    add.w $a0, $a0, $a1
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i32_minus_0x80000000:
; LA64:       # %bb.0:
; LA64-NEXT:    addu16i.d $a0, $a0, -32768
; LA64-NEXT:    ret
  %add = add i32 %x, -2147483648
  ret i32 %add
}

define signext i32 @add_i32_minus_0x80000000_sext(i32 %x) {
; LA32-LABEL: add_i32_minus_0x80000000_sext:
; LA32:       # %bb.0:
; LA32-NEXT:    lu12i.w $a1, -524288
; LA32-NEXT:    add.w $a0, $a0, $a1
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i32_minus_0x80000000_sext:
; LA64:       # %bb.0:
; LA64-NEXT:    addu16i.d $a0, $a0, -32768
; LA64-NEXT:    addi.w $a0, $a0, 0
; LA64-NEXT:    ret
  %add = add i32 %x, -2147483648
  ret i32 %add
}

define i64 @add_i64_minus_0x80000000(i64 %x) {
; LA32-LABEL: add_i64_minus_0x80000000:
; LA32:       # %bb.0:
; LA32-NEXT:    lu12i.w $a2, -524288
; LA32-NEXT:    add.w $a2, $a0, $a2
; LA32-NEXT:    sltu $a0, $a2, $a0
; LA32-NEXT:    add.w $a0, $a1, $a0
; LA32-NEXT:    addi.w $a1, $a0, -1
; LA32-NEXT:    move $a0, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i64_minus_0x80000000:
; LA64:       # %bb.0:
; LA64-NEXT:    addu16i.d $a0, $a0, -32768
; LA64-NEXT:    ret
  %add = add i64 %x, -2147483648
  ret i64 %add
}

define i32 @add_i32_minus_0x10000(i32 %x) {
; LA32-LABEL: add_i32_minus_0x10000:
; LA32:       # %bb.0:
; LA32-NEXT:    lu12i.w $a1, -16
; LA32-NEXT:    add.w $a0, $a0, $a1
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i32_minus_0x10000:
; LA64:       # %bb.0:
; LA64-NEXT:    addu16i.d $a0, $a0, -1
; LA64-NEXT:    ret
  %add = add i32 %x, -65536
  ret i32 %add
}

define signext i32 @add_i32_minus_0x10000_sext(i32 %x) {
; LA32-LABEL: add_i32_minus_0x10000_sext:
; LA32:       # %bb.0:
; LA32-NEXT:    lu12i.w $a1, -16
; LA32-NEXT:    add.w $a0, $a0, $a1
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i32_minus_0x10000_sext:
; LA64:       # %bb.0:
; LA64-NEXT:    addu16i.d $a0, $a0, -1
; LA64-NEXT:    addi.w $a0, $a0, 0
; LA64-NEXT:    ret
  %add = add i32 %x, -65536
  ret i32 %add
}

define i64 @add_i64_minus_0x10000(i64 %x) {
; LA32-LABEL: add_i64_minus_0x10000:
; LA32:       # %bb.0:
; LA32-NEXT:    lu12i.w $a2, -16
; LA32-NEXT:    add.w $a2, $a0, $a2
; LA32-NEXT:    sltu $a0, $a2, $a0
; LA32-NEXT:    add.w $a0, $a1, $a0
; LA32-NEXT:    addi.w $a1, $a0, -1
; LA32-NEXT:    move $a0, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i64_minus_0x10000:
; LA64:       # %bb.0:
; LA64-NEXT:    addu16i.d $a0, $a0, -1
; LA64-NEXT:    ret
  %add = add i64 %x, -65536
  ret i64 %add
}

;; Check that `addu16i.d + addi` is emitted for these cases.

define i32 @add_i32_0x7fff07ff(i32 %x) {
; LA32-LABEL: add_i32_0x7fff07ff:
; LA32:       # %bb.0:
; LA32-NEXT:    lu12i.w $a1, 524272
; LA32-NEXT:    ori $a1, $a1, 2047
; LA32-NEXT:    add.w $a0, $a0, $a1
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i32_0x7fff07ff:
; LA64:       # %bb.0:
; LA64-NEXT:    addu16i.d $a0, $a0, 32767
; LA64-NEXT:    addi.d $a0, $a0, 2047
; LA64-NEXT:    ret
  %add = add i32 %x, 2147420159
  ret i32 %add
}

define signext i32 @add_i32_0x7fff07ff_sext(i32 %x) {
; LA32-LABEL: add_i32_0x7fff07ff_sext:
; LA32:       # %bb.0:
; LA32-NEXT:    lu12i.w $a1, 524272
; LA32-NEXT:    ori $a1, $a1, 2047
; LA32-NEXT:    add.w $a0, $a0, $a1
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i32_0x7fff07ff_sext:
; LA64:       # %bb.0:
; LA64-NEXT:    addu16i.d $a0, $a0, 32767
; LA64-NEXT:    addi.w $a0, $a0, 2047
; LA64-NEXT:    ret
  %add = add i32 %x, 2147420159
  ret i32 %add
}

define i64 @add_i64_0x7fff07ff(i64 %x) {
; LA32-LABEL: add_i64_0x7fff07ff:
; LA32:       # %bb.0:
; LA32-NEXT:    lu12i.w $a2, 524272
; LA32-NEXT:    ori $a2, $a2, 2047
; LA32-NEXT:    add.w $a2, $a0, $a2
; LA32-NEXT:    sltu $a0, $a2, $a0
; LA32-NEXT:    add.w $a1, $a1, $a0
; LA32-NEXT:    move $a0, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i64_0x7fff07ff:
; LA64:       # %bb.0:
; LA64-NEXT:    addu16i.d $a0, $a0, 32767
; LA64-NEXT:    addi.d $a0, $a0, 2047
; LA64-NEXT:    ret
  %add = add i64 %x, 2147420159
  ret i64 %add
}

define i32 @add_i32_0x7ffef800(i32 %x) {
; LA32-LABEL: add_i32_0x7ffef800:
; LA32:       # %bb.0:
; LA32-NEXT:    lu12i.w $a1, 524271
; LA32-NEXT:    ori $a1, $a1, 2048
; LA32-NEXT:    add.w $a0, $a0, $a1
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i32_0x7ffef800:
; LA64:       # %bb.0:
; LA64-NEXT:    addu16i.d $a0, $a0, 32767
; LA64-NEXT:    addi.d $a0, $a0, -2048
; LA64-NEXT:    ret
  %add = add i32 %x, 2147416064
  ret i32 %add
}

define signext i32 @add_i32_0x7ffef800_sext(i32 %x) {
; LA32-LABEL: add_i32_0x7ffef800_sext:
; LA32:       # %bb.0:
; LA32-NEXT:    lu12i.w $a1, 524271
; LA32-NEXT:    ori $a1, $a1, 2048
; LA32-NEXT:    add.w $a0, $a0, $a1
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i32_0x7ffef800_sext:
; LA64:       # %bb.0:
; LA64-NEXT:    addu16i.d $a0, $a0, 32767
; LA64-NEXT:    addi.w $a0, $a0, -2048
; LA64-NEXT:    ret
  %add = add i32 %x, 2147416064
  ret i32 %add
}

define i64 @add_i64_0x7ffef800(i64 %x) {
; LA32-LABEL: add_i64_0x7ffef800:
; LA32:       # %bb.0:
; LA32-NEXT:    lu12i.w $a2, 524271
; LA32-NEXT:    ori $a2, $a2, 2048
; LA32-NEXT:    add.w $a2, $a0, $a2
; LA32-NEXT:    sltu $a0, $a2, $a0
; LA32-NEXT:    add.w $a1, $a1, $a0
; LA32-NEXT:    move $a0, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i64_0x7ffef800:
; LA64:       # %bb.0:
; LA64-NEXT:    addu16i.d $a0, $a0, 32767
; LA64-NEXT:    addi.d $a0, $a0, -2048
; LA64-NEXT:    ret
  %add = add i64 %x, 2147416064
  ret i64 %add
}

define i64 @add_i64_minus_0x80000800(i64 %x) {
; LA32-LABEL: add_i64_minus_0x80000800:
; LA32:       # %bb.0:
; LA32-NEXT:    lu12i.w $a2, 524287
; LA32-NEXT:    ori $a2, $a2, 2048
; LA32-NEXT:    add.w $a2, $a0, $a2
; LA32-NEXT:    sltu $a0, $a2, $a0
; LA32-NEXT:    add.w $a0, $a1, $a0
; LA32-NEXT:    addi.w $a1, $a0, -1
; LA32-NEXT:    move $a0, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i64_minus_0x80000800:
; LA64:       # %bb.0:
; LA64-NEXT:    addu16i.d $a0, $a0, -32768
; LA64-NEXT:    addi.d $a0, $a0, -2048
; LA64-NEXT:    ret
  %add = add i64 %x, -2147485696
  ret i64 %add
}

define i32 @add_i32_minus_0x23450679(i32 %x) {
; LA32-LABEL: add_i32_minus_0x23450679:
; LA32:       # %bb.0:
; LA32-NEXT:    lu12i.w $a1, -144465
; LA32-NEXT:    ori $a1, $a1, 2439
; LA32-NEXT:    add.w $a0, $a0, $a1
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i32_minus_0x23450679:
; LA64:       # %bb.0:
; LA64-NEXT:    addu16i.d $a0, $a0, -9029
; LA64-NEXT:    addi.d $a0, $a0, -1657
; LA64-NEXT:    ret
  %add = add i32 %x, -591726201
  ret i32 %add
}

define signext i32 @add_i32_minus_0x23450679_sext(i32 %x) {
; LA32-LABEL: add_i32_minus_0x23450679_sext:
; LA32:       # %bb.0:
; LA32-NEXT:    lu12i.w $a1, -144465
; LA32-NEXT:    ori $a1, $a1, 2439
; LA32-NEXT:    add.w $a0, $a0, $a1
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i32_minus_0x23450679_sext:
; LA64:       # %bb.0:
; LA64-NEXT:    addu16i.d $a0, $a0, -9029
; LA64-NEXT:    addi.w $a0, $a0, -1657
; LA64-NEXT:    ret
  %add = add i32 %x, -591726201
  ret i32 %add
}

define i64 @add_i64_minus_0x23450679(i64 %x) {
; LA32-LABEL: add_i64_minus_0x23450679:
; LA32:       # %bb.0:
; LA32-NEXT:    lu12i.w $a2, -144465
; LA32-NEXT:    ori $a2, $a2, 2439
; LA32-NEXT:    add.w $a2, $a0, $a2
; LA32-NEXT:    sltu $a0, $a2, $a0
; LA32-NEXT:    add.w $a0, $a1, $a0
; LA32-NEXT:    addi.w $a1, $a0, -1
; LA32-NEXT:    move $a0, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i64_minus_0x23450679:
; LA64:       # %bb.0:
; LA64-NEXT:    addu16i.d $a0, $a0, -9029
; LA64-NEXT:    addi.d $a0, $a0, -1657
; LA64-NEXT:    ret
  %add = add i64 %x, -591726201
  ret i64 %add
}

define i32 @add_i32_minus_0x2345fedd(i32 %x) {
; LA32-LABEL: add_i32_minus_0x2345fedd:
; LA32:       # %bb.0:
; LA32-NEXT:    lu12i.w $a1, -144480
; LA32-NEXT:    ori $a1, $a1, 291
; LA32-NEXT:    add.w $a0, $a0, $a1
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i32_minus_0x2345fedd:
; LA64:       # %bb.0:
; LA64-NEXT:    addu16i.d $a0, $a0, -9030
; LA64-NEXT:    addi.d $a0, $a0, 291
; LA64-NEXT:    ret
  %add = add i32 %x, -591789789
  ret i32 %add
}

define signext i32 @add_i32_minus_0x2345fedd_sext(i32 %x) {
; LA32-LABEL: add_i32_minus_0x2345fedd_sext:
; LA32:       # %bb.0:
; LA32-NEXT:    lu12i.w $a1, -144480
; LA32-NEXT:    ori $a1, $a1, 291
; LA32-NEXT:    add.w $a0, $a0, $a1
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i32_minus_0x2345fedd_sext:
; LA64:       # %bb.0:
; LA64-NEXT:    addu16i.d $a0, $a0, -9030
; LA64-NEXT:    addi.w $a0, $a0, 291
; LA64-NEXT:    ret
  %add = add i32 %x, -591789789
  ret i32 %add
}

define i64 @add_i64_minus_0x2345fedd(i64 %x) {
; LA32-LABEL: add_i64_minus_0x2345fedd:
; LA32:       # %bb.0:
; LA32-NEXT:    lu12i.w $a2, -144480
; LA32-NEXT:    ori $a2, $a2, 291
; LA32-NEXT:    add.w $a2, $a0, $a2
; LA32-NEXT:    sltu $a0, $a2, $a0
; LA32-NEXT:    add.w $a0, $a1, $a0
; LA32-NEXT:    addi.w $a1, $a0, -1
; LA32-NEXT:    move $a0, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i64_minus_0x2345fedd:
; LA64:       # %bb.0:
; LA64-NEXT:    addu16i.d $a0, $a0, -9030
; LA64-NEXT:    addi.d $a0, $a0, 291
; LA64-NEXT:    ret
  %add = add i64 %x, -591789789
  ret i64 %add
}

;; Check that `addu16i.d` isn't used for the following cases.

define i64 @add_i64_0x80000000(i64 %x) {
; LA32-LABEL: add_i64_0x80000000:
; LA32:       # %bb.0:
; LA32-NEXT:    lu12i.w $a2, -524288
; LA32-NEXT:    add.w $a2, $a0, $a2
; LA32-NEXT:    sltu $a0, $a2, $a0
; LA32-NEXT:    add.w $a1, $a1, $a0
; LA32-NEXT:    move $a0, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i64_0x80000000:
; LA64:       # %bb.0:
; LA64-NEXT:    lu12i.w $a1, -524288
; LA64-NEXT:    lu32i.d $a1, 0
; LA64-NEXT:    add.d $a0, $a0, $a1
; LA64-NEXT:    ret
  %add = add i64 %x, 2147483648
  ret i64 %add
}

define i64 @add_i64_0xffff0000(i64 %x) {
; LA32-LABEL: add_i64_0xffff0000:
; LA32:       # %bb.0:
; LA32-NEXT:    lu12i.w $a2, -16
; LA32-NEXT:    add.w $a2, $a0, $a2
; LA32-NEXT:    sltu $a0, $a2, $a0
; LA32-NEXT:    add.w $a1, $a1, $a0
; LA32-NEXT:    move $a0, $a2
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i64_0xffff0000:
; LA64:       # %bb.0:
; LA64-NEXT:    lu12i.w $a1, -16
; LA64-NEXT:    lu32i.d $a1, 0
; LA64-NEXT:    add.d $a0, $a0, $a1
; LA64-NEXT:    ret
  %add = add i64 %x, 4294901760
  ret i64 %add
}

;; -0x80000800 is equivalent to +0x7ffff800 in i32, so addu16i.d isn't matched
;; in this case.
define i32 @add_i32_minus_0x80000800(i32 %x) {
; LA32-LABEL: add_i32_minus_0x80000800:
; LA32:       # %bb.0:
; LA32-NEXT:    lu12i.w $a1, 524287
; LA32-NEXT:    ori $a1, $a1, 2048
; LA32-NEXT:    add.w $a0, $a0, $a1
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i32_minus_0x80000800:
; LA64:       # %bb.0:
; LA64-NEXT:    lu12i.w $a1, 524287
; LA64-NEXT:    ori $a1, $a1, 2048
; LA64-NEXT:    add.d $a0, $a0, $a1
; LA64-NEXT:    ret
  %add = add i32 %x, -2147485696
  ret i32 %add
}

define signext i32 @add_i32_minus_0x80000800_sext(i32 %x) {
; LA32-LABEL: add_i32_minus_0x80000800_sext:
; LA32:       # %bb.0:
; LA32-NEXT:    lu12i.w $a1, 524287
; LA32-NEXT:    ori $a1, $a1, 2048
; LA32-NEXT:    add.w $a0, $a0, $a1
; LA32-NEXT:    ret
;
; LA64-LABEL: add_i32_minus_0x80000800_sext:
; LA64:       # %bb.0:
; LA64-NEXT:    lu12i.w $a1, 524287
; LA64-NEXT:    ori $a1, $a1, 2048
; LA64-NEXT:    add.w $a0, $a0, $a1
; LA64-NEXT:    ret
  %add = add i32 %x, -2147485696
  ret i32 %add
}
