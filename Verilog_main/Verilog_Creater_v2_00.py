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
    
class IPMaker(TVM):
    def __init__(self, **kwargs):
        super().__init__()
        self.version : str = None
        self.vendor : str = None
        self.config : list = None
        self.name : str = None
        self.instance_name : str = None
        
        for key, value in kwargs.items():
            setattr(self, key, value)
            
    def SetConfig(self):
        for key, value in self.config.items():
            TVM.tcl_code += f' CONFIG.{key} {{{value}}}'
            
class BDCellMaker(TVM):
    def __init__(self, **kwargs):
        super().__init__()
        self.type : str = None
        self.vlnv : str = None
        self.config : list = None
        self.target_path : str = None
        
        for key, value in kwargs.items():
            setattr(self, key, value)
            
    def SetConfig(self):
        for key, value in self.config.items():
            TVM.tcl_code += f' CONFIG.{key} {{{value}}}'
            
class VerilogMaker(TVM):
    def __init__(self, **kwargs):
        super().__init__()
        self.name : str = None
        self.files : list = []
        self.target_path : str = None
        self.ip : list(IPMaker) = []
        
        for key, value in kwargs.items():
            setattr(self, key, value)
        
        self.files = [os.path.join(TVM.common_path,file).replace("\\","/") for file in self.files]
            
    def AddFiles(self, file_path):
        TVM.tcl_code += f'add_files -norecurse {{{file_path}}}\n'
    
    def AddConstraints(self, file_path):
        file_path_ = file_path.replace("\\","/")
        TVM.tcl_code += f'add_files -fileset constrs_1 -norecurse {file_path_}'
    
    def SetPrjName(self, folder_directory,prj_name):
        TVM.tcl_code += f'set project_name \"{prj_name}\"\n' + f'set project_dir \"{folder_directory}\"\n'
    
    def CreatePrj(self, part_name):
        TVM.tcl_code += f'create_project ${{project_name}} ${{project_dir}}/${{project_name}} -part {part_name}\n'
    
    def SetBoard(self, board_path, board_name):
        TVM.tcl_code += f'set boardpath {{{board_path}}}\n' + 'set_param board.repoPaths [list $boardpath]\n' + f'set_property BOARD_PART {board_name} [current_project]\n'
    
    def AddIP(self):
        for ip in self.ip:
            ip.SetConfig()
            
class BDMaker(TVM):
    def __init__(self, **kwargs):
        super().__init__()
        self.name : str = None
        self.files : list = []
        self.ip : list(IPMaker) = []
        
        for key, value in kwargs.items():
            setattr(self, key, value)
        
        self.files = [os.path.join(TVM.common_path,file).replace("\\","/") for file in self.files]
         

def set_global_namespace(json_file):
    with open(json_file, 'r') as file:
        data = json.load(file)
    TVM.SetClassVars(**data)
    
def create_objects_from_json(json_file):
    with open(json_file, 'r') as file:
        data = json.load(file)
    vm = VerilogMaker(**data['verilog'])
    for instance_name, ip_data in data.get('ip', {}).items():
        ip_maker = IPMaker(**ip_data)
        ip_maker.instance_name = instance_name  # Set the name attribute
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
    set_global_namespace('configuraiton.json')
    DAC_Controller = create_objects_from_json('DAC_Controller.json')
    