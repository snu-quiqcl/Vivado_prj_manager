; ModuleID = 'test1.c'
source_filename = "test1.c"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc19.29.30133"

%struct._object = type { i32, %struct.PyCTypeObject }
%struct.PyCTypeObject = type { ptr, ptr }
%struct.PyCListObject = type { %struct.PyCVarObject, ptr, i32 }
%struct.PyCVarObject = type { %struct._object, i32 }
%struct.PyCIntObject = type { %struct.PyCVarObject, [1 x i32] }
%struct.PyCCharObject = type { %struct.PyCVarObject, i8 }
%struct.PyCDoubleObject = type { %struct.PyCVarObject, [1 x double] }

$"??_C@_04DONFEANM@list?$AA@" = comdat any

$"??_C@_05DIFFJEPM@int64?$AA@" = comdat any

$"??_C@_04ENMBGAPA@char?$AA@" = comdat any

$"??_C@_06BNJCAIGJ@double?$AA@" = comdat any

@"??_C@_04DONFEANM@list?$AA@" = linkonce_odr dso_local unnamed_addr constant [5 x i8] c"list\00", comdat, align 1
@"??_C@_05DIFFJEPM@int64?$AA@" = linkonce_odr dso_local unnamed_addr constant [6 x i8] c"int64\00", comdat, align 1
@"??_C@_04ENMBGAPA@char?$AA@" = linkonce_odr dso_local unnamed_addr constant [5 x i8] c"char\00", comdat, align 1
@"??_C@_06BNJCAIGJ@double?$AA@" = linkonce_odr dso_local unnamed_addr constant [7 x i8] c"double\00", comdat, align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @show_list_structure(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %5 = load ptr, ptr %2, align 8
  %6 = getelementptr inbounds %struct._object, ptr %5, i32 0, i32 1
  %7 = getelementptr inbounds %struct.PyCTypeObject, ptr %6, i32 0, i32 0
  %8 = load ptr, ptr %7, align 8
  %9 = call i32 @strcmp(ptr noundef %8, ptr noundef @"??_C@_04DONFEANM@list?$AA@")
  %10 = icmp eq i32 %9, 0
  br i1 %10, label %11, label %40

11:                                               ; preds = %1
  %12 = load ptr, ptr %2, align 8
  %13 = getelementptr inbounds %struct.PyCListObject, ptr %12, i32 0, i32 1
  %14 = load ptr, ptr %13, align 8
  store ptr %14, ptr %3, align 8
  store i32 0, ptr %4, align 4
  store i32 0, ptr %4, align 4
  br label %15

15:                                               ; preds = %36, %11
  %16 = load i32, ptr %4, align 4
  %17 = load ptr, ptr %2, align 8
  %18 = getelementptr inbounds %struct.PyCListObject, ptr %17, i32 0, i32 0
  %19 = getelementptr inbounds %struct.PyCVarObject, ptr %18, i32 0, i32 1
  %20 = load i32, ptr %19, align 8
  %21 = icmp slt i32 %16, %20
  br i1 %21, label %22, label %39

22:                                               ; preds = %15
  %23 = load ptr, ptr %3, align 8
  %24 = load ptr, ptr %23, align 8
  call void @show_list_structure(ptr noundef %24)
  %25 = load i32, ptr %4, align 4
  %26 = load ptr, ptr %2, align 8
  %27 = getelementptr inbounds %struct.PyCListObject, ptr %26, i32 0, i32 0
  %28 = getelementptr inbounds %struct.PyCVarObject, ptr %27, i32 0, i32 1
  %29 = load i32, ptr %28, align 8
  %30 = sub nsw i32 %29, 1
  %31 = icmp ne i32 %25, %30
  br i1 %31, label %32, label %33

32:                                               ; preds = %22
  br label %33

33:                                               ; preds = %32, %22
  %34 = load ptr, ptr %3, align 8
  %35 = getelementptr inbounds ptr, ptr %34, i64 1
  store ptr %35, ptr %3, align 8
  br label %36

36:                                               ; preds = %33
  %37 = load i32, ptr %4, align 4
  %38 = add nsw i32 %37, 1
  store i32 %38, ptr %4, align 4
  br label %15, !llvm.loop !4

39:                                               ; preds = %15
  br label %58

40:                                               ; preds = %1
  %41 = load ptr, ptr %2, align 8
  %42 = getelementptr inbounds %struct._object, ptr %41, i32 0, i32 1
  %43 = getelementptr inbounds %struct.PyCTypeObject, ptr %42, i32 0, i32 0
  %44 = load ptr, ptr %43, align 8
  %45 = call i32 @strcmp(ptr noundef %44, ptr noundef @"??_C@_05DIFFJEPM@int64?$AA@")
  %46 = icmp eq i32 %45, 0
  br i1 %46, label %47, label %48

47:                                               ; preds = %40
  br label %57

48:                                               ; preds = %40
  %49 = load ptr, ptr %2, align 8
  %50 = getelementptr inbounds %struct._object, ptr %49, i32 0, i32 1
  %51 = getelementptr inbounds %struct.PyCTypeObject, ptr %50, i32 0, i32 0
  %52 = load ptr, ptr %51, align 8
  %53 = call i32 @strcmp(ptr noundef %52, ptr noundef @"??_C@_04ENMBGAPA@char?$AA@")
  %54 = icmp eq i32 %53, 0
  br i1 %54, label %55, label %56

55:                                               ; preds = %48
  br label %56

56:                                               ; preds = %55, %48
  br label %57

57:                                               ; preds = %56, %47
  br label %58

58:                                               ; preds = %57, %39
  ret void
}

