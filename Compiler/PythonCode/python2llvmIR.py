# make file : https://code4human.tistory.com/110
# Compiler : https://igotit.tistory.com/entry/GNU-Arm-Embedded-Toolchain-%EB%8B%A4%EC%9A%B4%EB%A1%9C%EB%93%9C-%EC%84%A4%EC%B9%98-%EC%84%A4%EC%A0%95
# Compile Script : aarch64-none-elf-gcc -march=armv8-a -mcpu=cortex-a53 -nostartfiles -T hello.ld hello.cpp -o hello.elf
# Link with library(.a file) aarch64-none-elf-gcc -march=armv8-a -mcpu=cortex-a53 -nostartfiles -T hello.ld -I./include hello.cpp ./lib/libxil.a ./lib/libmetal.a ./lib/libxilpm.a -o hello.elf
# Mini ELF Loader https://w3.cs.jmu.edu/lam2mo/cs261_2019_08/p2-load.html
# How to load ELF file to memory. https://ourembeddeds.github.io/blog/2020/08/16/elf-loader/
# Note that ELF file is composed of header and text section.
# aarch64-none-elf-gcc -march=armv8-a -mcpu=cortex-a53 -nostartfiles -T hello.ld -I./include hello.cpp ./lib/_sbrk.o ./lib/sbrk.o ./lib/read.o ./lib/write.o ./lib/lseek.o ./lib/close.o ./lib/libxil.a  -o hello.elf
# https://llvm.org/docs/tutorial/MyFirstLanguageFrontend/LangImpl03.html
# Clang Compile 
# clang --target=aarch64 -mcpu=cortex-a53 -emit-llvm -S test1.cpp
# llvm datalayout https://llvm.org/docs/LangRef.html#langref-datalayout
# llvm IR reference manual https://releases.llvm.org/10.0.0/docs/LangRef.html#i-getelementptr
# clang --target=aarch64 -mcpu=cortex-a53 -c test1.cpp -o test1.o
# this command makes output file
import ast
import subprocess
import os
from llvmlite import ir, binding

#######################################################################
#LLVM initialization
#######################################################################
binding.initialize()
binding.initialize_all_targets()
binding.initialize_all_asmprinters()

#######################################################################
#Module deifinition
#######################################################################
module = ir.Module(name="module")
module.triple = "aarch64-none-unknown-elf"
module.data_layout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"

#######################################################################
#Global variables
#######################################################################
functions = dict()
classes = dict()
list_types = dict()
strings = dict()

#######################################################################
#Define size_t for aarch64
#######################################################################
size_t = ir.IntType(64)

#######################################################################
#External function definition
#######################################################################
printf_type = ir.FunctionType(ir.VoidType(), [ir.PointerType(ir.IntType(8))], var_arg=True)
printf = ir.Function(module, printf_type, name="xil_printf")
functions['print'] = printf

# void * is set to i8 *
malloc_type = ir.FunctionType(ir.PointerType(ir.IntType(8)), [size_t], var_arg=True)
malloc = ir.Function(module, malloc_type, name="malloc")
functions['malloc'] = malloc

free_type = ir.FunctionType(ir.VoidType(), [ir.PointerType(ir.IntType(8))], var_arg=True)
free = ir.Function(module, free_type, name="free")
functions['free'] = free

#######################################################################
#type table to make type <-> int value mapping
#######################################################################
type_table = dict()
type_table['NO_TYPE'] = 0 # Type is not defined yet

#######################################################################
#Element functions
#######################################################################
DECL_VAR        = 'class.PyObject.__init__'
PYOBJECT        = 'class.PyObject'
MALLOC          = 'malloc'


