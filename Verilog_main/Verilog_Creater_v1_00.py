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
from pathlib import Path

POSSIBLE_FIFO_DEPTH = [512, 1024, 2048, 4096, 8192, 16384, 32768, 65536, 131072]

class Verilog_maker:
    def __init__(self):
        print('make verilog code...')
        # self.git_dir = 'E:\RFSoC\GIT'
        self.git_dir = 'C:\Jeonghyun\GIT'
        self.target_dir = 'RFSoC\RFSoC_Design_V1_1\IP_File_01'
        self.cpu_type = 'Zynq_APU_0_125MHz.tcl'
        # self.vivado_path = r"E:\Xilinx\Vivado\2020.2\bin\vivado.bat"
        self.vivado_path = r"C:\Xilinx\Vivado\2020.2\bin\vivado.bat"
        
        # self.board_path = "E:/Xilinx/Vivado/2020.2/data/boards/board_files"
        self.board_path = "C:/Xilinx/Vivado/2020.2/data/boards/board_files"
        self.part_name = "xczu28dr-ffvg1517-2-e"
        self.board_name = "xilinx.com:zcu111:part0:1.4"
        
        self.fifo_generator_list = []
        self.dds_compiler_list = []
        self.rf_converter_list = []
        
        self.dac_controller_dir =  os.path.join(self.target_dir, 'DAC_Controller')
        self.dac_controller_modules = ['DAC_Controller', 'AXI2FIFO', 'DDS_Controller', 'GPO_Core', 'RFDC_DDS', 'RTO_Core']
        #Number of total dac controller number
        self.total_dac_num = 8
        
        self.time_controller_dir = os.path.join(self.target_dir,'TimeController')
        
        self.time_controller_buffer_dir = os.path.join(self.target_dir, 'TimeControllerBuffer')
        
        self.RFSoC_Main_dir = os.path.join(self.target_dir,'RFSoC_Main')
        
        self.AXI_Buffer_dir = os.path.join(self.target_dir,'AXI_Buffer')
        
        self.TTLx8_out_dir = os.path.join(self.target_dir,'TTLx8_out')
        
        self.TTL_out_dir = os.path.join(self.target_dir,'TTL_out')
        
        self.EdgeCounter_dir = os.path.join(self.target_dir,'EdgeCounter')
        
        self.TTLx8_ports = ['FMCP_HSPC_LA00_CC',\
        'FMCP_HSPC_LA01_CC',\
        'FMCP_HSPC_LA02',\
        'FMCP_HSPC_LA03',\
        'FMCP_HSPC_LA04',\
        'FMCP_HSPC_LA05',\
        'FMCP_HSPC_LA06',\
        'FMCP_HSPC_LA07',\
        'FMCP_HSPC_LA08',\
        'FMCP_HSPC_LA09',\
        'FMCP_HSPC_LA10',\
        'FMCP_HSPC_LA11',\
        'FMCP_HSPC_LA12',\
        'FMCP_HSPC_LA13',\
        'FMCP_HSPC_LA14',\
        'FMCP_HSPC_LA15',\
        'FMCP_HSPC_LA16',\
        'FMCP_HSPC_LA17_CC',\
        'FMCP_HSPC_LA18_CC',\
        'FMCP_HSPC_LA19',\
        'FMCP_HSPC_LA20',\
        'FMCP_HSPC_LA21',\
        'FMCP_HSPC_LA22',\
        'FMCP_HSPC_LA23',\
        'FMCP_HSPC_LA24',\
        'FMCP_HSPC_LA25',\
        'FMCP_HSPC_LA26',\
        'FMCP_HSPC_LA27',\
        'FMCP_HSPC_LA28',\
        'FMCP_HSPC_LA29',\
        'FMCP_HSPC_LA30',\
        'FMCP_HSPC_LA31',\
        'FMCP_HSPC_LA32']
        
        # self.TTLx8_ports = ['FMCP_HSPC_LA00_CC',\
        # 'FMCP_HSPC_LA01_CC',\
        # 'FMCP_HSPC_LA02',\
        # 'FMCP_HSPC_LA03',\
        # 'FMCP_HSPC_LA04',\
        # 'FMCP_HSPC_LA05',\
        # 'FMCP_HSPC_LA06',\
        # 'FMCP_HSPC_LA07']
        
        self.total_ttlx8_num = ( len(self.TTLx8_ports) // 8 ) + (not len(self.TTLx8_ports) % 8 == 0)
        self.ttlx8_pin_num = len(self.TTLx8_ports)
        
        self.TTL_ports = ['DACIO_00','DACIO_01','DACIO_02','DACIO_03','DACIO_04',\
                        'DACIO_05','DACIO_06','DACIO_07','DACIO_08','DACIO_09',\
                        'DACIO_10', 'DACIO_11', 'DACIO_12', 'DACIO_13',\
                        'DACIO_14', 'DACIO_15', 'DACIO_16', 'DACIO_17', \
                        'DACIO_18', 'DACIO_19', 'ADCIO_00', 'ADCIO_01', \
                        'ADCIO_02', 'ADCIO_03', 'ADCIO_04', 'ADCIO_05', \
                        'ADCIO_06', 'ADCIO_07', 'ADCIO_08', 'ADCIO_09', \
                        'ADCIO_10', 'ADCIO_11', 'ADCIO_12', 'ADCIO_13', \
                        'ADCIO_14', 'ADCIO_15', 'ADCIO_16', 'ADCIO_17', \
                        'ADCIO_18', 'ADCIO_19']
        # self.TTL_ports = ['DACIO_00','DACIO_01','DACIO_02','DACIO_03','DACIO_04', 'DACIO_05','DACIO_06','DACIO_07']
        
        self.total_ttl_num = ( len(self.TTL_ports) // 8 ) + (not len(self.TTL_ports) % 8 == 0)
        self.ttl_pin_num = len(self.TTL_ports)
        
        self.ttl_fifo_depth = 256
        self.ttl_fifo_threshold = self.ttl_fifo_depth - 8
        self.ttl_fifo_data_len = 8
        self.ttl_fifo_addr_len = len(bin(self.ttl_fifo_depth - 1)) - 2 
        
        self.ttlx8_fifo_depth = 256
        self.ttlx8_fifo_threshold = self.ttlx8_fifo_depth - 8
        self.ttlx8_fifo_data_len = 64
        self.ttlx8_fifo_addr_len = len(bin(self.ttlx8_fifo_depth - 1)) - 2 
        
        self.rtob_fifo_depth = 256
        self.rtob_fifo_threshold = self.rtob_fifo_depth - 8
        self.rtob_fifo_data_len = 8
        self.rtob_fifo_addr_len = len(bin(self.rtob_fifo_depth - 1)) - 2 
        
        self.total_rfdc_num = 1
        
        self.total_AXI_ports = self.total_dac_num + 1 + self.total_ttlx8_num + self.total_ttl_num + self.total_rfdc_num
        
        self.tcl_commands = ''
        self.customized_ip_list = []
        self.do_sim = False
        self.make_bit_stream = (False and (not self.do_sim))
        
    def runVivadoTCL(self, vivado_bat, tcl_path):
        self.vivado_executable = vivado_bat# Replace with the actual path to vivado.bat
    
        # Start Vivado in batch mode and pass the TCL commands as input
        process = subprocess.Popen([self.vivado_executable, "-mode", "batch", "-source", tcl_path],
                                   stdout=subprocess.PIPE, stderr=subprocess.STDOUT, universal_newlines=True, text=True)
    
        while process.poll() == None:
            out = process.stdout.readline()
            print(out, end='')
            
        # Wait for the process to complete
        stdout, stderr = process.communicate()
    
        # Print the output and error messages
        # print(stdout)
        print(stderr)
    
    def getAllFilesInDirectory(self, directory,file_type):
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
    def generateAddFilesString(self, file_path):
        return f'add_files -norecurse {{{file_path}}}\n'
    
    def generateAddConstraintsString(self, file_path):
        file_path_ = file_path.replace("\\","/")
        return f'add_files -fileset constrs_1 -norecurse {file_path_}'
    
    def generateSetPrjString(self, folder_directory,prj_name):
        return f'set project_name \"{prj_name}\"\n' + f'set project_dir \"{folder_directory}\"\n'
    
    def generateCreatePrjString(self, part_name):
        return f'create_project ${{project_name}} ${{project_dir}}/${{project_name}} -part {part_name}\n'
    
    def generateSetBoard(self, board_path, board_name):
        return f'set boardpath {{{board_path}}}\n' + 'set_param board.repoPaths [list $boardpath]\n' + f'set_property BOARD_PART {board_name} [current_project]\n'
    
    def generateXilinxDdsIp(self, folder_directory, dds_name):
        tcl_code = ''
        tcl_code += f'create_ip -dir {folder_directory} -name dds_compiler -vendor xilinx.com -library ip -version 6.0 -module_name {dds_name}\n'
        #one line command
        tcl_code += f'set_property -dict [list CONFIG.PartsPresent {{SIN_COS_LUT_only}}'
        tcl_code += f' CONFIG.Spurious_Free_Dynamic_Range {{90}} CONFIG.Frequency_Resolution {{0.01}}'
        tcl_code += f' CONFIG.Phase_Width {{15}} CONFIG.Output_Width {{15}} CONFIG.Output_Selection'
        tcl_code += f' {{Sine}} CONFIG.Optimization_Goal {{Speed}} CONFIG.Latency_Configuration {{Configurable}}'
        tcl_code += f' CONFIG.Latency {{1}} CONFIG.Parameter_Entry {{Hardware_Parameters}} CONFIG.Noise_Shaping {{None}}'
        tcl_code += f' CONFIG.Has_Phase_Out {{false}} CONFIG.DATA_Has_TLAST {{Not_Required}} CONFIG.S_PHASE_Has_TUSER'
        tcl_code += f' {{Not_Required}} CONFIG.M_DATA_Has_TUSER {{Not_Required}} CONFIG.Output_Frequency1 {{0}} CONFIG.PINC1'
        tcl_code += f' {{0}}] [get_ips {dds_name}]\n'
        
        #using '\' makes error in vivado.bat. this should be replaced in '/'
        tcl_code = tcl_code.replace("\\","/")
        
        return tcl_code
    
    def generateXilinxFifoGenerator(self, folder_directory, fifo_name):
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
    
    def generateXilinxDspMul(self, folder_directory, dsp_name):
        tcl_code = ''
        tcl_code += f'create_ip -dir {folder_directory} -name xbip_dsp48_macro -vendor xilinx.com -library ip -version 3.0 -module_name {dsp_name}\n'
        tcl_code += f'set_property -dict [list CONFIG.instruction1 {{A*B}}'
        tcl_code += f' CONFIG.pipeline_options {{Expert}} CONFIG.areg_3 {{false}}'
        tcl_code += f' CONFIG.areg_4 {{false}} CONFIG.breg_3 {{false}} CONFIG.breg_4 {{false}}'
        tcl_code += f' CONFIG.mreg_5 {{false}} CONFIG.preg_6 {{false}} CONFIG.a_width {{17}}'
        tcl_code += f' CONFIG.b_width {{17}} CONFIG.creg_3 {{false}} CONFIG.creg_4 {{false}}'
        tcl_code += f' CONFIG.creg_5 {{false}} CONFIG.d_width {{18}} CONFIG.a_binarywidth {{0}}'
        tcl_code += f' CONFIG.b_binarywidth {{0}} CONFIG.concat_width {{48}} CONFIG.concat_binarywidth {{0}}'
        tcl_code += f' CONFIG.c_binarywidth {{0}} CONFIG.pcin_binarywidth {{0}} CONFIG.p_full_width {{34}}'
        tcl_code += f' CONFIG.p_width {{34}} CONFIG.p_binarywidth {{0}}]'
        tcl_code += f' [get_ips {dsp_name}]\n'
        
        #using '\' makes error in vivado.bat. this should be replaced in '/'
        tcl_code = tcl_code.replace("\\","/")
        
        return tcl_code
        
    def generateXilinxDspSum(self, folder_directory, dsp_name):
        tcl_code = ''
        tcl_code += f'create_ip -dir {folder_directory} -name xbip_dsp48_macro -vendor xilinx.com -library ip -version 3.0 -module_name {dsp_name}\n'
        tcl_code += f'set_property -dict [list CONFIG.instruction1 {{(A+D)+C}}'
        tcl_code += f' CONFIG.pipeline_options {{Expert}} CONFIG.dreg_1 {{false}}'
        tcl_code += f' CONFIG.dreg_2 {{false}} CONFIG.dreg_3 {{false}} CONFIG.areg_1 {{false}}'
        tcl_code += f' CONFIG.areg_2 {{false}} CONFIG.areg_3 {{false}} CONFIG.areg_4 {{false}}'
        tcl_code += f' CONFIG.creg_1 {{false}} CONFIG.creg_2 {{false}} CONFIG.creg_3 {{false}}'
        tcl_code += f' CONFIG.creg_4 {{false}} CONFIG.creg_5 {{false}} CONFIG.mreg_5 {{false}}'
        tcl_code += f' CONFIG.preg_6 {{false}} CONFIG.d_width {{17}} CONFIG.a_width {{17}}'
        tcl_code += f' CONFIG.c_width {{17}} CONFIG.breg_3 {{false}} CONFIG.breg_4 {{false}}'
        tcl_code += f' CONFIG.d_binarywidth {{0}} CONFIG.a_binarywidth {{0}} CONFIG.b_width {{18}}'
        tcl_code += f' CONFIG.b_binarywidth {{0}} CONFIG.concat_width {{48}} CONFIG.concat_binarywidth {{0}}'
        tcl_code += f' CONFIG.c_binarywidth {{0}} CONFIG.pcin_binarywidth {{0}} CONFIG.p_full_width {{18}}'
        tcl_code += f' CONFIG.p_width {{18}} CONFIG.p_binarywidth {{0}}]'
        tcl_code += f' [get_ips {dsp_name}]\n'
        
        #using '\' makes error in vivado.bat. this should be replaced in '/'
        tcl_code = tcl_code.replace("\\","/")
        
        return tcl_code
    
    def generateXilinxDspSub(self, folder_directory, dsp_name):
        tcl_code = ''
        tcl_code += f'create_ip -dir {folder_directory} -name xbip_dsp48_macro -vendor xilinx.com -library ip -version 3.0 -module_name {dsp_name}\n'
        tcl_code += f'set_property -dict [list CONFIG.instruction1 {{CONCAT-C}}'
        tcl_code += f' CONFIG.pipeline_options {{Expert}} CONFIG.creg_3 {{false}}'
        tcl_code += f' CONFIG.creg_4 {{false}} CONFIG.creg_5 {{false}} CONFIG.concatreg_3 {{false}}'
        tcl_code += f' CONFIG.concatreg_4 {{false}} CONFIG.concatreg_5 {{false}} CONFIG.preg_6 {{false}}'
        tcl_code += f' CONFIG.dreg_1 {{false}} CONFIG.dreg_2 {{false}} CONFIG.dreg_3 {{false}} CONFIG.areg_1 {{false}}'
        tcl_code += f' CONFIG.areg_2 {{false}} CONFIG.areg_3 {{false}} CONFIG.areg_4 {{false}} CONFIG.breg_3 {{false}}'
        tcl_code += f' CONFIG.breg_4 {{false}} CONFIG.creg_1 {{false}} CONFIG.creg_2 {{false}} CONFIG.mreg_5 {{false}}'
        tcl_code += f' CONFIG.d_width {{18}} CONFIG.d_binarywidth {{0}} CONFIG.a_width {{27}} CONFIG.a_binarywidth {{0}}'
        tcl_code += f' CONFIG.b_width {{18}} CONFIG.b_binarywidth {{0}} CONFIG.concat_width {{48}}'
        tcl_code += f' CONFIG.concat_binarywidth {{0}} CONFIG.c_width {{48}} CONFIG.c_binarywidth {{0}}'
        tcl_code += f' CONFIG.pcin_binarywidth {{0}} CONFIG.p_full_width {{48}}'
        tcl_code += f' CONFIG.p_width {{48}} CONFIG.p_binarywidth {{0}}]'
        tcl_code += f' [get_ips {dsp_name}]\n'
        
        #using '\' makes error in vivado.bat. this should be replaced in '/'
        tcl_code = tcl_code.replace("\\","/")
        
        return tcl_code
    
    def generateXilinxBram(self, folder_directory, bram_name):
        tcl_code = ''
        tcl_code += f'create_ip -dir {folder_directory} -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name {bram_name}\n'
        tcl_code += f'set_property -dict [list CONFIG.Memory_Type {{True_Dual_Port_RAM}}'
        tcl_code += f' CONFIG.Write_Width_A {{72}} CONFIG.Write_Depth_A {{1024}} CONFIG.Read_Width_A {{72}}'
        tcl_code += f' CONFIG.Operating_Mode_A {{NO_CHANGE}} CONFIG.Enable_A {{Always_Enabled}}'
        tcl_code += f' CONFIG.Write_Width_B {{72}} CONFIG.Read_Width_B {{72}} CONFIG.Enable_B {{Always_Enabled}}'
        tcl_code += f' CONFIG.Register_PortA_Output_of_Memory_Primitives {{true}} CONFIG.Register_PortB_Output_of_Memory_Primitives {{true}}'
        tcl_code += f' CONFIG.Use_RSTA_Pin {{true}} CONFIG.Use_RSTB_Pin {{true}} CONFIG.Port_B_Clock {{100}}'
        tcl_code += f' CONFIG.Port_B_Write_Rate {{50}} CONFIG.Port_B_Enable_Rate {{100}} CONFIG.EN_SAFETY_CKT {{true}}]'
        tcl_code += f' [get_ips {bram_name}]\n'
        
        #using '\' makes error in vivado.bat. this should be replaced in '/'
        tcl_code = tcl_code.replace("\\","/")
        
        return tcl_code
    
    def generateXilinxRtobFifo(self, folder_directory, fifo_name, threshold):
        i__ = 0
        while POSSIBLE_FIFO_DEPTH[i__] <= threshold:
            i__ += 1
            if i__ >= len(POSSIBLE_FIFO_DEPTH):
                raise Exception('rtob fifo depth is too big')
        tcl_code = ''
        tcl_code += f'create_ip -dir {folder_directory} -name fifo_generator -vendor xilinx.com -library ip -version 13.2 -module_name {fifo_name}\n'
        tcl_code += f'set_property -dict [list CONFIG.Performance_Options {{First_Word_Fall_Through}}'
        tcl_code += f' CONFIG.Input_Data_Width {{64}} CONFIG.Input_Depth {{{POSSIBLE_FIFO_DEPTH[i__]}}}'
        tcl_code += f' CONFIG.Output_Data_Width {{64}} CONFIG.Output_Depth {{{POSSIBLE_FIFO_DEPTH[i__]}}}'
        tcl_code += f' CONFIG.Underflow_Flag {{true}} CONFIG.Overflow_Flag {{true}}'
        tcl_code += f' CONFIG.Data_Count_Width {{{len(bin(POSSIBLE_FIFO_DEPTH[i__] - 1)) - 2}}} CONFIG.Write_Data_Count_Width {{{len(bin(POSSIBLE_FIFO_DEPTH[i__] - 1)) - 2}}}'
        tcl_code += f' CONFIG.Read_Data_Count_Width {{{len(bin(POSSIBLE_FIFO_DEPTH[i__] - 1)) - 2}}} CONFIG.Programmable_Full_Type'
        tcl_code += f' {{Single_Programmable_Full_Threshold_Constant}}'
        tcl_code += f' CONFIG.Full_Threshold_Assert_Value {{{threshold}}}'
        tcl_code += f' CONFIG.Full_Threshold_Negate_Value {{{threshold-1}}}'
        tcl_code += f' CONFIG.Empty_Threshold_Assert_Value {{4}}'
        tcl_code += f' CONFIG.Empty_Threshold_Negate_Value {{5}}]'
        tcl_code += f' [get_ips {fifo_name}]\n'
        
        #using '\' makes error in vivado.bat. this should be replaced in '/'
        tcl_code = tcl_code.replace("\\","/")
        
        return tcl_code

    
    def generateCustomizedIp(self, folder_directory):
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
    
    def addCustomizedIp(self, folder_directory):
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
        
    def ensureDirectoryExists(self, directory_path):
        if not os.path.exists(directory_path):
            try:
                os.makedirs(directory_path)
                print(f"Directory {directory_path} created.")
            except OSError as error:
                print(f"Error creating directory {directory_path}: {error}")
        else:
            print(f"Directory {directory_path} already exists.")
            
    def removeDuplicatesSet(self, lst):
        return list(set(lst))
        
    ###########################################################################
    ##DAC
    ###########################################################################
    def generateDacController(self, current_dir = None):
        fifo_list = []
        dds_list = []
        dsp_mul_list = []
        dsp_sum_list = []
        dsp_sub_list = []
        if current_dir == None:
            source_dir = './DAC_Controller'
        else:
            source_dir = f'{current_dir}/DAC_Controller'
        
        full_dir = os.path.join(self.git_dir, self.dac_controller_dir.lstrip('/').lstrip('\\'))
        base_dir = os.path.dirname(full_dir)
        base_name = os.path.basename(full_dir)
        new_full_dir = os.path.join(base_dir,base_name.lstrip('/').lstrip('\\'))
        new_output_full_dir =os.path.join(base_dir,base_name.lstrip('/').lstrip('\\') + f'_output')
        self.ensureDirectoryExists(new_full_dir)
            
        for filename in os.listdir(source_dir):
            source_path = os.path.join(source_dir, filename)
            file_root, file_extension = os.path.splitext(filename)
            new_filename = file_root + file_extension
            destination_path = os.path.join(new_full_dir, new_filename)
        
            # Open the source file and read its contents
            verilog_code = ''
            with open(source_path, 'r') as source_file:
                verilog_code = source_file.read()
                
            for module_ in self.dac_controller_modules:
                verilog_code = verilog_code.replace(module_,module_)
                
            verilog_code = re.sub(r'fifo_generator_(\d+)', f'dac_controller_fifo_generator' + r'_\1',verilog_code)
            matches = re.findall(f'dac_controller_fifo_generator'+r'_(\d+)',verilog_code)
            full_strings = [f'dac_controller_fifo_generator_{match}' for match in matches]
            fifo_list += full_strings
            
            verilog_code = re.sub(r'dds_compiler_(\d+)', f'dac_controller_dds_compiler' + r'_\1',verilog_code)
            matches = re.findall(f'dac_controller_dds_compiler'+r'_(\d+)',verilog_code)
            full_strings = [f'dac_controller_dds_compiler_{match}' for match in matches]
            dds_list += full_strings
            
            verilog_code = re.sub(r'xbip_dsp48_mul_macro_(\d+)', f'dac_controller_xbip_dsp48_mul_macro' + r'_\1',verilog_code)
            matches = re.findall(f'dac_controller_xbip_dsp48_mul_macro' + r'_(\d+)',verilog_code)
            full_strings = [f'dac_controller_xbip_dsp48_mul_macro_{match}' for match in matches]
            dsp_mul_list += full_strings
            
            verilog_code = re.sub(r'xbip_dsp48_sum_macro_(\d+)', f'dac_controller_xbip_dsp48_sum_macro' + r'_\1',verilog_code)
            matches = re.findall(f'dac_controller_xbip_dsp48_sum_macro' + r'_(\d+)',verilog_code)
            full_strings = [f'dac_controller_xbip_dsp48_sum_macro_{match}' for match in matches]
            dsp_sum_list += full_strings
            
            verilog_code = re.sub(r'xbip_dsp48_sub_macro_(\d+)', f'dac_controller_xbip_dsp48_sub_macro' + r'_\1',verilog_code)
            matches = re.findall(f'dac_controller_xbip_dsp48_sub_macro' + r'_(\d+)',verilog_code)
            full_strings = [f'dac_controller_xbip_dsp48_sub_macro_{match}' for match in matches]
            dsp_sub_list += full_strings
        
            # Write the modified content to the destination file
            with open(destination_path, 'w') as destination_file:
                destination_file.write(verilog_code)
                
            
        fifo_list = self.removeDuplicatesSet(fifo_list)
        dds_list = self.removeDuplicatesSet(dds_list)
        dsp_mul_list = self.removeDuplicatesSet(dsp_mul_list)
        dsp_sum_list = self.removeDuplicatesSet(dsp_sum_list)
        self.makeDacControllerTCL(new_output_full_dir, f'DAC_Controller',self.part_name,\
                                    self.board_path,self.board_name,new_full_dir, ['.sv', '.v','.xic'], \
                                    dds_list, fifo_list, dsp_mul_list, dsp_sum_list, dsp_sub_list)
        
    def makeDacControllerTCL(self, folder_directory,prj_name,part_name,board_path,board_name,src_folder_directory,file_type, dds_list, fifo_list, dsp_mul_list, dsp_sum_list, dsp_sub_list):
        file_name = prj_name+".tcl"
        print(file_name)
        # Combine the file name and folder directory to create the full file path
        file_path = folder_directory + '\\' + file_name
        print(file_path)
        
        self.ensureDirectoryExists(folder_directory)
        #add src files
        self.setProject(folder_directory, prj_name)
        self.createProject(part_name)
        self.addSrc(src_folder_directory,file_type)
        self.setBoard(board_path, board_name)
        
        for dds_ in dds_list:
            self.tcl_commands += self.generateXilinxDdsIp(folder_directory,dds_)
        
        for fifo_ in fifo_list:
            self.tcl_commands += self.generateXilinxFifoGenerator(folder_directory,fifo_)
            
        for dsp_ in dsp_mul_list:
            self.tcl_commands += self.generateXilinxDspMul(folder_directory, dsp_)
            
        for dsp_ in dsp_sum_list:
            self.tcl_commands += self.generateXilinxDspSum(folder_directory, dsp_)
            
        for dsp_ in dsp_sub_list:
            self.tcl_commands += self.generateXilinxDspSub(folder_directory, dsp_)
        
        # Save the TCL code to the .tcl file
        
        self.tcl_commands += self.generateCustomizedIp(folder_directory)
        # self.openVivado(folder_directory,prj_name)
        
        self.tcl_commands += f'set_property top {prj_name} [current_fileset]\n'.replace("\\","/")
        self.tcl_commands += f'set_property top_file {{ {src_folder_directory}/{prj_name}.sv }} [current_fileset]\n'.replace("\\","/")
        with open(file_path, 'w') as tcl_file:
            tcl_file.write(self.tcl_commands)
            
        self.tcl_commands = ''
        tcl_path = folder_directory + '\\' + prj_name + '.tcl'
        
        self.runVivadoTCL(self.vivado_path, tcl_path)
        
    ###########################################################################
    ##TimeController
    ###########################################################################
    def generateTimeController(self, current_dir = None):
        if current_dir == None:
            source_dir = './TimeController'
        else:
            source_dir = f'{current_dir}/TimeController'
        
        full_dir = os.path.join(self.git_dir, self.time_controller_dir.lstrip('/').lstrip('\\'))
        base_dir = os.path.dirname(full_dir)
        base_name = os.path.basename(full_dir)
        new_full_dir = os.path.join(base_dir,base_name)
        new_output_full_dir =os.path.join(base_dir,base_name.lstrip('/').lstrip('\\') + '_output')
        self.ensureDirectoryExists(new_full_dir)
            
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

        self.makeTimeControllerTCL(new_output_full_dir, 'TimeController', self.part_name, self.board_path, self.board_name, new_full_dir, ['.sv', '.v','.xic'])
        
    def makeTimeControllerTCL(self, folder_directory,prj_name,part_name,board_path,board_name,src_folder_directory,file_type):
        file_name = prj_name+".tcl"
        print(file_name)
        # Combine the file name and folder directory to create the full file path
        file_path = folder_directory + '\\' + file_name
        print(file_path)
        
        self.ensureDirectoryExists(folder_directory)
        self.ensureDirectoryExists(src_folder_directory)
        #add src files
        self.setProject(folder_directory, prj_name)
        self.createProject(part_name)
        self.addSrc(src_folder_directory,file_type)
        self.setBoard(board_path, board_name)
        
        # Save the TCL code to the .tcl file
        
        self.tcl_commands += self.generateCustomizedIp(folder_directory)
        
        self.tcl_commands += f'set_property top TimeController [current_fileset]\n'.replace("\\","/")
        self.tcl_commands += f'set_property top_file {{ {src_folder_directory}/TimeController.sv }} [current_fileset]\n'.replace("\\","/")
        with open(file_path, 'w') as tcl_file:
            tcl_file.write(self.tcl_commands)
            
        self.tcl_commands = ''
        
        tcl_path = folder_directory + '\\' + prj_name + '.tcl'
        
        self.runVivadoTCL(self.vivado_path, tcl_path)
        
    ###########################################################################
    ##TTLx8
    ###########################################################################
    def generateTTLx8Out(self, current_dir = None):
        if current_dir == None:
            source_dir = './TTLx8_out'
        else:
            source_dir = f'{current_dir}/TTLx8_out'
        
        full_dir = os.path.join(self.git_dir, self.TTLx8_out_dir.lstrip('/').lstrip('\\'))
        base_dir = os.path.dirname(full_dir)
        base_name = os.path.basename(full_dir)
        new_full_dir = os.path.join(base_dir,base_name)
        new_output_full_dir =os.path.join(base_dir,base_name + '_output')
        self.ensureDirectoryExists(new_full_dir)
            
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

        self.makeTTLx8OutTCL(new_output_full_dir, 'TTLx8_out', self.part_name, self.board_path, self.board_name, new_full_dir, ['.sv', '.v','.xic'])
        
    def makeTTLx8OutTCL(self, folder_directory,prj_name,part_name,board_path,board_name,src_folder_directory,file_type):
        file_name = prj_name+".tcl"
        print(file_name)
        # Combine the file name and folder directory to create the full file path
        file_path = folder_directory + '\\' + file_name
        print(file_path)
        
        self.ensureDirectoryExists(folder_directory)
        self.ensureDirectoryExists(src_folder_directory)
        #add src files
        self.setProject(folder_directory, prj_name)
        self.createProject(part_name)
        self.addSrc(src_folder_directory,file_type)
        self.setBoard(board_path, board_name)
        
        self.tcl_commands += self.generateXilinxRtobFifo(folder_directory, 'rtob_fifo_generator_0', self.ttlx8_fifo_depth)
        
        # Save the TCL code to the .tcl file
        
        self.tcl_commands += self.generateCustomizedIp(folder_directory)
        
        self.tcl_commands += f'set_property top TTLx8_out [current_fileset]\n'.replace("\\","/")
        self.tcl_commands += f'set_property top_file {{ {src_folder_directory}/TTLx8_out.sv }} [current_fileset]\n'.replace("\\","/")
        with open(file_path, 'w') as tcl_file:
            tcl_file.write(self.tcl_commands)
            
        self.tcl_commands = ''
        
        tcl_path = folder_directory + '\\' + prj_name + '.tcl'
        
        self.runVivadoTCL(self.vivado_path, tcl_path)
        
    ###########################################################################
    ##TTL
    ###########################################################################
    def generateTTLOut(self, current_dir = None):
        if current_dir == None:
            source_dir = './TTL_out'
        else:
            source_dir = f'{current_dir}/TTL_out'

        full_dir = os.path.join(self.git_dir, self.TTL_out_dir.lstrip('/').lstrip('\\'))
        base_dir = os.path.dirname(full_dir)
        base_name = os.path.basename(full_dir)
        new_full_dir = os.path.join(base_dir,base_name)
        new_output_full_dir =os.path.join(base_dir,base_name + '_output')
        self.ensureDirectoryExists(new_full_dir)

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

        self.makeTTLOutTCL(new_output_full_dir, 'TTL_out', self.part_name, self.board_path, self.board_name, new_full_dir, ['.sv', '.v','.xic'])

    def makeTTLOutTCL(self, folder_directory,prj_name,part_name,board_path,board_name,src_folder_directory,file_type):
        file_name = prj_name+".tcl"
        print(file_name)
        # Combine the file name and folder directory to create the full file path
        file_path = folder_directory + '/' + file_name
        print(file_path)

        self.ensureDirectoryExists(folder_directory)
        self.ensureDirectoryExists(src_folder_directory)
        #add src files
        self.setProject(folder_directory, prj_name)
        self.createProject(part_name)
        self.addSrc(src_folder_directory,file_type)
        self.setBoard(board_path, board_name)

        self.tcl_commands += self.generateXilinxRtobFifo(folder_directory, 'rtob_fifo_generator_1', self.ttl_fifo_depth)

        # Save the TCL code to the .tcl file

        self.tcl_commands += self.generateCustomizedIp(folder_directory)

        self.tcl_commands += f'set_property top TTL_out [current_fileset]\n'.replace("\\","/")
        self.tcl_commands += f'set_property top_file {{ {src_folder_directory}/TTL_out.sv }} [current_fileset]\n'.replace("\\","/")
        with open(file_path, 'w') as tcl_file:
            tcl_file.write(self.tcl_commands)

        self.tcl_commands = ''

        tcl_path = folder_directory + '\\' + prj_name + '.tcl'

        self.runVivadoTCL(self.vivado_path, tcl_path)
        
    ###########################################################################
    ##EdgeCounter
    ###########################################################################
    def generateEdgeCounter(self, current_dir = None):
        if current_dir == None:
            source_dir = './EdgeCounter'
        else:
            source_dir = f'{current_dir}/EdgeCounter'

        full_dir = os.path.join(self.git_dir, self.EdgeCounter_dir.lstrip('/').lstrip('\\'))
        base_dir = os.path.dirname(full_dir)
        base_name = os.path.basename(full_dir)
        new_full_dir = os.path.join(base_dir,base_name)
        new_output_full_dir =os.path.join(base_dir,base_name + '_output')
        self.ensureDirectoryExists(new_full_dir)

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

        self.makeEdgeCounterTCL(new_output_full_dir, 'EdgeCounter', self.part_name, self.board_path, self.board_name, new_full_dir, ['.sv', '.v','.xic'])

    def makeEdgeCounterTCL(self, folder_directory,prj_name,part_name,board_path,board_name,src_folder_directory,file_type):
        file_name = prj_name+".tcl"
        print(file_name)
        # Combine the file name and folder directory to create the full file path
        file_path = folder_directory + '/' + file_name
        print(file_path)

        self.ensureDirectoryExists(folder_directory)
        self.ensureDirectoryExists(src_folder_directory)
        #add src files
        self.setProject(folder_directory, prj_name)
        self.createProject(part_name)
        self.addSrc(src_folder_directory,file_type)
        self.setBoard(board_path, board_name)

        self.tcl_commands += self.generateXilinxFifoGenerator(folder_directory, 'fifo_generator_0')

        # Save the TCL code to the .tcl file

        self.tcl_commands += self.generateCustomizedIp(folder_directory)

        self.tcl_commands += f'set_property top EdgeCounter [current_fileset]\n'.replace("\\","/")
        self.tcl_commands += f'set_property top_file {{ {src_folder_directory}/EdgeCounter.sv }} [current_fileset]\n'.replace("\\","/")
        with open(file_path, 'w') as tcl_file:
            tcl_file.write(self.tcl_commands)

        self.tcl_commands = ''

        tcl_path = folder_directory + '\\' + prj_name + '.tcl'

        self.runVivadoTCL(self.vivado_path, tcl_path)
        
    def generateRFSoCmain(self, current_dir = None):
        if current_dir == None:
            source_dir = './RFSoC_Main'
        else:
            source_dir = f'{current_dir}/RFSoC_Main'
        
        full_dir = os.path.join(self.git_dir, self.RFSoC_Main_dir.lstrip('/').lstrip('\\'))
        base_dir = os.path.dirname(full_dir)
        base_name = os.path.basename(full_dir)
        new_full_dir = os.path.join(base_dir,base_name)
        new_output_full_dir =os.path.join(base_dir,base_name + '_output')
        self.ensureDirectoryExists(new_full_dir)
            
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

        self.makeRFSoCmainTCL(new_output_full_dir, 'RFSoC_Main', self.part_name, self.board_path, self.board_name, new_full_dir, ['.sv', '.v','.xic', '.xdc'],'block')
        
    def makeRFSoCmainTCL(self, folder_directory,prj_name,part_name,board_path,board_name,src_folder_directory,file_type,version = 'block'):
        file_name = prj_name+".tcl"
        print(file_name)
        # Combine the file name and folder directory to create the full file path
        file_path = folder_directory + '\\' + file_name
        print(file_path)
        
        self.ensureDirectoryExists(folder_directory)
        self.ensureDirectoryExists(src_folder_directory)
        #add src files
        self.setProject(folder_directory, prj_name)
        self.createProject(part_name)
        self.addSrc(src_folder_directory,file_type)
        self.setBoard(board_path, board_name)
        
        # Save the TCL code to the .tcl file
        
        self.tcl_commands += self.addCustomizedIp(folder_directory)
        self.tcl_commands += self.generateXilinxBlockDesign(folder_directory, prj_name)
        if self.make_bit_stream == False:
            self.openVivado(folder_directory,prj_name)
        with open(file_path, 'w') as tcl_file:
            tcl_file.write(self.tcl_commands)
            
        self.tcl_commands = ''
        
        tcl_path = folder_directory + '\\' + prj_name + '.tcl'
        
        self.runVivadoTCL(self.vivado_path, tcl_path)
            
    def generateXilinxBlockDesign(self, folder_directory, prj_name):
        print(f'folder dir : {folder_directory}')
        print(f'current python dir : {os.path.abspath(__file__)}')
        tcl_code = ''
        tcl_code += f'create_bd_design \"{prj_name}_blk\"\n'
        tcl_code += f'current_bd_design \"{prj_name}_blk\"\n'
        tcl_code += f'set parentObj [get_bd_cells /]\n'
        tcl_code += f'set parentObj [get_bd_cells \"\"]\n'
        tcl_code += 'set parentType [get_property TYPE $parentObj]\n'
        tcl_code += f'current_bd_instance $parentObj\n'
        tcl_code += """
set RF3_CLKO_A_C_N_228 [ create_bd_port -dir I -type clk -freq_hz 2000000000 RF3_CLKO_A_C_N_228 ]
set RF3_CLKO_A_C_N_229 [ create_bd_port -dir I -type clk -freq_hz 2000000000 RF3_CLKO_A_C_N_229 ]
set RF3_CLKO_A_C_P_228 [ create_bd_port -dir I -type clk -freq_hz 2000000000 RF3_CLKO_A_C_P_228 ]
set RF3_CLKO_A_C_P_229 [ create_bd_port -dir I -type clk -freq_hz 2000000000 RF3_CLKO_A_C_P_229 ]
"""
        #######################################################################
        # PLL
        #######################################################################
        tcl_code += """
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {80.0} \
   CONFIG.CLKOUT1_DRIVES {Buffer} \
   CONFIG.CLKOUT1_JITTER {92.027} \
   CONFIG.CLKOUT1_PHASE_ERROR {96.948} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {500} \
   CONFIG.CLKOUT2_DRIVES {Buffer} \
   CONFIG.CLKOUT3_DRIVES {Buffer} \
   CONFIG.CLKOUT4_DRIVES {Buffer} \
   CONFIG.CLKOUT5_DRIVES {Buffer} \
   CONFIG.CLKOUT6_DRIVES {Buffer} \
   CONFIG.CLKOUT7_DRIVES {Buffer} \
   CONFIG.MMCM_BANDWIDTH {OPTIMIZED} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {8} \
   CONFIG.MMCM_CLKIN1_PERIOD {8.000} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {2} \
   CONFIG.MMCM_COMPENSATION {AUTO} \
   CONFIG.PLL_CLKIN_PERIOD {8.000} \
   CONFIG.PRIMITIVE {PLL} \
   CONFIG.PRIM_IN_FREQ {124.998749} \
   CONFIG.RESET_PORT {resetn} \
   CONFIG.RESET_TYPE {ACTIVE_LOW} \
 ] $clk_wiz_0
        """
        if self.do_sim:
            tcl_code += 'set locked_0 [ create_bd_port -dir O locked_0 ]\n'
            
        
        #######################################################################
        # TTLx8_out
        #######################################################################
        neg = '_N'
        pos = '_P'
        i__ = 0
        for comp in self.TTLx8_ports:
            tcl_code += f'set {comp + neg} [ create_bd_port -dir O {comp + neg} ]\n'
            tcl_code += f'set {comp + pos} [ create_bd_port -dir O {comp + pos} ]\n'
            if self.do_sim:
                tcl_code += f'set output_pulse_x8_{i__}_p [ create_bd_port -dir O output_pulse_x8_{i__}_p ]\n'
                tcl_code += f'set output_pulse_x8_{i__}_n [ create_bd_port -dir O output_pulse_x8_{i__}_n ]\n'
            i__ += 1
            
        for module_index in range(self.total_ttlx8_num):
            tcl_code += f'set TTLx8_out_{module_index} [ create_bd_cell -type ip -vlnv xilinx.com:user:TTLx8_out TTLx8_out_{module_index} ]\n'
            tcl_code += f'set_property -dict [list CONFIG.THRESHOLD {{{self.ttlx8_fifo_threshold}}} CONFIG.DEPTH {{{self.ttlx8_fifo_depth}}}\
 CONFIG.DATA_LEN {{{self.ttlx8_fifo_data_len}}} CONFIG.ADDR_LEN {{{self.ttlx8_fifo_addr_len}}} ] [get_bd_cells TTLx8_out_{module_index}]\n'
            if self.ttlx8_pin_num - module_index * 8 < 8:        
                pin_number = self.ttlx8_pin_num - module_index * 8
            else:
                pin_number = 8
            for i__ in range(pin_number):
                tcl_code += f'connect_bd_net -net TTLx8_out_{module_index}_output_pulse_{i__}_p \
[get_bd_ports {self.TTLx8_ports[module_index * 8 + i__] + pos}] [get_bd_pins TTLx8_out_{module_index}/output_pulse_{i__}_p]\n'
                tcl_code += f'connect_bd_net -net TTLx8_out_{module_index}_output_pulse_{i__}_n \
[get_bd_ports {self.TTLx8_ports[module_index * 8 + i__] + neg}] [get_bd_pins TTLx8_out_{module_index}/output_pulse_{i__}_n]'
                tcl_code += '\n'
            
        #######################################################################
        # TTL_out
        #######################################################################
        i__ = 0
        for comp in self.TTL_ports:
            tcl_code += f'set {comp} [ create_bd_port -dir O {comp} ]\n'
            if self.do_sim:
                tcl_code += f'set output_pulse_x1_{i__} [ create_bd_port -dir O output_pulse_x1_{i__} ]\n'
            i__ += 1
            
        for module_index in range(self.total_ttl_num):
            tcl_code += f'set TTL_out_{module_index} [ create_bd_cell -type ip -vlnv xilinx.com:user:TTL_out TTL_out_{module_index} ]\n'
            tcl_code += f'set_property -dict [list CONFIG.THRESHOLD {{{self.ttl_fifo_threshold}}} CONFIG.DEPTH {{{self.ttl_fifo_depth}}}\
 CONFIG.ADDR_LEN {{{self.ttl_fifo_addr_len}}} CONFIG.DATA_LEN {{{self.ttl_fifo_data_len}}} ] [get_bd_cells TTL_out_{module_index}]\n'
            if self.ttl_pin_num - module_index * 8 < 8:        
                pin_number = self.ttl_pin_num - module_index * 8
            else:
                pin_number = 8
            for i__ in range(pin_number):
                tcl_code += f'connect_bd_net -net TTL_out_{module_index}_output_pulse_{i__} [get_bd_ports {self.TTL_ports[module_index * 8 + i__]}] \
[get_bd_pins TTL_out_{module_index}/output_pulse_{i__}]'
                if self.do_sim:
                    tcl_code += f' [get_bd_ports output_pulse_x1_{i__}]'
                tcl_code += '\n'
        
        #######################################################################
        # DAC output port
        #######################################################################
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
        
        #######################################################################
        # DAC Controller
        #######################################################################
        for i in range(self.total_dac_num):
            tcl_code += f'set DAC_Controller_{i} [ create_bd_cell -type ip -vlnv xilinx.com:user:DAC_Controller DAC_Controller_{i} ]\n'
            
        #######################################################################
        # Reset IP
        #######################################################################
        tcl_code += 'set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset proc_sys_reset_0 ]\n'
        
        #######################################################################
        # TimeController
        #######################################################################
        tcl_code += 'set TimeController_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:TimeController TimeController_0 ]\n'
        
        #######################################################################
        # AXI Interconnect
        #######################################################################
        tcl_code += f"""
set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect axi_interconnect_0 ]
set_property -dict [ list \
   CONFIG.NUM_MI {{{self.total_AXI_ports}}} \
 ] $axi_interconnect_0
        """
        
        #######################################################################
        # RFDC IP
        #######################################################################
        
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
   CONFIG.DAC0_Fabric_Freq {125.000} \
   CONFIG.DAC0_Outclk_Freq {125.000} \
   CONFIG.DAC0_PLL_Enable {false} \
   CONFIG.DAC0_Refclk_Div {2} \
   CONFIG.DAC0_Refclk_Freq {2000.000} \
   CONFIG.DAC0_Sampling_Rate {2} \
   CONFIG.DAC1_Fabric_Freq {125.000} \
   CONFIG.DAC1_Outclk_Freq {125.000} \
   CONFIG.DAC1_PLL_Enable {false} \
   CONFIG.DAC1_Refclk_Div {2} \
   CONFIG.DAC1_Refclk_Freq {2000.000} \
   CONFIG.DAC1_Sampling_Rate {2} """
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
                    
            tcl_code += '   CONFIG.DAC_Output_Current {0} '
            
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
            tcl_code += ' CONFIG.Axiclk_Freq {125} '
            tcl_code += '\n'
            tcl_code += f'] $usp_rf_data_converter_{i}\n'
            
        #######################################################################
        # ZYNQ IP
        #######################################################################
        # Setting Zynq
        
        # Open the file in read mode
        tcl_code += '\n'
        lines = []
        with open(self.cpu_type, 'r') as file:
            lines = file.readlines()
        
        # Initialize a variable to hold the concatenated content
        concatenated_content = ""
        current_line = ""
        
        # Iterate through the lines and concatenate lines ending with '\'
        for line in lines:
            line = line.rstrip('\n')
            if line.endswith('\\'):
                # If the line ends with '\', remove the '\' and concatenate with the next line
                current_line += line.rstrip('\\')
            else:
                # If the line does not end with '\', concatenate with the current line and add to the result
                concatenated_content += current_line + line + '\n'
                current_line = ""
        
        # Handle the case where the last line ends with '\'
        if current_line:
            concatenated_content += current_line + '\n'
        
        tcl_code += concatenated_content
        tcl_code += '\n'
        
        #######################################################################
        # AXI INTERCONNECT
        #######################################################################
        tcl_code += """
connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins usp_rf_data_converter_0/s_axi]
connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins TimeController_0/s_axi] [get_bd_intf_pins axi_interconnect_0/M01_AXI]
connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_M_AXI_HPM0_FPD [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_FPD]
        """
        
        tcl_code += '\n'
        
        axi_index = 2
        
        #######################################################################
        # DAC CONTROLLER AXI INTERCONNECTION
        #######################################################################
        for i in range(self.total_dac_num):
            if self.do_sim == True:
                tcl_code += f"""
