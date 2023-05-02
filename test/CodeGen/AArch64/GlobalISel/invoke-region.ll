; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -O0 -mtriple=aarch64-apple-ios -global-isel -stop-after=legalizer %s -o - | FileCheck %s

@global_var = external global i32
declare i32 @__gxx_personality_v0(...)
declare void @may_throw()

; This test checks that the widened G_CONSTANT operand to the phi in "continue" bb
; is placed before the potentially throwing call in the entry block.
define i1 @test_lpad_phi_widen_into_pred() personality ptr @__gxx_personality_v0 {
  ; CHECK-LABEL: name: test_lpad_phi_widen_into_pred
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   successors: %bb.3(0x40000000), %bb.2(0x40000000)
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[C:%[0-9]+]]:_(s32) = G_CONSTANT i32 42
  ; CHECK-NEXT:   [[GV:%[0-9]+]]:_(p0) = G_GLOBAL_VALUE @global_var
  ; CHECK-NEXT:   [[C1:%[0-9]+]]:_(s32) = G_CONSTANT i32 11
  ; CHECK-NEXT:   G_STORE [[C]](s32), [[GV]](p0) :: (store (s32) into @global_var)
  ; CHECK-NEXT:   [[C2:%[0-9]+]]:_(s16) = G_CONSTANT i16 1
  ; CHECK-NEXT:   G_INVOKE_REGION_START
  ; CHECK-NEXT:   EH_LABEL <mcsymbol >
  ; CHECK-NEXT:   ADJCALLSTACKDOWN 0, 0, implicit-def $sp, implicit $sp
  ; CHECK-NEXT:   BL @may_throw, csr_darwin_aarch64_aapcs, implicit-def $lr, implicit $sp
  ; CHECK-NEXT:   ADJCALLSTACKUP 0, 0, implicit-def $sp, implicit $sp
  ; CHECK-NEXT:   EH_LABEL <mcsymbol >
  ; CHECK-NEXT:   G_BR %bb.3
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.2.lpad (landing-pad):
  ; CHECK-NEXT:   successors: %bb.3(0x80000000)
  ; CHECK-NEXT:   liveins: $x0, $x1
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[PHI:%[0-9]+]]:_(s32) = G_PHI [[C1]](s32), %bb.1
  ; CHECK-NEXT:   EH_LABEL <mcsymbol >
  ; CHECK-NEXT:   G_STORE [[PHI]](s32), [[GV]](p0) :: (store (s32) into @global_var)
  ; CHECK-NEXT:   [[C3:%[0-9]+]]:_(s16) = G_CONSTANT i16 0
  ; CHECK-NEXT:   G_BR %bb.3
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.3.continue:
  ; CHECK-NEXT:   [[PHI1:%[0-9]+]]:_(s16) = G_PHI [[C2]](s16), %bb.1, [[C3]](s16), %bb.2
  ; CHECK-NEXT:   [[C4:%[0-9]+]]:_(s32) = G_CONSTANT i32 1
  ; CHECK-NEXT:   [[ANYEXT:%[0-9]+]]:_(s32) = G_ANYEXT [[PHI1]](s16)
  ; CHECK-NEXT:   [[AND:%[0-9]+]]:_(s32) = G_AND [[ANYEXT]], [[C4]]
  ; CHECK-NEXT:   $w0 = COPY [[AND]](s32)
  ; CHECK-NEXT:   RET_ReallyLR implicit $w0
  store i32 42, ptr @global_var
  invoke void @may_throw()
          to label %continue unwind label %lpad

lpad:                                             ; preds = %entry
  %p = phi i32 [ 11, %0 ]
  %1 = landingpad { ptr, i32 }
          catch ptr null
  store i32 %p, ptr @global_var
  br label %continue

continue:                                         ; preds = %entry, %lpad
  %r.0 = phi i1 [ 1, %0 ], [ 0, %lpad ]
  ret i1 %r.0
}