class LLVMIR_Statement:
    def __init__(self):
        self.classes_id = []
    
    def translate_python2llvmir(self,code):
        tree = ast.parse(python_code)
        
        classes = self.collect_classes(tree)
        self.make_PyObject_class()
        
        # string constant initializer
        for node in ast.walk(tree):
            if isinstance(node, ast.Constant) and type(node.value) == str:
                if node.value in strings:
                    pass
                else:
                    string_value = bytearray(node.value + '\0', encoding='ascii')
                    string_type = ir.Constant(ir.ArrayType(ir.IntType(8), len(node.value) + 1 ),string_value)
                    str_var = ir.GlobalVariable(module, string_type.type, name=f".str{len(strings)}")
                    str_var.global_constant = True
                    str_var.linkage = 'internal'
                    str_var.initializer=string_type
                    strings[node.value] = str_var
        
        for node in ast.walk(tree):
            if isinstance(node, ast.FunctionDef) and node not in (func_node for class_node in classes for func_node in class_node.body):
                print(ast.dump(node, indent=4))
                temp_func_maker = Func_Maker()
                temp_func_maker.translate_function(node)
                
            if isinstance(node, ast.ClassDef):
                print(ast.dump(node, indent=4))
                temp_class_maker = Class_Maker()
                temp_class_maker.translate_class(node)
                
        print('Converted LLVM IR')
        print('#################################################################')
        print('# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #')
        print('#################################################################')
        
        print(str(module))
        #######################################################################
        #Make .ll FIle
        #######################################################################
        self.write_file('./output.ll')
        
    def make_PyObject_class(self):
        """        
#https://stackoverflow.com/questions/14608250/how-can-i-find-the-size-of-a-type
# -> how to get sizeof type
class Element:
    define __init__(self,i8 * value, i64 size, i64 value_type):
        self i8 * value
        self i64 my_ref = 1
        self i64 size = size
        self value = bitcast malloc(size) to i8 *
        self type = value_type
        
        for i in range(size)
            *(self value + i) = *(value + i)
    
    define void set_value(self,i8 * value, i64 size):
        free(self value)
        self value = bitcast malloc(size) to i8 *
        self size = size
        for i in rannge(size):
            *(self value + i) = *(value + i)
    
    define void get_value(self,i8 * target_value):
        for i in rannge(self size):
            *(target_value + i) = *(self value + i)
    
    define decr_ref(self): -> MUST DECREASE REF NUM BEFORE FUNCTION RETURN
        self my_ref = my_ref - 1
        if my_ref == 0:
            free(self value)
    
    define incr_ref(self)
        self my_ref = my_ref + 1
        
Run this code in CPP and check whether it runs well
After compile this code as a llvm ir and make it generated in this code

--> Too slow!    
        """
        # Create a struct to represent the class data
        class_name = 'class.PyObject'
        
        # i8 * value (addr with type i8 *), i64 ref_num, i64 size 
        field_types = [ir.PointerType(ir.IntType(8)), ir.IntType(64), ir.IntType(64), ir.IntType(64)]
                
        class_type = module.context.get_identified_type(class_name)
        class_type.set_body(*field_types)
        classes[class_type.name] = class_type
        
        #######################################################################
        # PyObject __init__
        #######################################################################
        arg_types = [ir.PointerType(class_type), ir.PointerType(ir.IntType(8)), ir.IntType(64), ir.IntType(64)]
                
        ret_type = class_type.as_pointer()
        
        func_type = ir.FunctionType(ret_type, arg_types)
        function = ir.Function(module, func_type, name='class.PyObject.__init__')
        
        function.args[0].name = 'self'
        function.args[1].name = 'value_addr'
        function.args[2].name = 'size'
        function.args[3].name = 'value_type'
            
        block = function.append_basic_block(name="entry")
        builder = ir.IRBuilder(block)
        function = function
        function.variables = dict()
        functions[function.name] = function
        
        for i in range(len(function.args)):
            function.variables[function.args[i].name] = function.args[i]
            
        val_ptr = builder.gep(function.variables['self'],[ir.Constant(ir.IntType(32), 0), ir.Constant(ir.IntType(32), 0)],'val_ptr')
        ref_num = builder.gep(function.variables['self'],[ir.Constant(ir.IntType(32), 0), ir.Constant(ir.IntType(32), 1)],'ref_num')
        size = builder.gep(function.variables['self'],[ir.Constant(ir.IntType(32), 0), ir.Constant(ir.IntType(32), 2)],'size')
        value_type = builder.gep(function.variables['self'],[ir.Constant(ir.IntType(32), 0), ir.Constant(ir.IntType(32), 3)],'size')
        builder.store(function.args[1], val_ptr)
        builder.store(ir.Constant(ir.IntType(64), 1), ref_num)
        builder.store(function.args[2],size)
        builder.store(function.args[3],value_type)
        
        
        builder.ret(function.variables['self'])

        
    def translate_BinOp(self, node):
        left = self.translate_node(node.left)
        right = self.translate_node(node.right)

        if isinstance(node.op, ast.Add):
            return self.builder.add(left, right)
        elif isinstance(node.op, ast.Sub):
            return self.builder.sub(left, right)
        elif isinstance(node.op, ast.Mult):
            return self.builder.mul(left, right)
        else:
            raise NotImplemented(f'{node.op} is not implemented')
        # ... other binary operators

    def translate_Constant(self, node):
        # https://stackoverflow.com/questions/58674264/llvmlite-hello-world-example-produces-wrong-output
        global str_num
        if type(node.value) == int:
            return ir.Constant(ir.IntType(64), node.value)  # Assuming integer constants
        elif type(node.value) == str:
            if node.value in strings:
                str_var = strings[node.value]
            else:
                string_value = bytearray(node.value + '\0', encoding='ascii')
                string_type = ir.Constant(ir.ArrayType(ir.IntType(8), len(node.value) + 1 ),string_value)
                str_var = ir.GlobalVariable(module, string_type.type, name=f".str{len(strings)}")
                str_var.global_constant = True
                str_var.linkage = 'internal'
                str_var.initializer=string_type
                strings[node.value] = str_var
            if str_var.name in self.function.variables:
                ptr_var = self.function.variables[str_var.name]
            else:
                ptr_var = self.builder.alloca(ir.PointerType(ir.IntType(8)))
                self.function.variables[str_var.name] = ptr_var
                
            str_ptr = self.builder.bitcast(str_var, ir.PointerType(ir.IntType(8)))
            print(str_ptr)
            print(ptr_var)

            # Store the string pointer into the pointer variable
            self.builder.store(str_ptr, ptr_var)
            return self.builder.load(ptr_var)

    def translate_Name(self, node):
        if hasattr(node, 'func') and ('class.' + node.func.id) in classes:
            print(ast.dump(node, indent=4))
            class_instance = self.builder.alloca(classes[('class.' + node.func.id)])
            print(class_instance)
            return class_instance
        else:
            var_name = node.id
            for arg in self.function.args:
                if var_name == arg.name:
                    return arg
              
            if self.is_self(node):
                if node.attr in self.declared_self_vars:
                    var_ptr = self.builder.gep(self.function.variables['self'],[ir.Constant(ir.IntType(32), 0), ir.Constant(ir.IntType(32), len(self.declared_self_vars))],'self_'+node.target.attr) ###///
                else:
                    var_ptr = self.builder.alloca(self.translate_Name(node.value).type, name='self_'+node.attr)
                    self.declared_self_vars[var_ptr.name] = var_ptr
                    
            elif var_name in self.function.variables:
                var_ptr = self.function.variables[var_name]
            
            else:
                var_name = node.id
                var_type = ir.IntType(64)  # Assuming 64-bit integers
                var_ptr = self.builder.alloca(var_type, name=var_name)
                self.function.variables[var_name] = var_ptr
                
            return self.builder.load(var_ptr, var_name)
    
    def get_ptr(self,target):
        try:
            return self.function.variables[target.id]
        except:
            raise Exception(f'{target} this variable is not declatred')
        
    def translate_Return(self, node):
        if node.value:
            return_value = self.translate_node(node.value)
            # self.builder.ret(return_value)
            self.builder.ret(ir.Constant(classes[PYOBJECT].as_pointer(), None))
        else:
            self.builder.ret(ir.Constant(classes[PYOBJECT].as_pointer(), 0))
    def translate_Call(self, node):
        ######################################################################
        # Call Function
        ######################################################################
        if hasattr(node,'func'):
            if self.is_self(node.func):
                arg_list = [self.function.variables[node.func.value.id]]
                if hasattr(node, 'args'):
                    for arg in node.args:
                        arg_list.append(self.translate_node(arg))
                        
                return self.builder.call(functions[(self.function.variables[node.func.value.id].type.pointee.name +'.' + node.func.attr)], arg_list)
            else:
                arg_list = []
                if hasattr(node, 'args'):
                    for arg in node.args:
                        arg_list.append(self.translate_node(arg))
                return self.builder.call(functions[node.func.id], arg_list)
        else:
            raise TypeError('Not a function')
    def translate_Assign(self, node):
        if len(node.targets) != 1:
            raise NotImplementedError("Assignment to multiple targets is not supported")
    
        target = node.targets[0]
        ###
        # target var 
        ###
        if isinstance(node.value, ast.List):
            print('helo')
        if self.is_self(target):
            if ('self_' + target.attr) in self.declared_self_vars:
                var_ptr = self.declared_self_vars['self_'+target.attr] ###///
                value = self.translate_node(node.value)
                self.builder.store(value, var_ptr)
            else:
                var_ptr = self.builder.gep(self.function.variables['self'],[ir.Constant(ir.IntType(32), 0), ir.Constant(ir.IntType(32), len(self.declared_self_vars))],'self_'+target.attr)
                self.declared_self_vars['self_'+target.attr] = var_ptr
                value = self.translate_node(node.value)
                self.builder.store(value, var_ptr)
                
        elif target.id not in self.function.variables:
            if hasattr(node,'value') and hasattr(node.value, 'func') and ('class.' + node.value.func.id) in classes:
                var_ptr = self.builder.alloca(classes[('class.' + node.value.func.id)], name=target.id)
                arg_list = [var_ptr]
                if hasattr(node.value, 'args'):
                    for arg in node.value.args:
                        arg_list.append(self.translate_node(arg))
                self.builder.call(functions['class.' + node.value.func.id + '.' + '__init__'], arg_list)
                self.function.variables[var_ptr.name] = var_ptr
            
            else:            
                ######################################################################
                # PyObject Done
                ######################################################################
                # Allocate space for the variable on the stack
                var_ptr = self.make_element_var(target.id, node.value)
                
            return var_ptr
            
        else:
            print(ast.dump(node, indent=4))
            var_ptr = self.function.variables[target.id]
            value = self.translate_node(node.value)
            self.builder.store(value, var_ptr)
            
    def translate_AnnAssign(self, node):
        # Assuming all types are integer for simplicity
        if not isinstance(node.annotation, ast.Name) or node.annotation.id != 'int':
            raise NotImplementedError("Only integer types are supported")
            
        if self.is_self(node.target):
            if ('self_'+ node.target.attr) in self.declared_self_vars:
                var_ptr = self.declared_self_vars['self_'+node.target.attr] ###///
            else:
                var_ptr = self.builder.gep(self.function.variables['self'],\
                                           [ir.Constant(ir.IntType(32), 0), \
                                            ir.Constant(ir.IntType(32), \
                                            len(self.declared_self_vars))],\
                                           'self_'+node.target.attr)
                self.declared_self_vars['self_'+node.target.attr] = var_ptr
        else: 
            ######################################################################
            # PyObject Done
            ######################################################################
            # Allocate space for the variable on the stack
            var_ptr = self.make_element_var(node.target.id, node.value)
        
        return var_ptr
    
    def make_element_var(self, var_name, node_value):
        if node_value is not None:
            value = self.translate_node(node_value)
            var_type = value.type  # Assuming 64-bit integers SHOULD BE CHANGED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!S
            var_ptr = self.builder.alloca(var_type)
            self.builder.store(value, var_ptr)
            
        else:
            var_type = ir.IntType(64)
            var_ptr = self.builder.alloca(var_type)
            value = ir.Constant(ir.IntType(64), 0)
        
        if var_type in type_table:
            pass
        else:
            type_table[var_type] = len(type_table)
            
        self.builder.store(value,var_ptr)
        var_size = self.get_size_of_type(var_type)
        malloc_size = self.get_size_of_type(classes[PYOBJECT])
        element_ptr = self.builder.bitcast(self.builder.call(functions[MALLOC], [malloc_size]), classes[PYOBJECT].as_pointer())
        i8_ptr = self.builder.bitcast(var_ptr, ir.IntType(8).as_pointer())
        
        arg_list = [element_ptr, i8_ptr, ir.Constant(ir.IntType(64), \
                     type_table[var_type]), var_size]
        
        element_var = self.builder.call(functions[DECL_VAR], arg_list)
        element_var.name = var_name

        # Save the variable in the function's symbol table (if you have one)
        # self is necessary to refer to it later in the function
        self.function.variables[var_name] = element_var
        
        return var_ptr
        
    def translate_For(self,node):
        # Basic blocks for loop start, body, and end
        loop_start_block = self.builder.append_basic_block('loop_start')
        loop_body_block = self.builder.append_basic_block('loop_body')
        loop_end_block = self.builder.append_basic_block('loop_end')
        
        # Assuming the loop is like 'for i in range(start, end)'
        # Start value, end value, and step are extracted from the node
        
        # Initialize the loop variable 'i'
        index = self.translate_node(node.target)
        index_ptr = self.get_ptr(node.target)
        
        ####################################################################### 
        # Case using range
        #######################################################################
        if hasattr(node.iter,'func') and node.iter.func.id == 'range':
            start_val = 0  # Get start value from node
            end_val = node.iter.args[0].value    # Get end value from node
            step_val = 1   # Get step value from node (default to 1 if not specified)
        
        
        # Jump to loop start
        self.builder.branch(loop_start_block)
        
        # Loop start block
        self.builder.position_at_end(loop_start_block)
        
        cmp = self.builder.icmp_signed('<', index, ir.Constant(ir.IntType(64), end_val))
        self.builder.cbranch(cmp, loop_body_block, loop_end_block)
        
        # Loop body block
        self.builder.position_at_end(loop_body_block)
        # Translate the loop body (assuming it's another AST node)
        for stmt in node.body:
            self.translate_node(stmt)
        # Increment the loop variable
        index_next = self.builder.add(index, ir.Constant(ir.IntType(64), step_val))
        self.builder.store(index_next, index_ptr)
        # Jump back to loop start
        self.builder.branch(loop_start_block)
        
        # Loop end block
        self.builder.position_at_end(loop_end_block)
    
    def translate_Attribute(self, node):
        if hasattr(node,'value'):
            if ('self_'+ node.attr) in self.declared_self_vars:
                var_ptr = self.declared_self_vars['self_'+node.attr] ###///
            else:
                var_ptr = self.builder.gep(self.function.variables['self'],[ir.Constant(ir.IntType(32), 0), ir.Constant(ir.IntType(32), len(self.declared_self_vars))],'self_'+node.target.attr)
                self.declared_self_vars['self_'+node.attr] = var_ptr
        
        print(ast.dump(node, indent=4))
        return self.builder.load(var_ptr)
    
    def translate_If(self, node):
        condition = self.translate_node(node.test)

        # Create basic blocks for the 'then' and 'else' parts and for continuation
        then_block = self.builder.append_basic_block('then')
        else_block = self.builder.append_basic_block('else') if node.orelse else None
        continue_block = self.builder.append_basic_block('ifcont')

        # Conditional branch based on the condition
        self.builder.cbranch(condition, then_block, else_block or continue_block)

        # 'then' part
        self.builder.position_at_end(then_block)
        for stmt in node.body:
            self.translate_node(stmt)
        self.builder.branch(continue_block)

        # 'else' part (if there is one)
        if node.orelse != None:
            for stmt in node.orelse:
                self.builder.position_at_end(else_block)
                print(ast.dump(stmt, indent=4))
                self.translate_node(stmt)
                self.builder.branch(continue_block)

        # Continue with the rest of the code
        self.builder.position_at_end(continue_block)
        
    def translate_Compare(self, node):
        if len(node.ops) != 1 or len(node.comparators) != 1:
            raise NotImplementedError("Complex comparison not implemented")

        left = self.translate_node(node.left)
        right = self.translate_node(node.comparators[0])

        op = node.ops[0]
        if isinstance(op, ast.Eq):
            return self.builder.icmp_signed('==', left, right)
        elif isinstance(op, ast.NotEq):
            return self.builder.icmp_signed('!=', left, right)
        elif isinstance(op, ast.Lt):
            return self.builder.icmp_signed('<', left, right)
        elif isinstance(op, ast.LtE):
            return self.builder.icmp_signed('<=', left, right)
        elif isinstance(op, ast.Gt):
            return self.builder.icmp_signed('>', left, right)
        elif isinstance(op, ast.GtE):
            return self.builder.icmp_signed('>=', left, right)
        else:
            raise NotImplementedError("Unsupported comparison operation")
            
    def translate_BoolOp(self, node):
        if isinstance(node.op, ast.And):
            values = [self.translate_node(v) for v in node.values]
            result = values[0]
            for val in values[1:]:
                result = self.builder.and_(result, val)
            return result
        elif isinstance(node.op, ast.Or):
            values = [self.translate_node(v) for v in node.values]
            result = values[0]
            for val in values[1:]:
                result = self.builder.or_(result, val)
            return result
        else:
            raise NotImplementedError("Only 'And' BoolOps are implemented")
            
    def translate_List(self,node):
        ir.ArrayType(element_type, len(array_values))
    
    def translate_Expr(self,node):
        print(ast.dump(node, indent=4))
        return self.translate_node(node.value)
        
    def translate_node(self, node):
        if isinstance(node, ast.BinOp):
            return self.translate_BinOp(node)
        elif isinstance(node, ast.Constant):
            return self.translate_Constant(node)
        elif isinstance(node, ast.Name):
            return self.translate_Name(node)
        elif isinstance(node, ast.Assign):
            return self.translate_Assign(node)
        elif isinstance(node, ast.Return):
            return self.translate_Return(node)
        elif isinstance(node, ast.Call):
            return self.translate_Call(node)
        elif isinstance(node,ast.AnnAssign):
            return self.translate_AnnAssign(node)
        elif isinstance(node,ast.For):
            return self.translate_For(node)
        elif isinstance(node,ast.Attribute):
            return self.translate_Attribute(node)
        elif isinstance(node,ast.If):
            return self.translate_If(node)
        elif isinstance(node, ast.Compare):
            return self.translate_Compare(node)
        elif isinstance(node,ast.BoolOp):
            return self.translate_BoolOp(node)
        elif isinstance(node,ast.List):
            return self.translate_List(node)
        elif isinstance(node, ast.Expr):
            return self.translate_Expr(node)
        # Add more node types here as needed
        else:
            print()
            raise NotImplementedError(f"Node type \n{ast.dump(node, indent=4)}\n not implemented")
    
    def collect_classes(self, node):
        classes = []
        for item in ast.walk(node):
            if isinstance(item, ast.ClassDef):
                classes.append(item)
        return classes
    
    def get_ir_type(self, node):
        if hasattr(node,'annotation') and node.annotation != None and node.annotation.id == 'int':
            return ir.IntType(64)
        elif hasattr(node, 'id') and node.id != None and type(node.id) == 'int':
            return ir.IntType(64)
        
    def is_self(self,node):
        if isinstance(node,ast.Attribute):
            return True
        else:
            return False
        
    def get_size_of_type(self, var_type):
        """
        Calculate the size of the given LLVM type using getelementptr
        """
        ptr_type = var_type.as_pointer()
        null_ptr = ir.Constant(ptr_type, None)
        size_ptr = self.builder.gep(null_ptr, [ir.Constant(size_t, 1)], inbounds=True)
        size_int = self.builder.ptrtoint(size_ptr, size_t)
        
        return size_int
        
    def find_key_by_value(self, my_dict, search_value):
        for key, value in my_dict.items():
            print(search_value)
            if value == search_value:
                return key
        return None 
    
    def write_file(self, filename):
        with open(filename, "w") as f:
            f.write(str(module))
            
