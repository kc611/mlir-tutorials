module {
  omp.declare_reduction @__scf_reduction : f32 init {
  ^bb0(%arg0: f32):
    %0 = llvm.mlir.constant(0.000000e+00 : f32) : f32
    omp.yield(%0 : f32)
  } combiner {
  ^bb0(%arg0: f32, %arg1: f32):
    %0 = llvm.fadd %arg0, %arg1  : f32
    omp.yield(%0 : f32)
  } atomic {
  ^bb0(%arg0: !llvm.ptr, %arg1: !llvm.ptr):
    %0 = llvm.load %arg1 : !llvm.ptr -> f32
    %1 = llvm.atomicrmw fadd %arg0, %0 monotonic : !llvm.ptr, f32
    omp.yield
  } 
  llvm.func @conv_2d(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64, %arg6: i64, %arg7: !llvm.ptr, %arg8: !llvm.ptr, %arg9: i64, %arg10: i64, %arg11: i64, %arg12: i64, %arg13: i64, %arg14: !llvm.ptr, %arg15: !llvm.ptr, %arg16: i64, %arg17: i64, %arg18: i64, %arg19: i64, %arg20: i64) {
    %0 = llvm.mlir.constant(3 : index) : i64
    %1 = llvm.mlir.constant(100 : index) : i64
    %2 = llvm.mlir.constant(1 : i64) : i64
    %3 = llvm.mlir.constant(1 : index) : i64
    %4 = llvm.mlir.constant(98 : index) : i64
    %5 = llvm.mlir.constant(0 : index) : i64
    %6 = llvm.mlir.constant(2 : index) : i64
    %7 = llvm.mlir.constant(0.000000e+00 : f32) : f32
    omp.parallel {
      omp.wsloop {
        omp.loop_nest (%arg21, %arg22) : i64 = (%5, %5) to (%4, %4) step (%3, %3) {
          %8 = llvm.intr.stacksave : !llvm.ptr
          llvm.br ^bb1
        ^bb1:  // pred: ^bb0
          %9 = llvm.alloca %2 x f32 : (i64) -> !llvm.ptr
          llvm.store %7, %9 : f32, !llvm.ptr
          omp.parallel {
            omp.wsloop reduction(@__scf_reduction %9 -> %arg23 : !llvm.ptr) {
              omp.loop_nest (%arg24, %arg25) : i64 = (%5, %5) to (%6, %6) step (%3, %3) {
                %14 = llvm.intr.stacksave : !llvm.ptr
                llvm.br ^bb1
              ^bb1:  // pred: ^bb0
                %15 = llvm.add %arg21, %arg24 : i64
                %16 = llvm.add %arg22, %arg25 : i64
                %17 = llvm.mul %15, %1 : i64
                %18 = llvm.add %17, %16 : i64
                %19 = llvm.getelementptr %arg1[%18] : (!llvm.ptr, i64) -> !llvm.ptr, f32
                %20 = llvm.load %19 : !llvm.ptr -> f32
                %21 = llvm.mul %arg24, %0 : i64
                %22 = llvm.add %21, %arg25 : i64
                %23 = llvm.getelementptr %arg8[%22] : (!llvm.ptr, i64) -> !llvm.ptr, f32
                %24 = llvm.load %23 : !llvm.ptr -> f32
                %25 = llvm.fmul %20, %24  : f32
                %26 = llvm.load %arg23 : !llvm.ptr -> f32
                %27 = llvm.fadd %26, %25  : f32
                llvm.store %27, %arg23 : f32, !llvm.ptr
                llvm.intr.stackrestore %14 : !llvm.ptr
                llvm.br ^bb2
              ^bb2:  // pred: ^bb1
                omp.yield
              }
              omp.terminator
            }
            omp.terminator
          }
          %10 = llvm.load %9 : !llvm.ptr -> f32
          %11 = llvm.mul %arg21, %4 : i64
          %12 = llvm.add %11, %arg22 : i64
          %13 = llvm.getelementptr %arg15[%12] : (!llvm.ptr, i64) -> !llvm.ptr, f32
          llvm.store %10, %13 : f32, !llvm.ptr
          llvm.intr.stackrestore %8 : !llvm.ptr
          llvm.br ^bb2
        ^bb2:  // pred: ^bb1
          omp.yield
        }
        omp.terminator
      }
      omp.terminator
    }
    llvm.return
  }
}

