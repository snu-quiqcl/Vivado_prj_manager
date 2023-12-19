; ModuleID = 'PyCList.c'
source_filename = "PyCList.c"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc19.29.30133"

%struct.PyCListObject = type { %struct.PyCVarObject, ptr, i32 }
%struct.PyCVarObject = type { %struct._object, i32 }
%struct._object = type { i32, %struct.PyCTypeObject }
%struct.PyCTypeObject = type { ptr, ptr }

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @PyCList_Insert(ptr noundef %0, i32 noundef %1, ptr noundef %2) #0 {
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  %6 = alloca ptr, align 8
  store ptr %2, ptr %4, align 8
  store i32 %1, ptr %5, align 4
  store ptr %0, ptr %6, align 8
  %7 = load ptr, ptr %4, align 8
  %8 = load i32, ptr %5, align 4
  %9 = load ptr, ptr %6, align 8
  %10 = call i32 @ins1(ptr noundef %9, i32 noundef %8, ptr noundef %7)
  ret i32 %10
}

; Function Attrs: noinline nounwind optnone uwtable
define internal i32 @ins1(ptr noundef %0, i32 noundef %1, ptr noundef %2) #0 {
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  %7 = alloca ptr, align 8
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca ptr, align 8
  store ptr %2, ptr %5, align 8
  store i32 %1, ptr %6, align 4
  store ptr %0, ptr %7, align 8
  %11 = load ptr, ptr %7, align 8
  %12 = getelementptr inbounds %struct.PyCListObject, ptr %11, i32 0, i32 0
  %13 = getelementptr inbounds %struct.PyCVarObject, ptr %12, i32 0, i32 1
  %14 = load i32, ptr %13, align 8
  store i32 %14, ptr %9, align 4
  %15 = load ptr, ptr %5, align 8
  %16 = icmp eq ptr %15, null
  br i1 %16, label %17, label %18

17:                                               ; preds = %3
  store i32 -1, ptr %4, align 4
  br label %70

18:                                               ; preds = %3
  %19 = load i32, ptr %9, align 4
  %20 = add nsw i32 %19, 1
  %21 = load ptr, ptr %7, align 8
  %22 = call i32 @list_resize(ptr noundef %21, i32 noundef %20)
  %23 = icmp slt i32 %22, 0
  br i1 %23, label %24, label %25

24:                                               ; preds = %18
  store i32 -1, ptr %4, align 4
  br label %70

25:                                               ; preds = %18
  %26 = load i32, ptr %6, align 4
  %27 = icmp slt i32 %26, 0
  br i1 %27, label %28, label %36

28:                                               ; preds = %25
  %29 = load i32, ptr %9, align 4
  %30 = load i32, ptr %6, align 4
  %31 = add nsw i32 %30, %29
  store i32 %31, ptr %6, align 4
  %32 = load i32, ptr %6, align 4
  %33 = icmp slt i32 %32, 0
  br i1 %33, label %34, label %35

34:                                               ; preds = %28
  store i32 0, ptr %6, align 4
  br label %35

35:                                               ; preds = %34, %28
  br label %36

36:                                               ; preds = %35, %25
  %37 = load i32, ptr %6, align 4
  %38 = load i32, ptr %9, align 4
  %39 = icmp sgt i32 %37, %38
  br i1 %39, label %40, label %42

40:                                               ; preds = %36
  %41 = load i32, ptr %9, align 4
  store i32 %41, ptr %6, align 4
  br label %42

42:                                               ; preds = %40, %36
  %43 = load ptr, ptr %7, align 8
  %44 = getelementptr inbounds %struct.PyCListObject, ptr %43, i32 0, i32 1
  %45 = load ptr, ptr %44, align 8
  store ptr %45, ptr %10, align 8
  %46 = load i32, ptr %9, align 4
  store i32 %46, ptr %8, align 4
  br label %47

47:                                               ; preds = %52, %42
  %48 = load i32, ptr %8, align 4
  %49 = add nsw i32 %48, -1
  store i32 %49, ptr %8, align 4
  %50 = load i32, ptr %6, align 4
  %51 = icmp sge i32 %49, %50
  br i1 %51, label %52, label %63

