; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=hexagon < %s | FileCheck %s

; Test that we compile the HVX dual output intrinsics.

define inreg <32 x i32> @f0(<32 x i32> %a0, <32 x i32> %a1, ptr %a2) #0 {
; CHECK-LABEL: f0:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     r1 = #-1
; CHECK-NEXT:     v2 = vmem(r0+#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = vand(v2,r1)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0.w = vadd(v0.w,v1.w,q0):carry
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = load <32 x i32>, ptr %a2, align 128
  %v1 = tail call <128 x i1> @llvm.hexagon.V6.vandvrt.128B(<32 x i32> %v0, i32 -1)
  %v2 = tail call { <32 x i32>, <128 x i1> } @llvm.hexagon.V6.vaddcarry.128B(<32 x i32> %a0, <32 x i32> %a1, <128 x i1> %v1)
  %v3 = extractvalue { <32 x i32>, <128 x i1> } %v2, 0
  ret <32 x i32> %v3
}

define inreg <32 x i32> @f1(<32 x i32> %a0, <32 x i32> %a1, ptr %a2) #0 {
; CHECK-LABEL: f1:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     r1 = #-1
; CHECK-NEXT:     v2 = vmem(r0+#0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     q0 = vand(v2,r1)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0.w = vsub(v0.w,v1.w,q0):carry
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = load <32 x i32>, ptr %a2, align 128
  %v1 = tail call <128 x i1> @llvm.hexagon.V6.vandvrt.128B(<32 x i32> %v0, i32 -1)
  %v2 = tail call { <32 x i32>, <128 x i1> } @llvm.hexagon.V6.vsubcarry.128B(<32 x i32> %a0, <32 x i32> %a1, <128 x i1> %v1)
  %v3 = extractvalue { <32 x i32>, <128 x i1> } %v2, 0
  ret <32 x i32> %v3
}

define inreg <32 x i32> @f2(<32 x i32> %a0, <32 x i32> %a1) #0 {
; CHECK-LABEL: f2:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     v0.w,q0 = vadd(v0.w,v1.w):carry
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = tail call { <32 x i32>, <128 x i1> } @llvm.hexagon.V6.vaddcarryo.128B(<32 x i32> %a0, <32 x i32> %a1)
  %v1 = extractvalue { <32 x i32>, <128 x i1> } %v0, 0
  ret <32 x i32> %v1
}

define inreg <32 x i32> @f3(<32 x i32> %a0, <32 x i32> %a1) #0 {
; CHECK-LABEL: f3:
; CHECK:       // %bb.0: // %b0
; CHECK-NEXT:    {
; CHECK-NEXT:     v0.w,q0 = vsub(v0.w,v1.w):carry
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
b0:
  %v0 = tail call { <32 x i32>, <128 x i1> } @llvm.hexagon.V6.vsubcarryo.128B(<32 x i32> %a0, <32 x i32> %a1)
  %v1 = extractvalue { <32 x i32>, <128 x i1> } %v0, 0
  ret <32 x i32> %v1
}

declare { <32 x i32>, <128 x i1> } @llvm.hexagon.V6.vaddcarry.128B(<32 x i32>, <32 x i32>, <128 x i1>) #1
declare { <32 x i32>, <128 x i1> } @llvm.hexagon.V6.vsubcarry.128B(<32 x i32>, <32 x i32>, <128 x i1>) #1
declare { <32 x i32>, <128 x i1> } @llvm.hexagon.V6.vaddcarryo.128B(<32 x i32>, <32 x i32>) #1
declare { <32 x i32>, <128 x i1> } @llvm.hexagon.V6.vsubcarryo.128B(<32 x i32>, <32 x i32>) #1

declare <128 x i1> @llvm.hexagon.V6.vandvrt.128B(<32 x i32>, i32) #1

attributes #0 = { nounwind "target-cpu"="hexagonv66" "target-features"="+hvxv66,+hvx-length128b" }
attributes #1 = { nounwind readnone }
