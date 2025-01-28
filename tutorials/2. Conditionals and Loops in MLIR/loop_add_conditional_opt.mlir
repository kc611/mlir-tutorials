module {
  llvm.func @reduce(%arg0: i64, %arg1: i64, %arg2: i64, %arg3: i64) -> i64 {
    %0 = llvm.mlir.constant(0 : index) : i64
    llvm.br ^bb1(%arg0, %0 : i64, i64)
  ^bb1(%1: i64, %2: i64):  // 2 preds: ^bb0, ^bb6
    %3 = llvm.icmp "slt" %1, %arg1 : i64
    llvm.cond_br %3, ^bb2, ^bb7
  ^bb2:  // pred: ^bb1
    %4 = llvm.icmp "slt" %1, %arg3 : i64
    llvm.cond_br %4, ^bb3, ^bb4
  ^bb3:  // pred: ^bb2
    %5 = llvm.add %2, %arg2 : i64
    llvm.br ^bb5(%5 : i64)
  ^bb4:  // pred: ^bb2
    llvm.br ^bb5(%arg3 : i64)
  ^bb5(%6: i64):  // 2 preds: ^bb3, ^bb4
    llvm.br ^bb6
  ^bb6:  // pred: ^bb5
    %7 = llvm.add %1, %arg2 : i64
    llvm.br ^bb1(%7, %6 : i64, i64)
  ^bb7:  // pred: ^bb1
    llvm.return %2 : i64
  }
}

