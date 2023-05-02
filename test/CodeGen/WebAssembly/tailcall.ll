; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 2
; RUN: llc < %s -verify-machineinstrs -disable-wasm-fallthrough-return-opt -wasm-disable-explicit-locals -wasm-keep-registers -mcpu=mvp -mattr=+tail-call | FileCheck --check-prefixes=CHECK,SLOW %s
; RUN: llc < %s -verify-machineinstrs -disable-wasm-fallthrough-return-opt -wasm-disable-explicit-locals -wasm-keep-registers -fast-isel -mcpu=mvp -mattr=+tail-call | FileCheck --check-prefixes=CHECK,FAST %s
; RUN: llc < %s --filetype=obj -mattr=+tail-call | obj2yaml | FileCheck --check-prefix=YAML %s

; Test that the tail calls lower correctly

target triple = "wasm32-unknown-unknown"

%fn = type <{ptr}>
declare i1 @foo(i1)
declare i1 @bar(i1)

define void @recursive_notail_nullary() {
; CHECK-LABEL: recursive_notail_nullary:
; CHECK:         .functype recursive_notail_nullary () -> ()
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    call recursive_notail_nullary
; CHECK-NEXT:    return
  notail call void @recursive_notail_nullary()
  ret void
}

define void @recursive_musttail_nullary() {
; CHECK-LABEL: recursive_musttail_nullary:
; CHECK:         .functype recursive_musttail_nullary () -> ()
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    return_call recursive_musttail_nullary
  musttail call void @recursive_musttail_nullary()
  ret void
}
define void @recursive_tail_nullary() {
; SLOW-LABEL: recursive_tail_nullary:
; SLOW:         .functype recursive_tail_nullary () -> ()
; SLOW-NEXT:  # %bb.0:
; SLOW-NEXT:    return_call recursive_tail_nullary
;
; FAST-LABEL: recursive_tail_nullary:
; FAST:         .functype recursive_tail_nullary () -> ()
; FAST-NEXT:  # %bb.0:
; FAST-NEXT:    call recursive_tail_nullary
; FAST-NEXT:    return
  tail call void @recursive_tail_nullary()
  ret void
}

define i32 @recursive_notail(i32 %x, i32 %y) {
; CHECK-LABEL: recursive_notail:
; CHECK:         .functype recursive_notail (i32, i32) -> (i32)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    call $push0=, recursive_notail, $0, $1
; CHECK-NEXT:    return $pop0
  %v = notail call i32 @recursive_notail(i32 %x, i32 %y)
  ret i32 %v
}

define i32 @recursive_musttail(i32 %x, i32 %y) {
; CHECK-LABEL: recursive_musttail:
; CHECK:         .functype recursive_musttail (i32, i32) -> (i32)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    return_call recursive_musttail, $0, $1
  %v = musttail call i32 @recursive_musttail(i32 %x, i32 %y)
  ret i32 %v
}

define i32 @recursive_tail(i32 %x, i32 %y) {
; SLOW-LABEL: recursive_tail:
; SLOW:         .functype recursive_tail (i32, i32) -> (i32)
; SLOW-NEXT:  # %bb.0:
; SLOW-NEXT:    return_call recursive_tail, $0, $1
;
; FAST-LABEL: recursive_tail:
; FAST:         .functype recursive_tail (i32, i32) -> (i32)
; FAST-NEXT:  # %bb.0:
; FAST-NEXT:    call $push0=, recursive_tail, $0, $1
; FAST-NEXT:    return $pop0
  %v = tail call i32 @recursive_tail(i32 %x, i32 %y)
  ret i32 %v
}

define i32 @indirect_notail(%fn %f, i32 %x, i32 %y) {
; CHECK-LABEL: indirect_notail:
; CHECK:         .functype indirect_notail (i32, i32, i32) -> (i32)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    call_indirect $push0=, $0, $1, $2, $0 # Invalid depth argument!
; CHECK-NEXT:    return $pop0
  %p = extractvalue %fn %f, 0
  %v = notail call i32 %p(%fn %f, i32 %x, i32 %y)
  ret i32 %v
}