; Same test but with extensions.
define i1 @test_lpad_phi_widen_into_pred_ext(ptr %ptr) personality ptr @__gxx_personality_v0 {
  ; CHECK-LABEL: name: test_lpad_phi_widen_into_pred_ext
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   successors: %bb.3(0x40000000), %bb.2(0x40000000)
  ; CHECK-NEXT:   liveins: $x0
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:_(p0) = COPY $x0
  ; CHECK-NEXT:   [[C:%[0-9]+]]:_(s32) = G_CONSTANT i32 42
  ; CHECK-NEXT:   [[GV:%[0-9]+]]:_(p0) = G_GLOBAL_VALUE @global_var
  ; CHECK-NEXT:   [[C1:%[0-9]+]]:_(s32) = G_CONSTANT i32 11
  ; CHECK-NEXT:   G_STORE [[C]](s32), [[GV]](p0) :: (store (s32) into @global_var)
  ; CHECK-NEXT:   [[LOAD:%[0-9]+]]:_(s8) = G_LOAD [[COPY]](p0) :: (load (s8) from %ir.ptr)
  ; CHECK-NEXT:   [[ASSERT_ZEXT:%[0-9]+]]:_(s8) = G_ASSERT_ZEXT [[LOAD]], 1
  ; CHECK-NEXT:   [[ANYEXT:%[0-9]+]]:_(s16) = G_ANYEXT [[ASSERT_ZEXT]](s8)
  ; CHECK-NEXT:   G_INVOKE_REGION_START
  ; CHECK-NEXT:   EH_LABEL <mcsymbol >
  ; CHECK-NEXT:   ADJCALLSTACKDOWN 0, 0, implicit-def $sp, implicit $sp
  ; CHECK-NEXT:   BL @may_throw, csr_darwin_aarch64_aapcs, implicit-def $lr, implicit $sp
  ; CHECK-NEXT:   ADJCALLSTACKUP 0, 0, implicit-def $sp, implicit $sp
  ; CHECK-NEXT:   EH_LABEL <mcsymbol >
  ; CHECK-NEXT:   G_BR %bb.3
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.2.lpad (landing-pad):
  ; CHECK-NEXT:   successors: %bb.3(0x80000000)
  ; CHECK-NEXT:   liveins: $x0, $x1
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[PHI:%[0-9]+]]:_(s32) = G_PHI [[C1]](s32), %bb.1
  ; CHECK-NEXT:   EH_LABEL <mcsymbol >
  ; CHECK-NEXT:   G_STORE [[PHI]](s32), [[GV]](p0) :: (store (s32) into @global_var)
  ; CHECK-NEXT:   [[C2:%[0-9]+]]:_(s16) = G_CONSTANT i16 0
  ; CHECK-NEXT:   G_BR %bb.3
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.3.continue:
  ; CHECK-NEXT:   [[PHI1:%[0-9]+]]:_(s16) = G_PHI [[ANYEXT]](s16), %bb.1, [[C2]](s16), %bb.2
  ; CHECK-NEXT:   [[C3:%[0-9]+]]:_(s32) = G_CONSTANT i32 1
  ; CHECK-NEXT:   [[ANYEXT1:%[0-9]+]]:_(s32) = G_ANYEXT [[PHI1]](s16)
  ; CHECK-NEXT:   [[AND:%[0-9]+]]:_(s32) = G_AND [[ANYEXT1]], [[C3]]
  ; CHECK-NEXT:   $w0 = COPY [[AND]](s32)
  ; CHECK-NEXT:   RET_ReallyLR implicit $w0
  store i32 42, ptr @global_var
  %v = load i1, ptr %ptr
  invoke void @may_throw()
          to label %continue unwind label %lpad

lpad:                                             ; preds = %entry
  %p = phi i32 [ 11, %0 ]
  %1 = landingpad { ptr, i32 }
          catch ptr null
  store i32 %p, ptr @global_var
  br label %continue

continue:                                         ; preds = %entry, %lpad
  %r.0 = phi i1 [ %v, %0 ], [ 0, %lpad ]
  ret i1 %r.0
}
