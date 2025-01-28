# Introduction

In this tutorial we'll learn about `memref`s in MLIR. A `memref` (or a Memory Reference), as it's name suggest is simply a reference to a region of memory that can be allocated to read data from or write data into the memory region. The most common usage for a `memref` is to build array like structures within MLIR which can be associated with the array structures of a higher level language. For instance, as we'll see in future tutorials it is possible to represent NumPy arrays as `memref`s in MLIR. 

Now let's take alook at an example.

# Memref load: Sum of array elements example.

`memref`s in itself is a type which can used just like every other once the inner dimensions and types are declared. Here we have an example of taking in `memref` named `%input_array` of size 1024 with `f32` datatype as an argument to a function and summing up all elements within the given boundsof the `memref`. We can modify the `for` loop from our last tuotrial as follows:  

```
func.func @array_sum(%input_array: memref<1024xf32>, %lb: index, %ub: index, %step: index) -> (f32) {

  %sum_0 = arith.constant 0.0 : f32

  %sum = scf.for %loop_index = %lb to %ub step %step iter_args(%sum_iter = %sum_0) -> (f32) {
    %t = memref.load %input_array[%loop_index] : memref<1024xf32>
    %sum_next = arith.addf %sum_iter, %t : f32
    scf.yield %sum_next : f32
  }

  return %sum : f32
}

```

As you can see instead of adding the index for the loop we're instead loading the value within the `memref` using `memref.load` and using `arith.addf` upon the generated value and the `%sum_iter` and yeild the final sum as we did last time. 

Now we run the required MLIR passes over this logic using `mlir-opt`. The passes we require now are: `-convert-scf-to-cf`, `-convert-math-to-llvm`, `-finalize-memref-to-llvm`, `-convert-func-to-llvm`, `-convert-index-to-llvm` and `-reconcile-unrealized-casts`. Along with this we'll pass the flag `--mlir-print-ir-after-all` to see the effects of every single pass upon our dialect.

The complete command will look as follows:

```
mlir-opt --mlir-print-ir-after-all -convert-scf-to-cf -convert-math-to-llvm -finalize-memref-to-llvm -convert-func-to-llvm -convert-index-to-llvm -reconcile-unrealized-casts array_sum.mlir -o array_sum_opt.mlir
```

Upon running the command we get the following output:

