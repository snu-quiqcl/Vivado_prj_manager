; ModuleID = "module"
target triple = "aarch64-none-unknown-elf"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"

%"class.PyObject" = type {i8*, i64, i64, i64}
declare void @"xil_printf"(i8* %".1", ...) 

declare i8* @"malloc"(i64 %".1", ...) 

declare void @"free"(i8* %".1", ...) 

define %"class.PyObject"* @"class.PyObject.__init__"(%"class.PyObject"* %"self", i8* %"value_addr", i64 %"size", i64 %"value_type") 
{
entry:
  %".6" = getelementptr inbounds %"class.PyObject", %"class.PyObject"* %"self", i32 0, i32 0
  %".7" = getelementptr inbounds %"class.PyObject", %"class.PyObject"* %"self", i32 0, i32 1
  %".8" = getelementptr inbounds %"class.PyObject", %"class.PyObject"* %"self", i32 0, i32 2
  %".9" = getelementptr inbounds %"class.PyObject", %"class.PyObject"* %"self", i32 0, i32 3
  store i8* %"value_addr", i8** %".6"
  store i64 1, i64* %".7"
  store i64 %"size", i64* %".8"
  store i64 %"value_type", i64* %".9"
  ret %"class.PyObject"* %"self"
}

define i64 @"main"() 
{
entry:
  %"c" = alloca i64
  %".2" = call i8* (i64, ...) @"malloc"(i64 8)
  %".3" = load i64, i64* %"c"
  %".4" = bitcast i8* %".2" to i64*
  store i64 %".3", i64* %".4"
  %"c.1" = alloca %"class.PyObject"
  %".6" = bitcast i64* %"c" to i8*
  %".7" = call %"class.PyObject"* @"class.PyObject.__init__"(%"class.PyObject"* %"c.1", i8* %".6", i64 1, i64 8)
  ret i64 0
}
