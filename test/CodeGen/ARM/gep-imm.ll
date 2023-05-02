; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv6m-none-eabi < %s | FileCheck %s --check-prefix=CHECKV6M
; RUN: llc -mtriple=thumbv7m-none-eabi < %s | FileCheck %s --check-prefix=CHECKV7M
; RUN: llc -mtriple=thumbv7a-none-eabi < %s | FileCheck %s --check-prefix=CHECKV7A

define void @small(i32 %a, i32 %b, ptr %c, ptr %d) {
; CHECKV6M-LABEL: small:
; CHECKV6M:       @ %bb.0: @ %entry
; CHECKV6M-NEXT:    str r1, [r3, #120]
; CHECKV6M-NEXT:    str r0, [r3, #80]
; CHECKV6M-NEXT:    str r0, [r2, #80]
; CHECKV6M-NEXT:    bx lr
;
; CHECKV7M-LABEL: small:
; CHECKV7M:       @ %bb.0: @ %entry
; CHECKV7M-NEXT:    str r1, [r3, #120]
; CHECKV7M-NEXT:    str r0, [r3, #80]
; CHECKV7M-NEXT:    str r0, [r2, #80]
; CHECKV7M-NEXT:    bx lr
;
; CHECKV7A-LABEL: small:
; CHECKV7A:       @ %bb.0: @ %entry
; CHECKV7A-NEXT:    str r1, [r3, #120]
; CHECKV7A-NEXT:    str r0, [r3, #80]
; CHECKV7A-NEXT:    str r0, [r2, #80]
; CHECKV7A-NEXT:    bx lr
entry:
  %arrayidx = getelementptr inbounds i32, ptr %d, i32 20
  store i32 %a, ptr %arrayidx, align 4
  %arrayidx1 = getelementptr inbounds i32, ptr %d, i32 30
  store i32 %b, ptr %arrayidx1, align 4
  %arrayidx2 = getelementptr inbounds i32, ptr %c, i32 20
  store i32 %a, ptr %arrayidx2, align 4
  ret void
}

define void @large(i32 %a, i32 %b, ptr %c, ptr %d) {
; CHECKV6M-LABEL: large:
; CHECKV6M:       @ %bb.0: @ %entry
; CHECKV6M-NEXT:    .save {r4, lr}
; CHECKV6M-NEXT:    push {r4, lr}
; CHECKV6M-NEXT:    ldr r4, .LCPI1_0
; CHECKV6M-NEXT:    str r1, [r3, r4]
; CHECKV6M-NEXT:    movs r1, #125
; CHECKV6M-NEXT:    lsls r1, r1, #6
; CHECKV6M-NEXT:    str r0, [r3, r1]
; CHECKV6M-NEXT:    str r0, [r2, r1]
; CHECKV6M-NEXT:    pop {r4, pc}
; CHECKV6M-NEXT:    .p2align 2
; CHECKV6M-NEXT:  @ %bb.1:
; CHECKV6M-NEXT:  .LCPI1_0:
; CHECKV6M-NEXT:    .long 12000 @ 0x2ee0
;
; CHECKV7M-LABEL: large:
; CHECKV7M:       @ %bb.0: @ %entry
; CHECKV7M-NEXT:    mov.w r12, #8000
; CHECKV7M-NEXT:    str.w r0, [r3, r12]
; CHECKV7M-NEXT:    add.w r3, r3, #8000
; CHECKV7M-NEXT:    str.w r1, [r3, #4000]
; CHECKV7M-NEXT:    str.w r0, [r2, r12]
; CHECKV7M-NEXT:    bx lr
;
; CHECKV7A-LABEL: large:
; CHECKV7A:       @ %bb.0: @ %entry
; CHECKV7A-NEXT:    mov.w r12, #8000
; CHECKV7A-NEXT:    str.w r0, [r3, r12]
; CHECKV7A-NEXT:    add.w r3, r3, #8000
; CHECKV7A-NEXT:    str.w r1, [r3, #4000]
; CHECKV7A-NEXT:    str.w r0, [r2, r12]
; CHECKV7A-NEXT:    bx lr
entry:
  %arrayidx = getelementptr inbounds i32, ptr %d, i32 2000
  store i32 %a, ptr %arrayidx, align 4
  %arrayidx1 = getelementptr inbounds i32, ptr %d, i32 3000
  store i32 %b, ptr %arrayidx1, align 4
  %arrayidx2 = getelementptr inbounds i32, ptr %c, i32 2000
  store i32 %a, ptr %arrayidx2, align 4
  ret void
}

define void @huge(i32 %a, i32 %b, ptr %c, ptr %d) {
; CHECKV6M-LABEL: huge:
; CHECKV6M:       @ %bb.0: @ %entry
; CHECKV6M-NEXT:    .save {r4, lr}
; CHECKV6M-NEXT:    push {r4, lr}
; CHECKV6M-NEXT:    ldr r4, .LCPI2_0
; CHECKV6M-NEXT:    str r1, [r3, r4]
; CHECKV6M-NEXT:    ldr r1, .LCPI2_1
; CHECKV6M-NEXT:    str r0, [r3, r1]
; CHECKV6M-NEXT:    str r0, [r2, r1]
; CHECKV6M-NEXT:    pop {r4, pc}
; CHECKV6M-NEXT:    .p2align 2
; CHECKV6M-NEXT:  @ %bb.1:
; CHECKV6M-NEXT:  .LCPI2_0:
; CHECKV6M-NEXT:    .long 1200000 @ 0x124f80
; CHECKV6M-NEXT:  .LCPI2_1:
; CHECKV6M-NEXT:    .long 800000 @ 0xc3500
;
; CHECKV7M-LABEL: huge:
; CHECKV7M:       @ %bb.0: @ %entry
; CHECKV7M-NEXT:    movw r12, #20352
; CHECKV7M-NEXT:    movt r12, #18
; CHECKV7M-NEXT:    str.w r1, [r3, r12]
; CHECKV7M-NEXT:    movw r1, #13568
; CHECKV7M-NEXT:    movt r1, #12
; CHECKV7M-NEXT:    str r0, [r3, r1]
; CHECKV7M-NEXT:    str r0, [r2, r1]
; CHECKV7M-NEXT:    bx lr
;
; CHECKV7A-LABEL: huge:
; CHECKV7A:       @ %bb.0: @ %entry
; CHECKV7A-NEXT:    movw r12, #20352
; CHECKV7A-NEXT:    movt r12, #18
; CHECKV7A-NEXT:    str.w r1, [r3, r12]
; CHECKV7A-NEXT:    movw r1, #13568
; CHECKV7A-NEXT:    movt r1, #12
; CHECKV7A-NEXT:    str r0, [r3, r1]
; CHECKV7A-NEXT:    str r0, [r2, r1]
; CHECKV7A-NEXT:    bx lr
entry:
  %arrayidx = getelementptr inbounds i32, ptr %d, i32 200000
  store i32 %a, ptr %arrayidx, align 4
  %arrayidx1 = getelementptr inbounds i32, ptr %d, i32 300000
  store i32 %b, ptr %arrayidx1, align 4
  %arrayidx2 = getelementptr inbounds i32, ptr %c, i32 200000
  store i32 %a, ptr %arrayidx2, align 4
  ret void
}
