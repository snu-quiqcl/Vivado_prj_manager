# -*- coding: utf-8 -*-
"""
Created on Fri Aug 25 15:46:38 2023

@author: QC109_4

get delay
report_timing -from [get_ports {DT_I2S_LRCK_in}] -delay_type min_max -max_paths 200 -sort_by group -path_type full -input_pins -name timing_DT_TO_TDC_OUT
set fanout [ get_property FLAT_PIN_COUNT [ get_nets tmp3 ] ]
set net_delays [ get_net_delays -of _objects [ get_nets tmp3 ] ]
report_property [ lindex $net_delays 0 ]
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
        self.target_dir = 'RFSoC\RFSoC_Design_V1_1\IP_File_01'
        
        self.dac_controller_dir =  os.path.join(self.target_dir, 'DAC_Controller')
        self.dac_controller_modules = ['DAC_Controller', 'AXI2FIFO', 'DDS_Controller', 'GPO_Core', 'RFDC_DDS', 'RTO_Core', 'MAC']
        #Number of total dac controller number
        self.total_dac_num = 8 
        
        self.time_controller_dir = os.path.join(self.target_dir,'TimeController')
        
        self.time_controller_buffer_dir = os.path.join(self.target_dir, 'TimeControllerBuffer')
        
        self.RFSoC_Main_dir = os.path.join(self.target_dir,'RFSoC_Main')
        
        self.AXI_Buffer_dir = os.path.join(self.target_dir,'AXI_Buffer')
        
        self.total_rfdc_num = 1
        
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
        tcl_code += f' CONFIG.Latency {{3}} CONFIG.Parameter_Entry {{Hardware_Parameters}} CONFIG.Noise_Shaping {{None}}'
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
    
    def generate_xilinx_dsp_mul(self, folder_directory, dsp_name):
        tcl_code = ''
        tcl_code += f'create_ip -dir {folder_directory} -name xbip_dsp48_macro -vendor xilinx.com -library ip -version 3.0 -module_name {dsp_name}\n'
        tcl_code += f'set_property -dict [list CONFIG.instruction1 {{(D-A)*B}}'
        tcl_code += f' CONFIG.has_carryout {{false}} CONFIG.dreg_3 {{true}}'
        tcl_code += f' CONFIG.areg_3 {{true}} CONFIG.areg_4 {{true}} CONFIG.breg_3 {{true}}'
        tcl_code += f' CONFIG.breg_4 {{true}} CONFIG.cinreg_3 {{false}} CONFIG.cinreg_4 {{false}}'
        tcl_code += f' CONFIG.cinreg_5 {{false}} CONFIG.mreg_5 {{true}} CONFIG.preg_6 {{true}}'
        tcl_code += f' CONFIG.d_width {{16}} CONFIG.d_binarywidth {{0}} CONFIG.a_width {{16}}'
        tcl_code += f' CONFIG.a_binarywidth {{0}} CONFIG.b_width {{16}} CONFIG.b_binarywidth {{0}}'
        tcl_code += f' CONFIG.concat_width {{48}} CONFIG.concat_binarywidth {{0}} CONFIG.c_binarywidth {{0}}'
        tcl_code += f' CONFIG.pcin_binarywidth {{0}}]'
        tcl_code += f' [get_ips {dsp_name}]\n'
        
        #using '\' makes error in vivado.bat. this should be replaced in '/'
        tcl_code = tcl_code.replace("\\","/")
        
        return tcl_code
        
    def generate_xilinx_dsp_sum(self, folder_directory, dsp_name):
        tcl_code = ''
        tcl_code += f'create_ip -dir {folder_directory} -name xbip_dsp48_macro -vendor xilinx.com -library ip -version 3.0 -module_name {dsp_name}\n'
        tcl_code += f'set_property -dict [list CONFIG.instruction1 {{(D+A)+C+CARRYIN}}'
        tcl_code += f' CONFIG.has_carryout {{true}} CONFIG.dreg_1 {{true}} CONFIG.dreg_2 {{true}}'
        tcl_code += f' CONFIG.dreg_3 {{true}} CONFIG.areg_1 {{true}} CONFIG.areg_2 {{true}}'
        tcl_code += f' CONFIG.areg_3 {{true}} CONFIG.areg_4 {{true}} CONFIG.breg_3 {{false}}'
        tcl_code += f' CONFIG.breg_4 {{false}} CONFIG.creg_1 {{true}} CONFIG.creg_2 {{true}}'
        tcl_code += f' CONFIG.creg_3 {{true}} CONFIG.creg_4 {{true}} CONFIG.creg_5 {{true}}'
        tcl_code += f' CONFIG.cinreg_1 {{true}} CONFIG.cinreg_2 {{true}} CONFIG.cinreg_3 {{true}}'
        tcl_code += f' CONFIG.cinreg_4 {{true}} CONFIG.cinreg_5 {{true}} CONFIG.mreg_5 {{true}}'
        tcl_code += f' CONFIG.preg_6 {{true}} CONFIG.d_width {{16}} CONFIG.d_binarywidth {{0}}'
        tcl_code += f' CONFIG.a_width {{16}} CONFIG.a_binarywidth {{0}} CONFIG.b_width {{16}}'
        tcl_code += f' CONFIG.b_binarywidth {{0}} CONFIG.concat_width {{48}} CONFIG.concat_binarywidth {{0}}'
        tcl_code += f' CONFIG.c_width {{16}} CONFIG.c_binarywidth {{0}} CONFIG.pcin_binarywidth {{0}}'
        tcl_code += f' CONFIG.p_full_width {{17}} CONFIG.p_width {{17}} CONFIG.p_binarywidth {{0}}]'
        tcl_code += f' [get_ips {dsp_name}]\n'
        
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
        dsp_mul_list = []
        dsp_sum_list = []
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
            
            verilog_code = re.sub(r'xbip_dsp48_mul_macro_(\d+)', f'dac_controller_xbip_dsp48_{index}_mul_macro' + r'_\1',verilog_code)
            matches = re.findall(f'dac_controller_xbip_dsp48_{index}_mul_macro' + r'_(\d+)',verilog_code)
            full_strings = [f'dac_controller_xbip_dsp48_{index}_mul_macro_{match}' for match in matches]
            dsp_mul_list += full_strings
            
            verilog_code = re.sub(r'xbip_dsp48_sum_macro_(\d+)', f'dac_controller_xbip_dsp48_{index}_sum_macro' + r'_\1',verilog_code)
            matches = re.findall(f'dac_controller_xbip_dsp48_{index}_sum_macro' + r'_(\d+)',verilog_code)
            full_strings = [f'dac_controller_xbip_dsp48_{index}_sum_macro_{match}' for match in matches]
            dsp_sum_list += full_strings
        
            # Write the modified content to the destination file
            with open(destination_path, 'w') as destination_file:
                destination_file.write(verilog_code)
                
            
        self.remove_duplicates_set(fifo_list)
        self.remove_duplicates_set(dds_list)
        self.remove_duplicates_set(dsp_mul_list)
        self.remove_duplicates_set(dsp_sum_list)
        self.make_dac_controller_tcl(new_output_full_dir, f'DAC_Controller_{index}',self.part_name,\
                                    self.board_path,self.board_name,new_full_dir, ['.sv', '.v','.xic'], \
                                    dds_list, fifo_list, dsp_mul_list, dsp_sum_list)
        
    def make_dac_controller_tcl(self, folder_directory,prj_name,part_name,board_path,board_name,src_folder_directory,file_type, dds_list, fifo_list, dsp_mul_list, dsp_sum_list):
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
            
        for dsp_ in dsp_mul_list:
            self.tcl_commands += self.generate_xilinx_dsp_mul(folder_directory, dsp_)
            
        for dsp_ in dsp_sum_list:
            self.tcl_commands += self.generate_xilinx_dsp_sum(folder_directory, dsp_)
        
        # Save the TCL code to the .tcl file
        
        self.tcl_commands += self.generate_customized_ip(folder_directory)
        # self.open_vivado(folder_directory,prj_name)
        
        self.tcl_commands += f'set_property top {prj_name} [current_fileset]\n'.replace("\\","/")
        self.tcl_commands += f'set_property top_file {{ {src_folder_directory}/{prj_name}.sv }} [current_fileset]\n'.replace("\\","/")
        with open(file_path, 'w') as tcl_file:
            tcl_file.write(self.tcl_commands)
            
        self.tcl_commands = ''
        tcl_path = folder_directory + '\\' + prj_name + '.tcl'
        
        self.run_vivado_tcl(self.vivado_path, tcl_path)
        
    def generate_time_controller(self, current_dir = None):
        if current_dir == None:
            source_dir = './TimeController'
        else:
            source_dir = f'{current_dir}/TimeController'
        
        full_dir = os.path.join(self.git_dir, self.time_controller_dir)
        base_dir = os.path.dirname(full_dir)
        base_name = os.path.basename(full_dir)
        new_full_dir = os.path.join(base_dir,base_name)
        new_output_full_dir =os.path.join(base_dir,base_name + '_output')
        self.ensure_directory_exists(new_full_dir)
            
        for filename in os.listdir(source_dir):
            source_path = os.path.join(source_dir, filename)
            file_root, file_extension = os.path.splitext(filename)
            new_filename = file_root + file_extension
            destination_path = os.path.join(new_full_dir, new_filename)
        
            # Open the source file and read its contents
            verilog_code = ''
            with open(source_path, 'r') as source_file:
                verilog_code = source_file.read()
                
            # Write the modified content to the destination file
            with open(destination_path, 'w') as destination_file:
                destination_file.write(verilog_code)

        self.make_time_controller_tcl(new_output_full_dir, 'TimeController', self.part_name, self.board_path, self.board_name, new_full_dir, ['.sv', '.v','.xic'])
        
    def make_time_controller_tcl(self, folder_directory,prj_name,part_name,board_path,board_name,src_folder_directory,file_type):
        file_name = prj_name+".tcl"
        print(file_name)
        # Combine the file name and folder directory to create the full file path
        file_path = folder_directory + '\\' + file_name
        print(file_path)
        
        self.ensure_directory_exists(folder_directory)
        self.ensure_directory_exists(src_folder_directory)
        #add src files
        self.set_project(folder_directory, prj_name)
        self.create_project(part_name)
        self.add_src(src_folder_directory,file_type)
        self.set_board(board_path, board_name)
        
        # Save the TCL code to the .tcl file
        
        self.tcl_commands += self.generate_customized_ip(folder_directory)
        
        self.tcl_commands += f'set_property top TimeController [current_fileset]\n'.replace("\\","/")
        self.tcl_commands += f'set_property top_file {{ {src_folder_directory}/TimeController.sv }} [current_fileset]\n'.replace("\\","/")
        with open(file_path, 'w') as tcl_file:
            tcl_file.write(self.tcl_commands)
            
        self.tcl_commands = ''
        
        tcl_path = folder_directory + '\\' + prj_name + '.tcl'
        
        self.run_vivado_tcl(self.vivado_path, tcl_path)
        
    ##buffer
    def generate_axi_buffer(self, current_dir = None):
        if current_dir == None:
            source_dir = './AXI_Buffer'
        else:
            source_dir = f'{current_dir}/AXI_Buffer'
        
        full_dir = os.path.join(self.git_dir, self.AXI_Buffer_dir)
        base_dir = os.path.dirname(full_dir)
        base_name = os.path.basename(full_dir)
        new_full_dir = os.path.join(base_dir,base_name)
        new_output_full_dir =os.path.join(base_dir,base_name + '_output')
        self.ensure_directory_exists(new_full_dir)
            
        for filename in os.listdir(source_dir):
            source_path = os.path.join(source_dir, filename)
            file_root, file_extension = os.path.splitext(filename)
            new_filename = file_root + file_extension
            destination_path = os.path.join(new_full_dir, new_filename)
        
            # Open the source file and read its contents
            verilog_code = ''
            with open(source_path, 'r') as source_file:
                verilog_code = source_file.read()
                
            # Write the modified content to the destination file
            with open(destination_path, 'w') as destination_file:
                destination_file.write(verilog_code)

        self.make_axi_buffer_tcl(new_output_full_dir, 'AXI_Buffer', self.part_name, self.board_path, self.board_name, new_full_dir, ['.sv', '.v','.xic'])
        
    def make_axi_buffer_tcl(self, folder_directory,prj_name,part_name,board_path,board_name,src_folder_directory,file_type):
        file_name = prj_name+".tcl"
        print(file_name)
        # Combine the file name and folder directory to create the full file path
        file_path = folder_directory + '\\' + file_name
        print(file_path)
        
        self.ensure_directory_exists(folder_directory)
        self.ensure_directory_exists(src_folder_directory)
        #add src files
        self.set_project(folder_directory, prj_name)
        self.create_project(part_name)
        self.add_src(src_folder_directory,file_type)
        self.set_board(board_path, board_name)
        
        # Save the TCL code to the .tcl file
        
        self.tcl_commands += self.generate_customized_ip(folder_directory)
        
        self.tcl_commands += f'set_property top AXI_Buffer [current_fileset]\n'.replace("\\","/")
        self.tcl_commands += f'set_property top_file {{ {src_folder_directory}/AXI_Buffer.sv }} [current_fileset]\n'.replace("\\","/")
        with open(file_path, 'w') as tcl_file:
            tcl_file.write(self.tcl_commands)
            
        self.tcl_commands = ''
        
        tcl_path = folder_directory + '\\' + prj_name + '.tcl'
        
        self.run_vivado_tcl(self.vivado_path, tcl_path)
        
    def generate_RFSoC_main(self, current_dir = None):
        if current_dir == None:
            source_dir = './RFSoC_Main'
        else:
            source_dir = f'{current_dir}/RFSoC_Main'
        
        full_dir = os.path.join(self.git_dir, self.RFSoC_Main_dir)
        base_dir = os.path.dirname(full_dir)
        base_name = os.path.basename(full_dir)
        new_full_dir = os.path.join(base_dir,base_name)
        new_output_full_dir =os.path.join(base_dir,base_name + '_output')
        self.ensure_directory_exists(new_full_dir)
            
        for filename in os.listdir(source_dir):
            source_path = os.path.join(source_dir, filename)
            file_root, file_extension = os.path.splitext(filename)
            new_filename = file_root + file_extension
            destination_path = os.path.join(new_full_dir, new_filename)
        
            # Open the source file and read its contents
            verilog_code = ''
            with open(source_path, 'r') as source_file:
                verilog_code = source_file.read()
                
            # Write the modified content to the destination file
            with open(destination_path, 'w') as destination_file:
                destination_file.write(verilog_code)

        self.make_RFSoC_main_tcl(new_output_full_dir, 'RFSoC_Main', self.part_name, self.board_path, self.board_name, new_full_dir, ['.sv', '.v','.xic', '.xdc'],'block')
        
    def make_RFSoC_main_tcl(self, folder_directory,prj_name,part_name,board_path,board_name,src_folder_directory,file_type,version = 'block'):
        if version == 'block':
            file_name = prj_name+".tcl"
            print(file_name)
            # Combine the file name and folder directory to create the full file path
            file_path = folder_directory + '\\' + file_name
            print(file_path)
            
            self.ensure_directory_exists(folder_directory)
            self.ensure_directory_exists(src_folder_directory)
            #add src files
            self.set_project(folder_directory, prj_name)
            self.create_project(part_name)
            self.add_src(src_folder_directory,file_type)
            self.set_board(board_path, board_name)
            
            # Save the TCL code to the .tcl file
            
            self.tcl_commands += self.add_customized_ip(folder_directory)
            self.tcl_commands += self.generate_xilinx_block_design(folder_directory, prj_name)
            self.open_vivado(folder_directory,prj_name)
            with open(file_path, 'w') as tcl_file:
                tcl_file.write(self.tcl_commands)
                
            self.tcl_commands = ''
            
            tcl_path = folder_directory + '\\' + prj_name + '.tcl'
            
            self.run_vivado_tcl(self.vivado_path, tcl_path)
            
        #Only possible in TCL_Creater
        elif version == 'code':
            file_name = prj_name+".tcl"
            print(file_name)
            # Combine the file name and folder directory to create the full file path
            file_path = folder_directory + '\\' + file_name
            print(file_path)
            
            self.ensure_directory_exists(folder_directory)
            self.ensure_directory_exists(src_folder_directory)
            #add src files
            self.set_project(folder_directory, prj_name)
            self.create_project(part_name)
            self.add_src(src_folder_directory,file_type)
            self.set_board(board_path, board_name)
            
            # Save the TCL code to the .tcl file
            
            self.tcl_commands += self.add_customized_ip(folder_directory)
            
            for i in range(self.total_dac_num):
                self.tcl_commands += self.generate_custom_dac_controller(folder_directory, i)
                
            self.tcl_commands += self.generate_custom_time_controller(folder_directory)
            self.tcl_commands += self.generate_xilinx_Zynq(folder_directory)
            
            # set simulation length
            self.tcl_commands += 'set_property -name {xsim.simulate.runtime} -value {1ms} -objects [get_filesets sim_1]\n'
            self.open_vivado(folder_directory,prj_name)
            with open(file_path, 'w') as tcl_file:
                tcl_file.write(self.tcl_commands)
                
            self.tcl_commands = ''
            
            tcl_path = folder_directory + '\\' + prj_name + '.tcl'
            
            self.run_vivado_tcl(self.vivado_path, tcl_path)
            
    def generate_xilinx_block_design(self, folder_directory, prj_name):
        tcl_code = ''
        tcl_code += f'create_bd_design \"{prj_name}_blk\"\n'
        tcl_code += f'current_bd_design \"{prj_name}_blk\"\n'
        tcl_code += f'set parentObj [get_bd_cells /]\n'
        tcl_code += f'set parentObj [get_bd_cells \"\"]\n'
        tcl_code += 'set parentType [get_property TYPE $parentObj]\n'
        tcl_code += f'current_bd_instance $parentObj\n'
        tcl_code += """