class Class_Maker(LLVMIR_Statement):
    def __init__(self):
        self.declared_method = dict()
        self.declared_self_vars = dict()
        self.function = None
        self.class_type = None
        self.class_instance_ptr = None
        self.fields = set()
        self.field_types =[]
        self.undefined_function = dict()
        
    def translate_class(self,node):
        if isinstance(node,ast.ClassDef):
            # Create a struct to represent the class data
            class_name = 'class.' + node.name
            self.class_name = class_name
            
            field_types = []
            for stmt in node.body:
                if isinstance(stmt, ast.FunctionDef) and stmt.name == '__init__':    
                    for arg in stmt.body:
                        if isinstance(arg, ast.AnnAssign):
                            if hasattr(arg,"value") and arg.value != None:
                                self.translate_node(arg.value)
                    
                for arg in ast.walk(stmt):
                    if hasattr(arg,'target') and hasattr(arg.target,'value') and hasattr(arg.target.value,'id') and arg.target.value.id == 'self':
                        if not arg.target.attr in self.fields:
                            if hasattr(arg,'annotation'):
                                self.fields.add(arg.target.attr)
                                self.field_types.append(self.get_ir_type(arg))
                                    
                    
            self.class_type = module.context.get_identified_type(self.class_name)
            self.class_type.set_body(*self.field_types)
            classes[self.class_type.name] = self.class_type
            
            # class_struct.initializer = ir.Constant(class_struct, field_types)
            for stmt in node.body:
                if isinstance(stmt, ast.FunctionDef):
                    self.translate_method(stmt, self.class_type, node.name)
                                              
    def translate_method(self,node, class_type, node_name):
        if isinstance(node, ast.FunctionDef):            
            arg_types = []
            for arg in node.args.args:
                if arg.arg != 'self':
                    print(arg.arg)
                    arg_types.append(self.get_ir_type(arg))
            
            ret_type = classes[PYOBJECT].as_pointer()
            method_type = ir.FunctionType(ir.IntType(64), [ ir.PointerType(self.class_type) ] + arg_types)
            method = ir.Function(module, method_type, name=f"class.{node_name}.{node.name}")
            
            method.args[0].name = method.name
            
            for i in range(len(method.args)):
                if i < len(node.args.args):
                    method.args[i].name = node.args.args[i].arg
                    
            # self = create_default_func.args[0]
            # self.name = "self"
            # element_ptr = builder.gep(self, [ir.Constant(ir.IntType(32), 0), ir.Constant(ir.IntType(32), 0)], name="1")
            
            # # Store 0 in the first element of Foo
            # builder.store(ir.Constant(ir.IntType(32), 0), element_ptr)

            block = method.append_basic_block(name="entry")
            self.builder = ir.IRBuilder(block)
            self.function = method
            self.function.variables = dict()
            
            for i in range(len(self.function.args)):
                self.function.variables[self.function.args[i].name] = self.function.args[i]
                
            print(self.function.name)
            functions[self.function.name] = self.function
            
            # self.function.variables[] 
            # Generate IR for function body
            for stmt in node.body:
                self.translate_node(stmt)

            # Simplified: assuming function ends with return

