; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=slp-vectorizer,dce -slp-threshold=-100 -S -mtriple=i386-apple-macosx10.8.0 -mcpu=corei7-avx | FileCheck %s

target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:128:128-n8:16:32-S128"
target triple = "i386-apple-macosx10.9.0"

;int foo(ptr A, int k) {
;  double A0;
;  double A1;
;  if (k) {
;    A0 = 3;
;    A1 = 5;
;  } else {
;    A0 = A[10];
;    A1 = A[11];
;  }
;  A[0] = A0;
;  A[1] = A1;
;}


define i32 @foo(ptr nocapture %A, i32 %k) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i32 [[K:%.*]], 0
; CHECK-NEXT:    br i1 [[TOBOOL]], label [[IF_ELSE:%.*]], label [[IF_END:%.*]]
; CHECK:       if.else:
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds double, ptr [[A:%.*]], i64 10
; CHECK-NEXT:    [[TMP0:%.*]] = load <2 x double>, ptr [[ARRAYIDX]], align 8
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[TMP1:%.*]] = phi <2 x double> [ [[TMP0]], [[IF_ELSE]] ], [ <double 3.000000e+00, double 5.000000e+00>, [[ENTRY:%.*]] ]
; CHECK-NEXT:    store <2 x double> [[TMP1]], ptr [[A]], align 8
; CHECK-NEXT:    ret i32 undef
;
entry:
  %tobool = icmp eq i32 %k, 0
  br i1 %tobool, label %if.else, label %if.end

if.else:                                          ; preds = %entry
  %arrayidx = getelementptr inbounds double, ptr %A, i64 10
  %0 = load double, ptr %arrayidx, align 8
  %arrayidx1 = getelementptr inbounds double, ptr %A, i64 11
  %1 = load double, ptr %arrayidx1, align 8
  br label %if.end

if.end:                                           ; preds = %entry, %if.else
  %A0.0 = phi double [ %0, %if.else ], [ 3.000000e+00, %entry ]
  %A1.0 = phi double [ %1, %if.else ], [ 5.000000e+00, %entry ]
  store double %A0.0, ptr %A, align 8
  %arrayidx3 = getelementptr inbounds double, ptr %A, i64 1
  store double %A1.0, ptr %arrayidx3, align 8
  ret i32 undef
}


;int foo(ptr restrict B,  ptr restrict A, int n, int m) {
;  double R=A[1];
;  double G=A[0];
;  for (int i=0; i < 100; i++) {
;    R += 10;
;    G += 10;
;    R *= 4;
;    G *= 4;
;    R += 4;
;    G += 4;
;  }
;  B[0] = G;
;  B[1] = R;
;  return 0;
;}