set RF3_CLKO_A_C_N_228 [ create_bd_port -dir I -type clk -freq_hz 4000000000 RF3_CLKO_A_C_N_228 ]
set RF3_CLKO_A_C_N_229 [ create_bd_port -dir I -type clk -freq_hz 4000000000 RF3_CLKO_A_C_N_229 ]
set RF3_CLKO_A_C_P_228 [ create_bd_port -dir I -type clk -freq_hz 4000000000 RF3_CLKO_A_C_P_228 ]
set RF3_CLKO_A_C_P_229 [ create_bd_port -dir I -type clk -freq_hz 4000000000 RF3_CLKO_A_C_P_229 ]
"""
        for i in range(self.total_dac_num): 
            if i < 4:
                tcl_code +=f"""
set RFMC_DAC_0{i}_N [ create_bd_port -dir O RFMC_DAC_0{i}_N ]
set RFMC_DAC_0{i}_P [ create_bd_port -dir O RFMC_DAC_0{i}_P ]
            """
            else:
                tcl_code +=f"""
set RFMC_DAC_1{i-4}_N [ create_bd_port -dir O RFMC_DAC_0{i}_N ]
set RFMC_DAC_1{i-4}_P [ create_bd_port -dir O RFMC_DAC_0{i}_P ]
            """
            
        tcl_code += '\n'
        for i in range(self.total_dac_num):
            tcl_code += f'set DAC_Controller_{i} [ create_bd_cell -type ip -vlnv xilinx.com:user:DAC_Controller_{i} DAC_Controller_{i} ]\n'
            
        tcl_code += 'set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset proc_sys_reset_0 ]\n'
        tcl_code += 'set TimeController_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:TimeController TimeController_0 ]\n'
        tcl_code += 'set AXI_Buffer_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI_Buffer AXI_Buffer_0 ]'
        tcl_code += f"""
