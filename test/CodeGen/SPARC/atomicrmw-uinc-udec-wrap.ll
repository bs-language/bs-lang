; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=sparc -mcpu=v9 < %s | FileCheck %s

define i8 @atomicrmw_uinc_wrap_i8(ptr %ptr, i8 %val) {
; CHECK-LABEL: atomicrmw_uinc_wrap_i8:
; CHECK:         .cfi_startproc
; CHECK-NEXT:  ! %bb.0:
; CHECK-NEXT:    membar #LoadLoad | #StoreLoad | #LoadStore | #StoreStore
; CHECK-NEXT:    and %o0, -4, %o2
; CHECK-NEXT:    mov 3, %o3
; CHECK-NEXT:    andn %o3, %o0, %o0
; CHECK-NEXT:    sll %o0, 3, %o0
; CHECK-NEXT:    mov 255, %o3
; CHECK-NEXT:    ld [%o2], %o4
; CHECK-NEXT:    sll %o3, %o0, %o3
; CHECK-NEXT:    xor %o3, -1, %o3
; CHECK-NEXT:    and %o1, 255, %o1
; CHECK-NEXT:  .LBB0_1: ! %atomicrmw.start
; CHECK-NEXT:    ! =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    mov %o4, %o5
; CHECK-NEXT:    srl %o4, %o0, %o4
; CHECK-NEXT:    and %o4, 255, %g2
; CHECK-NEXT:    add %o4, 1, %o4
; CHECK-NEXT:    cmp %g2, %o1
; CHECK-NEXT:    movcc %icc, 0, %o4
; CHECK-NEXT:    and %o4, 255, %o4
; CHECK-NEXT:    sll %o4, %o0, %o4
; CHECK-NEXT:    and %o5, %o3, %g2
; CHECK-NEXT:    or %g2, %o4, %o4
; CHECK-NEXT:    cas [%o2], %o5, %o4
; CHECK-NEXT:    mov %g0, %g2
; CHECK-NEXT:    cmp %o4, %o5
; CHECK-NEXT:    move %icc, 1, %g2
; CHECK-NEXT:    cmp %g2, 1
; CHECK-NEXT:    bne %icc, .LBB0_1
; CHECK-NEXT:    nop
; CHECK-NEXT:  ! %bb.2: ! %atomicrmw.end
; CHECK-NEXT:    srl %o4, %o0, %o0
; CHECK-NEXT:    membar #LoadLoad | #StoreLoad | #LoadStore | #StoreStore
; CHECK-NEXT:    retl
; CHECK-NEXT:    nop
  %result = atomicrmw uinc_wrap ptr %ptr, i8 %val seq_cst
  ret i8 %result
}

