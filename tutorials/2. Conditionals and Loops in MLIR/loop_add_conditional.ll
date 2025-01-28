; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

define i64 @reduce(i64 %0, i64 %1, i64 %2, i64 %3) {
  br label %5

5:                                                ; preds = %16, %4
  %6 = phi i64 [ %17, %16 ], [ %0, %4 ]
  %7 = phi i64 [ %15, %16 ], [ 0, %4 ]
  %8 = icmp slt i64 %6, %1
  br i1 %8, label %9, label %18

9:                                                ; preds = %5
  %10 = icmp slt i64 %6, %3
  br i1 %10, label %11, label %13

11:                                               ; preds = %9
  %12 = add i64 %7, %2
  br label %14

13:                                               ; preds = %9
  br label %14

14:                                               ; preds = %11, %13
  %15 = phi i64 [ %3, %13 ], [ %12, %11 ]
  br label %16

16:                                               ; preds = %14
  %17 = add i64 %6, %2
  br label %5

18:                                               ; preds = %5
  ret i64 %7
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