set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect axi_interconnect_0 ]
set_property -dict [ list \
   CONFIG.NUM_MI {{{1 + self.total_rfdc_num + self.total_dac_num}}} \
 ] $axi_interconnect_0
        """
        
        for i in range(self.total_rfdc_num):
            tcl_code += f'set usp_rf_data_converter_{i} [ create_bd_cell -type ip -vlnv xilinx.com:ip:usp_rf_data_converter usp_rf_data_converter_{i} ]\n'
            tcl_code += """
 set_property -dict [ list \
   CONFIG.ADC0_Enable {0} \
   CONFIG.ADC0_Fabric_Freq {0.0} \
   CONFIG.ADC_Decimation_Mode00 {0} \
   CONFIG.ADC_Decimation_Mode01 {0} \
   CONFIG.ADC_Mixer_Type00 {3} \
   CONFIG.ADC_Mixer_Type01 {3} \
   CONFIG.ADC_OBS02 {false} \
   CONFIG.ADC_RESERVED_1_00 {false} \
   CONFIG.ADC_RESERVED_1_02 {false} \
   CONFIG.ADC_Slice00_Enable {false} \
   CONFIG.ADC_Slice01_Enable {false} \
   CONFIG.Analog_Detection {0} \
   CONFIG.DAC0_Enable {1} \
   CONFIG.DAC0_Fabric_Freq {250.000} \
   CONFIG.DAC0_Outclk_Freq {250.000} \
   CONFIG.DAC0_Refclk_Freq {4000.000} \
   CONFIG.DAC0_Sampling_Rate {4} \
   CONFIG.DAC1_Enable {1} \
   CONFIG.DAC1_Fabric_Freq {250.000} \
   CONFIG.DAC1_Outclk_Freq {250.000} \
   CONFIG.DAC1_Refclk_Freq {4000.000} \
   CONFIG.DAC1_Sampling_Rate {4} """
            for j in range(self.total_dac_num):
                if j < 4:
                    tcl_code += f' CONFIG.DAC_Interpolation_Mode0{j} {{1}} '
                else:
                    tcl_code += f' CONFIG.DAC_Interpolation_Mode1{j-4} {{1}} '
                    
            for j in range(self.total_dac_num):
                if j < 4:
                    tcl_code += f' CONFIG.DAC_Mixer_Type0{j} {{0}} '
                else:
                    tcl_code += f' CONFIG.DAC_Mixer_Type1{j-4} {{0}} '
                    
            for j in range(self.total_dac_num):
                if j < 4:
                    tcl_code += f' CONFIG.DAC_Mixer_Type0{j} {{0}} '
                else:
                    tcl_code += f' CONFIG.DAC_Mixer_Type1{j-4} {{0}} '
                    
            tcl_code += '   CONFIG.DAC_Output_Current {1} '
            
            for j in range(self.total_dac_num):
                if j < 4:
                    tcl_code += f' CONFIG.DAC_RESERVED_1_0{j} {{false}} '
                else:
                    tcl_code += f' CONFIG.DAC_RESERVED_1_1{j-4} {{false}} '
                    
            for j in range(self.total_dac_num):
                if j < 4:
                    tcl_code += f' CONFIG.DAC_Slice0{j}_Enable {{true}} '
                else:
                    tcl_code += f' CONFIG.DAC_Slice1{j-4}_Enable {{true}} '
            tcl_code += ' CONFIG.Axiclk_Freq {250} '
            tcl_code += '\n'
            tcl_code += f'] $usp_rf_data_converter_{i}\n'
            
        # Setting Zynq
        tcl_code += """
set zynq_ultra_ps_e_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e zynq_ultra_ps_e_0 ]
set_property -dict [ list \
   CONFIG.PSU_BANK_0_IO_STANDARD {LVCMOS18} \
   CONFIG.PSU_BANK_1_IO_STANDARD {LVCMOS18} \
   CONFIG.PSU_BANK_2_IO_STANDARD {LVCMOS18} \
   CONFIG.PSU_DDR_RAM_HIGHADDR {0xFFFFFFFF} \
   CONFIG.PSU_DDR_RAM_HIGHADDR_OFFSET {0x800000000} \
   CONFIG.PSU_DDR_RAM_LOWADDR_OFFSET {0x80000000} \
   CONFIG.PSU_DYNAMIC_DDR_CONFIG_EN {1} \
   CONFIG.PSU_MIO_0_DIRECTION {out} \
   CONFIG.PSU_MIO_0_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_0_POLARITY {Default} \
   CONFIG.PSU_MIO_10_DIRECTION {inout} \
   CONFIG.PSU_MIO_10_POLARITY {Default} \
   CONFIG.PSU_MIO_11_DIRECTION {inout} \
   CONFIG.PSU_MIO_11_POLARITY {Default} \
   CONFIG.PSU_MIO_12_DIRECTION {out} \
   CONFIG.PSU_MIO_12_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_12_POLARITY {Default} \
   CONFIG.PSU_MIO_13_DIRECTION {inout} \
   CONFIG.PSU_MIO_13_POLARITY {Default} \
   CONFIG.PSU_MIO_14_DIRECTION {inout} \
   CONFIG.PSU_MIO_14_POLARITY {Default} \
   CONFIG.PSU_MIO_15_DIRECTION {inout} \
   CONFIG.PSU_MIO_15_POLARITY {Default} \
   CONFIG.PSU_MIO_16_DIRECTION {inout} \
   CONFIG.PSU_MIO_16_POLARITY {Default} \
   CONFIG.PSU_MIO_17_DIRECTION {inout} \
   CONFIG.PSU_MIO_17_POLARITY {Default} \
   CONFIG.PSU_MIO_18_DIRECTION {in} \
   CONFIG.PSU_MIO_18_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_18_POLARITY {Default} \
   CONFIG.PSU_MIO_18_SLEW {fast} \
   CONFIG.PSU_MIO_19_DIRECTION {out} \
   CONFIG.PSU_MIO_19_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_19_POLARITY {Default} \
   CONFIG.PSU_MIO_1_DIRECTION {inout} \
   CONFIG.PSU_MIO_1_POLARITY {Default} \
   CONFIG.PSU_MIO_20_DIRECTION {inout} \
   CONFIG.PSU_MIO_20_POLARITY {Default} \
   CONFIG.PSU_MIO_21_DIRECTION {inout} \
   CONFIG.PSU_MIO_21_POLARITY {Default} \
   CONFIG.PSU_MIO_22_DIRECTION {inout} \
   CONFIG.PSU_MIO_22_POLARITY {Default} \
   CONFIG.PSU_MIO_23_DIRECTION {inout} \
   CONFIG.PSU_MIO_23_POLARITY {Default} \
   CONFIG.PSU_MIO_24_DIRECTION {inout} \
   CONFIG.PSU_MIO_24_POLARITY {Default} \
   CONFIG.PSU_MIO_25_DIRECTION {inout} \
   CONFIG.PSU_MIO_25_POLARITY {Default} \
   CONFIG.PSU_MIO_26_DIRECTION {inout} \
   CONFIG.PSU_MIO_26_POLARITY {Default} \
   CONFIG.PSU_MIO_27_DIRECTION {out} \
   CONFIG.PSU_MIO_27_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_27_POLARITY {Default} \
   CONFIG.PSU_MIO_28_DIRECTION {in} \
   CONFIG.PSU_MIO_28_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_28_POLARITY {Default} \
   CONFIG.PSU_MIO_28_SLEW {fast} \
   CONFIG.PSU_MIO_29_DIRECTION {out} \
   CONFIG.PSU_MIO_29_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_29_POLARITY {Default} \
   CONFIG.PSU_MIO_2_DIRECTION {inout} \
   CONFIG.PSU_MIO_2_POLARITY {Default} \
   CONFIG.PSU_MIO_30_DIRECTION {in} \
   CONFIG.PSU_MIO_30_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_30_POLARITY {Default} \
   CONFIG.PSU_MIO_30_SLEW {fast} \
   CONFIG.PSU_MIO_31_DIRECTION {inout} \
   CONFIG.PSU_MIO_31_POLARITY {Default} \
   CONFIG.PSU_MIO_32_DIRECTION {inout} \
   CONFIG.PSU_MIO_32_POLARITY {Default} \
   CONFIG.PSU_MIO_33_DIRECTION {inout} \
   CONFIG.PSU_MIO_33_POLARITY {Default} \
   CONFIG.PSU_MIO_34_DIRECTION {inout} \
   CONFIG.PSU_MIO_34_POLARITY {Default} \
   CONFIG.PSU_MIO_35_DIRECTION {inout} \
   CONFIG.PSU_MIO_35_POLARITY {Default} \
   CONFIG.PSU_MIO_36_DIRECTION {inout} \
   CONFIG.PSU_MIO_36_POLARITY {Default} \
   CONFIG.PSU_MIO_37_DIRECTION {inout} \
   CONFIG.PSU_MIO_37_POLARITY {Default} \
   CONFIG.PSU_MIO_38_DIRECTION {inout} \
   CONFIG.PSU_MIO_38_POLARITY {Default} \
   CONFIG.PSU_MIO_39_DIRECTION {inout} \
   CONFIG.PSU_MIO_39_POLARITY {Default} \
   CONFIG.PSU_MIO_3_DIRECTION {inout} \
   CONFIG.PSU_MIO_3_POLARITY {Default} \
   CONFIG.PSU_MIO_40_DIRECTION {inout} \
   CONFIG.PSU_MIO_40_POLARITY {Default} \
   CONFIG.PSU_MIO_41_DIRECTION {inout} \
   CONFIG.PSU_MIO_41_POLARITY {Default} \
   CONFIG.PSU_MIO_42_DIRECTION {inout} \
   CONFIG.PSU_MIO_42_POLARITY {Default} \
   CONFIG.PSU_MIO_43_DIRECTION {inout} \
   CONFIG.PSU_MIO_43_POLARITY {Default} \
   CONFIG.PSU_MIO_44_DIRECTION {inout} \
   CONFIG.PSU_MIO_44_POLARITY {Default} \
   CONFIG.PSU_MIO_45_DIRECTION {in} \
   CONFIG.PSU_MIO_45_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_45_POLARITY {Default} \
   CONFIG.PSU_MIO_45_SLEW {fast} \
   CONFIG.PSU_MIO_46_DIRECTION {inout} \
   CONFIG.PSU_MIO_46_POLARITY {Default} \
   CONFIG.PSU_MIO_47_DIRECTION {inout} \
   CONFIG.PSU_MIO_47_POLARITY {Default} \
   CONFIG.PSU_MIO_48_DIRECTION {inout} \
   CONFIG.PSU_MIO_48_POLARITY {Default} \
   CONFIG.PSU_MIO_49_DIRECTION {inout} \
   CONFIG.PSU_MIO_49_POLARITY {Default} \
   CONFIG.PSU_MIO_4_DIRECTION {inout} \
   CONFIG.PSU_MIO_4_POLARITY {Default} \
   CONFIG.PSU_MIO_50_DIRECTION {inout} \
   CONFIG.PSU_MIO_50_POLARITY {Default} \
   CONFIG.PSU_MIO_51_DIRECTION {out} \
   CONFIG.PSU_MIO_51_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_51_POLARITY {Default} \
   CONFIG.PSU_MIO_52_DIRECTION {in} \
   CONFIG.PSU_MIO_52_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_52_POLARITY {Default} \
   CONFIG.PSU_MIO_52_SLEW {fast} \
   CONFIG.PSU_MIO_53_DIRECTION {in} \
   CONFIG.PSU_MIO_53_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_53_POLARITY {Default} \
   CONFIG.PSU_MIO_53_SLEW {fast} \
   CONFIG.PSU_MIO_54_DIRECTION {inout} \
   CONFIG.PSU_MIO_54_POLARITY {Default} \
   CONFIG.PSU_MIO_55_DIRECTION {in} \
   CONFIG.PSU_MIO_55_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_55_POLARITY {Default} \
   CONFIG.PSU_MIO_55_SLEW {fast} \
   CONFIG.PSU_MIO_56_DIRECTION {inout} \
   CONFIG.PSU_MIO_56_POLARITY {Default} \
   CONFIG.PSU_MIO_57_DIRECTION {inout} \
   CONFIG.PSU_MIO_57_POLARITY {Default} \
   CONFIG.PSU_MIO_58_DIRECTION {out} \
   CONFIG.PSU_MIO_58_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_58_POLARITY {Default} \
   CONFIG.PSU_MIO_59_DIRECTION {inout} \
   CONFIG.PSU_MIO_59_POLARITY {Default} \
   CONFIG.PSU_MIO_5_DIRECTION {out} \
   CONFIG.PSU_MIO_5_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_5_POLARITY {Default} \
   CONFIG.PSU_MIO_60_DIRECTION {inout} \
   CONFIG.PSU_MIO_60_POLARITY {Default} \
   CONFIG.PSU_MIO_61_DIRECTION {inout} \
   CONFIG.PSU_MIO_61_POLARITY {Default} \
   CONFIG.PSU_MIO_62_DIRECTION {inout} \
   CONFIG.PSU_MIO_62_POLARITY {Default} \
   CONFIG.PSU_MIO_63_DIRECTION {inout} \
   CONFIG.PSU_MIO_63_POLARITY {Default} \
   CONFIG.PSU_MIO_64_DIRECTION {out} \
   CONFIG.PSU_MIO_64_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_64_POLARITY {Default} \
   CONFIG.PSU_MIO_65_DIRECTION {out} \
   CONFIG.PSU_MIO_65_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_65_POLARITY {Default} \
   CONFIG.PSU_MIO_66_DIRECTION {out} \
   CONFIG.PSU_MIO_66_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_66_POLARITY {Default} \
   CONFIG.PSU_MIO_67_DIRECTION {out} \
   CONFIG.PSU_MIO_67_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_67_POLARITY {Default} \
   CONFIG.PSU_MIO_68_DIRECTION {out} \
   CONFIG.PSU_MIO_68_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_68_POLARITY {Default} \
   CONFIG.PSU_MIO_69_DIRECTION {out} \
   CONFIG.PSU_MIO_69_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_69_POLARITY {Default} \
   CONFIG.PSU_MIO_6_DIRECTION {out} \
   CONFIG.PSU_MIO_6_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_6_POLARITY {Default} \
   CONFIG.PSU_MIO_70_DIRECTION {in} \
   CONFIG.PSU_MIO_70_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_70_POLARITY {Default} \
   CONFIG.PSU_MIO_70_SLEW {fast} \
   CONFIG.PSU_MIO_71_DIRECTION {in} \
   CONFIG.PSU_MIO_71_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_71_POLARITY {Default} \
   CONFIG.PSU_MIO_71_SLEW {fast} \
   CONFIG.PSU_MIO_72_DIRECTION {in} \
   CONFIG.PSU_MIO_72_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_72_POLARITY {Default} \
   CONFIG.PSU_MIO_72_SLEW {fast} \
   CONFIG.PSU_MIO_73_DIRECTION {in} \
   CONFIG.PSU_MIO_73_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_73_POLARITY {Default} \
   CONFIG.PSU_MIO_73_SLEW {fast} \
   CONFIG.PSU_MIO_74_DIRECTION {in} \
   CONFIG.PSU_MIO_74_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_74_POLARITY {Default} \
   CONFIG.PSU_MIO_74_SLEW {fast} \
   CONFIG.PSU_MIO_75_DIRECTION {in} \
   CONFIG.PSU_MIO_75_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_75_POLARITY {Default} \
   CONFIG.PSU_MIO_75_SLEW {fast} \
   CONFIG.PSU_MIO_76_DIRECTION {out} \
   CONFIG.PSU_MIO_76_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_76_POLARITY {Default} \
   CONFIG.PSU_MIO_77_DIRECTION {inout} \
   CONFIG.PSU_MIO_77_POLARITY {Default} \
   CONFIG.PSU_MIO_7_DIRECTION {out} \
   CONFIG.PSU_MIO_7_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_7_POLARITY {Default} \
   CONFIG.PSU_MIO_8_DIRECTION {inout} \
   CONFIG.PSU_MIO_8_POLARITY {Default} \
   CONFIG.PSU_MIO_9_DIRECTION {inout} \
   CONFIG.PSU_MIO_9_POLARITY {Default} \
   CONFIG.PSU_MIO_TREE_PERIPHERALS {Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Feedback Clk#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#GPIO0 MIO#I2C 0#I2C 0#I2C 1#I2C 1#UART 0#UART 0#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#GPIO0 MIO#GPIO1 MIO#DPAUX#DPAUX#DPAUX#DPAUX#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#GPIO1 MIO#SD 1#SD 1#SD 1#SD 1#GPIO1 MIO#GPIO1 MIO#SD 1#SD 1#SD 1#SD 1#SD 1#SD 1#SD 1#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#MDIO 3#MDIO 3} \
   CONFIG.PSU_MIO_TREE_SIGNALS {sclk_out#miso_mo1#mo2#mo3#mosi_mi0#n_ss_out#clk_for_lpbk#n_ss_out_upper#mo_upper[0]#mo_upper[1]#mo_upper[2]#mo_upper[3]#sclk_out_upper#gpio0[13]#scl_out#sda_out#scl_out#sda_out#rxd#txd#gpio0[20]#gpio0[21]#gpio0[22]#gpio0[23]#gpio0[24]#gpio0[25]#gpio1[26]#dp_aux_data_out#dp_hot_plug_detect#dp_aux_data_oe#dp_aux_data_in#gpio1[31]#gpio1[32]#gpio1[33]#gpio1[34]#gpio1[35]#gpio1[36]#gpio1[37]#gpio1[38]#sdio1_data_out[4]#sdio1_data_out[5]#sdio1_data_out[6]#sdio1_data_out[7]#gpio1[43]#gpio1[44]#sdio1_cd_n#sdio1_data_out[0]#sdio1_data_out[1]#sdio1_data_out[2]#sdio1_data_out[3]#sdio1_cmd_out#sdio1_clk_out#ulpi_clk_in#ulpi_dir#ulpi_tx_data[2]#ulpi_nxt#ulpi_tx_data[0]#ulpi_tx_data[1]#ulpi_stp#ulpi_tx_data[3]#ulpi_tx_data[4]#ulpi_tx_data[5]#ulpi_tx_data[6]#ulpi_tx_data[7]#rgmii_tx_clk#rgmii_txd[0]#rgmii_txd[1]#rgmii_txd[2]#rgmii_txd[3]#rgmii_tx_ctl#rgmii_rx_clk#rgmii_rxd[0]#rgmii_rxd[1]#rgmii_rxd[2]#rgmii_rxd[3]#rgmii_rx_ctl#gem3_mdc#gem3_mdio_out} \
   CONFIG.PSU_SD1_INTERNAL_BUS_WIDTH {8} \
   CONFIG.PSU_USB3__DUAL_CLOCK_ENABLE {1} \
   CONFIG.PSU__ACT_DDR_FREQ_MHZ {1066.656006} \
   CONFIG.PSU__CAN1__GRP_CLK__ENABLE {0} \
   CONFIG.PSU__CAN1__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__ACT_FREQMHZ {1199.988037} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__DIVISOR0 {1} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__FREQMHZ {1200} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__SRCSEL {APLL} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__FBDIV {72} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRF_APB__APLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRF_APB__APLL_TO_LPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__ACT_FREQMHZ {249.997498} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__ACT_FREQMHZ {249.997498} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__ACT_FREQMHZ {533.328003} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__FREQMHZ {1067} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__ACT_FREQMHZ {599.994019} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__FREQMHZ {600} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__SRCSEL {APLL} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__FBDIV {64} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRF_APB__DPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRF_APB__DPLL_TO_LPD_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__ACT_FREQMHZ {24.999750} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRF_APB__DP_AUDIO__FRAC_ENABLED {0} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__ACT_FREQMHZ {26.785446} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__DIVISOR0 {14} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__ACT_FREQMHZ {299.997009} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__SRCSEL {VPLL} \
   CONFIG.PSU__CRF_APB__DP_VIDEO__FRAC_ENABLED {0} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__ACT_FREQMHZ {599.994019} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__FREQMHZ {600} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__SRCSEL {APLL} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__ACT_FREQMHZ {249.997498} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__ACT_FREQMHZ {533.328003} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__FREQMHZ {533.33} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__FBDIV {90} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRF_APB__VPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRF_APB__VPLL_TO_LPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__ACT_FREQMHZ {499.994995} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__AFI6_REF_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__ACT_FREQMHZ {49.999500} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__DIVISOR0 {30} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__ACT_FREQMHZ {499.994995} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__ACT_FREQMHZ {249.997498} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__DLL_REF_CTRL__ACT_FREQMHZ {1499.984985} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__ACT_FREQMHZ {124.998749} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__FREQMHZ {125} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__ACT_FREQMHZ {249.997498} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__FBDIV {90} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRL_APB__IOPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRL_APB__IOPLL_TO_FPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__ACT_FREQMHZ {249.997498} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__ACT_FREQMHZ {499.994995} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__NAND_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__NAND_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__ACT_FREQMHZ {187.498123} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__DIVISOR0 {8} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__FREQMHZ {200} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__ACT_FREQMHZ {249.997498} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__DIVISOR0 {4} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__DIVISOR0 {4} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__DIVISOR0 {4} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__ACT_FREQMHZ {124.998749} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__FREQMHZ {125} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__FBDIV {45} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRL_APB__RPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRL_APB__RPLL_TO_FPD_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__DIVISOR0 {7} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__ACT_FREQMHZ {187.498123} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__DIVISOR0 {8} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__FREQMHZ {200} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__DIVISOR0 {7} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__DIVISOR0 {7} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__ACT_FREQMHZ {249.997498} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__ACT_FREQMHZ {19.999800} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__DIVISOR0 {25} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__DIVISOR1 {3} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__FREQMHZ {20} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB3__ENABLE {1} \
   CONFIG.PSU__CSUPMU__PERIPHERAL__VALID {1} \
   CONFIG.PSU__DDRC__ADDR_MIRROR {0} \
   CONFIG.PSU__DDRC__BANK_ADDR_COUNT {2} \
   CONFIG.PSU__DDRC__BG_ADDR_COUNT {1} \
   CONFIG.PSU__DDRC__BRC_MAPPING {ROW_BANK_COL} \
   CONFIG.PSU__DDRC__BUS_WIDTH {64 Bit} \
   CONFIG.PSU__DDRC__CL {15} \
   CONFIG.PSU__DDRC__CLOCK_STOP_EN {0} \
   CONFIG.PSU__DDRC__COL_ADDR_COUNT {10} \
   CONFIG.PSU__DDRC__COMPONENTS {UDIMM} \
   CONFIG.PSU__DDRC__CWL {14} \
   CONFIG.PSU__DDRC__DDR3L_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__DDR3_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__DDR4_ADDR_MAPPING {0} \
   CONFIG.PSU__DDRC__DDR4_CAL_MODE_ENABLE {0} \
   CONFIG.PSU__DDRC__DDR4_CRC_CONTROL {0} \
   CONFIG.PSU__DDRC__DDR4_T_REF_MODE {0} \
   CONFIG.PSU__DDRC__DDR4_T_REF_RANGE {Normal (0-85)} \
   CONFIG.PSU__DDRC__DEEP_PWR_DOWN_EN {0} \
   CONFIG.PSU__DDRC__DEVICE_CAPACITY {8192 MBits} \
   CONFIG.PSU__DDRC__DIMM_ADDR_MIRROR {0} \
   CONFIG.PSU__DDRC__DM_DBI {DM_NO_DBI} \
   CONFIG.PSU__DDRC__DQMAP_0_3 {0} \
   CONFIG.PSU__DDRC__DQMAP_12_15 {0} \
   CONFIG.PSU__DDRC__DQMAP_16_19 {0} \
   CONFIG.PSU__DDRC__DQMAP_20_23 {0} \
   CONFIG.PSU__DDRC__DQMAP_24_27 {0} \
   CONFIG.PSU__DDRC__DQMAP_28_31 {0} \
   CONFIG.PSU__DDRC__DQMAP_32_35 {0} \
   CONFIG.PSU__DDRC__DQMAP_36_39 {0} \
   CONFIG.PSU__DDRC__DQMAP_40_43 {0} \
   CONFIG.PSU__DDRC__DQMAP_44_47 {0} \
   CONFIG.PSU__DDRC__DQMAP_48_51 {0} \
   CONFIG.PSU__DDRC__DQMAP_4_7 {0} \
   CONFIG.PSU__DDRC__DQMAP_52_55 {0} \
   CONFIG.PSU__DDRC__DQMAP_56_59 {0} \
   CONFIG.PSU__DDRC__DQMAP_60_63 {0} \
   CONFIG.PSU__DDRC__DQMAP_64_67 {0} \
   CONFIG.PSU__DDRC__DQMAP_68_71 {0} \
   CONFIG.PSU__DDRC__DQMAP_8_11 {0} \
   CONFIG.PSU__DDRC__DRAM_WIDTH {16 Bits} \
   CONFIG.PSU__DDRC__ECC {Disabled} \
   CONFIG.PSU__DDRC__ENABLE_LP4_HAS_ECC_COMP {0} \
   CONFIG.PSU__DDRC__ENABLE_LP4_SLOWBOOT {0} \
   CONFIG.PSU__DDRC__FGRM {1X} \
   CONFIG.PSU__DDRC__LPDDR3_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__LPDDR4_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__LP_ASR {manual normal} \
   CONFIG.PSU__DDRC__MEMORY_TYPE {DDR 4} \
   CONFIG.PSU__DDRC__PARITY_ENABLE {0} \
   CONFIG.PSU__DDRC__PER_BANK_REFRESH {0} \
   CONFIG.PSU__DDRC__PHY_DBI_MODE {0} \
   CONFIG.PSU__DDRC__RANK_ADDR_COUNT {0} \
   CONFIG.PSU__DDRC__ROW_ADDR_COUNT {16} \
   CONFIG.PSU__DDRC__SB_TARGET {15-15-15} \
   CONFIG.PSU__DDRC__SELF_REF_ABORT {0} \
   CONFIG.PSU__DDRC__SPEED_BIN {DDR4_2133P} \
   CONFIG.PSU__DDRC__STATIC_RD_MODE {0} \
   CONFIG.PSU__DDRC__TRAIN_DATA_EYE {1} \
   CONFIG.PSU__DDRC__TRAIN_READ_GATE {1} \
   CONFIG.PSU__DDRC__TRAIN_WRITE_LEVEL {1} \
   CONFIG.PSU__DDRC__T_FAW {30.0} \
   CONFIG.PSU__DDRC__T_RAS_MIN {33} \
   CONFIG.PSU__DDRC__T_RC {47.06} \
   CONFIG.PSU__DDRC__T_RCD {15} \
   CONFIG.PSU__DDRC__T_RP {15} \
   CONFIG.PSU__DDRC__VENDOR_PART {OTHERS} \
   CONFIG.PSU__DDRC__VREF {1} \
   CONFIG.PSU__DDR_HIGH_ADDRESS_GUI_ENABLE {1} \
   CONFIG.PSU__DDR__INTERFACE__FREQMHZ {533.500} \
   CONFIG.PSU__DISPLAYPORT__LANE0__ENABLE {1} \
   CONFIG.PSU__DISPLAYPORT__LANE0__IO {GT Lane1} \
   CONFIG.PSU__DISPLAYPORT__LANE1__ENABLE {1} \
   CONFIG.PSU__DISPLAYPORT__LANE1__IO {GT Lane0} \
   CONFIG.PSU__DISPLAYPORT__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__DLL__ISUSED {1} \
   CONFIG.PSU__DPAUX__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__DPAUX__PERIPHERAL__IO {MIO 27 .. 30} \
   CONFIG.PSU__DP__LANE_SEL {Dual Lower} \
   CONFIG.PSU__DP__REF_CLK_FREQ {27} \
   CONFIG.PSU__DP__REF_CLK_SEL {Ref Clk1} \
   CONFIG.PSU__ENET3__FIFO__ENABLE {0} \
   CONFIG.PSU__ENET3__GRP_MDIO__ENABLE {1} \
   CONFIG.PSU__ENET3__GRP_MDIO__IO {MIO 76 .. 77} \
   CONFIG.PSU__ENET3__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__ENET3__PERIPHERAL__IO {MIO 64 .. 75} \
   CONFIG.PSU__ENET3__PTP__ENABLE {0} \
   CONFIG.PSU__ENET3__TSU__ENABLE {0} \
   CONFIG.PSU__FPDMASTERS_COHERENCY {0} \
   CONFIG.PSU__FPD_SLCR__WDT1__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__FPD_SLCR__WDT1__FREQMHZ {99.999001} \
   CONFIG.PSU__FPD_SLCR__WDT_CLK_SEL__SELECT {APB} \
   CONFIG.PSU__FPGA_PL0_ENABLE {1} \
   CONFIG.PSU__GEM3_COHERENCY {0} \
   CONFIG.PSU__GEM3_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__GEM__TSU__ENABLE {0} \
   CONFIG.PSU__GPIO0_MIO__IO {MIO 0 .. 25} \
   CONFIG.PSU__GPIO0_MIO__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__GPIO1_MIO__IO {MIO 26 .. 51} \
   CONFIG.PSU__GPIO1_MIO__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__GT__LINK_SPEED {HBR} \
   CONFIG.PSU__GT__PRE_EMPH_LVL_4 {0} \
   CONFIG.PSU__GT__VLT_SWNG_LVL_4 {0} \
   CONFIG.PSU__HIGH_ADDRESS__ENABLE {1} \
   CONFIG.PSU__I2C0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__I2C0__PERIPHERAL__IO {MIO 14 .. 15} \
   CONFIG.PSU__I2C1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__I2C1__PERIPHERAL__IO {MIO 16 .. 17} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC0_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC1_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC2_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC3_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__TTC0__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC0__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC1__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC1__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC2__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC2__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC3__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC3__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__WDT0__ACT_FREQMHZ {99.999001} \
   CONFIG.PSU__IOU_SLCR__WDT0__FREQMHZ {99.999001} \
   CONFIG.PSU__IOU_SLCR__WDT_CLK_SEL__SELECT {APB} \
   CONFIG.PSU__LPD_SLCR__CSUPMU__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__LPD_SLCR__CSUPMU__FREQMHZ {100.000000} \
   CONFIG.PSU__MAXIGP0__DATA_WIDTH {128} \
   CONFIG.PSU__MAXIGP1__DATA_WIDTH {128} \
   CONFIG.PSU__MAXIGP2__DATA_WIDTH {32} \
   CONFIG.PSU__OVERRIDE__BASIC_CLOCK {0} \
   CONFIG.PSU__PL_CLK0_BUF {TRUE} \
   CONFIG.PSU__PMU_COHERENCY {0} \
   CONFIG.PSU__PMU__AIBACK__ENABLE {0} \
   CONFIG.PSU__PMU__EMIO_GPI__ENABLE {0} \
   CONFIG.PSU__PMU__EMIO_GPO__ENABLE {0} \
   CONFIG.PSU__PMU__GPI0__ENABLE {0} \
   CONFIG.PSU__PMU__GPI1__ENABLE {0} \
   CONFIG.PSU__PMU__GPI2__ENABLE {0} \
   CONFIG.PSU__PMU__GPI3__ENABLE {0} \
   CONFIG.PSU__PMU__GPI4__ENABLE {0} \
   CONFIG.PSU__PMU__GPI5__ENABLE {0} \
   CONFIG.PSU__PMU__GPO0__ENABLE {0} \
   CONFIG.PSU__PMU__GPO1__ENABLE {0} \
   CONFIG.PSU__PMU__GPO2__ENABLE {0} \
   CONFIG.PSU__PMU__GPO3__ENABLE {0} \
   CONFIG.PSU__PMU__GPO4__ENABLE {0} \
   CONFIG.PSU__PMU__GPO5__ENABLE {0} \
   CONFIG.PSU__PMU__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__PMU__PLERROR__ENABLE {0} \
   CONFIG.PSU__PRESET_APPLIED {1} \
   CONFIG.PSU__PROTECTION__MASTERS {USB1:NonSecure;0|USB0:NonSecure;1|S_AXI_LPD:NA;0|S_AXI_HPC1_FPD:NA;0|S_AXI_HPC0_FPD:NA;0|S_AXI_HP3_FPD:NA;0|S_AXI_HP2_FPD:NA;0|S_AXI_HP1_FPD:NA;0|S_AXI_HP0_FPD:NA;0|S_AXI_ACP:NA;0|S_AXI_ACE:NA;0|SD1:NonSecure;1|SD0:NonSecure;0|SATA1:NonSecure;1|SATA0:NonSecure;1|RPU1:Secure;1|RPU0:Secure;1|QSPI:NonSecure;1|PMU:NA;1|PCIe:NonSecure;0|NAND:NonSecure;0|LDMA:NonSecure;1|GPU:NonSecure;1|GEM3:NonSecure;1|GEM2:NonSecure;0|GEM1:NonSecure;0|GEM0:NonSecure;0|FDMA:NonSecure;1|DP:NonSecure;1|DAP:NA;1|Coresight:NA;1|CSU:NA;1|APU:NA;1} \
   CONFIG.PSU__PROTECTION__SLAVES { \
     LPD;USB3_1_XHCI;FE300000;FE3FFFFF;0|LPD;USB3_1;FF9E0000;FF9EFFFF;0|LPD;USB3_0_XHCI;FE200000;FE2FFFFF;1|LPD;USB3_0;FF9D0000;FF9DFFFF;1|LPD;UART1;FF010000;FF01FFFF;0|LPD;UART0;FF000000;FF00FFFF;1|LPD;TTC3;FF140000;FF14FFFF;1|LPD;TTC2;FF130000;FF13FFFF;1|LPD;TTC1;FF120000;FF12FFFF;1|LPD;TTC0;FF110000;FF11FFFF;1|FPD;SWDT1;FD4D0000;FD4DFFFF;1|LPD;SWDT0;FF150000;FF15FFFF;1|LPD;SPI1;FF050000;FF05FFFF;0|LPD;SPI0;FF040000;FF04FFFF;0|FPD;SMMU_REG;FD5F0000;FD5FFFFF;1|FPD;SMMU;FD800000;FDFFFFFF;1|FPD;SIOU;FD3D0000;FD3DFFFF;1|FPD;SERDES;FD400000;FD47FFFF;1|LPD;SD1;FF170000;FF17FFFF;1|LPD;SD0;FF160000;FF16FFFF;0|FPD;SATA;FD0C0000;FD0CFFFF;1|LPD;RTC;FFA60000;FFA6FFFF;1|LPD;RSA_CORE;FFCE0000;FFCEFFFF;1|LPD;RPU;FF9A0000;FF9AFFFF;1|LPD;R5_TCM_RAM_GLOBAL;FFE00000;FFE3FFFF;1|LPD;R5_1_Instruction_Cache;FFEC0000;FFECFFFF;1|LPD;R5_1_Data_Cache;FFED0000;FFEDFFFF;1|LPD;R5_1_BTCM_GLOBAL;FFEB0000;FFEBFFFF;1|LPD;R5_1_ATCM_GLOBAL;FFE90000;FFE9FFFF;1|LPD;R5_0_Instruction_Cache;FFE40000;FFE4FFFF;1|LPD;R5_0_Data_Cache;FFE50000;FFE5FFFF;1|LPD;R5_0_BTCM_GLOBAL;FFE20000;FFE2FFFF;1|LPD;R5_0_ATCM_GLOBAL;FFE00000;FFE0FFFF;1|LPD;QSPI_Linear_Address;C0000000;DFFFFFFF;1|LPD;QSPI;FF0F0000;FF0FFFFF;1|LPD;PMU_RAM;FFDC0000;FFDDFFFF;1|LPD;PMU_GLOBAL;FFD80000;FFDBFFFF;1|FPD;PCIE_MAIN;FD0E0000;FD0EFFFF;0|FPD;PCIE_LOW;E0000000;EFFFFFFF;0|FPD;PCIE_HIGH2;8000000000;BFFFFFFFFF;0|FPD;PCIE_HIGH1;600000000;7FFFFFFFF;0|FPD;PCIE_DMA;FD0F0000;FD0FFFFF;0|FPD;PCIE_ATTRIB;FD480000;FD48FFFF;0|LPD;OCM_XMPU_CFG;FFA70000;FFA7FFFF;1|LPD;OCM_SLCR;FF960000;FF96FFFF;1|OCM;OCM;FFFC0000;FFFFFFFF;1|LPD;NAND;FF100000;FF10FFFF;0|LPD;MBISTJTAG;FFCF0000;FFCFFFFF;1|LPD;LPD_XPPU_SINK;FF9C0000;FF9CFFFF;1|LPD;LPD_XPPU;FF980000;FF98FFFF;1|LPD;LPD_SLCR_SECURE;FF4B0000;FF4DFFFF;1|LPD;LPD_SLCR;FF410000;FF4AFFFF;1|LPD;LPD_GPV;FE100000;FE1FFFFF;1|LPD;LPD_DMA_7;FFAF0000;FFAFFFFF;1|LPD;LPD_DMA_6;FFAE0000;FFAEFFFF;1|LPD;LPD_DMA_5;FFAD0000;FFADFFFF;1|LPD;LPD_DMA_4;FFAC0000;FFACFFFF;1|LPD;LPD_DMA_3;FFAB0000;FFABFFFF;1|LPD;LPD_DMA_2;FFAA0000;FFAAFFFF;1|LPD;LPD_DMA_1;FFA90000;FFA9FFFF;1|LPD;LPD_DMA_0;FFA80000;FFA8FFFF;1|LPD;IPI_CTRL;FF380000;FF3FFFFF;1|LPD;IOU_SLCR;FF180000;FF23FFFF;1|LPD;IOU_SECURE_SLCR;FF240000;FF24FFFF;1|LPD;IOU_SCNTRS;FF260000;FF26FFFF;1|LPD;IOU_SCNTR;FF250000;FF25FFFF;1|LPD;IOU_GPV;FE000000;FE0FFFFF;1|LPD;I2C1;FF030000;FF03FFFF;1|LPD;I2C0;FF020000;FF02FFFF;1|FPD;GPU;FD4B0000;FD4BFFFF;0|LPD;GPIO;FF0A0000;FF0AFFFF;1|LPD;GEM3;FF0E0000;FF0EFFFF;1|LPD;GEM2;FF0D0000;FF0DFFFF;0|LPD;GEM1;FF0C0000;FF0CFFFF;0|LPD;GEM0;FF0B0000;FF0BFFFF;0|FPD;FPD_XMPU_SINK;FD4F0000;FD4FFFFF;1|FPD;FPD_XMPU_CFG;FD5D0000;FD5DFFFF;1|FPD;FPD_SLCR_SECURE;FD690000;FD6CFFFF;1|FPD;FPD_SLCR;FD610000;FD68FFFF;1|FPD;FPD_DMA_CH7;FD570000;FD57FFFF;1|FPD;FPD_DMA_CH6;FD560000;FD56FFFF;1|FPD;FPD_DMA_CH5;FD550000;FD55FFFF;1|FPD;FPD_DMA_CH4;FD540000;FD54FFFF;1|FPD;FPD_DMA_CH3;FD530000;FD53FFFF;1|FPD;FPD_DMA_CH2;FD520000;FD52FFFF;1|FPD;FPD_DMA_CH1;FD510000;FD51FFFF;1|FPD;FPD_DMA_CH0;FD500000;FD50FFFF;1|LPD;EFUSE;FFCC0000;FFCCFFFF;1|FPD;Display Port;FD4A0000;FD4AFFFF;1|FPD;DPDMA;FD4C0000;FD4CFFFF;1|FPD;DDR_XMPU5_CFG;FD050000;FD05FFFF;1|FPD;DDR_XMPU4_CFG;FD040000;FD04FFFF;1|FPD;DDR_XMPU3_CFG;FD030000;FD03FFFF;1|FPD;DDR_XMPU2_CFG;FD020000;FD02FFFF;1|FPD;DDR_XMPU1_CFG;FD010000;FD01FFFF;1|FPD;DDR_XMPU0_CFG;FD000000;FD00FFFF;1|FPD;DDR_QOS_CTRL;FD090000;FD09FFFF;1|FPD;DDR_PHY;FD080000;FD08FFFF;1|DDR;DDR_LOW;0;7FFFFFFF;1|DDR;DDR_HIGH;800000000;87FFFFFFF;1|FPD;DDDR_CTRL;FD070000;FD070FFF;1|LPD;Coresight;FE800000;FEFFFFFF;1|LPD;CSU_DMA;FFC80000;FFC9FFFF;1|LPD;CSU;FFCA0000;FFCAFFFF;1|LPD;CRL_APB;FF5E0000;FF85FFFF;1|FPD;CRF_APB;FD1A0000;FD2DFFFF;1|FPD;CCI_REG;FD5E0000;FD5EFFFF;1|LPD;CAN1;FF070000;FF07FFFF;0|LPD;CAN0;FF060000;FF06FFFF;0|FPD;APU;FD5C0000;FD5CFFFF;1|LPD;APM_INTC_IOU;FFA20000;FFA2FFFF;1|LPD;APM_FPD_LPD;FFA30000;FFA3FFFF;1|FPD;APM_5;FD490000;FD49FFFF;1|FPD;APM_0;FD0B0000;FD0BFFFF;1|LPD;APM2;FFA10000;FFA1FFFF;1|LPD;APM1;FFA00000;FFA0FFFF;1|LPD;AMS;FFA50000;FFA5FFFF;1|FPD;AFI_5;FD3B0000;FD3BFFFF;1|FPD;AFI_4;FD3A0000;FD3AFFFF;1|FPD;AFI_3;FD390000;FD39FFFF;1|FPD;AFI_2;FD380000;FD38FFFF;1|FPD;AFI_1;FD370000;FD37FFFF;1|FPD;AFI_0;FD360000;FD36FFFF;1|LPD;AFIFM6;FF9B0000;FF9BFFFF;1|FPD;ACPU_GIC;F9010000;F907FFFF;1 \
   } \
   CONFIG.PSU__PSS_REF_CLK__FREQMHZ {33.333} \
   CONFIG.PSU__QSPI_COHERENCY {0} \
   CONFIG.PSU__QSPI_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__QSPI__GRP_FBCLK__ENABLE {1} \
   CONFIG.PSU__QSPI__GRP_FBCLK__IO {MIO 6} \
   CONFIG.PSU__QSPI__PERIPHERAL__DATA_MODE {x4} \
   CONFIG.PSU__QSPI__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__QSPI__PERIPHERAL__IO {MIO 0 .. 12} \
   CONFIG.PSU__QSPI__PERIPHERAL__MODE {Dual Parallel} \
   CONFIG.PSU__SATA__LANE0__ENABLE {0} \
   CONFIG.PSU__SATA__LANE1__ENABLE {1} \
   CONFIG.PSU__SATA__LANE1__IO {GT Lane3} \
   CONFIG.PSU__SATA__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SATA__REF_CLK_FREQ {125} \
   CONFIG.PSU__SATA__REF_CLK_SEL {Ref Clk3} \
   CONFIG.PSU__SD1_COHERENCY {0} \
   CONFIG.PSU__SD1_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__SD1__DATA_TRANSFER_MODE {8Bit} \
   CONFIG.PSU__SD1__GRP_CD__ENABLE {1} \
   CONFIG.PSU__SD1__GRP_CD__IO {MIO 45} \
   CONFIG.PSU__SD1__GRP_POW__ENABLE {0} \
   CONFIG.PSU__SD1__GRP_WP__ENABLE {0} \
   CONFIG.PSU__SD1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SD1__PERIPHERAL__IO {MIO 39 .. 51} \
   CONFIG.PSU__SD1__RESET__ENABLE {0} \
   CONFIG.PSU__SD1__SLOT_TYPE {SD 3.0} \
   CONFIG.PSU__SWDT0__CLOCK__ENABLE {0} \
   CONFIG.PSU__SWDT0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SWDT0__RESET__ENABLE {0} \
   CONFIG.PSU__SWDT1__CLOCK__ENABLE {0} \
   CONFIG.PSU__SWDT1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SWDT1__RESET__ENABLE {0} \
   CONFIG.PSU__TSU__BUFG_PORT_PAIR {0} \
   CONFIG.PSU__TTC0__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC0__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__TTC1__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC1__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__TTC2__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC2__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC2__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__TTC3__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC3__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC3__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__UART0__BAUD_RATE {115200} \
   CONFIG.PSU__UART0__MODEM__ENABLE {0} \
   CONFIG.PSU__UART0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__UART0__PERIPHERAL__IO {MIO 18 .. 19} \
   CONFIG.PSU__UART1__BAUD_RATE {<Select>} \
   CONFIG.PSU__UART1__MODEM__ENABLE {0} \
   CONFIG.PSU__UART1__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__UART1__PERIPHERAL__IO {<Select>} \
   CONFIG.PSU__USB0_COHERENCY {0} \
   CONFIG.PSU__USB0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__USB0__PERIPHERAL__IO {MIO 52 .. 63} \
   CONFIG.PSU__USB0__REF_CLK_FREQ {26} \
   CONFIG.PSU__USB0__REF_CLK_SEL {Ref Clk2} \
   CONFIG.PSU__USB0__RESET__ENABLE {0} \
   CONFIG.PSU__USB1__RESET__ENABLE {0} \
   CONFIG.PSU__USB2_0__EMIO__ENABLE {0} \
   CONFIG.PSU__USB3_0__EMIO__ENABLE {0} \
   CONFIG.PSU__USB3_0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__USB3_0__PERIPHERAL__IO {GT Lane2} \
   CONFIG.PSU__USB__RESET__MODE {Boot Pin} \
   CONFIG.PSU__USB__RESET__POLARITY {Active Low} \
   CONFIG.PSU__USE__IRQ0 {0} \
   CONFIG.PSU__USE__M_AXI_GP0 {1} \
   CONFIG.PSU__USE__M_AXI_GP1 {0} \
   CONFIG.PSU__USE__M_AXI_GP2 {0} \
   CONFIG.SUBPRESET1 {Custom} \
 ] $zynq_ultra_ps_e_0
        """
        
        tcl_code += """
connect_bd_intf_net -intf_net AXI_Buffer_0_m_axi [get_bd_intf_pins AXI_Buffer_0/m_axi] [get_bd_intf_pins axi_interconnect_0/S00_AXI]
connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins usp_rf_data_converter_0/s_axi]
connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins TimeController_0/s_axi] [get_bd_intf_pins axi_interconnect_0/M01_AXI]
connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_M_AXI_HPM0_FPD [get_bd_intf_pins AXI_Buffer_0/s_axi] [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_FPD]
        """
        
        tcl_code += '\n'
        
        for i in range(self.total_dac_num):
            if i < 4:
                tcl_code += f'connect_bd_intf_net -intf_net DAC_Controller_{i}_m00_axis [get_bd_intf_pins DAC_Controller_{i}/m00_axis] [get_bd_intf_pins usp_rf_data_converter_0/s0{i}_axis]\n'
            else:
                tcl_code += f'connect_bd_intf_net -intf_net DAC_Controller_{i}_m00_axis [get_bd_intf_pins DAC_Controller_{i}/m00_axis] [get_bd_intf_pins usp_rf_data_converter_0/s1{i-4}_axis]\n'
        
        tcl_code += '\n'
        for i in range(self.total_dac_num):
            tcl_code += f'connect_bd_intf_net -intf_net axi_interconnect_0_M0{i+2}_AXI [get_bd_intf_pins DAC_Controller_{i}/s_axi] [get_bd_intf_pins axi_interconnect_0/M0{i+2}_AXI]\n'
        

        tcl_code += """
