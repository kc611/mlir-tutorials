```
mlir-opt --mlir-print-ir-after-all --inline -affine-loop-normalize -affine-parallelize -affine-super-vectorize --affine-scalrep -lower-affine -convert-vector-to-scf -convert-linalg-to-loops -lower-affine -convert-scf-to-openmp -convert-scf-to-cf -cse -convert-openmp-to-llvm -convert-linalg-to-llvm -convert-vector-to-llvm -convert-math-to-llvm -expand-strided-metadata -lower-affine -finalize-memref-to-llvm -convert-func-to-llvm -convert-index-to-llvm -reconcile-unrealized-casts --llvm-request-c-wrappers matrix_conv_parallel.mlir -o matrix_conv_parallel_opt.mlir
```

```
mlir-translate matrix_conv_parallel_opt.mlir --mlir-to-llvmir -o matrix_conv_parallel.ll
```
```
llc -filetype=obj matrix_conv_parallel.ll -o matrix_conv_parallel.o
$CC -shared matrix_conv_parallel.o -o libmatrix_conv_parallel.so
```
