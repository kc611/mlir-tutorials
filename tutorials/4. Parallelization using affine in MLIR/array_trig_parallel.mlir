
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