define i32 @indirect_musttail(%fn %f, i32 %x, i32 %y) {
; CHECK-LABEL: indirect_musttail:
; CHECK:         .functype indirect_musttail (i32, i32, i32) -> (i32)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    return_call_indirect , $0, $1, $2, $0
  %p = extractvalue %fn %f, 0
  %v = musttail call i32 %p(%fn %f, i32 %x, i32 %y)
  ret i32 %v
}

define i32 @indirect_tail(%fn %f, i32 %x, i32 %y) {
; CHECK-LABEL: indirect_tail:
; CHECK:         .functype indirect_tail (i32, i32, i32) -> (i32)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    return_call_indirect , $0, $1, $2, $0
  %p = extractvalue %fn %f, 0
  %v = tail call i32 %p(%fn %f, i32 %x, i32 %y)
  ret i32 %v
}

define i1 @choice_notail(i1 %x) {
; SLOW-LABEL: choice_notail:
; SLOW:         .functype choice_notail (i32) -> (i32)
; SLOW-NEXT:  # %bb.0:
; SLOW-NEXT:    i32.const $push3=, foo
; SLOW-NEXT:    i32.const $push2=, bar
; SLOW-NEXT:    i32.const $push0=, 1
; SLOW-NEXT:    i32.and $push1=, $0, $pop0
; SLOW-NEXT:    i32.select $push4=, $pop3, $pop2, $pop1
; SLOW-NEXT:    call_indirect $push5=, $0, $pop4 # Invalid depth argument!
; SLOW-NEXT:    return $pop5
;
; FAST-LABEL: choice_notail:
; FAST:         .functype choice_notail (i32) -> (i32)
; FAST-NEXT:  # %bb.0:
; FAST-NEXT:    i32.const $push3=, foo
; FAST-NEXT:    i32.const $push4=, bar
; FAST-NEXT:    i32.const $push1=, 1
; FAST-NEXT:    i32.and $push2=, $0, $pop1
; FAST-NEXT:    i32.select $push5=, $pop3, $pop4, $pop2
; FAST-NEXT:    call_indirect $push0=, $0, $pop5 # Invalid depth argument!
; FAST-NEXT:    return $pop0
  %p = select i1 %x, ptr @foo, ptr @bar
  %v = notail call i1 %p(i1 %x)
  ret i1 %v
}

define i1 @choice_musttail(i1 %x) {
; SLOW-LABEL: choice_musttail:
; SLOW:         .functype choice_musttail (i32) -> (i32)
; SLOW-NEXT:  # %bb.0:
; SLOW-NEXT:    i32.const $push3=, foo
; SLOW-NEXT:    i32.const $push2=, bar
; SLOW-NEXT:    i32.const $push0=, 1
; SLOW-NEXT:    i32.and $push1=, $0, $pop0
; SLOW-NEXT:    i32.select $push4=, $pop3, $pop2, $pop1
; SLOW-NEXT:    return_call_indirect , $0, $pop4
;
; FAST-LABEL: choice_musttail:
; FAST:         .functype choice_musttail (i32) -> (i32)
; FAST-NEXT:  # %bb.0:
; FAST-NEXT:    i32.const $push4=, foo
; FAST-NEXT:    i32.const $push3=, bar
; FAST-NEXT:    i32.const $push1=, 1
; FAST-NEXT:    i32.and $push2=, $0, $pop1
; FAST-NEXT:    i32.select $push0=, $pop4, $pop3, $pop2
; FAST-NEXT:    return_call_indirect , $0, $pop0
  %p = select i1 %x, ptr @foo, ptr @bar
  %v = musttail call i1 %p(i1 %x)
  ret i1 %v
}

define i1 @choice_tail(i1 %x) {
; SLOW-LABEL: choice_tail:
; SLOW:         .functype choice_tail (i32) -> (i32)
; SLOW-NEXT:  # %bb.0:
; SLOW-NEXT:    i32.const $push3=, foo
; SLOW-NEXT:    i32.const $push2=, bar
; SLOW-NEXT:    i32.const $push0=, 1
; SLOW-NEXT:    i32.and $push1=, $0, $pop0
; SLOW-NEXT:    i32.select $push4=, $pop3, $pop2, $pop1
; SLOW-NEXT:    return_call_indirect , $0, $pop4
;
; FAST-LABEL: choice_tail:
; FAST:         .functype choice_tail (i32) -> (i32)
; FAST-NEXT:  # %bb.0:
; FAST-NEXT:    i32.const $push3=, foo
; FAST-NEXT:    i32.const $push4=, bar
; FAST-NEXT:    i32.const $push1=, 1
; FAST-NEXT:    i32.and $push2=, $0, $pop1
; FAST-NEXT:    i32.select $push5=, $pop3, $pop4, $pop2
; FAST-NEXT:    call_indirect $push0=, $0, $pop5 # Invalid depth argument!
; FAST-NEXT:    return $pop0
  %p = select i1 %x, ptr @foo, ptr @bar
  %v = tail call i1 %p(i1 %x)
  ret i1 %v
}

