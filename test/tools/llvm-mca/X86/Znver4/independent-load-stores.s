# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=znver4 -timeline -timeline-max-iterations=1 < %s | FileCheck %s -check-prefixes=ALL,NOALIAS
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=znver4 -timeline -timeline-max-iterations=1 -noalias=false < %s | FileCheck %s -check-prefixes=ALL,YESALIAS

  addq	$44, 64(%r14)
  addq	$44, 128(%r14)
  addq	$44, 192(%r14)
  addq	$44, 256(%r14)
  addq	$44, 320(%r14)
  addq	$44, 384(%r14)
  addq	$44, 448(%r14)
  addq	$44, 512(%r14)
  addq	$44, 576(%r14)
  addq	$44, 640(%r14)

# ALL:           Iterations:        100
# ALL-NEXT:      Instructions:      1000

# NOALIAS-NEXT:  Total Cycles:      675
# YESALIAS-NEXT: Total Cycles:      6003

# ALL-NEXT:      Total uOps:        1000

# ALL:           Dispatch Width:    6

# NOALIAS-NEXT:  uOps Per Cycle:    1.48
# NOALIAS-NEXT:  IPC:               1.48

# YESALIAS-NEXT: uOps Per Cycle:    0.17
# YESALIAS-NEXT: IPC:               0.17

# ALL-NEXT:      Block RThroughput: 6.7

# ALL:           Instruction Info:
# ALL-NEXT:      [1]: #uOps
# ALL-NEXT:      [2]: Latency
# ALL-NEXT:      [3]: RThroughput
# ALL-NEXT:      [4]: MayLoad
# ALL-NEXT:      [5]: MayStore
# ALL-NEXT:      [6]: HasSideEffects (U)

# ALL:           [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# ALL-NEXT:       1      6     0.67    *      *            addq	$44, 64(%r14)
# ALL-NEXT:       1      6     0.67    *      *            addq	$44, 128(%r14)
# ALL-NEXT:       1      6     0.67    *      *            addq	$44, 192(%r14)
# ALL-NEXT:       1      6     0.67    *      *            addq	$44, 256(%r14)
# ALL-NEXT:       1      6     0.67    *      *            addq	$44, 320(%r14)
# ALL-NEXT:       1      6     0.67    *      *            addq	$44, 384(%r14)
# ALL-NEXT:       1      6     0.67    *      *            addq	$44, 448(%r14)
# ALL-NEXT:       1      6     0.67    *      *            addq	$44, 512(%r14)
# ALL-NEXT:       1      6     0.67    *      *            addq	$44, 576(%r14)
# ALL-NEXT:       1      6     0.67    *      *            addq	$44, 640(%r14)

# ALL:           Resources:
# ALL-NEXT:      [0]   - Zn4AGU0
# ALL-NEXT:      [1]   - Zn4AGU1
# ALL-NEXT:      [2]   - Zn4AGU2
# ALL-NEXT:      [3]   - Zn4ALU0
# ALL-NEXT:      [4]   - Zn4ALU1
# ALL-NEXT:      [5]   - Zn4ALU2
# ALL-NEXT:      [6]   - Zn4ALU3
# ALL-NEXT:      [7]   - Zn4BRU1
# ALL-NEXT:      [8]   - Zn4FP0
# ALL-NEXT:      [9]   - Zn4FP1
# ALL-NEXT:      [10]  - Zn4FP2
# ALL-NEXT:      [11]  - Zn4FP3
# ALL-NEXT:      [12.0] - Zn4FP45
# ALL-NEXT:      [12.1] - Zn4FP45
# ALL-NEXT:      [13]  - Zn4FPSt
# ALL-NEXT:      [14.0] - Zn4LSU
# ALL-NEXT:      [14.1] - Zn4LSU
# ALL-NEXT:      [14.2] - Zn4LSU
# ALL-NEXT:      [15.0] - Zn4Load
# ALL-NEXT:      [15.1] - Zn4Load
# ALL-NEXT:      [15.2] - Zn4Load
# ALL-NEXT:      [16.0] - Zn4Store
# ALL-NEXT:      [16.1] - Zn4Store

