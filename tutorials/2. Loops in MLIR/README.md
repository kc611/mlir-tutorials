# Introduction

Previously we learned how to build basic program logic in MLIR, how the pipeline works and how to execute things. In this tutorial we'll delve deeper into MLIR concepts by taking a look at how MLIR handles loops.

# Looping in MLIR

We can write a basic program that looks like follows:

```
func.func @reduce(%lb: index, %ub: index, %step: index) -> (index) {
    %sum_0 = arith.constant 0 : index
    %sum = scf.for %iv = %lb to %ub step %step iter_args(%sum_iter = %sum_0) -> (index) {
        %sum_next = arith.addi %sum_iter, %step : index
        scf.yield %sum_next : index
    }
    return %sum : index
}
```

using the `scf` dialect. This dialect specializes in  operations that represent control flow constructs such as `if` and `for`. Structured as in the control flow has a structure unlike, for example, `goto`s or `assert`s which are direct jump from one location to another within the logic.

In our specific example above we've used a very specific operation [`scf.for`](https://mlir.llvm.org/docs/Dialects/SCFDialect/#scffor-scfforop) which requires `%start`, `%stop` and `%step` variables respectively. These is equivalent to writing `for(i=start;i<stop;i+=step)` loop in C++ or `for i in range(start, step, stop)` in Python. Then we define the `iter_args(..)` which define the common variable(s) across every iteration of the loop. For instance in our example after each iteration, the variable `%sum_iter` will be supplied to the loop body. The initial value in the first iteration of loop for the `%sum_iter` will be what we assigned to it at initialization during `iter_args()` i.e. `%sum_0` in our case. Then we yield values out of the first iteration using the `scf.yield` syntax, assigning the same yielded value to the `%sum_iter` in the next iteration. Hence continuing the for loop till the termination condition. This continues till the loop terminates and the final value is assigned to `%sum` which is then returned by the function. 

Now let's use `mlir-opt` upon this example to see how it converts to LLVM consumable dialect. For this example we'd need the `-convert-scf-to-cf`, `--convert-func-to-llvm`, `--convert-math-to-llvm` and `-convert-index-to-llvm` optimization passes. Most of these are self explanatory in what exactly they're doing, so let's look at the effects of each one on our example. For this we again use the `--mlir-print-ir-after-all` flag. 

On running the following command:

```
mlir-opt loop_add.mlir --mlir-print-ir-after-all -convert-scf-to-cf --convert-func-to-llvm --convert-math-to-llvm -convert-index-to-llvm -o loop_add_opt.mlir
```

We get the following output:

