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
        self.builder = None
        self.function = None

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
    
        # Load the variable's value
        return self.builder.load(var_ptr, var_name)
    
    def translate_Assign(self, node):
        if len(node.targets) != 1:
            raise NotImplementedError("Assignment to multiple targets is not supported")
    
        # Get the target of the assignment (assuming a single target for simplicity)
        target = node.targets[0]
    
        if not isinstance(target, ast.Name):
            raise NotImplementedError("Only assignment to simple variables is supported")
    
        # Compute the value to be assigned
        value = self.translate_node(node.value)
    
        # Check if the variable has been previously declared
        if target.id not in self.function.variables:
            # Allocate space for the variable (assuming it's an integer)
            var_ptr = self.builder.alloca(ir.IntType(64), name=target.id)
            self.function.variables[target.id] = var_ptr
        else:
            # Retrieve the pointer to the previously declared variable
            var_ptr = self.function.variables[target.id]
    
        # Store the computed value in the variable
        self.builder.store(value, var_ptr)
        
    def translate_Return(self, node):
        # If the return statement has a value to return
        if node.value:
            # Translate the return value expression to LLVM IR
            return_value = self.translate_node(node.value)
            # Generate the LLVM IR return instruction with the value
            self.builder.ret(return_value)
        else:
            # If there's no value to return (equivalent to 'return None' in Python)
            # Assuming the function is of void type in this case
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

    def generate_function(self, node):
        if isinstance(node, ast.FunctionDef):
            print(ast.dump(node, indent=4))
            # Simplified: assuming function returns int and takes int arguments
            
            arg_types = []
            args = []
            i = 0
            for arg in node.args.args:
                if arg.annotation.id == 'int':
                    arg_types.append(ir.IntType(64))
                    
                else:
                    arg_types.append(ir.IntType(64))
                    
            ret_type = ir.IntType(64)
            func_type = ir.FunctionType(ret_type, arg_types)
            function = ir.Function(self.module, func_type, name=node.name)
            
            for i in range(len(function.args)):
                function.args[i].name = node.args.args[i].arg
                
            block = function.append_basic_block(name="entry")
            self.builder = ir.IRBuilder(block)
            self.function = function
            self.function.variables = dict()
            # Generate IR for function body
            for stmt in node.body:
                self.translate_node(stmt)

            # Simplified: assuming function ends with return

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
def foo(a : int, b:int ) -> int:
    b:int
    b = 30
    b = b + 1
    return a + b
"""
    llvm_code = ''
    tree = ast.parse(python_code)
    ir_maker = LLVMIR_Statement()

    for node in ast.walk(tree):
        if isinstance(node, ast.FunctionDef):
            ir_maker.generate_function(node)
    print('Converted LLVM IR')
    print('##################################################################')
    print('# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # ')
    print('##################################################################')

    print(str(ir_maker.module))

