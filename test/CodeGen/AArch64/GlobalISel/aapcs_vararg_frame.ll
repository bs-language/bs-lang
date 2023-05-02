; RUN: llc < %s --global-isel=0 -mtriple=aarch64-linux-gnu -mattr=+fp-armv8 | FileCheck %s
; RUN: llc < %s --global-isel=1 -mtriple=aarch64-linux-gnu -mattr=+fp-armv8 | FileCheck %s --check-prefix=GISEL

define void @va(i32 %count, half %f, ...) nounwind {
; CHECK-LABEL: va:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    sub sp, sp, #176
; CHECK-NEXT:    stp x4, x5, [sp, #144]
; CHECK-NEXT:    stp x2, x3, [sp, #128]
; CHECK-NEXT:    str x1, [sp, #120]
; CHECK-NEXT:    stp x6, x7, [sp, #160]
; CHECK-NEXT:    stp q1, q2, [sp]
; CHECK-NEXT:    stp q3, q4, [sp, #32]
; CHECK-NEXT:    stp q5, q6, [sp, #64]
; CHECK-NEXT:    str q7, [sp, #96]
; CHECK-NEXT:    add sp, sp, #176
; CHECK-NEXT:    ret
;
; GISEL-LABEL: va:
; GISEL:       // %bb.0: // %entry
; GISEL-NEXT:    sub sp, sp, #176
; GISEL-NEXT:    stp x1, x2, [sp, #120]
; GISEL-NEXT:    stp x3, x4, [sp, #136]
; GISEL-NEXT:    stp x5, x6, [sp, #152]
; GISEL-NEXT:    str x7, [sp, #168]
; GISEL-NEXT:    stp q1, q2, [sp]
; GISEL-NEXT:    stp q3, q4, [sp, #32]
; GISEL-NEXT:    stp q5, q6, [sp, #64]
; GISEL-NEXT:    str q7, [sp, #96]
; GISEL-NEXT:    add sp, sp, #176
; GISEL-NEXT:    ret
entry:
  ret void
}