# ALL:           Resource pressure per iteration:
# ALL-NEXT:      [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12.0] [12.1] [13]   [14.0] [14.1] [14.2] [15.0] [15.1] [15.2] [16.0] [16.1]
# ALL-NEXT:      6.66   6.66   6.68   2.50   2.50   2.50   2.50    -      -      -      -      -      -      -      -     6.66   6.66   6.68   3.33   3.33   3.34   5.00   5.00

# ALL:           Resource pressure by instruction:
# ALL-NEXT:      [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12.0] [12.1] [13]   [14.0] [14.1] [14.2] [15.0] [15.1] [15.2] [16.0] [16.1] Instructions:
# ALL-NEXT:      0.66   0.66   0.68    -     0.50    -     0.50    -      -      -      -      -      -      -      -     0.66   0.66   0.68   0.33   0.33   0.34    -     1.00   addq	$44, 64(%r14)
# ALL-NEXT:      0.66   0.68   0.66   0.50    -     0.50    -      -      -      -      -      -      -      -      -     0.66   0.68   0.66   0.33   0.34   0.33   1.00    -     addq	$44, 128(%r14)
# ALL-NEXT:      0.68   0.66   0.66    -     0.50    -     0.50    -      -      -      -      -      -      -      -     0.68   0.66   0.66   0.34   0.33   0.33    -     1.00   addq	$44, 192(%r14)
# ALL-NEXT:      0.66   0.66   0.68   0.50    -     0.50    -      -      -      -      -      -      -      -      -     0.66   0.66   0.68   0.33   0.33   0.34   1.00    -     addq	$44, 256(%r14)
# ALL-NEXT:      0.66   0.68   0.66    -     0.50    -     0.50    -      -      -      -      -      -      -      -     0.66   0.68   0.66   0.33   0.34   0.33    -     1.00   addq	$44, 320(%r14)
# ALL-NEXT:      0.68   0.66   0.66   0.50    -     0.50    -      -      -      -      -      -      -      -      -     0.68   0.66   0.66   0.34   0.33   0.33   1.00    -     addq	$44, 384(%r14)
# ALL-NEXT:      0.66   0.66   0.68    -     0.50    -     0.50    -      -      -      -      -      -      -      -     0.66   0.66   0.68   0.33   0.33   0.34    -     1.00   addq	$44, 448(%r14)
# ALL-NEXT:      0.66   0.68   0.66   0.50    -     0.50    -      -      -      -      -      -      -      -      -     0.66   0.68   0.66   0.33   0.34   0.33   1.00    -     addq	$44, 512(%r14)
# ALL-NEXT:      0.68   0.66   0.66    -     0.50    -     0.50    -      -      -      -      -      -      -      -     0.68   0.66   0.66   0.34   0.33   0.33    -     1.00   addq	$44, 576(%r14)
# ALL-NEXT:      0.66   0.66   0.68   0.50    -     0.50    -      -      -      -      -      -      -      -      -     0.66   0.66   0.68   0.33   0.33   0.34   1.00    -     addq	$44, 640(%r14)

# ALL:           Timeline view:

# NOALIAS-NEXT:                      01234
# NOALIAS-NEXT:  Index     0123456789

# YESALIAS-NEXT:                     0123456789          0123456789          0123456789
# YESALIAS-NEXT: Index     0123456789          0123456789          0123456789          012

# NOALIAS:       [0,0]     DeeeeeeER .   .   addq	$44, 64(%r14)
# NOALIAS-NEXT:  [0,1]     DeeeeeeER .   .   addq	$44, 128(%r14)
# NOALIAS-NEXT:  [0,2]     D=eeeeeeER.   .   addq	$44, 192(%r14)
# NOALIAS-NEXT:  [0,3]     D==eeeeeeER   .   addq	$44, 256(%r14)
# NOALIAS-NEXT:  [0,4]     D==eeeeeeER   .   addq	$44, 320(%r14)
# NOALIAS-NEXT:  [0,5]     D===eeeeeeER  .   addq	$44, 384(%r14)
# NOALIAS-NEXT:  [0,6]     .D===eeeeeeER .   addq	$44, 448(%r14)
# NOALIAS-NEXT:  [0,7]     .D===eeeeeeER .   addq	$44, 512(%r14)
# NOALIAS-NEXT:  [0,8]     .D====eeeeeeER.   addq	$44, 576(%r14)
# NOALIAS-NEXT:  [0,9]     .D=====eeeeeeER   addq	$44, 640(%r14)

