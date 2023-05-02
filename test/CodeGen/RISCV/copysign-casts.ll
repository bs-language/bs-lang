; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV32I
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64I
; RUN: llc -mtriple=riscv32 -verify-machineinstrs -mattr=+f \
; RUN:   -target-abi ilp32f < %s | FileCheck %s -check-prefix=RV32IF
; RUN: llc -mtriple=riscv32 -verify-machineinstrs -mattr=+f -mattr=+d \
; RUN:   -target-abi ilp32d < %s | FileCheck %s -check-prefix=RV32IFD
; RUN: llc -mtriple=riscv64 -verify-machineinstrs -mattr=+f -mattr=+d \
; RUN:   -target-abi lp64d < %s | FileCheck %s -check-prefix=RV64IFD
; RUN: llc -mtriple=riscv32 -verify-machineinstrs -mattr=+f \
; RUN:   -mattr=+zfh -target-abi ilp32f < %s \
; RUN:   | FileCheck %s -check-prefix=RV32IFZFH
; RUN: llc -mtriple=riscv32 -verify-machineinstrs -mattr=+f -mattr=+d \
; RUN:   -mattr=+zfh -target-abi ilp32d < %s \
; RUN:   | FileCheck %s -check-prefix=RV32IFDZFH
; RUN: llc -mtriple=riscv64 -verify-machineinstrs -mattr=+f -mattr=+d \
; RUN:   -mattr=+zfh -target-abi lp64d < %s \
; RUN:   | FileCheck %s -check-prefix=RV64IFDZFH
; RUN: llc -mtriple=riscv32 -verify-machineinstrs -mattr=+f \
; RUN:   -mattr=+zfhmin -target-abi ilp32f < %s \
; RUN:   | FileCheck %s -check-prefix=RV32IFZFHMIN
; RUN: llc -mtriple=riscv32 -verify-machineinstrs -mattr=+f -mattr=+d \
; RUN:   -mattr=+zfhmin -target-abi ilp32d < %s \
; RUN:   | FileCheck %s -check-prefix=RV32IFDZFHMIN
; RUN: llc -mtriple=riscv64 -verify-machineinstrs -mattr=+f -mattr=+d \
; RUN:   -mattr=+zfhmin -target-abi lp64d < %s \
; RUN:   | FileCheck %s -check-prefix=RV64IFDZFHMIN

; Test fcopysign scenarios where the sign argument is casted to the type of the
; magnitude argument. Those casts can be folded away by the DAGCombiner.

declare double @llvm.copysign.f64(double, double)
declare float @llvm.copysign.f32(float, float)
declare half @llvm.copysign.f16(half, half)

