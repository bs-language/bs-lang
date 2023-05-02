; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 2
; RUN: opt -S -loop-reduce %s | FileCheck --check-prefixes=LEGACYPM %s
; RUN: opt -S -passes=loop-reduce %s | FileCheck --check-prefixes=NEWPM %s

; REQUIRES: asserts
; XFAIL: *

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define void @function_0(i32 %val_i32_8, i32 %val_i32_9) {
; LEGACYPM-LABEL: define void @function_0
; LEGACYPM-SAME: (i32 [[VAL_I32_8:%.*]], i32 [[VAL_I32_9:%.*]]) {
; LEGACYPM-NEXT:    [[VAL_I1_22:%.*]] = trunc i8 -66 to i1
; LEGACYPM-NEXT:    br i1 [[VAL_I1_22]], label [[BB_2_PREHEADER:%.*]], label [[BB_2_PREHEADER]]
; LEGACYPM:       bb_2.preheader:
; LEGACYPM-NEXT:    br label [[BB_2:%.*]]
; LEGACYPM:       bb_2:
; LEGACYPM-NEXT:    br label [[PRHDR_LOOP_3:%.*]]
; LEGACYPM:       prhdr_loop_3:
; LEGACYPM-NEXT:    br label [[LOOP_4:%.*]]
; LEGACYPM:       loop_4:
; LEGACYPM-NEXT:    [[LSR_IV:%.*]] = phi i32 [ [[LSR_IV_NEXT:%.*]], [[BE_6:%.*]] ], [ 7851, [[PRHDR_LOOP_3]] ]
; LEGACYPM-NEXT:    br i1 [[VAL_I1_22]], label [[BE_6]], label [[LOOP_EXIT_7SPLIT:%.*]]
; LEGACYPM:       bb_5:
; LEGACYPM-NEXT:    [[VAL_I32_40:%.*]] = mul i32 [[VAL_I32_9]], [[VAL_I32_24_LCSSA:%.*]]
; LEGACYPM-NEXT:    br label [[BB_2]]
; LEGACYPM:       be_6:
; LEGACYPM-NEXT:    [[LSR_IV_NEXT]] = add i32 [[LSR_IV]], 1
; LEGACYPM-NEXT:    br i1 [[VAL_I1_22]], label [[LOOP_4]], label [[BE_6_LOOP_EXIT_7_CRIT_EDGE:%.*]]
; LEGACYPM:       loop_exit_7split:
; LEGACYPM-NEXT:    br label [[LOOP_EXIT_7:%.*]]
; LEGACYPM:       be_6.loop_exit_7_crit_edge:
; LEGACYPM-NEXT:    br label [[LOOP_EXIT_7]]
; LEGACYPM:       loop_exit_7:
; LEGACYPM-NEXT:    [[VAL_I32_24_LCSSA]] = phi i32 [ [[LSR_IV]], [[BE_6_LOOP_EXIT_7_CRIT_EDGE]] ], [ [[LSR_IV]], [[LOOP_EXIT_7SPLIT]] ]
; LEGACYPM-NEXT:    br label [[BB_5:%.*]]
;
  %val_i1_22 = trunc i8 -66 to i1
  br i1 %val_i1_22, label %bb_2, label %bb_2

bb_2:                                             ; preds = %bb_5, %entry_1, %entry_1
  br label %prhdr_loop_3

prhdr_loop_3:                                     ; preds = %bb_2
  br label %loop_4

loop_4:                                           ; preds = %be_6, %prhdr_loop_3
  %loop_cnt_i32_11 = phi i32 [ 7850, %prhdr_loop_3 ], [ %val_i32_24, %be_6 ]
  %val_i32_24 = add i32 %loop_cnt_i32_11, 1
  br i1 %val_i1_22, label %be_6, label %loop_exit_7

bb_5:                                             ; preds = %loop_exit_7
  %val_i32_40 = mul i32 %val_i32_9, %val_i32_24.lcssa
  br label %bb_2

be_6:                                             ; preds = %loop_4
  br i1 %val_i1_22, label %loop_4, label %loop_exit_7

loop_exit_7:                                      ; preds = %be_6, %loop_4
  %val_i32_24.lcssa = phi i32 [ %val_i32_24, %be_6 ], [ %val_i32_24, %loop_4 ]
  br label %bb_5
}