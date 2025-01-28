; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

declare ptr @malloc(i64)

define { ptr, ptr, i64, [1 x i64], [1 x i64] } @array_trig(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, ptr %5, ptr %6, i64 %7, i64 %8, i64 %9, i64 %10, i64 %11, i64 %12) {
  %14 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } undef, ptr %5, 0
  %15 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %14, ptr %6, 1
  %16 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %15, i64 %7, 2
  %17 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %16, i64 %8, 3, 0
  %18 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %17, i64 %9, 4, 0
  %19 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } undef, ptr %0, 0
  %20 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %19, ptr %1, 1
  %21 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %20, i64 %2, 2
  %22 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, i64 %3, 3, 0
  %23 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %22, i64 %4, 4, 0
  %24 = call ptr @malloc(i64 ptrtoint (ptr getelementptr (double, ptr null, i64 1024) to i64))
  %25 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } undef, ptr %24, 0
  %26 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %25, ptr %24, 1
  %27 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %26, i64 0, 2
  %28 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %27, i64 1024, 3, 0
  %29 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %28, i64 1, 4, 0
  br label %30

30:                                               ; preds = %33, %13
  %31 = phi i64 [ %47, %33 ], [ %10, %13 ]
  %32 = icmp slt i64 %31, %11
  br i1 %32, label %33, label %48

33:                                               ; preds = %30
  %34 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %23, 1
  %35 = getelementptr double, ptr %34, i64 %31
  %36 = load double, ptr %35, align 8
  %37 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %18, 1
  %38 = getelementptr double, ptr %37, i64 %31
  %39 = load double, ptr %38, align 8
  %40 = call double @llvm.sin.f64(double %36)
  %41 = call double @llvm.cos.f64(double %39)
  %42 = call double @llvm.powi.f64.i32(double %40, i32 2)
  %43 = call double @llvm.powi.f64.i32(double %41, i32 2)
  %44 = fadd double %42, %43
  %45 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %29, 1
  %46 = getelementptr double, ptr %45, i64 %31
  store double %44, ptr %46, align 8
  %47 = add i64 %31, %12
  br label %30

48:                                               ; preds = %30
  ret { ptr, ptr, i64, [1 x i64], [1 x i64] } %29
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.sin.f64(double) #0

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.cos.f64(double) #0

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.powi.f64.i32(double, i32) #0

attributes #0 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