define double @fold_promote_d_s(double %a, float %b) nounwind {
; RV32I-LABEL: fold_promote_d_s:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a3, 524288
; RV32I-NEXT:    and a2, a2, a3
; RV32I-NEXT:    slli a1, a1, 1
; RV32I-NEXT:    srli a1, a1, 1
; RV32I-NEXT:    or a1, a1, a2
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fold_promote_d_s:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a2, 524288
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    slli a1, a1, 32
; RV64I-NEXT:    slli a0, a0, 1
; RV64I-NEXT:    srli a0, a0, 1
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    ret
;
; RV32IF-LABEL: fold_promote_d_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.x.w a2, fa0
; RV32IF-NEXT:    lui a3, 524288
; RV32IF-NEXT:    and a2, a2, a3
; RV32IF-NEXT:    slli a1, a1, 1
; RV32IF-NEXT:    srli a1, a1, 1
; RV32IF-NEXT:    or a1, a1, a2
; RV32IF-NEXT:    ret
;
; RV32IFD-LABEL: fold_promote_d_s:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fcvt.d.s ft0, fa1
; RV32IFD-NEXT:    fsgnj.d fa0, fa0, ft0
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: fold_promote_d_s:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.d.s ft0, fa1
; RV64IFD-NEXT:    fsgnj.d fa0, fa0, ft0
; RV64IFD-NEXT:    ret
;
; RV32IFZFH-LABEL: fold_promote_d_s:
; RV32IFZFH:       # %bb.0:
; RV32IFZFH-NEXT:    fmv.x.w a2, fa0
; RV32IFZFH-NEXT:    lui a3, 524288
; RV32IFZFH-NEXT:    and a2, a2, a3
; RV32IFZFH-NEXT:    slli a1, a1, 1
; RV32IFZFH-NEXT:    srli a1, a1, 1
; RV32IFZFH-NEXT:    or a1, a1, a2
; RV32IFZFH-NEXT:    ret
;
; RV32IFDZFH-LABEL: fold_promote_d_s:
; RV32IFDZFH:       # %bb.0:
; RV32IFDZFH-NEXT:    fcvt.d.s ft0, fa1
; RV32IFDZFH-NEXT:    fsgnj.d fa0, fa0, ft0
; RV32IFDZFH-NEXT:    ret
;
; RV64IFDZFH-LABEL: fold_promote_d_s:
; RV64IFDZFH:       # %bb.0:
; RV64IFDZFH-NEXT:    fcvt.d.s ft0, fa1
; RV64IFDZFH-NEXT:    fsgnj.d fa0, fa0, ft0
; RV64IFDZFH-NEXT:    ret
;
; RV32IFZFHMIN-LABEL: fold_promote_d_s:
; RV32IFZFHMIN:       # %bb.0:
; RV32IFZFHMIN-NEXT:    fmv.x.w a2, fa0
; RV32IFZFHMIN-NEXT:    lui a3, 524288
; RV32IFZFHMIN-NEXT:    and a2, a2, a3
; RV32IFZFHMIN-NEXT:    slli a1, a1, 1
; RV32IFZFHMIN-NEXT:    srli a1, a1, 1
; RV32IFZFHMIN-NEXT:    or a1, a1, a2
; RV32IFZFHMIN-NEXT:    ret
;
; RV32IFDZFHMIN-LABEL: fold_promote_d_s:
; RV32IFDZFHMIN:       # %bb.0:
; RV32IFDZFHMIN-NEXT:    fcvt.d.s ft0, fa1
; RV32IFDZFHMIN-NEXT:    fsgnj.d fa0, fa0, ft0
; RV32IFDZFHMIN-NEXT:    ret
;
; RV64IFDZFHMIN-LABEL: fold_promote_d_s:
; RV64IFDZFHMIN:       # %bb.0:
; RV64IFDZFHMIN-NEXT:    fcvt.d.s ft0, fa1
; RV64IFDZFHMIN-NEXT:    fsgnj.d fa0, fa0, ft0
; RV64IFDZFHMIN-NEXT:    ret
  %c = fpext float %b to double
  %t = call double @llvm.copysign.f64(double %a, double %c)
  ret double %t
}

