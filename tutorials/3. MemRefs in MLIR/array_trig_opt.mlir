module {
  llvm.func @malloc(i64) -> !llvm.ptr
  llvm.func @array_trig(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: !llvm.ptr, %arg6: !llvm.ptr, %arg7: i64, %arg8: i64, %arg9: i64, %arg10: i64, %arg11: i64, %arg12: i64) -> !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> {
    %0 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %1 = llvm.insertvalue %arg5, %0[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %2 = llvm.insertvalue %arg6, %1[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %3 = llvm.insertvalue %arg7, %2[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %4 = llvm.insertvalue %arg8, %3[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %5 = llvm.insertvalue %arg9, %4[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %6 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %7 = llvm.insertvalue %arg0, %6[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %8 = llvm.insertvalue %arg1, %7[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %9 = llvm.insertvalue %arg2, %8[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %10 = llvm.insertvalue %arg3, %9[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %11 = llvm.insertvalue %arg4, %10[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %12 = llvm.mlir.constant(1024 : index) : i64
    %13 = llvm.mlir.constant(1 : index) : i64
    %14 = llvm.mlir.zero : !llvm.ptr
    %15 = llvm.getelementptr %14[%12] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %16 = llvm.ptrtoint %15 : !llvm.ptr to i64
    %17 = llvm.call @malloc(%16) : (i64) -> !llvm.ptr
    %18 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %19 = llvm.insertvalue %17, %18[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %20 = llvm.insertvalue %17, %19[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %21 = llvm.mlir.constant(0 : index) : i64
    %22 = llvm.insertvalue %21, %20[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %23 = llvm.insertvalue %12, %22[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %24 = llvm.insertvalue %13, %23[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    llvm.br ^bb1(%arg10 : i64)
  ^bb1(%25: i64):  // 2 preds: ^bb0, ^bb2
    %26 = llvm.icmp "slt" %25, %arg11 : i64
    llvm.cond_br %26, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %27 = llvm.extractvalue %11[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %28 = llvm.getelementptr %27[%25] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %29 = llvm.load %28 : !llvm.ptr -> f64
    %30 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %31 = llvm.getelementptr %30[%25] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    %32 = llvm.load %31 : !llvm.ptr -> f64
    %33 = llvm.intr.sin(%29)  : (f64) -> f64
    %34 = llvm.intr.cos(%32)  : (f64) -> f64
    %35 = llvm.mlir.constant(2 : i32) : i32
    %36 = llvm.intr.powi(%33, %35)  : (f64, i32) -> f64
    %37 = llvm.intr.powi(%34, %35)  : (f64, i32) -> f64
    %38 = llvm.fadd %36, %37  : f64
    %39 = llvm.extractvalue %24[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %40 = llvm.getelementptr %39[%25] : (!llvm.ptr, i64) -> !llvm.ptr, f64
    llvm.store %38, %40 : f64, !llvm.ptr
    %41 = llvm.add %25, %arg12 : i64
    llvm.br ^bb1(%41 : i64)
  ^bb3:  // pred: ^bb1
    llvm.return %24 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
  }
}

