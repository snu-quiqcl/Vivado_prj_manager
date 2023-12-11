; ModuleID = "module"
target triple = "aarch64-none-unknown-elf"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"

%"class.goo" = type {i64, i64, i64, i64}
define i64 @"class.goo.__init__"(%"class.goo"* %"self", i64 %"d", i64 %"e", i64 %"f") 
{
entry:
  %".6" = getelementptr inbounds %"class.goo", %"class.goo"* %"self", i32 0, i32 0
  %".7" = getelementptr inbounds %"class.goo", %"class.goo"* %"self", i32 0, i32 1
  %".8" = getelementptr inbounds %"class.goo", %"class.goo"* %"self", i32 0, i32 2
  store i64 %"e", i64* %".8"
  ret i64 0
}

define i64 @"class.goo.mu"(%"class.goo"* %"self") 
{
entry:
  %".3" = getelementptr inbounds %"class.goo", %"class.goo"* %"self", i32 0, i32 3
  %".4" = add i64 50, 90
  %".5" = add i64 30, %".4"
  store i64 %".5", i64* %".3"
  %".7" = load i64, i64* %".3"
  ret i64 %".7"
}

define i64 @"foo"(i64 %"a", i64 %"b", i64 %"f") 
{
entry:
  %"c" = alloca i64
  %"goo_in" = alloca %"class.goo"
  %".5" = call i64 @"class.goo.__init__"(%"class.goo"* %"goo_in", i64 1, i64 2, i64 3)
  %".6" = call i64 @"class.goo.mu"(%"class.goo"* %"goo_in")
  %".7" = add i64 %".6", 50
  store i64 %".7", i64* %"c"
  %"c.1" = load i64, i64* %"c"
  %".9" = add i64 %"a", %"c.1"
  ret i64 %".9"
}

define i64 @"main"() 
{
entry:
  %"c" = alloca i64
  %"c.1" = load i64, i64* %"c"
  %".2" = icmp eq i64 %"c.1", 30
  br i1 %".2", label %"then", label %"else"
then:
  store i64 40, i64* %"c"
  br label %"ifcont"
else:
  store i64 60, i64* %"c"
  br label %"ifcont"
ifcont:
  ret i64 0
}
