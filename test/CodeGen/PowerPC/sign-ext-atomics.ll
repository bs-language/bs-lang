; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=powerpc64le-linux-gnu < %s | FileCheck %s
define i16 @SEXTParam(i16 signext %0) #0 {
; CHECK-LABEL: SEXTParam:
; CHECK:       # %bb.0: # %top
; CHECK-NEXT:    li 4, 0
; CHECK-NEXT:    sth 4, -4(1)
; CHECK-NEXT:    addi 4, 1, -4
; CHECK-NEXT:    lwsync
; CHECK-NEXT:  .LBB0_1: # %top
; CHECK-NEXT:    #
; CHECK-NEXT:    lharx 5, 0, 4
; CHECK-NEXT:    extsh 5, 5
; CHECK-NEXT:    cmpw 5, 3
; CHECK-NEXT:    blt 0, .LBB0_3
; CHECK-NEXT:  # %bb.2: # %top
; CHECK-NEXT:    #
; CHECK-NEXT:    sthcx. 3, 0, 4
; CHECK-NEXT:    bne 0, .LBB0_1
; CHECK-NEXT:  .LBB0_3: # %top
; CHECK-NEXT:    lwsync
; CHECK-NEXT:    lhz 3, -4(1)
; CHECK-NEXT:    cmpd 7, 3, 3
; CHECK-NEXT:    bne- 7, .+4
; CHECK-NEXT:    isync
; CHECK-NEXT:    blr
top:
  %1 = alloca i16, align 4
  store i16 0, ptr %1, align 4
  %rv.i = atomicrmw min ptr %1, i16 %0 acq_rel
  %rv.i2 = load atomic i16, ptr %1 acquire, align 16
  ret i16 %rv.i2
}

define i16 @noSEXTParam(i16 %0) #0 {
; CHECK-LABEL: noSEXTParam:
; CHECK:       # %bb.0: # %top
; CHECK-NEXT:    li 4, 0
; CHECK-NEXT:    extsh 3, 3
; CHECK-NEXT:    sth 4, -4(1)
; CHECK-NEXT:    addi 4, 1, -4
; CHECK-NEXT:    lwsync
; CHECK-NEXT:  .LBB1_1: # %top
; CHECK-NEXT:    #
; CHECK-NEXT:    lharx 5, 0, 4
; CHECK-NEXT:    extsh 5, 5
; CHECK-NEXT:    cmpw 5, 3
; CHECK-NEXT:    blt 0, .LBB1_3
; CHECK-NEXT:  # %bb.2: # %top
; CHECK-NEXT:    #
; CHECK-NEXT:    sthcx. 3, 0, 4
; CHECK-NEXT:    bne 0, .LBB1_1
; CHECK-NEXT:  .LBB1_3: # %top
; CHECK-NEXT:    lwsync
; CHECK-NEXT:    lhz 3, -4(1)
; CHECK-NEXT:    cmpd 7, 3, 3
; CHECK-NEXT:    bne- 7, .+4
; CHECK-NEXT:    isync
; CHECK-NEXT:    blr
top:
  %1 = alloca i16, align 4
  store i16 0, ptr %1, align 4
  %rv.i = atomicrmw min ptr %1, i16 %0 acq_rel
  %rv.i2 = load atomic i16, ptr %1 acquire, align 16
  ret i16 %rv.i2
}

define i16 @noSEXTLoad(ptr %p) #0 {
; CHECK-LABEL: noSEXTLoad:
; CHECK:       # %bb.0: # %top
; CHECK-NEXT:    lha 3, 0(3)
; CHECK-NEXT:    li 4, 0
; CHECK-NEXT:    sth 4, -4(1)
; CHECK-NEXT:    addi 4, 1, -4
; CHECK-NEXT:    lwsync
; CHECK-NEXT:  .LBB2_1: # %top
; CHECK-NEXT:    #
; CHECK-NEXT:    lharx 5, 0, 4
; CHECK-NEXT:    extsh 5, 5
; CHECK-NEXT:    cmpw 5, 3
; CHECK-NEXT:    blt 0, .LBB2_3
; CHECK-NEXT:  # %bb.2: # %top
; CHECK-NEXT:    #
; CHECK-NEXT:    sthcx. 3, 0, 4
; CHECK-NEXT:    bne 0, .LBB2_1
; CHECK-NEXT:  .LBB2_3: # %top
; CHECK-NEXT:    lwsync
; CHECK-NEXT:    lhz 3, -4(1)
; CHECK-NEXT:    cmpd 7, 3, 3
; CHECK-NEXT:    bne- 7, .+4
; CHECK-NEXT:    isync
; CHECK-NEXT:    blr
top:
  %0 = load i16, ptr %p, align 2
  %1 = alloca i16, align 4
  store i16 0, ptr %1, align 4
  %rv.i = atomicrmw min ptr %1, i16 %0 acq_rel
  %rv.i2 = load atomic i16, ptr %1 acquire, align 16
  ret i16 %rv.i2
}
attributes #0 = { nounwind }
