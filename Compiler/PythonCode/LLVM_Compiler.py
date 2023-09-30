import ast
import subprocess
from llvmlite import ir, binding

# Initialize LLVM
binding.initialize()
binding.initialize_all_targets()
binding.initialize_all_asmprinters()

class LLVMCodeGenerator(ast.NodeVisitor):
    def __init__(self):
        self.module = ir.Module(name="my_module")
        self.module.triple = 'aarch64-none-elf'
        self.builder = None

    def emit_function(self, node):
        func_type = ir.FunctionType(ir.IntType(64), [])
        func = ir.Function(self.module, func_type, name=node.name)
        block = func.append_basic_block(name="entry")
        self.builder = ir.IRBuilder(block)
        self.generic_visit(node)
        return func

    def visit_FunctionDef(self, node):
        self.emit_function(node)

    def visit_Assign(self, node):
        if isinstance(node.targets[0], ast.Name) and isinstance(node.value, ast.Num):
            var_name = node.targets[0].id
            setattr(self, var_name, ir.Constant(ir.IntType(64), node.value.n))

    def visit_Return(self, node):
        if isinstance(node.value, ast.BinOp):
            left = getattr(self, node.value.left.id)
            right = getattr(self, node.value.right.id)
            if isinstance(node.value.op, ast.Add):
                result = self.builder.add(left, right)
            elif isinstance(node.value.op, ast.Sub):
                result = self.builder.sub(left, right)
            elif isinstance(node.value.op, ast.Mult):
                result = self.builder.mul(left, right)
            # ... handle other operations as needed
            else:
                raise ValueError("Unsupported operation")
            self.builder.ret(result)

def compile_to_llvm_ir(python_code):
    tree = ast.parse(python_code)
    codegen = LLVMCodeGenerator()
    codegen.visit(tree)
    return str(codegen.module)

if __name__ == "__main__":
    python_code = """
def goo():
    c = 90
    d = 30
    return c * d
"""
    
    llvm_ir = compile_to_llvm_ir(python_code)
    print(llvm_ir)


classes = []
classes_id = []

indent = 0

def make_indent():
    c_code = ""
    global indent
    for i in range(indent):
        c_code += "    "
    return c_code

def inc_indent():
    global indent
    indent += 1

def dec_indent():
    global indent
    indent -= 1

def collect_classes(node):
        classes = []
        for item in ast.walk(node):
            if isinstance(item, ast.ClassDef):
                classes.append(item)
        return classes
        
