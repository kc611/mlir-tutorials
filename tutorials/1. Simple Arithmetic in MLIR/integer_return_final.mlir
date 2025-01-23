module {
  llvm.func @test_fma() -> f64 {
    %0 = llvm.mlir.constant(1.000000e+00 : f64) : f64
    %1 = llvm.mlir.constant(2.000000e+00 : f64) : f64
    %2 = llvm.mlir.constant(3.000000e+00 : f64) : f64
    %3 = llvm.intr.fma(%0, %1, %2)  : (f64, f64, f64) -> f64
    llvm.return %3 : f64
  }
}