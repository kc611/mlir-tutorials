; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define double @test_fma() {
  %1 = call double @llvm.fma.f64(double 1.000000e+00, double 2.000000e+00, double 3.000000e+00)
  ret double %1
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.fma.f64(double, double, double) #0

attributes #0 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}