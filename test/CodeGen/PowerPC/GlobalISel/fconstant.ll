; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py

; RUN: llc -mtriple=powerpc64le-unknown-linux-gnu -global-isel -code-model=small \
; RUN:   -verify-machineinstrs -o - < %s | FileCheck %s --check-prefix=SMALL
; RUN: llc -mtriple=powerpc64le-unknown-linux-gnu -global-isel -code-model=medium \
; RUN:   -verify-machineinstrs -o - < %s | FileCheck %s --check-prefix=MEDIUM
; RUN: llc -mtriple=powerpc64le-unknown-linux-gnu -global-isel -code-model=large \
; RUN:   -verify-machineinstrs -o - < %s | FileCheck %s --check-prefix=LARGE

define float @foo_float() {
; SMALL-LABEL: foo_float:
; SMALL:       # %bb.0: # %entry
; SMALL-NEXT:    ld 3, .LC0@toc(2)
; SMALL-NEXT:    lfs 1, 0(3)
; SMALL-NEXT:    blr
;
; MEDIUM-LABEL: foo_float:
; MEDIUM:       # %bb.0: # %entry
; MEDIUM-NEXT:    addis 3, 2, .LCPI0_0@toc@ha
; MEDIUM-NEXT:    addi 3, 3, .LCPI0_0@toc@l
; MEDIUM-NEXT:    lfs 1, 0(3)
; MEDIUM-NEXT:    blr
;
; LARGE-LABEL: foo_float:
; LARGE:       # %bb.0: # %entry
; LARGE-NEXT:    addis 3, 2, .LC0@toc@ha
; LARGE-NEXT:    ld 3, .LC0@toc@l(3)
; LARGE-NEXT:    lfs 1, 0(3)
; LARGE-NEXT:    blr
entry:
  ret float 1.000000e+00
}

define double @foo_double() {
; SMALL-LABEL: foo_double:
; SMALL:       # %bb.0: # %entry
; SMALL-NEXT:    ld 3, .LC1@toc(2)
; SMALL-NEXT:    lfd 1, 0(3)
; SMALL-NEXT:    blr
;
; MEDIUM-LABEL: foo_double:
; MEDIUM:       # %bb.0: # %entry
; MEDIUM-NEXT:    addis 3, 2, .LCPI1_0@toc@ha
; MEDIUM-NEXT:    addi 3, 3, .LCPI1_0@toc@l
; MEDIUM-NEXT:    lfd 1, 0(3)
; MEDIUM-NEXT:    blr
;
; LARGE-LABEL: foo_double:
; LARGE:       # %bb.0: # %entry
; LARGE-NEXT:    addis 3, 2, .LC1@toc@ha
; LARGE-NEXT:    ld 3, .LC1@toc@l(3)
; LARGE-NEXT:    lfd 1, 0(3)
; LARGE-NEXT:    blr
entry:
  ret double 1.000000e+00
}