# Create port connections
connect_bd_net -net RF3_CLKO_A_C_N_1 [get_bd_ports RF3_CLKO_A_C_N_228] [get_bd_pins usp_rf_data_converter_0/dac0_clk_n]
connect_bd_net -net RF3_CLKO_A_C_N_2 [get_bd_ports RF3_CLKO_A_C_N_229] [get_bd_pins usp_rf_data_converter_0/dac1_clk_n]
connect_bd_net -net RF3_CLKO_A_C_P_1 [get_bd_ports RF3_CLKO_A_C_P_228] [get_bd_pins usp_rf_data_converter_0/dac0_clk_p]
connect_bd_net -net RF3_CLKO_A_C_P_2 [get_bd_ports RF3_CLKO_A_C_P_229] [get_bd_pins usp_rf_data_converter_0/dac1_clk_p]
        """
        
        #Vivado makes replica of register to resolve high fan problem. So you don't have to consider high fan problem in auto_start, and coutner.
        tcl_code += '\n'
        tcl_code += 'connect_bd_net -net TimeController_0_auto_start'
        for i in range(self.total_dac_num):
            tcl_code += f' [get_bd_pins DAC_Controller_{i}/auto_start]'
        tcl_code += ' [get_bd_pins TimeController_0/auto_start]\n'
        
        tcl_code += 'connect_bd_net -net TimeController_0_counter'
        for i in range(self.total_dac_num):
            tcl_code += f' [get_bd_pins DAC_Controller_{i}/counter]'
        tcl_code += ' [get_bd_pins TimeController_0/counter]\n'
        
        tcl_code += 'connect_bd_net -net proc_sys_reset_0_peripheral_aresetn'
        for i in range(self.total_dac_num):
            tcl_code += f' [get_bd_pins DAC_Controller_{i}/s_axi_aresetn]'
        tcl_code += ' [get_bd_pins TimeController_0/s_axi_aresetn] [get_bd_pins axi_interconnect_0/ARESETN] \
[get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] \
[get_bd_pins AXI_Buffer_0/m_axi_aresetn] [get_bd_pins AXI_Buffer_0/s_axi_aresetn] '
        for i in range(self.total_dac_num):
            tcl_code += f' [get_bd_pins axi_interconnect_0/M0{i+2}_ARESETN]'
        tcl_code += ' [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins usp_rf_data_converter_0/s0_axis_aresetn] [get_bd_pins usp_rf_data_converter_0/s1_axis_aresetn] [get_bd_pins usp_rf_data_converter_0/s_axi_aresetn] '
        tcl_code += '\n'
        
        for i in range(self.total_dac_num):
            if i < 4:
                tcl_code += f'connect_bd_net -net usp_rf_data_converter_0_vout0{i}_n [get_bd_ports RFMC_DAC_0{i}_N] [get_bd_pins usp_rf_data_converter_0/vout0{i}_n]\n'
                tcl_code += f'connect_bd_net -net usp_rf_data_converter_0_vout0{i}_p [get_bd_ports RFMC_DAC_0{i}_P] [get_bd_pins usp_rf_data_converter_0/vout0{i}_p]\n'
            else:
                tcl_code += f'connect_bd_net -net usp_rf_data_converter_0_vout1{i-4}_n [get_bd_ports RFMC_DAC_0{i}_N] [get_bd_pins usp_rf_data_converter_0/vout1{i-4}_n]\n'
                tcl_code += f'connect_bd_net -net usp_rf_data_converter_0_vout1{i-4}_p [get_bd_ports RFMC_DAC_0{i}_P] [get_bd_pins usp_rf_data_converter_0/vout1{i-4}_p]\n'
                
        tcl_code += 'connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 '
        for i in range(self.total_dac_num):
            tcl_code += f' [get_bd_pins DAC_Controller_{i}/m00_axis_aclk] [get_bd_pins DAC_Controller_{i}/s_axi_aclk] [get_bd_pins axi_interconnect_0/M0{i+2}_ACLK]'
        tcl_code += """ [get_bd_pins AXI_Buffer_0/m_axi_aclk] [get_bd_pins AXI_Buffer_0/s_axi_aclk] [get_bd_pins TimeController_0/s_axi_aclk]\
 [get_bd_pins axi_interconnect_0/ACLK]\
 [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK]\
 [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins usp_rf_data_converter_0/s0_axis_aclk] [get_bd_pins usp_rf_data_converter_0/s1_axis_aclk]\
 [get_bd_pins usp_rf_data_converter_0/s_axi_aclk] [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
        """
        
        tcl_code += '\n'
        tcl_code += 'connect_bd_net -net zynq_ultra_ps_e_0_pl_resetn0 [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]\n'
        
        
#         for i in range(self.total_dac_num):
#             tcl_code += f'assign_bd_address -offset 0xA000{i}000 -range 0x00001000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs DAC_Controller_{i}/s_axi/reg0] -force\n'
#         tcl_code += """
# assign_bd_address -offset 0xA0008000 -range 0x00001000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs TimeController_0/s_axi/reg0] -force
# assign_bd_address -offset 0xA00C0000 -range 0x00040000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs usp_rf_data_converter_0/s_axi/Reg] -force
#         """
        for i in range(self.total_dac_num):
            tcl_code += f'assign_bd_address -offset 0x44A{i}0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces AXI_Buffer_0/m_axi] [get_bd_addr_segs DAC_Controller_{i}/s_axi/reg0] -force\n'
        tcl_code += """
assign_bd_address -offset 0x44A80000 -range 0x00010000 -target_address_space [get_bd_addr_spaces AXI_Buffer_0/m_axi] [get_bd_addr_segs TimeController_0/s_axi/reg0] -force
assign_bd_address -offset 0x44AC0000 -range 0x00040000 -target_address_space [get_bd_addr_spaces AXI_Buffer_0/m_axi] [get_bd_addr_segs usp_rf_data_converter_0/s_axi/Reg] -force
assign_bd_address -offset 0x002000000000 -range 0x002000000000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs AXI_Buffer_0/s_axi/reg0] -force
        """
        
        tcl_code += '\n'
        
        #using '\' makes error in vivado.bat. this should be replaced in '/'
        tcl_code = tcl_code.replace("\\","/")
        
        return tcl_code
            
    def generate_custom_dac_controller(self, folder_directory, num):
        tcl_code = ''
        tcl_code += f'create_ip -dir {folder_directory} -name DAC_Controller -vendor xilinx.com -library user -version 1.0 -module_name DAC_Controller_{num}\n'
        
        #using '\' makes error in vivado.bat. this should be replaced in '/'
        tcl_code = tcl_code.replace("\\","/")
        
        return tcl_code
    
    def generate_custom_time_controller(self,folder_directory):
        tcl_code = ''
        tcl_code += f'create_ip -dir {folder_directory} -name TimeController -vendor xilinx.com -library user -version 1.0 -module_name TimeController\n'
        
        #using '\' makes error in vivado.bat. this should be replaced in '/'
        tcl_code = tcl_code.replace("\\","/")
        
        return tcl_code
    
    def generate_custom_axi_buffer(self,folder_directory):
        tcl_code = ''
        tcl_code += f'create_ip -dir {folder_directory} -name AxiBuffer -vendor xilinx.com -library user -version 1.0 -module_name AxiBuffer\n'
        
        #using '\' makes error in vivado.bat. this should be replaced in '/'
        tcl_code = tcl_code.replace("\\","/")
        
        return tcl_code
        
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
            
    def run(self):
        for i in range(self.total_dac_num):
            self.generate_indexed_dac_controller(i)
        self.generate_time_controller()
        self.generate_axi_buffer()
        self.generate_RFSoC_main()
        
    
            
if __name__ == "__main__":
    vm = Verilog_maker()
    vm.run()