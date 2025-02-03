; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

%struct.ident_t = type { i32, i32, i32, i32, ptr }

@0 = private unnamed_addr constant [23 x i8] c";unknown;unknown;0;0;;\00", align 1
@1 = private unnamed_addr constant %struct.ident_t { i32 0, i32 2, i32 0, i32 22, ptr @0 }, align 8
@2 = private unnamed_addr constant %struct.ident_t { i32 0, i32 66, i32 0, i32 22, ptr @0 }, align 8
@3 = private unnamed_addr constant %struct.ident_t { i32 0, i32 18, i32 0, i32 22, ptr @0 }, align 8
@.gomp_critical_user_.reduction.var = common global [8 x i32] zeroinitializer, align 4

declare ptr @malloc(i64)

declare void @free(ptr)

define void @conv_2d(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, i64 %5, i64 %6, ptr %7, ptr %8, i64 %9, i64 %10, i64 %11, i64 %12, i64 %13, ptr %14, ptr %15, i64 %16, i64 %17, i64 %18, i64 %19, i64 %20) {
  %structArg76 = alloca { ptr, ptr, ptr }, align 8
  br label %entry

entry:                                            ; preds = %21
  %omp_global_thread_num = call i32 @__kmpc_global_thread_num(ptr @1)
  br label %omp_parallel

omp_parallel:                                     ; preds = %entry
  %gep_77 = getelementptr { ptr, ptr, ptr }, ptr %structArg76, i32 0, i32 0
  store ptr %1, ptr %gep_77, align 8
  %gep_78 = getelementptr { ptr, ptr, ptr }, ptr %structArg76, i32 0, i32 1
  store ptr %8, ptr %gep_78, align 8
  %gep_79 = getelementptr { ptr, ptr, ptr }, ptr %structArg76, i32 0, i32 2
  store ptr %15, ptr %gep_79, align 8
  call void (ptr, i32, ptr, ...) @__kmpc_fork_call(ptr @1, i32 1, ptr @conv_2d..omp_par.1, ptr %structArg76)
  br label %omp.par.outlined.exit73

omp.par.outlined.exit73:                          ; preds = %omp_parallel
  br label %omp.par.exit.split

omp.par.exit.split:                               ; preds = %omp.par.outlined.exit73
  ret void
}

; Function Attrs: norecurse nounwind
define internal void @conv_2d..omp_par.1(ptr noalias %tid.addr, ptr noalias %zero.addr, ptr %0) #0 {
omp.par.entry:
  %gep_ = getelementptr { ptr, ptr, ptr }, ptr %0, i32 0, i32 0
  %loadgep_ = load ptr, ptr %gep_, align 8
  %gep_1 = getelementptr { ptr, ptr, ptr }, ptr %0, i32 0, i32 1
  %loadgep_2 = load ptr, ptr %gep_1, align 8
  %gep_3 = getelementptr { ptr, ptr, ptr }, ptr %0, i32 0, i32 2
  %loadgep_4 = load ptr, ptr %gep_3, align 8
  %structArg = alloca { ptr, ptr, ptr, ptr, ptr }, align 8
  %.reloaded = alloca i64, align 8
  %.reloaded56 = alloca i64, align 8
  %tid.addr.local = alloca i32, align 4
  %1 = load i32, ptr %tid.addr, align 4
  store i32 %1, ptr %tid.addr.local, align 4
  %tid = load i32, ptr %tid.addr.local, align 4
  %p.lastiter67 = alloca i32, align 4
  %p.lowerbound68 = alloca i64, align 8
  %p.upperbound69 = alloca i64, align 8
  %p.stride70 = alloca i64, align 8
  br label %omp.par.region

omp.par.region:                                   ; preds = %omp.par.entry
  br label %omp.par.region1

omp.par.region1:                                  ; preds = %omp.par.region
  br label %omp_loop.preheader

omp_loop.preheader:                               ; preds = %omp.par.region1
  br label %omp_collapsed.preheader57

