# -*- coding: utf-8 -*-
"""
Created on Wed Aug  2 18:01:13 2023

@author: QC109_4
"""
import TCPClient_v1_00 as TCP
import C_compiler as elf_maker
import python2C as interpreter

class RFSoC_Mgr(TCP.RFSoC):
    def __init__(self):
        super().__init__()
        self.interpreter = interpreter.interpreter()
        self.comp = elf_maker.Compiler()
        self.file_name = 'RFSoC_Driver'
        self.do_compile = True
        self.comp.do_compile = self.do_compile
        
    def run_RFSoC(self):
        # Compile C Code in ../C_Code/
        self.comp.compile_code(self.file_name)
        
        # Read the ELF file
        elf_data = self.comp.read_elf_file(self.file_name)

        # Convert to C code array representation
        c_code = self.comp.create_c_code_array(elf_data)

        # Save the C code to a file
        self.comp.save_c_code_to_file(c_code, self.file_name)
        
        # Send ELF binary data to RFSoC
        self.send_bin(self.comp.create_TCP_packet())
        self.tcp.write("#BIN#run_binary#!EOL#");
        
    def set_file_name(self, file_name):
        self.file_name = file_name.replace('.cpp', '').replace('.c', '')
        
if __name__ == "__main__":
    file_name = 'MALLOC_EXP'
    RFSoC_Mgr = RFSoC_Mgr()
    RFSoC_Mgr.set_file_name(file_name)
    RFSoC_Mgr.connect()
    RFSoC_Mgr.run_RFSoC()