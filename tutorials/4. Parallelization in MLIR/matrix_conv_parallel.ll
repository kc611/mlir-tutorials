; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

%struct.ident_t = type { i32, i32, i32, i32, ptr }

@0 = private unnamed_addr constant [23 x i8] c";unknown;unknown;0;0;;\00", align 1
@1 = private unnamed_addr constant %struct.ident_t { i32 0, i32 2, i32 0, i32 22, ptr @0 }, align 8
@2 = private unnamed_addr constant %struct.ident_t { i32 0, i32 66, i32 0, i32 22, ptr @0 }, align 8
@3 = private unnamed_addr constant %struct.ident_t { i32 0, i32 18, i32 0, i32 22, ptr @0 }, align 8
@.gomp_critical_user_.reduction.var = common global [8 x i32] zeroinitializer, align 8

define void @conv_2d(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, i64 %5, i64 %6, ptr %7, ptr %8, i64 %9, i64 %10, i64 %11, i64 %12, i64 %13, ptr %14, ptr %15, i64 %16, i64 %17, i64 %18, i64 %19, i64 %20) {
  %structArg77 = alloca { ptr, ptr, ptr }, align 8
  br label %entry

entry:                                            ; preds = %21
  %omp_global_thread_num = call i32 @__kmpc_global_thread_num(ptr @1)
  br label %omp_parallel

omp_parallel:                                     ; preds = %entry
  %gep_78 = getelementptr { ptr, ptr, ptr }, ptr %structArg77, i32 0, i32 0
  store ptr %1, ptr %gep_78, align 8
  %gep_79 = getelementptr { ptr, ptr, ptr }, ptr %structArg77, i32 0, i32 1
  store ptr %8, ptr %gep_79, align 8
  %gep_80 = getelementptr { ptr, ptr, ptr }, ptr %structArg77, i32 0, i32 2
  store ptr %15, ptr %gep_80, align 8
  call void (ptr, i32, ptr, ...) @__kmpc_fork_call(ptr @1, i32 1, ptr @conv_2d..omp_par.1, ptr %structArg77)
  br label %omp.par.outlined.exit74

omp.par.outlined.exit74:                          ; preds = %omp_parallel
  br label %omp.par.exit.split

omp.par.exit.split:                               ; preds = %omp.par.outlined.exit74
  ret void
}

; Function Attrs: nounwind
define internal void @conv_2d..omp_par.1(ptr noalias %tid.addr, ptr noalias %zero.addr, ptr %0) #0 {
omp.par.entry:
  %gep_ = getelementptr { ptr, ptr, ptr }, ptr %0, i32 0, i32 0
  %loadgep_ = load ptr, ptr %gep_, align 8
  %gep_1 = getelementptr { ptr, ptr, ptr }, ptr %0, i32 0, i32 1
  %loadgep_2 = load ptr, ptr %gep_1, align 8
  %gep_3 = getelementptr { ptr, ptr, ptr }, ptr %0, i32 0, i32 2
  %loadgep_4 = load ptr, ptr %gep_3, align 8
  %structArg = alloca { ptr, ptr, ptr, ptr, ptr }, align 8
  %p.lastiter68 = alloca i32, align 4
  %p.lowerbound69 = alloca i64, align 8
  %p.upperbound70 = alloca i64, align 8
  %p.stride71 = alloca i64, align 8
  %.reloaded = alloca i64, align 8
  %.reloaded57 = alloca i64, align 8
  %tid.addr.local = alloca i32, align 4
  %1 = load i32, ptr %tid.addr, align 4
  store i32 %1, ptr %tid.addr.local, align 4
  %tid = load i32, ptr %tid.addr.local, align 4
  br label %omp.reduction.init

omp.reduction.init:                               ; preds = %omp.par.entry
  br label %omp.par.region

omp.par.region:                                   ; preds = %omp.reduction.init
  br label %omp.par.region1

omp.par.region1:                                  ; preds = %omp.par.region
  br label %omp_loop.preheader

omp_loop.preheader:                               ; preds = %omp.par.region1
  br label %omp_collapsed.preheader58

omp_collapsed.preheader58:                        ; preds = %omp_loop.preheader
  store i64 0, ptr %p.lowerbound69, align 4
  store i64 9603, ptr %p.upperbound70, align 4
  store i64 1, ptr %p.stride71, align 4
  %omp_global_thread_num72 = call i32 @__kmpc_global_thread_num(ptr @1)
  call void @__kmpc_for_static_init_8u(ptr @1, i32 %omp_global_thread_num72, i32 34, ptr %p.lastiter68, ptr %p.lowerbound69, ptr %p.upperbound70, ptr %p.stride71, i64 1, i64 0)
  %2 = load i64, ptr %p.lowerbound69, align 4
  %3 = load i64, ptr %p.upperbound70, align 4
  %4 = sub i64 %3, %2
  %5 = add i64 %4, 1
  br label %omp_collapsed.header59