set m00_axis_0{i} [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m00_axis_0{i} ]
set_property -dict [ list \
 CONFIG.FREQ_HZ {{124998749}} \
 ] $m00_axis_0{i}
    
connect_bd_intf_net -intf_net DAC_Controller_{i}_m00_axis [get_bd_intf_ports m00_axis_0{i}] [get_bd_intf_pins DAC_Controller_{i}/m00_axis]
                """
            else:
                if i < 4:
                    tcl_code += f'connect_bd_intf_net -intf_net DAC_Controller_{i}_m00_axis [get_bd_intf_pins DAC_Controller_{i}/m00_axis] [get_bd_intf_pins usp_rf_data_converter_0/s0{i}_axis]\n'
                    
                else:
                    tcl_code += f'connect_bd_intf_net -intf_net DAC_Controller_{i}_m00_axis [get_bd_intf_pins DAC_Controller_{i}/m00_axis] [get_bd_intf_pins usp_rf_data_converter_0/s1{i-4}_axis]\n'
        
        tcl_code += '\n'
        for i in range(self.total_dac_num):
            tcl_code += f'connect_bd_intf_net -intf_net axi_interconnect_0_M'+f'{axi_index}'.zfill(2)+f'_AXI [get_bd_intf_pins DAC_Controller_{i}/s_axi] [get_bd_intf_pins axi_interconnect_0/M'+f'{axi_index}'.zfill(2)+'_AXI]\n'
            axi_index += 1
        #######################################################################
        # TTLx8_out AXI INTERCONNECTION
        #######################################################################
        tcl_code += '\n'
        for i in range(self.total_ttlx8_num):
            tcl_code += f'connect_bd_intf_net -intf_net axi_interconnect_0_M'+f'{axi_index}'.zfill(2)+f'_AXI [get_bd_intf_pins TTLx8_out_{i}/s_axi] [get_bd_intf_pins axi_interconnect_0/M'+f'{axi_index}'.zfill(2)+'_AXI]\n'
            axi_index += 1
        
        #######################################################################
        # TTL_out AXI INTERCONNECTION
        #######################################################################
        tcl_code += '\n'
        for i in range(self.total_ttl_num):
            tcl_code += f'connect_bd_intf_net -intf_net axi_interconnect_0_M'+f'{axi_index}'.zfill(2)+f'_AXI [get_bd_intf_pins TTL_out_{i}/s_axi] [get_bd_intf_pins axi_interconnect_0/M'+f'{axi_index}'.zfill(2)+'_AXI]\n'
            axi_index += 1
        

        #######################################################################
        # RF CLOCK CONNECTION
        #######################################################################
        tcl_code += """
