# -*- coding: utf-8 -*-
"""
Created on Mon Feb 19 19:15:25 2024

@author: alexi
"""
import re
import argparse
from Verilog_Creator_v2_00 import *

POSSIBLE_FIFO_DEPTH = [512, 1024, 2048, 4096, 8192, 16384, 32768, 65536, 131072]

class RFSoCMaker(TVM):
    def __init__(self, **kwargs):
        super().__init__()
        self.project_name : str = None
        self.DAC_Controller_fifo_depth : str = None
        self.TTL_out_fifo_depth : str = None
        self.TTLx8_out_fifo_depth : str = None
        self.EdgeCounter_fifo_depth : str = None
        self.json_path : list[str] = None
        self.bd_cell : list[BDCellMaker] = []
        self.verilog_maker : list[VerilogMaker] = []
        self.file : list[str] = []
        
        self.axi_offset : str = None
        self.axi_interconnect : str = ""
        self.total_axi_number : int = 0
        self.input_ports : list[str] = []
        self.output_ports : list[str] = []
        self.clk : dict[str : dict[str : str]] = {}
        self.CPU : str = ""
        self.reset : str = ""
        
        self.timecontroller : str = ""
        self.rfdc : str = ""
        
        for key, value in kwargs.items():
            setattr(self, key, value)
            
        for json_file in self.json_path:
            vm = CreateVerilogMaker(json_file)
            self.verilog_maker.append(vm)
            self.file.append(vm.target_path)
            
        self.target_path = os.path.join(TVM.target_path,self.project_name).replace("\\","/")
        self.tcl_path = os.path.join(self.target_path,self.project_name+'.tcl')
        self.SetPossibleFifoDepth()
        EnsureDirectoryExists(self.target_path)
        TVM.axi_offset = int(self.axi_offset,16)
    
    def OverrideParameter(self) -> None:
        for v in self.verilog_maker:
            for ip in v.ip:
                if ip.name == 'fifo_generator':
                    fifo_depth = getattr(self,v.name + '_fifo_depth')
                    ip.config['Input_Depth'] = fifo_depth
                    ip.config['Output_Depth'] = fifo_depth
                    ip.config['Full_Threshold_Assert_Value'] = str(int(fifo_depth)-8)
                    ip.config['Full_Threshold_Negate_Value'] = str(int(fifo_depth)-8)
            v.MakeTCL()
            
        for bd_cell in self.bd_cell:
            if bd_cell.module_name == self.axi_interconnect:
                bd_cell.config['NUM_MI'] = self.total_axi_number
        TVM.CPU = self.CPU
        TVM.axi_interconnect = self.axi_interconnect
        TVM.total_axi_number = self.total_axi_number
    
    def SetPossibleFifoDepth(self) -> None:
        pattern = r'\b\w+_fifo_depth\b'
        attributes = dir(self)
        fifo_depths = [attr for attr in attributes if re.search(pattern, attr)]
        for fifo_depth in fifo_depths:
            fifo_depth_value = int(getattr(self,fifo_depth))
            i = 0
            while POSSIBLE_FIFO_DEPTH[i] < fifo_depth_value:
                i += 1
                if i >= len(POSSIBLE_FIFO_DEPTH):
                    raise Exception('rtob fifo depth is too big')
                setattr(self,fifo_depth,str(POSSIBLE_FIFO_DEPTH[i]))
    
    def MakeOutputPorts(self) -> None:
        for port in self.output_ports:
            TVM.tcl_code += f'set {port} [ create_bd_port -dir O {port} ]\n'
            
    def MakeInputPorts(self):
        for port in self.input_ports:
            TVM.tcl_code += f'set {port} [ create_bd_port -dir I {port} ]\n'
            
    def MakeClkPorts(self):
        for port, option in self.clk.items():
            TVM.tcl_code += f'set {port} [ create_bd_port '
            for key, val in option.items():
                TVM.tcl_code += f'-{key} {val} '
            TVM.tcl_code += f' {port} ]\n'
    
    def SetPrjName(self) -> None:
        TVM.tcl_code += f'set project_name \"{self.project_name}\"\n' + f'set project_dir \"{self.target_path}\"\n'
    
    def SetIPRepo(self) -> None:
        TVM.tcl_code += 'set_property  ip_repo_paths {' + ' '.join([f'{file}' 
                        for file in self.file]) + ' } [current_project]\nupdate_ip_catalog\n' if self.file else ''

    def SetBlockDiagram(self) -> None:
        TVM.tcl_code += f'create_bd_design \"{self.project_name}_blk\"\n'
        TVM.tcl_code += f'current_bd_design \"{self.project_name}_blk\"\n'
        TVM.tcl_code += 'set parentObj [get_bd_cells /]\n'
        TVM.tcl_code += 'set parentObj [get_bd_cells \"\"]\n'
        TVM.tcl_code += 'set parentType [get_property TYPE $parentObj]\n'
        TVM.tcl_code += 'current_bd_instance $parentObj\n'
        
    def ConnectPorts(self) -> None:
        TVM.tcl_code += TVM.connection_code
    
    def SetAddress(self) -> None:
        TVM.tcl_code += TVM.address_code
    
    def ConnectAXIinterface(self) -> None:
        TVM.tcl_code += f'connect_bd_net -net {self.reset}_peripheral_aresetn'\
                        +f' [get_bd_pins {self.reset}/peripheral_aresetn]'\
                        +''.join([f' [get_bd_pins {bd_cell}/s_axi_aresetn]' 
                        if hasattr(bd_cell,'axi') else '' for bd_cell 
                        in self.bd_cell]) + ''
        TVM.tcl_code += f''
        TVM.tcl_code += '\n'
        TVM.tcl_code += f'connect_bd_net -net {self.CPU}_s_axi_aclk'\
                        +f' [get_bd_pins {self.CPU}/maxihpm0_fpd_aclk]'\
                        +f' [get_bd_pins {self.CPU}/pl_clk0]'\
                        +''.join([f' [get_bd_pins {bd_cell}/s_axi_aclk]' 
                        if hasattr(bd_cell,'axi') else '' for bd_cell 
                        in self.bd_cell]) + ''
        TVM.tcl_code += ''.join([f' [get_bd_pins {self.axi_interconnect}/M{str(i).zfill(len(str(TVM.total_axi_number)))}_ACLK]' 
                        for i in range(self.total_axi_number)])
        TVM.tcl_code += f' [get_bd_pins {self.rfdc}/s0_axis_aclk] [get_bd_pins {self.rfdc}/s1_axis_aclk]'
        TVM.tcl_code += '\n'
    
    def ConnectRTIOinterface(self) -> None:
        TVM.tcl_code += f'connect_bd_net -net {self.timecontroller}_auto_start'\
                         + ''.join([f' [get_bd_pins {bd_cell.module_name}/auto_start]' 
                        if 'xilinx.com:user' in bd_cell.vlnv else '' for bd_cell 
                        in self.bd_cell]) + '\n' if self.bd_cell else ''
        TVM.tcl_code += f'connect_bd_net -net {self.timecontroller}_counter'\
                         + ''.join([f' [get_bd_pins {bd_cell.module_name}/counter]' 
                        if 'xilinx.com:user' in bd_cell.vlnv else '' for bd_cell 
                        in self.bd_cell]) + '\n' if self.bd_cell else ''
    
    def StartGUI(self) -> None:
        TVM.tcl_code += 'start_gui\n'
    
    def MakeTCL(self) -> None:
        self.SetPrjName()
        self.CreatePrj()
        self.AddConstraints()
        self.SetBoard()
        self.SetIPRepo()
        self.SetBlockDiagram()
        self.MakeOutputPorts()
        self.MakeInputPorts()
        self.MakeClkPorts()
        for bd_cell in self.bd_cell:
            bd_cell.SetConfig()
        self.ConnectPorts()
        self.ConnectAXIinterface()
        self.ConnectRTIOinterface()
        self.SetAddress()
        self.StartGUI()
        with open(os.path.join(self.target_path,self.project_name+'.tcl'), 'w') as file:
            file.write(TVM.tcl_code)
        RunVivadoTCL(self.tcl_path)
        TVM.ClearTCLCode()
        DeleteDump()
    
