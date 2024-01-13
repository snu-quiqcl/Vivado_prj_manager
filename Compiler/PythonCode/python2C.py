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

classes = dict()
functions = dict()
types = dict()
    
indent = 0

list_value_num = 0

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
    if indent >0:
        indent -= 1
def reset_indent():
    global indent
    indent = 0
    
def inc_list_value_num():
    global list_value_num
    list_value_num += 1

def dec_list_value_num():
    global list_value_num
    list_value_num -= 1

def get_list_value_num():
    global list_value_num
    return list_value_num

class Token_Object:
    def __init__(self, statement, var_type):
        self.statement = statement
        self.var_type = var_type
        self.value = None
        self.is_R = False
    
    def __statement__(self):
        return self.statement
    
    def __type__(self):
        return self.var_type
    
    def __value__(self):
        return self.value()
    
    def __is_R__(self):
        return self.is_R
    
    def set_statement(self,statement):
        self.statement = statement
    
    def set_value(self,value):
        self.value = value
        
    def set_is_R(self):
        self.is_R = True
            

class Basic_Statement:
    def __init__(self):
        self.c_code = ''
        print('basic')
        
    def append_code(self, code):
        self.c_code += code
        
    def get_code(self):
        return self.c_code
        
    def translate_BinOp(self, node):
        left_code = self.normal_statement(node.left).__statement__()
        right_code = self.normal_statement(node.right).__statement__()
        if self.normal_statement(node.left).__type__() != self.normal_statement(node.right).__type__():
            raise Exception(f'{self.normal_statement(node.left).__statement__()} \
and {self.normal_statement(node.right).__statement__()} \
type is different ({self.normal_statement(node.left).__type__()} !=\
{self.normal_statement(node.right).__type__()})')
        op_code = self.operator_to_c(node.op)
        
        return Token_Object(f"({left_code} {op_code} {right_code})",\
                            self.normal_statement(node.left).__type__())
    
    def translate_Constant(self,node):
        if type(node.value).__name__ == 'str':
            if len(node.value) == 1:
                return Token_Object(str(node.value),types['char'])
            else:
                return Token_Object("\""+node.value + "\"", types['str'])
        return Token_Object(str(node.value),types[type(node.value).__name__])
    
    def translate_Expr(self,node):
        return Token_Object(f"{self.normal_statement(node.value).__statement__()};\n" + make_indent(),None)
    
    def translate_Subscript(self,node):
        return Token_Object(f"{self.normal_statement(node.value).__statement__()}\
                            [{self.normal_statement(node.slice).__statement__()}]"\
                            ,self.normal_statement(node.value).__type__()) #CHECK!!
        
    def translate_Call(self,node):
        # print(ast.dump(node, indent=4))
        if hasattr(node.func, 'value'):
            if node.func.value.id in self.declared_vars:
                c_code = ""
                c_code += f"{node.func.value.id}.{node.func.attr}("
                param_num = len(node.args)
                param_index = 0
                for stmt in node.args:
                    c_code += self.normal_statement(stmt).__statement__()
                    param_index += 1
                    if not param_index == param_num:
                        c_code += ', '
                c_code += ')'
                return Token_Object(c_code,self.declared_vars[node.func.value.id].__type__().declared_method[node.func.attr].ret_type)
        
        elif node.func.id in classes:
            c_code = ""
            c_code += f"{node.func.id}("
            param_num = len(node.args)
            param_index = 0
            for stmt in node.args:
                c_code += self.normal_statement(stmt).__statement__()
                param_index += 1
                if not param_index == param_num:
                    c_code += ', '
            c_code += ')'
            return Token_Object(c_code,classes[node.func.id])
        else:
            c_code = ""
            if node.func.id in functions:
                func_name = functions[node.func.id].name
            else:
                raise Exception(f'{node.func.id} is not declared')
            c_code += f"{func_name}("
            param_num = len(node.args)
            param_index = 0
            for stmt in node.args:
                c_code += self.normal_statement(stmt).__statement__()
                param_index += 1
                if not param_index == param_num:
                    c_code += ', '
            c_code += ')'
            return Token_Object(c_code,functions[node.func.id].ret_type)
        
    def tranlsate_Name(self,node):
        if node.id in self.declared_vars:
            return self.declared_vars[node.id]
        else:
            raise Exception(f'{node.id} is not defined')
    
    def translate_Compare(self,node):
        if self.normal_statement(node.left).__type__() != self.normal_statement(node.comparators[0]).__type__():
            raise Exception(f'different type cannot be compared ({self.normal_statement(node.left).__type__()} != {self.normal_statement(node.comparators[0]).__type__()})')
        return Token_Object(f'( {self.normal_statement(node.left).__statement__()} {self.operator_to_c(node.ops[0])} {self.normal_statement(node.comparators[0]).__statement__()} )','COMP')

    def translate_Attribute(self,node):
        if node.value.id == 'self':
            return self.declared_this_vars[node.attr]
        
        else:
            print("unpared token")
            raise NotImplementedError()
            return ast.unparse(node)

    def translate_BoolOp(self, node):
        stmt_num = len(node.values)
        stmt_index = 0
        c_code = ""
        
        for stmt in node.values:
            c_code += self.normal_statement(stmt).__statement__()
            stmt_index += 1
            if stmt_index != stmt_num:
                c_code += self.operator_to_c(node.op)
            
        return Token_Object(c_code,'BoolOp')
    
    def tranlsate_AnnAssign(self,node):
        c_code = ''
        target = node.target
        
        if not self.is_self(target):
            if target.id in self.declared_vars:
                raise Exception(f'variable re declaration {target.id}')
            
            self.append_code(f'{types[node.annotation.id].__statement__()} {target.id};\n' + make_indent())
            self.declared_vars[target.id] = Token_Object(target.id, types[node.annotation.id])
            
            var_name = self.normal_statement(target)
            if hasattr(node, 'value') and node.value != None:
                var_value = self.normal_statement(node.value)
                c_code += f"{var_name.__statement__()} = {var_value.__statement__()};\n" + make_indent()
                
                if self.declared_vars[var_name.__statement__()].__type__() != var_value.__type__():
                    raise Exception(f'{var_name.__statement__()} and {var_value.__statement__()} \
has different type ({self.declared_vars[var_name.__statement__()].__type__ ()}\
!={var_value.__type__()})')
            
            if var_name.__is_R__():
                raise Exception(f'R value cannot be assigned({var_name.__statement__()})')
            
            return Token_Object(c_code, self.declared_vars[var_name.__statement__()].__type__ ())
        else:
            # For class inherent variable declaration
            if isinstance(node.target,ast.Attribute) and node.target.value.id == 'self':
                c_code += f"this->{node.target.attr};\n" + make_indent()
            # For local variable declaration
            elif hasattr(node.target,'id') and not node.target.id in self.declared_vars:
                if not node.target.id in self.declared_vars:
                    self.declared_vars[node.target.id] = Token_Object(node.target.id, node.annotation.id)
                c_code += f"{types[node.annotation.id].__statement__()} {node.target.id};\n" + make_indent()
                var_name = node.target.id
                if hasattr(node,'value') and node.value != None:
                    var_value = self.normal_statement(node.value).__statement__()
                    c_code += f"{var_name} = {var_value};\n" + make_indent()
            return Token_Object(c_code,node.annotation.id)
            
                    
    def translate_Assign(self, node):
        c_code = ''
        for target in node.targets: #target can be multiple?
            # Class variable declaration
            if not self.is_self(target):
                var_name = self.normal_statement(target)
                var_value = self.normal_statement(node.value)
                
                if var_name.__is_R__():
                    raise Exception(f'R value cannot be assigned({var_name.__statement__()})')
                
                c_code += f"{var_name.__statement__()} = {var_value.__statement__()};\n" + make_indent()
                self.declared_vars[var_name] = Token_Object(var_name, var_value.__type__())
                if self.declared_vars[var_name].__type__() != var_value.__type__():
                        raise Exception(f'{var_name.__statement__()} and {var_value.__statement__()} \
has different type ({self.declared_vars[var_name.__statement__()].__type__ ()}\
!={var_value.__type__()})')
                return Token_Object(c_code, self.declared_vars[var_name.__statement__()].__type__ ())
            
            # Variable is declared as a this-> variable
            elif self.is_self(target) and target.attr in self.declared_this_vars:
                var_name = f'this -> {target.attr}'
                var_value = self.normal_statement(node.value).__statement__()
                c_code += f"{var_name} = {var_value};\n" + make_indent()
                return Token_Object(c_code, 'assign')
    
    def translate_Return(self,node):
        return_ob = self.normal_statement(node.value)
        return_value = return_ob.__statement__()
        return_type = return_ob.__type__()
        c_code = f"return {return_value};\n" + make_indent()
        return Token_Object(c_code,return_type)
        
    def translate_If(self, node):
        # print(ast.dump(node, indent=4))
        condition = self.normal_statement(node.test).__statement__()
        inc_indent()
        c_code = f"if ({condition}) {{\n" + make_indent()
    
        for stmt in node.body:
            c_code += self.normal_statement(stmt).__statement__()
        dec_indent()
        c_code += "}\n" + make_indent()
        
        for stmt in node.orelse:
            c_code += self.handle_elif_blocks(stmt).__statement__()
    
        return Token_Object(c_code,'if')
    
    def handle_elif_blocks(self, node):
        c_code = ""
        # print(ast.dump(node, indent=4))
        #ELIF case
        if isinstance(node, ast.If):
            condition = self.normal_statement(node.test).__statement__()
            inc_indent()
            c_code += f"else if ({condition}) {{\n" + make_indent()
    
            for stmt in node.body:
                c_code += self.normal_statement(stmt).__statement__()
            dec_indent()
            c_code += "}\n" + make_indent()
            dec_indent()
            
            if hasattr(node,'orelse'):
                c_code += self.handle_elif_blocks(node.orelse).__statement__()
        #ELSE case
        else:
            inc_indent()
            inc_indent()
            #only when else case exist
            if not len(node) == 0:
                c_code += 'else {\n' + make_indent()
                for stmt in node:
                    c_code += self.normal_statement(stmt).__statement__()
                dec_indent()
                c_code += '}\n' + make_indent()
            
            dec_indent()
    
        return Token_Object(c_code,'elif')
    
    def translate_For(self,node):
        # print(ast.dump(node, indent=4))
        c_code = ''
        loop_var = node.target.id
        if len(node.iter.args) == 3:
            start = self.normal_statement(node.iter.args[0]).__statement__()
            end = self.normal_statement(node.iter.args[1]).__statement__()
            step = self.normal_statement(node.iter.args[2]).__statement__()
        elif len(node.iter.args) == 2:
            start = self.normal_statement(node.iter.args[0]).__statement__()
            end = self.normal_statement(node.iter.args[1]).__statement__()
            step = "1"
        
        else:
            start = "0"
            end = self.normal_statement(node.iter.args[0]).__statement__()
            step = "1"

        c_code += self.normal_statement(node.target).__statement__() + ';\n' +make_indent()
        inc_indent()
        c_code += f"for ({loop_var} = {start}; {loop_var} < {end}; {loop_var} += {step}) {{\n" + make_indent()
        
        for stmt in node.body:
            c_code += self.normal_statement(stmt).__statement__()

        dec_indent()
        c_code += "}\n" + make_indent()
        return Token_Object(c_code, 'FOR')
    
    def translate_List(self, node):
        var_name = f'list_pointer_{get_list_value_num()}'
        if node.elts is not None:
            var_type = types['list_ele'].__statement__()
            self.append_code(f'{var_type} {var_name} = PyCList_New({len(node.elts)});\n' + make_indent())
            inc_list_value_num()
            index = 0
            
            for ele in node.elts:
                element = self.normal_statement(ele)
                ele_name = element.__statement__()
                ele_type = element.__type__()
                if ele_type == 'int64_t':
                    self.append_code(f'{var_type} list_componenet_class_{get_list_value_num()} = PyC_make_int64({ele_name});\n' + make_indent())
                elif ele_type == 'char':
                    self.append_code(f'{var_type} list_componenet_class_{get_list_value_num()} = PyC_make_char({ele_name});\n' + make_indent())
                
                self.append_code(f'PyC_INCREF(list_componenet_class_{get_list_value_num()});\n' + make_indent())
                self.append_code(f'PyCList_SET_ITEM({var_name}, {index}, list_componenet_class_{get_list_value_num()});\n' + make_indent())
                self.declared_vars[f'list_componenet_class_{get_list_value_num()}'] = Token_Object(f'list_componenet_class_{get_list_value_num()}','PyCObject *')
                inc_list_value_num()
                index += 1
            self.declared_vars[var_name] = Token_Object(var_name,types['list'])
            
            return self.declared_vars[var_name]
        #####################################################################
        # we have to consider when already declared list is redeclared again...
        #####################################################################
        
    def normal_statement(self,node):
        if isinstance(node, ast.BinOp):
            return self.translate_BinOp(node)
        elif isinstance(node, ast.Constant):
            return self.translate_Constant(node)
        elif isinstance(node, ast.Expr):
            return self.translate_Expr(node)
        elif isinstance(node, ast.Subscript):
            return self.translate_Subscript(node)
        elif isinstance(node, ast.Call):
            return self.translate_Call(node)
        elif isinstance(node, ast.Name):
            return self.tranlsate_Name(node)
        elif isinstance(node, ast.Compare):
            return self.translate_Compare(node)
        elif isinstance(node,ast.Attribute):
            return self.translate_Attribute(node)
        elif isinstance(node, ast.BoolOp):
            return self.translate_BoolOp(node)
        elif isinstance(node, ast.AnnAssign):
            return self.tranlsate_AnnAssign(node)
        elif isinstance(node, ast.Assign):
            return self.translate_Assign(node)
        elif isinstance(node, ast.Return):
            return self.translate_Return(node)
        elif isinstance(node, ast.If):
            return self.translate_If(node)
        elif isinstance(node, ast.For):
            return self.translate_For(node)
        elif isinstance(node, ast.List):
            return self.translate_List(node)
        else: 
            print(ast.dump(node,indent=4))
            raise NotImplemented(f'{node} is not implemented')
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
    
    def is_self(self,node):
        if isinstance(node,ast.Attribute) and node.value.id == 'self':
            return True
        else:
            return False
        
    def add_function_args(self, node):
        param_start_index = len(node.args.args)-len(node.args.defaults)
        param_index = 0
                
        for arg in node.args.args:
            if arg.arg != 'self':
                self.append_code(f" {types[arg.annotation.id].__statement__()} {arg.arg}")
                # Note that class method contains self variable
                if param_index >= param_start_index and len(node.args.defaults) != 0:
                    self.append_code(" = " + str(node.args.defaults[param_index - param_start_index].value) + " ")
                if param_index < (len(node.args.args) - 1):
                    self.append_code(",")
                param_index += 1
            else:
                param_index += 1
    

