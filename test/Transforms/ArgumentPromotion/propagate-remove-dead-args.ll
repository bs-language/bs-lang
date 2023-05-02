; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 2
; RUN: opt < %s -passes=argpromotion -S | FileCheck %s

%ptr.struct = type { ptr, ptr, ptr }

define internal void @child(ptr %this, ptr %y, ptr %x) {
; CHECK-LABEL: define internal void @child
; CHECK-SAME: (ptr [[Y:%.*]], half [[X_0_VAL:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store half [[X_0_VAL]], ptr [[Y]], align 2
; CHECK-NEXT:    ret void
;
entry:
  %0 = load half, ptr %x
  store half %0, ptr %y
  ret void
}

define internal void @parent(ptr %this, ptr %p1, ptr %p2) {
; CHECK-LABEL: define internal void @parent
; CHECK-SAME: (ptr [[P1:%.*]], ptr [[P2:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[P2_VAL2:%.*]] = load half, ptr [[P2]], align 2
; CHECK-NEXT:    call void @child(ptr [[P1]], half [[P2_VAL2]])
; CHECK-NEXT:    [[P2_VAL1:%.*]] = load half, ptr [[P2]], align 2
; CHECK-NEXT:    call void @child(ptr [[P1]], half [[P2_VAL1]])
; CHECK-NEXT:    [[P2_VAL:%.*]] = load half, ptr [[P2]], align 2
; CHECK-NEXT:    call void @child(ptr [[P1]], half [[P2_VAL]])
; CHECK-NEXT:    ret void
;
entry:
  %src_element_op_0 = getelementptr ptr, ptr %this, i64 0
  %load0 = load ptr, ptr %src_element_op_0
  call void @child(ptr %load0, ptr %p1, ptr %p2)
  %src_element_op_1 = getelementptr ptr, ptr %this, i64 1
  %load1 = load ptr, ptr %src_element_op_1
  call void @child(ptr %load1, ptr %p1, ptr %p2)
  %src_element_op_2 = getelementptr ptr, ptr %this, i64 2
  %load2 = load ptr, ptr %src_element_op_2
  call void @child(ptr %load2, ptr %p1, ptr %p2)
  ret void
}

define  void @grandparent() {
; CHECK-LABEL: define void @grandparent() {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[XPTR:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[YPTR:%.*]] = alloca i32, align 4
; CHECK-NEXT:    call void @parent(ptr [[XPTR]], ptr [[YPTR]])
; CHECK-NEXT:    ret void
;
entry:
  %f = alloca %ptr.struct
  %xptr = alloca i32
  %yptr = alloca i32
  call void @parent(ptr %f, ptr %xptr, ptr %yptr)
  ret void
}

define internal ptr @callee(ptr %dead) {
; CHECK-LABEL: define internal ptr @callee() {
; CHECK-NEXT:    ret ptr null
;
  ret ptr null
}

define void @caller() {
; CHECK-LABEL: define void @caller() {
; CHECK-NEXT:    [[TMP1:%.*]] = call ptr @callee()
; CHECK-NEXT:    [[TMP2:%.*]] = call ptr @callee()
; CHECK-NEXT:    ret void
;
  %ret = call ptr @callee(ptr null)
  %ret2 = call ptr @callee(ptr %ret)
  ret void
}
