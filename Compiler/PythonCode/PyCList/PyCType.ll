; ModuleID = 'PyCType.c'
source_filename = "PyCType.c"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc19.29.30133"

%struct._object = type { i32, %struct.PyCTypeObject }
%struct.PyCTypeObject = type { ptr, ptr }

@num_type = dso_local global i32 4, align 4
@type_table = dso_local global [4 x [20 x i8]] [[20 x i8] c"int64\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", [20 x i8] c"float64\00\00\00\00\00\00\00\00\00\00\00\00\00", [20 x i8] c"uint8\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", [20 x i8] c"list\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00"], align 16

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @do_richcompare(ptr noundef %0, ptr noundef %1, i32 noundef %2) #0 {
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca i32, align 4
  store i32 %2, ptr %5, align 4
  store ptr %1, ptr %6, align 8
  store ptr %0, ptr %7, align 8
  %10 = load ptr, ptr %6, align 8
  %11 = getelementptr inbounds %struct._object, ptr %10, i32 0, i32 1
  %12 = getelementptr inbounds %struct.PyCTypeObject, ptr %11, i32 0, i32 0
  %13 = load ptr, ptr %12, align 8
  %14 = load ptr, ptr %7, align 8
  %15 = getelementptr inbounds %struct._object, ptr %14, i32 0, i32 1
  %16 = getelementptr inbounds %struct.PyCTypeObject, ptr %15, i32 0, i32 0
  %17 = load ptr, ptr %16, align 8
  %18 = call i32 @strcmp(ptr noundef %17, ptr noundef %13)
  %19 = icmp eq i32 %18, 0
  br i1 %19, label %20, label %33

20:                                               ; preds = %3
  %21 = load ptr, ptr %6, align 8
  %22 = getelementptr inbounds %struct._object, ptr %21, i32 0, i32 1
  %23 = getelementptr inbounds %struct.PyCTypeObject, ptr %22, i32 0, i32 1
  %24 = load ptr, ptr %23, align 8
  store ptr %24, ptr %8, align 8
  %25 = icmp ne ptr %24, null
  br i1 %25, label %26, label %33

26:                                               ; preds = %20
  %27 = load ptr, ptr %8, align 8
  %28 = load i32, ptr %5, align 4
  %29 = load ptr, ptr %7, align 8
  %30 = load ptr, ptr %6, align 8
  %31 = call i32 %27(ptr noundef %30, ptr noundef %29, i32 noundef %28)
  store i32 %31, ptr %9, align 4
  %32 = load i32, ptr %9, align 4
  store i32 %32, ptr %4, align 4
  br label %34

33:                                               ; preds = %20, %3
  store i32 0, ptr %4, align 4
  br label %34