52:                                               ; preds = %47
  %53 = load ptr, ptr %10, align 8
  %54 = load i32, ptr %8, align 4
  %55 = sext i32 %54 to i64
  %56 = getelementptr inbounds ptr, ptr %53, i64 %55
  %57 = load ptr, ptr %56, align 8
  %58 = load ptr, ptr %10, align 8
  %59 = load i32, ptr %8, align 4
  %60 = add nsw i32 %59, 1
  %61 = sext i32 %60 to i64
  %62 = getelementptr inbounds ptr, ptr %58, i64 %61
  store ptr %57, ptr %62, align 8
  br label %47, !llvm.loop !4

63:                                               ; preds = %47
  %64 = load ptr, ptr %5, align 8
  %65 = call ptr @PyC_IncRef(ptr noundef %64)
  %66 = load ptr, ptr %10, align 8
  %67 = load i32, ptr %6, align 4
  %68 = sext i32 %67 to i64
  %69 = getelementptr inbounds ptr, ptr %66, i64 %68
  store ptr %65, ptr %69, align 8
  store i32 0, ptr %4, align 4
  br label %70

70:                                               ; preds = %63, %24, %17
  %71 = load i32, ptr %4, align 4
  ret i32 %71
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @_PyCList_AppendTakeRefListResize(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  store ptr %1, ptr %4, align 8
  store ptr %0, ptr %5, align 8
  %7 = load ptr, ptr %5, align 8
  %8 = getelementptr inbounds %struct.PyCListObject, ptr %7, i32 0, i32 0
  %9 = getelementptr inbounds %struct.PyCVarObject, ptr %8, i32 0, i32 1
  %10 = load i32, ptr %9, align 8
  store i32 %10, ptr %6, align 4
  %11 = load i32, ptr %6, align 4
  %12 = add nsw i32 %11, 1
  %13 = load ptr, ptr %5, align 8
  %14 = call i32 @list_resize(ptr noundef %13, i32 noundef %12)
  %15 = icmp slt i32 %14, 0
  br i1 %15, label %16, label %19

16:                                               ; preds = %2
  %17 = load ptr, ptr %4, align 8
  %18 = call ptr @PyC_DecRef(ptr noundef %17)
  store i32 -1, ptr %3, align 4
  br label %23

19:                                               ; preds = %2
  %20 = load ptr, ptr %4, align 8
  %21 = load i32, ptr %6, align 4
  %22 = load ptr, ptr %5, align 8
  call void @PyCList_SET_ITEM(ptr noundef %22, i32 noundef %21, ptr noundef %20)
  store i32 0, ptr %3, align 4
  br label %23

23:                                               ; preds = %19, %16
  %24 = load i32, ptr %3, align 4
  ret i32 %24
}

