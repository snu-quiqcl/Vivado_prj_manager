# -*- coding: utf-8 -*-
"""
Created on Sun Feb 18 19:33:29 2024

@author: alexi
"""

import json
import os
import subprocess
import shutil
import argparse

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
    connection_code : str = ""
    
    CPU : str = ""
    axi_interconnect : str = ""
    axi_number : int = 0
    axi_offset : int = 0
    address_code : str = ""
    total_axi_number : int = 0
    
    def __init__(self):
        pass
    
    @classmethod
    def SetClassVars(cls, **kwargs):
        for key, value in kwargs.items():
            setattr(cls, key, value)
            
    @classmethod
    def ClearTCLCode(cls):
        cls.tcl_code = ""
        
    def AddFiles(self) -> None:
        for file in self.files:
            TVM.tcl_code += f'add_files -norecurse {{{file}}}\n'
    
    def AddConstraints(self) -> None:
        TVM.tcl_code += f'add_files -fileset constrs_1 -norecurse {TVM.constraints}\n'
    
    def CreatePrj(self) -> None:
        TVM.tcl_code += f'create_project ${{project_name}} ${{project_dir}}/${{project_name}} -part {TVM.part_name}\n'
    
    def SetBoard(self) -> None:
        TVM.tcl_code += f'set boardpath {{{TVM.board_path}}}\n' +\
            'set_param board.repoPaths [list $boardpath]\n' +\
            f'set_property BOARD_PART {TVM.board_name} [current_project]\n'
    
class IPMaker:
    def __init__(self, **kwargs):
        super().__init__()
        self.version : str = None
        self.vendor : str = None
        self.config : dict() = None
        self.name : str = None
        self.module_name : str = None
        self.target_path : str = None
        self.tcl_options : list(str) = []
        
        for key, value in kwargs.items():
            setattr(self, key, value)
            
    def SetConfig(self) -> None:
        TVM.tcl_code += f'create_ip -dir {self.target_path}'
        for tcl_option in self.tcl_options:
            TVM.tcl_code += f' -{tcl_option} {getattr(self,tcl_option)}'
        TVM.tcl_code += '\n'
        TVM.tcl_code += "set_property -dict [list " + " ".join([f"CONFIG.{key} {{{value}}}" 
                        for key, value in self.config.items()]) + "]" if self.config else ""
        if self.config:
            TVM.tcl_code += f' [get_ips {self.module_name}]\n'
            
class BDCellMaker:
    def __init__(self, **kwargs):
        super().__init__()
        self.type : str = None
        self.vlnv : str = None
        self.config : dict() = {}
        self.ports : dict() = {}
        self.interface : dict() = {}
        self.module_name : str = None
        
        for key, value in kwargs.items():
            setattr(self, key, value)
            
    def SetConfig(self) -> None:
        TVM.tcl_code += f'set {self.module_name} [ create_bd_cell'
        for tcl_option in self.tcl_options:
            TVM.tcl_code += f' -{tcl_option} {getattr(self,tcl_option)}'
        TVM.tcl_code += f' {self.module_name} ]'
        TVM.tcl_code += '\n'
        TVM.tcl_code += "set_property -dict [list " + " ".join([f"CONFIG.{key} {{{value}}}" 
                        for key, value in self.config.items()]) + "]" if self.config else ""
        reg = 'reg0' if 'xilinx.com:user' in self.vlnv else 'Reg'
        if 'xilinx.com:user' in self.vlnv and self.config:
            TVM.tcl_code += f' [get_bd_cells {self.module_name}]\n'
        elif self.config:
            TVM.tcl_code += f' ${self.module_name}\n'
        for victim, target in self.ports.items():
            TVM.connection_code += f'connect_bd_net -net {self.module_name}_{victim} [get_bd_ports {target}] [get_bd_pins {self.module_name}/{victim}]\n'
        for victim, target in self.interface.items():
            TVM.connection_code += f'connect_bd_intf_net -intf_net {self.module_name}_{victim} [get_bd_intf_pins {target}] [get_bd_intf_pins {self.module_name}/{victim}]\n'
        if hasattr(self,'axi'):
            range_ = int(self.axi.get('range'),16)
            TVM.connection_code += f'connect_bd_intf_net -intf_net {TVM.axi_interconnect}_M{str(TVM.axi_number).zfill(2)}_AXI [get_bd_intf_pins {self.module_name}/s_axi]'
            TVM.connection_code += f' [get_bd_intf_pins {TVM.axi_interconnect}/M{str(TVM.axi_number).zfill(2)}_AXI]\n'
            if 'offset' in self.axi:
                offset = self.axi.get('offset')
                TVM.address_code += f'assign_bd_address -offset {offset} -range {hex(range_).upper()} -target_address_space [get_bd_addr_spaces {TVM.CPU}/Data] [get_bd_addr_segs {self.module_name}/s_axi/{reg}] -force\n'
            else:
                TVM.address_code += f'assign_bd_address -offset {hex(TVM.axi_offset).upper()} -range {hex(range_).upper()} -target_address_space [get_bd_addr_spaces {TVM.CPU}/Data] [get_bd_addr_segs {self.module_name}/s_axi/{reg}] -force\n'
                TVM.axi_offset += range_
            TVM.axi_number += 1
            
