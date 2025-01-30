# Introduction

In this tutorial we'll learn about `memref`s in MLIR. A `memref` (or a Memory Reference), as it's name suggest is simply a reference to a region of memory that can be allocated to read data from or write data into the memory region. The most common usage for a `memref` is to build array like structures within MLIR which can be associated with the array structures of a higher level language. For instance, as we'll see in future tutorials it is possible to represent NumPy arrays as `memref`s in MLIR. 

Now let's take alook at an example.

# Memref load: Index a NumPy array

`memref`s in itself is a type which can used just like every other once the inner dimensions and types are declared. Here we have an example of taking in `memref` named `%input_array` of size 1024 with `f32` datatype as an argument to a function and indexing it with a particular array index. 


```
func.func @array_index(%buffer: memref<1024xf32>, %array_idx: index) -> (f32) {
  %res = memref.load %buffer[%array_idx] : memref<1024xf32>
  return %res : f32
}
```

As we can see here, we're using `memref.load` which loads the 

Now we run the required MLIR passes over this logic using `mlir-opt`. The passes we require now are: `-finalize-memref-to-llvm`, `-convert-func-to-llvm`, `-convert-index-to-llvm` and `-reconcile-unrealized-casts`. Along with this we'll pass the flag `--mlir-print-ir-after-all` to see the effects of every single pass upon our dialect.

The complete command will look as follows:

```
mlir-opt --mlir-print-ir-after-all -finalize-memref-to-llvm -convert-func-to-llvm -convert-index-to-llvm -reconcile-unrealized-casts array_index.mlir -o array_index_opt.mlir
```

Upon running the command we get the following output:

```
// -----// IR Dump After FinalizeMemRefToLLVMConversionPass (finalize-memref-to-llvm) //----- //
module {
  func.func @array_index(%arg0: memref<1024xf32>, %arg1: index) -> f32 {
    %0 = builtin.unrealized_conversion_cast %arg1 : index to i64
    %1 = builtin.unrealized_conversion_cast %arg0 : memref<1024xf32> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %2 = llvm.extractvalue %1[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %3 = llvm.getelementptr %2[%0] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %4 = llvm.load %3 : !llvm.ptr -> f32
    return %4 : f32
  }
}


// -----// IR Dump After ConvertFuncToLLVMPass (convert-func-to-llvm) //----- //
module {
  llvm.func @array_index(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64) -> f32 {
    %0 = builtin.unrealized_conversion_cast %arg5 : i64 to index
    %1 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %2 = llvm.insertvalue %arg0, %1[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %3 = llvm.insertvalue %arg1, %2[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %4 = llvm.insertvalue %arg2, %3[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %5 = llvm.insertvalue %arg3, %4[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %6 = llvm.insertvalue %arg4, %5[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %7 = builtin.unrealized_conversion_cast %6 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> to memref<1024xf32>
    %8 = builtin.unrealized_conversion_cast %7 : memref<1024xf32> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %9 = builtin.unrealized_conversion_cast %0 : index to i64
    %10 = builtin.unrealized_conversion_cast %7 : memref<1024xf32> to !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %11 = llvm.extractvalue %10[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %12 = llvm.getelementptr %11[%9] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %13 = llvm.load %12 : !llvm.ptr -> f32
    llvm.return %13 : f32
  }
}


// -----// IR Dump After ConvertIndexToLLVMPass (convert-index-to-llvm) //----- //
module {
  llvm.func @array_index(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64) -> f32 {
    %0 = builtin.unrealized_conversion_cast %arg5 : i64 to index
    %1 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %2 = llvm.insertvalue %arg0, %1[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %3 = llvm.insertvalue %arg1, %2[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %4 = llvm.insertvalue %arg2, %3[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %5 = llvm.insertvalue %arg3, %4[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %6 = llvm.insertvalue %arg4, %5[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %7 = builtin.unrealized_conversion_cast %6 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> to memref<1024xf32>
    %8 = llvm.extractvalue %6[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %9 = llvm.getelementptr %8[%arg5] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %10 = llvm.load %9 : !llvm.ptr -> f32
    llvm.return %10 : f32
  }
}


// -----// IR Dump After ReconcileUnrealizedCasts (reconcile-unrealized-casts) //----- //
module {
  llvm.func @array_index(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: i64) -> f32 {
    %0 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %1 = llvm.insertvalue %arg0, %0[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %2 = llvm.insertvalue %arg1, %1[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %3 = llvm.insertvalue %arg2, %2[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %4 = llvm.insertvalue %arg3, %3[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %5 = llvm.insertvalue %arg4, %4[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %6 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %7 = llvm.getelementptr %6[%arg5] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %8 = llvm.load %7 : !llvm.ptr -> f32
    llvm.return %8 : f32
  }
}

```

Notice that in the `convert-func-to-llvm` pass, the argument `%arg0: memref<1024xf32>` gets converted into `%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64, %arg3: i64, %arg4: i64`. These are the `allocated`, `aligned`, `offset`, `shape`, `stride` whicch are explained as follows:

- `allocated`:
- `aligned`:
- `offset`:
- `shape`:
- `stride`: 

## Program compilation and execution

Next we use `mlir-translate` and compile the generated MLIR into LLVM IR using:

```
mlir-translate array_index_opt.mlir --mlir-to-llvmir -o array_index.ll
```

And continue execution of program just like our previous tutorials as follows:

```
llc -filetype=obj array_index.ll -o array_index.o
$CC -shared array_index.o -o libarray_index.so
```

