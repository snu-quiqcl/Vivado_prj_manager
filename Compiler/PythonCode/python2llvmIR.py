# make file : https://code4human.tistory.com/110
# Compiler : https://igotit.tistory.com/entry/GNU-Arm-Embedded-Toolchain-%EB%8B%A4%EC%9A%B4%EB%A1%9C%EB%93%9C-%EC%84%A4%EC%B9%98-%EC%84%A4%EC%A0%95
# Compile Script : aarch64-none-elf-gcc -march=armv8-a -mcpu=cortex-a53 -nostartfiles -T hello.ld hello.cpp -o hello.elf
# Link with library(.a file) aarch64-none-elf-gcc -march=armv8-a -mcpu=cortex-a53 -nostartfiles -T hello.ld -I./include hello.cpp ./lib/libxil.a ./lib/libmetal.a ./lib/libxilpm.a -o hello.elf
# Mini ELF Loader https://w3.cs.jmu.edu/lam2mo/cs261_2019_08/p2-load.html
# How to load ELF file to memory. https://ourembeddeds.github.io/blog/2020/08/16/elf-loader/
# Note that ELF file is composed of header and text section.
# aarch64-none-elf-gcc -march=armv8-a -mcpu=cortex-a53 -nostartfiles -T hello.ld -I./include hello.cpp ./lib/_sbrk.o ./lib/sbrk.o ./lib/read.o ./lib/write.o ./lib/lseek.o ./lib/close.o ./lib/libxil.a  -o hello.elf
import ast
import subprocess
from llvmlite import ir 

class LLVMIR_Statement:
    def __init__(self):
        module = ir.Module(name="module")
        module.triple = "aarch64-none-elf"
        self.module = module
        self.functions = []
        self.classes = []
        self.classes_id = []
    
    def translate_python2llvmir(self,code):
        tree = ast.parse(python_code)
        
        self.classes = self.collect_classes(tree)
        for classes_ in self.classes:
            self.classes_id.append(classes_.name)
        
        for node in ast.walk(tree):
            if isinstance(node, ast.FunctionDef) and node not in (func_node for class_node in self.classes for func_node in class_node.body):
                print(ast.dump(node, indent=4))
                temp_func_maker = Func_Maker(self.module)
                self.module = temp_func_maker.translate_function(node)
                
            if isinstance(node, ast.ClassDef):
                print(ast.dump(node, indent=4))
                temp_class_maker = Class_Maker(self.module)
                self.module = temp_class_maker.translate_class(node)
                
        print('Converted LLVM IR')
        print('##################################################################')
        print('# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # ')
        print('##################################################################')
        
        print(str(self.module))
        
    def translate_BinOp(self, node):
        left = self.translate_node(node.left)
        right = self.translate_node(node.right)

        if isinstance(node.op, ast.Add):
            return self.builder.add(left, right)
        elif isinstance(node.op, ast.Sub):
            return self.builder.sub(left, right)
        # ... other binary operators

    def translate_Constant(self, node):
        return ir.Constant(ir.IntType(64), node.value)  # Assuming integer constants

    def translate_Name(self, node):
        var_name = node.id
        for arg in self.function.args:
            if var_name == arg.name:
                return arg
            
        if var_name in self.function.variables:
            var_ptr = self.function.variables[var_name]
        else:
            raise KeyError(f"Variable '{var_name}' not found in function arguments or local variables")
    
        return self.builder.load(var_ptr, var_name)
    
    def translate_Assign(self, node):
        print(ast.dump(node, indent=4))
        if len(node.targets) != 1:
            raise NotImplementedError("Assignment to multiple targets is not supported")
    
        target = node.targets[0]
        if hasattr(target,"value") and target.value != None:
            value = self.translate_node(node.value)
            
        value = self.translate_node(node.value)
    
        if self.is_self_var(target):
            if target.attr in self.declared_this_vars:
                var_ptr = self.function.variables[target.attr]
            else:
                var_ptr = self.builder.alloca(self.translate_Name(node.value).type, name='this_'+target.attr)
                self.declared_this_vars['this_'+target.attr] = var_ptr
        
        elif target.id not in self.function.variables:
            var_ptr = self.builder.alloca(self.translate_Name(node.value).type, name=target.id)
            self.function.variables[target.id] = var_ptr
        else:
            var_ptr = self.function.variables[target.id]
        
        self.builder.store(value, var_ptr)
        
    def translate_Return(self, node):
        if node.value:
            return_value = self.translate_node(node.value)
            self.builder.ret(return_value)
        else:
            self.builder.ret_void()
    def translate_Call(self, node):
        ######################################################################
        # Fill the Code!
        ######################################################################
        print('hello')
    
    def translate_AnnAssign(self, node):
        # Assuming all types are integer for simplicity
        if not isinstance(node.annotation, ast.Name) or node.annotation.id != 'int':
            raise NotImplementedError("Only integer types are supported")
    
        # Allocate space for the variable on the stack
        var_name = node.target.id
        var_type = ir.IntType(64)  # Assuming 64-bit integers
        var_ptr = self.builder.alloca(var_type, name=var_name)
    
        # Store the initial value if it exists
        if node.value is not None:
            value = self.translate_node(node.value)
            self.builder.store(value, var_ptr)
    
        # Save the variable in the function's symbol table (if you have one)
        # This is necessary to refer to it later in the function
        self.function.variables[var_name] = var_ptr
    
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
        # Add more node types here as needed
        else:
            raise NotImplementedError(f"Node type {type(node)} not implemented")
    
    def collect_classes(self, node):
        classes = []
        for item in ast.walk(node):
            if isinstance(item, ast.ClassDef):
                classes.append(item)
        return classes
    
    def get_ir_type(self, node):
        if hasattr(node,'annotation') and node.annotation != None and node.annotation.id == 'int':
            return ir.IntType(64)
        elif hasattr(node, 'id') and node.id != None and node.id == 'int':
            return ir.IntType(64)
        
    def is_self_var(self,node):
        if hasattr(node, 'value') and hasattr(node.value, 'id') and node.value.id != None and node.value.id == 'self':
            return True
        else:
            return False

