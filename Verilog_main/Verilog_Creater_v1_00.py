# -*- coding: utf-8 -*-
"""
Created on Fri Aug 25 15:46:38 2023

@author: QC109_4
"""
import os
import re
import subprocess

class Verilog_maker:
    def __init__(self):
        print('make verilog code...')
        self.fifo_generator_list = []
        self.dds_compiler_list = []
        self.rf_converter_list = []
        self.git_dir = 'E:\RFSoC\GIT'
        self.dac_controller_dir = 'RFSoC\RFSoC_Design_V1_1\IP_File_01\DAC_Controller'
        self.dac_controller_modules = ['DAC_Controller', 'AXI2FIFO', 'DDS_Controller', 'GPO_Core', 'RFDC_DDS', 'RTO_Core']
        self.vivado_path = r"E:\Xilinx\Vivado\2020.2\bin\vivado.bat"
        self.board_path = "E:/Xilinx/Vivado/2020.2/data/boards/board_files"
        self.part_name = "xczu28dr-ffvg1517-2-e"
        self.board_name = "xilinx.com:zcu111:part0:1.4"
        self.tcl_commands = ''
        self.customized_ip_list = []
        
    def run_vivado_tcl(self, vivado_bat, tcl_path):
        self.vivado_executable = vivado_bat# Replace with the actual path to vivado.bat
    
        # Start Vivado in batch mode and pass the TCL commands as input
        process = subprocess.Popen([self.vivado_executable, "-mode", "batch", "-source", tcl_path],
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
    
    def generate_add_constraints_string(self, file_path):
        file_path_ = file_path.replace("\\","/")
        return f'add_files -fileset constrs_1 -norecurse {file_path_}'
    
    def generate_set_prj_string(self, folder_directory,prj_name):
        return f'set project_name \"{prj_name}\"\n' + f'set project_dir \"{folder_directory}\"\n'
    
    def generate_create_prj_string(self, part_name):
        return f'create_project ${{project_name}} ${{project_dir}}/${{project_name}} -part {part_name}\n'
    
    def generate_set_board(self, board_path, board_name):
        return f'set boardpath {{{board_path}}}\n' + 'set_param board.repoPaths [list $boardpath]\n' + f'set_property BOARD_PART {board_name} [current_project]\n'
    
    def generate_xilinx_dds_ip(self, folder_directory, dds_name):
        tcl_code = ''
        tcl_code += f'create_ip -dir {folder_directory} -name dds_compiler -vendor xilinx.com -library ip -version 6.0 -module_name {dds_name}\n'
        #one line command
        tcl_code += f'set_property -dict [list CONFIG.PartsPresent {{SIN_COS_LUT_only}}'
        tcl_code += f' CONFIG.Spurious_Free_Dynamic_Range {{90}} CONFIG.Frequency_Resolution {{0.01}}'
        tcl_code += f' CONFIG.Phase_Width {{14}} CONFIG.Output_Width {{14}} CONFIG.Output_Selection'
        tcl_code += f' {{Sine}} CONFIG.Optimization_Goal {{Speed}} CONFIG.Latency_Configuration {{Configurable}}'
        tcl_code += f' CONFIG.Latency {{1}} CONFIG.Parameter_Entry {{Hardware_Parameters}} CONFIG.Noise_Shaping {{None}}'
        tcl_code += f' CONFIG.Has_Phase_Out {{false}} CONFIG.DATA_Has_TLAST {{Not_Required}} CONFIG.S_PHASE_Has_TUSER'
        tcl_code += f' {{Not_Required}} CONFIG.M_DATA_Has_TUSER {{Not_Required}} CONFIG.Output_Frequency1 {{0}} CONFIG.PINC1'
        tcl_code += f' {{0}}] [get_ips {dds_name}]\n'
        
        #using '\' makes error in vivado.bat. this should be replaced in '/'
        tcl_code = tcl_code.replace("\\","/")
        
        return tcl_code
    
    def generate_xilinx_fifo_generator(self, folder_directory, fifo_name):
        tcl_code = ''
        tcl_code += f'create_ip -dir {folder_directory} -name fifo_generator -vendor xilinx.com -library ip -version 13.2 -module_name {fifo_name}\n'
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
        tcl_code += f' [get_ips {fifo_name}]\n'
        
        #using '\' makes error in vivado.bat. this should be replaced in '/'
        tcl_code = tcl_code.replace("\\","/")
        
        return tcl_code
    
    def generate_customized_ip(self, folder_directory):
        tcl_code = ''
        tcl_code += f'ipx::package_project -root_dir {folder_directory}'
        tcl_code += f' -vendor xilinx.com -library user -taxonomy /UserIP\n'
        tcl_code += f'ipx::save_core [ipx::current_core]\n'
        tcl_code += f'set_property  ip_repo_paths  {folder_directory} [current_project]\n'
        tcl_code += f'update_ip_catalog\n'
        
        #using '\' makes error in vivado.bat. this should be replaced in '/'
        tcl_code = tcl_code.replace("\\","/")
        
        self.customized_ip_list.append(folder_directory)
        
        return tcl_code
    
    def add_customized_ip(self, folder_directory):
        tcl_code = ''
        tcl_code += r'set_property  ip_repo_paths {'
        for ip_dir in self.customized_ip_list:
            tcl_code += f' {ip_dir} '
            
        tcl_code += r'}'
        tcl_code += f' [current_project]\n'
        tcl_code += f'update_ip_catalog\n'
        
        #using '\' makes error in vivado.bat. this should be replaced in '/'
        tcl_code = tcl_code.replace("\\","/")
        
        return tcl_code
        
    def ensure_directory_exists(self, directory_path):
        if not os.path.exists(directory_path):
            try:
                os.makedirs(directory_path)
                print(f"Directory {directory_path} created.")
            except OSError as error:
                print(f"Error creating directory {directory_path}: {error}")
        else:
            print(f"Directory {directory_path} already exists.")
            
    def remove_duplicates_set(self, lst):
        return list(set(lst))
        
    def generate_indexed_dac_controller(self, index, current_dir = None):
        fifo_list = []
        dds_list = []
        if current_dir == None:
            source_dir = './DAC_Controller'
        else:
            source_dir = f'{current_dir}/DAC_Controller'
        
        full_dir = os.path.join(self.git_dir, self.dac_controller_dir)
        base_dir = os.path.dirname(full_dir)
        base_name = os.path.basename(full_dir)
        new_full_dir = os.path.join(base_dir,base_name + f'_{index}')
        new_output_full_dir =os.path.join(base_dir,base_name + f'_output_{index}')
        self.ensure_directory_exists(new_full_dir)
            
        for filename in os.listdir(source_dir):
            source_path = os.path.join(source_dir, filename)
            file_root, file_extension = os.path.splitext(filename)
            new_filename = file_root + f'_{index}' + file_extension
            destination_path = os.path.join(new_full_dir, new_filename)
        
            # Open the source file and read its contents
            verilog_code = ''
            with open(source_path, 'r') as source_file:
                verilog_code = source_file.read()
                
            for module_ in self.dac_controller_modules:
                verilog_code = verilog_code.replace(module_,module_ +  f'_{index}')
                
            verilog_code = re.sub(r'fifo_generator_(\d+)', f'dac_controller_fifo_{index}_generator' + r'_\1',verilog_code)
            matches = re.findall(f'dac_controller_fifo_{index}_generator'+r'_(\d+)',verilog_code)
            full_strings = [f'dac_controller_fifo_{index}_generator_{match}' for match in matches]
            fifo_list += full_strings
            
            verilog_code = re.sub(r'dds_compiler_(\d+)', f'dac_controller_dds_{index}_compiler' + r'_\1',verilog_code)
            matches = re.findall(f'dac_controller_dds_{index}_compiler'+r'_(\d+)',verilog_code)
            full_strings = [f'dac_controller_dds_{index}_compiler_{match}' for match in matches]
            dds_list += full_strings
        
            # Write the modified content to the destination file
            with open(destination_path, 'w') as destination_file:
                destination_file.write(verilog_code)
                
            
        self.remove_duplicates_set(fifo_list)
        self.remove_duplicates_set(dds_list)
        self.make_dac_controller_tcl(new_output_full_dir, f'DAC_Controller_{index}',self.part_name,self.board_path,self.board_name,new_full_dir, ['.sv', '.v','.xic'], dds_list, fifo_list)
        
    def make_dac_controller_tcl(self, folder_directory,prj_name,part_name,board_path,board_name,src_folder_directory,file_type, dds_list, fifo_list):
        file_name = prj_name+".tcl"
        print(file_name)
        # Combine the file name and folder directory to create the full file path
        file_path = folder_directory + '\\' + file_name
        print(file_path)
        
        self.ensure_directory_exists(folder_directory)
        #add src files
        self.set_project(folder_directory, prj_name)
        self.create_project(part_name)
        self.add_src(src_folder_directory,file_type)
        self.set_board(board_path, board_name)
        for dds_ in dds_list:
            self.tcl_commands += self.generate_xilinx_dds_ip(folder_directory,dds_)
        
        for fifo_ in fifo_list:
            self.tcl_commands += self.generate_xilinx_fifo_generator(folder_directory,fifo_)
        
        # Save the TCL code to the .tcl file
        
        self.tcl_commands += self.generate_customized_ip(folder_directory)
        # self.open_vivado(folder_directory,prj_name)
        
        self.tcl_commands += f'set_property top DAC_Controller [current_fileset]\n'.replace("\\","/")
        self.tcl_commands += f'set_property top_file {{ {src_folder_directory}/DAC_Controller.sv }} [current_fileset]\n'.replace("\\","/")
        with open(file_path, 'w') as tcl_file:
            tcl_file.write(self.tcl_commands)
            
        self.tcl_commands = ''
        tcl_path = folder_directory + '\\' + prj_name + '.tcl'
        
        self.run_vivado_tcl(self.vivado_path, tcl_path)
        
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
            root, ext = os.path.splitext(all_file_path)
            if ext == '.xdc':
                tcl_code += self.generate_add_constraints_string(all_file_path)
            else:
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
        tcl_code += 'start_gui\n'
        # tcl_code += f'open_project {folder_directory}/{prj_name}/{prj_name}.xpr\n'
        
        tcl_code = tcl_code.replace("\\","/")
        
        self.tcl_commands += tcl_code
        
    
    def run(self, folder_directory,prj_name,part_name,board_path,board_name,file_type,vivado_path, tcl_path):
        self.run_vivado_tcl(vivado_path, tcl_path)
        
    
            
if __name__ == "__main__":
    vm = Verilog_maker()
    for i in range(1):
        vm.generate_indexed_dac_controller(i)