define i16 @atomicrmw_uinc_wrap_i16(ptr %ptr, i16 %val) {
; CHECK-LABEL: atomicrmw_uinc_wrap_i16:
; CHECK:         .cfi_startproc
; CHECK-NEXT:  ! %bb.0:
; CHECK-NEXT:    membar #LoadLoad | #StoreLoad | #LoadStore | #StoreStore
; CHECK-NEXT:    and %o0, -4, %o2
; CHECK-NEXT:    and %o0, 3, %o0
; CHECK-NEXT:    xor %o0, 2, %o0
; CHECK-NEXT:    sll %o0, 3, %o0
; CHECK-NEXT:    sethi 63, %o3
; CHECK-NEXT:    or %o3, 1023, %o3
; CHECK-NEXT:    ld [%o2], %o5
; CHECK-NEXT:    sll %o3, %o0, %o4
; CHECK-NEXT:    xor %o4, -1, %o4
; CHECK-NEXT:    and %o1, %o3, %o1
; CHECK-NEXT:  .LBB1_1: ! %atomicrmw.start
; CHECK-NEXT:    ! =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    mov %o5, %g2
; CHECK-NEXT:    srl %o5, %o0, %o5
; CHECK-NEXT:    and %o5, %o3, %g3
; CHECK-NEXT:    add %o5, 1, %o5
; CHECK-NEXT:    cmp %g3, %o1
; CHECK-NEXT:    movcc %icc, 0, %o5
; CHECK-NEXT:    and %o5, %o3, %o5
; CHECK-NEXT:    sll %o5, %o0, %o5
; CHECK-NEXT:    and %g2, %o4, %g3
; CHECK-NEXT:    or %g3, %o5, %o5
; CHECK-NEXT:    cas [%o2], %g2, %o5
; CHECK-NEXT:    mov %g0, %g3
; CHECK-NEXT:    cmp %o5, %g2
; CHECK-NEXT:    move %icc, 1, %g3
; CHECK-NEXT:    cmp %g3, 1
; CHECK-NEXT:    bne %icc, .LBB1_1
; CHECK-NEXT:    nop
; CHECK-NEXT:  ! %bb.2: ! %atomicrmw.end
; CHECK-NEXT:    srl %o5, %o0, %o0
; CHECK-NEXT:    membar #LoadLoad | #StoreLoad | #LoadStore | #StoreStore
; CHECK-NEXT:    retl
; CHECK-NEXT:    nop
  %result = atomicrmw uinc_wrap ptr %ptr, i16 %val seq_cst
  ret i16 %result
}

define i32 @atomicrmw_uinc_wrap_i32(ptr %ptr, i32 %val) {
; CHECK-LABEL: atomicrmw_uinc_wrap_i32:
; CHECK:         .cfi_startproc
; CHECK-NEXT:  ! %bb.0:
; CHECK-NEXT:    membar #LoadLoad | #StoreLoad | #LoadStore | #StoreStore
; CHECK-NEXT:    ld [%o0], %o2
; CHECK-NEXT:  .LBB2_1: ! %atomicrmw.start
; CHECK-NEXT:    ! =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    mov %o2, %o3
; CHECK-NEXT:    add %o2, 1, %o2
; CHECK-NEXT:    cmp %o3, %o1
; CHECK-NEXT:    movcc %icc, 0, %o2
; CHECK-NEXT:    cas [%o0], %o3, %o2
; CHECK-NEXT:    mov %g0, %o4
; CHECK-NEXT:    cmp %o2, %o3
; CHECK-NEXT:    move %icc, 1, %o4
; CHECK-NEXT:    cmp %o4, 1
; CHECK-NEXT:    bne %icc, .LBB2_1
; CHECK-NEXT:    nop
; CHECK-NEXT:  ! %bb.2: ! %atomicrmw.end
; CHECK-NEXT:    membar #LoadLoad | #StoreLoad | #LoadStore | #StoreStore
; CHECK-NEXT:    retl
; CHECK-NEXT:    mov %o2, %o0
  %result = atomicrmw uinc_wrap ptr %ptr, i32 %val seq_cst
  ret i32 %result
}

