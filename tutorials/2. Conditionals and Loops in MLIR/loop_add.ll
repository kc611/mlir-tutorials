; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define i64 @loop_add(i64 %0, i64 %1, i64 %2) {
  br label %4

4:                                                ; preds = %8, %3
  %5 = phi i64 [ %10, %8 ], [ %0, %3 ]
  %6 = phi i64 [ %9, %8 ], [ 0, %3 ]
  %7 = icmp slt i64 %5, %1
  br i1 %7, label %8, label %11

8:                                                ; preds = %4
  %9 = add i64 %6, %5
  %10 = add i64 %5, %2
  br label %4

11:                                               ; preds = %4
  ret i64 %6
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