; Function Attrs: noinline nounwind optnone uwtable
define internal i32 @list_resize(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  store i32 %1, ptr %4, align 4
  store ptr %0, ptr %5, align 8
  store ptr null, ptr %6, align 8
  %10 = load ptr, ptr %5, align 8
  %11 = getelementptr inbounds %struct.PyCListObject, ptr %10, i32 0, i32 2
  %12 = load i32, ptr %11, align 8
  store i32 %12, ptr %9, align 4
  %13 = load i32, ptr %9, align 4
  %14 = load i32, ptr %4, align 4
  %15 = icmp sge i32 %13, %14
  br i1 %15, label %16, label %26

16:                                               ; preds = %2
  %17 = load i32, ptr %4, align 4
  %18 = load i32, ptr %9, align 4
  %19 = ashr i32 %18, 1
  %20 = icmp sge i32 %17, %19
  br i1 %20, label %21, label %26

21:                                               ; preds = %16
  %22 = load i32, ptr %4, align 4
  %23 = load ptr, ptr %5, align 8
  %24 = getelementptr inbounds %struct.PyCListObject, ptr %23, i32 0, i32 0
  %25 = getelementptr inbounds %struct.PyCVarObject, ptr %24, i32 0, i32 1
  store i32 %22, ptr %25, align 8
  store i32 0, ptr %3, align 4
  br label %81

26:                                               ; preds = %16, %2
  %27 = load i32, ptr %4, align 4
  %28 = load i32, ptr %4, align 4
  %29 = ashr i32 %28, 3
  %30 = add nsw i32 %27, %29
  %31 = add nsw i32 %30, 6
  %32 = and i32 %31, -4
  store i32 %32, ptr %7, align 4
  %33 = load i32, ptr %4, align 4
  %34 = load ptr, ptr %5, align 8
  %35 = getelementptr inbounds %struct.PyCListObject, ptr %34, i32 0, i32 0
  %36 = getelementptr inbounds %struct.PyCVarObject, ptr %35, i32 0, i32 1
  %37 = load i32, ptr %36, align 8
  %38 = sub nsw i32 %33, %37
  %39 = load i32, ptr %7, align 4
  %40 = load i32, ptr %4, align 4
  %41 = sub nsw i32 %39, %40
  %42 = icmp sgt i32 %38, %41
  br i1 %42, label %43, label %47

43:                                               ; preds = %26
  %44 = load i32, ptr %4, align 4
  %45 = add nsw i32 %44, 3
  %46 = and i32 %45, -4
  store i32 %46, ptr %7, align 4
  br label %47

47:                                               ; preds = %43, %26
  %48 = load i32, ptr %4, align 4
  %49 = icmp eq i32 %48, 0
  br i1 %49, label %50, label %51

50:                                               ; preds = %47
  store i32 0, ptr %7, align 4
  br label %51

51:                                               ; preds = %50, %47
  %52 = load i32, ptr %7, align 4
  %53 = sext i32 %52 to i64
  %54 = icmp ule i64 %53, 125000000
  br i1 %54, label %55, label %65

55:                                               ; preds = %51
  %56 = load i32, ptr %7, align 4
  %57 = sext i32 %56 to i64
  %58 = mul i64 %57, 8
  %59 = trunc i64 %58 to i32
  store i32 %59, ptr %8, align 4
  %60 = load i32, ptr %8, align 4
  %61 = load ptr, ptr %5, align 8
  %62 = getelementptr inbounds %struct.PyCListObject, ptr %61, i32 0, i32 1
  %63 = load ptr, ptr %62, align 8
  %64 = call ptr @PyCMem_Realloc(ptr noundef %63, i32 noundef %60)
  store ptr %64, ptr %6, align 8
  br label %66

65:                                               ; preds = %51
  store ptr null, ptr %6, align 8
  br label %66

66:                                               ; preds = %65, %55
  %67 = load ptr, ptr %6, align 8
  %68 = icmp eq ptr %67, null
  br i1 %68, label %69, label %70

69:                                               ; preds = %66
  store i32 -1, ptr %3, align 4
  br label %81

70:                                               ; preds = %66
  %71 = load ptr, ptr %6, align 8
  %72 = load ptr, ptr %5, align 8
  %73 = getelementptr inbounds %struct.PyCListObject, ptr %72, i32 0, i32 1
  store ptr %71, ptr %73, align 8
  %74 = load i32, ptr %4, align 4
  %75 = load ptr, ptr %5, align 8
  %76 = getelementptr inbounds %struct.PyCListObject, ptr %75, i32 0, i32 0
  %77 = getelementptr inbounds %struct.PyCVarObject, ptr %76, i32 0, i32 1
  store i32 %74, ptr %77, align 8
  %78 = load i32, ptr %7, align 4
  %79 = load ptr, ptr %5, align 8
  %80 = getelementptr inbounds %struct.PyCListObject, ptr %79, i32 0, i32 2
  store i32 %78, ptr %80, align 8
  store i32 0, ptr %3, align 4
  br label %81

81:                                               ; preds = %70, %69, %21
  %82 = load i32, ptr %3, align 4
  ret i32 %82
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

; Function Attrs: noinline nounwind optnone uwtable
define internal void @PyCList_SET_ITEM(ptr noundef %0, i32 noundef %1, ptr noundef %2) #0 {
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  %6 = alloca ptr, align 8
  store ptr %2, ptr %4, align 8
  store i32 %1, ptr %5, align 4
  store ptr %0, ptr %6, align 8
  %7 = load ptr, ptr %4, align 8
  %8 = load ptr, ptr %6, align 8
  %9 = getelementptr inbounds %struct.PyCListObject, ptr %8, i32 0, i32 1
  %10 = load ptr, ptr %9, align 8
  %11 = load i32, ptr %5, align 4
  %12 = sext i32 %11 to i64
  %13 = getelementptr inbounds ptr, ptr %10, i64 %12
  store ptr %7, ptr %13, align 8
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @PyCList_Append(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  store ptr %1, ptr %4, align 8
  store ptr %0, ptr %5, align 8
  %6 = load ptr, ptr %4, align 8
  %7 = icmp ne ptr %6, null
  br i1 %7, label %8, label %13

8:                                                ; preds = %2
  %9 = load ptr, ptr %4, align 8
  %10 = call ptr @PyC_IncRef(ptr noundef %9)
  %11 = load ptr, ptr %5, align 8
  %12 = call i32 @_PyCList_AppendTakeRefListResize(ptr noundef %11, ptr noundef %10)
  store i32 %12, ptr %3, align 4
  br label %14

13:                                               ; preds = %2
  store i32 -1, ptr %3, align 4
  br label %14

14:                                               ; preds = %13, %8
  %15 = load i32, ptr %3, align 4
  ret i32 %15
}

; Function Attrs: noinline nounwind optnone uwtable
define internal ptr @PyC_IncRef(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = getelementptr inbounds %struct._object, ptr %4, i32 0, i32 0
  %6 = load i32, ptr %5, align 8
  store i32 %6, ptr %3, align 4
  %7 = load i32, ptr %3, align 4
  %8 = add nsw i32 %7, 1
  %9 = load ptr, ptr %2, align 8
  %10 = getelementptr inbounds %struct._object, ptr %9, i32 0, i32 0
  store i32 %8, ptr %10, align 8
  %11 = load ptr, ptr %2, align 8
  ret ptr %11
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @PyCList_dealloc(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 8
  %4 = load ptr, ptr %2, align 8
  %5 = getelementptr inbounds %struct.PyCListObject, ptr %4, i32 0, i32 1
  %6 = load ptr, ptr %5, align 8
  %7 = icmp ne ptr %6, null
  br i1 %7, label %8, label %30

8:                                                ; preds = %1
  %9 = load ptr, ptr %2, align 8
  %10 = getelementptr inbounds %struct.PyCListObject, ptr %9, i32 0, i32 0
  %11 = getelementptr inbounds %struct.PyCVarObject, ptr %10, i32 0, i32 1
  %12 = load i32, ptr %11, align 8
  store i32 %12, ptr %3, align 4
  br label %13

13:                                               ; preds = %17, %8
  %14 = load i32, ptr %3, align 4
  %15 = add nsw i32 %14, -1
  store i32 %15, ptr %3, align 4
  %16 = icmp sge i32 %15, 0
  br i1 %16, label %17, label %26

17:                                               ; preds = %13
  %18 = load ptr, ptr %2, align 8
  %19 = getelementptr inbounds %struct.PyCListObject, ptr %18, i32 0, i32 1
  %20 = load ptr, ptr %19, align 8
  %21 = load i32, ptr %3, align 4
  %22 = sext i32 %21 to i64
  %23 = getelementptr inbounds ptr, ptr %20, i64 %22
  %24 = load ptr, ptr %23, align 8
  %25 = call ptr @PyC_DecRef(ptr noundef %24)
  br label %13, !llvm.loop !6

26:                                               ; preds = %13
  %27 = load ptr, ptr %2, align 8
  %28 = getelementptr inbounds %struct.PyCListObject, ptr %27, i32 0, i32 1
  %29 = load ptr, ptr %28, align 8
  call void @free(ptr noundef %29)
  br label %30

30:                                               ; preds = %26, %1
  ret void
}

declare dso_local void @free(ptr noundef) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @PyCList_remove(ptr noundef %0, ptr noundef %1) #0 {
  %3 = alloca ptr, align 8
  %4 = alloca ptr, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca ptr, align 8
  %8 = alloca i32, align 4
  store ptr %1, ptr %3, align 8
  store ptr %0, ptr %4, align 8
  store i32 0, ptr %5, align 4
  br label %9

9:                                                ; preds = %86, %2
  %10 = load i32, ptr %5, align 4
  %11 = load ptr, ptr %4, align 8
  %12 = getelementptr inbounds %struct.PyCListObject, ptr %11, i32 0, i32 0
  %13 = getelementptr inbounds %struct.PyCVarObject, ptr %12, i32 0, i32 1
  %14 = load i32, ptr %13, align 8
  %15 = icmp slt i32 %10, %14
  br i1 %15, label %16, label %89

16:                                               ; preds = %9
  %17 = load ptr, ptr %4, align 8
  %18 = getelementptr inbounds %struct.PyCListObject, ptr %17, i32 0, i32 1
  %19 = load ptr, ptr %18, align 8
  %20 = load i32, ptr %5, align 4
  %21 = sext i32 %20 to i64
  %22 = getelementptr inbounds ptr, ptr %19, i64 %21
  %23 = load ptr, ptr %22, align 8
  store ptr %23, ptr %7, align 8
  %24 = load ptr, ptr %3, align 8
  %25 = load ptr, ptr %7, align 8
  %26 = call i32 @PyCObject_RichCompareBool(ptr noundef %25, ptr noundef %24, i32 noundef 0)
  store i32 %26, ptr %8, align 4
  %27 = load i32, ptr %8, align 4
  %28 = icmp sgt i32 %27, 0
  br i1 %28, label %29, label %85

29:                                               ; preds = %16
  %30 = load ptr, ptr %4, align 8
  %31 = getelementptr inbounds %struct.PyCListObject, ptr %30, i32 0, i32 1
  %32 = load ptr, ptr %31, align 8
  %33 = load i32, ptr %5, align 4
  %34 = sext i32 %33 to i64
  %35 = getelementptr inbounds ptr, ptr %32, i64 %34
  %36 = load ptr, ptr %35, align 8
  %37 = call ptr @PyC_DecRef(ptr noundef %36)
  %38 = load i32, ptr %5, align 4
  %39 = add nsw i32 %38, 1
  store i32 %39, ptr %6, align 4
  br label %40

40:                                               ; preds = %62, %29
  %41 = load i32, ptr %6, align 4
  %42 = load ptr, ptr %4, align 8
  %43 = getelementptr inbounds %struct.PyCListObject, ptr %42, i32 0, i32 0
  %44 = getelementptr inbounds %struct.PyCVarObject, ptr %43, i32 0, i32 1
  %45 = load i32, ptr %44, align 8
  %46 = icmp slt i32 %41, %45
  br i1 %46, label %47, label %65

47:                                               ; preds = %40
  %48 = load ptr, ptr %4, align 8
  %49 = getelementptr inbounds %struct.PyCListObject, ptr %48, i32 0, i32 1
  %50 = load ptr, ptr %49, align 8
  %51 = load i32, ptr %6, align 4
  %52 = sext i32 %51 to i64
  %53 = getelementptr inbounds ptr, ptr %50, i64 %52
  %54 = load ptr, ptr %53, align 8
  %55 = load ptr, ptr %4, align 8
  %56 = getelementptr inbounds %struct.PyCListObject, ptr %55, i32 0, i32 1
  %57 = load ptr, ptr %56, align 8
  %58 = load i32, ptr %6, align 4
  %59 = sub nsw i32 %58, 1
  %60 = sext i32 %59 to i64
  %61 = getelementptr inbounds ptr, ptr %57, i64 %60
  store ptr %54, ptr %61, align 8
  br label %62

62:                                               ; preds = %47
  %63 = load i32, ptr %6, align 4
  %64 = add nsw i32 %63, 1
  store i32 %64, ptr %6, align 4
  br label %40, !llvm.loop !7

65:                                               ; preds = %40
  %66 = load ptr, ptr %4, align 8
  %67 = getelementptr inbounds %struct.PyCListObject, ptr %66, i32 0, i32 0
  %68 = getelementptr inbounds %struct.PyCVarObject, ptr %67, i32 0, i32 1
  %69 = load i32, ptr %68, align 8
  %70 = sub nsw i32 %69, 1
  %71 = load ptr, ptr %4, align 8
  %72 = getelementptr inbounds %struct.PyCListObject, ptr %71, i32 0, i32 1
  %73 = load ptr, ptr %72, align 8
  %74 = call ptr @PyCMem_Realloc(ptr noundef %73, i32 noundef %70)
  %75 = load ptr, ptr %4, align 8
  %76 = getelementptr inbounds %struct.PyCListObject, ptr %75, i32 0, i32 1
  store ptr %74, ptr %76, align 8
  %77 = load ptr, ptr %4, align 8
  %78 = getelementptr inbounds %struct.PyCListObject, ptr %77, i32 0, i32 0
  %79 = getelementptr inbounds %struct.PyCVarObject, ptr %78, i32 0, i32 1
  %80 = load i32, ptr %79, align 8
  %81 = sub nsw i32 %80, 1
  %82 = load ptr, ptr %4, align 8
  %83 = getelementptr inbounds %struct.PyCListObject, ptr %82, i32 0, i32 0
  %84 = getelementptr inbounds %struct.PyCVarObject, ptr %83, i32 0, i32 1
  store i32 %81, ptr %84, align 8
  br label %85

85:                                               ; preds = %65, %16
  br label %86

86:                                               ; preds = %85
  %87 = load i32, ptr %5, align 4
  %88 = add nsw i32 %87, 1
  store i32 %88, ptr %5, align 4
  br label %9, !llvm.loop !8

89:                                               ; preds = %9
  ret void
}

declare dso_local i32 @PyCObject_RichCompareBool(ptr noundef, ptr noundef, i32 noundef) #1

; Function Attrs: noinline nounwind optnone uwtable
define internal ptr @PyCMem_Realloc(ptr noundef %0, i32 noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  %5 = alloca ptr, align 8
  %6 = alloca i32, align 4
  store i32 %1, ptr %3, align 4
  store ptr %0, ptr %4, align 8
  %7 = load ptr, ptr %4, align 8
  %8 = icmp eq ptr %7, null
  br i1 %8, label %9, label %25

9:                                                ; preds = %2
  %10 = load i32, ptr %3, align 4
  %11 = call ptr @malloc(i32 noundef %10)
  store ptr %11, ptr %5, align 8
  store i32 0, ptr %6, align 4
  store i32 0, ptr %6, align 4
  br label %12

12:                                               ; preds = %21, %9
  %13 = load i32, ptr %6, align 4
  %14 = load i32, ptr %3, align 4
  %15 = icmp slt i32 %13, %14
  br i1 %15, label %16, label %24

16:                                               ; preds = %12
  %17 = load ptr, ptr %5, align 8
  %18 = load i32, ptr %6, align 4
  %19 = sext i32 %18 to i64
  %20 = getelementptr inbounds i8, ptr %17, i64 %19
  store i8 0, ptr %20, align 1
  br label %21

21:                                               ; preds = %16
  %22 = load i32, ptr %6, align 4
  %23 = add nsw i32 %22, 1
  store i32 %23, ptr %6, align 4
  br label %12, !llvm.loop !9

24:                                               ; preds = %12
  br label %29

25:                                               ; preds = %2
  %26 = load i32, ptr %3, align 4
  %27 = load ptr, ptr %4, align 8
  %28 = call ptr @realloc(ptr noundef %27, i32 noundef %26)
  store ptr %28, ptr %5, align 8
  br label %29

29:                                               ; preds = %25, %24
  %30 = load ptr, ptr %5, align 8
  ret ptr %30
}

declare dso_local void @PyCMem_Free(ptr noundef) #1

declare dso_local ptr @malloc(i32 noundef) #1

declare dso_local ptr @realloc(ptr noundef, i32 noundef) #1

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
!7 = distinct !{!7, !5}
!8 = distinct !{!8, !5}
!9 = distinct !{!9, !5}