define i32 @foo2(ptr noalias nocapture %B, ptr noalias nocapture %A, i32 %n, i32 %m) #0 {
; CHECK-LABEL: @foo2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load <2 x double>, ptr [[A:%.*]], align 8
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_019:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[INC:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[TMP1:%.*]] = phi <2 x double> [ [[TMP0]], [[ENTRY]] ], [ [[TMP4:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = fadd <2 x double> [[TMP1]], <double 1.000000e+01, double 1.000000e+01>
; CHECK-NEXT:    [[TMP3:%.*]] = fmul <2 x double> [[TMP2]], <double 4.000000e+00, double 4.000000e+00>
; CHECK-NEXT:    [[TMP4]] = fadd <2 x double> [[TMP3]], <double 4.000000e+00, double 4.000000e+00>
; CHECK-NEXT:    [[INC]] = add nsw i32 [[I_019]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i32 [[INC]], 100
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_END:%.*]], label [[FOR_BODY]]
; CHECK:       for.end:
; CHECK-NEXT:    store <2 x double> [[TMP4]], ptr [[B:%.*]], align 8
; CHECK-NEXT:    ret i32 0
;
entry:
  %arrayidx = getelementptr inbounds double, ptr %A, i64 1
  %0 = load double, ptr %arrayidx, align 8
  %1 = load double, ptr %A, align 8
  br label %for.body

for.body:                                         ; preds = %for.body, %entry
  %i.019 = phi i32 [ 0, %entry ], [ %inc, %for.body ]
  %G.018 = phi double [ %1, %entry ], [ %add5, %for.body ]
  %R.017 = phi double [ %0, %entry ], [ %add4, %for.body ]
  %add = fadd double %R.017, 1.000000e+01
  %add2 = fadd double %G.018, 1.000000e+01
  %mul = fmul double %add, 4.000000e+00
  %mul3 = fmul double %add2, 4.000000e+00
  %add4 = fadd double %mul, 4.000000e+00
  %add5 = fadd double %mul3, 4.000000e+00
  %inc = add nsw i32 %i.019, 1
  %exitcond = icmp eq i32 %inc, 100
  br i1 %exitcond, label %for.end, label %for.body

for.end:                                          ; preds = %for.body
  store double %add5, ptr %B, align 8
  %arrayidx7 = getelementptr inbounds double, ptr %B, i64 1
  store double %add4, ptr %arrayidx7, align 8
  ret i32 0
}

; float foo3(ptr A) {
;
;   float R = A[0];
;   float G = A[1];
;   float B = A[2];
;   float Y = A[3];
;   float P = A[4];
;   for (int i=0; i < 121; i+=3) {
;     R+=Aptr7;
;     G+=Aptr8;
;     B+=Aptr9;
;     Y+=Aptr10;
;     P+=Aptr11;
;   }
;
;   return R+G+B+Y+P;
; }

define float @foo3(ptr nocapture readonly %A) #0 {
; CHECK-LABEL: @foo3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load float, ptr [[A:%.*]], align 4
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds float, ptr [[A]], i64 1
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x float>, ptr [[ARRAYIDX1]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <4 x float> [[TMP1]], <4 x float> poison, <2 x i32> <i32 undef, i32 0>
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <2 x float> [[TMP2]], float [[TMP0]], i32 0
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[R_052:%.*]] = phi float [ [[TMP0]], [[ENTRY]] ], [ [[ADD6:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[TMP4:%.*]] = phi <4 x float> [ [[TMP1]], [[ENTRY]] ], [ [[TMP13:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[TMP5:%.*]] = phi <2 x float> [ [[TMP3]], [[ENTRY]] ], [ [[TMP9:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[TMP6:%.*]] = extractelement <2 x float> [[TMP5]], i32 0
; CHECK-NEXT:    [[MUL:%.*]] = fmul float [[TMP6]], 7.000000e+00
; CHECK-NEXT:    [[ADD6]] = fadd float [[R_052]], [[MUL]]
; CHECK-NEXT:    [[TMP7:%.*]] = add nsw i64 [[INDVARS_IV]], 2
; CHECK-NEXT:    [[ARRAYIDX14:%.*]] = getelementptr inbounds float, ptr [[A]], i64 [[TMP7]]
; CHECK-NEXT:    [[TMP8:%.*]] = load float, ptr [[ARRAYIDX14]], align 4
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 3
; CHECK-NEXT:    [[ARRAYIDX19:%.*]] = getelementptr inbounds float, ptr [[A]], i64 [[INDVARS_IV_NEXT]]
; CHECK-NEXT:    [[TMP9]] = load <2 x float>, ptr [[ARRAYIDX19]], align 4
; CHECK-NEXT:    [[TMP10:%.*]] = shufflevector <2 x float> [[TMP5]], <2 x float> [[TMP9]], <4 x i32> <i32 1, i32 undef, i32 2, i32 3>
; CHECK-NEXT:    [[TMP11:%.*]] = insertelement <4 x float> [[TMP10]], float [[TMP8]], i32 1
; CHECK-NEXT:    [[TMP12:%.*]] = fmul <4 x float> [[TMP11]], <float 8.000000e+00, float 9.000000e+00, float 1.000000e+01, float 1.100000e+01>
; CHECK-NEXT:    [[TMP13]] = fadd <4 x float> [[TMP4]], [[TMP12]]
; CHECK-NEXT:    [[TMP14:%.*]] = trunc i64 [[INDVARS_IV_NEXT]] to i32
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[TMP14]], 121
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    [[TMP15:%.*]] = extractelement <4 x float> [[TMP13]], i32 0
; CHECK-NEXT:    [[ADD28:%.*]] = fadd float [[ADD6]], [[TMP15]]
; CHECK-NEXT:    [[TMP16:%.*]] = extractelement <4 x float> [[TMP13]], i32 1
; CHECK-NEXT:    [[ADD29:%.*]] = fadd float [[ADD28]], [[TMP16]]
; CHECK-NEXT:    [[TMP17:%.*]] = extractelement <4 x float> [[TMP13]], i32 2
; CHECK-NEXT:    [[ADD30:%.*]] = fadd float [[ADD29]], [[TMP17]]
; CHECK-NEXT:    [[TMP18:%.*]] = extractelement <4 x float> [[TMP13]], i32 3
; CHECK-NEXT:    [[ADD31:%.*]] = fadd float [[ADD30]], [[TMP18]]
; CHECK-NEXT:    ret float [[ADD31]]
;
entry:
  %0 = load float, ptr %A, align 4
  %arrayidx1 = getelementptr inbounds float, ptr %A, i64 1
  %1 = load float, ptr %arrayidx1, align 4
  %arrayidx2 = getelementptr inbounds float, ptr %A, i64 2
  %2 = load float, ptr %arrayidx2, align 4
  %arrayidx3 = getelementptr inbounds float, ptr %A, i64 3
  %3 = load float, ptr %arrayidx3, align 4
  %arrayidx4 = getelementptr inbounds float, ptr %A, i64 4
  %4 = load float, ptr %arrayidx4, align 4
  br label %for.body

for.body:                                         ; preds = %for.body, %entry
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.body ]
  %P.056 = phi float [ %4, %entry ], [ %add26, %for.body ]
  %Y.055 = phi float [ %3, %entry ], [ %add21, %for.body ]
  %B.054 = phi float [ %2, %entry ], [ %add16, %for.body ]
  %G.053 = phi float [ %1, %entry ], [ %add11, %for.body ]
  %R.052 = phi float [ %0, %entry ], [ %add6, %for.body ]
  %5 = phi float [ %1, %entry ], [ %11, %for.body ]
  %6 = phi float [ %0, %entry ], [ %9, %for.body ]
  %mul = fmul float %6, 7.000000e+00
  %add6 = fadd float %R.052, %mul
  %mul10 = fmul float %5, 8.000000e+00
  %add11 = fadd float %G.053, %mul10
  %7 = add nsw i64 %indvars.iv, 2
  %arrayidx14 = getelementptr inbounds float, ptr %A, i64 %7
  %8 = load float, ptr %arrayidx14, align 4
  %mul15 = fmul float %8, 9.000000e+00
  %add16 = fadd float %B.054, %mul15
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 3
  %arrayidx19 = getelementptr inbounds float, ptr %A, i64 %indvars.iv.next
  %9 = load float, ptr %arrayidx19, align 4
  %mul20 = fmul float %9, 1.000000e+01
  %add21 = fadd float %Y.055, %mul20
  %10 = add nsw i64 %indvars.iv, 4
  %arrayidx24 = getelementptr inbounds float, ptr %A, i64 %10
  %11 = load float, ptr %arrayidx24, align 4
  %mul25 = fmul float %11, 1.100000e+01
  %add26 = fadd float %P.056, %mul25
  %12 = trunc i64 %indvars.iv.next to i32
  %cmp = icmp slt i32 %12, 121
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body
  %add28 = fadd float %add6, %add11
  %add29 = fadd float %add28, %add16
  %add30 = fadd float %add29, %add21
  %add31 = fadd float %add30, %add26
  ret float %add31
}

; Make sure the order of phi nodes of different types does not prevent
; vectorization of same typed phi nodes.
define float @sort_phi_type(ptr nocapture readonly %A) {
; CHECK-LABEL: @sort_phi_type(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = phi <4 x float> [ <float 1.000000e+01, float 1.000000e+01, float 1.000000e+01, float 1.000000e+01>, [[ENTRY]] ], [ [[TMP2:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <4 x float> [[TMP0]], <4 x float> poison, <4 x i32> <i32 0, i32 1, i32 3, i32 2>
; CHECK-NEXT:    [[TMP2]] = fmul <4 x float> [[TMP1]], <float 8.000000e+00, float 9.000000e+00, float 1.000000e+02, float 1.110000e+02>
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nsw i64 [[INDVARS_IV]], 4
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i64 [[INDVARS_IV_NEXT]], 128
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    [[TMP3:%.*]] = extractelement <4 x float> [[TMP2]], i32 0
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <4 x float> [[TMP2]], i32 1
; CHECK-NEXT:    [[ADD29:%.*]] = fadd float [[TMP3]], [[TMP4]]
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <4 x float> [[TMP2]], i32 2
; CHECK-NEXT:    [[ADD30:%.*]] = fadd float [[ADD29]], [[TMP5]]
; CHECK-NEXT:    [[TMP6:%.*]] = extractelement <4 x float> [[TMP2]], i32 3
; CHECK-NEXT:    [[ADD31:%.*]] = fadd float [[ADD30]], [[TMP6]]
; CHECK-NEXT:    ret float [[ADD31]]
;
entry:
  br label %for.body

for.body:                                         ; preds = %for.body, %entry
  %Y = phi float [ 1.000000e+01, %entry ], [ %mul10, %for.body ]
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.body ]
  %B = phi float [ 1.000000e+01, %entry ], [ %mul15, %for.body ]
  %G = phi float [ 1.000000e+01, %entry ], [ %mul20, %for.body ]
  %R = phi float [ 1.000000e+01, %entry ], [ %mul25, %for.body ]
  %mul10 = fmul float %Y, 8.000000e+00
  %mul15 = fmul float %B, 9.000000e+00
  %mul20 = fmul float %R, 10.000000e+01
  %mul25 = fmul float %G, 11.100000e+01
  %indvars.iv.next = add nsw i64 %indvars.iv, 4
  %cmp = icmp slt i64 %indvars.iv.next, 128
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body
  %add28 = fadd float 1.000000e+01, %mul10
  %add29 = fadd float %mul10, %mul15
  %add30 = fadd float %add29, %mul20
  %add31 = fadd float %add30, %mul25
  ret float %add31
}

define void @test(ptr %i1, ptr %i2, ptr %o) {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[I1_0:%.*]] = load x86_fp80, ptr [[I1:%.*]], align 16
; CHECK-NEXT:    [[I1_GEP1:%.*]] = getelementptr x86_fp80, ptr [[I1]], i64 1
; CHECK-NEXT:    [[I1_1:%.*]] = load x86_fp80, ptr [[I1_GEP1]], align 16
; CHECK-NEXT:    br i1 undef, label [[THEN:%.*]], label [[END:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[I2_0:%.*]] = load x86_fp80, ptr [[I2:%.*]], align 16
; CHECK-NEXT:    [[I2_GEP1:%.*]] = getelementptr inbounds x86_fp80, ptr [[I2]], i64 1
; CHECK-NEXT:    [[I2_1:%.*]] = load x86_fp80, ptr [[I2_GEP1]], align 16
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[PHI0:%.*]] = phi x86_fp80 [ [[I1_0]], [[ENTRY:%.*]] ], [ [[I2_0]], [[THEN]] ]
; CHECK-NEXT:    [[PHI1:%.*]] = phi x86_fp80 [ [[I1_1]], [[ENTRY]] ], [ [[I2_1]], [[THEN]] ]
; CHECK-NEXT:    store x86_fp80 [[PHI0]], ptr [[O:%.*]], align 16
; CHECK-NEXT:    [[O_GEP1:%.*]] = getelementptr inbounds x86_fp80, ptr [[O]], i64 1
; CHECK-NEXT:    store x86_fp80 [[PHI1]], ptr [[O_GEP1]], align 16
; CHECK-NEXT:    ret void
;
; Test that we correctly recognize the discontiguous memory in arrays where the
; size is less than the alignment, and through various different GEP formations.
; We disable the vectorization of x86_fp80 for now.

entry:
  %i1.0 = load x86_fp80, ptr %i1, align 16
  %i1.gep1 = getelementptr x86_fp80, ptr %i1, i64 1
  %i1.1 = load x86_fp80, ptr %i1.gep1, align 16
  br i1 undef, label %then, label %end

then:
  %i2.0 = load x86_fp80, ptr %i2, align 16
  %i2.gep1 = getelementptr inbounds x86_fp80, ptr %i2, i64 1
  %i2.1 = load x86_fp80, ptr %i2.gep1, align 16
  br label %end

end:
  %phi0 = phi x86_fp80 [ %i1.0, %entry ], [ %i2.0, %then ]
  %phi1 = phi x86_fp80 [ %i1.1, %entry ], [ %i2.1, %then ]
  store x86_fp80 %phi0, ptr %o, align 16
  %o.gep1 = getelementptr inbounds x86_fp80, ptr %o, i64 1
  store x86_fp80 %phi1, ptr %o.gep1, align 16
  ret void
}