define i64 @atomicrmw_uinc_wrap_i64(ptr %ptr, i64 %val) {
; CHECK-LABEL: atomicrmw_uinc_wrap_i64:
; CHECK:         .cfi_startproc
; CHECK-NEXT:  ! %bb.0:
; CHECK-NEXT:    save %sp, -96, %sp
; CHECK-NEXT:    .cfi_def_cfa_register %fp
; CHECK-NEXT:    .cfi_window_save
; CHECK-NEXT:    .cfi_register %o7, %i7
; CHECK-NEXT:    membar #LoadLoad | #StoreLoad | #LoadStore | #StoreStore
; CHECK-NEXT:    ldd [%i0], %i4
; CHECK-NEXT:  .LBB3_1: ! %atomicrmw.start
; CHECK-NEXT:    ! =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    mov %g0, %i3
; CHECK-NEXT:    mov %g0, %g2
; CHECK-NEXT:    addcc %i5, 1, %o4
; CHECK-NEXT:    addxcc %i4, 0, %o3
; CHECK-NEXT:    cmp %i4, %i1
; CHECK-NEXT:    movcc %icc, 1, %i3
; CHECK-NEXT:    cmp %i5, %i2
; CHECK-NEXT:    movcc %icc, 1, %g2
; CHECK-NEXT:    cmp %i4, %i1
; CHECK-NEXT:    move %icc, %g2, %i3
; CHECK-NEXT:    cmp %i3, 0
; CHECK-NEXT:    movne %icc, 0, %o3
; CHECK-NEXT:    movne %icc, 0, %o4
; CHECK-NEXT:    mov %i0, %o0
; CHECK-NEXT:    mov %i4, %o1
; CHECK-NEXT:    call __sync_val_compare_and_swap_8
; CHECK-NEXT:    mov %i5, %o2
; CHECK-NEXT:    xor %o0, %i4, %i3
; CHECK-NEXT:    xor %o1, %i5, %i4
; CHECK-NEXT:    or %i4, %i3, %i3
; CHECK-NEXT:    mov %o1, %i5
; CHECK-NEXT:    cmp %i3, 0
; CHECK-NEXT:    bne %icc, .LBB3_1
; CHECK-NEXT:    mov %o0, %i4
; CHECK-NEXT:  ! %bb.2: ! %atomicrmw.end
; CHECK-NEXT:    membar #LoadLoad | #StoreLoad | #LoadStore | #StoreStore
; CHECK-NEXT:    mov %i4, %i0
; CHECK-NEXT:    ret
; CHECK-NEXT:    restore %g0, %i5, %o1
  %result = atomicrmw uinc_wrap ptr %ptr, i64 %val seq_cst
  ret i64 %result
}

define i8 @atomicrmw_udec_wrap_i8(ptr %ptr, i8 %val) {
; CHECK-LABEL: atomicrmw_udec_wrap_i8:
; CHECK:         .cfi_startproc
; CHECK-NEXT:  ! %bb.0:
; CHECK-NEXT:    membar #LoadLoad | #StoreLoad | #LoadStore | #StoreStore
; CHECK-NEXT:    and %o0, -4, %o2
; CHECK-NEXT:    mov 3, %o3
; CHECK-NEXT:    andn %o3, %o0, %o0
; CHECK-NEXT:    sll %o0, 3, %o0
; CHECK-NEXT:    mov 255, %o3
; CHECK-NEXT:    ld [%o2], %o5
; CHECK-NEXT:    sll %o3, %o0, %o3
; CHECK-NEXT:    xor %o3, -1, %o3
; CHECK-NEXT:    and %o1, 255, %o4
; CHECK-NEXT:  .LBB4_1: ! %atomicrmw.start
; CHECK-NEXT:    ! =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    mov %o5, %g2
; CHECK-NEXT:    srl %o5, %o0, %o5
; CHECK-NEXT:    and %o5, 255, %g3
; CHECK-NEXT:    add %o5, -1, %o5
; CHECK-NEXT:    cmp %g3, %o4
; CHECK-NEXT:    movgu %icc, %o1, %o5
; CHECK-NEXT:    cmp %g3, 0
; CHECK-NEXT:    move %icc, %o1, %o5
; CHECK-NEXT:    and %o5, 255, %o5
; CHECK-NEXT:    sll %o5, %o0, %o5
; CHECK-NEXT:    and %g2, %o3, %g3
; CHECK-NEXT:    or %g3, %o5, %o5
; CHECK-NEXT:    cas [%o2], %g2, %o5
; CHECK-NEXT:    mov %g0, %g3
; CHECK-NEXT:    cmp %o5, %g2
; CHECK-NEXT:    move %icc, 1, %g3
; CHECK-NEXT:    cmp %g3, 1
; CHECK-NEXT:    bne %icc, .LBB4_1
; CHECK-NEXT:    nop
; CHECK-NEXT:  ! %bb.2: ! %atomicrmw.end
; CHECK-NEXT:    srl %o5, %o0, %o0
; CHECK-NEXT:    membar #LoadLoad | #StoreLoad | #LoadStore | #StoreStore
; CHECK-NEXT:    retl
; CHECK-NEXT:    nop
  %result = atomicrmw udec_wrap ptr %ptr, i8 %val seq_cst
  ret i8 %result
}