define double @fold_promote_d_h(double %a, half %b) nounwind {
; RV32I-LABEL: fold_promote_d_h:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a3, 8
; RV32I-NEXT:    and a2, a2, a3
; RV32I-NEXT:    slli a2, a2, 16
; RV32I-NEXT:    slli a1, a1, 1
; RV32I-NEXT:    srli a1, a1, 1
; RV32I-NEXT:    or a1, a1, a2
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fold_promote_d_h:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a2, 8
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    slli a1, a1, 48
; RV64I-NEXT:    slli a0, a0, 1
; RV64I-NEXT:    srli a0, a0, 1
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    ret
;
; RV32IF-LABEL: fold_promote_d_h:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.x.w a2, fa0
; RV32IF-NEXT:    lui a3, 8
; RV32IF-NEXT:    and a2, a2, a3
; RV32IF-NEXT:    slli a2, a2, 16
; RV32IF-NEXT:    slli a1, a1, 1
; RV32IF-NEXT:    srli a1, a1, 1
; RV32IF-NEXT:    or a1, a1, a2
; RV32IF-NEXT:    ret
;
; RV32IFD-LABEL: fold_promote_d_h:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IFD-NEXT:    fsd fs0, 0(sp) # 8-byte Folded Spill
; RV32IFD-NEXT:    fmv.d fs0, fa0
; RV32IFD-NEXT:    fmv.x.w a0, fa1
; RV32IFD-NEXT:    call __extendhfsf2@plt
; RV32IFD-NEXT:    fcvt.d.s ft0, fa0
; RV32IFD-NEXT:    fsgnj.d fa0, fs0, ft0
; RV32IFD-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IFD-NEXT:    fld fs0, 0(sp) # 8-byte Folded Reload
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: fold_promote_d_h:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    addi sp, sp, -16
; RV64IFD-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64IFD-NEXT:    fsd fs0, 0(sp) # 8-byte Folded Spill
; RV64IFD-NEXT:    fmv.d fs0, fa0
; RV64IFD-NEXT:    fmv.x.w a0, fa1
; RV64IFD-NEXT:    call __extendhfsf2@plt
; RV64IFD-NEXT:    fcvt.d.s ft0, fa0
; RV64IFD-NEXT:    fsgnj.d fa0, fs0, ft0
; RV64IFD-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64IFD-NEXT:    fld fs0, 0(sp) # 8-byte Folded Reload
; RV64IFD-NEXT:    addi sp, sp, 16
; RV64IFD-NEXT:    ret
;
; RV32IFZFH-LABEL: fold_promote_d_h:
; RV32IFZFH:       # %bb.0:
; RV32IFZFH-NEXT:    fmv.x.h a2, fa0
; RV32IFZFH-NEXT:    lui a3, 8
; RV32IFZFH-NEXT:    and a2, a2, a3
; RV32IFZFH-NEXT:    slli a2, a2, 16
; RV32IFZFH-NEXT:    slli a1, a1, 1
; RV32IFZFH-NEXT:    srli a1, a1, 1
; RV32IFZFH-NEXT:    or a1, a1, a2
; RV32IFZFH-NEXT:    ret
;
; RV32IFDZFH-LABEL: fold_promote_d_h:
; RV32IFDZFH:       # %bb.0:
; RV32IFDZFH-NEXT:    fcvt.d.h ft0, fa1
; RV32IFDZFH-NEXT:    fsgnj.d fa0, fa0, ft0
; RV32IFDZFH-NEXT:    ret
;
; RV64IFDZFH-LABEL: fold_promote_d_h:
; RV64IFDZFH:       # %bb.0:
; RV64IFDZFH-NEXT:    fcvt.d.h ft0, fa1
; RV64IFDZFH-NEXT:    fsgnj.d fa0, fa0, ft0
; RV64IFDZFH-NEXT:    ret
;
; RV32IFZFHMIN-LABEL: fold_promote_d_h:
; RV32IFZFHMIN:       # %bb.0:
; RV32IFZFHMIN-NEXT:    fmv.x.h a2, fa0
; RV32IFZFHMIN-NEXT:    lui a3, 8
; RV32IFZFHMIN-NEXT:    and a2, a2, a3
; RV32IFZFHMIN-NEXT:    slli a2, a2, 16
; RV32IFZFHMIN-NEXT:    slli a1, a1, 1
; RV32IFZFHMIN-NEXT:    srli a1, a1, 1
; RV32IFZFHMIN-NEXT:    or a1, a1, a2
; RV32IFZFHMIN-NEXT:    ret
;
; RV32IFDZFHMIN-LABEL: fold_promote_d_h:
; RV32IFDZFHMIN:       # %bb.0:
; RV32IFDZFHMIN-NEXT:    fcvt.d.h ft0, fa1
; RV32IFDZFHMIN-NEXT:    fsgnj.d fa0, fa0, ft0
; RV32IFDZFHMIN-NEXT:    ret
;
; RV64IFDZFHMIN-LABEL: fold_promote_d_h:
; RV64IFDZFHMIN:       # %bb.0:
; RV64IFDZFHMIN-NEXT:    fcvt.d.h ft0, fa1
; RV64IFDZFHMIN-NEXT:    fsgnj.d fa0, fa0, ft0
; RV64IFDZFHMIN-NEXT:    ret
  %c = fpext half %b to double
  %t = call double @llvm.copysign.f64(double %a, double %c)
  ret double %t
}

