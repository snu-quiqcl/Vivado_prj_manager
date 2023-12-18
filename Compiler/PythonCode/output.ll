; ModuleID = "module"
target triple = "aarch64-none-unknown-elf"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"

declare void @"xil_printf"(i8* %".1", ...) 

declare i8* @"malloc"(i64 %".1", ...) 

declare void @"free"(i8* %".1", ...) 

@".str0" = internal constant [8 x i8] c"hello\0a\0d\00"
@".str1" = internal constant [7 x i8] c"c = %d\00"
define i64 @"main"() 
{
entry:
  %".2" = alloca i64
  store i64 3, i64* %".2"
  store i64 3, i64* %".2"
  %".5" = alloca i64
  store i64 30, i64* %".5"
  %".7" = alloca i8*
  %".8" = bitcast [8 x i8]* @".str0" to i8*
  store i8* %".8", i8** %".7"
  %".10" = load i8*, i8** %".7"
  call void (i8*, ...) @"xil_printf"(i8* %".10")
  %"c" = load i64, i64* %".2"
  %".12" = icmp eq i64 %"c", 30
  %"c.1" = load i64, i64* %".2"
  %".13" = icmp sgt i64 %"c.1", 20
  %".14" = or i1 %".12", %".13"
  br i1 %".14", label %"then", label %"else"
then:
  store i64 40, i64* %".2"
  br label %"ifcont"
else:
  %"c.2" = load i64, i64* %".2"
  %".18" = icmp eq i64 %"c.2", 50
  br i1 %".18", label %"then.1", label %"else.1"
ifcont:
  %".30" = alloca i8*
  %".31" = bitcast [7 x i8]* @".str1" to i8*
  store i8* %".31", i8** %".30"
  %".33" = load i8*, i8** %".30"
  %"c.4" = load i64, i64* %".2"
  call void (i8*, ...) @"xil_printf"(i8* %".33", i64 %"c.4")
  ret i64 0
then.1:
  store i64 60, i64* %".2"
  br label %"ifcont.1"
else.1:
  %"c.3" = load i64, i64* %".2"
  %".22" = icmp eq i64 %"c.3", 60
  br i1 %".22", label %"then.2", label %"else.2"
ifcont.1:
  br label %"ifcont"
then.2:
  store i64 70, i64* %".2"
  br label %"ifcont.2"
else.2:
  store i64 60, i64* %".2"
  br label %"ifcont.2"
ifcont.2:
  br label %"ifcont.1"
}
