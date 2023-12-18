; ModuleID = 'test1.cpp'
source_filename = "test1.cpp"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64"

; Function Attrs: mustprogress noinline norecurse nounwind optnone uwtable
define dso_local noundef i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca fp128, align 16
  store i32 0, ptr %1, align 4
  store fp128 0xL00000000000000003FFF000000000000, ptr %4, align 16
  store i32 1, ptr %2, align 4
  br label %5

5:                                                ; preds = %10, %0
  %6 = load i32, ptr %2, align 4
  %7 = icmp slt i32 %6, 10
  br i1 %7, label %8, label %13

8:                                                ; preds = %5
  %9 = load i32, ptr %2, align 4
  store i32 %9, ptr %3, align 4
  br label %10

10:                                               ; preds = %8
  %11 = load i32, ptr %2, align 4
  %12 = add nsw i32 %11, 1
  store i32 %12, ptr %2, align 4
  br label %5, !llvm.loop !4

13:                                               ; preds = %5
  %14 = load i32, ptr %2, align 4
  ret i32 %14
}

attributes #0 = { mustprogress noinline norecurse nounwind optnone uwtable "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-a53" "target-features"="+aes,+crc,+crypto,+fp-armv8,+neon,+sha2,+v8a,-fmv" }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"uwtable", i32 2}
!2 = !{i32 7, !"frame-pointer", i32 1}
!3 = !{!"clang version 16.0.4"}
!4 = distinct !{!4, !5}
!5 = !{!"llvm.loop.mustprogress"}