class Basic_Statement:
    def __init__(self):
        print('basic')
        
    def normal_statement(self,node):
        # print(ast.dump(node, indent=4))
        
        c_code = ""
        if isinstance(node, ast.BinOp):
            left_code = self.normal_statement(node.left)
            right_code = self.normal_statement(node.right)
            op_code = self.operator_to_c(node.op)
            return f"({left_code} {op_code} {right_code})"
        elif isinstance(node, ast.Constant):
            return str(node.value)
        
        elif isinstance(node, ast.Expr):
            return f"{self.normal_statement(node.value)};"
        
        elif isinstance(node, ast.Subscript):
            return f"{self.normal_statement(node.value)}[{self.normal_statement(node.slice)}]"
        
        elif isinstance(node, ast.Call):
            if hasattr(node.func, 'value'):
                if node.func.value.id in self.declared_class:
                    c_code = ""
                    c_code += f"{self.declared_class[node.func.value.id]}_{node.func.attr}(&{node.func.value.id},"
                    param_num = len(node.args)
                    param_index = 0
                    for stmt in node.args:
                        c_code += self.normal_statement(stmt)
                        param_index += 1
                        if not param_index == param_num:
                            c_code += ', '
                    c_code += ')'
                    return c_code
            else:
                c_code = ""
                c_code += f"{node.func.id}("
                param_num = len(node.args)
                param_index = 0
                for stmt in node.args:
                    c_code += self.normal_statement(stmt)
                    param_index += 1
                    if not param_index == param_num:
                        c_code += ', '
                c_code += ')'
                return c_code
        elif isinstance(node, ast.Name):
            return node.id
        
        elif isinstance(node, ast.Compare):
            return f'( {self.normal_statement(node.left)} {self.operator_to_c(node.ops[0])} {self.normal_statement(node.comparators[0])} )'
    
        elif isinstance(node,ast.Attribute):
            if node.value.id == 'self':
                return f"this->{node.attr}"
            
            else:
                print("unpared token")
                return ast.unparse(node)
        
        elif isinstance(node, ast.BoolOp):
            stmt_num = len(node.values)
            stmt_index = 0
            c_code = ""
            
            for stmt in node.values:
                c_code += self.normal_statement(stmt)
                stmt_index += 1
                if stmt_index != stmt_num:
                    c_code += self.operator_to_c(node.op)
                
            return c_code
        
        else: #String process problem
            print("unpared token")
            return ast.unparse(node)
            
    def operator_to_c(self, op_node):
        operators_map = {
            ast.Add: "+",
            ast.Sub: "-",
            ast.Mult: "*",
            ast.Div: "/",
            ast.Gt: ">",
            ast.Lt:"<",
            ast.And:"&&",
            ast.Or:"||",
            ast.Eq:"=="
        }
        return operators_map[type(op_node)]
    

    def handle_if_block(self, node):
        # print(ast.dump(node, indent=4))
        condition = self.normal_statement(node.test)
        c_code = make_indent()+ f"if ({condition}) {{\n"
    
        inc_indent()
        c_code += self.func_general_statement(node)
        dec_indent()
        c_code += make_indent()+"}\n"
        
        for stmt in node.orelse:
            c_code += self.handle_elif_blocks(stmt)
    
        return c_code
    
    def handle_elif_blocks(self, node):
        c_code = ""
        # print(ast.dump(node, indent=4))
        #ELIF case
        if isinstance(node, ast.If):
            condition = self.normal_statement(node.test)
            c_code += make_indent()+f"else if ({condition}) {{\n"
    
            inc_indent()
            c_code += self.func_general_statement(node)
            dec_indent()
            c_code += make_indent()+"}\n"
            
            if hasattr(node,'orelse'):
                c_code += self.handle_elif_blocks(node.orelse)
        #ELSE case
        else:
            #only when else case exist
            if not len(node) == 0:
                c_code += make_indent() + 'else {\n'
                c_code += self.func_general_statement(node)
                c_code += make_indent() + '}\n'
    
        return c_code
    
    def func_general_statement(self, node):
        c_code = ""
        node_list = None
        #For generic function
        if hasattr(node,'body'):
            node_list = node.body
        #For ELSE case whcih gives list parameter 'orelse'
        else:
            node_list = node
            
        for stmt in node_list:
            if isinstance(stmt, ast.AnnAssign):
                if hasattr(stmt.value,'func') and stmt.value.func.id == 'list':
                    var_name = stmt.target.id
                    if var_name not in self.declared_vars:
                        c_code += make_indent() + f"{stmt.annotation.id} * {var_name};\n"
                        self.declared_vars.add(var_name)
                
                elif isinstance(stmt.value,ast.List):
                    var_name = stmt.target.id
                    if var_name not in self.declared_vars:
                        c_code += make_indent() + f"{stmt.annotation.id} {var_name}[] = {{"
                        self.declared_vars.add(var_name)
                        param_num = len(stmt.value.elts)
                        param_index = 0
                        for elt in stmt.value.elts:
                            c_code += self.normal_statement(elt)
                            param_index += 1
                            if param_index != param_num:
                                c_code += ', '
                        c_code += '};'
                    else:
                        param_num = len(stmt.value.elts)
                        param_index = 0
                        for elt in stmt.value.elts:
                            c_code += make_indent() + f"{var_name}[{param_index}] = {self.normal_statement(elt)};\n"
                            param_index += 1
                else:
                    # For class inherent variable declaration
                    print(stmt.target)
                    if isinstance(stmt.target,ast.Attribute) and stmt.target.value.id == 'self':
                        c_code += make_indent()+f"this->{stmt.target.attr};\n"
                    # For local variable declaration
                    elif hasattr(stmt.target,'id') and not stmt.target.id in self.declared_vars:
                        if not stmt.target.id in self.declared_vars:
                            self.declared_vars.add(stmt.target.id)
                        c_code += make_indent()+f"{stmt.annotation.id} {stmt.target.id};\n"
                        var_name = stmt.target.id
                        if hasattr(stmt,'value') and stmt.value != None:
                            var_value = self.normal_statement(stmt.value)
                            c_code += make_indent()+f"{var_name} = {var_value};\n"
                            
                    
            elif isinstance(stmt, ast.BinOp):
                c_code += self.normal_statement(stmt)
                    
            elif isinstance(stmt, ast.Expression):
                c_code += make_indent() + f"{self.normal_statement(stmt.body.value)};\n"
            
            elif isinstance(stmt, ast.Expr):
                var_value = self.normal_statement(stmt.value)
                c_code += make_indent() +  f"{var_value};\n"
                    
            elif isinstance(stmt, ast.Assign):
                for target in stmt.targets: #target can be multiple?
                    if isinstance(target, ast.Name):
                        if hasattr(stmt.value,'func') and (stmt.value.func.id in classes_id):
                            var_name = target.id
                            var_value = self.normal_statement(stmt.value)
                            c_code += make_indent() + f"{var_name} = {var_value};\n"
                            self.declared_class[var_name] = stmt.value.func.id
                        
                        elif isinstance(stmt.value,ast.List):
                            var_name = target.id
                            if var_name not in self.declared_vars:
                                c_code += make_indent() + f"{stmt.annotation.id} {var_name}[] = {{"
                                self.declared_vars.add(var_name)
                                param_num = len(stmt.value.elts)
                                param_index = 0
                                for elt in stmt.value.elts:
                                    c_code += self.normal_statement(elt)
                                    param_index += 1
                                    if param_index != param_num:
                                        c_code += ', '
                                c_code += '};'
                            else:
                                param_num = len(stmt.value.elts)
                                param_index = 0
                                for elt in stmt.value.elts:
                                    c_code += make_indent() + f"{var_name}[{param_index}] = {self.normal_statement(elt)};\n"
                                    param_index += 1
                            
                        else:
                            var_name = target.id
                            if var_name not in self.declared_vars:
                                c_code += make_indent() + f"int {var_name};\n"
                                self.declared_vars.add(var_name)

                            for target in stmt.targets:
                                var_name = target.id
                                var_value = self.normal_statement(stmt.value)
                                c_code += make_indent() + f"{var_name} = {var_value};\n"
            
            elif isinstance(stmt,ast.Attribute):
                if not stmt.id in self.declared_this_vars and stmt.value.id == 'self':
                    self.declared_this_vars(stmt.attr)
                    raise Exception('Not declared class variable Error')
                c_code += make_indent()+f"this->{stmt.value.attr};\n"
                                
            elif isinstance(stmt, ast.Return):
                return_value = self.normal_statement(stmt.value)
                c_code += make_indent() + f"return {return_value};\n"
            
            elif isinstance(stmt, ast.If):
                c_code += self.handle_if_block(stmt)
                
            elif isinstance(stmt, ast.For):
                # print(ast.dump(stmt, indent=4))
                loop_var = stmt.target.id
                if len(stmt.iter.args) == 3:
                    start = self.normal_statement(stmt.iter.args[0])
                    end = self.normal_statement(stmt.iter.args[1])
                    step = self.normal_statement(stmt.iter.args[2])
                elif len(stmt.iter.args) == 2:
                    start = self.normal_statement(stmt.iter.args[0])
                    end = self.normal_statement(stmt.iter.args[1])
                    step = "1"
                
                else:
                    start = "0"
                    end = self.normal_statement(stmt.iter.args[0])
                    step = "1"
        
                c_code += make_indent() + f"for (int {loop_var} = {start}; {loop_var} < {end}; {loop_var} += {step}) {{\n"
                
                inc_indent()
                c_code += self.func_general_statement(stmt)
                dec_indent()
        
                c_code += make_indent() + "}\n"
        
        return c_code
    
    def method_general_statement(self, node):
        c_code = ""
        c_code += self.func_general_statement(node)
        return c_code