define float @fold_promote_f_h(float %a, half %b) nounwind {
; RV32I-LABEL: fold_promote_f_h:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a2, 8
; RV32I-NEXT:    and a1, a1, a2
; RV32I-NEXT:    slli a1, a1, 16
; RV32I-NEXT:    slli a0, a0, 1
; RV32I-NEXT:    srli a0, a0, 1
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fold_promote_f_h:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a2, 8
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    slliw a1, a1, 16
; RV64I-NEXT:    slli a0, a0, 33
; RV64I-NEXT:    srli a0, a0, 33
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    ret
;
; RV32IF-LABEL: fold_promote_f_h:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    addi sp, sp, -16
; RV32IF-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IF-NEXT:    fsw fs0, 8(sp) # 4-byte Folded Spill
; RV32IF-NEXT:    fmv.s fs0, fa0
; RV32IF-NEXT:    fmv.x.w a0, fa1
; RV32IF-NEXT:    call __extendhfsf2@plt
; RV32IF-NEXT:    fsgnj.s fa0, fs0, fa0
; RV32IF-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IF-NEXT:    flw fs0, 8(sp) # 4-byte Folded Reload
; RV32IF-NEXT:    addi sp, sp, 16
; RV32IF-NEXT:    ret
;
; RV32IFD-LABEL: fold_promote_f_h:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IFD-NEXT:    fsd fs0, 0(sp) # 8-byte Folded Spill
; RV32IFD-NEXT:    fmv.s fs0, fa0
; RV32IFD-NEXT:    fmv.x.w a0, fa1
; RV32IFD-NEXT:    call __extendhfsf2@plt
; RV32IFD-NEXT:    fsgnj.s fa0, fs0, fa0
; RV32IFD-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IFD-NEXT:    fld fs0, 0(sp) # 8-byte Folded Reload
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: fold_promote_f_h:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    addi sp, sp, -16
; RV64IFD-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64IFD-NEXT:    fsd fs0, 0(sp) # 8-byte Folded Spill
; RV64IFD-NEXT:    fmv.s fs0, fa0
; RV64IFD-NEXT:    fmv.x.w a0, fa1
; RV64IFD-NEXT:    call __extendhfsf2@plt
; RV64IFD-NEXT:    fsgnj.s fa0, fs0, fa0
; RV64IFD-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64IFD-NEXT:    fld fs0, 0(sp) # 8-byte Folded Reload
; RV64IFD-NEXT:    addi sp, sp, 16
; RV64IFD-NEXT:    ret
;
; RV32IFZFH-LABEL: fold_promote_f_h:
; RV32IFZFH:       # %bb.0:
; RV32IFZFH-NEXT:    fcvt.s.h ft0, fa1
; RV32IFZFH-NEXT:    fsgnj.s fa0, fa0, ft0
; RV32IFZFH-NEXT:    ret
;
; RV32IFDZFH-LABEL: fold_promote_f_h:
; RV32IFDZFH:       # %bb.0:
; RV32IFDZFH-NEXT:    fcvt.s.h ft0, fa1
; RV32IFDZFH-NEXT:    fsgnj.s fa0, fa0, ft0
; RV32IFDZFH-NEXT:    ret
;
; RV64IFDZFH-LABEL: fold_promote_f_h:
; RV64IFDZFH:       # %bb.0:
; RV64IFDZFH-NEXT:    fcvt.s.h ft0, fa1
; RV64IFDZFH-NEXT:    fsgnj.s fa0, fa0, ft0
; RV64IFDZFH-NEXT:    ret
;
; RV32IFZFHMIN-LABEL: fold_promote_f_h:
; RV32IFZFHMIN:       # %bb.0:
; RV32IFZFHMIN-NEXT:    fcvt.s.h ft0, fa1
; RV32IFZFHMIN-NEXT:    fsgnj.s fa0, fa0, ft0
; RV32IFZFHMIN-NEXT:    ret
;
; RV32IFDZFHMIN-LABEL: fold_promote_f_h:
; RV32IFDZFHMIN:       # %bb.0:
; RV32IFDZFHMIN-NEXT:    fcvt.s.h ft0, fa1
; RV32IFDZFHMIN-NEXT:    fsgnj.s fa0, fa0, ft0
; RV32IFDZFHMIN-NEXT:    ret
;
; RV64IFDZFHMIN-LABEL: fold_promote_f_h:
; RV64IFDZFHMIN:       # %bb.0:
; RV64IFDZFHMIN-NEXT:    fcvt.s.h ft0, fa1
; RV64IFDZFHMIN-NEXT:    fsgnj.s fa0, fa0, ft0
; RV64IFDZFHMIN-NEXT:    ret
  %c = fpext half %b to float
  %t = call float @llvm.copysign.f32(float %a, float %c)
  ret float %t
}

