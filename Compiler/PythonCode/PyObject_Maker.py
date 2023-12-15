# -*- coding: utf-8 -*-
"""
Created on Wed Dec 13 14:22:55 2023

@author: QC109_4
"""
from python2llvmIR import LLVMIR_Statement

global ir

class PyObject(LLVMIR_Statement):
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
        self.builder = ir.IRBuilder(block)
        function = function
        function.variables = dict()
        functions[function.name] = function
        
        for i in range(len(function.args)):
            function.variables[function.args[i].name] = function.args[i]
            
        val_ptr = self.builder.gep(function.variables['self'],[ir.Constant(ir.IntType(32), 0), ir.Constant(ir.IntType(32), 0)],'val_ptr')
        ref_num = self.builder.gep(function.variables['self'],[ir.Constant(ir.IntType(32), 0), ir.Constant(ir.IntType(32), 1)],'ref_num')
        size = self.builder.gep(function.variables['self'],[ir.Constant(ir.IntType(32), 0), ir.Constant(ir.IntType(32), 2)],'size')
        value_type = self.builder.gep(function.variables['self'],[ir.Constant(ir.IntType(32), 0), ir.Constant(ir.IntType(32), 3)],'type')
        self.builder.store(ir.Constant(ir.IntType(64), 1), ref_num)
        self.builder.store(function.args[2],size)
        self.builder.store(function.args[3],value_type)
        
        malloc_call = self.builder.call(functions[MALLOC], [self.builder.load(size)])
        val_ptr = self.builder.bitcast(malloc_call, ir.PointerType(ir.IntType(8)))
        
        # Copy memory value
        prepare_block = function.append_basic_block("prepare")
        loop_block = function.append_basic_block("loop")
        after_loop_block = function.append_basic_block("after_loop")
        end_block = function.append_basic_block("end")
        self.builder.branch(loop_block)
        
        # Loop: for i in range(size)
        self.builder.position_at_end(prepare_block)
        i = self.builder.alloca(ir.IntType(64),0)
        condition = self.builder.icmp_signed('<', self.builder.load(i), function.args[2],'condition')
        self.builder.cbranch(condition, loop_block, end_block)
        
        # Memory copy logic
        # *(self.value + i) = *(victim.value + i)
        # Assuming victim also has a 'value' pointer, similar to 'self'
        self.builder.position_at_end(loop_block)
        victim_value = self.builder.alloca(ir.PointerType(ir.IntType(8)), name="victim.value")  # Placeholder
        src_ptr = self.builder.gep(function.args[1], [self.builder.load(i)])
        dst_ptr = self.builder.gep(val_ptr, [self.builder.load(i)])
        self.builder.store(self.builder.load(src_ptr), dst_ptr)
        self.builder.branch(after_loop_block)
                
        # AFTER LOOP
        # Increment and check loop 
        self.builder.position_at_end(after_loop_block)
        self.builder.store(self.builder.add(self.builder.load(i), ir.Constant(ir.IntType(64), 1)),i)
        end_condition = self.builder.icmp_signed('<', self.builder.load(i), function.args[2])
        self.builder.cbranch(end_condition, loop_block, end_block)
        
        # END LOOP
        self.builder.position_at_end(end_block)
        
        self.builder.ret(function.variables['self'])
        
        #######################################################################
        # PyObject set_value
        #######################################################################
        """
        define void set_value(self,PyObject * victim):
            if self value != NULL:
                free(self value)
            self value = bitcast malloc(victim -> size) to i8 *
            self size = victim -> size
            for i in rannge(size):
                *(self value + i) = *(value + i)
        """
        arg_types = [ir.PointerType(class_type), ir.PointerType(class_type)]
        
        ret_type = class_type.as_pointer()
        
        func_type = ir.FunctionType(ret_type, arg_types)
        function = ir.Function(module, func_type, name='class.PyObject.set_value')
        
        function.args[0].name = 'self'
        function.args[1].name = 'victim'
        
        block = function.append_basic_block(name="entry")
        self.builder = ir.IRBuilder(block)
        function = function
        function.variables = dict()
        functions[function.name] = function
        
        for i in range(len(function.args)):
            function.variables[function.args[i].name] = function.args[i]
            
        self_val_ptr = self.builder.gep(function.variables['self'],[ir.Constant(ir.IntType(32), 0), ir.Constant(ir.IntType(32), 0)],'val_ptr')
        self_ref_num = self.builder.gep(function.variables['self'],[ir.Constant(ir.IntType(32), 0), ir.Constant(ir.IntType(32), 1)],'ref_num')
        self_size = self.builder.gep(function.variables['self'],[ir.Constant(ir.IntType(32), 0), ir.Constant(ir.IntType(32), 2)],'size')
        self_value_type = self.builder.gep(function.variables['self'],[ir.Constant(ir.IntType(32), 0), ir.Constant(ir.IntType(32), 3)],'type')
        
        victim_val_ptr = self.builder.gep(function.variables['victim'],[ir.Constant(ir.IntType(32), 0), ir.Constant(ir.IntType(32), 0)],'val_ptr')
        victim_ref_num = self.builder.gep(function.variables['victim'],[ir.Constant(ir.IntType(32), 0), ir.Constant(ir.IntType(32), 1)],'ref_num')
        victim_size = self.builder.gep(function.variables['victim'],[ir.Constant(ir.IntType(32), 0), ir.Constant(ir.IntType(32), 2)],'size')
        victim_value_type = self.builder.gep(function.variables['victim'],[ir.Constant(ir.IntType(32), 0), ir.Constant(ir.IntType(32), 3)],'type')
        
        # Free Variable
        condition = self.builder.icmp_signed('!=', self.builder.load(self_val_ptr), ir.Constant(ir.PointerType(ir.IntType(8)), None))
        with self.builder.if_then(condition):
            self.builder.call(functions[FREE], [self.builder.load(self_val_ptr)])
            
        # self.value = bitcast malloc(victim.size) to i8*
        victim_size_val = self.builder.load(victim_size)
        malloc_call = self.builder.call(functions[MALLOC], [victim_size_val])
        self_value_casted = self.builder.bitcast(malloc_call, ir.PointerType(ir.IntType(8)))
        self.builder.store(self_value_casted, self_val_ptr)
        
        # self.size = victim.size
        self.builder.store(victim_size_val, self_size)
        
        # Copy memory from victim to self.value
        prepare_block = function.append_basic_block("prepare")
        loop_block = function.append_basic_block("loop")
        after_loop_block = function.append_basic_block("after_loop")
        end_block = function.append_basic_block("end")
        self.builder.branch(loop_block)
        
        # PREPARE LOOP
        self.builder.position_at_end(prepare_block)
        i = self.builder.alloca(ir.IntType(64),0)
        condition = self.builder.icmp_signed('<', self.builder.load(i), victim_size_val,'condition')
        self.builder.cbranch(condition, loop_block, end_block)
        
        # LOOP
        # Memory copy logic
        # *(self.value + i) = *(victim.value + i)
        # Assuming victim also has a 'value' pointer, similar to 'self'
        self.builder.position_at_end(loop_block)
        victim_value = self.builder.alloca(ir.PointerType(ir.IntType(8)), name="victim.value")  # Placeholder
        src_ptr = self.builder.gep(self.builder.load(victim_val_ptr), [self.builder.load(i)])
        dst_ptr = self.builder.gep(self.builder.load(self_val_ptr), [self.builder.load(i)])
        self.builder.store(self.builder.load(src_ptr), dst_ptr)
        self.builder.branch(after_loop_block)
        
        # AFTER LOOP
        # Increment and check loop 
        self.builder.position_at_end(after_loop_block)
        self.builder.store(self.builder.add(self.builder.load(i), ir.Constant(ir.IntType(64), 1)),i)
        end_condition = self.builder.icmp_signed('<', self.builder.load(i), victim_size_val)
        self.builder.cbranch(end_condition, loop_block, end_block)
        
        # END LOOP
        self.builder.position_at_end(end_block)
        
        self.builder.ret(function.variables['self'])