; It is an LLVM validation error for a 'musttail' callee to have a different
; prototype than its caller, so the following tests can only be done with
; 'tail'.

declare i32 @baz(i32, i32, i32)
define i32 @mismatched_prototypes() {
; SLOW-LABEL: mismatched_prototypes:
; SLOW:         .functype mismatched_prototypes () -> (i32)
; SLOW-NEXT:  # %bb.0:
; SLOW-NEXT:    i32.const $push2=, 0
; SLOW-NEXT:    i32.const $push1=, 42
; SLOW-NEXT:    i32.const $push0=, 6
; SLOW-NEXT:    return_call baz, $pop2, $pop1, $pop0
;
; FAST-LABEL: mismatched_prototypes:
; FAST:         .functype mismatched_prototypes () -> (i32)
; FAST-NEXT:  # %bb.0:
; FAST-NEXT:    i32.const $push1=, 0
; FAST-NEXT:    i32.const $push2=, 42
; FAST-NEXT:    i32.const $push3=, 6
; FAST-NEXT:    call $push0=, baz, $pop1, $pop2, $pop3
; FAST-NEXT:    return $pop0
  %v = tail call i32 @baz(i32 0, i32 42, i32 6)
  ret i32 %v
}

define void @mismatched_return_void() {
; SLOW-LABEL: mismatched_return_void:
; SLOW:         .functype mismatched_return_void () -> ()
; SLOW-NEXT:  # %bb.0:
; SLOW-NEXT:    i32.const $push2=, 0
; SLOW-NEXT:    i32.const $push1=, 42
; SLOW-NEXT:    i32.const $push0=, 6
; SLOW-NEXT:    call $drop=, baz, $pop2, $pop1, $pop0
; SLOW-NEXT:    return
;
; FAST-LABEL: mismatched_return_void:
; FAST:         .functype mismatched_return_void () -> ()
; FAST-NEXT:  # %bb.0:
; FAST-NEXT:    i32.const $push0=, 0
; FAST-NEXT:    i32.const $push1=, 42
; FAST-NEXT:    i32.const $push2=, 6
; FAST-NEXT:    call $drop=, baz, $pop0, $pop1, $pop2
; FAST-NEXT:    return
  %v = tail call i32 @baz(i32 0, i32 42, i32 6)
  ret void
}

define float @mismatched_return_f32() {
; SLOW-LABEL: mismatched_return_f32:
; SLOW:         .functype mismatched_return_f32 () -> (f32)
; SLOW-NEXT:  # %bb.0:
; SLOW-NEXT:    i32.const $push2=, 0
; SLOW-NEXT:    i32.const $push1=, 42
; SLOW-NEXT:    i32.const $push0=, 6
; SLOW-NEXT:    call $push3=, baz, $pop2, $pop1, $pop0
; SLOW-NEXT:    f32.reinterpret_i32 $push4=, $pop3
; SLOW-NEXT:    return $pop4
;
; FAST-LABEL: mismatched_return_f32:
; FAST:         .functype mismatched_return_f32 () -> (f32)
; FAST-NEXT:  # %bb.0:
; FAST-NEXT:    i32.const $push2=, 0
; FAST-NEXT:    i32.const $push3=, 42
; FAST-NEXT:    i32.const $push4=, 6
; FAST-NEXT:    call $push1=, baz, $pop2, $pop3, $pop4
; FAST-NEXT:    f32.reinterpret_i32 $push0=, $pop1
; FAST-NEXT:    return $pop0
  %v = tail call i32 @baz(i32 0, i32 42, i32 6)
  %u = bitcast i32 %v to float
  ret float %u
}