omp_collapsed.preheader57:                        ; preds = %omp_loop.preheader
  store i64 0, ptr %p.lowerbound68, align 4
  store i64 63, ptr %p.upperbound69, align 4
  store i64 1, ptr %p.stride70, align 4
  %omp_global_thread_num71 = call i32 @__kmpc_global_thread_num(ptr @1)
  call void @__kmpc_for_static_init_8u(ptr @1, i32 %omp_global_thread_num71, i32 34, ptr %p.lastiter67, ptr %p.lowerbound68, ptr %p.upperbound69, ptr %p.stride70, i64 1, i64 0)
  %2 = load i64, ptr %p.lowerbound68, align 4
  %3 = load i64, ptr %p.upperbound69, align 4
  %4 = sub i64 %3, %2
  %5 = add i64 %4, 1
  br label %omp_collapsed.header58

omp_collapsed.header58:                           ; preds = %omp_collapsed.inc61, %omp_collapsed.preheader57
  %omp_collapsed.iv64 = phi i64 [ 0, %omp_collapsed.preheader57 ], [ %omp_collapsed.next66, %omp_collapsed.inc61 ]
  br label %omp_collapsed.cond59

omp_collapsed.cond59:                             ; preds = %omp_collapsed.header58
  %omp_collapsed.cmp65 = icmp ult i64 %omp_collapsed.iv64, %5
  br i1 %omp_collapsed.cmp65, label %omp_collapsed.body60, label %omp_collapsed.exit62

omp_collapsed.exit62:                             ; preds = %omp_collapsed.cond59
  call void @__kmpc_for_static_fini(ptr @1, i32 %omp_global_thread_num71)
  %omp_global_thread_num72 = call i32 @__kmpc_global_thread_num(ptr @1)
  call void @__kmpc_barrier(ptr @2, i32 %omp_global_thread_num72)
  br label %omp_collapsed.after63

omp_collapsed.after63:                            ; preds = %omp_collapsed.exit62
  br label %omp_loop.after

omp_loop.after:                                   ; preds = %omp_collapsed.after63
  br label %omp.region.cont

omp.region.cont:                                  ; preds = %omp_loop.after
  br label %omp.par.pre_finalize

omp.par.pre_finalize:                             ; preds = %omp.region.cont
  br label %omp.par.outlined.exit73.exitStub

omp_collapsed.body60:                             ; preds = %omp_collapsed.cond59
  %6 = add i64 %omp_collapsed.iv64, %2
  %7 = urem i64 %6, 8
  %8 = udiv i64 %6, 8
  br label %omp_loop.body

omp_loop.body:                                    ; preds = %omp_collapsed.body60
  %9 = mul i64 %8, 1
  %10 = add i64 %9, 0
  br label %omp_loop.preheader2

omp_loop.preheader2:                              ; preds = %omp_loop.body
  br label %omp_loop.body5

omp_loop.body5:                                   ; preds = %omp_loop.preheader2
  %11 = mul i64 %7, 1
  %12 = add i64 %11, 0
  br label %omp.wsloop.region

omp.wsloop.region:                                ; preds = %omp_loop.body5
  %13 = call ptr @llvm.stacksave()
  br label %omp.wsloop.region13

omp.wsloop.region13:                              ; preds = %omp.wsloop.region
  %14 = alloca float, i64 1, align 4
  store float 0.000000e+00, ptr %14, align 4
  %omp_global_thread_num15 = call i32 @__kmpc_global_thread_num(ptr @1)
  store i64 %10, ptr %.reloaded, align 4
  store i64 %12, ptr %.reloaded56, align 4
  br label %omp_parallel