define float @fold_demote_s_d(float %a, double %b) nounwind {
; RV32I-LABEL: fold_demote_s_d:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a1, 524288
; RV32I-NEXT:    and a1, a2, a1
; RV32I-NEXT:    slli a0, a0, 1
; RV32I-NEXT:    srli a0, a0, 1
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fold_demote_s_d:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 33
; RV64I-NEXT:    srli a0, a0, 33
; RV64I-NEXT:    srli a1, a1, 63
; RV64I-NEXT:    slli a1, a1, 63
; RV64I-NEXT:    srli a1, a1, 32
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    ret
;
; RV32IF-LABEL: fold_demote_s_d:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a1
; RV32IF-NEXT:    fsgnj.s fa0, fa0, ft0
; RV32IF-NEXT:    ret
;
; RV32IFD-LABEL: fold_demote_s_d:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fcvt.s.d ft0, fa1
; RV32IFD-NEXT:    fsgnj.s fa0, fa0, ft0
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: fold_demote_s_d:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.s.d ft0, fa1
; RV64IFD-NEXT:    fsgnj.s fa0, fa0, ft0
; RV64IFD-NEXT:    ret
;
; RV32IFZFH-LABEL: fold_demote_s_d:
; RV32IFZFH:       # %bb.0:
; RV32IFZFH-NEXT:    fmv.w.x ft0, a1
; RV32IFZFH-NEXT:    fsgnj.s fa0, fa0, ft0
; RV32IFZFH-NEXT:    ret
;
; RV32IFDZFH-LABEL: fold_demote_s_d:
; RV32IFDZFH:       # %bb.0:
; RV32IFDZFH-NEXT:    fcvt.s.d ft0, fa1
; RV32IFDZFH-NEXT:    fsgnj.s fa0, fa0, ft0
; RV32IFDZFH-NEXT:    ret
;
; RV64IFDZFH-LABEL: fold_demote_s_d:
; RV64IFDZFH:       # %bb.0:
; RV64IFDZFH-NEXT:    fcvt.s.d ft0, fa1
; RV64IFDZFH-NEXT:    fsgnj.s fa0, fa0, ft0
; RV64IFDZFH-NEXT:    ret
;
; RV32IFZFHMIN-LABEL: fold_demote_s_d:
; RV32IFZFHMIN:       # %bb.0:
; RV32IFZFHMIN-NEXT:    fmv.w.x ft0, a1
; RV32IFZFHMIN-NEXT:    fsgnj.s fa0, fa0, ft0
; RV32IFZFHMIN-NEXT:    ret
;
; RV32IFDZFHMIN-LABEL: fold_demote_s_d:
; RV32IFDZFHMIN:       # %bb.0:
; RV32IFDZFHMIN-NEXT:    fcvt.s.d ft0, fa1
; RV32IFDZFHMIN-NEXT:    fsgnj.s fa0, fa0, ft0
; RV32IFDZFHMIN-NEXT:    ret
;
; RV64IFDZFHMIN-LABEL: fold_demote_s_d:
; RV64IFDZFHMIN:       # %bb.0:
; RV64IFDZFHMIN-NEXT:    fcvt.s.d ft0, fa1
; RV64IFDZFHMIN-NEXT:    fsgnj.s fa0, fa0, ft0
; RV64IFDZFHMIN-NEXT:    ret
  %c = fptrunc double %b to float
  %t = call float @llvm.copysign.f32(float %a, float %c)
  ret float %t
}

