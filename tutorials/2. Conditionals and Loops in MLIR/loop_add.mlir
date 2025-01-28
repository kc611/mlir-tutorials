func.func @loop_add(%lb: index, %ub: index, %step: index) -> (index) {
    %sum_0 = arith.constant 0 : index

    %sum = scf.for %iv = %lb to %ub step %step iter_args(%sum_iter = %sum_0) -> (index) {
        %sum_next = arith.addi %sum_iter, %iv : index
        scf.yield %sum_next : index
    }

    return %sum : index
}
