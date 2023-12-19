; ModuleID = 'PyCLong.c'
source_filename = "PyCLong.c"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc19.29.30133"

%struct.PyCIntObject = type { %struct.PyCVarObject, [1 x i32] }
%struct.PyCVarObject = type { %struct._object, i32 }
%struct._object = type { i32, %struct.PyCTypeObject }
%struct.PyCTypeObject = type { ptr, ptr }
%struct.PyCDoubleObject = type { %struct.PyCVarObject, [1 x double] }
%struct.PyCCharObject = type { %struct.PyCVarObject, i8 }

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @PyC_get_int64_t(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = getelementptr inbounds %struct.PyCIntObject, ptr %4, i32 0, i32 0
  %6 = getelementptr inbounds %struct.PyCVarObject, ptr %5, i32 0, i32 1
  %7 = load i32, ptr %6, align 8
  %8 = icmp sgt i32 %7, 0
  %9 = zext i1 %8 to i64
  %10 = select i1 %8, i32 1, i32 -1
  store i32 %10, ptr %3, align 4
  %11 = load ptr, ptr %2, align 8
  %12 = getelementptr inbounds %struct.PyCIntObject, ptr %11, i32 0, i32 1
  %13 = getelementptr inbounds [1 x i32], ptr %12, i64 0, i64 0
  %14 = load i32, ptr %13, align 8
  %15 = load i32, ptr %3, align 4
  %16 = mul nsw i32 %14, %15
  ret i32 %16
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @PyC_get_double(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca double, align 8
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = getelementptr inbounds %struct.PyCDoubleObject, ptr %4, i32 0, i32 0
  %6 = getelementptr inbounds %struct.PyCVarObject, ptr %5, i32 0, i32 1
  %7 = load i32, ptr %6, align 8
  %8 = sitofp i32 %7 to double
  %9 = fcmp ogt double %8, 0.000000e+00
  %10 = zext i1 %9 to i64
  %11 = select i1 %9, double 1.000000e+00, double -1.000000e+00
  store double %11, ptr %3, align 8
  %12 = load ptr, ptr %2, align 8
  %13 = getelementptr inbounds %struct.PyCDoubleObject, ptr %12, i32 0, i32 1
  %14 = getelementptr inbounds [1 x double], ptr %13, i64 0, i64 0
  %15 = load double, ptr %14, align 8
  %16 = load double, ptr %3, align 8
  %17 = fmul double %15, %16
  ret double %17
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i8 @PyC_get_char(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8
  %4 = getelementptr inbounds %struct.PyCCharObject, ptr %3, i32 0, i32 1
  %5 = load i8, ptr %4, align 8
  ret i8 %5
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @int64_t_richcompare(ptr noundef %0, ptr noundef %1, i32 noundef %2) #0 {
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  store i32 %2, ptr %5, align 4
  store ptr %1, ptr %6, align 8
  store ptr %0, ptr %7, align 8
  %10 = load ptr, ptr %7, align 8
  %11 = call i32 @PyC_get_int64_t(ptr noundef %10)
  store i32 %11, ptr %8, align 4
  %12 = load ptr, ptr %6, align 8
  %13 = call i32 @PyC_get_int64_t(ptr noundef %12)
  store i32 %13, ptr %9, align 4
  br label %14

14:                                               ; preds = %3
  %15 = load i32, ptr %5, align 4
  switch i32 %15, label %52 [
    i32 0, label %16
    i32 1, label %22
    i32 2, label %28
    i32 3, label %34
    i32 4, label %40
    i32 5, label %46
  ]

16:                                               ; preds = %14
  %17 = load i32, ptr %8, align 4
  %18 = load i32, ptr %9, align 4
  %19 = icmp eq i32 %17, %18
  br i1 %19, label %20, label %21

20:                                               ; preds = %16
  store i32 1, ptr %4, align 4
  br label %53

21:                                               ; preds = %16
  store i32 0, ptr %4, align 4
  br label %53

22:                                               ; preds = %14
  %23 = load i32, ptr %8, align 4
  %24 = load i32, ptr %9, align 4
  %25 = icmp ne i32 %23, %24
  br i1 %25, label %26, label %27

26:                                               ; preds = %22
  store i32 1, ptr %4, align 4
  br label %53

27:                                               ; preds = %22
  store i32 0, ptr %4, align 4
  br label %53

28:                                               ; preds = %14
  %29 = load i32, ptr %8, align 4
  %30 = load i32, ptr %9, align 4
  %31 = icmp slt i32 %29, %30
  br i1 %31, label %32, label %33

32:                                               ; preds = %28
  store i32 1, ptr %4, align 4
  br label %53

33:                                               ; preds = %28
  store i32 0, ptr %4, align 4
  br label %53

34:                                               ; preds = %14
  %35 = load i32, ptr %8, align 4
  %36 = load i32, ptr %9, align 4
  %37 = icmp sgt i32 %35, %36
  br i1 %37, label %38, label %39

38:                                               ; preds = %34
  store i32 1, ptr %4, align 4
  br label %53

39:                                               ; preds = %34
  store i32 0, ptr %4, align 4
  br label %53

40:                                               ; preds = %14
  %41 = load i32, ptr %8, align 4
  %42 = load i32, ptr %9, align 4
  %43 = icmp sle i32 %41, %42
  br i1 %43, label %44, label %45

44:                                               ; preds = %40
  store i32 1, ptr %4, align 4
  br label %53

45:                                               ; preds = %40
  store i32 0, ptr %4, align 4
  br label %53

46:                                               ; preds = %14
  %47 = load i32, ptr %8, align 4
  %48 = load i32, ptr %9, align 4
  %49 = icmp sge i32 %47, %48
  br i1 %49, label %50, label %51

50:                                               ; preds = %46
  store i32 1, ptr %4, align 4
  br label %53

51:                                               ; preds = %46
  store i32 0, ptr %4, align 4
  br label %53

52:                                               ; preds = %14
  store i32 2, ptr %4, align 4
  br label %53

53:                                               ; preds = %20, %21, %26, %27, %32, %33, %38, %39, %44, %45, %50, %51, %52
  %54 = load i32, ptr %4, align 4
  ret i32 %54
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @char_richcompare(ptr noundef %0, ptr noundef %1, i32 noundef %2) #0 {
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca i8, align 1
  %9 = alloca i8, align 1
  store i32 %2, ptr %5, align 4
  store ptr %1, ptr %6, align 8
  store ptr %0, ptr %7, align 8
  %10 = load ptr, ptr %7, align 8
  %11 = call i8 @PyC_get_char(ptr noundef %10)
  store i8 %11, ptr %8, align 1
  %12 = load ptr, ptr %6, align 8
  %13 = call i8 @PyC_get_char(ptr noundef %12)
  store i8 %13, ptr %9, align 1
  br label %14

14:                                               ; preds = %3
  %15 = load i32, ptr %5, align 4
  switch i32 %15, label %64 [
    i32 0, label %16
    i32 1, label %24
    i32 2, label %32
    i32 3, label %40
    i32 4, label %48
    i32 5, label %56
  ]

16:                                               ; preds = %14
  %17 = load i8, ptr %8, align 1
  %18 = sext i8 %17 to i32
  %19 = load i8, ptr %9, align 1
  %20 = sext i8 %19 to i32
  %21 = icmp eq i32 %18, %20
  br i1 %21, label %22, label %23

22:                                               ; preds = %16
  store i32 1, ptr %4, align 4
  br label %65

23:                                               ; preds = %16
  store i32 0, ptr %4, align 4
  br label %65

24:                                               ; preds = %14
  %25 = load i8, ptr %8, align 1
  %26 = sext i8 %25 to i32
  %27 = load i8, ptr %9, align 1
  %28 = sext i8 %27 to i32
  %29 = icmp ne i32 %26, %28
  br i1 %29, label %30, label %31

30:                                               ; preds = %24
  store i32 1, ptr %4, align 4
  br label %65

31:                                               ; preds = %24
  store i32 0, ptr %4, align 4
  br label %65

32:                                               ; preds = %14
  %33 = load i8, ptr %8, align 1
  %34 = sext i8 %33 to i32
  %35 = load i8, ptr %9, align 1
  %36 = sext i8 %35 to i32
  %37 = icmp slt i32 %34, %36
  br i1 %37, label %38, label %39

38:                                               ; preds = %32
  store i32 1, ptr %4, align 4
  br label %65

39:                                               ; preds = %32
  store i32 0, ptr %4, align 4
  br label %65

40:                                               ; preds = %14
  %41 = load i8, ptr %8, align 1
  %42 = sext i8 %41 to i32
  %43 = load i8, ptr %9, align 1
  %44 = sext i8 %43 to i32
  %45 = icmp sgt i32 %42, %44
  br i1 %45, label %46, label %47

46:                                               ; preds = %40
  store i32 1, ptr %4, align 4
  br label %65

47:                                               ; preds = %40
  store i32 0, ptr %4, align 4
  br label %65

48:                                               ; preds = %14
  %49 = load i8, ptr %8, align 1
  %50 = sext i8 %49 to i32
  %51 = load i8, ptr %9, align 1
  %52 = sext i8 %51 to i32
  %53 = icmp sle i32 %50, %52
  br i1 %53, label %54, label %55

54:                                               ; preds = %48
  store i32 1, ptr %4, align 4
  br label %65

55:                                               ; preds = %48
  store i32 0, ptr %4, align 4
  br label %65

56:                                               ; preds = %14
  %57 = load i8, ptr %8, align 1
  %58 = sext i8 %57 to i32
  %59 = load i8, ptr %9, align 1
  %60 = sext i8 %59 to i32
  %61 = icmp sge i32 %58, %60
  br i1 %61, label %62, label %63

62:                                               ; preds = %56
  store i32 1, ptr %4, align 4
  br label %65

63:                                               ; preds = %56
  store i32 0, ptr %4, align 4
  br label %65

64:                                               ; preds = %14
  store i32 2, ptr %4, align 4
  br label %65

65:                                               ; preds = %22, %23, %30, %31, %38, %39, %46, %47, %54, %55, %62, %63, %64
  %66 = load i32, ptr %4, align 4
  ret i32 %66
}

attributes #0 = { noinline nounwind optnone uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 1, !"wchar_size", i32 2}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"uwtable", i32 2}
!3 = !{!"clang version 16.0.4"}
