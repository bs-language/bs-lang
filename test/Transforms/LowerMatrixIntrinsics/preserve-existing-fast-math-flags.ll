; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -matrix-allow-contract=false -passes=lower-matrix-intrinsics -S < %s | FileCheck %s

define <4 x float> @preserve_fmf_fast(<4 x float> %m, <4 x float> %n) {
; CHECK-LABEL: @preserve_fmf_fast(
; CHECK-NEXT:    [[SPLIT:%.*]] = shufflevector <4 x float> [[M:%.*]], <4 x float> poison, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[SPLIT1:%.*]] = shufflevector <4 x float> [[M]], <4 x float> poison, <2 x i32> <i32 2, i32 3>
; CHECK-NEXT:    [[SPLIT2:%.*]] = shufflevector <4 x float> [[N:%.*]], <4 x float> poison, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[SPLIT3:%.*]] = shufflevector <4 x float> [[N]], <4 x float> poison, <2 x i32> <i32 2, i32 3>
; CHECK-NEXT:    [[BLOCK:%.*]] = shufflevector <2 x float> [[SPLIT]], <2 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP1:%.*]] = extractelement <2 x float> [[SPLIT2]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT:%.*]] = insertelement <1 x float> poison, float [[TMP1]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLAT:%.*]] = shufflevector <1 x float> [[SPLAT_SPLATINSERT]], <1 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP2:%.*]] = fmul fast <1 x float> [[BLOCK]], [[SPLAT_SPLAT]]
; CHECK-NEXT:    [[BLOCK4:%.*]] = shufflevector <2 x float> [[SPLIT1]], <2 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP3:%.*]] = extractelement <2 x float> [[SPLIT2]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT5:%.*]] = insertelement <1 x float> poison, float [[TMP3]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLAT6:%.*]] = shufflevector <1 x float> [[SPLAT_SPLATINSERT5]], <1 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP4:%.*]] = call fast <1 x float> @llvm.fmuladd.v1f32(<1 x float> [[BLOCK4]], <1 x float> [[SPLAT_SPLAT6]], <1 x float> [[TMP2]])
; CHECK-NEXT:    [[TMP5:%.*]] = shufflevector <1 x float> [[TMP4]], <1 x float> poison, <2 x i32> <i32 0, i32 undef>
; CHECK-NEXT:    [[TMP6:%.*]] = shufflevector <2 x float> undef, <2 x float> [[TMP5]], <2 x i32> <i32 2, i32 1>
; CHECK-NEXT:    [[BLOCK7:%.*]] = shufflevector <2 x float> [[SPLIT]], <2 x float> poison, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP7:%.*]] = extractelement <2 x float> [[SPLIT2]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT8:%.*]] = insertelement <1 x float> poison, float [[TMP7]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLAT9:%.*]] = shufflevector <1 x float> [[SPLAT_SPLATINSERT8]], <1 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP8:%.*]] = fmul fast <1 x float> [[BLOCK7]], [[SPLAT_SPLAT9]]
; CHECK-NEXT:    [[BLOCK10:%.*]] = shufflevector <2 x float> [[SPLIT1]], <2 x float> poison, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP9:%.*]] = extractelement <2 x float> [[SPLIT2]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT11:%.*]] = insertelement <1 x float> poison, float [[TMP9]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLAT12:%.*]] = shufflevector <1 x float> [[SPLAT_SPLATINSERT11]], <1 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP10:%.*]] = call fast <1 x float> @llvm.fmuladd.v1f32(<1 x float> [[BLOCK10]], <1 x float> [[SPLAT_SPLAT12]], <1 x float> [[TMP8]])
; CHECK-NEXT:    [[TMP11:%.*]] = shufflevector <1 x float> [[TMP10]], <1 x float> poison, <2 x i32> <i32 0, i32 undef>
; CHECK-NEXT:    [[TMP12:%.*]] = shufflevector <2 x float> [[TMP6]], <2 x float> [[TMP11]], <2 x i32> <i32 0, i32 2>
; CHECK-NEXT:    [[BLOCK13:%.*]] = shufflevector <2 x float> [[SPLIT]], <2 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP13:%.*]] = extractelement <2 x float> [[SPLIT3]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT14:%.*]] = insertelement <1 x float> poison, float [[TMP13]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLAT15:%.*]] = shufflevector <1 x float> [[SPLAT_SPLATINSERT14]], <1 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP14:%.*]] = fmul fast <1 x float> [[BLOCK13]], [[SPLAT_SPLAT15]]
; CHECK-NEXT:    [[BLOCK16:%.*]] = shufflevector <2 x float> [[SPLIT1]], <2 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP15:%.*]] = extractelement <2 x float> [[SPLIT3]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT17:%.*]] = insertelement <1 x float> poison, float [[TMP15]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLAT18:%.*]] = shufflevector <1 x float> [[SPLAT_SPLATINSERT17]], <1 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP16:%.*]] = call fast <1 x float> @llvm.fmuladd.v1f32(<1 x float> [[BLOCK16]], <1 x float> [[SPLAT_SPLAT18]], <1 x float> [[TMP14]])
; CHECK-NEXT:    [[TMP17:%.*]] = shufflevector <1 x float> [[TMP16]], <1 x float> poison, <2 x i32> <i32 0, i32 undef>
; CHECK-NEXT:    [[TMP18:%.*]] = shufflevector <2 x float> undef, <2 x float> [[TMP17]], <2 x i32> <i32 2, i32 1>
; CHECK-NEXT:    [[BLOCK19:%.*]] = shufflevector <2 x float> [[SPLIT]], <2 x float> poison, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP19:%.*]] = extractelement <2 x float> [[SPLIT3]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT20:%.*]] = insertelement <1 x float> poison, float [[TMP19]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLAT21:%.*]] = shufflevector <1 x float> [[SPLAT_SPLATINSERT20]], <1 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP20:%.*]] = fmul fast <1 x float> [[BLOCK19]], [[SPLAT_SPLAT21]]
; CHECK-NEXT:    [[BLOCK22:%.*]] = shufflevector <2 x float> [[SPLIT1]], <2 x float> poison, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP21:%.*]] = extractelement <2 x float> [[SPLIT3]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT23:%.*]] = insertelement <1 x float> poison, float [[TMP21]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLAT24:%.*]] = shufflevector <1 x float> [[SPLAT_SPLATINSERT23]], <1 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP22:%.*]] = call fast <1 x float> @llvm.fmuladd.v1f32(<1 x float> [[BLOCK22]], <1 x float> [[SPLAT_SPLAT24]], <1 x float> [[TMP20]])
; CHECK-NEXT:    [[TMP23:%.*]] = shufflevector <1 x float> [[TMP22]], <1 x float> poison, <2 x i32> <i32 0, i32 undef>
; CHECK-NEXT:    [[TMP24:%.*]] = shufflevector <2 x float> [[TMP18]], <2 x float> [[TMP23]], <2 x i32> <i32 0, i32 2>
; CHECK-NEXT:    [[SPLIT25:%.*]] = shufflevector <4 x float> [[N]], <4 x float> poison, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[SPLIT26:%.*]] = shufflevector <4 x float> [[N]], <4 x float> poison, <2 x i32> <i32 2, i32 3>
; CHECK-NEXT:    [[TMP25:%.*]] = fadd fast <2 x float> [[TMP12]], [[SPLIT25]]
; CHECK-NEXT:    [[TMP26:%.*]] = fadd fast <2 x float> [[TMP24]], [[SPLIT26]]
; CHECK-NEXT:    [[TMP27:%.*]] = shufflevector <2 x float> [[TMP25]], <2 x float> [[TMP26]], <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:    ret <4 x float> [[TMP27]]
;
  %res.0 = tail call fast <4 x float> @llvm.matrix.multiply.v4f32.v4f32.v4f32(<4 x float> %m, <4 x float> %n, i32 2, i32 2, i32 2)
  %res.1 = fadd fast <4 x float> %res.0, %n
  ret <4 x float> %res.1
}

