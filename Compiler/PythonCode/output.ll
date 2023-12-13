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
  store i64 1, i64* %".7"
  store i64 %"size", i64* %".8"
  store i64 %"value_type", i64* %".9"
  %".13" = load i64, i64* %".8"
  %".14" = call i8* (i64, ...) @"malloc"(i64 %".13")
  br label %"loop"
prepare:
  %".16" = alloca i64, i32 0
  %".17" = load i64, i64* %".16"
  %"condition" = icmp slt i64 %".17", %"size"
  br i1 %"condition", label %"loop", label %"end"
loop:
  %"victim.value" = alloca i8*
  %".19" = load i64, i64* %".16"
  %".20" = getelementptr i8, i8* %"value_addr", i64 %".19"
  %".21" = load i64, i64* %".16"
  %".22" = getelementptr i8, i8* %".14", i64 %".21"
  %".23" = load i8, i8* %".20"
  store i8 %".23", i8* %".22"
  br label %"after_loop"
after_loop:
  %".26" = load i64, i64* %".16"
  %".27" = add i64 %".26", 1
  store i64 %".27", i64* %".16"
  %".29" = load i64, i64* %".16"
  %".30" = icmp slt i64 %".29", %"size"
  br i1 %".30", label %"loop", label %"end"
end:
  ret %"class.PyObject"* %"self"
}

define %"class.PyObject"* @"class.PyObject.set_value"(%"class.PyObject"* %"self", %"class.PyObject"* %"victim") 
{
entry:
  %".4" = getelementptr inbounds %"class.PyObject", %"class.PyObject"* %"self", i32 0, i32 0
  %".5" = getelementptr inbounds %"class.PyObject", %"class.PyObject"* %"self", i32 0, i32 1
  %".6" = getelementptr inbounds %"class.PyObject", %"class.PyObject"* %"self", i32 0, i32 2
  %".7" = getelementptr inbounds %"class.PyObject", %"class.PyObject"* %"self", i32 0, i32 3
  %".8" = getelementptr inbounds %"class.PyObject", %"class.PyObject"* %"victim", i32 0, i32 0
  %".9" = getelementptr inbounds %"class.PyObject", %"class.PyObject"* %"victim", i32 0, i32 1
  %".10" = getelementptr inbounds %"class.PyObject", %"class.PyObject"* %"victim", i32 0, i32 2
  %".11" = getelementptr inbounds %"class.PyObject", %"class.PyObject"* %"victim", i32 0, i32 3
  %".12" = load i8*, i8** %".4"
  %".13" = icmp ne i8* %".12", null
  br i1 %".13", label %"entry.if", label %"entry.endif"
entry.if:
  %".15" = load i8*, i8** %".4"
  call void (i8*, ...) @"free"(i8* %".15")
  br label %"entry.endif"
entry.endif:
  %".18" = load i64, i64* %".10"
  %".19" = call i8* (i64, ...) @"malloc"(i64 %".18")
  store i8* %".19", i8** %".4"
  store i64 %".18", i64* %".6"
  br label %"loop"
prepare:
  %".23" = alloca i64, i32 0
  %".24" = load i64, i64* %".23"
  %"condition" = icmp slt i64 %".24", %".18"
  br i1 %"condition", label %"loop", label %"end"
loop:
  %"victim.value" = alloca i8*
  %".26" = load i8*, i8** %".8"
  %".27" = load i64, i64* %".23"
  %".28" = getelementptr i8, i8* %".26", i64 %".27"
  %".29" = load i8*, i8** %".4"
  %".30" = load i64, i64* %".23"
  %".31" = getelementptr i8, i8* %".29", i64 %".30"
  %".32" = load i8, i8* %".28"
  store i8 %".32", i8* %".31"
  br label %"after_loop"
after_loop:
  %".35" = load i64, i64* %".23"
  %".36" = add i64 %".35", 1
  store i64 %".36", i64* %".23"
  %".38" = load i64, i64* %".23"
  %".39" = icmp slt i64 %".38", %".18"
  br i1 %".39", label %"loop", label %"end"
end:
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
  ret %"class.PyObject"* null
}
