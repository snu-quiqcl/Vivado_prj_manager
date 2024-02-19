# -*- coding: utf-8 -*-
"""
Created on Sun Feb 18 19:33:29 2024

@author: alexi
"""

import json
import os
import subprocess
import shutil

# This is Verilog Mother
class TVM:
    common_path : str = None
    target_path : str = None
    vivado_path : str = None
    board_path : str = None
    part_name : str = None
    board_name : str = None
    version : str = None
    constraints : str = None
    tcl_code : str = ""
    
    def __init__(self):
        pass
    
    @classmethod
    def SetClassVars(cls, **kwargs):
        for key, value in kwargs.items():
            setattr(cls, key, value)
            
    @classmethod
    def ClearTCLCode(cls):
        cls.tcl_code = ""
    
class IPMaker:
    def __init__(self, **kwargs):
        super().__init__()
        self.version : str = None
        self.vendor : str = None
        self.config : list = None
        self.name : str = None
        self.module_name : str = None
        self.target_path : str = None
        self.tcl_options : list(str) = []
        
        for key, value in kwargs.items():
            setattr(self, key, value)
            
    def SetConfig(self):
        TVM.tcl_code += f'create_ip -dir {self.target_path}'
        for tcl_option in self.tcl_options:
            TVM.tcl_code += f' -{tcl_option} {getattr(self,tcl_option)}'
        TVM.tcl_code += '\n'
        TVM.tcl_code += 'set_property -dict [list'
        for key, value in self.config.items():
            TVM.tcl_code += f' CONFIG.{key} {{{value}}}'
        TVM.tcl_code += f'] [get_ips {self.module_name}]\n'
            
class BDCellMaker:
    def __init__(self, **kwargs):
        super().__init__()
        self.type : str = None
        self.vlnv : str = None
        self.config : list = None
        self.target_path : str = None
        
        for key, value in kwargs.items():
            setattr(self, key, value)
            
class VerilogMaker:
    def __init__(self, **kwargs):
        super().__init__()
        self.name : str = None
        self.files : list = []
        self.ip : list(IPMaker) = []
        self.target_path : str = None
        
        for key, value in kwargs.items():
            setattr(self, key, value)
        
        self.files = [os.path.join(TVM.common_path,file).replace("\\","/") for file in self.files]
        self.target_path = os.path.join(TVM.target_path,self.name).replace("\\","/")
            
    def AddFiles(self):
        for file in self.files:
            TVM.tcl_code += f'add_files -norecurse {{{file}}}\n'
    
    def AddConstraints(self):
        TVM.tcl_code += f'add_files -fileset constrs_1 -norecurse {TVM.constraints}'
    
    def SetPrjName(self):
        TVM.tcl_code += f'set project_name \"{self.name}\"\n' + f'set project_dir \"{self.target_path}\"\n'
    
    def CreatePrj(self):
        TVM.tcl_code += f'create_project ${{project_name}} ${{project_dir}}/${{project_name}} -part {TVM.part_name}\n'
    
    def SetBoard(self):
        TVM.tcl_code += f'set boardpath {{{TVM.board_path}}}\n' +\
            'set_param board.repoPaths [list $boardpath]\n' +\
            f'set_property BOARD_PART {TVM.board_name} [current_project]\n'
    
    def SetTop(self):
        TVM.tcl_code += f'set_property top {self.name} [current_fileset]\n'
        TVM.tcl_code += f'set_property top_file {{ {self.target_path}/{self.top} }} [current_fileset]\n'
        
    def AddIP(self):
        for ip in self.ip:
            ip.SetConfig()
            
    def GenerateCustomizedIp(self):
        TVM.tcl_code += f'ipx::package_project -root_dir {self.target_path}'
        TVM.tcl_code += f' -vendor xilinx.com -library user -taxonomy /UserIP\n'
        TVM.tcl_code += f'ipx::save_core [ipx::current_core]\n'
        TVM.tcl_code += f'set_property  ip_repo_paths  {self.target_path} [current_project]\n'
        TVM.tcl_code += f'update_ip_catalog\n'
            
    def CopyFiles(self):
        ensureDirectoryExists(self.target_path)
        for file in self.files:
            shutil.copy(file,os.path.join(self.target_path,os.path.basename(file)))
        self.files = [os.path.join(self.target_path,os.path.basename(file)) for file in self.files]
            
    def MakeTCL(self):
        self.CopyFiles()
        self.SetPrjName()
        self.CreatePrj()
        self.AddFiles()
        self.SetBoard()
        self.AddIP()
        self.GenerateCustomizedIp()
        self.SetTop()
        with open(os.path.join(self.target_path,self.name+'.tcl'), 'w') as file:
            file.write(TVM.tcl_code)
            
class BDMaker:
    def __init__(self, **kwargs):
        super().__init__()
        self.name : str = None
        self.files : list = []
        self.ip : list(IPMaker) = []
        
        for key, value in kwargs.items():
            setattr(self, key, value)
        
        self.files = [os.path.join(TVM.common_path,file).replace("\\","/") for file in self.files]
         

def SetGlobalNamespace(json_file):
    with open(json_file, 'r') as file:
        data = json.load(file)
    TVM.SetClassVars(**data)
    
def CreateVerilogMaker(json_file):
    with open(json_file, 'r') as file:
        data = json.load(file)
    vm = VerilogMaker(**data['verilog'])
    for module_name, ip_data in data.get('ip', {}).items():
        ip_maker = IPMaker(**ip_data)
        ip_maker.module_name = module_name  # Set the name attribute
        ip_maker.target_path = vm.target_path
        vm.ip.append(ip_maker)
    return vm

def ensureDirectoryExists(directory_path):
    if not os.path.exists(directory_path):
        try:
            os.makedirs(directory_path)
            print(f"Directory {directory_path} created.")
        except OSError as error:
            print(f"Error creating directory {directory_path}: {error}")
    else:
        print(f"Directory {directory_path} already exists.")

# Assuming your JSON file is named 'data.json'
if __name__ == "__main__":
    SetGlobalNamespace('configuraiton.json')
    DAC_Controller = CreateVerilogMaker('DAC_Controller.json')
    DAC_Controller.MakeTCL()
    print(TVM.tcl_code)
    