define void @mismatched_indirect_void(%fn %f, i32 %x, i32 %y) {
; CHECK-LABEL: mismatched_indirect_void:
; CHECK:         .functype mismatched_indirect_void (i32, i32, i32) -> ()
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    call_indirect $drop=, $0, $1, $2, $0 # Invalid depth argument!
; CHECK-NEXT:    return
  %p = extractvalue %fn %f, 0
  %v = tail call i32 %p(%fn %f, i32 %x, i32 %y)
  ret void
}

define float @mismatched_indirect_f32(%fn %f, i32 %x, i32 %y) {
; CHECK-LABEL: mismatched_indirect_f32:
; CHECK:         .functype mismatched_indirect_f32 (i32, i32, i32) -> (f32)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    call_indirect $push0=, $0, $1, $2, $0 # Invalid depth argument!
; CHECK-NEXT:    f32.reinterpret_i32 $push1=, $pop0
; CHECK-NEXT:    return $pop1
  %p = extractvalue %fn %f, 0
  %v = tail call i32 %p(%fn %f, i32 %x, i32 %y)
  %u = bitcast i32 %v to float
  ret float %u
}

declare i32 @quux(ptr byval(i32))
define i32 @mismatched_byval(ptr %x) {
; CHECK-LABEL: mismatched_byval:
; CHECK:         .functype mismatched_byval (i32) -> (i32)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    global.get $push1=, __stack_pointer
; CHECK-NEXT:    i32.const $push2=, 16
; CHECK-NEXT:    i32.sub $push8=, $pop1, $pop2
; CHECK-NEXT:    local.tee $push7=, $1=, $pop8
; CHECK-NEXT:    global.set __stack_pointer, $pop7
; CHECK-NEXT:    i32.load $push0=, 0($0)
; CHECK-NEXT:    i32.store 12($1), $pop0
; CHECK-NEXT:    i32.const $push3=, 16
; CHECK-NEXT:    i32.add $push4=, $1, $pop3
; CHECK-NEXT:    global.set __stack_pointer, $pop4
; CHECK-NEXT:    i32.const $push5=, 12
; CHECK-NEXT:    i32.add $push6=, $1, $pop5
; CHECK-NEXT:    return_call quux, $pop6
  %v = tail call i32 @quux(ptr byval(i32) %x)
  ret i32 %v
}

declare i32 @var(...)
define i32 @varargs(i32 %x) {
; CHECK-LABEL: varargs:
; CHECK:         .functype varargs (i32) -> (i32)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    global.get $push0=, __stack_pointer
; CHECK-NEXT:    i32.const $push1=, 16
; CHECK-NEXT:    i32.sub $push5=, $pop0, $pop1
; CHECK-NEXT:    local.tee $push4=, $1=, $pop5
; CHECK-NEXT:    global.set __stack_pointer, $pop4
; CHECK-NEXT:    i32.store 0($1), $0
; CHECK-NEXT:    call $0=, var, $1
; CHECK-NEXT:    i32.const $push2=, 16
; CHECK-NEXT:    i32.add $push3=, $1, $pop2
; CHECK-NEXT:    global.set __stack_pointer, $pop3
; CHECK-NEXT:    return $0
  %v = tail call i32 (...) @var(i32 %x)
  ret i32 %v
}

; Type transformations inhibit tail calls, even when they are nops

define i32 @mismatched_return_zext() {
; SLOW-LABEL: mismatched_return_zext:
; SLOW:         .functype mismatched_return_zext () -> (i32)
; SLOW-NEXT:  # %bb.0:
; SLOW-NEXT:    i32.const $push0=, 1
; SLOW-NEXT:    call $push1=, foo, $pop0
; SLOW-NEXT:    i32.const $push3=, 1
; SLOW-NEXT:    i32.and $push2=, $pop1, $pop3
; SLOW-NEXT:    return $pop2
;
; FAST-LABEL: mismatched_return_zext:
; FAST:         .functype mismatched_return_zext () -> (i32)
; FAST-NEXT:  # %bb.0:
; FAST-NEXT:    i32.const $push2=, 1
; FAST-NEXT:    call $push1=, foo, $pop2
; FAST-NEXT:    i32.const $push3=, 1
; FAST-NEXT:    i32.and $push0=, $pop1, $pop3
; FAST-NEXT:    return $pop0
  %v = tail call i1 @foo(i1 1)
  %u = zext i1 %v to i32
  ret i32 %u
}

