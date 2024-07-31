# -*- coding: utf-8 -*-
"""
Created on Fri Apr 12 14:47:04 2024

@author: alexi
"""
import re

def Convert2json(input_str):
    # Sample data lines
    data_lines = input_str.strip().split('\n')
    
    # Pattern to match the required format
    pattern = r"CONFIG\.([\w\.]+)\s+([\w\.]+)\s+([\w\.]+)\s+([^\n]+)"
    
    # Process each line using the regex
    for line in data_lines:
        match = re.match(pattern, line)
        if match:
            key, dummy1, dummy2, value = match.groups()
            if not (key == "Component_Name"):
                print(',')
                transformed_line = f'"{key}" : "{value}"'
                print(transformed_line,end='')

if __name__ == "__main__":
    input_str = """
CONFIG.C_BUFGCE_DIV                 string   false      1
CONFIG.C_BUFG_GT_SYNC               string   false      false
CONFIG.C_BUF_TYPE                   string   false      OBUFDS
CONFIG.C_OBUFDS_GTE5_ADV            string   false      "00"
CONFIG.C_REFCLK_ICNTL_TX            string   false      "00000"
CONFIG.C_SIZE                       string   false      1
CONFIG.Component_Name               string   false      RFSoC_Main_blk_util_ds_buf_0_0
CONFIG.DIFF_CLK_IN_BOARD_INTERFACE  string   false      Custom
CONFIG.USE_BOARD_FLOW               string   false      false
"""
    Convert2json(input_str)