class Class_Maker(Basic_Statement):
    def __init__(self):
        # Variable symbol table
        self.declared_vars = dict()
        # Class symbol table
        self.declared_class = dict()
        # Method symbol table
        self.declared_method = dict()
        #current function name
        self.func_name = None
        # this-> variable symbol table
        self.declared_this_vars = dict()
        #current class name
        self.class_name = None
        # return type of function
        self.ret_type = None
        # current function's body AST
        self.body = None
        # current function's c code
        self.c_code = ''
        
    def translate_class(self,node):
        self.body = node
        if isinstance(node, ast.ClassDef):
            class_name = node.name
            self.class_name = class_name
            self.append_code(f"class {class_name} {{\n" + make_indent())
            
            # Get all self value
            for stmt in node.body:
                for arg in ast.walk(stmt):
                    # Condition whether variable is self variable or not
                    if hasattr(arg,'target') and hasattr(arg.target,'value') \
                            and hasattr(arg.target.value,'id') \
                            and arg.target.value.id == 'self':
                        # Check whether variable is in symbol table already or not
                        if not arg.target.attr in self.declared_this_vars:
                            if hasattr(arg,'annotation'):
                                # Put this->variable in declared symbol table with type
                                if not arg.target.attr in self.declared_this_vars:
                                    self.declared_this_vars[arg.target.attr] = \
                                    Token_Object(f'{arg.target.attr}', \
                                    types[arg.annotation.id])
                                else:
                                    raise Exception(f'self.{arg.target.attr} is already declared')
            
            inc_indent()
            #Declare class variables
            self.append_code("public:\n" + make_indent())
            for arg in self.declared_this_vars:
                self.append_code(f'{self.declared_this_vars[arg].__type__().__statement__()} \
{self.declared_this_vars[arg].__statement__()};\n'  + make_indent() )
            
            dec_indent()
            self.append_code('\n'+make_indent())
            inc_indent()
            #Declare function method. Implementation is at outside of class declaration
            self.append_code("public:\n" + make_indent())
            self.append_code(f'{class_name}(){{}};\n' + make_indent())
            
            for stmt in node.body:
                if isinstance(stmt, ast.FunctionDef):
                    param_index = 0
                    if stmt.name == "__init__":
                        self.declared_method[stmt.name] = Func_Maker()
                        self.append_code(f"{class_name}(")
                        
                    else:
                        self.declared_method[stmt.name] = Func_Maker()
                        if hasattr(stmt,"returns") and hasattr(stmt.returns,"id") and stmt.returns != None:
                            self.append_code(f"{types[stmt.returns.id].__statement__()} {stmt.name}(")
                        else:
                            raise Exception(f'{stmt.name} has no return type')
                    for arg in stmt.args.args:
                        if arg.arg != 'self':
                            self.append_code(f" {types[arg.annotation.id].__statement__()} {arg.arg}")
                            if param_index < (len(stmt.args.args) - 1):
                                self.append_code(",")
                        param_index += 1
                        
                    self.append_code(");\n" + make_indent())
                            
            dec_indent();
            self.append_code("};\n\n" + make_indent())
            
            for methods in self.declared_method:
                self.declared_method[methods].initialize_class_ob(self,methods)

            # Class Method Implementation
            for stmt in node.body:
                if isinstance(stmt, ast.FunctionDef):
                    self.append_code(self.declared_method[stmt.name].translate_method(stmt))
                    
                
            return self.get_code()
        
    def __statement__(self):
        return self.class_name