define i32 @mismatched_return_sext() {
; SLOW-LABEL: mismatched_return_sext:
; SLOW:         .functype mismatched_return_sext () -> (i32)
; SLOW-NEXT:  # %bb.0:
; SLOW-NEXT:    i32.const $push3=, 0
; SLOW-NEXT:    i32.const $push0=, 1
; SLOW-NEXT:    call $push1=, foo, $pop0
; SLOW-NEXT:    i32.const $push5=, 1
; SLOW-NEXT:    i32.and $push2=, $pop1, $pop5
; SLOW-NEXT:    i32.sub $push4=, $pop3, $pop2
; SLOW-NEXT:    return $pop4
;
; FAST-LABEL: mismatched_return_sext:
; FAST:         .functype mismatched_return_sext () -> (i32)
; FAST-NEXT:  # %bb.0:
; FAST-NEXT:    i32.const $push4=, 1
; FAST-NEXT:    call $push3=, foo, $pop4
; FAST-NEXT:    i32.const $push0=, 31
; FAST-NEXT:    i32.shl $push1=, $pop3, $pop0
; FAST-NEXT:    i32.const $push5=, 31
; FAST-NEXT:    i32.shr_s $push2=, $pop1, $pop5
; FAST-NEXT:    return $pop2
  %v = tail call i1 @foo(i1 1)
  %u = sext i1 %v to i32
  ret i32 %u
}

declare i32 @int()
define i1 @mismatched_return_trunc() {
; CHECK-LABEL: mismatched_return_trunc:
; CHECK:         .functype mismatched_return_trunc () -> (i32)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    call $push0=, int
; CHECK-NEXT:    return $pop0
  %v = tail call i32 @int()
  %u = trunc i32 %v to i1
  ret i1 %u
}

; Stack-allocated arguments inhibit tail calls

define i32 @stack_arg(ptr %x) {
; SLOW-LABEL: stack_arg:
; SLOW:         .functype stack_arg (i32) -> (i32)
; SLOW-NEXT:  # %bb.0:
; SLOW-NEXT:    global.get $push0=, __stack_pointer
; SLOW-NEXT:    i32.const $push1=, 16
; SLOW-NEXT:    i32.sub $push7=, $pop0, $pop1
; SLOW-NEXT:    local.tee $push6=, $2=, $pop7
; SLOW-NEXT:    global.set __stack_pointer, $pop6
; SLOW-NEXT:    i32.const $push4=, 12
; SLOW-NEXT:    i32.add $push5=, $2, $pop4
; SLOW-NEXT:    call $1=, stack_arg, $pop5
; SLOW-NEXT:    i32.const $push2=, 16
; SLOW-NEXT:    i32.add $push3=, $2, $pop2
; SLOW-NEXT:    global.set __stack_pointer, $pop3
; SLOW-NEXT:    return $1
;
; FAST-LABEL: stack_arg:
; FAST:         .functype stack_arg (i32) -> (i32)
; FAST-NEXT:  # %bb.0:
; FAST-NEXT:    global.get $push1=, __stack_pointer
; FAST-NEXT:    i32.const $push2=, 16
; FAST-NEXT:    i32.sub $push8=, $pop1, $pop2
; FAST-NEXT:    local.tee $push7=, $2=, $pop8
; FAST-NEXT:    global.set __stack_pointer, $pop7
; FAST-NEXT:    i32.const $push5=, 12
; FAST-NEXT:    i32.add $push6=, $2, $pop5
; FAST-NEXT:    local.copy $push0=, $pop6
; FAST-NEXT:    call $1=, stack_arg, $pop0
; FAST-NEXT:    i32.const $push3=, 16
; FAST-NEXT:    i32.add $push4=, $2, $pop3
; FAST-NEXT:    global.set __stack_pointer, $pop4
; FAST-NEXT:    return $1
  %a = alloca i32
  %v = tail call i32 @stack_arg(ptr %a)
  ret i32 %v
}

