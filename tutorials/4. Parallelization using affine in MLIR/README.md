# Introduction

Previously we got to know about looping dialects in MLIR and wrote a few examples using the `scf` dialect. However using `scf` is only one of the ways in which loops can be represented within MLIR. In this tutorial we'll learn how to make those loop parallel using `affine` dialect. 

# Parallelizing loops:

We take out previous example where we did the operation `sin(x)^2 + cos(y)^2` upon entire arrays and modify it to use `affine` dialect instead of `scf` as follows:

```
func.func @array_trig(%array_1: memref<1024xf64>, %array_2: memref<1024xf64>, %res_array: memref<1024xf64>, %lb: index, %ub: index, %step: index) -> () {
  affine.parallel (%iv) = (%lb) to (%ub) {
    %u = affine.load %array_1[%iv] : memref<1024xf64>
    %v = affine.load %array_2[%iv] : memref<1024xf64>

    %sin_value = math.sin %u : f64
    %cos_value = math.cos %v : f64

    %power = arith.constant 2 : i32
    %sin_sq = math.fpowi %sin_value, %power : f64, i32
    %cos_sq = math.fpowi %cos_value, %power : f64, i32

    %res_value = arith.addf %sin_sq, %cos_sq: f64

    affine.store %res_value, %res_array[%iv] : memref<1024xf64>
  }

  return
}
```

As we can see in the above example, the arguments and logic is the same as it was in previous, but the dialect has not changed to being `affine` specific. 

The main advantage of using `affine` is that 


### Program execution

We need the multiple passes when using `affine`. Some notable ones are:

- `affine-loop-normalize`:
- `lower-affine`:

The full set of optimization passes are listed below as a single command of `mlir-opt`:

```
mlir-opt --mlir-print-ir-after-all --inline -affine-loop-normalize -affine-parallelize -affine-super-vectorize --affine-scalrep -lower-affine -convert-vector-to-scf -convert-linalg-to-loops -lower-affine -convert-scf-to-openmp -convert-scf-to-cf -cse -convert-openmp-to-llvm -convert-linalg-to-llvm -convert-vector-to-llvm -convert-math-to-llvm -expand-strided-metadata -lower-affine -finalize-memref-to-llvm -convert-func-to-llvm -convert-index-to-llvm -reconcile-unrealized-casts --llvm-request-c-wrappers array_trig_parallel.mlir -o array_trig_parallel_opt.mlir
```

Now that we have transformed our logic into LLVM translatable dialect. We use `mlir-to-llvmir` to translate it completely into LLVM-IR as follows:

```
mlir-translate array_trig_parallel_opt.mlir --mlir-to-llvmir -o array_trig_parallel.ll
```

Now we compile the program using `llc` and make a shared object file using the conda provisioned `$CC` command:

```
llc -filetype=obj --relocation-model=pic array_trig_parallel.ll -o array_trig_parallel.o
$CC -shared -fPIC -lm -fopenmp array_trig_parallel.o -o libarray_trig_parallel.so
```

Note that here we've used the `-fopenmp` flag. This links the symbols within shared object code to thier respective internal OpenMP implementations.

Now we have the following Python script that uses `ctypes` to execute the function within the shared object.

```
import ctypes
import numpy as np

module = ctypes.CDLL('./libarray_trig_parallel.so')

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

### Symbol table:

Now let's take a look at the symbol table of the generated `.so` file.


# Nested parallization:

Futhermore a good usage of this dialect in practical world scenario is matrix convolutions which is heavily used in Machine Learning.

Following is an example of 2-D convolutions inspired by MLIR docs:

```
func.func @conv_2d(%input_matrix : memref<10x10xf32>, %conv_matrix : memref<3x3xf32>, %res_matrix : memref<8x8xf32>) -> () {

  affine.parallel (%x, %y) = (0, 0) to (8, 8) {
    %elem = affine.parallel (%kx, %ky) = (0, 0) to (2, 2) reduce ("addf") -> f32 {
      %inner_elem = affine.load %input_matrix[%x + %kx, %y + %ky] : memref<10x10xf32>
      %conv_elem = affine.load %conv_matrix[%kx, %ky] : memref<3x3xf32>
      %res_elem = arith.mulf %inner_elem, %conv_elem : f32
      affine.yield %res_elem : f32
    }
    affine.store %elem, %res_matrix[%x, %y] : memref<8x8xf32>
  }
  return
}

```

### Program execution:

We can use the same set of commands we used to compile our example earlier as follows:

```
mlir-opt --mlir-print-ir-after-all --inline -affine-loop-normalize -affine-parallelize -affine-super-vectorize --affine-scalrep -lower-affine -convert-vector-to-scf -convert-linalg-to-loops -lower-affine -convert-scf-to-openmp -convert-scf-to-cf -cse -convert-openmp-to-llvm -convert-linalg-to-llvm -convert-vector-to-llvm -convert-math-to-llvm -expand-strided-metadata -lower-affine -finalize-memref-to-llvm -convert-func-to-llvm -convert-index-to-llvm -reconcile-unrealized-casts --llvm-request-c-wrappers matrix_conv_parallel.mlir -o matrix_conv_parallel_opt.mlir
```

Translate it into LLVM-IR

```
mlir-translate matrix_conv_parallel_opt.mlir --mlir-to-llvmir -o matrix_conv_parallel.ll
```

And further compile it down to a shared object file:

```
llc -filetype=obj --relocation-model=pic matrix_conv_parallel.ll -o matrix_conv_parallel.o
$CC -shared -fPIC -lm -fopenmp matrix_conv_parallel.o -o libmatrix_conv_parallel.so
```

And use the following Python script to call the function using `ctypes`:

```
import ctypes
import numpy as np

module = ctypes.CDLL('./libmatrix_conv_parallel.so')

def as_memref_descriptor(arr, ty):
    intptr_t = getattr(ctypes, f"c_int{8 * ctypes.sizeof(ctypes.c_void_p)}")
    ty_ptr = ctypes.POINTER(ty)

    arg0 = ctypes.cast(arr.ctypes.data, ty_ptr)
    arg1 = arg0
    arg2 = intptr_t(0)

    shapes_arg = [intptr_t(x) for x in arr.shape]
    strides_arg = [intptr_t(x) for x in arr.strides]

    return arg0, arg1, arg2, *shapes_arg, *strides_arg

array_1 = np.ones(10 * 10, dtype=np.float64).reshape(10, 10)
conv_filter = np.arange(9, dtype=np.float64).reshape(3, 3)
res_array = np.zeros((8, 8), dtype=np.float64)

array_1_as_memref = as_memref_descriptor(array_1, ctypes.c_float)
conv_filter_as_memref = as_memref_descriptor(conv_filter, ctypes.c_float)
res_array_as_memref = as_memref_descriptor(res_array, ctypes.c_float)

argtypes = [
    *[type(x) for x in array_1_as_memref], 
    *[type(x) for x in conv_filter_as_memref], 
    *[type(x) for x in res_array_as_memref]]

module.conv_2d.argtypes = argtypes
module.conv_2d.restype = ctypes.c_float

def conv_2d(*args):
    return module.conv_2d(*args)

print(conv_2d(*array_1_as_memref, *conv_filter_as_memref, *res_array_as_memref))
np.set_printoptions(threshold=np.inf)
print(res_array)
```

# Conclusion

