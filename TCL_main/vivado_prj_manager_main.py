# -*- coding: utf-8 -*-
"""
Created on Fri Jul 21 12:43:14 2023

@author: QC109_4, GPT
"""
import subprocess
import os

def run_vivado_tcl( vivado_bat, tcl_commands):
    vivado_executable = vivado_bat# Replace with the actual path to vivado.bat

    # Start Vivado in batch mode and pass the TCL commands as input
    process = subprocess.Popen([vivado_executable, "-mode", "batch", "-source", tcl_commands],
                               stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

    # Wait for the process to complete
    stdout, stderr = process.communicate()

    # Print the output and error messages
    print(stdout)
    print(stderr)

def get_all_files_in_directory(directory,file_type):
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
def generate_add_files_string(file_path):
    return f'add_files -norecurse {{{file_path}}}\n'

def generate_set_prj_string(folder_directory,prj_name):
    return f'set project_name \"{prj_name}\"\n' + f'set project_dir \"{folder_directory}\"\n'

def generate_create_prj_string(part_name):
    return f'create_project ${{project_name}} ${{project_dir}}/${{project_name}} -part {part_name}\n'

def generate_set_board(board_path, board_name):
    return f'set boardpath {{{board_path}}}\n' + 'set_param board.repoPaths [list $boardpath]\n' + f'set_property BOARD_PART {board_name} [current_project]\n'

def make_tcl(folder_directory,prj_name,part_name,board_path,board_name,file_type):
    file_name = prj_name+".tcl"
    print(file_name)
    # Combine the file name and folder directory to create the full file path
    file_path = folder_directory + '\\' + file_name
    print(file_path)
    
    tcl_code = ""
    #add src files
    tcl_code += set_project(folder_directory, prj_name)
    tcl_code += '\n'
    tcl_code += create_project(part_name)
    tcl_code += '\n'
    tcl_code += add_src(folder_directory,file_type)
    tcl_code += '\n'
    tcl_code += set_board(board_path, board_name)
    
    # Save the TCL code to the .tcl file
    with open(file_path, 'w') as tcl_file:
        tcl_file.write(tcl_code)
        
def set_project(folder_directory, prj_name):
    tcl_code = "# Set the project name and working directory\n"
    tcl_code += generate_set_prj_string(folder_directory,prj_name)
    tcl_code = tcl_code.replace("\\","/")
    
    return tcl_code

def create_project(part_name):
    tcl_code = "# Create a new project\n"
    tcl_code += generate_create_prj_string(part_name)
    tcl_code = tcl_code.replace("\\","/")
    
    return tcl_code

def add_src(folder_directory,file_type):
    # Get all files in the directory
    all_files = get_all_files_in_directory(folder_directory,file_type)
    tcl_code = "# Add the FIFO IP file to the project\n"
    for all_file_path in all_files:
        tcl_code += generate_add_files_string(all_file_path)
    #using '\' makes error in vivado.bat. this should be replaced in '/'
    tcl_code = tcl_code.replace("\\","/")
    
    return tcl_code

def set_board(board_path, board_name):
    tcl_code = "# Set the target board\n"
    tcl_code += generate_set_board(board_path, board_name)
    tcl_code = tcl_code.replace("\\","/")
    
    return tcl_code

if __name__ == "__main__":
    # Replace "your_tcl_file.tcl" with the path to your actual TCL file
    prj_name = "TimeController"
    folder_directory = "E:\RFSoC\GIT\RFSoC\RFSoC_Design_V1_1\IP_File_00\TimeController"
    part_name = "xczu28dr-ffvg1517-2-e"
    board_path = "E:/Xilinx/Vivado/2020.2/data/boards/board_files"
    board_name = "xilinx.com:zcu111:part0:1.4"
    file_type = [".v", ".sv", ".xci"]
    
    make_tcl(folder_directory,prj_name,part_name,board_path,board_name,file_type)
    
    file_path = folder_directory + '\\' + prj_name + '.tcl'
    vivado_path = r"E:\Xilinx\Vivado\2020.2\bin\vivado.bat"  
    
    run_vivado_tcl(vivado_path, file_path)