```
// -----// IR Dump After SCFToControlFlow (convert-scf-to-cf) //----- //
module {
  func.func @reduce(%arg0: index, %arg1: index, %arg2: index) -> index {
    %c0 = arith.constant 0 : index
    cf.br ^bb1(%arg0, %c0 : index, index)
  ^bb1(%0: index, %1: index):  // 2 preds: ^bb0, ^bb2
    %2 = arith.cmpi slt, %0, %arg1 : index
    cf.cond_br %2, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %3 = arith.addi %1, %arg2 : index
    %4 = arith.addi %0, %arg2 : index
    cf.br ^bb1(%4, %3 : index, index)
  ^bb3:  // pred: ^bb1
    return %1 : index
  }
}


// -----// IR Dump After ConvertFuncToLLVMPass (convert-func-to-llvm) //----- //
module attributes {llvm.data_layout = ""} {
  llvm.func @reduce(%arg0: i64, %arg1: i64, %arg2: i64) -> i64 {
    %0 = llvm.mlir.constant(0 : index) : i64
    llvm.br ^bb1(%arg0, %0 : i64, i64)
  ^bb1(%1: i64, %2: i64):  // 2 preds: ^bb0, ^bb2
    %3 = llvm.icmp "slt" %1, %arg1 : i64
    llvm.cond_br %3, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %4 = llvm.add %2, %arg2  : i64
    %5 = llvm.add %1, %arg2  : i64
    llvm.br ^bb1(%5, %4 : i64, i64)
  ^bb3:  // pred: ^bb1
    llvm.return %2 : i64
  }
}


// -----// IR Dump After ConvertMathToLLVMPass (convert-math-to-llvm) //----- //
module attributes {llvm.data_layout = ""} {
  llvm.func @reduce(%arg0: i64, %arg1: i64, %arg2: i64) -> i64 {
    %0 = llvm.mlir.constant(0 : index) : i64
    llvm.br ^bb1(%arg0, %0 : i64, i64)
  ^bb1(%1: i64, %2: i64):  // 2 preds: ^bb0, ^bb2
    %3 = llvm.icmp "slt" %1, %arg1 : i64
    llvm.cond_br %3, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %4 = llvm.add %2, %arg2  : i64
    %5 = llvm.add %1, %arg2  : i64
    llvm.br ^bb1(%5, %4 : i64, i64)
  ^bb3:  // pred: ^bb1
    llvm.return %2 : i64
  }
}


// -----// IR Dump After ConvertIndexToLLVMPass (convert-index-to-llvm) //----- //
module attributes {llvm.data_layout = ""} {
  llvm.func @reduce(%arg0: i64, %arg1: i64, %arg2: i64) -> i64 {
    %0 = llvm.mlir.constant(0 : index) : i64
    llvm.br ^bb1(%arg0, %0 : i64, i64)
  ^bb1(%1: i64, %2: i64):  // 2 preds: ^bb0, ^bb2
    %3 = llvm.icmp "slt" %1, %arg1 : i64
    llvm.cond_br %3, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %4 = llvm.add %2, %arg2  : i64
    %5 = llvm.add %1, %arg2  : i64
    llvm.br ^bb1(%5, %4 : i64, i64)
  ^bb3:  // pred: ^bb1
    llvm.return %2 : i64
  }
}

```

The most interesting transformation here is the `convert-scf-to-cf` which converts the human readable structured control flow into a more machine code (amchine readable) like form. It transforms the for loop into multiple jump (namely the `cf.br`) statements as follows:

```
    %c0 = arith.constant 0 : index
    cf.br ^bb1(%arg0, %c0 : index, index)
  
  ^bb1(%0: index, %1: index):  // 2 preds: ^bb0, ^bb2
    %2 = arith.cmpi slt, %0, %arg1 : index
    cf.cond_br %2, ^bb2, ^bb3

  ^bb2:  // pred: ^bb1
    %3 = arith.addi %1, %arg2 : index
    %4 = arith.addi %0, %arg2 : index
    cf.br ^bb1(%4, %3 : index, index)

  ^bb3:  // pred: ^bb1
    return %1 : index
```

This transformation hence allows further optimizations within the loop that would've been much harder to detect and optimize were the loop was in structured form. 

We can then transform our code into LLVM IR as we did before using:

```
mlir-translate loop_add_opt.mlir --mlir-to-llvmir
```

to get the following output:

```
; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

declare ptr @malloc(i64)

declare void @free(ptr)

define i64 @reduce(i64 %0, i64 %1, i64 %2) {
  br label %4

4:                                                ; preds = %8, %3
  %5 = phi i64 [ %10, %8 ], [ %0, %3 ]
  %6 = phi i64 [ %9, %8 ], [ 0, %3 ]
  %7 = icmp slt i64 %5, %1
  br i1 %7, label %8, label %11

8:                                                ; preds = %4
  %9 = add i64 %6, %2
  %10 = add i64 %5, %2
  br label %4

11:                                               ; preds = %4
  ret i64 %6
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}

```

Here we can see that the for loop has been completely decomposed into break statements across the logic. 

Now we continue onto the compilation and execution of program as follows:

```
llc -filetype=obj loop_add.ll -o loop_add.o
$CC -shared loop_add.o -o libloop_add.so
```

And executing the code within Python as follows:

```
import ctypes

module = ctypes.CDLL('./libloop_add.so')

module.reduce.argtypes = [ctypes.c_int, ctypes.c_int, ctypes.c_int]
module.reduce.restype = ctypes.c_int

def reduce(start, stop, step):
    return module.reduce(start, stop, step)

print(reduce(1, 10, 1))
# Outputs: 45

```