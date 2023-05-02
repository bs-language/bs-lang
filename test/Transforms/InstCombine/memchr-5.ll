; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; Verify that calls to memchr with arrays of elements larger than char
; are folded correctly.
; RUN: opt < %s -passes=instcombine -S -data-layout="E" | FileCheck %s --check-prefixes=BE
; RUN: opt < %s -passes=instcombine -S -data-layout="e" | FileCheck %s --check-prefixes=LE

declare ptr @memchr(ptr, i32, i64)

; BE representation: { 'a', 'b', 'c', 'd', 'e', ..., 'p' }
; LE representation: { 'd', 'c', 'b', 'a', 'h', ..., 'm' }
@a = constant [4 x i32] [i32 1633837924, i32 1701209960, i32 1768581996, i32 1835954032]


; Fold memchr(a, C, 16) for C in ['a', 'd'] U ['o', 'q'].

define void @fold_memchr_a(ptr %pcmp) {
; BE-LABEL: @fold_memchr_a(
; BE-NEXT:    store i64 0, ptr [[PCMP:%.*]], align 4
; BE-NEXT:    [[PSTOR1:%.*]] = getelementptr i64, ptr [[PCMP]], i64 1
; BE-NEXT:    store i64 1, ptr [[PSTOR1]], align 4
; BE-NEXT:    [[PSTOR2:%.*]] = getelementptr i64, ptr [[PCMP]], i64 2
; BE-NEXT:    store i64 2, ptr [[PSTOR2]], align 4
; BE-NEXT:    [[PSTOR3:%.*]] = getelementptr i64, ptr [[PCMP]], i64 3
; BE-NEXT:    store i64 3, ptr [[PSTOR3]], align 4
; BE-NEXT:    [[PSTOR4:%.*]] = getelementptr i64, ptr [[PCMP]], i64 4
; BE-NEXT:    store i64 13, ptr [[PSTOR4]], align 4
; BE-NEXT:    [[PSTOR6:%.*]] = getelementptr i64, ptr [[PCMP]], i64 6
; BE-NEXT:    store i64 14, ptr [[PSTOR6]], align 4
; BE-NEXT:    [[PSTOR7:%.*]] = getelementptr i64, ptr [[PCMP]], i64 7
; BE-NEXT:    store i64 15, ptr [[PSTOR7]], align 4
; BE-NEXT:    [[PSTOR8:%.*]] = getelementptr i64, ptr [[PCMP]], i64 8
; BE-NEXT:    store i64 0, ptr [[PSTOR8]], align 4
; BE-NEXT:    ret void
;
; LE-LABEL: @fold_memchr_a(
; LE-NEXT:    store i64 3, ptr [[PCMP:%.*]], align 4
; LE-NEXT:    [[PSTOR1:%.*]] = getelementptr i64, ptr [[PCMP]], i64 1
; LE-NEXT:    store i64 2, ptr [[PSTOR1]], align 4
; LE-NEXT:    [[PSTOR2:%.*]] = getelementptr i64, ptr [[PCMP]], i64 2
; LE-NEXT:    store i64 1, ptr [[PSTOR2]], align 4
; LE-NEXT:    [[PSTOR3:%.*]] = getelementptr i64, ptr [[PCMP]], i64 3
; LE-NEXT:    store i64 0, ptr [[PSTOR3]], align 4
; LE-NEXT:    [[PSTOR4:%.*]] = getelementptr i64, ptr [[PCMP]], i64 4
; LE-NEXT:    store i64 14, ptr [[PSTOR4]], align 4
; LE-NEXT:    [[PSTOR6:%.*]] = getelementptr i64, ptr [[PCMP]], i64 6
; LE-NEXT:    store i64 13, ptr [[PSTOR6]], align 4
; LE-NEXT:    [[PSTOR7:%.*]] = getelementptr i64, ptr [[PCMP]], i64 7
; LE-NEXT:    store i64 12, ptr [[PSTOR7]], align 4
; LE-NEXT:    [[PSTOR8:%.*]] = getelementptr i64, ptr [[PCMP]], i64 8
; LE-NEXT:    store i64 0, ptr [[PSTOR8]], align 4
; LE-NEXT:    ret void
;
  %ip0 = ptrtoint ptr @a to i64

; Fold memchr(a, 'a', 16) - a to 0 (3 in LE).

  %pa = call ptr @memchr(ptr @a, i32 97, i64 16)
  %ipa = ptrtoint ptr %pa to i64
  %offa = sub i64 %ipa, %ip0
  store i64 %offa, ptr %pcmp

; Fold memchr(a, 'b', 16) - a to 1 (2 in LE)

  %pb = call ptr @memchr(ptr @a, i32 98, i64 16)
  %ipb = ptrtoint ptr %pb to i64
  %offb = sub i64 %ipb, %ip0
  %pstor1 = getelementptr i64, ptr %pcmp, i64 1
  store i64 %offb, ptr %pstor1

; Fold memchr(a, 'c', 16) - a to 2 (1 in LE)

  %pc = call ptr @memchr(ptr @a, i32 99, i64 16)
  %ipc = ptrtoint ptr %pc to i64
  %offc = sub i64 %ipc, %ip0
  %pstor2 = getelementptr i64, ptr %pcmp, i64 2
  store i64 %offc, ptr %pstor2

; Fold memchr(a, 'd', 16) - a to 3 (0 in LE)

  %pd = call ptr @memchr(ptr @a, i32 100, i64 16)
  %ipd = ptrtoint ptr %pd to i64
  %offd = sub i64 %ipd, %ip0
  %pstor3 = getelementptr i64, ptr %pcmp, i64 3
  store i64 %offd, ptr %pstor3

; Fold memchr(a, 'n', 16) - a to 13 (14 in LE)

  %pn = call ptr @memchr(ptr @a, i32 110, i64 16)
  %ipn = ptrtoint ptr %pn to i64
  %offn = sub i64 %ipn, %ip0
  %pstor4 = getelementptr i64, ptr %pcmp, i64 4
  store i64 %offn, ptr %pstor4

; Fold memchr(a, 'o', 16) - a to 14 (13 in LE)

  %po = call ptr @memchr(ptr @a, i32 111, i64 16)
  %ipo = ptrtoint ptr %po to i64
  %offo = sub i64 %ipo, %ip0
  %pstor6 = getelementptr i64, ptr %pcmp, i64 6
  store i64 %offo, ptr %pstor6

; Fold memchr(a, 'p', 16) - a to 15 (12 in LE)

  %pp = call ptr @memchr(ptr @a, i32 112, i64 16)
  %ipp = ptrtoint ptr %pp to i64
  %offp = sub i64 %ipp, %ip0
  %pstor7 = getelementptr i64, ptr %pcmp, i64 7
  store i64 %offp, ptr %pstor7

; Fold memchr(a, 'q', 16) to null in both BE and LE.

  %pq = call ptr @memchr(ptr @a, i32 113, i64 16)
  %ipq = ptrtoint ptr %pq to i64
  %pstor8 = getelementptr i64, ptr %pcmp, i64 8
  store i64 %ipq, ptr %pstor8

  ret void
}


; Fold memchr(a + 1, C, 12) for C in ['e', 'h'] U ['a', 'd'].

define void @fold_memchr_a_p1(ptr %pcmp) {
; BE-LABEL: @fold_memchr_a_p1(
; BE-NEXT:    store i64 0, ptr [[PCMP:%.*]], align 4
; BE-NEXT:    [[PSTOR1:%.*]] = getelementptr i64, ptr [[PCMP]], i64 1
; BE-NEXT:    store i64 1, ptr [[PSTOR1]], align 4
; BE-NEXT:    [[PSTOR2:%.*]] = getelementptr i64, ptr [[PCMP]], i64 2
; BE-NEXT:    store i64 2, ptr [[PSTOR2]], align 4
; BE-NEXT:    [[PSTOR3:%.*]] = getelementptr i64, ptr [[PCMP]], i64 3
; BE-NEXT:    store i64 3, ptr [[PSTOR3]], align 4
; BE-NEXT:    [[PSTOR4:%.*]] = getelementptr i64, ptr [[PCMP]], i64 4
; BE-NEXT:    store i64 0, ptr [[PSTOR4]], align 4
; BE-NEXT:    [[PSTOR5:%.*]] = getelementptr i64, ptr [[PCMP]], i64 5
; BE-NEXT:    store i64 0, ptr [[PSTOR5]], align 4
; BE-NEXT:    ret void
;
; LE-LABEL: @fold_memchr_a_p1(
; LE-NEXT:    store i64 3, ptr [[PCMP:%.*]], align 4
; LE-NEXT:    [[PSTOR1:%.*]] = getelementptr i64, ptr [[PCMP]], i64 1
; LE-NEXT:    store i64 2, ptr [[PSTOR1]], align 4
; LE-NEXT:    [[PSTOR2:%.*]] = getelementptr i64, ptr [[PCMP]], i64 2
; LE-NEXT:    store i64 1, ptr [[PSTOR2]], align 4
; LE-NEXT:    [[PSTOR3:%.*]] = getelementptr i64, ptr [[PCMP]], i64 3
; LE-NEXT:    store i64 0, ptr [[PSTOR3]], align 4
; LE-NEXT:    [[PSTOR4:%.*]] = getelementptr i64, ptr [[PCMP]], i64 4
; LE-NEXT:    store i64 0, ptr [[PSTOR4]], align 4
; LE-NEXT:    [[PSTOR5:%.*]] = getelementptr i64, ptr [[PCMP]], i64 5
; LE-NEXT:    store i64 0, ptr [[PSTOR5]], align 4
; LE-NEXT:    ret void
;
  %p0 = getelementptr [4 x i32], ptr @a, i64 0, i64 1
  %ip0 = ptrtoint ptr %p0 to i64

; Fold memchr(a + 1, 'e', 12) - a to 0 (3 in LE).

  %pe = call ptr @memchr(ptr %p0, i32 101, i64 12)
  %ipe = ptrtoint ptr %pe to i64
  %offe = sub i64 %ipe, %ip0
  store i64 %offe, ptr %pcmp

; Fold memchr(a + 1, 'f', 12) - a to 1 (2 in LE).

  %pf = call ptr @memchr(ptr %p0, i32 102, i64 12)
  %ipf = ptrtoint ptr %pf to i64
  %offf = sub i64 %ipf, %ip0
  %pstor1 = getelementptr i64, ptr %pcmp, i64 1
  store i64 %offf, ptr %pstor1

; Fold memchr(a + 1, 'g', 12) - a to 2 (1 in LE).

  %pg = call ptr @memchr(ptr %p0, i32 103, i64 12)
  %ipg = ptrtoint ptr %pg to i64
  %offg = sub i64 %ipg, %ip0
  %pstor2 = getelementptr i64, ptr %pcmp, i64 2
  store i64 %offg, ptr %pstor2

; Fold memchr(a + 1, 'h', 12) - a to 3 (0 in LE).

  %ph = call ptr @memchr(ptr %p0, i32 104, i64 12)
  %iph = ptrtoint ptr %ph to i64
  %offh = sub i64 %iph, %ip0
  %pstor3 = getelementptr i64, ptr %pcmp, i64 3
  store i64 %offh, ptr %pstor3

; Fold memchr(a + 1, 'a', 12) to null in both BE and LE.

  %pa = call ptr @memchr(ptr %p0, i32 97, i64 12)
  %ipa = ptrtoint ptr %pa to i64
  %pstor4 = getelementptr i64, ptr %pcmp, i64 4
  store i64 %ipa, ptr %pstor4

; Fold memchr(a + 1, 'd', 12) to null in both BE and LE.

  %pd = call ptr @memchr(ptr %p0, i32 100, i64 12)
  %ipd = ptrtoint ptr %pd to i64
  %pstor5 = getelementptr i64, ptr %pcmp, i64 5
  store i64 %ipd, ptr %pstor5

  ret void
}
