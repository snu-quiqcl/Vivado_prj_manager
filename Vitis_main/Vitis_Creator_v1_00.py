# -*- coding: utf-8 -*-
"""
Created on Tue Sep 26 19:40:08 2023

@author: QC109_4
"""
import os
import re
import subprocess

class Vitis_maker:
    def __init__(self):
        print('make vitis project...')
        self.vitis_dir = r'E:\Xilinx\Vitis\2020.2\bin\xsct.bat'
        self.git_dir = r'E:\RFSoC\GIT'
        self.tcl_commands = ''
        self.xsa_dir = os.path.join(self.git_dir,'Vivado_prj_manager','Vitis_main','RFSoC_Main_blk_wrapper.xsa')
        self.lang = 'C'
        
        if self.lang == 'C++': # LWIP -> need extern "C"...
            self.firmware_dir = os.path.join(self.git_dir,'Vivado_prj_manager','Vitis_main','RFSoC_Firmware_CPP')
            self.target_dir = os.path.join(self.git_dir,'RFSoC','RFSoC_Design_V1_1','VITIS_CPP')
        else:
            self.firmware_dir = os.path.join(self.git_dir,'Vivado_prj_manager','Vitis_main','RFSoC_Firmware')
            self.target_dir = os.path.join(self.git_dir,'RFSoC','RFSoC_Design_V1_1','VITIS')
            
        self.C_file_dir = os.path.join(self.target_dir,'RFSoC_Firmware_app','src')
        self.ensure_directory_exists(self.C_file_dir)
        # self.copy_C_files()
    
    def ensure_directory_exists(self, directory_dir):
        if not os.path.exists(directory_dir):
            try:
                os.makedirs(directory_dir)
                print(f"Directory {directory_dir} created.")
            except OSError as error:
                print(f"Error creating directory {directory_dir}: {error}")
        else:
            print(f"Directory {directory_dir} already exists.")
            
    def copy_C_files(self):
        for filename in os.listdir(self.firmware_dir):
            source_dir = os.path.join(self.firmware_dir, filename)
            file_root, file_extension = os.path.splitext(filename)
            new_filename = file_root + file_extension
            destination_dir = os.path.join(self.C_file_dir, new_filename)
            
            C_code = ''
            with open(source_dir, 'r') as source_file:
                C_code = source_file.read()
            
            with open(destination_dir, 'w') as destination_file:
                destination_file.write(C_code)
        
    def run_vitis_tcl(self):
        file_dir = f'{self.target_dir}/make_project.tcl'
        self.tcl_commands = self.tcl_commands.replace('\\','/')
        with open(file_dir, 'w') as tcl_file:
            tcl_file.write(self.tcl_commands)
        # Start Vitis in batch mode and pass the TCL commands as input
        process = subprocess.Popen([self.vitis_dir, file_dir],
                                   stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, cwd=self.target_dir)
    
        # Wait for the process to complete
        stdout, stderr = process.communicate()
    
        # Print the output and error messages
        print(stdout)
        print(stderr)
        
    def make_vitis_platform(self):
        self.tcl_commands += f"""
platform create -name "RFSoC_Firmware_plt" -hw "{self.xsa_dir}" -proc psu_cortexa53_0 -os standalone -arch 64-bit -fsbl-target psu_cortexa53_0
platform read {os.path.join(self.target_dir,'RFSoC_Firmware_plt','platform.spr')}
platform active {{RFSoC_Firmware_plt}}
domain active standalone_domain

platform write
platform generate -domains 
platform active RFSoC_Firmware_plt
domain active standalone_domain
bsp reload
bsp setlib -name libmetal -ver 2.1
bsp setlib -name lwip211 -ver 1.3
bsp setlib -name xilpm -ver 3.2
bsp config compiler "aarch64-none-elf-gcc"
bsp write
bsp reload
catch {{bsp regenerate}}
platform generate
platform active RFSoC_Firmware_plt
platform generate -domains
        """
        # domain create -name a53_Standalone -os standalone -proc psu_cortexa53_0
        # platform generate -domains a53_standalone
        
        self.tcl_commands += '\n'
        
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
    
    def make_vitis_application(self):
        if self.lang == 'C++':
            self.tcl_commands += f"""
app create -name RFSoC_Firmware_app -platform RFSoC_Firmware_plt -proc psu_cortexa53_0 -os standalone -lang C++ -template {{Empty Application (C++)}} -domain standalone_domain
importsources -name RFSoC_Firmware_app -path "{self.firmware_dir}" -soft-link
            """
        else:
            self.tcl_commands += f"""
app create -name RFSoC_Firmware_app -platform RFSoC_Firmware_plt -proc psu_cortexa53_0 -os standalone -lang C -template {{Empty Application}} -domain standalone_domain
importsources -name RFSoC_Firmware_app -path "{self.firmware_dir}" -soft-link
            """
        
        self.tcl_commands += '\n'
        
    def set_workspace(self):
        self.tcl_commands += f'setws \"{self.target_dir}\"'
        self.tcl_commands += '\n'

            
if __name__ == "__main__":
    vtm = Vitis_maker()
    vtm.set_workspace()
    vtm.make_vitis_platform()
    vtm.make_vitis_application()
    vtm.run_vitis_tcl()