class VerilogMaker(TVM):
    def __init__(self, **kwargs):
        super().__init__()
        self.name : str = None
        self.files : list = []
        self.ip : list(IPMaker) = []
        self.target_path : str = None
        self.tcl_path : str = None
        
        for key, value in kwargs.items():
            setattr(self, key, value)
        
        self.files = [os.path.join(TVM.common_path,file).replace("\\","/") for file in self.files]
        self.target_path = os.path.join(TVM.target_path,self.name).replace("\\","/")
        self.tcl_path = os.path.join(self.target_path,self.name+'.tcl')
        
    def SetTop(self) -> None:
        TVM.tcl_code += f'set_property top {self.name} [current_fileset]\n'
        TVM.tcl_code += f'set_property top_file {{ {self.target_path}/{self.top} }} [current_fileset]\n'
        
    def AddIP(self) -> None:
        for ip in self.ip:
            ip.SetConfig()
            
    def GenerateCustomizedIp(self) -> None:
        TVM.tcl_code += f'ipx::package_project -root_dir {self.target_path}'
        TVM.tcl_code += ' -vendor xilinx.com -library user -taxonomy /UserIP\n'
        TVM.tcl_code += 'ipx::save_core [ipx::current_core]\n'
        TVM.tcl_code += f'set_property  ip_repo_paths  {self.target_path} [current_project]\n'
        TVM.tcl_code += 'update_ip_catalog\n'
            
    def CopyFiles(self) -> None:
        EnsureDirectoryExists(self.target_path)
        for file in self.files:
            shutil.copy(file,os.path.join(self.target_path,os.path.basename(file)))
        self.files = [os.path.join(self.target_path,os.path.basename(file)).replace("\\","/") for file in self.files]
    
    def SetPrjName(self) -> None:
        TVM.tcl_code += f'set project_name \"{self.name}\"\n' + f'set project_dir \"{self.target_path}\"\n'
        
    def MakeTCL(self) -> None:
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
        RunVivadoTCL(self.tcl_path)
        TVM.ClearTCLCode()
        DeleteDump()
        
def SetGlobalNamespace(json_file) -> None:
    with open(json_file, 'r') as file:
        data = json.load(file)
    TVM.SetClassVars(**data)
    
def CreateVerilogMaker(json_file) -> VerilogMaker:
    with open(json_file, 'r') as file:
        data = json.load(file)
    vm = VerilogMaker(**data['verilog'])
    for module_name, ip_data in data.get('ip', {}).items():
        ip_maker = IPMaker(**ip_data)
        ip_maker.module_name = module_name  # Set the name attribute
        ip_maker.target_path = vm.target_path
        vm.ip.append(ip_maker)
    return vm

def EnsureDirectoryExists(directory_path) -> None:
    if not os.path.exists(directory_path):
        try:
            os.makedirs(directory_path)
            print(f"Directory {directory_path} created.")
        except OSError as error:
            print(f"Error creating directory {directory_path}: {error}")
    else:
        print(f"Directory {directory_path} already exists.")

def RunVivadoTCL(tcl_path) -> None:
    process = subprocess.Popen([TVM.vivado_path, "-mode", "batch", "-source", tcl_path],
                               stdout=subprocess.PIPE, stderr=subprocess.STDOUT, universal_newlines=True, text=True)
    while process.poll() == None:
        out = process.stdout.readline()
        print(out, end='')
    stdout, stderr = process.communicate()
    print(stderr if stderr else 'Vivado ended with no error')

def DeleteDump() -> None:
    if os.path.exists(os.path.join(os.path.dirname(__file__),'vivado.jou')):
        os.remove(os.path.join(os.path.dirname(__file__),'vivado.jou'))
        print('vivado.jou is deletd')
    if os.path.exists(os.path.join(os.path.dirname(__file__),'vivado.log')):
        os.remove(os.path.join(os.path.dirname(__file__),'vivado.log'))
        print('vivado.log is deletd')
def main(args : argparse.Namespace) -> None:
    # Use provided values or defaults
    configuration = args.config if args.config else 'configuration.json'
    verilog_json = args.verilog_json if args.verilog_json else 'verilog_json.json'

    SetGlobalNamespace(configuration)
    vm = CreateVerilogMaker(verilog_json)
    vm.MakeTCL()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Make SoC Block diagram with\
                                     json files. You need configuration file which\
                                     set directory of vivado and common directory path\
                                     and json files which specifies the SoC design")
    parser.add_argument("-v", "--verbose", action="store_true", help="Increase output verbosity")
    parser.add_argument("-c", "--config", help="Configuration file name")
    parser.add_argument("-f", "--verilog_json", help="verilog JSON file name")
    args = parser.parse_args()
    main(args)
    
    