omp_collapsed.header59:                           ; preds = %omp_collapsed.inc62, %omp_collapsed.preheader58
  %omp_collapsed.iv65 = phi i64 [ 0, %omp_collapsed.preheader58 ], [ %omp_collapsed.next67, %omp_collapsed.inc62 ]
  br label %omp_collapsed.cond60

omp_collapsed.cond60:                             ; preds = %omp_collapsed.header59
  %omp_collapsed.cmp66 = icmp ult i64 %omp_collapsed.iv65, %5
  br i1 %omp_collapsed.cmp66, label %omp_collapsed.body61, label %omp_collapsed.exit63

omp_collapsed.exit63:                             ; preds = %omp_collapsed.cond60
  call void @__kmpc_for_static_fini(ptr @1, i32 %omp_global_thread_num72)
  %omp_global_thread_num73 = call i32 @__kmpc_global_thread_num(ptr @1)
  call void @__kmpc_barrier(ptr @2, i32 %omp_global_thread_num73)
  br label %omp_collapsed.after64

omp_collapsed.after64:                            ; preds = %omp_collapsed.exit63
  br label %omp_loop.after

omp_loop.after:                                   ; preds = %omp_collapsed.after64
  br label %omp.region.cont

omp.region.cont:                                  ; preds = %omp_loop.after
  br label %omp.par.pre_finalize

omp.par.pre_finalize:                             ; preds = %omp.region.cont
  br label %omp.par.outlined.exit74.exitStub

omp_collapsed.body61:                             ; preds = %omp_collapsed.cond60
  %6 = add i64 %omp_collapsed.iv65, %2
  %7 = urem i64 %6, 98
  %8 = udiv i64 %6, 98
  br label %omp_loop.body

omp_loop.body:                                    ; preds = %omp_collapsed.body61
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
  %13 = call ptr @llvm.stacksave.p0()
  br label %omp.wsloop.region13

omp.wsloop.region13:                              ; preds = %omp.wsloop.region
  %14 = alloca float, i64 1, align 4
  store float 0.000000e+00, ptr %14, align 4
  %omp_global_thread_num15 = call i32 @__kmpc_global_thread_num(ptr @1)
  store i64 %10, ptr %.reloaded, align 4
  store i64 %12, ptr %.reloaded57, align 4
  br label %omp_parallel

omp_parallel:                                     ; preds = %omp.wsloop.region13
  %gep_.reloaded = getelementptr { ptr, ptr, ptr, ptr, ptr }, ptr %structArg, i32 0, i32 0
  store ptr %.reloaded, ptr %gep_.reloaded, align 8
  %gep_.reloaded57 = getelementptr { ptr, ptr, ptr, ptr, ptr }, ptr %structArg, i32 0, i32 1
  store ptr %.reloaded57, ptr %gep_.reloaded57, align 8
  %gep_5 = getelementptr { ptr, ptr, ptr, ptr, ptr }, ptr %structArg, i32 0, i32 2
  store ptr %14, ptr %gep_5, align 8
  %gep_75 = getelementptr { ptr, ptr, ptr, ptr, ptr }, ptr %structArg, i32 0, i32 3
  store ptr %loadgep_, ptr %gep_75, align 8
  %gep_76 = getelementptr { ptr, ptr, ptr, ptr, ptr }, ptr %structArg, i32 0, i32 4
  store ptr %loadgep_2, ptr %gep_76, align 8
  call void (ptr, i32, ptr, ...) @__kmpc_fork_call(ptr @1, i32 1, ptr @conv_2d..omp_par, ptr %structArg)
  br label %omp.par.outlined.exit

omp.par.outlined.exit:                            ; preds = %omp_parallel
  br label %omp.par.exit21.split

omp.par.exit21.split:                             ; preds = %omp.par.outlined.exit
  %15 = load float, ptr %14, align 4
  %16 = mul i64 %10, 98
  %17 = add i64 %16, %12
  %18 = getelementptr float, ptr %loadgep_4, i64 %17
  store float %15, ptr %18, align 4
  call void @llvm.stackrestore.p0(ptr %13)
  br label %omp.wsloop.region14

omp.wsloop.region14:                              ; preds = %omp.par.exit21.split
  br label %omp.region.cont12

omp.region.cont12:                                ; preds = %omp.wsloop.region14
  br label %omp_loop.after8

omp_loop.after8:                                  ; preds = %omp.region.cont12
  br label %omp_collapsed.inc62