34:                                               ; preds = %33, %26
  %35 = load i32, ptr %4, align 4
  ret i32 %35
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @strcmp(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  store ptr %1, ptr %4, align 8
  store ptr %0, ptr %5, align 8
  store i32 0, ptr %6, align 4
  br label %7

7:                                                ; preds = %45, %2
  %8 = load ptr, ptr %5, align 8
  %9 = load i32, ptr %6, align 4
  %10 = sext i32 %9 to i64
  %11 = getelementptr inbounds i8, ptr %8, i64 %10
  %12 = load i8, ptr %11, align 1
  %13 = sext i8 %12 to i32
  %14 = load ptr, ptr %4, align 8
  %15 = load i32, ptr %6, align 4
  %16 = sext i32 %15 to i64
  %17 = getelementptr inbounds i8, ptr %14, i64 %16
  %18 = load i8, ptr %17, align 1
  %19 = sext i8 %18 to i32
  %20 = icmp ne i32 %13, %19
  br i1 %20, label %21, label %22

21:                                               ; preds = %7
  store i32 1, ptr %3, align 4
  br label %46

22:                                               ; preds = %7
  %23 = load ptr, ptr %5, align 8
  %24 = load i32, ptr %6, align 4
  %25 = sext i32 %24 to i64
  %26 = getelementptr inbounds i8, ptr %23, i64 %25
  %27 = load i8, ptr %26, align 1
  %28 = sext i8 %27 to i32
  %29 = icmp eq i32 %28, 0
  br i1 %29, label %30, label %40

30:                                               ; preds = %22
  %31 = load ptr, ptr %4, align 8
  %32 = load i32, ptr %6, align 4
  %33 = sext i32 %32 to i64
  %34 = getelementptr inbounds i8, ptr %31, i64 %33
  %35 = load i8, ptr %34, align 1
  %36 = sext i8 %35 to i32
  %37 = icmp eq i32 %36, 0
  br i1 %37, label %38, label %39

38:                                               ; preds = %30
  store i32 0, ptr %3, align 4
  br label %46

39:                                               ; preds = %30
  store i32 1, ptr %3, align 4
  br label %46

40:                                               ; preds = %22
  %41 = load i32, ptr %6, align 4
  %42 = add nsw i32 %41, 1
  store i32 %42, ptr %6, align 4
  br label %43

43:                                               ; preds = %40
  br label %44

44:                                               ; preds = %43
  br label %45

45:                                               ; preds = %44
  br i1 true, label %7, label %46

46:                                               ; preds = %21, %38, %39, %45
  %47 = load i32, ptr %3, align 4
  ret i32 %47
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @PyCObject_RichCompare(ptr noundef %0, ptr noundef %1, i32 noundef %2) #0 {
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca i32, align 4
  store i32 %2, ptr %5, align 4
  store ptr %1, ptr %6, align 8
  store ptr %0, ptr %7, align 8
  %9 = load ptr, ptr %7, align 8
  %10 = icmp eq ptr %9, null
  br i1 %10, label %14, label %11

11:                                               ; preds = %3
  %12 = load ptr, ptr %6, align 8
  %13 = icmp eq ptr %12, null
  br i1 %13, label %14, label %15

14:                                               ; preds = %11, %3
  store i32 0, ptr %4, align 4
  br label %21

15:                                               ; preds = %11
  %16 = load i32, ptr %5, align 4
  %17 = load ptr, ptr %6, align 8
  %18 = load ptr, ptr %7, align 8
  %19 = call i32 @do_richcompare(ptr noundef %18, ptr noundef %17, i32 noundef %16)
  store i32 %19, ptr %8, align 4
  %20 = load i32, ptr %8, align 4
  store i32 %20, ptr %4, align 4
  br label %21

21:                                               ; preds = %15, %14
  %22 = load i32, ptr %4, align 4
  ret i32 %22
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @PyCObject_RichCompareBool(ptr noundef %0, ptr noundef %1, i32 noundef %2) #0 {
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca ptr, align 8
  %7 = alloca ptr, align 8
  %8 = alloca i32, align 4
  %9 = alloca ptr, align 8
  store i32 %2, ptr %5, align 4
  store ptr %1, ptr %6, align 8
  store ptr %0, ptr %7, align 8
  %10 = load ptr, ptr %7, align 8
  %11 = load ptr, ptr %6, align 8
  %12 = icmp eq ptr %10, %11
  br i1 %12, label %13, label %23

13:                                               ; preds = %3
  %14 = load i32, ptr %5, align 4
  %15 = icmp eq i32 %14, 0
  br i1 %15, label %16, label %17

16:                                               ; preds = %13
  store i32 1, ptr %4, align 4
  br label %29

17:                                               ; preds = %13
  %18 = load i32, ptr %5, align 4
  %19 = icmp eq i32 %18, 1
  br i1 %19, label %20, label %21

20:                                               ; preds = %17
  store i32 0, ptr %4, align 4
  br label %29

21:                                               ; preds = %17
  br label %22

22:                                               ; preds = %21
  br label %23

23:                                               ; preds = %22, %3
  %24 = load i32, ptr %5, align 4
  %25 = load ptr, ptr %6, align 8
  %26 = load ptr, ptr %7, align 8
  %27 = call i32 @PyCObject_RichCompare(ptr noundef %26, ptr noundef %25, i32 noundef %24)
  store i32 %27, ptr %8, align 4
  %28 = load i32, ptr %8, align 4
  store i32 %28, ptr %4, align 4
  br label %29

29:                                               ; preds = %23, %20, %16
  %30 = load i32, ptr %4, align 4
  ret i32 %30
}

attributes #0 = { noinline nounwind optnone uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 1, !"wchar_size", i32 2}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"uwtable", i32 2}
!3 = !{!"clang version 16.0.4"}
