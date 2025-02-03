module attributes {llvm.data_layout = ""} {
  llvm.func @array_trig(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: !llvm.ptr, %arg6: !llvm.ptr, %arg7: i64, %arg8: i64, %arg9: i64, %arg10: !llvm.ptr, %arg11: !llvm.ptr, %arg12: i64, %arg13: i64, %arg14: i64, %arg15: i64, %arg16: i64, %arg17: i64) {
    %0 = llvm.mlir.constant(-1 : index) : i64
    %1 = llvm.mlir.constant(0 : index) : i64
    %2 = llvm.mlir.constant(2 : i32) : i32
    %3 = llvm.mlir.constant(1 : index) : i64
    %4 = llvm.mul %arg15, %0  : i64
    %5 = llvm.add %arg16, %4  : i64
    omp.parallel   {
      omp.wsloop   for  (%arg18) : i64 = (%1) to (%5) step (%3) {
        %6 = llvm.intr.stacksave : !llvm.ptr
        llvm.br ^bb1
      ^bb1:  // pred: ^bb0
        %7 = llvm.add %arg18, %arg15  : i64
        %8 = llvm.getelementptr %arg1[%7] : (!llvm.ptr, i64) -> !llvm.ptr, f64
        %9 = llvm.load %8 : !llvm.ptr -> f64
        %10 = llvm.getelementptr %arg6[%7] : (!llvm.ptr, i64) -> !llvm.ptr, f64
        %11 = llvm.load %10 : !llvm.ptr -> f64
        %12 = llvm.intr.sin(%9)  : (f64) -> f64
        %13 = llvm.intr.cos(%11)  : (f64) -> f64
        %14 = llvm.intr.powi(%12, %2)  : (f64, i32) -> f64
        %15 = llvm.intr.powi(%13, %2)  : (f64, i32) -> f64
        %16 = llvm.fadd %14, %15  : f64
        %17 = llvm.getelementptr %arg11[%7] : (!llvm.ptr, i64) -> !llvm.ptr, f64
        llvm.store %16, %17 : f64, !llvm.ptr
        llvm.intr.stackrestore %6 : !llvm.ptr
        llvm.br ^bb2
      ^bb2:  // pred: ^bb1
        omp.yield
      }
      omp.terminator
    }
    llvm.return
  }
}