define half @fold_demote_h_s(half %a, float %b) nounwind {
; RV32I-LABEL: fold_demote_h_s:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a2, 524288
; RV32I-NEXT:    and a1, a1, a2
; RV32I-NEXT:    srli a1, a1, 16
; RV32I-NEXT:    slli a0, a0, 17
; RV32I-NEXT:    srli a0, a0, 17
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fold_demote_h_s:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srliw a1, a1, 31
; RV64I-NEXT:    slli a1, a1, 15
; RV64I-NEXT:    slli a0, a0, 49
; RV64I-NEXT:    srli a0, a0, 49
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    ret
;
; RV32IF-LABEL: fold_demote_h_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.x.w a0, fa0
; RV32IF-NEXT:    fmv.x.w a1, fa1
; RV32IF-NEXT:    lui a2, 524288
; RV32IF-NEXT:    and a1, a1, a2
; RV32IF-NEXT:    srli a1, a1, 16
; RV32IF-NEXT:    slli a0, a0, 17
; RV32IF-NEXT:    srli a0, a0, 17
; RV32IF-NEXT:    or a0, a0, a1
; RV32IF-NEXT:    lui a1, 1048560
; RV32IF-NEXT:    or a0, a0, a1
; RV32IF-NEXT:    fmv.w.x fa0, a0
; RV32IF-NEXT:    ret
;
; RV32IFD-LABEL: fold_demote_h_s:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fmv.x.w a0, fa0
; RV32IFD-NEXT:    fmv.x.w a1, fa1
; RV32IFD-NEXT:    lui a2, 524288
; RV32IFD-NEXT:    and a1, a1, a2
; RV32IFD-NEXT:    srli a1, a1, 16
; RV32IFD-NEXT:    slli a0, a0, 17
; RV32IFD-NEXT:    srli a0, a0, 17
; RV32IFD-NEXT:    or a0, a0, a1
; RV32IFD-NEXT:    lui a1, 1048560
; RV32IFD-NEXT:    or a0, a0, a1
; RV32IFD-NEXT:    fmv.w.x fa0, a0
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: fold_demote_h_s:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fmv.x.w a0, fa0
; RV64IFD-NEXT:    fmv.x.w a1, fa1
; RV64IFD-NEXT:    lui a2, 524288
; RV64IFD-NEXT:    and a1, a1, a2
; RV64IFD-NEXT:    srli a1, a1, 16
; RV64IFD-NEXT:    slli a0, a0, 49
; RV64IFD-NEXT:    srli a0, a0, 49
; RV64IFD-NEXT:    or a0, a0, a1
; RV64IFD-NEXT:    lui a1, 1048560
; RV64IFD-NEXT:    or a0, a0, a1
; RV64IFD-NEXT:    fmv.w.x fa0, a0
; RV64IFD-NEXT:    ret
;
; RV32IFZFH-LABEL: fold_demote_h_s:
; RV32IFZFH:       # %bb.0:
; RV32IFZFH-NEXT:    fcvt.h.s ft0, fa1
; RV32IFZFH-NEXT:    fsgnj.h fa0, fa0, ft0
; RV32IFZFH-NEXT:    ret
;
; RV32IFDZFH-LABEL: fold_demote_h_s:
; RV32IFDZFH:       # %bb.0:
; RV32IFDZFH-NEXT:    fcvt.h.s ft0, fa1
; RV32IFDZFH-NEXT:    fsgnj.h fa0, fa0, ft0
; RV32IFDZFH-NEXT:    ret
;
; RV64IFDZFH-LABEL: fold_demote_h_s:
; RV64IFDZFH:       # %bb.0:
; RV64IFDZFH-NEXT:    fcvt.h.s ft0, fa1
; RV64IFDZFH-NEXT:    fsgnj.h fa0, fa0, ft0
; RV64IFDZFH-NEXT:    ret
;
; RV32IFZFHMIN-LABEL: fold_demote_h_s:
; RV32IFZFHMIN:       # %bb.0:
; RV32IFZFHMIN-NEXT:    addi sp, sp, -16
; RV32IFZFHMIN-NEXT:    fsh fa0, 12(sp)
; RV32IFZFHMIN-NEXT:    fmv.x.w a0, fa1
; RV32IFZFHMIN-NEXT:    lbu a1, 13(sp)
; RV32IFZFHMIN-NEXT:    lui a2, 524288
; RV32IFZFHMIN-NEXT:    and a0, a0, a2
; RV32IFZFHMIN-NEXT:    srli a0, a0, 24
; RV32IFZFHMIN-NEXT:    andi a1, a1, 127
; RV32IFZFHMIN-NEXT:    or a0, a1, a0
; RV32IFZFHMIN-NEXT:    sb a0, 13(sp)
; RV32IFZFHMIN-NEXT:    flh fa0, 12(sp)
; RV32IFZFHMIN-NEXT:    addi sp, sp, 16
; RV32IFZFHMIN-NEXT:    ret
;
; RV32IFDZFHMIN-LABEL: fold_demote_h_s:
; RV32IFDZFHMIN:       # %bb.0:
; RV32IFDZFHMIN-NEXT:    addi sp, sp, -16
; RV32IFDZFHMIN-NEXT:    fsh fa0, 12(sp)
; RV32IFDZFHMIN-NEXT:    fmv.x.w a0, fa1
; RV32IFDZFHMIN-NEXT:    lbu a1, 13(sp)
; RV32IFDZFHMIN-NEXT:    lui a2, 524288
; RV32IFDZFHMIN-NEXT:    and a0, a0, a2
; RV32IFDZFHMIN-NEXT:    srli a0, a0, 24
; RV32IFDZFHMIN-NEXT:    andi a1, a1, 127
; RV32IFDZFHMIN-NEXT:    or a0, a1, a0
; RV32IFDZFHMIN-NEXT:    sb a0, 13(sp)
; RV32IFDZFHMIN-NEXT:    flh fa0, 12(sp)
; RV32IFDZFHMIN-NEXT:    addi sp, sp, 16
; RV32IFDZFHMIN-NEXT:    ret
;
; RV64IFDZFHMIN-LABEL: fold_demote_h_s:
; RV64IFDZFHMIN:       # %bb.0:
; RV64IFDZFHMIN-NEXT:    addi sp, sp, -16
; RV64IFDZFHMIN-NEXT:    fsw fa1, 8(sp)
; RV64IFDZFHMIN-NEXT:    fsh fa0, 0(sp)
; RV64IFDZFHMIN-NEXT:    lbu a0, 11(sp)
; RV64IFDZFHMIN-NEXT:    lbu a1, 1(sp)
; RV64IFDZFHMIN-NEXT:    andi a0, a0, 128
; RV64IFDZFHMIN-NEXT:    andi a1, a1, 127
; RV64IFDZFHMIN-NEXT:    or a0, a1, a0
; RV64IFDZFHMIN-NEXT:    sb a0, 1(sp)
; RV64IFDZFHMIN-NEXT:    flh fa0, 0(sp)
; RV64IFDZFHMIN-NEXT:    addi sp, sp, 16
; RV64IFDZFHMIN-NEXT:    ret
  %c = fptrunc float %b to half
  %t = call half @llvm.copysign.f16(half %a, half %c)
  ret half %t
}