class Func_Maker(LLVMIR_Statement):
    def __init__(self):
        self.declared_class = {}
        self.declared_method = []
        self.function = None
        self.undefined_function = dict()
        self.builder = None
        
    def translate_function(self, node):
        if isinstance(node, ast.FunctionDef):
            # Simplified: assuming function returns int and takes int arguments
            
            arg_types = []
            for arg in node.args.args:
                arg_types.append(self.get_ir_type(arg))
                    
            ret_type = classes[PYOBJECT].as_pointer()
            func_type = ir.FunctionType(ret_type, arg_types)
            function = ir.Function(module, func_type, name=node.name)
            
            for i in range(len(function.args)):
                function.args[i].name = node.args.args[i].arg
                
            block = function.append_basic_block(name="entry")
            self.builder = ir.IRBuilder(block)
            self.function = function
            self.function.variables = dict()
            functions[function.name] = self.function
            
            for i in range(len(self.function.args)):
                self.function.variables[self.function.args[i].name] = self.function.args[i]
            # Generate IR for function body
            for stmt in node.body:
                self.translate_node(stmt)

            # Simplified: assuming function ends with return   
        

class List_Maker(LLVMIR_Statement):
    """
    only first List pointer is in symbol table
List 0      1       2       3       4 ... 2 ** n
     |      |
     V      V
     NULL   List    0       1       2 ...

class List:
    define __init__(self, size = 16)
        self List * addr   // if self addr == NULL -> It does not have
                            // child list
        self Eelement value
        self i64 size = size
        self i64 max = 16
        
    define append(self, Element element)
        if self size + 1 > self max
            temp_addr = malloc(sizeof(List) * 2 * self size)
            for i = 0 ; i < self size; i++
                *( temp_addr + i ) = *( self addr + i ) 
            free(self addr)
    
For AST 
    if isinstance(node,ast.BinOp) and (isinstance(node.left,ast.List) or isinstance(node.right,ast.List) ):
        for i in len(right):
             store(load(right List Type + i * sizeof(List Type)),(left List type + i))
    if isinstance(node,ast.Subscrpit):
        load()
 
    """
    def __init__(self, ir_builder, element_type = None):
        self.element_type = element_type
        self.undefined = False
        self.builder = ir_builder
        
            
    def make_list(self, array_size = 16):
        if self.element_type == None:
            self.undefined = True
            return ir.ArrayType(ir.IntType(64), 16)
        else:
            return ir.ArrayType(self.element_type, array_size)
        
    def set_type(self,ir_type):
        self.element_type = ir_type
        self.undefined = False
        if not self.element_type in list_types:
            d
    def make_append_function(self):
        asd
    def make_init_function(self):
        asd
        