define <4 x float> @preserve_fmf_reassoc(<4 x float> %m, <4 x float> %n) {
; CHECK-LABEL: @preserve_fmf_reassoc(
; CHECK-NEXT:    [[SPLIT:%.*]] = shufflevector <4 x float> [[M:%.*]], <4 x float> poison, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[SPLIT1:%.*]] = shufflevector <4 x float> [[M]], <4 x float> poison, <2 x i32> <i32 2, i32 3>
; CHECK-NEXT:    [[SPLIT2:%.*]] = shufflevector <4 x float> [[N:%.*]], <4 x float> poison, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[SPLIT3:%.*]] = shufflevector <4 x float> [[N]], <4 x float> poison, <2 x i32> <i32 2, i32 3>
; CHECK-NEXT:    [[BLOCK:%.*]] = shufflevector <2 x float> [[SPLIT]], <2 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP1:%.*]] = extractelement <2 x float> [[SPLIT2]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT:%.*]] = insertelement <1 x float> poison, float [[TMP1]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLAT:%.*]] = shufflevector <1 x float> [[SPLAT_SPLATINSERT]], <1 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP2:%.*]] = fmul reassoc <1 x float> [[BLOCK]], [[SPLAT_SPLAT]]
; CHECK-NEXT:    [[BLOCK4:%.*]] = shufflevector <2 x float> [[SPLIT1]], <2 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP3:%.*]] = extractelement <2 x float> [[SPLIT2]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT5:%.*]] = insertelement <1 x float> poison, float [[TMP3]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLAT6:%.*]] = shufflevector <1 x float> [[SPLAT_SPLATINSERT5]], <1 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP4:%.*]] = fmul reassoc <1 x float> [[BLOCK4]], [[SPLAT_SPLAT6]]
; CHECK-NEXT:    [[TMP5:%.*]] = fadd reassoc <1 x float> [[TMP2]], [[TMP4]]
; CHECK-NEXT:    [[TMP6:%.*]] = shufflevector <1 x float> [[TMP5]], <1 x float> poison, <2 x i32> <i32 0, i32 undef>
; CHECK-NEXT:    [[TMP7:%.*]] = shufflevector <2 x float> undef, <2 x float> [[TMP6]], <2 x i32> <i32 2, i32 1>
; CHECK-NEXT:    [[BLOCK7:%.*]] = shufflevector <2 x float> [[SPLIT]], <2 x float> poison, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP8:%.*]] = extractelement <2 x float> [[SPLIT2]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT8:%.*]] = insertelement <1 x float> poison, float [[TMP8]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLAT9:%.*]] = shufflevector <1 x float> [[SPLAT_SPLATINSERT8]], <1 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP9:%.*]] = fmul reassoc <1 x float> [[BLOCK7]], [[SPLAT_SPLAT9]]
; CHECK-NEXT:    [[BLOCK10:%.*]] = shufflevector <2 x float> [[SPLIT1]], <2 x float> poison, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP10:%.*]] = extractelement <2 x float> [[SPLIT2]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT11:%.*]] = insertelement <1 x float> poison, float [[TMP10]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLAT12:%.*]] = shufflevector <1 x float> [[SPLAT_SPLATINSERT11]], <1 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP11:%.*]] = fmul reassoc <1 x float> [[BLOCK10]], [[SPLAT_SPLAT12]]
; CHECK-NEXT:    [[TMP12:%.*]] = fadd reassoc <1 x float> [[TMP9]], [[TMP11]]
; CHECK-NEXT:    [[TMP13:%.*]] = shufflevector <1 x float> [[TMP12]], <1 x float> poison, <2 x i32> <i32 0, i32 undef>
; CHECK-NEXT:    [[TMP14:%.*]] = shufflevector <2 x float> [[TMP7]], <2 x float> [[TMP13]], <2 x i32> <i32 0, i32 2>
; CHECK-NEXT:    [[BLOCK13:%.*]] = shufflevector <2 x float> [[SPLIT]], <2 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP15:%.*]] = extractelement <2 x float> [[SPLIT3]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT14:%.*]] = insertelement <1 x float> poison, float [[TMP15]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLAT15:%.*]] = shufflevector <1 x float> [[SPLAT_SPLATINSERT14]], <1 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP16:%.*]] = fmul reassoc <1 x float> [[BLOCK13]], [[SPLAT_SPLAT15]]
; CHECK-NEXT:    [[BLOCK16:%.*]] = shufflevector <2 x float> [[SPLIT1]], <2 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP17:%.*]] = extractelement <2 x float> [[SPLIT3]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT17:%.*]] = insertelement <1 x float> poison, float [[TMP17]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLAT18:%.*]] = shufflevector <1 x float> [[SPLAT_SPLATINSERT17]], <1 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP18:%.*]] = fmul reassoc <1 x float> [[BLOCK16]], [[SPLAT_SPLAT18]]
; CHECK-NEXT:    [[TMP19:%.*]] = fadd reassoc <1 x float> [[TMP16]], [[TMP18]]
; CHECK-NEXT:    [[TMP20:%.*]] = shufflevector <1 x float> [[TMP19]], <1 x float> poison, <2 x i32> <i32 0, i32 undef>
; CHECK-NEXT:    [[TMP21:%.*]] = shufflevector <2 x float> undef, <2 x float> [[TMP20]], <2 x i32> <i32 2, i32 1>
; CHECK-NEXT:    [[BLOCK19:%.*]] = shufflevector <2 x float> [[SPLIT]], <2 x float> poison, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP22:%.*]] = extractelement <2 x float> [[SPLIT3]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT20:%.*]] = insertelement <1 x float> poison, float [[TMP22]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLAT21:%.*]] = shufflevector <1 x float> [[SPLAT_SPLATINSERT20]], <1 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP23:%.*]] = fmul reassoc <1 x float> [[BLOCK19]], [[SPLAT_SPLAT21]]
; CHECK-NEXT:    [[BLOCK22:%.*]] = shufflevector <2 x float> [[SPLIT1]], <2 x float> poison, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP24:%.*]] = extractelement <2 x float> [[SPLIT3]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT23:%.*]] = insertelement <1 x float> poison, float [[TMP24]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLAT24:%.*]] = shufflevector <1 x float> [[SPLAT_SPLATINSERT23]], <1 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP25:%.*]] = fmul reassoc <1 x float> [[BLOCK22]], [[SPLAT_SPLAT24]]
; CHECK-NEXT:    [[TMP26:%.*]] = fadd reassoc <1 x float> [[TMP23]], [[TMP25]]
; CHECK-NEXT:    [[TMP27:%.*]] = shufflevector <1 x float> [[TMP26]], <1 x float> poison, <2 x i32> <i32 0, i32 undef>
; CHECK-NEXT:    [[TMP28:%.*]] = shufflevector <2 x float> [[TMP21]], <2 x float> [[TMP27]], <2 x i32> <i32 0, i32 2>
; CHECK-NEXT:    [[SPLIT25:%.*]] = shufflevector <4 x float> [[N]], <4 x float> poison, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[SPLIT26:%.*]] = shufflevector <4 x float> [[N]], <4 x float> poison, <2 x i32> <i32 2, i32 3>
; CHECK-NEXT:    [[TMP29:%.*]] = fsub reassoc <2 x float> [[TMP14]], [[SPLIT25]]
; CHECK-NEXT:    [[TMP30:%.*]] = fsub reassoc <2 x float> [[TMP28]], [[SPLIT26]]
; CHECK-NEXT:    [[TMP31:%.*]] = shufflevector <2 x float> [[TMP29]], <2 x float> [[TMP30]], <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:    ret <4 x float> [[TMP31]]
;
  %res.0 = tail call reassoc <4 x float> @llvm.matrix.multiply.v4f32.v4f32.v4f32(<4 x float> %m, <4 x float> %n, i32 2, i32 2, i32 2)
  %res.1 = fsub reassoc <4 x float> %res.0, %n
  ret <4 x float> %res.1
}

