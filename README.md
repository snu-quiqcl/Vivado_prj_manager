<img width="80%" src=https://github.com/snu-quiqcl/RFSoC/assets/49219392/304ff119-cee9-46a9-b3de-0a288b984e47>

# Vivado_prj_manager
Create TCL file and execute TCL code automatically.
## TCL_Creater_v1_01
Make TCL files in DAC_Controller and TimeController which creates .xpr file automatically. After this, this creates block file which can be simulated or compiled to bit file.

## Verilog_Creater_v1_00
Open DAC_Controller files and index modules and xilins ips to prevent duplication error. After this creates TCL file and make xpr file and customized ip file automatically.

250MHz -> Reaaching to 250MHz is challenging, so we have to return to 100MHz, nad use 1.25ns resolution of TTL signal.

A fully completed device development is required.

## Vitis_Creator_v1_00
This python program creates platform and application project automatically with .xsa file which is created from vivado. This project includes firmware file which run binary code(ELF file) and conduct TCP communication.

## Compiler
This python program requires GNU aarch64-none-elf-g++ compiler in window to compile cpp files. It contains linker file, and start file which initialize BSS section before get into main function. After this it sends binary code to RFSoC with TCP protocol and run this code.

you can download gnu compiler in here:
https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads
(aarch64-none-elf)