class Class_Maker(Basic_Statement):
    def __init__(self):
        self.declared_vars = set()
        self.declared_class = {}
        self.declared_method = []
        self.declared_this_vars = []
        self.class_name = None
        
    def translate_class(self,node):
        if isinstance(node, ast.ClassDef):
            print(ast.dump(node, indent=4))
            class_name = node.name
            self.class_name = class_name
            c_code = f"class {class_name} {{\n"
    
            for stmt in node.body:
                inc_indent()
                if isinstance(stmt, ast.FunctionDef):
                    if stmt.name == "__init__":
                        c_code += make_indent() + "public:\n"
                        inc_indent()
                        for arg in stmt.body:
                            if isinstance(arg, ast.AnnAssign):
                                self.declared_vars.add(arg.target.attr)
                                if hasattr(arg,"value") and arg.value != None:
                                    var_name = arg.target.attr
                                    var_value = self.normal_statement(arg.value)
                                    c_code += make_indent() + f"{arg.annotation.id} {var_name} = {var_value};\n"
                                else:
                                    c_code += make_indent() + f"{arg.annotation.id} {arg.target.attr};\n"
                        dec_indent()
                        c_code += make_indent() + "public:\n"
                        inc_indent()
                        c_code += make_indent() + f"{class_name}("
                        dec_indent()
                        param_num = -len(stmt.args.defaults)
                        param_index = 0
                        
                        for arg in stmt.args.args:
                            if arg.arg != 'self':
                                c_code +=f" {arg.annotation.id} {arg.arg}"
                                # Note that class method contains self variable
                                param_num += 1
                                if param_num >= 0:
                                    c_code += " = " + str(stmt.args.defaults[param_num].value) + " "
                                param_index += 1
                                if param_index != (len(stmt.args.args)-1):
                                    c_code += ","
                        c_code += ");\n"
                        dec_indent()
            
            #Method declaration in class
            for stmt in node.body:
                if isinstance(stmt, ast.FunctionDef) and stmt.name != "__init__":
                    if hasattr(stmt,"returns") and hasattr(stmt.returns,"id") and stmt.returns != None:
                        c_code += make_indent() + f"{stmt.returns.id} {stmt.name}("
                    else:
                        c_code += make_indent() +  f"int {stmt.name}("
                    
                    param_num = -len(stmt.args.defaults)
                    print(len(stmt.args.defaults))
                    param_index = 0
                    
                    for arg in stmt.args.args:
                        if arg.arg != 'self':
                            c_code +=f" {arg.annotation.id} {arg.arg}"
                            # Note that class method contains self variable
                            param_index += 1
                            if param_num >= 0 and len(stmt.args.defaults) != 0:
                                c_code += " = " + str(stmt.args.defaults[param_num].value) + " "
                            param_num += 1
                            if param_index != (len(stmt.args.args)-1):
                                c_code += ","
                    
                    c_code += ");\n"
                
            dec_indent()
            dec_indent()
            c_code += "};\n\n"
    
            # Class Method Declaration
            for stmt in node.body:
                # Non-init method
                if isinstance(stmt, ast.FunctionDef) and stmt.name != "__init__":
                    self.declared_method.append(stmt.name)
                    if hasattr(stmt,"returns") and hasattr(stmt.returns,"id") and stmt.returns != None:
                        c_code += make_indent() + f"{stmt.returns.id} {self.class_name}::{stmt.name}("
                    else:
                        c_code += make_indent() +  f"int {self.class_name}::{stmt.name}("
                    
                    param_num = -len(stmt.args.defaults)
                    print(len(stmt.args.defaults))
                    param_index = 0
                    
                    #Parameter Declaration
                    for arg in stmt.args.args:
                        if arg.arg != 'self':
                            c_code +=f" {arg.annotation.id} {arg.arg}"
                            # Note that class method contains self variable
                            param_index += 1
                            if param_num >= 0 and len(stmt.args.defaults) != 0:
                                c_code += " = " + str(stmt.args.defaults[param_num].value) + " "
                            param_num += 1
                            if param_index != (len(stmt.args.args)-1):
                                c_code += ","
                    
                    c_code += "){\n"
                    inc_indent()
                    c_code += self.method_general_statement(stmt)
                    dec_indent()
                    c_code += '}\n'
                    
                #Init Method
                if isinstance(stmt, ast.FunctionDef) and stmt.name == "__init__":
                    self.declared_method.append(f'{self.class_name}')
                    # No return value
                    c_code += f'{self.class_name}('
                    
                    param_num = -len(stmt.args.defaults)
                    print(len(stmt.args.defaults))
                    param_index = 0
                    
                    #Parameter Declaration
                    for arg in stmt.args.args:
                        if arg.arg != 'self':
                            c_code +=f" {arg.annotation.id} {arg.arg}"
                            # Note that class method contains self variable
                            param_index += 1
                            if param_num >= 0 and len(stmt.args.defaults) != 0:
                                c_code += " = " + str(stmt.args.defaults[param_num].value) + " "
                            param_num += 1
                            if param_index != (len(stmt.args.args)-1):
                                c_code += ","
                    
                    c_code += "){\n"
                    inc_indent()
                    c_code += self.method_general_statement(stmt)
                    dec_indent()
                    c_code += '}\n'
    
            return c_code


