```
mlir-opt --mlir-print-ir-after-all --inline -affine-loop-normalize -affine-parallelize -affine-super-vectorize --affine-scalrep -lower-affine -convert-vector-to-scf -convert-linalg-to-loops -lower-affine -convert-scf-to-openmp -convert-scf-to-cf -cse -convert-openmp-to-llvm -convert-linalg-to-llvm -convert-vector-to-llvm -convert-math-to-llvm -expand-strided-metadata -lower-affine -finalize-memref-to-llvm -convert-func-to-llvm -convert-index-to-llvm -reconcile-unrealized-casts --llvm-request-c-wrappers array_trig_parallel.mlir -o array_trig_parallel_opt.mlir
```

```
mlir-translate array_trig_parallel_opt.mlir --mlir-to-llvmir -o array_trig_parallel.ll
```
```
llc -filetype=obj --relocation-model=picarray_trig_parallel.ll -o array_trig_parallel.o
$CC -shared -fPIC array_trig_parallel.o -o libarray_trig_parallel.so
```


```
mlir-opt --mlir-print-ir-after-all --inline -affine-loop-normalize -affine-parallelize -affine-super-vectorize --affine-scalrep -lower-affine -convert-vector-to-scf -convert-linalg-to-loops -lower-affine -convert-scf-to-openmp -convert-scf-to-cf -cse -convert-openmp-to-llvm -convert-linalg-to-llvm -convert-vector-to-llvm -convert-math-to-llvm -expand-strided-metadata -lower-affine -finalize-memref-to-llvm -convert-func-to-llvm -convert-index-to-llvm -reconcile-unrealized-casts --llvm-request-c-wrappers matrix_conv_parallel.mlir -o matrix_conv_parallel_opt.mlir
```

```
mlir-translate matrix_conv_parallel_opt.mlir --mlir-to-llvmir -o matrix_conv_parallel.ll
```
```
llc -filetype=obj --relocation-model=pic matrix_conv_parallel.ll -o matrix_conv_parallel.o
$CC -shared -fPIC matrix_conv_parallel.o -o libmatrix_conv_parallel.so
```
