func.func @loop_add_conditional(%lb: index, %ub: index, %step: index, %limit: index) -> (index) {
    %sum_0 = arith.constant 0 : index

    %sum = scf.for %iv = %lb to %ub step %step iter_args(%sum_iter = %sum_0) -> (index) {
        %conditional_val = arith.cmpi slt, %iv, %limit : index

        %sum_next = scf.if %conditional_val -> (index) {
            %res_value = arith.addi %sum_iter, %iv : index
            scf.yield %res_value: index
        } else {
            scf.yield %sum_iter: index
        }

        scf.yield %sum_next : index
    }

    return %sum : index
}