class Func_Maker(Basic_Statement):
    def __init__(self):
        self.declared_vars = set()
        self.declared_class = {}
        self.declared_method = []
        self.func_name = None
        
    def translate_function(self,node):
        if isinstance(node, ast.FunctionDef):
            if hasattr(node,"returns") and hasattr(node.returns,"id") and node.returns != None:
                c_code = f"{node.returns.id} {node.name}("
            else:
                c_code = f"int {node.name}("
            
            self.func_name = node.name
            #For check delcared variable
            # print(ast.dump(node, indent=4))
            
            param_num = -len(node.args.defaults)
            param_index = 0
            
            for arg in node.args.args:
                c_code += f" {arg.annotation.id} {arg.arg}"
                if param_num >= 0 and len(node.args.defaults) != 0:
                    c_code += " = " + str(node.args.defaults[param_num].value) + " "
                param_num += 1
                param_index += 1
                if param_index != len(node.args.args):
                    c_code += ","
            
            c_code += ") {\n"
            
            for arg in node.args.args:
                self.declared_vars.add(arg.arg) 
                
            inc_indent()
            c_code += self.func_general_statement(node)
            dec_indent()
            c_code += make_indent() + "}\n"
            return c_code
        
        else:
            c_code = ""
            inc_indent()
            c_code += self.func_general_statement(node)
            dec_indent()
            c_code += make_indent() + "}\n"
                    
            return c_code