declare dso_local i32 @strcmp(ptr noundef, ptr noundef) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca ptr, align 8
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = call ptr @PyC_make_int64(i32 noundef 10)
  store ptr %7, ptr %1, align 8
  %8 = call ptr @PyC_make_int64(i32 noundef 20)
  store ptr %8, ptr %2, align 8
  %9 = call ptr @PyC_make_char(i8 noundef 99)
  store ptr %9, ptr %3, align 8
  %10 = call ptr @PyC_make_double(double noundef 1.000000e+00)
  store ptr %10, ptr %4, align 8
  %11 = call ptr @PyCList_New(i32 noundef 0)
  store ptr %11, ptr %5, align 8
  %12 = call ptr @PyCList_New(i32 noundef 0)
  store ptr %12, ptr %6, align 8
  %13 = load ptr, ptr %1, align 8
  %14 = load ptr, ptr %6, align 8
  %15 = call i32 @PyCList_Append(ptr noundef %14, ptr noundef %13)
  %16 = load ptr, ptr %1, align 8
  %17 = load ptr, ptr %5, align 8
  %18 = call i32 @PyCList_Append(ptr noundef %17, ptr noundef %16)
  %19 = load ptr, ptr %2, align 8
  %20 = load ptr, ptr %5, align 8
  %21 = call i32 @PyCList_Append(ptr noundef %20, ptr noundef %19)
  %22 = load ptr, ptr %3, align 8
  %23 = load ptr, ptr %5, align 8
  %24 = call i32 @PyCList_Append(ptr noundef %23, ptr noundef %22)
  %25 = load ptr, ptr %6, align 8
  %26 = load ptr, ptr %5, align 8
  %27 = call i32 @PyCList_Append(ptr noundef %26, ptr noundef %25)
  %28 = load ptr, ptr %5, align 8
  call void @show_list_structure(ptr noundef %28)
  %29 = load ptr, ptr %3, align 8
  %30 = load ptr, ptr %5, align 8
  call void @PyCList_remove(ptr noundef %30, ptr noundef %29)
  %31 = load ptr, ptr %5, align 8
  call void @show_list_structure(ptr noundef %31)
  ret i32 0
}