if __name__ == "__main__":
    python_code1 = """
class dds:
    def __init__(self, a:int = 3):
        self.a:int 
    def out(self, q:int, c:int = 10) ->char:
        self.a = 30 + 50
        b:int = 30
        print(self.a)
        if b < 0:
            print("oh")
        elif self.a > 0 and b < 10 and 3 == 4:
            print("hello")
            return 1 - 90
            
        else:
            print("END")
            return 3
        return a
    def goo(self, c:int) -> int:
        print("hello")
            
def foo( a:int = 10):
    new_dds = dds(30+40,50)
    new_dds.out(30,40)
    num_list:int = list()
    new_list:int = [1,2,3]
    x:int = new_dds.out(20,30,60) + 20
    x = (30 + 50)
    
    new_list = [5,9,10]
    
    new_list[1+10] =3
    
    i:int;
    k:int =10
    
    for i in range(6):
        print(i)
        k = i
    
    if x == 80:
        print(x)
    elif x == 40:
        print( x + 60)
        
    print(a)
"""
    python_code = """
# class goo:
#     def __init__(self, d:int, e:int, f:int)->int:
#         self.q:int
#         self.d:int
#         self.e:int
#         self.e = e
#         return
    
#     def mu(self):
#         self.m:int
#         self.m = 30 + (50+90)
#         return self.m
        

@kernel        
# def foo(a : int, b:int , f:int) -> int:
#     c:int
#     # num_list = [1,2,3,4]
#     # num_list[2]
#     # c = 30
#     # c = b + 1
#     # d = c
#     # for i in range(8):
#     #     c = i * 8
#     goo_in = goo(1,2,3)
#     # c = foo(1,2,3)
#     c = goo_in.mu() + 50
#     return a + c

def main() -> int:
    c = 3
    d = 30
    # print('hello')
    # if c == 30 or c > 20:
    #     c = 40
    # else:
    #     c = 60
    return 0
"""
    
    ir_maker = LLVMIR_Statement()
    ir_maker.translate_python2llvmir(python_code1)