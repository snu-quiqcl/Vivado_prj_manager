# Vivado_prj_manager
It is vivado project maker based on speicified json file. It requires two json files. In first json file, configuration json file, you should write your vivado environment and information about your FPGA board. For instance, path of vivado repository, and version of your vivado are required. In second json file, verilog json file, you should write your verilog code information. For instance, verilog code paths and IP configuration settings are required.

## Configuration JSON file
Below json file is example of configuration json file.

```json
{
    "common_path" : "VERILOG_FILE_PATH",
    "target_path" : "TARGET_PATH",
    "vivado_path" : "C:/Xilinx/Vivado/2020.2/bin/vivado.bat",
    "board_path" : "C:/Xilinx/Vivado/2020.2/data/boards/board_files",
    "part_name" : "xczu28dr-ffvg1517-2-e",
    "board_name" : "xilinx.com:zcu111:part0:1.4",
    "constraints" : "CONSTRAINT_FILE_PATH/ZCU111_Rev1.0.xdc",
    "version" : "2020.2"
}
```

+ ```common_path``` is path common direcotry of which your verilog files exist. For example, common path of ```C:/A/verilog_file1.sv```, ```C:/A/verilog_file2.sv``` and ```C:/A/B/verilog_file3.sv``` is ```C:/A/```. You should write its relative path of verilog files when you make second json file, verilog json file.
  
+ ```target_path``` is path which you want to make vivado project. Vivado project will be created in ```target_path```, and if this path does not exist, it will be created automatically. 

+ ```vivado_path``` is path of ```vivado.bat``` which runs actual vivado TCL code and make vivado project. Note that almost of ```vivado.bat``` is located in ```Xilinx/Vivado/2020.2/bin```. 

+ ```board_path``` is path board files exist, and it is also located in ```Xilinx/Vivado/2020.2/data/boards/board_files``` mostly.

+  ```part_name``` is your xilinx chip part name.

+  ```board_name``` is your FPGA board name. If you don't know it's board name, you can make vivado manually, and check its TCL code.

+  ```constraints``` is your FPGA constraint file path and its name.

+  ```version``` is version of you vivado.

## Verilog JSON file
Below json file is example of verilog json file.

```json
{
    "verilog" : {
        "name" : "TTL_out",
        "top": "TTL_out.sv",
        "files" : [
            "TTL_out/TTL_Controller.sv",
            "TTL_out/TTL_out.sv",
            "RTIO_Lib/AXI2FIFO.sv",
            "RTIO_Lib/GPO_Core.sv",
            "RTIO_Lib/RTOB_Core.sv",
            "RTIO_Lib/adj_fifo.sv"
        ]
    },
    "ip" : {
        "fifo_generator_0" : {
            "name" : "fifo_generator",
            "version" : "13.2",
            "vendor" : "xilinx.com",
            "library" : "ip",
            "tcl_options" : ["name", "version", "vendor", "library", "module_name"],
            "config" : {
                "Fifo_Implementation" : "Independent_Clocks_Builtin_FIFO",
                "Read_Clock_Frequency" : "125",
                "Write_Clock_Frequency" : "125",
                "Performance_Options" : "First_Word_Fall_Through",
                "Input_Data_Width" : "128", 
                "Input_Depth" : "512",
                "Output_Data_Width" : "128", 
                "Output_Depth" : "512",
                "Underflow_Flag" : "true", 
                "Overflow_Flag" : "true",
                "Data_Count_Width" : "5",
                "Write_Data_Count_Width" : "5",
                "Read_Data_Count_Width" : "5", 
                "Programmable_Full_Type" : "Single_Programmable_Full_Threshold_Constant",
                "Full_Threshold_Assert_Value" : "504",
                "Full_Threshold_Negate_Value" : "504",
                "Empty_Threshold_Assert_Value" : "4",
                "Empty_Threshold_Negate_Value" : "5"
            }
        }
    }
}
```

+ ```common_path``` 