class Func_Maker(Basic_Statement):
    def __init__(self):
        # Variable symbol table
        self.declared_vars = dict()
        # Class symbol table
        self.declared_class = dict()
        # Method symbol table
        self.declared_method = dict()
        #current function name
        self.func_name = None
        # this-> variable symbol table
        self.declared_this_vars = dict()
        #current class name
        self.class_name = None
        # return type of function
        self.ret_type = None
        # current function's body AST
        self.body = None
        # current function's c code
        self.c_code = ''
        
    def translate_function(self,node):
        if isinstance(node, ast.FunctionDef):
            if hasattr(node,"returns") and hasattr(node.returns,"id") and node.returns != None:
                self.append_code(f"{types[node.returns.id].__statement__()} {node.name}(")
                self.ret_type = types[node.returns.id]
            else:
                raise Exception(f'{node.name} has no return type')
            
            self.func_name = node.name
            
            self.add_function_args(node)
            
            inc_indent()
            
            self.append_code(") {\n" + make_indent())
            
            for arg in node.args.args:
                self.declared_vars[arg.arg] = Token_Object(arg.arg, arg.annotation.id)
                self.declared_vars[arg.arg].set_is_R()
                
            for stmt in node.body:
                self.append_code(self.normal_statement(stmt).__statement__())
                
            self.append_code("}\n" + make_indent())
            dec_indent()
            return self.get_code()
        
        else:
            self.append_code("")
            self.append_code(self.normal_statement(node))
            self.append_code("}\n" + make_indent())
                    
            return self.get_code()
        
    def translate_method(self,stmt):
        inc_indent()
        if stmt.name != '__init__':
            if hasattr(stmt,"returns") and hasattr(stmt.returns,"id") and stmt.returns != None:
                self.append_code(f"{types[stmt.returns.id].__statement__()} {self.class_name}::{stmt.name}(")
                self.ret_type = types[stmt.returns.id]
            else:
                raise Exception(f'{stmt.name} has no return type')
            
        else:
            self.append_code(f'{self.class_name}::{self.class_name}(')
        
        #Parameter Declaration
        self.add_function_args(stmt)
        
        for arg in stmt.args.args:
            if arg.arg != 'self':
                self.declared_vars[arg.arg] = Token_Object(arg.arg, arg.annotation.id)
            else:
                self.declared_vars[arg.arg] = Token_Object(arg.arg, 'class')
        
        self.append_code("){\n" + make_indent())
        for arg in stmt.body:
            self.append_code(self.normal_statement(arg).__statement__())
        dec_indent()
        self.append_code('}\n' + make_indent())
        
        return self.get_code() 
    
    def initialize_class_ob(self,class_ob, name):
        self.declared_vars = class_ob.declared_vars
        self.declared_class = class_ob.declared_class
        self.declared_method =class_ob.declared_method
        self.func_name = name
        self.declared_this_vars = class_ob.declared_this_vars
        self.class_name = class_ob.class_name
        self.ret_type = None
        self.body = class_ob.body
        
    def __statement__(self):
        return self.func_name
            