omp_parallel:                                     ; preds = %omp.wsloop.region13
  %gep_.reloaded = getelementptr { ptr, ptr, ptr, ptr, ptr }, ptr %structArg, i32 0, i32 0
  store ptr %.reloaded, ptr %gep_.reloaded, align 8
  %gep_.reloaded56 = getelementptr { ptr, ptr, ptr, ptr, ptr }, ptr %structArg, i32 0, i32 1
  store ptr %.reloaded56, ptr %gep_.reloaded56, align 8
  %gep_5 = getelementptr { ptr, ptr, ptr, ptr, ptr }, ptr %structArg, i32 0, i32 2
  store ptr %14, ptr %gep_5, align 8
  %gep_74 = getelementptr { ptr, ptr, ptr, ptr, ptr }, ptr %structArg, i32 0, i32 3
  store ptr %loadgep_, ptr %gep_74, align 8
  %gep_75 = getelementptr { ptr, ptr, ptr, ptr, ptr }, ptr %structArg, i32 0, i32 4
  store ptr %loadgep_2, ptr %gep_75, align 8
  call void (ptr, i32, ptr, ...) @__kmpc_fork_call(ptr @1, i32 1, ptr @conv_2d..omp_par, ptr %structArg)
  br label %omp.par.outlined.exit

omp.par.outlined.exit:                            ; preds = %omp_parallel
  br label %omp.par.exit21.split

omp.par.exit21.split:                             ; preds = %omp.par.outlined.exit
  %15 = load float, ptr %14, align 4
  %16 = mul i64 %10, 8
  %17 = add i64 %16, %12
  %18 = getelementptr float, ptr %loadgep_4, i64 %17
  store float %15, ptr %18, align 4
  call void @llvm.stackrestore(ptr %13)
  br label %omp.wsloop.region14

omp.wsloop.region14:                              ; preds = %omp.par.exit21.split
  br label %omp.region.cont12

omp.region.cont12:                                ; preds = %omp.wsloop.region14
  br label %omp_loop.after8

omp_loop.after8:                                  ; preds = %omp.region.cont12
  br label %omp_collapsed.inc61

omp_collapsed.inc61:                              ; preds = %omp_loop.after8
  %omp_collapsed.next66 = add nuw i64 %omp_collapsed.iv64, 1
  br label %omp_collapsed.header58

omp.par.outlined.exit73.exitStub:                 ; preds = %omp.par.pre_finalize
  ret void
}

; Function Attrs: norecurse nounwind
define internal void @conv_2d..omp_par(ptr noalias %tid.addr16, ptr noalias %zero.addr17, ptr %0) #0 {
omp.par.entry18:
  %gep_.reloaded = getelementptr { ptr, ptr, ptr, ptr, ptr }, ptr %0, i32 0, i32 0
  %loadgep_.reloaded = load ptr, ptr %gep_.reloaded, align 8
  %gep_.reloaded56 = getelementptr { ptr, ptr, ptr, ptr, ptr }, ptr %0, i32 0, i32 1
  %loadgep_.reloaded56 = load ptr, ptr %gep_.reloaded56, align 8
  %gep_ = getelementptr { ptr, ptr, ptr, ptr, ptr }, ptr %0, i32 0, i32 2
  %loadgep_ = load ptr, ptr %gep_, align 8
  %gep_1 = getelementptr { ptr, ptr, ptr, ptr, ptr }, ptr %0, i32 0, i32 3
  %loadgep_2 = load ptr, ptr %gep_1, align 8
  %gep_3 = getelementptr { ptr, ptr, ptr, ptr, ptr }, ptr %0, i32 0, i32 4
  %loadgep_4 = load ptr, ptr %gep_3, align 8
  %tid.addr.local22 = alloca i32, align 4
  %1 = load i32, ptr %tid.addr16, align 4
  store i32 %1, ptr %tid.addr.local22, align 4
  %tid23 = load i32, ptr %tid.addr.local22, align 4
  %2 = load i64, ptr %loadgep_.reloaded, align 4
  %3 = load i64, ptr %loadgep_.reloaded56, align 4
  %4 = alloca float, align 4
  %p.lastiter = alloca i32, align 4
  %p.lowerbound = alloca i64, align 8
  %p.upperbound = alloca i64, align 8
  %p.stride = alloca i64, align 8
  %red.array = alloca [1 x ptr], align 8
  br label %omp.par.region19

omp.par.region19:                                 ; preds = %omp.par.entry18
  br label %omp.par.region27

omp.par.region27:                                 ; preds = %omp.par.region19
  store float 0.000000e+00, ptr %4, align 4
  br label %omp_loop.preheader28

omp_loop.preheader28:                             ; preds = %omp.par.region27
  br label %omp_collapsed.preheader

