; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=msan < %s | FileCheck %s

target triple = "x86_64-unknown-linux-gnu"

define void @test_memcpy(ptr %p, ptr byval(i32) %p2) sanitize_memory {
; CHECK-LABEL: @test_memcpy(
; CHECK-NEXT:    [[TMP1:%.*]] = ptrtoint ptr [[P2:%.*]] to i64
; CHECK-NEXT:    [[TMP2:%.*]] = xor i64 [[TMP1]], 87960930222080
; CHECK-NEXT:    [[TMP3:%.*]] = inttoptr i64 [[TMP2]] to ptr
; CHECK-NEXT:    call void @llvm.memcpy.p0.p0.i64(ptr align 4 [[TMP3]], ptr align 4 inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 8) to ptr), i64 4, i1 false)
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    [[TMP4:%.*]] = call ptr @__msan_memcpy(ptr [[P:%.*]], ptr [[P2]], i64 4)
; CHECK-NEXT:    ret void
;
  call void @llvm.memcpy.p0.p0.i64(ptr %p, ptr %p2, i64 4, i1 false)
  ret void
}

define void @test_memmove(ptr %p, ptr byval(i32) %p2) sanitize_memory {
; CHECK-LABEL: @test_memmove(
; CHECK-NEXT:    [[TMP1:%.*]] = ptrtoint ptr [[P2:%.*]] to i64
; CHECK-NEXT:    [[TMP2:%.*]] = xor i64 [[TMP1]], 87960930222080
; CHECK-NEXT:    [[TMP3:%.*]] = inttoptr i64 [[TMP2]] to ptr
; CHECK-NEXT:    call void @llvm.memcpy.p0.p0.i64(ptr align 4 [[TMP3]], ptr align 4 inttoptr (i64 add (i64 ptrtoint (ptr @__msan_param_tls to i64), i64 8) to ptr), i64 4, i1 false)
; CHECK-NEXT:    call void @llvm.donothing()
; CHECK-NEXT:    [[TMP4:%.*]] = call ptr @__msan_memmove(ptr [[P:%.*]], ptr [[P2]], i64 4)
; CHECK-NEXT:    ret void
;
  call void @llvm.memmove.p0.p0.i64(ptr %p, ptr %p2, i64 4, i1 false)
  ret void
}

declare void @llvm.memcpy.p0.p0.i64(ptr, ptr, i64, i1)
declare void @llvm.memmove.p0.p0.i64(ptr, ptr, i64, i1)