def CreateRFSoCMaker(json_file) -> RFSoCMaker:
    with open(json_file, 'r') as file:
        data = json.load(file)
    rm = RFSoCMaker(**data['block_diagram'])
    for module_name, ip_data in data.get('bd_cell', {}).items():
        bd_cell_maker = BDCellMaker(**ip_data)
        bd_cell_maker.module_name = module_name  # Set the name attribute
        rm.bd_cell.append(bd_cell_maker)
        if hasattr(bd_cell_maker, "axi"):
            rm.total_axi_number += 1
        if hasattr(bd_cell_maker,'vlnv'):
            if 'xilinx.com:ip:zynq_ultra_ps_e' in getattr(bd_cell_maker,'vlnv'):
                setattr(rm,'CPU',bd_cell_maker.module_name)
            if 'xilinx.com:user:TimeController' in getattr(bd_cell_maker,'vlnv'):
                setattr(rm,'timecontroller',bd_cell_maker.module_name)
            if 'xilinx.com:ip:axi_interconnect' in getattr(bd_cell_maker,'vlnv'):
                setattr(rm,'axi_interconnect',bd_cell_maker.module_name)
            if 'xilinx.com:ip:proc_sys_reset' in getattr(bd_cell_maker,'vlnv'):
                setattr(rm,'reset',bd_cell_maker.module_name)
            if 'xilinx.com:ip:usp_rf_data_converter' in getattr(bd_cell_maker,'vlnv'):
                setattr(rm,'rfdc',bd_cell_maker.module_name)
    rm.OverrideParameter()
    return rm

def main(args):
    # Use provided values or defaults
    configuration = args.config if args.config else 'configuraiton.json'
    soc_json = args.soc_json if args.soc_json else 'RFSoC.json'

    SetGlobalNamespace(configuration)
    RFSoC_Maker = CreateRFSoCMaker(soc_json)
    RFSoC_Maker.MakeTCL()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Make SoC Block diagram with\
                                     json files. You need configuration file which\
                                     set directory of vivado and common directory path\
                                     and json files which specifies the SoC design")
    parser.add_argument("-v", "--verbose", action="store_true", help="Increase output verbosity")
    parser.add_argument("-c", "--config", help="Configuration file name")
    parser.add_argument("-f", "--soc_json", help="SoC JSON file name")
    args = parser.parse_args()
    main(args)