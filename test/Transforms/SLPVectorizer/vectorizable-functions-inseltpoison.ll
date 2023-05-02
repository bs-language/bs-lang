; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=slp-vectorizer -S %s | FileCheck %s

declare float @memread(float) readonly nounwind willreturn #0
declare <4 x float> @vmemread(<4 x float>)

define <4 x float> @memread_4x(ptr %a) {
; CHECK-LABEL: @memread_4x(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <4 x float>, ptr [[A:%.*]], align 16
; CHECK-NEXT:    [[TMP1:%.*]] = call fast <4 x float> @vmemread(<4 x float> [[TMP0]])
; CHECK-NEXT:    ret <4 x float> [[TMP1]]
;
entry:
  %0 = load <4 x float>, ptr %a, align 16
  %vecext = extractelement <4 x float> %0, i32 0
  %1 = tail call fast float @memread(float %vecext) #0
  %vecins = insertelement <4 x float> poison, float %1, i32 0
  %vecext.1 = extractelement <4 x float> %0, i32 1
  %2 = tail call fast float @memread(float %vecext.1) #0
  %vecins.1 = insertelement <4 x float> %vecins, float %2, i32 1
  %vecext.2 = extractelement <4 x float> %0, i32 2
  %3 = tail call fast float @memread(float %vecext.2) #0
  %vecins.2 = insertelement <4 x float> %vecins.1, float %3, i32 2
  %vecext.3 = extractelement <4 x float> %0, i32 3
  %4 = tail call fast float @memread(float %vecext.3) #0
  %vecins.3 = insertelement <4 x float> %vecins.2, float %4, i32 3
  ret <4 x float> %vecins.3
}

declare float @memwrite(float) nounwind willreturn #1
declare <4 x float> @vmemwrite(<4 x float>)

define <4 x float> @memwrite_4x(ptr %a) {
; CHECK-LABEL: @memwrite_4x(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <4 x float>, ptr [[A:%.*]], align 16
; CHECK-NEXT:    [[VECEXT:%.*]] = extractelement <4 x float> [[TMP0]], i32 0
; CHECK-NEXT:    [[TMP1:%.*]] = tail call fast float @memwrite(float [[VECEXT]]) #[[ATTR2:[0-9]+]]
; CHECK-NEXT:    [[VECINS:%.*]] = insertelement <4 x float> poison, float [[TMP1]], i32 0
; CHECK-NEXT:    [[VECEXT_1:%.*]] = extractelement <4 x float> [[TMP0]], i32 1
; CHECK-NEXT:    [[TMP2:%.*]] = tail call fast float @memwrite(float [[VECEXT_1]]) #[[ATTR2]]
; CHECK-NEXT:    [[VECINS_1:%.*]] = insertelement <4 x float> [[VECINS]], float [[TMP2]], i32 1
; CHECK-NEXT:    [[VECEXT_2:%.*]] = extractelement <4 x float> [[TMP0]], i32 2
; CHECK-NEXT:    [[TMP3:%.*]] = tail call fast float @memwrite(float [[VECEXT_2]]) #[[ATTR2]]
; CHECK-NEXT:    [[VECINS_2:%.*]] = insertelement <4 x float> [[VECINS_1]], float [[TMP3]], i32 2
; CHECK-NEXT:    [[VECEXT_3:%.*]] = extractelement <4 x float> [[TMP0]], i32 3
; CHECK-NEXT:    [[TMP4:%.*]] = tail call fast float @memwrite(float [[VECEXT_3]]) #[[ATTR2]]
; CHECK-NEXT:    [[VECINS_3:%.*]] = insertelement <4 x float> [[VECINS_2]], float [[TMP4]], i32 3
; CHECK-NEXT:    ret <4 x float> [[VECINS_3]]
;
entry:
  %0 = load <4 x float>, ptr %a, align 16
  %vecext = extractelement <4 x float> %0, i32 0
  %1 = tail call fast float @memwrite(float %vecext) #1
  %vecins = insertelement <4 x float> poison, float %1, i32 0
  %vecext.1 = extractelement <4 x float> %0, i32 1
  %2 = tail call fast float @memwrite(float %vecext.1) #1
  %vecins.1 = insertelement <4 x float> %vecins, float %2, i32 1
  %vecext.2 = extractelement <4 x float> %0, i32 2
  %3 = tail call fast float @memwrite(float %vecext.2) #1
  %vecins.2 = insertelement <4 x float> %vecins.1, float %3, i32 2
  %vecext.3 = extractelement <4 x float> %0, i32 3
  %4 = tail call fast float @memwrite(float %vecext.3) #1
  %vecins.3 = insertelement <4 x float> %vecins.2, float %4, i32 3
  ret <4 x float> %vecins.3
}

attributes #0 = { "vector-function-abi-variant"="_ZGV_LLVM_N4v_memread(vmemread)" }
attributes #1 = { "vector-function-abi-variant"="_ZGV_LLVM_N4v_memwrite(vmemwrite)" }