omp_collapsed.preheader:                          ; preds = %omp_loop.preheader28
  store i64 0, ptr %p.lowerbound, align 4
  store i64 3, ptr %p.upperbound, align 4
  store i64 1, ptr %p.stride, align 4
  %omp_global_thread_num52 = call i32 @__kmpc_global_thread_num(ptr @1)
  call void @__kmpc_for_static_init_8u(ptr @1, i32 %omp_global_thread_num52, i32 34, ptr %p.lastiter, ptr %p.lowerbound, ptr %p.upperbound, ptr %p.stride, i64 1, i64 0)
  %5 = load i64, ptr %p.lowerbound, align 4
  %6 = load i64, ptr %p.upperbound, align 4
  %7 = sub i64 %6, %5
  %8 = add i64 %7, 1
  br label %omp_collapsed.header

omp_collapsed.header:                             ; preds = %omp_collapsed.inc, %omp_collapsed.preheader
  %omp_collapsed.iv = phi i64 [ 0, %omp_collapsed.preheader ], [ %omp_collapsed.next, %omp_collapsed.inc ]
  br label %omp_collapsed.cond

omp_collapsed.cond:                               ; preds = %omp_collapsed.header
  %omp_collapsed.cmp = icmp ult i64 %omp_collapsed.iv, %8
  br i1 %omp_collapsed.cmp, label %omp_collapsed.body, label %omp_collapsed.exit

omp_collapsed.exit:                               ; preds = %omp_collapsed.cond
  call void @__kmpc_for_static_fini(ptr @1, i32 %omp_global_thread_num52)
  %omp_global_thread_num53 = call i32 @__kmpc_global_thread_num(ptr @1)
  call void @__kmpc_barrier(ptr @2, i32 %omp_global_thread_num53)
  br label %omp_collapsed.after

omp_collapsed.after:                              ; preds = %omp_collapsed.exit
  br label %omp_loop.after34

omp_loop.after34:                                 ; preds = %omp_collapsed.after
  %red.array.elem.0 = getelementptr inbounds [1 x ptr], ptr %red.array, i64 0, i64 0
  store ptr %4, ptr %red.array.elem.0, align 8
  %omp_global_thread_num54 = call i32 @__kmpc_global_thread_num(ptr @3)
  %reduce = call i32 @__kmpc_reduce(ptr @3, i32 %omp_global_thread_num54, i32 1, i64 8, ptr %red.array, ptr @.omp.reduction.func, ptr @.gomp_critical_user_.reduction.var)
  switch i32 %reduce, label %reduce.finalize [
    i32 1, label %reduce.switch.nonatomic
    i32 2, label %reduce.switch.atomic
  ]

reduce.switch.atomic:                             ; preds = %omp_loop.after34
  %9 = load float, ptr %4, align 4
  %10 = atomicrmw fadd ptr %loadgep_, float %9 monotonic, align 4
  br label %reduce.finalize

reduce.switch.nonatomic:                          ; preds = %omp_loop.after34
  %red.value.0 = load float, ptr %loadgep_, align 4
  %red.private.value.0 = load float, ptr %4, align 4
  %11 = fadd float %red.value.0, %red.private.value.0
  store float %11, ptr %loadgep_, align 4
  call void @__kmpc_end_reduce(ptr @3, i32 %omp_global_thread_num54, ptr @.gomp_critical_user_.reduction.var)
  br label %reduce.finalize

reduce.finalize:                                  ; preds = %reduce.switch.atomic, %reduce.switch.nonatomic, %omp_loop.after34
  %omp_global_thread_num55 = call i32 @__kmpc_global_thread_num(ptr @1)
  call void @__kmpc_barrier(ptr @2, i32 %omp_global_thread_num55)
  br label %omp.region.cont26

omp.region.cont26:                                ; preds = %reduce.finalize
  br label %omp.par.pre_finalize20

omp.par.pre_finalize20:                           ; preds = %omp.region.cont26
  br label %omp.par.outlined.exit.exitStub

