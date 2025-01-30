module {
  llvm.func @array_sum(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64, %arg6: i64, %arg7: i64) -> f32 {
    %0 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %1 = llvm.insertvalue %arg0, %0[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %2 = llvm.insertvalue %arg1, %1[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %3 = llvm.insertvalue %arg2, %2[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %4 = llvm.insertvalue %arg3, %3[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %5 = llvm.insertvalue %arg4, %4[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %6 = llvm.mlir.constant(1.000000e+00 : f32) : f32
    llvm.br ^bb1(%arg5, %6 : i64, f32)
  ^bb1(%7: i64, %8: f32):  // 2 preds: ^bb0, ^bb2
    %9 = llvm.icmp "slt" %7, %arg6 : i64
    llvm.cond_br %9, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %10 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %11 = llvm.getelementptr %10[%7] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %12 = llvm.load %11 : !llvm.ptr -> f32
    %13 = llvm.fadd %8, %12  : f32
    %14 = llvm.add %7, %arg7 : i64
    llvm.br ^bb1(%14, %13 : i64, f32)
  ^bb3:  // pred: ^bb1
    llvm.return %8 : f32
  }
}