```
// -----// IR Dump After SCFToControlFlow (convert-scf-to-cf) //----- //
module {
  func.func @array_sum(%arg0: memref<1024xf32>, %arg1: index, %arg2: index, %arg3: index) -> f32 {
    %cst = arith.constant 0.000000e+00 : f32
    cf.br ^bb1(%arg1, %cst : index, f32)
  ^bb1(%0: index, %1: f32):  // 2 preds: ^bb0, ^bb2
    %2 = arith.cmpi slt, %0, %arg2 : index
    cf.cond_br %2, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %3 = memref.load %arg0[%0] : memref<1024xf32>
    %4 = arith.addf %1, %3 : f32
    %5 = arith.addi %0, %arg3 : index
    cf.br ^bb1(%5, %4 : index, f32)
  ^bb3:  // pred: ^bb1
    return %1 : f32
  }
}


// -----// IR Dump After ConvertMathToLLVMPass (convert-math-to-llvm) //----- //
module {
  func.func @array_sum(%arg0: memref<1024xf32>, %arg1: index, %arg2: index, %arg3: index) -> f32 {
    %cst = arith.constant 0.000000e+00 : f32
    cf.br ^bb1(%arg1, %cst : index, f32)
  ^bb1(%0: index, %1: f32):  // 2 preds: ^bb0, ^bb2
    %2 = arith.cmpi slt, %0, %arg2 : index
    cf.cond_br %2, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %3 = memref.load %arg0[%0] : memref<1024xf32>
    %4 = arith.addf %1, %3 : f32
    %5 = arith.addi %0, %arg3 : index
    cf.br ^bb1(%5, %4 : index, f32)
  ^bb3:  // pred: ^bb1
    return %1 : f32
  }
}


// -----// IR Dump After FinalizeMemRefToLLVMConversionPass (finalize-memref-to-llvm) //----- //
module {
  func.func @array_sum(%arg0: memref<1024xf32>, %arg1: index, %arg2: index, %arg3: index) -> f32 {
    %0 = builtin.unrealized_conversion_cast %arg0 : memref<1024xf32> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %cst = arith.constant 0.000000e+00 : f32
    cf.br ^bb1(%arg1, %cst : index, f32)
  ^bb1(%1: index, %2: f32):  // 2 preds: ^bb0, ^bb2
    %3 = builtin.unrealized_conversion_cast %1 : index to i64
    %4 = arith.cmpi slt, %1, %arg2 : index
    cf.cond_br %4, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %5 = llvm.extractvalue %0[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %6 = llvm.getelementptr %5[%3] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %7 = llvm.load %6 : !llvm.ptr -> f32
    %8 = arith.addf %2, %7 : f32
    %9 = arith.addi %1, %arg3 : index
    cf.br ^bb1(%9, %8 : index, f32)
  ^bb3:  // pred: ^bb1
    return %2 : f32
  }
}


// -----// IR Dump After ConvertFuncToLLVMPass (convert-func-to-llvm) //----- //
module {
  llvm.func @array_sum(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64, %arg6: i64, %arg7: i64) -> f32 {
    %0 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %1 = llvm.insertvalue %arg0, %0[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %2 = llvm.insertvalue %arg1, %1[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %3 = llvm.insertvalue %arg2, %2[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %4 = llvm.insertvalue %arg3, %3[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %5 = llvm.insertvalue %arg4, %4[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %6 = builtin.unrealized_conversion_cast %5 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> to memref<1024xf32>
    %7 = builtin.unrealized_conversion_cast %6 : memref<1024xf32> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %8 = builtin.unrealized_conversion_cast %6 : memref<1024xf32> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %9 = llvm.mlir.constant(0.000000e+00 : f32) : f32
    llvm.br ^bb1(%arg5, %9 : i64, f32)
  ^bb1(%10: i64, %11: f32):  // 2 preds: ^bb0, ^bb2
    %12 = builtin.unrealized_conversion_cast %10 : i64 to index
    %13 = builtin.unrealized_conversion_cast %12 : index to i64
    %14 = llvm.icmp "slt" %10, %arg6 : i64
    llvm.cond_br %14, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %15 = llvm.extractvalue %8[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %16 = llvm.getelementptr %15[%13] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %17 = llvm.load %16 : !llvm.ptr -> f32
    %18 = llvm.fadd %11, %17  : f32
    %19 = llvm.add %10, %arg7 : i64
    llvm.br ^bb1(%19, %18 : i64, f32)
  ^bb3:  // pred: ^bb1
    llvm.return %11 : f32
  }
}


// -----// IR Dump After ConvertIndexToLLVMPass (convert-index-to-llvm) //----- //
module {
  llvm.func @array_sum(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64, %arg6: i64, %arg7: i64) -> f32 {
    %0 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %1 = llvm.insertvalue %arg0, %0[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %2 = llvm.insertvalue %arg1, %1[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %3 = llvm.insertvalue %arg2, %2[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %4 = llvm.insertvalue %arg3, %3[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %5 = llvm.insertvalue %arg4, %4[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %6 = builtin.unrealized_conversion_cast %5 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> to memref<1024xf32>
    %7 = llvm.mlir.constant(0.000000e+00 : f32) : f32
    llvm.br ^bb1(%arg5, %7 : i64, f32)
  ^bb1(%8: i64, %9: f32):  // 2 preds: ^bb0, ^bb2
    %10 = builtin.unrealized_conversion_cast %8 : i64 to index
    %11 = llvm.icmp "slt" %8, %arg6 : i64
    llvm.cond_br %11, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %12 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %13 = llvm.getelementptr %12[%8] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %14 = llvm.load %13 : !llvm.ptr -> f32
    %15 = llvm.fadd %9, %14  : f32
    %16 = llvm.add %8, %arg7 : i64
    llvm.br ^bb1(%16, %15 : i64, f32)
  ^bb3:  // pred: ^bb1
    llvm.return %9 : f32
  }
}


// -----// IR Dump After ReconcileUnrealizedCasts (reconcile-unrealized-casts) //----- //
module {
  llvm.func @array_sum(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64, %arg6: i64, %arg7: i64) -> f32 {
    %0 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %1 = llvm.insertvalue %arg0, %0[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %2 = llvm.insertvalue %arg1, %1[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %3 = llvm.insertvalue %arg2, %2[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %4 = llvm.insertvalue %arg3, %3[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %5 = llvm.insertvalue %arg4, %4[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %6 = llvm.mlir.constant(0.000000e+00 : f32) : f32
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
```