omp_collapsed.body:                               ; preds = %omp_collapsed.cond
  %12 = add i64 %omp_collapsed.iv, %5
  %13 = urem i64 %12, 2
  %14 = udiv i64 %12, 2
  br label %omp_loop.body31

omp_loop.body31:                                  ; preds = %omp_collapsed.body
  %15 = mul i64 %14, 1
  %16 = add i64 %15, 0
  br label %omp_loop.preheader38

omp_loop.preheader38:                             ; preds = %omp_loop.body31
  br label %omp_loop.body41

omp_loop.body41:                                  ; preds = %omp_loop.preheader38
  %17 = mul i64 %13, 1
  %18 = add i64 %17, 0
  br label %omp.wsloop.region49

omp.wsloop.region49:                              ; preds = %omp_loop.body41
  %19 = call ptr @llvm.stacksave()
  br label %omp.wsloop.region50

omp.wsloop.region50:                              ; preds = %omp.wsloop.region49
  %20 = add i64 %2, %16
  %21 = add i64 %3, %18
  %22 = mul i64 %20, 10
  %23 = add i64 %22, %21
  %24 = getelementptr float, ptr %loadgep_2, i64 %23
  %25 = load float, ptr %24, align 4
  %26 = mul i64 %16, 3
  %27 = add i64 %26, %18
  %28 = getelementptr float, ptr %loadgep_4, i64 %27
  %29 = load float, ptr %28, align 4
  %30 = fmul float %25, %29
  %31 = load float, ptr %4, align 4
  %32 = fadd float %31, %30
  store float %32, ptr %4, align 4
  call void @llvm.stackrestore(ptr %19)
  br label %omp.wsloop.region51

omp.wsloop.region51:                              ; preds = %omp.wsloop.region50
  br label %omp.region.cont48

omp.region.cont48:                                ; preds = %omp.wsloop.region51
  br label %omp_loop.after44

omp_loop.after44:                                 ; preds = %omp.region.cont48
  br label %omp_collapsed.inc

omp_collapsed.inc:                                ; preds = %omp_loop.after44
  %omp_collapsed.next = add nuw i64 %omp_collapsed.iv, 1
  br label %omp_collapsed.header

omp.par.outlined.exit.exitStub:                   ; preds = %omp.par.pre_finalize20
  ret void
}

; Function Attrs: nounwind
declare i32 @__kmpc_global_thread_num(ptr) #1

; Function Attrs: nocallback nofree nosync nounwind willreturn
declare ptr @llvm.stacksave() #2

; Function Attrs: nocallback nofree nosync nounwind willreturn
declare void @llvm.stackrestore(ptr) #2

; Function Attrs: nounwind
declare void @__kmpc_for_static_init_8u(ptr, i32, i32, ptr, ptr, ptr, ptr, i64, i64) #1

; Function Attrs: nounwind
declare void @__kmpc_for_static_fini(ptr, i32) #1

; Function Attrs: convergent nounwind
declare void @__kmpc_barrier(ptr, i32) #3

define internal void @.omp.reduction.func(ptr %0, ptr %1) {
  %3 = getelementptr inbounds [1 x ptr], ptr %0, i64 0, i64 0
  %4 = load ptr, ptr %3, align 8
  %5 = load float, ptr %4, align 4
  %6 = getelementptr inbounds [1 x ptr], ptr %1, i64 0, i64 0
  %7 = load ptr, ptr %6, align 8
  %8 = load float, ptr %7, align 4
  %9 = fadd float %5, %8
  store float %9, ptr %4, align 4
  ret void
}

; Function Attrs: convergent nounwind
declare i32 @__kmpc_reduce(ptr, i32, i32, i64, ptr, ptr, ptr) #3

; Function Attrs: convergent nounwind
declare void @__kmpc_end_reduce(ptr, i32, ptr) #3

; Function Attrs: nounwind
declare !callback !1 void @__kmpc_fork_call(ptr, i32, ptr, ...) #1

attributes #0 = { norecurse nounwind }
attributes #1 = { nounwind }
attributes #2 = { nocallback nofree nosync nounwind willreturn }
attributes #3 = { convergent nounwind }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{!2}
!2 = !{i64 2, i64 -1, i64 -1, i1 true}