omp_collapsed.inc62:                              ; preds = %omp_loop.after8
  %omp_collapsed.next67 = add nuw i64 %omp_collapsed.iv65, 1
  br label %omp_collapsed.header59

omp.par.outlined.exit74.exitStub:                 ; preds = %omp.par.pre_finalize
  ret void
}

; Function Attrs: nounwind
define internal void @conv_2d..omp_par(ptr noalias %tid.addr16, ptr noalias %zero.addr17, ptr %0) #0 {
omp.par.entry18:
  %gep_.reloaded = getelementptr { ptr, ptr, ptr, ptr, ptr }, ptr %0, i32 0, i32 0
  %loadgep_.reloaded = load ptr, ptr %gep_.reloaded, align 8
  %gep_.reloaded57 = getelementptr { ptr, ptr, ptr, ptr, ptr }, ptr %0, i32 0, i32 1
  %loadgep_.reloaded57 = load ptr, ptr %gep_.reloaded57, align 8
  %gep_ = getelementptr { ptr, ptr, ptr, ptr, ptr }, ptr %0, i32 0, i32 2
  %loadgep_ = load ptr, ptr %gep_, align 8
  %gep_1 = getelementptr { ptr, ptr, ptr, ptr, ptr }, ptr %0, i32 0, i32 3
  %loadgep_2 = load ptr, ptr %gep_1, align 8
  %gep_3 = getelementptr { ptr, ptr, ptr, ptr, ptr }, ptr %0, i32 0, i32 4
  %loadgep_4 = load ptr, ptr %gep_3, align 8
  %p.lastiter = alloca i32, align 4
  %p.lowerbound = alloca i64, align 8
  %p.upperbound = alloca i64, align 8
  %p.stride = alloca i64, align 8
  %tid.addr.local22 = alloca i32, align 4
  %1 = load i32, ptr %tid.addr16, align 4
  store i32 %1, ptr %tid.addr.local22, align 4
  %tid23 = load i32, ptr %tid.addr.local22, align 4
  %2 = alloca float, align 4
  %red.array = alloca [1 x ptr], align 8
  %3 = load i64, ptr %loadgep_.reloaded, align 4
  %4 = load i64, ptr %loadgep_.reloaded57, align 4
  br label %omp.reduction.init26

omp.reduction.init26:                             ; preds = %omp.par.entry18
  br label %omp.par.region19

omp.par.region19:                                 ; preds = %omp.reduction.init26
  br label %omp.par.region28

omp.par.region28:                                 ; preds = %omp.par.region19
  store float 0.000000e+00, ptr %2, align 4
  br label %omp_loop.preheader29

omp_loop.preheader29:                             ; preds = %omp.par.region28
  br label %omp_collapsed.preheader

omp_collapsed.preheader:                          ; preds = %omp_loop.preheader29
  store i64 0, ptr %p.lowerbound, align 4
  store i64 3, ptr %p.upperbound, align 4
  store i64 1, ptr %p.stride, align 4
  %omp_global_thread_num53 = call i32 @__kmpc_global_thread_num(ptr @1)
  call void @__kmpc_for_static_init_8u(ptr @1, i32 %omp_global_thread_num53, i32 34, ptr %p.lastiter, ptr %p.lowerbound, ptr %p.upperbound, ptr %p.stride, i64 1, i64 0)
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
  call void @__kmpc_for_static_fini(ptr @1, i32 %omp_global_thread_num53)
  %omp_global_thread_num54 = call i32 @__kmpc_global_thread_num(ptr @1)
  call void @__kmpc_barrier(ptr @2, i32 %omp_global_thread_num54)
  br label %omp_collapsed.after

omp_collapsed.after:                              ; preds = %omp_collapsed.exit
  br label %omp_loop.after35

omp_loop.after35:                                 ; preds = %omp_collapsed.after
  %red.array.elem.0 = getelementptr inbounds [1 x ptr], ptr %red.array, i64 0, i64 0
  store ptr %2, ptr %red.array.elem.0, align 8
  %omp_global_thread_num55 = call i32 @__kmpc_global_thread_num(ptr @3)
  %reduce = call i32 @__kmpc_reduce(ptr @3, i32 %omp_global_thread_num55, i32 1, i64 8, ptr %red.array, ptr @.omp.reduction.func, ptr @.gomp_critical_user_.reduction.var)
  switch i32 %reduce, label %reduce.finalize [
    i32 1, label %reduce.switch.nonatomic
    i32 2, label %reduce.switch.atomic
  ]

reduce.switch.atomic:                             ; preds = %omp_loop.after35
  %9 = load float, ptr %2, align 4
  %10 = atomicrmw fadd ptr %loadgep_, float %9 monotonic, align 4
  br label %reduce.finalize

