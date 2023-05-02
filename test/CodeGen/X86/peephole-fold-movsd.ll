; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-pc-linux < %s | FileCheck %s
;
; Check that x86's peephole optimization doesn't fold a 64-bit load (movsd) into
; addpd.
; rdar://problem/18236850

%struct.S1 = type { double, double }

@g = common dso_local global %struct.S1 zeroinitializer, align 8

declare void @foo3(ptr)

define dso_local void @foo1(double %a.coerce0, double %a.coerce1, double %b.coerce0, double %b.coerce1) nounwind {
; CHECK-LABEL: foo1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    subq $24, %rsp
; CHECK-NEXT:    movq %rsp, %rdi
; CHECK-NEXT:    callq foo3@PLT
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    movapd {{.*#+}} xmm1 = <1.0E+0,u>
; CHECK-NEXT:    movhpd {{.*#+}} xmm1 = xmm1[0],mem[0]
; CHECK-NEXT:    addpd %xmm0, %xmm1
; CHECK-NEXT:    movapd %xmm1, g(%rip)
; CHECK-NEXT:    addq $24, %rsp
; CHECK-NEXT:    retq
  %1 = alloca <2 x double>, align 16
  call void @foo3(ptr %1) #2
  %2 = load double, ptr %1, align 16
  %p3 = getelementptr inbounds %struct.S1, ptr %1, i64 0, i32 1
  %3 = load double, ptr %p3, align 8
  %4 = insertelement <2 x double> undef, double %2, i32 0
  %5 = insertelement <2 x double> %4, double 0.000000e+00, i32 1
  %6 = insertelement <2 x double> undef, double %3, i32 1
  %7 = insertelement <2 x double> %6, double 1.000000e+00, i32 0
  %8 = fadd <2 x double> %5, %7
  store <2 x double> %8, ptr @g, align 16
  ret void
}