define i16 @atomicrmw_udec_wrap_i16(ptr %ptr, i16 %val) {
; CHECK-LABEL: atomicrmw_udec_wrap_i16:
; CHECK:         .cfi_startproc
; CHECK-NEXT:  ! %bb.0:
; CHECK-NEXT:    membar #LoadLoad | #StoreLoad | #LoadStore | #StoreStore
; CHECK-NEXT:    and %o0, -4, %o2
; CHECK-NEXT:    and %o0, 3, %o0
; CHECK-NEXT:    xor %o0, 2, %o0
; CHECK-NEXT:    sll %o0, 3, %o0
; CHECK-NEXT:    sethi 63, %o3
; CHECK-NEXT:    or %o3, 1023, %o3
; CHECK-NEXT:    ld [%o2], %g2
; CHECK-NEXT:    sll %o3, %o0, %o4
; CHECK-NEXT:    xor %o4, -1, %o4
; CHECK-NEXT:    and %o1, %o3, %o5
; CHECK-NEXT:  .LBB5_1: ! %atomicrmw.start
; CHECK-NEXT:    ! =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    mov %g2, %g3
; CHECK-NEXT:    srl %g2, %o0, %g2
; CHECK-NEXT:    and %g2, %o3, %g4
; CHECK-NEXT:    add %g2, -1, %g2
; CHECK-NEXT:    cmp %g4, %o5
; CHECK-NEXT:    movgu %icc, %o1, %g2
; CHECK-NEXT:    cmp %g4, 0
; CHECK-NEXT:    move %icc, %o1, %g2
; CHECK-NEXT:    and %g2, %o3, %g2
; CHECK-NEXT:    sll %g2, %o0, %g2
; CHECK-NEXT:    and %g3, %o4, %g4
; CHECK-NEXT:    or %g4, %g2, %g2
; CHECK-NEXT:    cas [%o2], %g3, %g2
; CHECK-NEXT:    mov %g0, %g4
; CHECK-NEXT:    cmp %g2, %g3
; CHECK-NEXT:    move %icc, 1, %g4
; CHECK-NEXT:    cmp %g4, 1
; CHECK-NEXT:    bne %icc, .LBB5_1
; CHECK-NEXT:    nop
; CHECK-NEXT:  ! %bb.2: ! %atomicrmw.end
; CHECK-NEXT:    srl %g2, %o0, %o0
; CHECK-NEXT:    membar #LoadLoad | #StoreLoad | #LoadStore | #StoreStore
; CHECK-NEXT:    retl
; CHECK-NEXT:    nop
  %result = atomicrmw udec_wrap ptr %ptr, i16 %val seq_cst
  ret i16 %result
}