class interpreter:
    def __inint__(self):
        print("python 2 C")
        
    def python_to_c(self,source_code):
        tree = ast.parse(source_code)
    
        c_code = ""
        global classes
        global classes_id
        classes = collect_classes(tree)
        for classes_ in classes:
            classes_id.append(classes_.name)
        for node in ast.walk(tree):
            if isinstance(node, ast.ClassDef):
                temp_class_maker = Class_Maker()
                c_code += temp_class_maker.translate_class(node)
            elif isinstance(node, ast.FunctionDef) and node not in (func_node for class_node in classes for func_node in class_node.body):
                print(node.name)
                temp_func_maker = Func_Maker()
                c_code += temp_func_maker.translate_function(node)
                print(ast.dump(node, indent=4))
    
        return c_code
    
    def save_c_code_to_file(self, c_code, output_filename):
        with open(output_filename, 'w') as f:
            f.write(c_code)

if __name__ == "__main__":
#     python_code = """
# def foo(a: int = 10) -> char:
#     b:int = a + 10
#     30
#     10+90
#     goo(20+goo(30))
#     a = 20
#     return b

# def bar(x: int, y: float = 10.3) -> int:
#     z = x * (y + foo(10))
#     z = 30 + 60
#     return z
# """

    python_code = """
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
            
def foo( a:int = 10 ):
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
    interp = interpreter()
    c_code = interp.python_to_c(python_code)
    print('Converted C')
    print('##################################################################')
    print('##################################################################')
    print('##################################################################')
    print(c_code)