# YESALIAS:      [0,0]     DeeeeeeER .    .    .    .    .    .    .    .    .    .    . .   addq	$44, 64(%r14)
# YESALIAS-NEXT: [0,1]     D======eeeeeeER.    .    .    .    .    .    .    .    .    . .   addq	$44, 128(%r14)
# YESALIAS-NEXT: [0,2]     D============eeeeeeER    .    .    .    .    .    .    .    . .   addq	$44, 192(%r14)
# YESALIAS-NEXT: [0,3]     D==================eeeeeeER   .    .    .    .    .    .    . .   addq	$44, 256(%r14)
# YESALIAS-NEXT: [0,4]     D========================eeeeeeER  .    .    .    .    .    . .   addq	$44, 320(%r14)
# YESALIAS-NEXT: [0,5]     D==============================eeeeeeER .    .    .    .    . .   addq	$44, 384(%r14)
# YESALIAS-NEXT: [0,6]     .D===================================eeeeeeER.    .    .    . .   addq	$44, 448(%r14)
# YESALIAS-NEXT: [0,7]     .D=========================================eeeeeeER    .    . .   addq	$44, 512(%r14)
# YESALIAS-NEXT: [0,8]     .D===============================================eeeeeeER   . .   addq	$44, 576(%r14)
# YESALIAS-NEXT: [0,9]     .D=====================================================eeeeeeER   addq	$44, 640(%r14)

# ALL:           Average Wait times (based on the timeline view):
# ALL-NEXT:      [0]: Executions
# ALL-NEXT:      [1]: Average time spent waiting in a scheduler's queue
# ALL-NEXT:      [2]: Average time spent waiting in a scheduler's queue while ready
# ALL-NEXT:      [3]: Average time elapsed from WB until retire stage

# ALL:                 [0]    [1]    [2]    [3]
# ALL-NEXT:      0.     1     1.0    1.0    0.0       addq	$44, 64(%r14)

# NOALIAS-NEXT:  1.     1     1.0    0.0    0.0       addq	$44, 128(%r14)
# NOALIAS-NEXT:  2.     1     2.0    1.0    0.0       addq	$44, 192(%r14)
# NOALIAS-NEXT:  3.     1     3.0    1.0    0.0       addq	$44, 256(%r14)
# NOALIAS-NEXT:  4.     1     3.0    0.0    0.0       addq	$44, 320(%r14)
# NOALIAS-NEXT:  5.     1     4.0    1.0    0.0       addq	$44, 384(%r14)
# NOALIAS-NEXT:  6.     1     4.0    1.0    0.0       addq	$44, 448(%r14)
# NOALIAS-NEXT:  7.     1     4.0    0.0    0.0       addq	$44, 512(%r14)
# NOALIAS-NEXT:  8.     1     5.0    1.0    0.0       addq	$44, 576(%r14)
# NOALIAS-NEXT:  9.     1     6.0    1.0    0.0       addq	$44, 640(%r14)
# NOALIAS-NEXT:         1     3.3    0.7    0.0       <total>

# YESALIAS-NEXT: 1.     1     7.0    0.0    0.0       addq	$44, 128(%r14)
# YESALIAS-NEXT: 2.     1     13.0   0.0    0.0       addq	$44, 192(%r14)
# YESALIAS-NEXT: 3.     1     19.0   0.0    0.0       addq	$44, 256(%r14)
# YESALIAS-NEXT: 4.     1     25.0   0.0    0.0       addq	$44, 320(%r14)
# YESALIAS-NEXT: 5.     1     31.0   0.0    0.0       addq	$44, 384(%r14)
# YESALIAS-NEXT: 6.     1     36.0   0.0    0.0       addq	$44, 448(%r14)
# YESALIAS-NEXT: 7.     1     42.0   0.0    0.0       addq	$44, 512(%r14)
# YESALIAS-NEXT: 8.     1     48.0   0.0    0.0       addq	$44, 576(%r14)
# YESALIAS-NEXT: 9.     1     54.0   0.0    0.0       addq	$44, 640(%r14)
# YESALIAS-NEXT:        1     27.6   0.1    0.0       <total>
