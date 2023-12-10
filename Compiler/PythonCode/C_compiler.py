# -*- coding: utf-8 -*-
"""
Created on Tue Aug  1 23:27:53 2023

@author: QC109_4
aarch64-none-elf-gcc -march=armv8-a -mcpu=cortex-a53 -nostartfiles -T../MALLOC_EXP.ld -I../include mallocr.c ../_sbrk.c ../close.c ../write.c ../lseek.c ../read.c ../inbyte.c ../lib/libxil.a -o mallocr.o
aarch64-none-elf-gcc -march=armv8-a -mcpu=cortex-a53 -nostartfiles -T../MALLOC_EXP.ld -I../include ../init/start_custom.S mallocr.c ../_sbrk.c ../close.c ../write.c ../lseek.c ../read.c ../inbyte.c ../lib/libxil.a -o mallocr.o
-> this works -> dependency problem...
"""
import subprocess
import os
from elftools.elf.elffile import ELFFile #pip install pyelftools
from capstone import * #pip install capstone

class Compiler:
    def __init__(self):
        print('compiler')
        self.elf_data = None
        self.do_compile = False
        self.entry_point = 0x00
        self.stack_start = 0x00
        self.stack_end = 0x00
        self.heap_start = 0x00
        self.heap_end = 0x00
        self.elf_data = None
        self.use_make = False
        self.is_cpp = True
        self.total_command = ''
        self.total_log = ''
        
        # self.git_dir = r'C:\Jeonghyun\GIT'
        self.git_dir = r'C:\Jeonghyun\GIT'
        self.xilinx_include_dir = r'Vivado_prj_manager\Compiler\Xilinx_Include\bspinclude\include'
        self.rfsoc_driver_dir = r'Vivado_prj_manager\Compiler\C_Code\RFSoC_Driver'
        self.rfsoc_driver_include_dir = r'Vivado_prj_manager\Compiler\C_Code\RFSoC_Driver_Include'
        
        self.full_rfsoc_driver_dir = os.path.join(self.git_dir,self.rfsoc_driver_dir)
        self.full_rfsoc_driver_include_dir = os.path.join(self.git_dir,self.rfsoc_driver_include_dir)
        self.full_xilinx_include_dir = os.path.join(self.git_dir, self.xilinx_include_dir)
    
    def get_all_files_in_directory(self, directory,file_type):
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
        
    def read_elf_file(self, file_name):
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

            # Iterate over the sections and print information about each section
            # print("\nSections:")
            # for section in elf_file.iter_sections():
            #     print(f"  {section.name} (type: {section['sh_type']}, size: {section['sh_size']})")
            
            self.entry_point = elf_file.header.e_entry
            
            # output_file = "../C_Code/ELF_BIN.txt"
            # with open(output_file, 'w') as output_f:
            #     output_f.write("Contents of ELF file:\n")
            #     hex_dump = [" ".join(f"{b:02X}" for b in self.elf_data[i:i+16]) for i in range(0, len(self.elf_data), 16)]
            #     for line in hex_dump:
            #         output_f.write(line + "\n")
            
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
                            

            # # You can also access the symbol table and print information about symbols
            # if '.symtab' in elf_file:
            #     print("\nSymbol table:")
            #     for symbol in elf_file.get_section_by_name('.symtab').iter_symbols():
            #         print(f"  {symbol.name} (value: 0x{symbol['st_value']:x}, size: {symbol['st_size']})")
            
            
        return self.elf_data
    
    def create_c_code_array(self, data):
        c_code_array = []
        for byte in data:
            c_code_array.append(hex(byte))
    
        # Group the bytes into 16 bytes per line for better readability
        c_code_lines = [', '.join(c_code_array[i:i+16]) for i in range(16*4096, len(c_code_array), 16)]
        
        # Join the lines with newlines and add C code array syntax
        c_code = "const unsigned char elf_data[] = {\n"
        c_code += ",\n".join(c_code_lines)
        c_code += "\n};\n"
        
        return c_code
    
    def save_c_code_to_file(self, c_code, file_name):
        output_filename = f'../C_Code/{file_name}/' + file_name + '_array.txt'
        with open(output_filename, 'w') as f:
            f.write(c_code)
            
    def compile_ll_file(self,file_name):
        cmd_conc = ''
        filename, file_extension = os.path.splitext(file_name)
        cmd = [
                'clang',
                '--target=aarch64',
                '-mcpu=cortex-a53',
                '-c',
                '-Wall',
                '-O2',
                f'{filename}.ll',
                '-o',
                f'\"../C_Code/{filename}/{filename}.o\"'
            ]
        for line in cmd:
            cmd_conc += (line + ' ')
            
        print(cmd_conc)
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
            
    def compile_code(self, file_name):
        if self.do_compile == True:
            driver_list = []
            if self.use_make == False:
                ###############################################################
                ## RFSoC Driver
                ###############################################################
                driver_files = self.get_all_files_in_directory(self.full_rfsoc_driver_dir,['cpp','c'])
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
            else: # this is old version... code revision is required
                Makefile_code = f"""
# Define the compiler and compiler flags
CC = aarch64-none-elf-gcc
CFLAGS = -march=armv8-a -mcpu=cortex-a53 -nostartfiles -I ../include

# Define the linker and linker flags
LD = aarch64-none-elf-gcc
LDFLAGS = -march=armv8-a -mcpu=cortex-a53 -nostartfiles -T {file_name}.ld  -I ../include
ADD_LIB =../lib/libxil.a

# List all source files (cpp files) in the current folder
SRCS := $(wildcard *.c *.cpp)

# List all assembly files in the current folder
ASMS := ../init/startup.S

# List all object files corresponding to the source files
OBJS = $(SRCS:.c=.o) $(ASMS:.S=.o)

# Define the final target executable
TARGET = {file_name}.elf

# Default rule: build the executable
all: $(TARGET)

# Rule to compile each source file into object files
%.o: %.cpp
	$(CC) $(CFLAGS) -c $< $(ADD_LIB) -o $@

# Rule to compile each source file into object files2
%.o: %.c
	$(CC) $(CFLAGS) -c $< $(ADD_LIB) -o $@

# Rule to assemble each assembly source file into object files
%.o: %.S
	$(CC) $(CFLAGS) -c $< -o $@

# Rule to build the target executable
$(TARGET): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $^ $(ADD_LIB)

# Clean rule: remove generated files
clean:
	del {file_name}.elf
	del $(OBJS)
	del $(TARGET)

#print all dirs
get-dir:
	$(ALL_DIRS)
                """
                current_directory = os.getcwd()
                  
                # Construct the desired directory path relative to the current directory
                directory_path = os.path.join(current_directory, "..", "C_Code", file_name)
                
                # Normalize the path (resolve "..", "." etc.)
                directory_path = os.path.normpath(directory_path)
                  
                # Check if the directory exists
                if not os.path.exists(directory_path):
                    # If not, create the directory
                    os.makedirs(directory_path)
                  
                # Change the current working directory
                os.chdir(directory_path)
                with open('Makefile', 'w') as f:
                    f.write(Makefile_code)
                cmd = [
                'make'
                ]
                process = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
                stdout, stderr = process.communicate()
                if stderr:
                    print("Error Code")
                    raise Exception(stderr)
                else:
                    print("Compilation successful.")
        else:
            print("No Compile")
    def create_TCP_packet(self):
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
    file_name = "skeleton_code"
    #Compile C Code
    comp.do_compile = do_compile
    # comp.compile_code(file_name)
    comp.compile_ll_file('output')
    
    # Read the ELF file
    elf_data = comp.read_elf_file(file_name)

    # Convert to C code array representation
    c_code = comp.create_c_code_array(elf_data)

    # Save the C code to a file
    comp.save_c_code_to_file(c_code, file_name)
