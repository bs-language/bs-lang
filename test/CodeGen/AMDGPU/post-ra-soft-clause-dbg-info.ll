; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=amdgcn -mcpu=gfx900 -mattr=+xnack -amdgpu-max-memory-clause=0 -verify-machineinstrs < %s | FileCheck -enable-var-scope -check-prefix=GCN %s

; Test the behavior of the post-RA soft clause bundler in the presence
; of debug info. The debug info should not interfere with the
; bundling, which could result in an observable codegen change.

define amdgpu_kernel void @dbg_clause(ptr addrspace(1) %out, ptr addrspace(1) %aptr) !dbg !4 {
; GCN-LABEL: dbg_clause:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GCN-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    global_load_dword v1, v0, s[2:3]
; GCN-NEXT:    ;DEBUG_VALUE: foo:a <- $vgpr1
; GCN-NEXT:    global_load_dword v2, v0, s[2:3] offset:32
; GCN-NEXT:    ;DEBUG_VALUE: foo:b <- $vgpr2
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    v_add_f32_e32 v1, v1, v2
; GCN-NEXT:    global_store_dword v0, v1, s[0:1]
; GCN-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %out.gep = getelementptr float, ptr addrspace(1) %out, i32 %tid
  %gep0 = getelementptr float, ptr addrspace(1) %aptr, i32 %tid
  %gep1 = getelementptr float, ptr addrspace(1) %gep0, i32 8
  %a = load float, ptr addrspace(1) %gep0, align 4
  call void @llvm.dbg.value(metadata float %a, metadata !8, metadata !DIExpression()), !dbg !9
  %b = load float, ptr addrspace(1) %gep1, align 4
  call void @llvm.dbg.value(metadata float %b, metadata !10, metadata !DIExpression()), !dbg !11
  %fadd = fadd float %a, %b
  store float %fadd, ptr addrspace(1) %out.gep, align 4
  ret void
}

declare i32 @llvm.amdgcn.workitem.id.x() #0
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { nounwind readnone speculatable willreturn }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, isOptimized: true, runtimeVersion: 0, emissionKind: NoDebug)
!1 = !DIFile(filename: "/tmp/foo.cl", directory: "/dev/null")
!2 = !{i32 2, !"Dwarf Version", i32 4}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = distinct !DISubprogram(name: "foo", scope: !1, file: !1, line: 1, type: !5, scopeLine: 2, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0)
!5 = !DISubroutineType(types: !6)
!6 = !{null, !7}
!7 = !DIBasicType(name: "float", size: 32, align: 32)
!8 = !DILocalVariable(name: "a", arg: 1, scope: !4, file: !1, line: 1)
!9 = !DILocation(line: 1, column: 42, scope: !4)
!10 = !DILocalVariable(name: "b", arg: 2, scope: !4, file: !1, line: 2)
!11 = !DILocation(line: 2, column: 42, scope: !4)
