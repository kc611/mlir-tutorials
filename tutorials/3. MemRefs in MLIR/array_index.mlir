func.func @array_index(%buffer: memref<1024xf32>, %array_idx: index) -> (f32) {

  %res = memref.load %buffer[%array_idx] : memref<1024xf32>

  return %res : f32
}

