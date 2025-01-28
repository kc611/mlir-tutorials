module {
  llvm.func @loop_add(%arg0: i64, %arg1: i64, %arg2: i64) -> i64 {
    %0 = llvm.mlir.constant(0 : index) : i64
    llvm.br ^bb1(%arg0, %0 : i64, i64)
  ^bb1(%1: i64, %2: i64):  // 2 preds: ^bb0, ^bb2
    %3 = llvm.icmp "slt" %1, %arg1 : i64
    llvm.cond_br %3, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %4 = llvm.add %2, %1 : i64
    %5 = llvm.add %1, %arg2 : i64
    llvm.br ^bb1(%5, %4 : i64, i64)
  ^bb3:  // pred: ^bb1
    llvm.return %2 : i64
  }
}

