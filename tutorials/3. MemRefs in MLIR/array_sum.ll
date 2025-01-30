; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define float @array_sum(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, i64 %5, i64 %6, i64 %7) {
  %9 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } undef, ptr %0, 0
  %10 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %9, ptr %1, 1
  %11 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %10, i64 %2, 2
  %12 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, i64 %3, 3, 0
  %13 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %12, i64 %4, 4, 0
  br label %14

14:                                               ; preds = %18, %8
  %15 = phi i64 [ %23, %18 ], [ %5, %8 ]
  %16 = phi float [ %22, %18 ], [ 1.000000e+00, %8 ]
  %17 = icmp slt i64 %15, %6
  br i1 %17, label %18, label %24

18:                                               ; preds = %14
  %19 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %13, 1
  %20 = getelementptr float, ptr %19, i64 %15
  %21 = load float, ptr %20, align 4
  %22 = fadd float %16, %21
  %23 = add i64 %15, %7
  br label %14

24:                                               ; preds = %14
  ret float %16
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