define i32 @stack_arg_gep(ptr %x) {
; SLOW-LABEL: stack_arg_gep:
; SLOW:         .functype stack_arg_gep (i32) -> (i32)
; SLOW-NEXT:  # %bb.0:
; SLOW-NEXT:    global.get $push2=, __stack_pointer
; SLOW-NEXT:    i32.const $push3=, 16
; SLOW-NEXT:    i32.sub $push9=, $pop2, $pop3
; SLOW-NEXT:    local.tee $push8=, $2=, $pop9
; SLOW-NEXT:    global.set __stack_pointer, $pop8
; SLOW-NEXT:    i32.const $push6=, 8
; SLOW-NEXT:    i32.add $push7=, $2, $pop6
; SLOW-NEXT:    i32.const $push0=, 4
; SLOW-NEXT:    i32.or $push1=, $pop7, $pop0
; SLOW-NEXT:    call $1=, stack_arg_gep, $pop1
; SLOW-NEXT:    i32.const $push4=, 16
; SLOW-NEXT:    i32.add $push5=, $2, $pop4
; SLOW-NEXT:    global.set __stack_pointer, $pop5
; SLOW-NEXT:    return $1
;
; FAST-LABEL: stack_arg_gep:
; FAST:         .functype stack_arg_gep (i32) -> (i32)
; FAST-NEXT:  # %bb.0:
; FAST-NEXT:    global.get $push3=, __stack_pointer
; FAST-NEXT:    i32.const $push4=, 16
; FAST-NEXT:    i32.sub $push10=, $pop3, $pop4
; FAST-NEXT:    local.tee $push9=, $2=, $pop10
; FAST-NEXT:    global.set __stack_pointer, $pop9
; FAST-NEXT:    i32.const $push7=, 8
; FAST-NEXT:    i32.add $push8=, $2, $pop7
; FAST-NEXT:    local.copy $push0=, $pop8
; FAST-NEXT:    i32.const $push1=, 4
; FAST-NEXT:    i32.add $push2=, $pop0, $pop1
; FAST-NEXT:    call $1=, stack_arg_gep, $pop2
; FAST-NEXT:    i32.const $push5=, 16
; FAST-NEXT:    i32.add $push6=, $2, $pop5
; FAST-NEXT:    global.set __stack_pointer, $pop6
; FAST-NEXT:    return $1
  %a = alloca { i32, i32 }
  %p = getelementptr { i32, i32 }, ptr %a, i32 0, i32 1
  %v = tail call i32 @stack_arg_gep(ptr %p)
  ret i32 %v
}

define i32 @stack_arg_cast(i32 %x) {
; SLOW-LABEL: stack_arg_cast:
; SLOW:         .functype stack_arg_cast (i32) -> (i32)
; SLOW-NEXT:  # %bb.0:
; SLOW-NEXT:    global.get $push0=, __stack_pointer
; SLOW-NEXT:    i32.const $push1=, 256
; SLOW-NEXT:    i32.sub $push5=, $pop0, $pop1
; SLOW-NEXT:    local.tee $push4=, $1=, $pop5
; SLOW-NEXT:    global.set __stack_pointer, $pop4
; SLOW-NEXT:    i32.const $push2=, 256
; SLOW-NEXT:    i32.add $push3=, $1, $pop2
; SLOW-NEXT:    global.set __stack_pointer, $pop3
; SLOW-NEXT:    return_call stack_arg_cast, $1
;
; FAST-LABEL: stack_arg_cast:
; FAST:         .functype stack_arg_cast (i32) -> (i32)
; FAST-NEXT:  # %bb.0:
; FAST-NEXT:    global.get $push1=, __stack_pointer
; FAST-NEXT:    i32.const $push2=, 256
; FAST-NEXT:    i32.sub $push6=, $pop1, $pop2
; FAST-NEXT:    local.tee $push5=, $2=, $pop6
; FAST-NEXT:    global.set __stack_pointer, $pop5
; FAST-NEXT:    local.copy $push0=, $2
; FAST-NEXT:    call $1=, stack_arg_cast, $pop0
; FAST-NEXT:    i32.const $push3=, 256
; FAST-NEXT:    i32.add $push4=, $2, $pop3
; FAST-NEXT:    global.set __stack_pointer, $pop4
; FAST-NEXT:    return $1
  %a = alloca [64 x i32]
  %i = ptrtoint ptr %a to i32
  %v = tail call i32 @stack_arg_cast(i32 %i)
  ret i32 %v
}

