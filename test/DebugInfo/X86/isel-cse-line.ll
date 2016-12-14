; RUN: llc -filetype=asm -fast-isel=false -O0 < %s | FileCheck %s
;
; Generated by:
; clang -emit-llvm -S -g test.cpp

; typedef double         fp_t;
; typedef unsigned long  int_t;
;
; int_t glb_start      = 17;
; int_t glb_end        = 42;
;
; int main()
; {
;   int_t start = glb_start;
;   int_t end   = glb_end;
;
;   fp_t dbl_start = (fp_t) start;
;   fp_t dbl_end   = (fp_t) end;
;
;   return 0;
; }

; SelectionDAG performs CSE on constant pool loads. Make sure line numbers
; from such nodes are not propagated. Doing so results in oscillating line numbers.

; CHECK: .loc 1 12
; CHECK: .loc 1 13
; CHECK-NOT: .loc 1 12

; ModuleID = 't.cpp'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@glb_start = global i64 17, align 8, !dbg !7
@glb_end = global i64 42, align 8, !dbg !10

; Function Attrs: norecurse nounwind uwtable
define i32 @main() !dbg !14 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  %4 = alloca double, align 8
  %5 = alloca double, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i64* %2, metadata !18, metadata !19), !dbg !20
  %6 = load i64, i64* @glb_start, align 8, !dbg !21
  store i64 %6, i64* %2, align 8, !dbg !20
  call void @llvm.dbg.declare(metadata i64* %3, metadata !22, metadata !19), !dbg !23
  %7 = load i64, i64* @glb_end, align 8, !dbg !24
  store i64 %7, i64* %3, align 8, !dbg !23
  call void @llvm.dbg.declare(metadata double* %4, metadata !25, metadata !19), !dbg !26
  %8 = load i64, i64* %2, align 8, !dbg !27
  %9 = uitofp i64 %8 to double, !dbg !27
  store double %9, double* %4, align 8, !dbg !26
  call void @llvm.dbg.declare(metadata double* %5, metadata !28, metadata !19), !dbg !29
  %10 = load i64, i64* %3, align 8, !dbg !30
  %11 = uitofp i64 %10 to double, !dbg !30
  store double %11, double* %5, align 8, !dbg !29
  ret i32 0, !dbg !31
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata, metadata)

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!11, !12}
!llvm.ident = !{!13}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "clang version 3.9.0 (trunk 268246)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, globals: !6)
!1 = !DIFile(filename: "/home/wpieb/test/D12094.cpp", directory: "/home/wpieb/build/llvm/trunk/llvm-RelWithDebInfo")
!2 = !{}
!3 = !{!4}
!4 = !DIDerivedType(tag: DW_TAG_typedef, name: "fp_t", file: !1, line: 1, baseType: !5)
!5 = !DIBasicType(name: "double", size: 64, align: 64, encoding: DW_ATE_float)
!6 = !{!7, !10}
!7 = distinct !DIGlobalVariable(name: "glb_start", scope: !0, file: !1, line: 4, type: !8, isLocal: false, isDefinition: true)
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_t", file: !1, line: 2, baseType: !9)
!9 = !DIBasicType(name: "long unsigned int", size: 64, align: 64, encoding: DW_ATE_unsigned)
!10 = distinct !DIGlobalVariable(name: "glb_end", scope: !0, file: !1, line: 5, type: !8, isLocal: false, isDefinition: true)
!11 = !{i32 2, !"Dwarf Version", i32 4}
!12 = !{i32 2, !"Debug Info Version", i32 3}
!13 = !{!"clang version 3.9.0 (trunk 268246)"}
!14 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 7, type: !15, isLocal: false, isDefinition: true, scopeLine: 8, flags: DIFlagPrototyped, isOptimized: false, unit: !0, variables: !2)
!15 = !DISubroutineType(types: !16)
!16 = !{!17}
!17 = !DIBasicType(name: "int", size: 32, align: 32, encoding: DW_ATE_signed)
!18 = !DILocalVariable(name: "start", scope: !14, file: !1, line: 9, type: !8)
!19 = !DIExpression()
!20 = !DILocation(line: 9, column: 9, scope: !14)
!21 = !DILocation(line: 9, column: 17, scope: !14)
!22 = !DILocalVariable(name: "end", scope: !14, file: !1, line: 10, type: !8)
!23 = !DILocation(line: 10, column: 9, scope: !14)
!24 = !DILocation(line: 10, column: 17, scope: !14)
!25 = !DILocalVariable(name: "dbl_start", scope: !14, file: !1, line: 12, type: !4)
!26 = !DILocation(line: 12, column: 8, scope: !14)
!27 = !DILocation(line: 12, column: 27, scope: !14)
!28 = !DILocalVariable(name: "dbl_end", scope: !14, file: !1, line: 13, type: !4)
!29 = !DILocation(line: 13, column: 8, scope: !14)
!30 = !DILocation(line: 13, column: 27, scope: !14)
!31 = !DILocation(line: 15, column: 3, scope: !14)