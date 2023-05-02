; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=armv7-none-eabi | FileCheck %s

; PR7158
define i32 @test_pr7158() nounwind {
; CHECK-LABEL: test_pr7158:
; CHECK:       @ %bb.0: @ %bb.nph55.bb.nph55.split_crit_edge
; CHECK-NEXT:  .LBB0_1: @ %bb.i19
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    b .LBB0_1
bb.nph55.bb.nph55.split_crit_edge:
  br label %bb3

bb3:                                              ; preds = %bb3, %bb.nph55.bb.nph55.split_crit_edge
  br i1 undef, label %bb.i19, label %bb3

bb.i19:                                           ; preds = %bb.i19, %bb3
  %0 = insertelement <4 x float> undef, float undef, i32 3 ; <<4 x float>> [#uses=3]
  %1 = fmul <4 x float> %0, %0                    ; <<4 x float>> [#uses=1]
  %2 = bitcast <4 x float> %1 to <2 x double>     ; <<2 x double>> [#uses=0]
  %3 = fmul <4 x float> %0, undef                 ; <<4 x float>> [#uses=0]
  br label %bb.i19
}

; Check that the DAG combiner does not arbitrarily modify BUILD_VECTORs
; after legalization.
define void @test_illegal_build_vector() nounwind {
; CHECK-LABEL: test_illegal_build_vector:
; CHECK:       @ %bb.0: @ %entry
entry:
  store <2 x i64> undef, ptr undef, align 16
  %0 = load <16 x i8>, ptr undef, align 16            ; <<16 x i8>> [#uses=1]
  %1 = or <16 x i8> zeroinitializer, %0           ; <<16 x i8>> [#uses=1]
  store <16 x i8> %1, ptr undef, align 16
  ret void
}

; PR22678
; Check CONCAT_VECTORS DAG combiner pass doesn't introduce illegal types.
define void @test_pr22678() {
; CHECK-LABEL: test_pr22678:
; CHECK:       @ %bb.0:
  %1 = fptoui <16 x float> undef to <16 x i8>
  store <16 x i8> %1, ptr undef
  ret void
}

; Radar 8407927: Make sure that VMOVRRD gets optimized away when the result is
; converted back to be used as a vector type.
define <4 x i32> @test_vmovrrd_combine() nounwind {
; CHECK-LABEL: test_vmovrrd_combine:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    mov r0, #0
; CHECK-NEXT:    cmp r0, #0
; CHECK-NEXT:    @ implicit-def: $q8
; CHECK-NEXT:    bne .LBB3_2
; CHECK-NEXT:  @ %bb.1: @ %bb1.preheader
; CHECK-NEXT:    vmov.i32 q8, #0x0
; CHECK-NEXT:  .LBB3_2: @ %bb2
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    vmov r2, r3, d17
; CHECK-NEXT:    bx lr
entry:
  br i1 undef, label %bb1, label %bb2

bb1:
  %0 = bitcast <2 x i64> zeroinitializer to <2 x double>
  %1 = extractelement <2 x double> %0, i32 0
  %2 = bitcast double %1 to i64
  %3 = insertelement <1 x i64> undef, i64 %2, i32 0
  %4 = shufflevector <1 x i64> %3, <1 x i64> undef, <2 x i32> <i32 0, i32 1>
  %tmp2006.3 = bitcast <2 x i64> %4 to <16 x i8>
  %5 = shufflevector <16 x i8> %tmp2006.3, <16 x i8> undef, <16 x i32> <i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19>
  %tmp2004.3 = bitcast <16 x i8> %5 to <4 x i32>
  br i1 undef, label %bb2, label %bb1

bb2:
  %result = phi <4 x i32> [ undef, %entry ], [ %tmp2004.3, %bb1 ]
  ret <4 x i32> %result
}

; Test trying to do a ShiftCombine on illegal types.
; The vector should be split first.
define void @lshrIllegalType(ptr %A) nounwind {
; CHECK-LABEL: lshrIllegalType:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r0:128]
; CHECK-NEXT:    vshr.u32 q8, q8, #3
; CHECK-NEXT:    vst1.32 {d16, d17}, [r0:128]!
; CHECK-NEXT:    vld1.64 {d16, d17}, [r0:128]
; CHECK-NEXT:    vshr.u32 q8, q8, #3
; CHECK-NEXT:    vst1.64 {d16, d17}, [r0:128]
; CHECK-NEXT:    bx lr
       %tmp1 = load <8 x i32>, ptr %A
       %tmp2 = lshr <8 x i32> %tmp1, < i32 3, i32 3, i32 3, i32 3, i32 3, i32 3, i32 3, i32 3>
       store <8 x i32> %tmp2, ptr %A
       ret void
}

; Test folding a binary vector operation with constant BUILD_VECTOR
; operands with i16 elements.
define void @test_i16_constant_fold() nounwind optsize {
; CHECK-LABEL: test_i16_constant_fold:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.i8 d16, #0x1
; CHECK-NEXT:    vst1.8 {d16}, [r0]
; CHECK-NEXT:    bx lr
entry:
  %0 = sext <4 x i1> zeroinitializer to <4 x i16>
  %1 = add <4 x i16> %0, zeroinitializer
  %2 = shufflevector <4 x i16> %1, <4 x i16> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %3 = add <8 x i16> %2, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %4 = trunc <8 x i16> %3 to <8 x i8>
  tail call void @llvm.arm.neon.vst1.p0.v8i8(ptr undef, <8 x i8> %4, i32 1)
  ret void
}

declare void @llvm.arm.neon.vst1.p0.v8i8(ptr, <8 x i8>, i32) nounwind

; Test that loads and stores of i64 vector elements are handled as f64 values
; so they are not split up into i32 values.  Radar 8755338.
define void @i64_buildvector(ptr %ptr, ptr %vp) nounwind {
; CHECK-LABEL: i64_buildvector:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r0]
; CHECK-NEXT:    vst1.64 {d16, d17}, [r1]
; CHECK-NEXT:    bx lr
  %t0 = load i64, ptr %ptr, align 4
  %t1 = insertelement <2 x i64> undef, i64 %t0, i32 0
  store <2 x i64> %t1, ptr %vp
  ret void
}

define void @i64_insertelement(ptr %ptr, ptr %vp) nounwind {
; CHECK-LABEL: i64_insertelement:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r1]
; CHECK-NEXT:    vldr d16, [r0]
; CHECK-NEXT:    vst1.64 {d16, d17}, [r1]
; CHECK-NEXT:    bx lr
  %t0 = load i64, ptr %ptr, align 4
  %vec = load <2 x i64>, ptr %vp
  %t1 = insertelement <2 x i64> %vec, i64 %t0, i32 0
  store <2 x i64> %t1, ptr %vp
  ret void
}

define void @i64_extractelement(ptr %ptr, ptr %vp) nounwind {
; CHECK-LABEL: i64_extractelement:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldr d16, [r1]
; CHECK-NEXT:    vstr d16, [r0]
; CHECK-NEXT:    bx lr
  %vec = load <2 x i64>, ptr %vp
  %t1 = extractelement <2 x i64> %vec, i32 0
  store i64 %t1, ptr %ptr
  ret void
}

; Test trying to do a AND Combine on illegal types.
define void @andVec(ptr %A) nounwind {
; CHECK-LABEL: andVec:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    .pad #8
; CHECK-NEXT:    sub sp, sp, #8
; CHECK-NEXT:    ldr r1, [r0]
; CHECK-NEXT:    vmov.i16 d17, #0x7
; CHECK-NEXT:    str r1, [sp, #4]
; CHECK-NEXT:    add r1, sp, #4
; CHECK-NEXT:    vld1.32 {d16[0]}, [r1:32]
; CHECK-NEXT:    mov r1, sp
; CHECK-NEXT:    vmovl.u8 q9, d16
; CHECK-NEXT:    vand d16, d18, d17
; CHECK-NEXT:    vorr d17, d16, d16
; CHECK-NEXT:    vuzp.8 d17, d18
; CHECK-NEXT:    vst1.32 {d17[0]}, [r1:32]
; CHECK-NEXT:    vld1.32 {d17[0]}, [r1:32]
; CHECK-NEXT:    vmov.u16 r1, d16[2]
; CHECK-NEXT:    vmovl.u16 q8, d17
; CHECK-NEXT:    vmov.32 r2, d16[0]
; CHECK-NEXT:    strb r1, [r0, #2]
; CHECK-NEXT:    strh r2, [r0]
; CHECK-NEXT:    add sp, sp, #8
; CHECK-NEXT:    bx lr
  %tmp = load <3 x i8>, ptr %A, align 4
  %and = and <3 x i8> %tmp, <i8 7, i8 7, i8 7>
  store <3 x i8> %and, ptr %A
  ret void
}


; Test trying to do an OR Combine on illegal types.
define void @orVec(ptr %A) nounwind {
; CHECK-LABEL: orVec:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    .pad #8
; CHECK-NEXT:    sub sp, sp, #8
; CHECK-NEXT:    ldr r1, [r0]
; CHECK-NEXT:    str r1, [sp, #4]
; CHECK-NEXT:    add r1, sp, #4
; CHECK-NEXT:    vld1.32 {d16[0]}, [r1:32]
; CHECK-NEXT:    mov r1, sp
; CHECK-NEXT:    vmovl.u8 q8, d16
; CHECK-NEXT:    vorr.i16 d16, #0x7
; CHECK-NEXT:    vorr d18, d16, d16
; CHECK-NEXT:    vuzp.8 d18, d19
; CHECK-NEXT:    vst1.32 {d18[0]}, [r1:32]
; CHECK-NEXT:    vld1.32 {d18[0]}, [r1:32]
; CHECK-NEXT:    vmov.u16 r1, d16[2]
; CHECK-NEXT:    vmovl.u16 q8, d18
; CHECK-NEXT:    vmov.32 r2, d16[0]
; CHECK-NEXT:    strb r1, [r0, #2]
; CHECK-NEXT:    strh r2, [r0]
; CHECK-NEXT:    add sp, sp, #8
; CHECK-NEXT:    bx lr
  %tmp = load <3 x i8>, ptr %A, align 4
  %or = or <3 x i8> %tmp, <i8 7, i8 7, i8 7>
  store <3 x i8> %or, ptr %A
  ret void
}

; The following test was hitting an assertion in the DAG combiner when
; constant folding the multiply because the "sext undef" was translated to
; a BUILD_VECTOR with i32 0 operands, which did not match the i16 operands
; of the other BUILD_VECTOR.
define i16 @foldBuildVectors() {
; CHECK-LABEL: foldBuildVectors:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    mov r0, #0
; CHECK-NEXT:    bx lr
  %1 = sext <8 x i8> undef to <8 x i16>
  %2 = mul <8 x i16> %1, <i16 255, i16 255, i16 255, i16 255, i16 255, i16 255, i16 255, i16 255>
  %3 = extractelement <8 x i16> %2, i32 0
  ret i16 %3
}

; Test that we are generating vrev and vext for reverse shuffles of v8i16
; shuffles.
define void @reverse_v8i16(ptr %loadaddr, ptr %storeaddr) {
; CHECK-LABEL: reverse_v8i16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r0]
; CHECK-NEXT:    vrev64.16 q8, q8
; CHECK-NEXT:    vext.16 q8, q8, q8, #4
; CHECK-NEXT:    vst1.64 {d16, d17}, [r1]
; CHECK-NEXT:    bx lr
  %v0 = load <8 x i16>, ptr %loadaddr
  %v1 = shufflevector <8 x i16> %v0, <8 x i16> undef,
              <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  store <8 x i16> %v1, ptr %storeaddr
  ret void
}

; Test that we are generating vrev and vext for reverse shuffles of v16i8
; shuffles.
define void @reverse_v16i8(ptr %loadaddr, ptr %storeaddr) {
; CHECK-LABEL: reverse_v16i8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vld1.64 {d16, d17}, [r0]
; CHECK-NEXT:    vrev64.8 q8, q8
; CHECK-NEXT:    vext.8 q8, q8, q8, #8
; CHECK-NEXT:    vst1.64 {d16, d17}, [r1]
; CHECK-NEXT:    bx lr
  %v0 = load <16 x i8>, ptr %loadaddr
  %v1 = shufflevector <16 x i8> %v0, <16 x i8> undef,
       <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8,
                   i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  store <16 x i8> %v1, ptr %storeaddr
  ret void
}

; <rdar://problem/14170854>.
; vldr cannot handle unaligned loads.
; Fall back to vld1.32, which can, instead of using the general purpose loads
; followed by a costly sequence of instructions to build the vector register.
define <8 x i16> @t3(i8 zeroext %xf, ptr nocapture %sp0, ptr nocapture %sp1, ptr nocapture %outp) {
; CHECK-LABEL: t3:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vld1.32 {d16[0]}, [r1]
; CHECK-NEXT:    vld1.32 {d16[1]}, [r2]
; CHECK-NEXT:    vmull.u8 q8, d16, d16
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    vmov r2, r3, d17
; CHECK-NEXT:    bx lr
entry:
  %pix_sp0.0.copyload = load i32, ptr %sp0, align 1
  %pix_sp1.0.copyload = load i32, ptr %sp1, align 1
  %vecinit = insertelement <2 x i32> undef, i32 %pix_sp0.0.copyload, i32 0
  %vecinit1 = insertelement <2 x i32> %vecinit, i32 %pix_sp1.0.copyload, i32 1
  %0 = bitcast <2 x i32> %vecinit1 to <8 x i8>
  %vmull.i = tail call <8 x i16> @llvm.arm.neon.vmullu.v8i16(<8 x i8> %0, <8 x i8> %0)
  ret <8 x i16> %vmull.i
}

; Function Attrs: nounwind readnone
declare <8 x i16> @llvm.arm.neon.vmullu.v8i16(<8 x i8>, <8 x i8>)

; Check that (insert_vector_elt (load)) => (vector_load).
; Thus, check that scalar_to_vector do not interfer with that.
define <8 x i16> @t4(ptr nocapture %sp0) {
; CHECK-LABEL: t4:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vld1.32 {d16[0]}, [r0]
; CHECK-NEXT:    vmull.u8 q8, d16, d16
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    vmov r2, r3, d17
; CHECK-NEXT:    bx lr
entry:
  %pix_sp0.0.copyload = load i32, ptr %sp0, align 1
  %vec = insertelement <2 x i32> undef, i32 %pix_sp0.0.copyload, i32 0
  %0 = bitcast <2 x i32> %vec to <8 x i8>
  %vmull.i = tail call <8 x i16> @llvm.arm.neon.vmullu.v8i16(<8 x i8> %0, <8 x i8> %0)
  ret <8 x i16> %vmull.i
}

; Make sure vector load is used for all three loads.
; Lowering to build vector was breaking the single use property of the load of
;  %pix_sp0.0.copyload.
define <8 x i16> @t5(ptr nocapture %sp0, ptr nocapture %sp1, ptr nocapture %sp2) {
; CHECK-LABEL: t5:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vld1.32 {d16[1]}, [r0]
; CHECK-NEXT:    vorr d17, d16, d16
; CHECK-NEXT:    vld1.32 {d16[0]}, [r1]
; CHECK-NEXT:    vld1.32 {d17[0]}, [r2]
; CHECK-NEXT:    vmull.u8 q8, d16, d17
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    vmov r2, r3, d17
; CHECK-NEXT:    bx lr
entry:
  %pix_sp0.0.copyload = load i32, ptr %sp0, align 1
  %pix_sp1.0.copyload = load i32, ptr %sp1, align 1
  %pix_sp2.0.copyload = load i32, ptr %sp2, align 1
  %vec = insertelement <2 x i32> undef, i32 %pix_sp0.0.copyload, i32 1
  %vecinit1 = insertelement <2 x i32> %vec, i32 %pix_sp1.0.copyload, i32 0
  %vecinit2 = insertelement <2 x i32> %vec, i32 %pix_sp2.0.copyload, i32 0
  %0 = bitcast <2 x i32> %vecinit1 to <8 x i8>
  %1 = bitcast <2 x i32> %vecinit2 to <8 x i8>
  %vmull.i = tail call <8 x i16> @llvm.arm.neon.vmullu.v8i16(<8 x i8> %0, <8 x i8> %1)
  ret <8 x i16> %vmull.i
}

; <rdar://problem/14989896> Make sure we manage to truncate a vector from an
; illegal type to a legal type.
define <2 x i8> @test_truncate(<2 x i128> %in) {
; CHECK-LABEL: test_truncate:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov.32 d16[0], r0
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vld1.32 {d16[1]}, [r0:32]
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    bx lr
entry:
  %res = trunc <2 x i128> %in to <2 x i8>
  ret <2 x i8> %res
}
