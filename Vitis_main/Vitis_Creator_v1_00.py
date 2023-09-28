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
        self.vitis_path = r'E:\Xilinx\Vitis\2020.2\bin\xsct.bat'
        self.tcl_commands = ''
        self.xsa_path = 'E:/RFSoC/GIT/Vivado_prj_manager/Vitis_main/RFSoC_Main_blk_wrapper.xsa'
        self.target_path = r'E:/RFSoC/GIT/RFSoC/RFSoC_Design_V1_1/VITIS'
        self.firmware_path = r'E:\RFSoC\GIT\Vivado_prj_manager\Vitis_main\RFSoC_Firmware'
        
    def run_vitis_tcl(self):
        file_path = f'{self.target_path}/make_project.tcl'
        self.tcl_commands = self.tcl_commands.replace('\\','/')
        with open(file_path, 'w') as tcl_file:
            tcl_file.write(self.tcl_commands)
        # Start Vitis in batch mode and pass the TCL commands as input
        process = subprocess.Popen([self.vitis_path, file_path],
                                   stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, cwd=self.target_path)
    
        # Wait for the process to complete
        stdout, stderr = process.communicate()
    
        # Print the output and error messages
        print(stdout)
        print(stderr)
        
    def make_vitis_platform(self):
        self.tcl_commands += f"""
platform create -name "RFSoC_Firmware_plt" -hw "{self.xsa_path}" -proc psu_cortexa53_0 -os standalone -arch 64-bit -fsbl-target psu_cortexa53_0

platform write
platform generate -domains 
platform active RFSoC_Firmware_plt
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
        
    def make_vitis_application(self):
        self.tcl_commands += f"""
app create -name RFSoC_Firmware_app -platform RFSoC_Firmware_plt -proc psu_cortexa53_0 -os standalone -lang C -template {{Empty Application}}
importsources -name RFSoC_Firmware_app -path "{self.firmware_path}" -soft-link
        """
        
    def set_workspace(self):
        self.tcl_commands += f'setws \"{self.target_path}\"'

            
if __name__ == "__main__":
    vtm = Vitis_maker()
    vtm.set_workspace()
    vtm.make_vitis_platform()
    vtm.make_vitis_application()
    vtm.run_vitis_tcl()