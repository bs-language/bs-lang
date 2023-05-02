; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=s390x-linux-gnu -mcpu=z13 < %s  | FileCheck %s

; Test that DAGCombiner gets helped by computeKnownBitsForTargetNode().

; SystemZISD::REPLICATE
define i32 @f0(ptr %p0) {
; CHECK-LABEL: f0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl %v0, 0(%r2), 3
; CHECK-NEXT:    vgbm %v1, 0
; CHECK-NEXT:    vceqf %v0, %v0, %v1
; CHECK-NEXT:    vrepif %v1, 1
; CHECK-NEXT:    vnc %v0, %v1, %v0
; CHECK-NEXT:    vst %v0, 0(%r2), 3
; CHECK-NEXT:    vlgvf %r2, %v0, 3
; CHECK-NEXT:    # kill: def $r2l killed $r2l killed $r2d
; CHECK-NEXT:    br %r14
  %a0 = load <4 x i32>, ptr %p0, align 8
  %cmp0 = icmp ne <4 x i32> %a0, zeroinitializer
  %zxt0 = zext <4 x i1> %cmp0 to <4 x i32>
  store <4 x i32> %zxt0, ptr %p0, align 8
  %ext0 = extractelement <4 x i32> %zxt0, i32 3
  br label %exit

exit:
; The vector icmp+zext involves a REPLICATE of 1's. If KnownBits reflects
; this, DAGCombiner can see that the i32 icmp and zext here are not needed.
  %cmp1 = icmp ne i32 %ext0, 0
  %zxt1 = zext i1 %cmp1 to i32
  ret i32 %zxt1
}

; SystemZISD::JOIN_DWORDS (and REPLICATE)
; The DAG XOR has JOIN_DWORDS and REPLICATE operands. With KnownBits properly set
; for both these nodes, ICMP is used instead of TM during lowering because
; adjustForRedundantAnd() succeeds.
define void @f1(i64 %a0, i64 %a1) {
; CHECK-LABEL: f1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    risbgn %r0, %r2, 63, 191, 0
; CHECK-NEXT:    risbgn %r1, %r3, 63, 191, 0
; CHECK-NEXT:    vlvgp %v0, %r0, %r1
; CHECK-NEXT:    vrepig %v1, 1
; CHECK-NEXT:    vx %v0, %v0, %v1
; CHECK-NEXT:    vlgvg %r0, %v0, 0
; CHECK-NEXT:    cgijlh %r0, 0, .LBB1_3
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    vlgvg %r0, %v0, 1
; CHECK-NEXT:    cgijlh %r0, 0, .LBB1_3
; CHECK-NEXT:  # %bb.2:
; CHECK-NEXT:  .LBB1_3:
  %1 = and i64 %a0, 1
  %2 = and i64 %a1, 1
  %3 = insertelement <2 x i64> undef, i64 %1, i32 0
  %4 = insertelement <2 x i64> %3, i64 %2, i32 1
  %5 = xor <2 x i64> %4, <i64 1, i64 1>
  %6 = extractelement <2 x i64> %5, i32 0
  %7 = and i64 %6, 1
  %8 = icmp eq i64 %7, 0
  br i1 %8, label %9, label %14

; <label>:9:                                      ; preds = %0
  %10 = extractelement <2 x i64> %5, i32 1
  %11 = and i64 %10, 1
  %12 = icmp eq i64 %11, 0
  br i1 %12, label %13, label %14

; <label>:13:                                      ; preds = %0
  unreachable

; <label>:14:                                      ; preds = %0
  unreachable
}
