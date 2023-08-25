# -*- coding: utf-8 -*-
"""
Created on Fri Aug 25 15:46:38 2023

@author: QC109_4
"""

class Verilog_maker:
    def __init__(self):
        print('make verilog code...')
        
    def generate_dds_code(self, dds_num):
        DDS_code = ''
        for i in range(dds_num):
            DDS_code += f"""
dds_compiler_{i} dds_{i}(
    .s_axis_phase_tdata(phase_input[{i}]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[{i}]),
    .m_axis_data_tvalid(dds_output_valid[{i}]),
    .aclk(CLK100MHz)
);
\n
                        """