define half @fold_demote_h_d(half %a, double %b) nounwind {
; RV32I-LABEL: fold_demote_h_d:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a1, 524288
; RV32I-NEXT:    and a1, a2, a1
; RV32I-NEXT:    srli a1, a1, 16
; RV32I-NEXT:    slli a0, a0, 17
; RV32I-NEXT:    srli a0, a0, 17
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fold_demote_h_d:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 49
; RV64I-NEXT:    srli a0, a0, 49
; RV64I-NEXT:    srli a1, a1, 63
; RV64I-NEXT:    slli a1, a1, 63
; RV64I-NEXT:    srli a1, a1, 48
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    ret
;
; RV32IF-LABEL: fold_demote_h_d:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.x.w a0, fa0
; RV32IF-NEXT:    lui a2, 524288
; RV32IF-NEXT:    and a1, a1, a2
; RV32IF-NEXT:    srli a1, a1, 16
; RV32IF-NEXT:    slli a0, a0, 17
; RV32IF-NEXT:    srli a0, a0, 17
; RV32IF-NEXT:    or a0, a0, a1
; RV32IF-NEXT:    lui a1, 1048560
; RV32IF-NEXT:    or a0, a0, a1
; RV32IF-NEXT:    fmv.w.x fa0, a0
; RV32IF-NEXT:    ret
;
; RV32IFD-LABEL: fold_demote_h_d:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    fsd fa1, 8(sp)
; RV32IFD-NEXT:    lw a0, 12(sp)
; RV32IFD-NEXT:    fmv.x.w a1, fa0
; RV32IFD-NEXT:    lui a2, 524288
; RV32IFD-NEXT:    and a0, a0, a2
; RV32IFD-NEXT:    srli a0, a0, 16
; RV32IFD-NEXT:    slli a1, a1, 17
; RV32IFD-NEXT:    srli a1, a1, 17
; RV32IFD-NEXT:    lui a2, 1048560
; RV32IFD-NEXT:    or a1, a1, a2
; RV32IFD-NEXT:    or a0, a1, a0
; RV32IFD-NEXT:    fmv.w.x fa0, a0
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: fold_demote_h_d:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fmv.x.d a0, fa1
; RV64IFD-NEXT:    fmv.x.w a1, fa0
; RV64IFD-NEXT:    slli a1, a1, 49
; RV64IFD-NEXT:    srli a1, a1, 49
; RV64IFD-NEXT:    srli a0, a0, 63
; RV64IFD-NEXT:    slli a0, a0, 63
; RV64IFD-NEXT:    srli a0, a0, 48
; RV64IFD-NEXT:    lui a2, 1048560
; RV64IFD-NEXT:    or a1, a1, a2
; RV64IFD-NEXT:    or a0, a1, a0
; RV64IFD-NEXT:    fmv.w.x fa0, a0
; RV64IFD-NEXT:    ret
;
; RV32IFZFH-LABEL: fold_demote_h_d:
; RV32IFZFH:       # %bb.0:
; RV32IFZFH-NEXT:    srli a1, a1, 16
; RV32IFZFH-NEXT:    fmv.h.x ft0, a1
; RV32IFZFH-NEXT:    fsgnj.h fa0, fa0, ft0
; RV32IFZFH-NEXT:    ret
;
; RV32IFDZFH-LABEL: fold_demote_h_d:
; RV32IFDZFH:       # %bb.0:
; RV32IFDZFH-NEXT:    fcvt.h.d ft0, fa1
; RV32IFDZFH-NEXT:    fsgnj.h fa0, fa0, ft0
; RV32IFDZFH-NEXT:    ret
;
; RV64IFDZFH-LABEL: fold_demote_h_d:
; RV64IFDZFH:       # %bb.0:
; RV64IFDZFH-NEXT:    fcvt.h.d ft0, fa1
; RV64IFDZFH-NEXT:    fsgnj.h fa0, fa0, ft0
; RV64IFDZFH-NEXT:    ret
;
; RV32IFZFHMIN-LABEL: fold_demote_h_d:
; RV32IFZFHMIN:       # %bb.0:
; RV32IFZFHMIN-NEXT:    addi sp, sp, -16
; RV32IFZFHMIN-NEXT:    fsh fa0, 8(sp)
; RV32IFZFHMIN-NEXT:    srli a1, a1, 16
; RV32IFZFHMIN-NEXT:    fmv.h.x ft0, a1
; RV32IFZFHMIN-NEXT:    fsh ft0, 12(sp)
; RV32IFZFHMIN-NEXT:    lbu a0, 9(sp)
; RV32IFZFHMIN-NEXT:    lbu a1, 13(sp)
; RV32IFZFHMIN-NEXT:    andi a0, a0, 127
; RV32IFZFHMIN-NEXT:    andi a1, a1, 128
; RV32IFZFHMIN-NEXT:    or a0, a0, a1
; RV32IFZFHMIN-NEXT:    sb a0, 9(sp)
; RV32IFZFHMIN-NEXT:    flh fa0, 8(sp)
; RV32IFZFHMIN-NEXT:    addi sp, sp, 16
; RV32IFZFHMIN-NEXT:    ret
;
; RV32IFDZFHMIN-LABEL: fold_demote_h_d:
; RV32IFDZFHMIN:       # %bb.0:
; RV32IFDZFHMIN-NEXT:    addi sp, sp, -16
; RV32IFDZFHMIN-NEXT:    fsd fa1, 8(sp)
; RV32IFDZFHMIN-NEXT:    fsh fa0, 4(sp)
; RV32IFDZFHMIN-NEXT:    lbu a0, 15(sp)
; RV32IFDZFHMIN-NEXT:    lbu a1, 5(sp)
; RV32IFDZFHMIN-NEXT:    andi a0, a0, 128
; RV32IFDZFHMIN-NEXT:    andi a1, a1, 127
; RV32IFDZFHMIN-NEXT:    or a0, a1, a0
; RV32IFDZFHMIN-NEXT:    sb a0, 5(sp)
; RV32IFDZFHMIN-NEXT:    flh fa0, 4(sp)
; RV32IFDZFHMIN-NEXT:    addi sp, sp, 16
; RV32IFDZFHMIN-NEXT:    ret
;
; RV64IFDZFHMIN-LABEL: fold_demote_h_d:
; RV64IFDZFHMIN:       # %bb.0:
; RV64IFDZFHMIN-NEXT:    addi sp, sp, -16
; RV64IFDZFHMIN-NEXT:    fsh fa0, 8(sp)
; RV64IFDZFHMIN-NEXT:    lbu a0, 9(sp)
; RV64IFDZFHMIN-NEXT:    andi a0, a0, 127
; RV64IFDZFHMIN-NEXT:    fmv.x.d a1, fa1
; RV64IFDZFHMIN-NEXT:    srli a1, a1, 63
; RV64IFDZFHMIN-NEXT:    slli a1, a1, 63
; RV64IFDZFHMIN-NEXT:    srli a1, a1, 56
; RV64IFDZFHMIN-NEXT:    or a0, a0, a1
; RV64IFDZFHMIN-NEXT:    sb a0, 9(sp)
; RV64IFDZFHMIN-NEXT:    flh fa0, 8(sp)
; RV64IFDZFHMIN-NEXT:    addi sp, sp, 16
; RV64IFDZFHMIN-NEXT:    ret
  %c = fptrunc double %b to half
  %t = call half @llvm.copysign.f16(half %a, half %c)
  ret half %t
}
