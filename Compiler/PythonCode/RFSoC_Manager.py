# -*- coding: utf-8 -*-
"""
Created on Wed Aug  2 18:01:13 2023

@author: QC109_4
"""
import TCPClient_v1_00 as TCP
import C_compiler as elf_maker
import python2C as interpreter
import time

class rfsocMgr(TCP.RFSoC):
    def __init__(self):
        super().__init__()
        self.interpreter = interpreter.interpreter()
        self.comp = elf_maker.Compiler()
        self.file_name = 'RFSoC_Driver'
        self.do_compile = True
        self.comp.do_compile = self.do_compile
        
    def runRFSoC(self):
        # Compile C Code in ../C_Code/
        self.comp.compile_code(self.file_name)
        
        # Read the ELF file
        elf_data = self.comp.read_elf_file(self.file_name)

        # Convert to C code array representation
        c_code = self.comp.create_c_code_array(elf_data)

        # Save the C code to a file
        self.comp.save_c_code_to_file(c_code, self.file_name)
        
        # Send ELF binary data to RFSoC
        self.sendBin(self.comp.create_TCP_packet())
        self.tcp.write("#BIN#run_binary#!EOL#");
        a = self.tcp.read()
        print(a)
        
    def setFileName(self, file_name):
        self.file_name = file_name.replace('.cpp', '').replace('.c', '')
        
    def stopRFSoC(self):
        self.tcp.write("#BIN#stop_binary#!EOL#")
        a = self.tcp.read()
        print(a)
    
    def readTCP(self):
        a = self.tcp.read()
        print(a)
    
    def read8bitData(self):
        """
        Note that read data is little edian type.
        For instance 
        int64_t x = 0x010203040506
        is coverted to 
        [6,5,4,3,2,1,0,0]
        when we receive data

        """
        data_list = self.tcp.read()
        data_list = bytes(data_list,'latin-1')
        data_list = [i_ for i_ in data_list]
        print(data_list)
        # TCP transfer callback function
        self.recvCallback()
        
        return data_list
        
    def read64bitData(self):
        data_list = self.read8bitData()
        data_64bit_list = []
        for index in range(len(data_list)>>3):
            data_64bit = (data_list[index * 8]) + (data_list[index * 8 + 1] << 8) +\
            (data_list[index * 8 + 2] << 16 )+ (data_list[index * 8 + 3] << 24)+\
            (data_list[index * 8 + 4] << 32 )+ (data_list[index * 8 + 5] << 40)+\
            (data_list[index * 8 + 6] << 48) + (data_list[index * 8 + 7] << 56)
            
            data_64bit_list.append(data_64bit)
           
        data_hex_list = [hex(i_) for i_ in data_64bit_list]
        print(data_hex_list)
        return data_64bit_list
    
    def close(self):
        self.disconnect()
        
if __name__ == "__main__":
    file_name = 'skeleton_code'
    rfsocMgr = rfsocMgr()
    rfsocMgr.setFileName(file_name)
    rfsocMgr.connect()
    rfsocMgr.stopRFSoC()
    rfsocMgr.runRFSoC()
    rfsocMgr.read64bitData()
    rfsocMgr.read64bitData()
    
    # rfsocMgr.stopRFSoC()
    rfsocMgr.close()