; Function Attrs: noinline nounwind optnone uwtable
define internal ptr @PyC_make_int64(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  %5 = call ptr @PyCMem_Malloc(i32 noundef 40)
  store ptr %5, ptr %3, align 8
  %6 = load ptr, ptr %3, align 8
  %7 = getelementptr inbounds %struct._object, ptr %6, i32 0, i32 1
  %8 = getelementptr inbounds %struct.PyCTypeObject, ptr %7, i32 0, i32 0
  store ptr @"??_C@_05DIFFJEPM@int64?$AA@", ptr %8, align 8
  %9 = load i32, ptr %2, align 4
  %10 = icmp sgt i32 %9, 0
  %11 = zext i1 %10 to i64
  %12 = select i1 %10, i32 1, i32 -1
  store i32 %12, ptr %4, align 4
  %13 = load i32, ptr %4, align 4
  %14 = load ptr, ptr %3, align 8
  %15 = getelementptr inbounds %struct.PyCIntObject, ptr %14, i32 0, i32 0
  %16 = getelementptr inbounds %struct.PyCVarObject, ptr %15, i32 0, i32 1
  store i32 %13, ptr %16, align 8
  %17 = load i32, ptr %4, align 4
  %18 = load i32, ptr %2, align 4
  %19 = mul nsw i32 %17, %18
  %20 = load ptr, ptr %3, align 8
  %21 = getelementptr inbounds %struct.PyCIntObject, ptr %20, i32 0, i32 1
  %22 = getelementptr inbounds [1 x i32], ptr %21, i64 0, i64 0
  store i32 %19, ptr %22, align 8
  %23 = load ptr, ptr %3, align 8
  %24 = getelementptr inbounds %struct._object, ptr %23, i32 0, i32 1
  %25 = getelementptr inbounds %struct.PyCTypeObject, ptr %24, i32 0, i32 1
  store ptr @int64_t_richcompare, ptr %25, align 8
  %26 = load ptr, ptr %3, align 8
  ret ptr %26
}

; Function Attrs: noinline nounwind optnone uwtable
define internal ptr @PyC_make_char(i8 noundef %0) #0 {
  %2 = alloca i8, align 1
  %3 = alloca ptr, align 8
  store i8 %0, ptr %2, align 1
  %4 = call ptr @PyCMem_Malloc(i32 noundef 40)
  store ptr %4, ptr %3, align 8
  %5 = load ptr, ptr %3, align 8
  %6 = getelementptr inbounds %struct._object, ptr %5, i32 0, i32 1
  %7 = getelementptr inbounds %struct.PyCTypeObject, ptr %6, i32 0, i32 0
  store ptr @"??_C@_04ENMBGAPA@char?$AA@", ptr %7, align 8
  %8 = load ptr, ptr %3, align 8
  %9 = getelementptr inbounds %struct.PyCCharObject, ptr %8, i32 0, i32 0
  %10 = getelementptr inbounds %struct.PyCVarObject, ptr %9, i32 0, i32 1
  store i32 1, ptr %10, align 8
  %11 = load i8, ptr %2, align 1
  %12 = load ptr, ptr %3, align 8
  %13 = getelementptr inbounds %struct.PyCCharObject, ptr %12, i32 0, i32 1
  store i8 %11, ptr %13, align 8
  %14 = load ptr, ptr %3, align 8
  ret ptr %14
}

; Function Attrs: noinline nounwind optnone uwtable
define internal ptr @PyC_make_double(double noundef %0) #0 {
  %2 = alloca double, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store double %0, ptr %2, align 8
  %5 = call ptr @PyCMem_Malloc(i32 noundef 40)
  store ptr %5, ptr %3, align 8
  %6 = load ptr, ptr %3, align 8
  %7 = getelementptr inbounds %struct._object, ptr %6, i32 0, i32 1
  %8 = getelementptr inbounds %struct.PyCTypeObject, ptr %7, i32 0, i32 0
  store ptr @"??_C@_06BNJCAIGJ@double?$AA@", ptr %8, align 8
  %9 = load double, ptr %2, align 8
  %10 = fcmp ogt double %9, 0.000000e+00
  %11 = zext i1 %10 to i64
  %12 = select i1 %10, i32 1, i32 -1
  store i32 %12, ptr %4, align 4
  %13 = load i32, ptr %4, align 4
  %14 = load ptr, ptr %3, align 8
  %15 = getelementptr inbounds %struct.PyCDoubleObject, ptr %14, i32 0, i32 0
  %16 = getelementptr inbounds %struct.PyCVarObject, ptr %15, i32 0, i32 1
  store i32 %13, ptr %16, align 8
  %17 = load i32, ptr %4, align 4
  %18 = sitofp i32 %17 to double
  %19 = load double, ptr %2, align 8
  %20 = fmul double %18, %19
  %21 = load ptr, ptr %3, align 8
  %22 = getelementptr inbounds %struct.PyCDoubleObject, ptr %21, i32 0, i32 1
  %23 = getelementptr inbounds [1 x double], ptr %22, i64 0, i64 0
  store double %20, ptr %23, align 8
  %24 = load ptr, ptr %3, align 8
  %25 = getelementptr inbounds %struct._object, ptr %24, i32 0, i32 1
  %26 = getelementptr inbounds %struct.PyCTypeObject, ptr %25, i32 0, i32 1
  store ptr @char_richcompare, ptr %26, align 8
  %27 = load ptr, ptr %3, align 8
  ret ptr %27
}