class interpreter:
    def __init__(self):
        self.c_code = r'#include <stdio.h>' + '\r\n'
        self.c_code += """#include "PyCObjcet.h"
#include "PyCMem.h"
#include "PyCList.h"
#include "PyCType.h"
#include "PyCTypedef.h"

#define list (PyCListObject * )
#define list_ele (PyCObject * )
        """
        
        self.c_code += '\r\n'
        print("python 2 C")
        
    def python_to_c(self,source_code):
        tree = ast.parse(source_code)
    
        global classes
        for node in ast.walk(tree):
            if isinstance(node, ast.ClassDef):
                reset_indent()
                temp_class_maker = Class_Maker()
                self.c_code += temp_class_maker.translate_class(node)
                classes[temp_class_maker.class_name] = temp_class_maker
                types[temp_class_maker.class_name] = temp_class_maker
                reset_indent()
                
            elif isinstance(node, ast.FunctionDef):
                print(ast.dump(node, indent=4))
                reset_indent()
                check_exist = False
                for class_ in classes:
                    for node_ in ast.walk(classes[class_].body):
                        if node_ == node:
                            check_exist = True
                
                if not check_exist:
                    temp_func_maker = Func_Maker()
                    self.c_code += temp_func_maker.translate_function(node)
                    functions[temp_func_maker.func_name] = temp_func_maker
                    
                reset_indent()
    
        return self.c_code
    
    def save_c_code_to_file(self, output_filename):
        with open(output_filename, 'w') as f:
            f.write(self.c_code)
            
    def show_c_code(self):
        print(self.c_code)

