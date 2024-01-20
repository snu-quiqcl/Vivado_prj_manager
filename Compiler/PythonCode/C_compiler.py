# -*- coding: utf-8 -*-
"""
Created on Tue Aug  1 23:27:53 2023

@author: QC109_4
"""
import subprocess
import os
from elftools.elf.elffile import ELFFile #pip install pyelftools
from capstone import * #pip install capstone

class Compiler:
    def __init__(self):
        print('compiler')
        # elf file object
        self.elf_data = None
        # Compiler Object will not compile C Code if do_compile is set to False
        self.do_compile = False
        # Save the entry point of the ELF file
        self.entry_point = 0x00
        # Save the stack pointer address of the ELF file
        self.stack_start = 0x00
        # Save the end of stack pointer address of the ELF file.
        self.stack_end = 0x00
        # Save the head pointer address of the ELF file
        self.heap_start = 0x00
        # Save the end of the heap pointer address of the ELF file
        self.heap_end = 0x00
        # If is_cpp is set to False, you use gcc compiler to compile your C Code.
        # On the other side, if you set this to True, you will use g++ compiler to compile
        # your code. Note that two compilers work differently when you compile 
        # C and C++ files together
        self.is_cpp = True
        # total_command is used temporaliry save gnu compiler command
        self.total_command = ''
        # total_log save the compiler output
        self.total_log = ''
        
        # Directory of your GIT
        self.git_dir = r'C:\Jeonghyun\GIT'
        # Compiler use Xilinx bsp libraries. So, you have to set xilinx include diretory
        # In this program, default xilinx library direcotry is set already, so you
        # don't need to modify this variable.
        self.xilinx_include_dir = r'Vivado_prj_manager\Compiler\Xilinx_Include\bspinclude\include'
        # Directory of RFSoC Driver C programs. In RFSoC Driver, there is DAC Controller driver, or TTL 
        # driver etc. 
        self.rfsoc_driver_dir = r'Vivado_prj_manager\Compiler\C_Code\RFSoC_Driver'
        # Directory of RFSoC Driver header.
        self.rfsoc_driver_include_dir = r'Vivado_prj_manager\Compiler\C_Code\RFSoC_Driver_Include'
        # full_* has full directory of each relative directories.
        self.full_rfsoc_driver_dir = os.path.join(self.git_dir,self.rfsoc_driver_dir)
        self.full_rfsoc_driver_include_dir = os.path.join(self.git_dir,self.rfsoc_driver_include_dir)
        self.full_xilinx_include_dir = os.path.join(self.git_dir, self.xilinx_include_dir)
    
    def getAllFilesInDirectory(self, directory,file_type):
        """
        get all files which are in directory
        Args:
            directory : directory where you want to search
            file_type : list of file types which you want to serach
        
        Returns:
            list of files which are in directory and has type of file_type
        """
        file_list = []
        is_filetype = False
        
        for root, dirs, files in os.walk(directory):
            for file in files:
                for types_ in file_type:
                    if file.endswith(types_):
                        is_filetype = True
                if is_filetype:
                    file_list.append(os.path.join(root, file))
                is_filetype = False
        return file_list
        
    def readELFfile(self, file_name):
        """
        read ELF file and get stack start, end, heap start, end address. In addition 
        it gets entry point address where PC register has to jump to start 
        program on CPU.
        Args:
            file_name : name of file
        
        Returns:
            elf file 
        """
        elf_file_name = f'../C_Code/{file_name}/' + file_name + '.elf'
        with open(elf_file_name, 'rb') as f:
            self.elf_data = f.read()
            elf_file = ELFFile(f)

            # Print information about the ELF file
            print("ELF file information:")
            print(f"  Architecture: {elf_file.get_machine_arch()}")
            print(f"  Number of sections: {elf_file.num_sections()}")
            print(f"  Number of segments: {elf_file.num_segments()}")
            print(f"ENTRY POINT: \t0x{elf_file.header.e_entry:x}")

            self.entry_point = elf_file.header.e_entry
            
            for section in elf_file.iter_sections():
                # Check if the section is of type SHT_SYMTAB (symbol table)
                if section.header['sh_type'] == 'SHT_SYMTAB':
                    # Iterate over all symbols in the symbol table
                    for symbol in section.iter_symbols():
                        # print(symbol.name)
                        if symbol.name == '__stack_start':
                            self.stack_start = symbol.entry.st_value
                            print(f'STACK_START : \t{hex(self.stack_start)}')
                        elif symbol.name == '_stack_end':
                            self.stack_end = symbol.entry.st_value
                            print(f'STACK_END : \t{hex(self.stack_end)}')
                        elif symbol.name == '_heap_start':
                            self.heap_start = symbol.entry.st_value
                            print(f'HEAP_SATRT : \t{hex(self.heap_start)}')
                        elif symbol.name == '_heap_end':
                            self.heap_end = symbol.entry.st_value
                            print(f'HEAP_END : \t\t{hex(self.heap_end)}')
            
        return self.elf_data
    
            
    def compileCode(self, file_name):
        """
        Compile the C Code to ELF file
        Args:
            file_name : directory and name of file. If should be same
        
        Returns:
            None
        """
        if self.do_compile == True:
            driver_list = []
            ###############################################################
            ## RFSoC Driver
            ###############################################################
            driver_files = self.getAllFilesInDirectory(self.full_rfsoc_driver_dir,['cpp','c'])
            for file_ in driver_files:
                compile_file_dir_, compile_file_ = os.path.split(file_)
                base_name, extension = os.path.splitext(compile_file_)
                cmd = [
                            'aarch64-none-elf-g++',                             #g++ also works
                            '-Wall',
                            '-O2',
                            '-c',
                            '-fmessage-length=0',
                            f'-MT\"{os.path.join(compile_file_dir_,base_name)}.o\"',
                            '-D',
                            '__BAREMETAL__',
                            f'-I{self.full_rfsoc_driver_include_dir}',
                            f'-I{self.full_xilinx_include_dir}',
                            '-MMD',
                            '-MP',
                            f'-MF\"{os.path.join(compile_file_dir_,base_name)}.d\"',
                            f'-MT\"{os.path.join(compile_file_dir_,base_name)}.o\"',
                            '-o',
                            f'\"{os.path.join(compile_file_dir_,base_name)}.o\"',
                            f'\"{file_}\"'
                        ]
                
                driver_list += [f'{os.path.join(compile_file_dir_,base_name)}.o']
                cmd_conc = ''
                for line in cmd:
                    cmd_conc += (line + ' ')
                    
                print(cmd_conc)
                
                process = subprocess.Popen(cmd_conc, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
                stdout, stderr = process.communicate()
                print(stderr)
                self.total_command += cmd_conc + '\n'
                self.total_log += stderr
                
            
            ###############################################################
            ## RFSoC Driver Library
            ###############################################################
            rfsoc_lib_name = 'RFSoC_lib'
            cmd_conc = f'ar rcus {os.path.join(compile_file_dir_,rfsoc_lib_name)}.a '
            for line in driver_list:
                cmd_conc += (line + ' ')
            print(cmd_conc)
            process = subprocess.Popen(cmd_conc, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
            stdout, stderr = process.communicate()
            print(stderr)
            self.total_command += cmd_conc + '\n'
            self.total_log += stderr
                
            ###############################################################
            ## main.cpp
            ###############################################################
            # Define the command to be executed
            cmd = [
                        'aarch64-none-elf-g++',                             #g++ also works
                        '-Wall',
                        '-O2',
                        '-c',
                        '-fmessage-length=0',
                        f'-MT\"../C_Code/{file_name}/{file_name}.o\"',
                        '-D',
                        '__BAREMETAL__',
                        f'-I{self.full_rfsoc_driver_include_dir}',
                        '-I../Xilinx_Include/bspinclude/include',
                        '-MMD',
                        '-MP',
                        f'-MF\"../C_Code/{file_name}/{file_name}.d\"',
                        f'-MT\"../C_Code/{file_name}/{file_name}.o\"',
                        '-o',
                        f'\"../C_Code/{file_name}/{file_name}.o\"'
                    ]
            #aarch64-none-elf-g++ -Wall -O2 -c -fmessage-length=0 -MT"../C_Code/VECTOR_EXP/VECTOR_EXP.o" -D __BAREMETAL__ -IE:/RFSoC/GIT/RFSoC/RFSoC_Design_V1_1/VITIS_CPP/RFSoC_Firmware_plt/export/RFSoC_Firmware_plt/sw/RFSoC_Firmware_plt/standalone_domain/bspinclude/include -MMD -MP -MF"../C_Code/VECTOR_EXP/VECTOR_EXP.d" -MT"../C_Code/VECTOR_EXP/VECTOR_EXP.o" -o "../C_Code/VECTOR_EXP/VECTOR_EXP.o" "../C_Code/VECTOR_EXP/VECTOR_EXP.cpp"
            if self.is_cpp == True:
                cmd += [f'\"../C_Code/{file_name}/{file_name}.cpp\"']
            else:
                cmd += [f'../C_Code/{file_name}/{file_name}.c']
            
            cmd_conc = ''
            for line in cmd:
                cmd_conc += (line + ' ')
                
            print(cmd_conc)
                
            # Execute the command
            process = subprocess.Popen(cmd_conc, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
            stdout, stderr = process.communicate()
            print(stderr)
            self.total_command += cmd_conc + '\n'
            self.total_log += stderr
            
            ###############################################################
            ## startup.S
            ###############################################################
            cmd = [
                        'aarch64-none-elf-g++',                             #g++ also works
                        '-Wall',
                        '-O2',
                        '-c',
                        '-fmessage-length=0',
                        f'-MT\"../C_Code/init/startup.o\"',
                        '-D',
                        '__BAREMETAL__',
                        f'-I{self.full_rfsoc_driver_include_dir}',
                        '-I../Xilinx_Include/bspinclude/include',
                        '-MMD',
                        '-MP',
                        f'-MF\"../C_Code/init/startup.d\"',
                        f'-MT\"../C_Code/init/startup.o\"',
                        '-o',
                        f'\"../C_Code/init/startup.o\"',
                        '\"../C_Code/init/startup.S\"'
                    ]
            #aarch64-none-elf-g++ -Wall -O2 -c -fmessage-length=0 -MT"../C_Code/VECTOR_EXP/VECTOR_EXP.o" -D __BAREMETAL__ -IE:/RFSoC/GIT/RFSoC/RFSoC_Design_V1_1/VITIS_CPP/RFSoC_Firmware_plt/export/RFSoC_Firmware_plt/sw/RFSoC_Firmware_plt/standalone_domain/bspinclude/include -MMD -MP -MF"../C_Code/VECTOR_EXP/VECTOR_EXP.d" -MT"../C_Code/VECTOR_EXP/VECTOR_EXP.o" -o "../C_Code/VECTOR_EXP/VECTOR_EXP.o" "../C_Code/VECTOR_EXP/VECTOR_EXP.cpp"
            cmd_conc = ''
            for line in cmd:
                cmd_conc += (line + ' ')
                
            # Execute the command
            process = subprocess.Popen(cmd_conc, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
            stdout, stderr = process.communicate()
            print(stderr)
            self.total_command += cmd_conc + '\n'
            self.total_log += stderr
            
            ###############################################################
            ## main.elf
            ###############################################################
            cmd = [
                        'aarch64-none-elf-g++',
                        f'-Wl,-T -Wl,../C_Code/linker/linker.ld',
                        f'-L../Xilinx_Include/bsplib/lib',
                        '-o',
                        f'\"../C_Code/{file_name}/{file_name}.elf\"',
                        f'../C_Code/{file_name}/{file_name}.o',
                        f'{self.full_rfsoc_driver_dir}/RFSoC_lib.a',
                        f'../C_Code/init/startup.o',
                        '-Wl,--start-group,-lxil,-lgcc,-lc,-lstdc++,--end-group',
                        '-Wl,--start-group,-lxil,-lmetal,-lgcc,-lc,--end-group',
                        '-Wl,--start-group,-lxil,-llwip4,-lgcc,-lc,--end-group',
                        '-Wl,--start-group,-lxilpm,-lxil,-lgcc,-lc,--end-group',
                        '-Wl,--start-group,-lxil,-lgcc,-lc,-lmetal,--end-group'
                ]
            
            cmd_conc =''
            
            for line in cmd:
                cmd_conc += (line + ' ')
                
            print(cmd_conc)
            process = subprocess.Popen(cmd_conc, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
            stdout, stderr = process.communicate()
            print(stderr)
            self.total_command += cmd_conc + '\n'
            self.total_log += stderr
            
            current_file_dir, dump_ = os.path.split(os.path.realpath(__file__))
            with open(os.path.join(current_file_dir,'LOG.txt'), 'w') as f:
                f.write(self.total_log)
            with open(os.path.join(current_file_dir,'CMD.txt'), 'w') as f:
                f.write(self.total_command)
                
            log_dir = os.path.join(current_file_dir,'LOG.txt')
            
    
            # Check the return code
            if 'error:' in self.total_log:
                raise Exception(f'Compile error. Check {log_dir}')
            else:
                print("Compilation successful.")
            
        else:
            print("No Compile")
    def createTCPpacket(self):
        """
        Create TCP data packet to send to RFSoC
        Args:
            None
        
        Returns:
            list of data which you want to send to RFSoC
        """
        data_packets = []
        
        elf_list = []
        data = "#BIN"
        header_data = ""
        for byte in self.elf_data:
            elf_list.append(hex(byte))
        for i in range(16*4096,len(elf_list)):
            if (len(data) + len(str(elf_list[i]))) > 512:
                data += '#!EOL#'
                data_packets.append(data)
                data = "#BIN"
            data += f'#{str(elf_list[i])}'
        if data != "":
            data += '#!EOL#'
            data_packets.append(data)
        header_data += f'#BIN#save_binary#{hex(self.entry_point)}'
        header_data += f'#{hex(self.stack_start)}'
        header_data += f'#{hex(self.stack_end)}'
        header_data += f'#{hex(self.heap_start)}'
        header_data += f'#{hex(self.heap_end)}'
        header_data += f'#{hex(len(data_packets))}'
        header_data += f'#!EOL#'
        data_packets.insert(0,header_data)
        
        return data_packets
            
if __name__ == "__main__":
    do_compile = True
    
    comp = Compiler()
    file_name = "skeleton_code_1"
    #Compile C Code
    comp.do_compile = do_compile
    comp.compileCode(file_name)
    # comp.compile_ll_file('output')
    
    # Read the ELF file
    elf_data = comp.readELFfile(file_name)
