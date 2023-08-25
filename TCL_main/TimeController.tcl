# Set the project name and working directory
set project_name "TimeController"
set project_dir "E:/RFSoC/GIT/Vivado_prj_manager/TCL_main"

# Create a new project
create_project ${project_name} ${project_dir}/${project_name} -part xczu28dr-ffvg1517-2-e

# Add the FIFO IP file to the project

# Set the target board
set boardpath {E:/Xilinx/Vivado/2020.2/data/boards/board_files}
set_param board.repoPaths [list $boardpath]
set_property BOARD_PART xilinx.com:zcu111:part0:1.4 [current_project]

