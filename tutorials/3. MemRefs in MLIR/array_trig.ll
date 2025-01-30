; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define void @array_trig(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, ptr %5, ptr %6, i64 %7, i64 %8, i64 %9, ptr %10, ptr %11, i64 %12, i64 %13, i64 %14, i64 %15, i64 %16, i64 %17) {
  %19 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } undef, ptr %10, 0
  %20 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %19, ptr %11, 1
  %21 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %20, i64 %12, 2
  %22 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, i64 %13, 3, 0
  %23 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %22, i64 %14, 4, 0
  %24 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } undef, ptr %5, 0
  %25 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %24, ptr %6, 1
  %26 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %25, i64 %7, 2
  %27 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %26, i64 %8, 3, 0
  %28 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %27, i64 %9, 4, 0
  %29 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } undef, ptr %0, 0
  %30 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %29, ptr %1, 1
  %31 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %30, i64 %2, 2
  %32 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %31, i64 %3, 3, 0
  %33 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %32, i64 %4, 4, 0
  br label %34

34:                                               ; preds = %37, %18
  %35 = phi i64 [ %51, %37 ], [ %15, %18 ]
  %36 = icmp slt i64 %35, %16
  br i1 %36, label %37, label %52

37:                                               ; preds = %34
  %38 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %33, 1
  %39 = getelementptr double, ptr %38, i64 %35
  %40 = load double, ptr %39, align 8
  %41 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %28, 1
  %42 = getelementptr double, ptr %41, i64 %35
  %43 = load double, ptr %42, align 8
  %44 = call double @llvm.sin.f64(double %40)
  %45 = call double @llvm.cos.f64(double %43)
  %46 = call double @llvm.powi.f64.i32(double %44, i32 2)
  %47 = call double @llvm.powi.f64.i32(double %45, i32 2)
  %48 = fadd double %46, %47
  %49 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %23, 1
  %50 = getelementptr double, ptr %49, i64 %35
  store double %48, ptr %50, align 8
  %51 = add i64 %35, %17
  br label %34

52:                                               ; preds = %34
  ret void
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
