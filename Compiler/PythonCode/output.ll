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

define %"class.PyObject"* @"main"() 
{
entry:
  %".2" = alloca i64
  store i64 3, i64* %".2"
  store i64 3, i64* %".2"
  %".5" = getelementptr inbounds i64, i64* null, i64 1
  %".6" = ptrtoint i64* %".5" to i64
  %".7" = getelementptr inbounds %"class.PyObject", %"class.PyObject"* null, i64 1
  %".8" = ptrtoint %"class.PyObject"* %".7" to i64
  %".9" = call i8* (i64, ...) @"malloc"(i64 %".8")
  %".10" = bitcast i8* %".9" to %"class.PyObject"*
  %".11" = bitcast i64* %".2" to i8*
  %"c" = call %"class.PyObject"* @"class.PyObject.__init__"(%"class.PyObject"* %".10", i8* %".11", i64 1, i64 %".6")
  %".13" = alloca i64
  store i64 30, i64* %".13"
  store i64 30, i64* %".13"
  %".16" = getelementptr inbounds i64, i64* null, i64 1
  %".17" = ptrtoint i64* %".16" to i64
  %".18" = getelementptr inbounds %"class.PyObject", %"class.PyObject"* null, i64 1
  %".19" = ptrtoint %"class.PyObject"* %".18" to i64
  %".20" = call i8* (i64, ...) @"malloc"(i64 %".19")
  %".21" = bitcast i8* %".20" to %"class.PyObject"*
  %".22" = bitcast i64* %".13" to i8*
  %"d" = call %"class.PyObject"* @"class.PyObject.__init__"(%"class.PyObject"* %".21", i8* %".22", i64 1, i64 %".17")
  ret %"class.PyObject"* null
}
