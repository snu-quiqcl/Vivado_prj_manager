# -*- coding: utf-8 -*-
"""
Created on Fri Jul 21 12:43:14 2023

@author: QC109_4, GPT
"""
import subprocess
import os

class TCL_maker:
    def __init__(self):
        self.total_dds_num = 0
        self.total_fifo_num = 0
        self.total_rfdc_num= 0
        self.vivado_executable = ''
        self.tcl_commands = ''

    def run_vivado_tcl(self, vivado_bat):
        self.vivado_executable = vivado_bat# Replace with the actual path to vivado.bat
    
        # Start Vivado in batch mode and pass the TCL commands as input
        process = subprocess.Popen([self.vivado_executable, "-mode", "batch", "-source", self.tcl_commands],
                                   stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    
        # Wait for the process to complete
        stdout, stderr = process.communicate()
    
        # Print the output and error messages
        print(stdout)
        print(stderr)
    
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
    
    # Function to generate the "add_files" string for a given file
    def generate_add_files_string(self, file_path):
        return f'add_files -norecurse {{{file_path}}}\n'
    
    def generate_set_prj_string(self, folder_directory,prj_name):
        return f'set project_name \"{prj_name}\"\n' + f'set project_dir \"{folder_directory}\"\n'
    
    def generate_create_prj_string(self, part_name):
        return f'create_project ${{project_name}} ${{project_dir}}/${{project_name}} -part {part_name}\n'
    
    def generate_set_board(self, board_path, board_name):
        return f'set boardpath {{{board_path}}}\n' + 'set_param board.repoPaths [list $boardpath]\n' + f'set_property BOARD_PART {board_name} [current_project]\n'
    
    def generate_xilinx_dds_ip(self, folder_directory):
        tcl_code = ''
        tcl_code += f'create_ip -dir {folder_directory} -name dds_compiler -vendor xilinx.com -library ip -version 6.0 -module_name dds_compiler_{self.total_dds_num}\n'
        #one line command
        tcl_code += f'set_property -dict [list CONFIG.PartsPresent {{SIN_COS_LUT_only}}'
        tcl_code += f' CONFIG.Spurious_Free_Dynamic_Range {{90}} CONFIG.Frequency_Resolution {{0.01}}'
        tcl_code += f' CONFIG.Phase_Width {{14}} CONFIG.Output_Width {{14}} CONFIG.Output_Selection'
        tcl_code += f' {{Sine}} CONFIG.Optimization_Goal {{Speed}} CONFIG.Latency_Configuration {{Configurable}}'
        tcl_code += f' CONFIG.Latency {{1}} CONFIG.Parameter_Entry {{Hardware_Parameters}} CONFIG.Noise_Shaping {{None}}'
        tcl_code += f' CONFIG.Has_Phase_Out {{false}} CONFIG.DATA_Has_TLAST {{Not_Required}} CONFIG.S_PHASE_Has_TUSER'
        tcl_code += f' {{Not_Required}} CONFIG.M_DATA_Has_TUSER {{Not_Required}} CONFIG.Output_Frequency1 {{0}} CONFIG.PINC1'
        tcl_code += f' {{0}}] [get_ips dds_compiler_{self.total_dds_num}]\n'
        
        #using '\' makes error in vivado.bat. this should be replaced in '/'
        tcl_code = tcl_code.replace("\\","/")
        
        self.total_dds_num += 1;
        
        return tcl_code
    
    def generate_xilinx_fifo_generator(self, folder_directory, total_fifo_num):
        tcl_code = ''
        tcl_code += f'create_ip -dir {folder_directory} -name fifo_generator -vendor xilinx.com -library ip -version 13.2 -module_name fifo_generator_{total_fifo_num}\n'
        tcl_code += f'set_property -dict [list CONFIG.Performance_Options {{First_Word_Fall_Through}}'
        tcl_code += f' CONFIG.Input_Data_Width {{128}} CONFIG.Input_Depth {{8192}}'
        tcl_code += f' CONFIG.Output_Data_Width {{128}} CONFIG.Output_Depth {{8192}}'
        tcl_code += f' CONFIG.Underflow_Flag {{true}} CONFIG.Overflow_Flag {{true}}'
        tcl_code += f' CONFIG.Data_Count_Width {{13}} CONFIG.Write_Data_Count_Width {{13}}'
        tcl_code += f' CONFIG.Read_Data_Count_Width {{13}} CONFIG.Programmable_Full_Type'
        tcl_code += f' {{Single_Programmable_Full_Threshold_Constant}}'
        tcl_code += f' CONFIG.Full_Threshold_Assert_Value {{8100}}'
        tcl_code += f' CONFIG.Full_Threshold_Negate_Value {{8099}}'
        tcl_code += f' CONFIG.Empty_Threshold_Assert_Value {{4}}'
        tcl_code += f' CONFIG.Empty_Threshold_Negate_Value {{5}}]'
        tcl_code += f' [get_ips fifo_generator_{total_fifo_num}]\n'
        
        #using '\' makes error in vivado.bat. this should be replaced in '/'
        tcl_code = tcl_code.replace("\\","/")
        
        return tcl_code
    
    def generate_xilinx_RF_converter(self, folder_directory, total_rfdc_num):
        tcl_code = ''
        tcl_code += f'create_ip -dir {folder_directory} -name usp_rf_data_converter -vendor xilinx.com -library ip -version 2.4 -module_name usp_rf_data_converter_{total_rfdc_num}\n'
        tcl_code += f'set_property -dict [list CONFIG.Analog_Detection {{0}} CONFIG.ADC0_Enable {{0}}'
        tcl_code += f' CONFIG.ADC0_Fabric_Freq {{0.0}} CONFIG.ADC_Slice00_Enable {{false}}'
        tcl_code += f' CONFIG.ADC_Decimation_Mode00 {{0}} CONFIG.ADC_Mixer_Type00 {{3}}'
        tcl_code += f' CONFIG.ADC_RESERVED_1_00 {{0}} CONFIG.ADC_Slice01_Enable {{false}}'
        tcl_code += f' CONFIG.ADC_Decimation_Mode01 {{0}} CONFIG.ADC_Mixer_Type01 {{3}}'
        tcl_code += f' CONFIG.ADC_RESERVED_1_02 {{0}} CONFIG.ADC_OBS02 {{0}} CONFIG.DAC0_Enable {{1}}'
        tcl_code += f' CONFIG.DAC0_Sampling_Rate {{1.6}} CONFIG.DAC0_Refclk_Freq {{1600.000}}'
        tcl_code += f' CONFIG.DAC0_Outclk_Freq {{100.000}} CONFIG.DAC0_Fabric_Freq {{100.000}}'
        tcl_code += f' CONFIG.DAC_Slice00_Enable {{true}} CONFIG.DAC_Interpolation_Mode00 {{1}}'
        tcl_code += f' CONFIG.DAC_Mixer_Type00 {{0}} CONFIG.DAC_RESERVED_1_00 {{0}} CONFIG.DAC_RESERVED_1_01 {{0}}'
        tcl_code += f' CONFIG.DAC_RESERVED_1_02 {{0}} CONFIG.DAC_RESERVED_1_03 {{0}}] [get_ips usp_rf_data_converter_{total_rfdc_num}]\n'
        
        
        #using '\' makes error in vivado.bat. this should be replaced in '/'
        tcl_code = tcl_code.replace("\\","/")
        
        return tcl_code
    
    def generate_xilinx_fifo_generator(self, folder_directory, total_fifo_num):
        tcl_code = ''
        tcl_code += f'create_ip -dir {folder_directory} -name fifo_generator -vendor xilinx.com -library ip -version 13.2 -module_name fifo_generator_{total_fifo_num}\n'
        tcl_code += f'set_property -dict [list CONFIG.Performance_Options {{First_Word_Fall_Through}}'
        tcl_code += f' CONFIG.Input_Data_Width {{128}} CONFIG.Input_Depth {{8192}}'
        tcl_code += f' CONFIG.Output_Data_Width {{128}} CONFIG.Output_Depth {{8192}}'
        tcl_code += f' CONFIG.Underflow_Flag {{true}} CONFIG.Overflow_Flag {{true}}'
        tcl_code += f' CONFIG.Data_Count_Width {{13}} CONFIG.Write_Data_Count_Width {{13}}'
        tcl_code += f' CONFIG.Read_Data_Count_Width {{13}} CONFIG.Programmable_Full_Type'
        tcl_code += f' {{Single_Programmable_Full_Threshold_Constant}}'
        tcl_code += f' CONFIG.Full_Threshold_Assert_Value {{8100}}'
        tcl_code += f' CONFIG.Full_Threshold_Negate_Value {{8099}}'
        tcl_code += f' CONFIG.Empty_Threshold_Assert_Value {{4}}'
        tcl_code += f' CONFIG.Empty_Threshold_Negate_Value {{5}}]'
        tcl_code += f' [get_ips fifo_generator_{total_fifo_num}]\n'
        
        #using '\' makes error in vivado.bat. this should be replaced in '/'
        tcl_code = tcl_code.replace("\\","/")
        
        return tcl_code
    
    def make_tcl(self, folder_directory,prj_name,part_name,board_path,board_name,file_type):
        file_name = prj_name+".tcl"
        print(file_name)
        # Combine the file name and folder directory to create the full file path
        file_path = folder_directory + '\\' + file_name
        print(file_path)
        
        #add src files
        self.set_project(folder_directory, prj_name)
        self.create_project(part_name)
        self.add_src(folder_directory,file_type)
        self.set_board(board_path, board_name)
        # self.generate_xilinx_dds_ip(folder_directory)
        
        # Save the TCL code to the .tcl file
        with open(file_path, 'w') as tcl_file:
            tcl_file.write(self.tcl_commands)
            
    def set_project(self, folder_directory, prj_name):
        tcl_code = "# Set the project name and working directory\n"
        tcl_code += self.generate_set_prj_string(folder_directory,prj_name)
        tcl_code = tcl_code.replace("\\","/")
        tcl_code += '\n'
        
        self.tcl_commands += tcl_code
    
    def create_project(self, part_name):
        tcl_code = "# Create a new project\n"
        tcl_code += self.generate_create_prj_string(part_name)
        tcl_code = tcl_code.replace("\\","/")
        tcl_code += '\n'
        
        self.tcl_commands += tcl_code
    
    def add_src(self, folder_directory,file_type):
        # Get all files in the directory
        all_files = self.get_all_files_in_directory(folder_directory,file_type)
        tcl_code = "# Add the FIFO IP file to the project\n"
        for all_file_path in all_files:
            tcl_code += self.generate_add_files_string(all_file_path)
        #using '\' makes error in vivado.bat. this should be replaced in '/'
        tcl_code = tcl_code.replace("\\","/")
        tcl_code += '\n'
        
        self.tcl_commands += tcl_code
    
    def set_board(self, board_path, board_name):
        tcl_code = "# Set the target board\n"
        tcl_code += self.generate_set_board(board_path, board_name)
        tcl_code = tcl_code.replace("\\","/")
        tcl_code += '\n'
        
        self.tcl_commands += tcl_code
        
    def open_vivado(self, folder_directory,prj_name):
        tcl_code = ''
        tcl_code += 'close_project\n'
        tcl_code += 'start_gui\n'
        tcl_code += f'open_project {folder_directory}/{prj_name}/{prj_name}.xpr\n'
        
        tcl_code = tcl_code.replace("\\","/")
        
        self.tcl_commands += tcl_code
        
    
    def run(self, folder_directory,prj_name,part_name,board_path,board_name,file_type,vivado_path, file_path):
        self.make_tcl(folder_directory,prj_name,part_name,board_path,board_name,file_type)
        self.run_vivado_tcl(vivado_path, file_path)

if __name__ == "__main__":
    # Replace "your_tcl_file.tcl" with the path to your actual TCL file
    prj_name = "TimeController"
    folder_directory = "E:\RFSoC\GIT\Vivado_prj_manager\TCL_main"
    part_name = "xczu28dr-ffvg1517-2-e"
    board_path = "E:/Xilinx/Vivado/2020.2/data/boards/board_files"
    board_name = "xilinx.com:zcu111:part0:1.4"
    file_type = [".v", ".sv", ".xci"]
    
    tcl = TCL_maker()
    tcl.make_tcl(folder_directory,prj_name,part_name,board_path,board_name,file_type)
    
    file_path = folder_directory + '\\' + prj_name + '.tcl'
    vivado_path = r"E:\Xilinx\Vivado\2020.2\bin\vivado.bat"  
    
    #tcl.run_vivado_tcl(vivado_path, file_path)