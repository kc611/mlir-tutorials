func.func @test_fma() -> f64 {
  %arg1 = arith.constant 1.0 : f64
  %arg2 = arith.constant 2.0 : f64
  %arg3 = arith.constant 3.0 : f64
  %res = math.fma %arg1, %arg2, %arg3: f64
  func.return %res : f64
}
