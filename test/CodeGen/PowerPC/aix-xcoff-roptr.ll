; RUN: llc -mtriple powerpc-ibm-aix-xcoff -mroptr < %s | FileCheck %s
; RUN: llc -mtriple powerpc-ibm-aix-xcoff -mroptr -filetype=obj -o %t.o < %s
; RUN: llvm-objdump -t --symbol-description %t.o | FileCheck %s --check-prefix=OBJ

; RUN: not llc -mtriple powerpc-ibm-aix-xcoff -mroptr -data-sections=false \
; RUN: < %s 2>&1 | FileCheck %s --check-prefix=DS_ERR

; DS_ERR: -mroptr option must be used with -data-sections

%union.U = type { %"struct.U::A" }
%"struct.U::A" = type { ptr }

@_ZL1p = internal constant i32 ptrtoint (ptr @_ZL1p to i32), align 4
; CHECK:         .csect _ZL1p[RO],2
; CHECK-NEXT:    .lglobl	_ZL1p[RO]
; CHECK-NEXT:    .align	2
; CHECK-NEXT:    .vbyte	4, _ZL1p[RO]
; OBJ-DAG: {{([[:xdigit:]]{8})}} l .text {{([[:xdigit:]]{8})}} (idx: [[#]]) _ZL1p[RO]
@q = thread_local constant ptr @_ZL1p, align 4
; CHECK:         .csect q[TL],2
; CHECK-NEXT:    .globl	q[TL]
; CHECK-NEXT:    .align	2
; CHECK-NEXT:    .vbyte	4, _ZL1p[RO]
; OBJ-DAG: {{([[:xdigit:]]{8})}} g O .tdata {{([[:xdigit:]]{8})}} (idx: [[#]]) q[TL]
@u = local_unnamed_addr constant [1 x %union.U] [%union.U { %"struct.U::A" { ptr @_ZL1p } }], align 4
; CHECK:         .csect u[RO],2
; CHECK-NEXT:    .globl	u[RO]
; CHECK-NEXT:    .align	2
; CHECK-NEXT:    .vbyte	4, _ZL1p[RO]
; OBJ-DAG: {{([[:xdigit:]]{8})}} g .text {{([[:xdigit:]]{8})}} (idx: [[#]]) u[RO]
