; ModuleID = 'test1.cpp'
source_filename = "test1.cpp"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64"

$_Z3sumIiET_S0_S0_ = comdat any

$_Z3sumIcET_S0_S0_ = comdat any

@.str = private unnamed_addr constant [6 x i8] c"abcd\00\00", align 1

; Function Attrs: mustprogress noinline norecurse optnone uwtable
define dso_local noundef i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca ptr, align 8
  %4 = alloca [10 x i32], align 4
  store i32 0, ptr %1, align 4
  store ptr @.str, ptr %3, align 8
  %5 = load i32, ptr %2, align 4
  %6 = load i32, ptr %2, align 4
  %7 = call noundef i32 @_Z3sumIiET_S0_S0_(i32 noundef %5, i32 noundef %6)
  %8 = load i32, ptr %2, align 4
  %9 = trunc i32 %8 to i8
  %10 = call noundef i8 @_Z3sumIcET_S0_S0_(i8 noundef %9, i8 noundef 10)
  call void @llvm.memset.p0.i64(ptr align 4 %4, i8 0, i64 40, i1 false)
  %11 = getelementptr inbounds [10 x i32], ptr %4, i32 0, i32 0
  store i32 1, ptr %11, align 4
  %12 = getelementptr inbounds [10 x i32], ptr %4, i32 0, i32 1
  store i32 2, ptr %12, align 4
  %13 = getelementptr inbounds [10 x i32], ptr %4, i32 0, i32 2
  store i32 3, ptr %13, align 4
  %14 = load i32, ptr %2, align 4
  %15 = add nsw i32 %14, 1
  store i32 %15, ptr %2, align 4
  %16 = load i32, ptr %2, align 4
  ret i32 %16
}

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define linkonce_odr dso_local noundef i32 @_Z3sumIiET_S0_S0_(i32 noundef %0, i32 noundef %1) #1 comdat {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, ptr %3, align 4
  store i32 %1, ptr %4, align 4
  %5 = load i32, ptr %3, align 4
  %6 = load i32, ptr %4, align 4
  %7 = add nsw i32 %5, %6
  ret i32 %7
}

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define linkonce_odr dso_local noundef i8 @_Z3sumIcET_S0_S0_(i8 noundef %0, i8 noundef %1) #1 comdat {
  %3 = alloca i8, align 1
  %4 = alloca i8, align 1
  store i8 %0, ptr %3, align 1
  store i8 %1, ptr %4, align 1
  %5 = load i8, ptr %3, align 1
  %6 = zext i8 %5 to i32
  %7 = load i8, ptr %4, align 1
  %8 = zext i8 %7 to i32
  %9 = add nsw i32 %6, %8
  %10 = trunc i32 %9 to i8
  ret i8 %10
}

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #2

attributes #0 = { mustprogress noinline norecurse optnone uwtable "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-a53" "target-features"="+aes,+crc,+crypto,+fp-armv8,+neon,+sha2,+v8a,-fmv" }
attributes #1 = { mustprogress noinline nounwind optnone uwtable "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-a53" "target-features"="+aes,+crc,+crypto,+fp-armv8,+neon,+sha2,+v8a,-fmv" }
attributes #2 = { nocallback nofree nounwind willreturn memory(argmem: write) }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"uwtable", i32 2}
!2 = !{i32 7, !"frame-pointer", i32 1}
!3 = !{!"clang version 16.0.4"}