reduce.switch.nonatomic:                          ; preds = %omp_loop.after35
  %red.value.0 = load float, ptr %loadgep_, align 4
  %red.private.value.0 = load float, ptr %2, align 4
  %11 = fadd float %red.value.0, %red.private.value.0
  store float %11, ptr %loadgep_, align 4
  call void @__kmpc_end_reduce(ptr @3, i32 %omp_global_thread_num55, ptr @.gomp_critical_user_.reduction.var)
  br label %reduce.finalize

reduce.finalize:                                  ; preds = %reduce.switch.atomic, %reduce.switch.nonatomic, %omp_loop.after35
  %omp_global_thread_num56 = call i32 @__kmpc_global_thread_num(ptr @1)
  call void @__kmpc_barrier(ptr @2, i32 %omp_global_thread_num56)
  br label %omp.region.cont27

omp.region.cont27:                                ; preds = %reduce.finalize
  br label %omp.par.pre_finalize20

omp.par.pre_finalize20:                           ; preds = %omp.region.cont27
  br label %omp.par.outlined.exit.exitStub

omp_collapsed.body:                               ; preds = %omp_collapsed.cond
  %12 = add i64 %omp_collapsed.iv, %5
  %13 = urem i64 %12, 2
  %14 = udiv i64 %12, 2
  br label %omp_loop.body32

omp_loop.body32:                                  ; preds = %omp_collapsed.body
  %15 = mul i64 %14, 1
  %16 = add i64 %15, 0
  br label %omp_loop.preheader39

omp_loop.preheader39:                             ; preds = %omp_loop.body32
  br label %omp_loop.body42

omp_loop.body42:                                  ; preds = %omp_loop.preheader39
  %17 = mul i64 %13, 1
  %18 = add i64 %17, 0
  br label %omp.wsloop.region50

omp.wsloop.region50:                              ; preds = %omp_loop.body42
  %19 = call ptr @llvm.stacksave.p0()
  br label %omp.wsloop.region51

omp.wsloop.region51:                              ; preds = %omp.wsloop.region50
  %20 = add i64 %3, %16
  %21 = add i64 %4, %18
  %22 = mul i64 %20, 100
  %23 = add i64 %22, %21
  %24 = getelementptr float, ptr %loadgep_2, i64 %23
  %25 = load float, ptr %24, align 4
  %26 = mul i64 %16, 3
  %27 = add i64 %26, %18
  %28 = getelementptr float, ptr %loadgep_4, i64 %27
  %29 = load float, ptr %28, align 4
  %30 = fmul float %25, %29
  %31 = load float, ptr %2, align 4
  %32 = fadd float %31, %30
  store float %32, ptr %2, align 4
  call void @llvm.stackrestore.p0(ptr %19)
  br label %omp.wsloop.region52

omp.wsloop.region52:                              ; preds = %omp.wsloop.region51
  br label %omp.region.cont49

omp.region.cont49:                                ; preds = %omp.wsloop.region52
  br label %omp_loop.after45

omp_loop.after45:                                 ; preds = %omp.region.cont49
  br label %omp_collapsed.inc

omp_collapsed.inc:                                ; preds = %omp_loop.after45
  %omp_collapsed.next = add nuw i64 %omp_collapsed.iv, 1
  br label %omp_collapsed.header

omp.par.outlined.exit.exitStub:                   ; preds = %omp.par.pre_finalize20
  ret void
}

; Function Attrs: nounwind
declare i32 @__kmpc_global_thread_num(ptr) #0

; Function Attrs: nocallback nofree nosync nounwind willreturn
declare ptr @llvm.stacksave.p0() #1

; Function Attrs: nocallback nofree nosync nounwind willreturn
declare void @llvm.stackrestore.p0(ptr) #1

; Function Attrs: nounwind
declare void @__kmpc_for_static_init_8u(ptr, i32, i32, ptr, ptr, ptr, ptr, i64, i64) #0

; Function Attrs: nounwind
declare void @__kmpc_for_static_fini(ptr, i32) #0

; Function Attrs: convergent nounwind
declare void @__kmpc_barrier(ptr, i32) #2

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
declare i32 @__kmpc_reduce(ptr, i32, i32, i64, ptr, ptr, ptr) #2

; Function Attrs: convergent nounwind
declare void @__kmpc_end_reduce(ptr, i32, ptr) #2

; Function Attrs: nounwind
declare !callback !1 void @__kmpc_fork_call(ptr, i32, ptr, ...) #0

attributes #0 = { nounwind }
attributes #1 = { nocallback nofree nosync nounwind willreturn }
attributes #2 = { convergent nounwind }

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !{!2}
!2 = !{i64 2, i64 -1, i64 -1, i1 true}