## Program compilation and execution

Next we use `mlir-translate` and compile the generated MLIR into LLVM IR using:

```
mlir-translate array_sum_opt.mlir --mlir-to-llvmir -o array_sum.ll
```

And continue execution of program just like our previous tutorials as follows:

```
llc -filetype=obj array_sum.ll -o array_sum.o
$CC -shared array_sum.o -o libarray_sum.so
```

And run the program within Python, notice that within Python we have to use lists to represent the `memref`


```
import ctypes

module = ctypes.CDLL('./libarray_sum.so')

module.array_sum.argtypes = [ctypes.Array, ctypes.c_int, ctypes.c_int, ctypes.c_int]
module.array_sum.restype = ctypes.c_float

def array_sum(array, start, stop, step):
    return module.array_sum(array, start, stop, step)

# The array is a list of 1024 elements, all of which are 1.
array = [1.0] * 1024

array = (ctypes.c_float * len(array))(*array)

print(array_sum(array, 0, 1024, 1))
# Outputs: 1024.0

```

# Memref store: (Sin(x))^2 + (Cos(y))^2 upon arrays

Now we move onto a more complex example that does the operation `sin(x)^2 + cos(y)^2` upon entire arrays. This would look as follows: 

```
func.func @array_sine(%array_1: memref<1024xf64>, %array_2: memref<1024xf64>, %lb: index, %ub: index, %step: index) -> (memref<1024xf64>) {

  %res_array = memref.alloc() : memref<1024xf64>

  scf.for %iv = %lb to %ub step %step iter_args() -> () {
    %u = memref.load %array_1[%iv] : memref<1024xf64>
    %v = memref.load %array_2[%iv] : memref<1024xf64>

    %sin_value = math.sin %u : f64
    %cos_value = math.cos %v : f64

    %power = arith.constant 2 : i32
    %sin_sq = math.fpowi %sin_value, %power : f64, i32
    %cos_sq = math.fpowi %cos_value, %power : f64, i32

    %res_value = arith.addf %sin_sq, %cos_sq: f64

    memref.store %res_value, %res_array[%iv] : memref<1024xf64>
  }

  return %res_array: memref<1024xf64>
}

```

Here you can notice we're declaring a new `memref` called `%result_array` using `memref.alloca` which allocates a region of memory for the declared `memref`. Further down the line we do the required `memref.load` from the respective arrays and finally a `memref.store` of the final value within the `%result_array`

Now we execute the same set of commands upon this example:

```
mlir-opt --mlir-print-ir-after-all -convert-scf-to-cf -convert-math-to-llvm -finalize-memref-to-llvm -convert-func-to-llvm -convert-index-to-llvm -reconcile-unrealized-casts array_trig.mlir -o array_trig_opt.mlir
```

And convert it into LLVM IR

```
mlir-translate array_trig_opt.mlir --mlir-to-llvmir -o array_trig.ll
```

And continue execution of program just like our previous tutorials as follows:

```
llc -filetype=obj array_trig.ll -o array_trig.o
$CC -shared array_trig.o -o libarray_trig.so
```

And run the program within Python:

```

```
