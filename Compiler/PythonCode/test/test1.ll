; ModuleID = 'test1.cpp'
source_filename = "test1.cpp"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64"

%class.foo = type { i32, i32 }

$_ZN3fooC2Ei = comdat any

$_ZN3foo3gooEi = comdat any

; Function Attrs: mustprogress noinline norecurse optnone uwtable
define dso_local noundef i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca %class.foo, align 4
  store i32 0, ptr %1, align 4
  call void @_ZN3fooC2Ei(ptr noundef nonnull align 4 dereferenceable(8) %3, i32 noundef 365)
  %4 = getelementptr inbounds %class.foo, ptr %3, i32 0, i32 0
  %5 = load i32, ptr %4, align 4
  store i32 %5, ptr %2, align 4
  %6 = load i32, ptr %2, align 4
  %7 = add nsw i32 %6, 1
  store i32 %7, ptr %2, align 4
  %8 = call noundef i32 @_ZN3foo3gooEi(ptr noundef nonnull align 4 dereferenceable(8) %3, i32 noundef 23432)
  store i32 %8, ptr %2, align 4
  %9 = load i32, ptr %2, align 4
  ret i32 %9
}

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local void @_ZN3fooC2Ei(ptr noundef nonnull align 4 dereferenceable(8) %0, i32 noundef %1) unnamed_addr #1 comdat align 2 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %5 = load ptr, ptr %3, align 8
  %6 = load i32, ptr %4, align 4
  %7 = getelementptr inbounds %class.foo, ptr %5, i32 0, i32 0
  store i32 %6, ptr %7, align 4
  %8 = load i32, ptr %4, align 4
  %9 = add nsw i32 %8, 20
  %10 = getelementptr inbounds %class.foo, ptr %5, i32 0, i32 1
  store i32 %9, ptr %10, align 4
  ret void
}

; Function Attrs: mustprogress noinline nounwind optnone uwtable
define linkonce_odr dso_local noundef i32 @_ZN3foo3gooEi(ptr noundef nonnull align 4 dereferenceable(8) %0, i32 noundef %1) #2 comdat align 2 {
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  store i32 %1, ptr %4, align 4
  %5 = load ptr, ptr %3, align 8
  %6 = load i32, ptr %4, align 4
  %7 = getelementptr inbounds %class.foo, ptr %5, i32 0, i32 0
  store i32 %6, ptr %7, align 4
  %8 = load i32, ptr %4, align 4
  %9 = add nsw i32 %8, 30
  ret i32 %9
}

attributes #0 = { mustprogress noinline norecurse optnone uwtable "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-a53" "target-features"="+aes,+crc,+crypto,+fp-armv8,+neon,+sha2,+v8a,-fmv" }
attributes #1 = { noinline nounwind optnone uwtable "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-a53" "target-features"="+aes,+crc,+crypto,+fp-armv8,+neon,+sha2,+v8a,-fmv" }
attributes #2 = { mustprogress noinline nounwind optnone uwtable "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-a53" "target-features"="+aes,+crc,+crypto,+fp-armv8,+neon,+sha2,+v8a,-fmv" }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"uwtable", i32 2}
!2 = !{i32 7, !"frame-pointer", i32 1}
!3 = !{!"clang version 16.0.4"}