; Checks that epilogues are inserted after return calls.
define i32 @direct_epilogue() {
; CHECK-LABEL: direct_epilogue:
; CHECK:         .functype direct_epilogue () -> (i32)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    global.get $push0=, __stack_pointer
; CHECK-NEXT:    i32.const $push1=, 256
; CHECK-NEXT:    i32.sub $push5=, $pop0, $pop1
; CHECK-NEXT:    local.tee $push4=, $0=, $pop5
; CHECK-NEXT:    global.set __stack_pointer, $pop4
; CHECK-NEXT:    i32.const $push2=, 256
; CHECK-NEXT:    i32.add $push3=, $0, $pop2
; CHECK-NEXT:    global.set __stack_pointer, $pop3
; CHECK-NEXT:    return_call direct_epilogue
  %a = alloca [64 x i32]
  %v = musttail call i32 @direct_epilogue()
  ret i32 %v
}

define i32 @indirect_epilogue(ptr %p) {
; CHECK-LABEL: indirect_epilogue:
; CHECK:         .functype indirect_epilogue (i32) -> (i32)
; CHECK-NEXT:  # %bb.0:
; CHECK-NEXT:    global.get $push0=, __stack_pointer
; CHECK-NEXT:    i32.const $push1=, 256
; CHECK-NEXT:    i32.sub $push5=, $pop0, $pop1
; CHECK-NEXT:    local.tee $push4=, $1=, $pop5
; CHECK-NEXT:    global.set __stack_pointer, $pop4
; CHECK-NEXT:    i32.const $push2=, 256
; CHECK-NEXT:    i32.add $push3=, $1, $pop2
; CHECK-NEXT:    global.set __stack_pointer, $pop3
; CHECK-NEXT:    return_call_indirect , $0, $0
  %a = alloca [64 x i32]
  %v = musttail call i32 %p(ptr %p)
  ret i32 %v
}

; Check that the signatures generated for external indirectly
; return-called functions include the proper return types

; YAML-LABEL: - Index:           8
; YAML-NEXT:    ParamTypes:
; YAML-NEXT:      - I32
; YAML-NEXT:      - F32
; YAML-NEXT:      - I64
; YAML-NEXT:      - F64
; YAML-NEXT:    ReturnTypes:
; YAML-NEXT:      - I32
define i32 @unique_caller(ptr %p) {
; SLOW-LABEL: unique_caller:
; SLOW:         .functype unique_caller (i32) -> (i32)
; SLOW-NEXT:  # %bb.0:
; SLOW-NEXT:    i32.const $push4=, 0
; SLOW-NEXT:    f32.const $push3=, 0x0p0
; SLOW-NEXT:    i64.const $push2=, 0
; SLOW-NEXT:    f64.const $push1=, 0x0p0
; SLOW-NEXT:    i32.load $push0=, 0($0)
; SLOW-NEXT:    return_call_indirect , $pop4, $pop3, $pop2, $pop1, $pop0
;
; FAST-LABEL: unique_caller:
; FAST:         .functype unique_caller (i32) -> (i32)
; FAST-NEXT:  # %bb.0:
; FAST-NEXT:    i32.const $push1=, 0
; FAST-NEXT:    i32.const $push7=, 0
; FAST-NEXT:    f32.convert_i32_s $push2=, $pop7
; FAST-NEXT:    i64.const $push3=, 0
; FAST-NEXT:    i32.const $push6=, 0
; FAST-NEXT:    f64.convert_i32_s $push4=, $pop6
; FAST-NEXT:    i32.load $push5=, 0($0)
; FAST-NEXT:    call_indirect $push0=, $pop1, $pop2, $pop3, $pop4, $pop5 # Invalid depth argument!
; FAST-NEXT:    return $pop0
  %f = load ptr, ptr %p
  %v = tail call i32 %f(i32 0, float 0., i64 0, double 0.)
  ret i32 %v
}

; CHECK-LABEL: .section .custom_section.target_features
; CHECK-NEXT: .int8 1
; CHECK-NEXT: .int8 43
; CHECK-NEXT: .int8 9
; CHECK-NEXT: .ascii "tail-call"