##############################################################################
# External function declare
##############################################################################
xil_printf = Func_Maker()
xil_printf.name = 'xil_printf'
functions['print'] = xil_printf

##############################################################################
# Type declare
##############################################################################
types['int'] = Token_Object('int64_t','int64_t')
types['char'] = Token_Object('char','char')
types['list'] = Token_Object('list','list')
types['list_ele'] = Token_Object('list_ele','list_ele')
types['str'] = Token_Object('str','str')

if __name__ == "__main__":
    python_code = """
class dds:
    def __init__(self, a:int = 3):
        self.a:int 
        self.a = a
        
    def out(self, q:int, c:int = 10) ->int:
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
            
def foo( a:int, q:int = 64) -> int:
    b:int = 30
    c:int
    c = 50
    new_dds:dds = dds(30+40,50)
    # new_dds.out(30,40)
    # num_list = list()
    new_list:list = [1,2,3,[1,2,3,[2,'c']]]
    # x:int = new_dds.out(20,30,60) + 20
    # x = (30 + 50)
    
    # new_list2 = [5,9,10,'c']
    
    # new_list[1+10] =3
    
    i:int;
    k:int =10
    
    for i in range(6):
        print(i)
        k = i
    
    x:int = 30
    if x == 80:
        print("x = %d",x)
    elif x == 40:
        print("x+60 = %d", x + 60)
        
"""
    interp = interpreter()
    interp.python_to_c(python_code)
    
    print('Converted C')
    print('##################################################################')
    print('##################################################################')
    print('##################################################################')
    interp.show_c_code()

