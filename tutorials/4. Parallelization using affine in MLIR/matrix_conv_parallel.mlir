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
