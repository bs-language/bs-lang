; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -O2 < %s | FileCheck %s -check-prefix=ENABLE
; RUN: opt -S -hexagon-emit-lookup-tables=true -O2 < %s | FileCheck %s -check-prefix=ENABLE
; RUN: opt -S -hexagon-emit-lookup-tables=false -O2 < %s | FileCheck %s -check-prefix=DISABLE

target datalayout = "e-m:e-p:32:32:32-a:0-n16:32-i64:64:64-i32:32:32-i16:16:16-i1:8:8-f32:32:32-f64:64:64-v32:32:32-v64:64:64-v512:512:512-v1024:1024:1024-v2048:2048:2048"
target triple = "hexagon-unknown--elf"

; Function Attrs: noinline nounwind
define i32 @foo(i32 %x) #0 section ".tcm_text" {
; ENABLE-LABEL: @foo(
; ENABLE-NEXT:  entry:
; ENABLE-NEXT:    [[TMP0:%.*]] = icmp ult i32 [[X:%.*]], 6
; ENABLE-NEXT:    br i1 [[TMP0]], label [[SWITCH_LOOKUP:%.*]], label [[RETURN:%.*]]
; ENABLE:       switch.lookup:
; ENABLE-NEXT:    [[SWITCH_GEP:%.*]] = getelementptr inbounds [6 x i32], ptr @switch.table.foo, i32 0, i32 [[X]]
; ENABLE-NEXT:    [[SWITCH_LOAD:%.*]] = load i32, ptr [[SWITCH_GEP]], align 4
; ENABLE-NEXT:    br label [[RETURN]]
; ENABLE:       return:
; ENABLE-NEXT:    [[RETVAL_0:%.*]] = phi i32 [ [[SWITCH_LOAD]], [[SWITCH_LOOKUP]] ], [ 19, [[ENTRY:%.*]] ]
; ENABLE-NEXT:    ret i32 [[RETVAL_0]]
;
; DISABLE-LABEL: @foo(
; DISABLE-NEXT:  entry:
; DISABLE-NEXT:    switch i32 [[X:%.*]], label [[SW_DEFAULT:%.*]] [
; DISABLE-NEXT:    i32 0, label [[RETURN:%.*]]
; DISABLE-NEXT:    i32 1, label [[SW_BB1:%.*]]
; DISABLE-NEXT:    i32 2, label [[SW_BB2:%.*]]
; DISABLE-NEXT:    i32 3, label [[SW_BB3:%.*]]
; DISABLE-NEXT:    i32 4, label [[SW_BB4:%.*]]
; DISABLE-NEXT:    i32 5, label [[SW_BB5:%.*]]
; DISABLE-NEXT:    ]
; DISABLE:       sw.bb1:
; DISABLE-NEXT:    br label [[RETURN]]
; DISABLE:       sw.bb2:
; DISABLE-NEXT:    br label [[RETURN]]
; DISABLE:       sw.bb3:
; DISABLE-NEXT:    br label [[RETURN]]
; DISABLE:       sw.bb4:
; DISABLE-NEXT:    br label [[RETURN]]
; DISABLE:       sw.bb5:
; DISABLE-NEXT:    br label [[RETURN]]
; DISABLE:       sw.default:
; DISABLE-NEXT:    br label [[RETURN]]
; DISABLE:       return:
; DISABLE-NEXT:    [[RETVAL_0:%.*]] = phi i32 [ 19, [[SW_DEFAULT]] ], [ 5, [[SW_BB5]] ], [ 12, [[SW_BB4]] ], [ 22, [[SW_BB3]] ], [ 14, [[SW_BB2]] ], [ 20, [[SW_BB1]] ], [ 9, [[ENTRY:%.*]] ]
; DISABLE-NEXT:    ret i32 [[RETVAL_0]]
;
entry:
  %retval = alloca i32, align 4
  %x.addr = alloca i32, align 4
  store i32 %x, ptr %x.addr, align 4
  %0 = load i32, ptr %x.addr, align 4
  switch i32 %0, label %sw.default [
  i32 0, label %sw.bb
  i32 1, label %sw.bb1
  i32 2, label %sw.bb2
  i32 3, label %sw.bb3
  i32 4, label %sw.bb4
  i32 5, label %sw.bb5
  ]

sw.bb:                                            ; preds = %entry
  store i32 9, ptr %retval, align 4
  br label %return

sw.bb1:                                           ; preds = %entry
  store i32 20, ptr %retval, align 4
  br label %return

sw.bb2:                                           ; preds = %entry
  store i32 14, ptr %retval, align 4
  br label %return

sw.bb3:                                           ; preds = %entry
  store i32 22, ptr %retval, align 4
  br label %return

sw.bb4:                                           ; preds = %entry
  store i32 12, ptr %retval, align 4
  br label %return

sw.bb5:                                           ; preds = %entry
  store i32 5, ptr %retval, align 4
  br label %return

sw.default:                                       ; preds = %entry
  store i32 19, ptr %retval, align 4
  br label %return

return:                                           ; preds = %sw.default, %sw.bb5, %sw.bb4, %sw.bb3, %sw.bb2, %sw.bb1, %sw.bb
  %1 = load i32, ptr %retval, align 4
  ret i32 %1
}

attributes #0 = { noinline nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "frame-pointer"="all" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="hexagonv60" "target-features"="-hvx,-long-calls" "unsafe-fp-math"="false" "use-soft-float"="false" }