; Function Attrs: noinline nounwind optnone uwtable
define internal ptr @PyCList_New(i32 noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  store i32 %0, ptr %3, align 4
  %5 = load i32, ptr %3, align 4
  %6 = icmp slt i32 %5, 0
  br i1 %6, label %7, label %8

7:                                                ; preds = %1
  store ptr null, ptr %2, align 8
  br label %44

8:                                                ; preds = %1
  %9 = call ptr @PyCMem_Malloc(i32 noundef 48)
  store ptr %9, ptr %4, align 8
  %10 = load ptr, ptr %4, align 8
  %11 = icmp eq ptr %10, null
  br i1 %11, label %12, label %13

12:                                               ; preds = %8
  store ptr null, ptr %2, align 8
  br label %44

13:                                               ; preds = %8
  %14 = load ptr, ptr %4, align 8
  %15 = getelementptr inbounds %struct._object, ptr %14, i32 0, i32 1
  %16 = getelementptr inbounds %struct.PyCTypeObject, ptr %15, i32 0, i32 0
  store ptr @"??_C@_04DONFEANM@list?$AA@", ptr %16, align 8
  %17 = load i32, ptr %3, align 4
  %18 = icmp sle i32 %17, 0
  br i1 %18, label %19, label %22

19:                                               ; preds = %13
  %20 = load ptr, ptr %4, align 8
  %21 = getelementptr inbounds %struct.PyCListObject, ptr %20, i32 0, i32 1
  store ptr null, ptr %21, align 8
  br label %35

22:                                               ; preds = %13
  %23 = load i32, ptr %3, align 4
  %24 = call ptr @PyCMem_Calloc(i32 noundef %23, i32 noundef 8)
  %25 = load ptr, ptr %4, align 8
  %26 = getelementptr inbounds %struct.PyCListObject, ptr %25, i32 0, i32 1
  store ptr %24, ptr %26, align 8
  %27 = load ptr, ptr %4, align 8
  %28 = getelementptr inbounds %struct.PyCListObject, ptr %27, i32 0, i32 1
  %29 = load ptr, ptr %28, align 8
  %30 = icmp eq ptr %29, null
  br i1 %30, label %31, label %34

31:                                               ; preds = %22
  %32 = load ptr, ptr %4, align 8
  %33 = call ptr @PyC_DecRef(ptr noundef %32)
  store ptr null, ptr %2, align 8
  br label %44

34:                                               ; preds = %22
  br label %35

35:                                               ; preds = %34, %19
  %36 = load i32, ptr %3, align 4
  %37 = load ptr, ptr %4, align 8
  %38 = getelementptr inbounds %struct.PyCListObject, ptr %37, i32 0, i32 2
  store i32 %36, ptr %38, align 8
  %39 = load i32, ptr %3, align 4
  %40 = load ptr, ptr %4, align 8
  %41 = getelementptr inbounds %struct.PyCListObject, ptr %40, i32 0, i32 0
  %42 = getelementptr inbounds %struct.PyCVarObject, ptr %41, i32 0, i32 1
  store i32 %39, ptr %42, align 8
  %43 = load ptr, ptr %4, align 8
  store ptr %43, ptr %2, align 8
  br label %44

44:                                               ; preds = %35, %31, %12, %7
  %45 = load ptr, ptr %2, align 8
  ret ptr %45
}

declare dso_local i32 @PyCList_Append(ptr noundef, ptr noundef) #1

declare dso_local void @PyCList_remove(ptr noundef, ptr noundef) #1