And run the program within Python.

```
import ctypes
import numpy as np

module = ctypes.CDLL('./libarray_index.so')

# array_index.mlir:

# func.func @array_index(%buffer: memref<1024xf32>, %array_idx: index) -> (f32) {
#   %res = memref.load %buffer[%array_idx] : memref<1024xf32>
#   return %res : f32
# }

def array_index(allocated, aligned, offset, shape_1, stride_1, start):
    return module.array_index(allocated, aligned, offset, shape_1, stride_1, start)

def as_memref_descriptor(arr, ty):
    intptr_t = getattr(ctypes, f"c_int{8 * ctypes.sizeof(ctypes.c_void_p)}")
    N = arr.ndim

    ty_ptr = ctypes.POINTER(ty)

    arg0 = ctypes.cast(arr.ctypes.data, ty_ptr)
    arg1 = arg0
    arg2 = intptr_t(0)

    shapes_arg = [intptr_t(x) for x in arr.shape]
    strides_arg = [intptr_t(x) for x in arr.strides]

    return arg0, arg1, arg2, *shapes_arg, *strides_arg

# The array is a list of 1024 elements, all of which are 1.
array = np.arange(1024, dtype=np.float32)

array_as_memref = as_memref_descriptor(array, ctypes.c_float)

module.array_index.argtypes = [*[type(x) for x in array_as_memref], ctypes.c_int]
module.array_index.restype = ctypes.c_float

print(array_index(*array_as_memref,  105))
# Outputs 105.0
```

# Memref load: Sum of array elements example.

We can modify the `for` loop from our last tuotrial as follows:  

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

And run the program within Python:


```
import ctypes
import numpy as np

module = ctypes.CDLL('./libarray_sum.so')

def array_sum(allocated, aligned, offset, shape_1, stride_1, start, stop, step):
    return module.array_sum(allocated, aligned, offset, shape_1, stride_1, start, stop, step)

def as_memref_descriptor(arr, ty):
    intptr_t = getattr(ctypes, f"c_int{8 * ctypes.sizeof(ctypes.c_void_p)}")
    ty_ptr = ctypes.POINTER(ty)

    arg0 = ctypes.cast(arr.ctypes.data, ty_ptr)
    arg1 = arg0
    arg2 = intptr_t(0)

    shapes_arg = [intptr_t(x) for x in arr.shape]
    strides_arg = [intptr_t(x) for x in arr.strides]

    return arg0, arg1, arg2, *shapes_arg, *strides_arg

array = np.arange(1024, dtype=np.float32)

array_as_memref = as_memref_descriptor(array, ctypes.c_float)

module.array_sum.argtypes = [*[type(x) for x in array_as_memref], ctypes.c_long, ctypes.c_long, ctypes.c_long]
module.array_sum.restype = ctypes.c_float

print(module.array_sum.argtypes)
# [<class '__main__.LP_c_float'>, <class '__main__.LP_c_float'>, <class 'ctypes.c_long'>, <class 'ctypes.c_long'>, <class 'ctypes.c_long'>, <class 'ctypes.c_long'>, <class 'ctypes.c_long'>, <class 'ctypes.c_long'>]

print(array_sum(*array_as_memref, 0, 1023, 1))
# Outputs: 522754.0.0

```

# Memref store and return: (Sin(x))^2 + (Cos(y))^2 upon arrays

Now we move onto a more complex example that does the operation `sin(x)^2 + cos(y)^2` upon entire arrays and saves the result within the resulting array inplace. This would look as follows: 

```
func.func @array_trig(%array_1: memref<1024xf64>, %array_2: memref<1024xf64>, %res_array: memref<1024xf64>, %lb: index, %ub: index, %step: index) -> () {

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

  return
}

```

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
import ctypes
import numpy as np

module = ctypes.CDLL('./libarray_trig.so')

def as_memref_descriptor(arr, ty):
    intptr_t = getattr(ctypes, f"c_int{8 * ctypes.sizeof(ctypes.c_void_p)}")
    ty_ptr = ctypes.POINTER(ty)

    arg0 = ctypes.cast(arr.ctypes.data, ty_ptr)
    arg1 = arg0
    arg2 = intptr_t(0)

    shapes_arg = [intptr_t(x) for x in arr.shape]
    strides_arg = [intptr_t(x) for x in arr.strides]

    return arg0, arg1, arg2, *shapes_arg, *strides_arg

array_1 = np.arange(1024, dtype=np.float64)
array_2 = np.arange(1024, dtype=np.float64)
res_array = np.zeros(1024, dtype=np.float64)

array_1_as_memref = as_memref_descriptor(array_1, ctypes.c_double)
array_2_as_memref = as_memref_descriptor(array_2, ctypes.c_double)
res_array_as_memref = as_memref_descriptor(res_array, ctypes.c_double)

module.array_trig.argtypes = [
    *[type(x) for x in array_1_as_memref], 
    *[type(x) for x in array_2_as_memref], 
    *[type(x) for x in res_array_as_memref], 
    ctypes.c_long, ctypes.c_long, ctypes.c_long]

module.array_trig.restype = ctypes.c_double

def array_trig(*args):
    return module.array_trig(*args)

print(array_trig(*array_1_as_memref, *array_2_as_memref, *res_array_as_memref, 0, 1024, 1))

print(res_array)

print(np.allclose(res_array, np.sin(array_1) ** 2 + np.cos(array_2) ** 2))

```