class Class_Maker(LLVMIR_Statement):
    def __init__(self,module):
        self.declared_class = dict()
        self.declared_method = dict()
        self.declared_this_vars = dict()
        self.function = None
        self.module = module
        
    def translate_class(self,node):
        if isinstance(node,ast.ClassDef):
            # Create a struct to represent the class data
            class_name = node.name
            self.class_name = class_name
            
            field_types = []
            for stmt in node.body:
                if isinstance(stmt, ast.FunctionDef) and stmt.name == '__init__':    
                    for arg in stmt.body:
                        if isinstance(arg, ast.AnnAssign):
                            self.declared_vars.add(arg.target.attr)
                            if hasattr(arg,"value") and arg.value != None:
                                var_name = arg.target.attr
                                var_value = self.translate_node(arg.value)
                                
                    param_num = -len(stmt.args.defaults)
                    param_index = 0
                    
                    for arg in stmt.args.args:
                        field_types.append(self.get_ir_type(arg))

            class_struct_type = ir.LiteralStructType(field_types)
            class_struct = ir.GlobalVariable(self.module, 
                                             class_struct_type, 
                                             name=node.name)
            
            self.declared_class = class_struct

            # class_struct.initializer = ir.Constant(class_struct, field_types)
            for stmt in node.body:
                if isinstance(stmt, ast.FunctionDef):
                    self.translate_method(stmt, class_struct, node.name)
                                
            return self.module
                    
    def translate_method(self,node, class_struct, node_name):
        if isinstance(node, ast.FunctionDef):            
            arg_types = []
            for arg in node.args.args:
                if hasattr(arg,'annotation') and arg.annotation != None and arg.annotation.id == 'int':
                    arg_types.append(ir.IntType(64))
                    
                else:
                    arg_types.append(ir.IntType(64))
            
            method_type = ir.FunctionType(ir.IntType(64), [ir.PointerType(class_struct)] + arg_types)
            method = ir.Function(self.module, method_type, name=f"{node_name}_{node.name}")
            
            method.args[0].name = method.name
            
            for i in range(len(method.args)):
                if i < len(node.args.args):
                    method.args[i+1].name = node.args.args[i].arg
                    
            block = method.append_basic_block(name="entry")
            self.builder = ir.IRBuilder(block)
            self.function = method
            self.function.variables = dict()
            
            for i in range(len(self.function.args)):
                self.function.variables[self.function.args[i].name] = self.function.args[i]
            
            # self.function.variables[] 
            # Generate IR for function body
            for stmt in node.body:
                self.translate_node(stmt)

            # Simplified: assuming function ends with return

class Func_Maker(LLVMIR_Statement):
    def __init__(self,module):
        self.declared_class = {}
        self.declared_method = []
        self.function = None
        self.module = module
        
    def translate_function(self, node):
        if isinstance(node, ast.FunctionDef):
            # Simplified: assuming function returns int and takes int arguments
            
            arg_types = []
            for arg in node.args.args:
                arg_types.append(self.get_ir_type(arg))
                    
            if hasattr(node,"returns") and hasattr(node.returns,"id") and node.returns != None:
                ret_type = self.get_ir_type(node.returns)
            else:
                ret_type = ir.IntType(64)
            func_type = ir.FunctionType(ret_type, arg_types)
            function = ir.Function(self.module, func_type, name=node.name)
            
            for i in range(len(function.args)):
                function.args[i].name = node.args.args[i].arg
                
            block = function.append_basic_block(name="entry")
            self.builder = ir.IRBuilder(block)
            self.function = function
            self.function.variables = dict()
            
            for i in range(len(self.function.args)):
                self.function.variables[self.function.args[i].name] = self.function.args[i]
            # Generate IR for function body
            for stmt in node.body:
                self.translate_node(stmt)

            # Simplified: assuming function ends with return   
            
            return self.module

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
class goo:
    def __init__(self, d:int, e:int, f:int):
        self.d = d
        
def foo(a : int, b:int , f:int) -> int:
    c:int
    c = 30
    c = b + 1
    d = c
    return a + c
"""
    
    ir_maker = LLVMIR_Statement()
    ir_maker.translate_python2llvmir(python_code1)