define <4 x float> @preserve_fmf_contract_reassoc(<4 x float> %m, <4 x float> %n) {
; CHECK-LABEL: @preserve_fmf_contract_reassoc(
; CHECK-NEXT:    [[SPLIT:%.*]] = shufflevector <4 x float> [[M:%.*]], <4 x float> poison, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[SPLIT1:%.*]] = shufflevector <4 x float> [[M]], <4 x float> poison, <2 x i32> <i32 2, i32 3>
; CHECK-NEXT:    [[SPLIT2:%.*]] = shufflevector <4 x float> [[N:%.*]], <4 x float> poison, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[SPLIT3:%.*]] = shufflevector <4 x float> [[N]], <4 x float> poison, <2 x i32> <i32 2, i32 3>
; CHECK-NEXT:    [[BLOCK:%.*]] = shufflevector <2 x float> [[SPLIT]], <2 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP1:%.*]] = extractelement <2 x float> [[SPLIT2]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT:%.*]] = insertelement <1 x float> poison, float [[TMP1]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLAT:%.*]] = shufflevector <1 x float> [[SPLAT_SPLATINSERT]], <1 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP2:%.*]] = fmul reassoc contract <1 x float> [[BLOCK]], [[SPLAT_SPLAT]]
; CHECK-NEXT:    [[BLOCK4:%.*]] = shufflevector <2 x float> [[SPLIT1]], <2 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP3:%.*]] = extractelement <2 x float> [[SPLIT2]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT5:%.*]] = insertelement <1 x float> poison, float [[TMP3]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLAT6:%.*]] = shufflevector <1 x float> [[SPLAT_SPLATINSERT5]], <1 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP4:%.*]] = call reassoc contract <1 x float> @llvm.fmuladd.v1f32(<1 x float> [[BLOCK4]], <1 x float> [[SPLAT_SPLAT6]], <1 x float> [[TMP2]])
; CHECK-NEXT:    [[TMP5:%.*]] = shufflevector <1 x float> [[TMP4]], <1 x float> poison, <2 x i32> <i32 0, i32 undef>
; CHECK-NEXT:    [[TMP6:%.*]] = shufflevector <2 x float> undef, <2 x float> [[TMP5]], <2 x i32> <i32 2, i32 1>
; CHECK-NEXT:    [[BLOCK7:%.*]] = shufflevector <2 x float> [[SPLIT]], <2 x float> poison, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP7:%.*]] = extractelement <2 x float> [[SPLIT2]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT8:%.*]] = insertelement <1 x float> poison, float [[TMP7]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLAT9:%.*]] = shufflevector <1 x float> [[SPLAT_SPLATINSERT8]], <1 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP8:%.*]] = fmul reassoc contract <1 x float> [[BLOCK7]], [[SPLAT_SPLAT9]]
; CHECK-NEXT:    [[BLOCK10:%.*]] = shufflevector <2 x float> [[SPLIT1]], <2 x float> poison, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP9:%.*]] = extractelement <2 x float> [[SPLIT2]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT11:%.*]] = insertelement <1 x float> poison, float [[TMP9]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLAT12:%.*]] = shufflevector <1 x float> [[SPLAT_SPLATINSERT11]], <1 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP10:%.*]] = call reassoc contract <1 x float> @llvm.fmuladd.v1f32(<1 x float> [[BLOCK10]], <1 x float> [[SPLAT_SPLAT12]], <1 x float> [[TMP8]])
; CHECK-NEXT:    [[TMP11:%.*]] = shufflevector <1 x float> [[TMP10]], <1 x float> poison, <2 x i32> <i32 0, i32 undef>
; CHECK-NEXT:    [[TMP12:%.*]] = shufflevector <2 x float> [[TMP6]], <2 x float> [[TMP11]], <2 x i32> <i32 0, i32 2>
; CHECK-NEXT:    [[BLOCK13:%.*]] = shufflevector <2 x float> [[SPLIT]], <2 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP13:%.*]] = extractelement <2 x float> [[SPLIT3]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT14:%.*]] = insertelement <1 x float> poison, float [[TMP13]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLAT15:%.*]] = shufflevector <1 x float> [[SPLAT_SPLATINSERT14]], <1 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP14:%.*]] = fmul reassoc contract <1 x float> [[BLOCK13]], [[SPLAT_SPLAT15]]
; CHECK-NEXT:    [[BLOCK16:%.*]] = shufflevector <2 x float> [[SPLIT1]], <2 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP15:%.*]] = extractelement <2 x float> [[SPLIT3]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT17:%.*]] = insertelement <1 x float> poison, float [[TMP15]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLAT18:%.*]] = shufflevector <1 x float> [[SPLAT_SPLATINSERT17]], <1 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP16:%.*]] = call reassoc contract <1 x float> @llvm.fmuladd.v1f32(<1 x float> [[BLOCK16]], <1 x float> [[SPLAT_SPLAT18]], <1 x float> [[TMP14]])
; CHECK-NEXT:    [[TMP17:%.*]] = shufflevector <1 x float> [[TMP16]], <1 x float> poison, <2 x i32> <i32 0, i32 undef>
; CHECK-NEXT:    [[TMP18:%.*]] = shufflevector <2 x float> undef, <2 x float> [[TMP17]], <2 x i32> <i32 2, i32 1>
; CHECK-NEXT:    [[BLOCK19:%.*]] = shufflevector <2 x float> [[SPLIT]], <2 x float> poison, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP19:%.*]] = extractelement <2 x float> [[SPLIT3]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLATINSERT20:%.*]] = insertelement <1 x float> poison, float [[TMP19]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLAT21:%.*]] = shufflevector <1 x float> [[SPLAT_SPLATINSERT20]], <1 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP20:%.*]] = fmul reassoc contract <1 x float> [[BLOCK19]], [[SPLAT_SPLAT21]]
; CHECK-NEXT:    [[BLOCK22:%.*]] = shufflevector <2 x float> [[SPLIT1]], <2 x float> poison, <1 x i32> <i32 1>
; CHECK-NEXT:    [[TMP21:%.*]] = extractelement <2 x float> [[SPLIT3]], i64 1
; CHECK-NEXT:    [[SPLAT_SPLATINSERT23:%.*]] = insertelement <1 x float> poison, float [[TMP21]], i64 0
; CHECK-NEXT:    [[SPLAT_SPLAT24:%.*]] = shufflevector <1 x float> [[SPLAT_SPLATINSERT23]], <1 x float> poison, <1 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP22:%.*]] = call reassoc contract <1 x float> @llvm.fmuladd.v1f32(<1 x float> [[BLOCK22]], <1 x float> [[SPLAT_SPLAT24]], <1 x float> [[TMP20]])
; CHECK-NEXT:    [[TMP23:%.*]] = shufflevector <1 x float> [[TMP22]], <1 x float> poison, <2 x i32> <i32 0, i32 undef>
; CHECK-NEXT:    [[TMP24:%.*]] = shufflevector <2 x float> [[TMP18]], <2 x float> [[TMP23]], <2 x i32> <i32 0, i32 2>
; CHECK-NEXT:    [[SPLIT25:%.*]] = shufflevector <4 x float> [[N]], <4 x float> poison, <2 x i32> <i32 0, i32 1>
; CHECK-NEXT:    [[SPLIT26:%.*]] = shufflevector <4 x float> [[N]], <4 x float> poison, <2 x i32> <i32 2, i32 3>
; CHECK-NEXT:    [[TMP25:%.*]] = fmul reassoc contract <2 x float> [[TMP12]], [[SPLIT25]]
; CHECK-NEXT:    [[TMP26:%.*]] = fmul reassoc contract <2 x float> [[TMP24]], [[SPLIT26]]
; CHECK-NEXT:    [[TMP27:%.*]] = fneg contract <2 x float> [[TMP25]]
; CHECK-NEXT:    [[TMP28:%.*]] = fneg contract <2 x float> [[TMP26]]
; CHECK-NEXT:    [[TMP29:%.*]] = shufflevector <2 x float> [[TMP27]], <2 x float> [[TMP28]], <4 x i32> <i32 0, i32 1, i32 2, i32 3>
; CHECK-NEXT:    ret <4 x float> [[TMP29]]
;
  %res.0 = tail call contract reassoc <4 x float> @llvm.matrix.multiply.v4f32.v4f32.v4f32(<4 x float> %m, <4 x float> %n, i32 2, i32 2, i32 2)
  %res.1 = fmul reassoc contract <4 x float> %res.0, %n
  %res.2 = fneg contract <4 x float> %res.1
  ret <4 x float> %res.2
}

declare <4 x float> @llvm.matrix.multiply.v4f32.v4f32.v4f32(<4 x float>, <4 x float>, i32, i32, i32)
