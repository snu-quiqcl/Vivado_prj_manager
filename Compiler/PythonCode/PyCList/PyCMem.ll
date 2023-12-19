; ModuleID = 'PyCMem.c'
source_filename = "PyCMem.c"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc19.29.30133"

%struct._object = type { i32, %struct.PyCTypeObject }
%struct.PyCTypeObject = type { ptr, ptr }

$"??_C@_04HIBGFPH@NULL?$AA@" = comdat any

$"??_C@_06ICGJLFIM@string?$AA@" = comdat any

$"??_C@_04DONFEANM@list?$AA@" = comdat any

@"??_C@_04HIBGFPH@NULL?$AA@" = linkonce_odr dso_local unnamed_addr constant [5 x i8] c"NULL\00", comdat, align 1
@"??_C@_06ICGJLFIM@string?$AA@" = linkonce_odr dso_local unnamed_addr constant [7 x i8] c"string\00", comdat, align 1
@"??_C@_04DONFEANM@list?$AA@" = linkonce_odr dso_local unnamed_addr constant [5 x i8] c"list\00", comdat, align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @PyCMem_Free(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  %3 = load ptr, ptr %2, align 8
  %4 = getelementptr inbounds %struct._object, ptr %3, i32 0, i32 1
  %5 = getelementptr inbounds %struct.PyCTypeObject, ptr %4, i32 0, i32 0
  %6 = load ptr, ptr %5, align 8
  %7 = call i32 @strcmp(ptr noundef %6, ptr noundef @"??_C@_04HIBGFPH@NULL?$AA@")
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %9, label %11

9:                                                ; preds = %1
  %10 = load ptr, ptr %2, align 8
  call void @free(ptr noundef %10)
  br label %32

11:                                               ; preds = %1
  %12 = load ptr, ptr %2, align 8
  %13 = getelementptr inbounds %struct._object, ptr %12, i32 0, i32 1
  %14 = getelementptr inbounds %struct.PyCTypeObject, ptr %13, i32 0, i32 0
  %15 = load ptr, ptr %14, align 8
  %16 = call i32 @strcmp(ptr noundef %15, ptr noundef @"??_C@_06ICGJLFIM@string?$AA@")
  %17 = icmp eq i32 %16, 0
  br i1 %17, label %18, label %19

18:                                               ; preds = %11
  br label %31

19:                                               ; preds = %11
  %20 = load ptr, ptr %2, align 8
  %21 = getelementptr inbounds %struct._object, ptr %20, i32 0, i32 1
  %22 = getelementptr inbounds %struct.PyCTypeObject, ptr %21, i32 0, i32 0
  %23 = load ptr, ptr %22, align 8
  %24 = call i32 @strcmp(ptr noundef %23, ptr noundef @"??_C@_04DONFEANM@list?$AA@")
  %25 = icmp eq i32 %24, 0
  br i1 %25, label %26, label %28

26:                                               ; preds = %19
  %27 = load ptr, ptr %2, align 8
  call void @PyCList_dealloc(ptr noundef %27)
  br label %30

28:                                               ; preds = %19
  %29 = load ptr, ptr %2, align 8
  call void @free(ptr noundef %29)
  br label %32

30:                                               ; preds = %26
  br label %31

31:                                               ; preds = %30, %18
  br label %32

32:                                               ; preds = %28, %31, %9
  ret void
}

declare dso_local i32 @strcmp(ptr noundef, ptr noundef) #1

declare dso_local void @free(ptr noundef) #1

declare dso_local void @PyCList_dealloc(ptr noundef) #1

attributes #0 = { noinline nounwind optnone uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 1, !"wchar_size", i32 2}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"uwtable", i32 2}
!3 = !{!"clang version 16.0.4"}
