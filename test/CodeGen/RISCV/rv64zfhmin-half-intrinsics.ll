; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=riscv64 -mattr=+zfhmin \
; RUN:   -verify-machineinstrs -target-abi lp64f | \
; RUN:   FileCheck -check-prefix=CHECKIZFHMIN %s
; RUN: llc < %s -mtriple=riscv64 -mattr=+d \
; RUN:   -mattr=+zfhmin -verify-machineinstrs -target-abi lp64d | \
; RUN:   FileCheck -check-prefix=CHECKIZFHMIN %s

; These intrinsics require half and i64 to be legal types.

declare i64 @llvm.llrint.i64.f16(half)

define i64 @llrint_f16(half %a) nounwind {
; CHECKIZFHMIN-LABEL: llrint_f16:
; CHECKIZFHMIN:       # %bb.0:
; CHECKIZFHMIN-NEXT:    fcvt.s.h ft0, fa0
; CHECKIZFHMIN-NEXT:    fcvt.l.s a0, ft0
; CHECKIZFHMIN-NEXT:    ret
  %1 = call i64 @llvm.llrint.i64.f16(half %a)
  ret i64 %1
}

declare i64 @llvm.llround.i64.f16(half)

define i64 @llround_f16(half %a) nounwind {
; CHECKIZFHMIN-LABEL: llround_f16:
; CHECKIZFHMIN:       # %bb.0:
; CHECKIZFHMIN-NEXT:    fcvt.s.h ft0, fa0
; CHECKIZFHMIN-NEXT:    fcvt.l.s a0, ft0, rmm
; CHECKIZFHMIN-NEXT:    ret
  %1 = call i64 @llvm.llround.i64.f16(half %a)
  ret i64 %1
}