# Create port connections
connect_bd_net -net RF3_CLKO_A_C_N_1 [get_bd_ports RF3_CLKO_A_C_N_228] [get_bd_pins usp_rf_data_converter_0/dac0_clk_n]
connect_bd_net -net RF3_CLKO_A_C_N_2 [get_bd_ports RF3_CLKO_A_C_N_229] [get_bd_pins usp_rf_data_converter_0/dac1_clk_n]
connect_bd_net -net RF3_CLKO_A_C_P_1 [get_bd_ports RF3_CLKO_A_C_P_228] [get_bd_pins usp_rf_data_converter_0/dac0_clk_p]
connect_bd_net -net RF3_CLKO_A_C_P_2 [get_bd_ports RF3_CLKO_A_C_P_229] [get_bd_pins usp_rf_data_converter_0/dac1_clk_p]
        """
        
        #Vivado makes replica of register to resolve high fan problem. So you don't have to consider high fan problem in auto_start, and coutner.
        tcl_code += '\n'
        
        #######################################################################
        # AUTO START CONNECTION
        #######################################################################
        tcl_code += 'connect_bd_net -net TimeController_0_auto_start'
        for i in range(self.total_dac_num):
            tcl_code += f' [get_bd_pins DAC_Controller_{i}/auto_start]'
        for i in range(self.total_ttlx8_num):
            tcl_code += f' [get_bd_pins TTLx8_out_{i}/auto_start]'
        for i in range(self.total_ttl_num):
            tcl_code += f' [get_bd_pins TTL_out_{i}/auto_start]'
        tcl_code += ' [get_bd_pins TimeController_0/auto_start]\n'
        
        #######################################################################
        # COUNTER CONNECTION
        #######################################################################
        tcl_code += 'connect_bd_net -net TimeController_0_counter'
        for i in range(self.total_dac_num):
            tcl_code += f' [get_bd_pins DAC_Controller_{i}/counter]'
        for i in range(self.total_ttlx8_num):
            tcl_code += f' [get_bd_pins TTLx8_out_{i}/counter]'
        for i in range(self.total_ttl_num):
            tcl_code += f' [get_bd_pins TTL_out_{i}/counter]'
        tcl_code += ' [get_bd_pins TimeController_0/counter]\n'
        
        #######################################################################
        # AXI ARESTN CONNECTION
        #######################################################################
        tcl_code += 'connect_bd_net -net proc_sys_reset_0_peripheral_aresetn'
        for i in range(self.total_dac_num):
            tcl_code += f' [get_bd_pins DAC_Controller_{i}/s_axi_aresetn]'
        for i in range(self.total_ttlx8_num):
            tcl_code += f' [get_bd_pins TTLx8_out_{i}/s_axi_aresetn]'
        for i in range(self.total_ttl_num):
            tcl_code += f' [get_bd_pins TTL_out_{i}/s_axi_aresetn]'
        for i in range(self.total_AXI_ports):
            tcl_code += f' [get_bd_pins axi_interconnect_0/M'+f'{i}'.zfill(2)+'_ARESETN]'
            
        tcl_code += ' [get_bd_pins TimeController_0/s_axi_aresetn] [get_bd_pins axi_interconnect_0/ARESETN]'
        tcl_code += ' [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]'
        tcl_code += ' [get_bd_pins usp_rf_data_converter_0/s0_axis_aresetn] [get_bd_pins usp_rf_data_converter_0/s1_axis_aresetn]'
        tcl_code += ' [get_bd_pins usp_rf_data_converter_0/s_axi_aresetn] [get_bd_pins clk_wiz_0/resetn]'
        tcl_code += '\n'
        
        #######################################################################
        # RFDC OUTPUT PORT CONNECTION
        #######################################################################
        for i in range(self.total_dac_num):
            if i < 4:
                tcl_code += f'connect_bd_net -net usp_rf_data_converter_0_vout0{i}_n [get_bd_ports RFMC_DAC_0{i}_N] [get_bd_pins usp_rf_data_converter_0/vout0{i}_n]\n'
                tcl_code += f'connect_bd_net -net usp_rf_data_converter_0_vout0{i}_p [get_bd_ports RFMC_DAC_0{i}_P] [get_bd_pins usp_rf_data_converter_0/vout0{i}_p]\n'
            else:
                tcl_code += f'connect_bd_net -net usp_rf_data_converter_0_vout1{i-4}_n [get_bd_ports RFMC_DAC_0{i}_N] [get_bd_pins usp_rf_data_converter_0/vout1{i-4}_n]\n'
                tcl_code += f'connect_bd_net -net usp_rf_data_converter_0_vout1{i-4}_p [get_bd_ports RFMC_DAC_0{i}_P] [get_bd_pins usp_rf_data_converter_0/vout1{i-4}_p]\n'
                
        #######################################################################
        # S_AXI_ACLK CONNECTION
        #######################################################################
        tcl_code += 'connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 '
        for i in range(self.total_dac_num):
            tcl_code += f' [get_bd_pins DAC_Controller_{i}/m00_axis_aclk] [get_bd_pins DAC_Controller_{i}/s_axi_aclk]'
        for i in range(self.total_ttlx8_num):
            tcl_code += f' [get_bd_pins TTLx8_out_{i}/s_axi_aclk]'
        for i in range(self.total_ttl_num):
            tcl_code += f' [get_bd_pins TTL_out_{i}/s_axi_aclk]'
        for i in range(self.total_AXI_ports):
            tcl_code += f' [get_bd_pins axi_interconnect_0/M'+f'{i}'.zfill(2)+'_ACLK] '
            
        tcl_code += """ [get_bd_pins TimeController_0/s_axi_aclk] [get_bd_pins clk_wiz_0/clk_in1]\
 [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK]\
 [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins usp_rf_data_converter_0/s0_axis_aclk] [get_bd_pins usp_rf_data_converter_0/s1_axis_aclk]\
 [get_bd_pins usp_rf_data_converter_0/s_axi_aclk] [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
        """
        
        tcl_code += '\n'
        tcl_code += 'connect_bd_net -net zynq_ultra_ps_e_0_pl_resetn0 [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]\n'
        
        #######################################################################
        # PLL CLOCK CONNECTION
        #######################################################################
        tcl_code += 'connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1]'
        for i in range(self.total_ttlx8_num):
            tcl_code += f' [get_bd_pins TTLx8_out_{i}/clk_x4] '
        tcl_code += '\n'
        
        if self.do_sim:
            tcl_code += 'connect_bd_net -net clk_wiz_0_locked [get_bd_ports locked_0] [get_bd_pins clk_wiz_0/locked]\n'
        
        #######################################################################
        # ADDRESS CONFIGURATION
        #######################################################################
        for i in range(self.total_dac_num):
            tcl_code += f'assign_bd_address -offset 0xA000{i}000 -range 0x00001000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs DAC_Controller_{i}/s_axi/reg0] -force\n'
        addr_ = 0xA0010000
        for i in range(self.total_ttlx8_num):
            addr_str = hex(addr_).upper()
            tcl_code += f'assign_bd_address -offset {addr_str} -range 0x00001000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs TTLx8_out_{i}/s_axi/reg0] -force\n'
            addr_ = addr_ + 0x00001000
            
        for i in range(self.total_ttl_num):
            addr_str = hex(addr_).upper()
            tcl_code += f'assign_bd_address -offset {addr_str} -range 0x00001000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs TTL_out_{i}/s_axi/reg0] -force\n'
            addr_ = addr_ + 0x00001000
        
        tcl_code += """
assign_bd_address -offset 0xA0008000 -range 0x00001000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs TimeController_0/s_axi/reg0] -force
assign_bd_address -offset 0xA00C0000 -range 0x00040000 -target_address_space [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs usp_rf_data_converter_0/s_axi/Reg] -force
        """
        #######################################################################
        # SIMULATION TIME CONFIGURATION
        #######################################################################
        tcl_code += 'set_property -name {xsim.simulate.runtime} -value {100us} -objects [get_filesets sim_1]'
        
        tcl_code += '\n'
        
        #######################################################################
        # TEST CODE WRITTEN LOCALLY
        #######################################################################
        if self.do_sim == True:
            for i in range(self.total_dac_num):
                tcl_code += f'delete_bd_objs [get_bd_ports RFMC_DAC_0{i}_N]\n'
                tcl_code += f'delete_bd_objs [get_bd_ports RFMC_DAC_0{i}_P]\n'
            block_addr = os.path.join(folder_directory,'/RFSoC_Main/RFSoC_Main.srcs/sources_1/bd/RFSoC_Main_blk/RFSoC_Main_blk.bd'.lstrip('/').lstrip('\\'))
            wrapper_addr = os.path.join(folder_directory,'/RFSoC_Main/RFSoC_Main.gen/sources_1/bd/RFSoC_Main_blk/hdl/RFSoC_Main_blk_wrapper.v'.lstrip('/').lstrip('\\'))
#             tcl_code += f"""
# delete_bd_objs [get_bd_ports RF3_CLKO_A_C_N_228]
# delete_bd_objs [get_bd_ports RF3_CLKO_A_C_P_228]
# delete_bd_objs [get_bd_nets RF3_CLKO_A_C_N_2] [get_bd_ports RF3_CLKO_A_C_N_229]
# delete_bd_objs [get_bd_nets RF3_CLKO_A_C_P_2] [get_bd_ports RF3_CLKO_A_C_P_229]
# delete_bd_objs [get_bd_cells usp_rf_data_converter_0]
# make_wrapper -files [get_files {block_addr}] -top
# add_files -norecurse {wrapper_addr}
# add_files -fileset sim_1 -norecurse E:/RFSoC/GIT/Vivado_prj_manager/Verilog_main/RFSoC_Main_Sim/RFSoC_Main_TB04.sv
#             """
#         else:
        if self.make_bit_stream == True:
            block_addr = os.path.join(folder_directory,'RFSoC_Main/RFSoC_Main.srcs/sources_1/bd/RFSoC_Main_blk/RFSoC_Main_blk.bd'.lstrip('/').lstrip('\\'))
            wrapper_addr = os.path.join(folder_directory,'RFSoC_Main/RFSoC_Main.gen/sources_1/bd/RFSoC_Main_blk/hdl/RFSoC_Main_blk_wrapper.v'.lstrip('/').lstrip('\\'))
            tcl_code += f"""
make_wrapper -files [get_files {block_addr}] -top
add_files -norecurse {wrapper_addr}
launch_runs impl_1 -to_step write_bitstream -jobs 6
            """
            
        #using '\' makes error in vivado.bat. this should be replaced in '/'
        tcl_code = tcl_code.replace("\\","/")
        
        return tcl_code
        
    def setProject(self, folder_directory, prj_name):
        tcl_code = "# Set the project name and working directory\n"
        tcl_code += self.generateSetPrjString(folder_directory,prj_name)
        tcl_code = tcl_code.replace("\\","/")
        tcl_code += '\n'
        
        self.tcl_commands += tcl_code
    
    def createProject(self, part_name):
        tcl_code = "# Create a new project\n"
        tcl_code += self.generateCreatePrjString(part_name)
        tcl_code = tcl_code.replace("\\","/")
        tcl_code += '\n'
        
        self.tcl_commands += tcl_code
    
    def addSrc(self, folder_directory,file_type):
        # Get all files in the directory
        all_files = self.getAllFilesInDirectory(folder_directory,file_type)
        tcl_code = "# Add the FIFO IP file to the project\n"
        for all_file_path in all_files:
            root, ext = os.path.splitext(all_file_path)
            if ext == '.xdc':
                tcl_code += self.generateAddConstraintsString(all_file_path)
            else:
                tcl_code += self.generateAddFilesString(all_file_path)
            
        #using '\' makes error in vivado.bat. this should be replaced in '/'
        tcl_code = tcl_code.replace("\\","/")
        tcl_code += '\n'
        
        self.tcl_commands += tcl_code
    
    def setBoard(self, board_path, board_name):
        tcl_code = "# Set the target board\n"
        tcl_code += self.generateSetBoard(board_path, board_name)
        tcl_code = tcl_code.replace("\\","/")
        tcl_code += '\n'
        
        self.tcl_commands += tcl_code
        
    def openVivado(self, folder_directory,prj_name):
        tcl_code = ''
        tcl_code += 'start_gui\n'
        # tcl_code += f'open_project {folder_directory}/{prj_name}/{prj_name}.xpr\n'
        
        tcl_code = tcl_code.replace("\\","/")
        
        self.tcl_commands += tcl_code
    
    def generateXSA(self):
        tcl_code = ''
        file_path = os.path.join(self.git_dir, self.target_dir,'make_xsa.tcl')
        if self.make_bit_stream == True:
            bit_addr = os.path.join(self.git_dir,'Vivado_prj_manager','Vitis_main','RFSoC_Main_blk_wrapper.xsa')
            prj_addr = os.path.join(self.git_dir,self.target_dir,'RFSoC_Main_output/RFSoC_Main/RFSoC_Main.xpr')
            tcl_code += f"""
open_project {prj_addr}
write_hw_platform -fixed -include_bit -force -file {bit_addr}
            """
            
            tcl_code = tcl_code.replace("\\","/")
            self.tcl_commands += tcl_code
            with open(file_path, 'w') as tcl_file:
                tcl_file.write(self.tcl_commands)

            self.runVivadoTCL(self.vivado_path, file_path)
            
    def run(self):
        self.generateDacController()
        self.generateTimeController()
        self.generateTTLx8Out()
        self.generateTTLOut()
        self.generateEdgeCounter()
        self.generateRFSoCmain()
        self.generateXSA()
        
    
            
if __name__ == "__main__":
    vm = Verilog_maker()
    vm.run()