define i32 @atomicrmw_udec_wrap_i32(ptr %ptr, i32 %val) {
; CHECK-LABEL: atomicrmw_udec_wrap_i32:
; CHECK:         .cfi_startproc
; CHECK-NEXT:  ! %bb.0:
; CHECK-NEXT:    membar #LoadLoad | #StoreLoad | #LoadStore | #StoreStore
; CHECK-NEXT:    ld [%o0], %o2
; CHECK-NEXT:  .LBB6_1: ! %atomicrmw.start
; CHECK-NEXT:    ! =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    mov %o2, %o3
; CHECK-NEXT:    add %o2, -1, %o2
; CHECK-NEXT:    cmp %o3, %o1
; CHECK-NEXT:    movgu %icc, %o1, %o2
; CHECK-NEXT:    cmp %o3, 0
; CHECK-NEXT:    move %icc, %o1, %o2
; CHECK-NEXT:    cas [%o0], %o3, %o2
; CHECK-NEXT:    mov %g0, %o4
; CHECK-NEXT:    cmp %o2, %o3
; CHECK-NEXT:    move %icc, 1, %o4
; CHECK-NEXT:    cmp %o4, 1
; CHECK-NEXT:    bne %icc, .LBB6_1
; CHECK-NEXT:    nop
; CHECK-NEXT:  ! %bb.2: ! %atomicrmw.end
; CHECK-NEXT:    membar #LoadLoad | #StoreLoad | #LoadStore | #StoreStore
; CHECK-NEXT:    retl
; CHECK-NEXT:    mov %o2, %o0
  %result = atomicrmw udec_wrap ptr %ptr, i32 %val seq_cst
  ret i32 %result
}

define i64 @atomicrmw_udec_wrap_i64(ptr %ptr, i64 %val) {
; CHECK-LABEL: atomicrmw_udec_wrap_i64:
; CHECK:         .cfi_startproc
; CHECK-NEXT:  ! %bb.0:
; CHECK-NEXT:    save %sp, -96, %sp
; CHECK-NEXT:    .cfi_def_cfa_register %fp
; CHECK-NEXT:    .cfi_window_save
; CHECK-NEXT:    .cfi_register %o7, %i7
; CHECK-NEXT:    membar #LoadLoad | #StoreLoad | #LoadStore | #StoreStore
; CHECK-NEXT:    ldd [%i0], %i4
; CHECK-NEXT:  .LBB7_1: ! %atomicrmw.start
; CHECK-NEXT:    ! =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    mov %g0, %i3
; CHECK-NEXT:    mov %g0, %g2
; CHECK-NEXT:    mov %g0, %g3
; CHECK-NEXT:    addcc %i5, -1, %o4
; CHECK-NEXT:    addxcc %i4, -1, %o3
; CHECK-NEXT:    or %i5, %i4, %g4
; CHECK-NEXT:    cmp %g4, 0
; CHECK-NEXT:    move %icc, 1, %i3
; CHECK-NEXT:    cmp %i4, %i1
; CHECK-NEXT:    movgu %icc, 1, %g2
; CHECK-NEXT:    cmp %i5, %i2
; CHECK-NEXT:    movgu %icc, 1, %g3
; CHECK-NEXT:    cmp %i4, %i1
; CHECK-NEXT:    move %icc, %g3, %g2
; CHECK-NEXT:    or %i3, %g2, %i3
; CHECK-NEXT:    cmp %i3, 0
; CHECK-NEXT:    movne %icc, %i1, %o3
; CHECK-NEXT:    movne %icc, %i2, %o4
; CHECK-NEXT:    mov %i0, %o0
; CHECK-NEXT:    mov %i4, %o1
; CHECK-NEXT:    call __sync_val_compare_and_swap_8
; CHECK-NEXT:    mov %i5, %o2
; CHECK-NEXT:    xor %o0, %i4, %i3
; CHECK-NEXT:    xor %o1, %i5, %i4
; CHECK-NEXT:    or %i4, %i3, %i3
; CHECK-NEXT:    mov %o1, %i5
; CHECK-NEXT:    cmp %i3, 0
; CHECK-NEXT:    bne %icc, .LBB7_1
; CHECK-NEXT:    mov %o0, %i4
; CHECK-NEXT:  ! %bb.2: ! %atomicrmw.end
; CHECK-NEXT:    membar #LoadLoad | #StoreLoad | #LoadStore | #StoreStore
; CHECK-NEXT:    mov %i4, %i0
; CHECK-NEXT:    ret
; CHECK-NEXT:    restore %g0, %i5, %o1
  %result = atomicrmw udec_wrap ptr %ptr, i64 %val seq_cst
  ret i64 %result
}