; Function Attrs: noinline nounwind optnone uwtable
define internal ptr @PyCMem_Malloc(i32 noundef %0) #0 {
  %2 = alloca i32, align 4
  %3 = alloca ptr, align 8
  store i32 %0, ptr %2, align 4
  %4 = load i32, ptr %2, align 4
  %5 = call ptr @malloc(i32 noundef %4)
  store ptr %5, ptr %3, align 8
  %6 = load ptr, ptr %3, align 8
  %7 = getelementptr inbounds %struct._object, ptr %6, i32 0, i32 0
  store i32 0, ptr %7, align 8
  %8 = load ptr, ptr %3, align 8
  ret ptr %8
}

declare dso_local i32 @int64_t_richcompare(ptr noundef, ptr noundef, i32 noundef) #1

declare dso_local ptr @malloc(i32 noundef) #1

declare dso_local i32 @char_richcompare(ptr noundef, ptr noundef, i32 noundef) #1

; Function Attrs: noinline nounwind optnone uwtable
define internal ptr @PyCMem_Calloc(i32 noundef %0, i32 noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  store i32 %1, ptr %3, align 4
  store i32 %0, ptr %4, align 4
  %7 = load i32, ptr %3, align 4
  %8 = load i32, ptr %4, align 4
  %9 = mul nsw i32 %7, %8
  %10 = call ptr @malloc(i32 noundef %9)
  store ptr %10, ptr %5, align 8
  store i32 0, ptr %6, align 4
  store i32 0, ptr %6, align 4
  br label %11

11:                                               ; preds = %22, %2
  %12 = load i32, ptr %6, align 4
  %13 = load i32, ptr %3, align 4
  %14 = load i32, ptr %4, align 4
  %15 = mul nsw i32 %13, %14
  %16 = icmp slt i32 %12, %15
  br i1 %16, label %17, label %25

17:                                               ; preds = %11
  %18 = load ptr, ptr %5, align 8
  %19 = load i32, ptr %6, align 4
  %20 = sext i32 %19 to i64
  %21 = getelementptr inbounds i8, ptr %18, i64 %20
  store i8 0, ptr %21, align 1
  br label %22

22:                                               ; preds = %17
  %23 = load i32, ptr %6, align 4
  %24 = add nsw i32 %23, 1
  store i32 %24, ptr %6, align 4
  br label %11, !llvm.loop !6

25:                                               ; preds = %11
  %26 = load ptr, ptr %5, align 8
  ret ptr %26
}

; Function Attrs: noinline nounwind optnone uwtable
define internal ptr @PyC_DecRef(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 8
  %5 = load ptr, ptr %3, align 8
  %6 = getelementptr inbounds %struct._object, ptr %5, i32 0, i32 0
  %7 = load i32, ptr %6, align 8
  store i32 %7, ptr %4, align 4
  %8 = load i32, ptr %4, align 4
  %9 = sub nsw i32 %8, 1
  %10 = load ptr, ptr %3, align 8
  %11 = getelementptr inbounds %struct._object, ptr %10, i32 0, i32 0
  store i32 %9, ptr %11, align 8
  %12 = load ptr, ptr %3, align 8
  %13 = getelementptr inbounds %struct._object, ptr %12, i32 0, i32 0
  %14 = load i32, ptr %13, align 8
  %15 = icmp sle i32 %14, 0
  br i1 %15, label %16, label %18

16:                                               ; preds = %1
  %17 = load ptr, ptr %3, align 8
  call void @PyCMem_Free(ptr noundef %17)
  store ptr null, ptr %2, align 8
  br label %20

18:                                               ; preds = %1
  %19 = load ptr, ptr %3, align 8
  store ptr %19, ptr %2, align 8
  br label %20

20:                                               ; preds = %18, %16
  %21 = load ptr, ptr %2, align 8
  ret ptr %21
}

declare dso_local void @PyCMem_Free(ptr noundef) #1

attributes #0 = { noinline nounwind optnone uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 1, !"wchar_size", i32 2}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"uwtable", i32 2}
!3 = !{!"clang version 16.0.4"}
!4 = distinct !{!4, !5}
!5 = !{!"llvm.loop.mustprogress"}
!6 = distinct !{!6, !5}
