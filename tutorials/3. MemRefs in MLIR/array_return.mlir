func.func @array_index(%buffer: memref<1024xf32>) -> (memref<1024xf32>) {
    %res_value = arith.constant 10.0 : f32
    %array_idx = arith.constant 0.0 : index
    memref.store res_value, %buffer[%array_idx]: memref<1024xf32>
    return %buffer : memref<1024xf32>
}

