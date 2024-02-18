# -*- coding: utf-8 -*-
"""
Created on Sun Feb 18 20:48:22 2024

@author: alexi
"""
import re

a = r"""CONFIG.CLKIN1_JITTER_PS {80.0}    CONFIG.CLKOUT1_DRIVES {Buffer}    CONFIG.CLKOUT1_JITTER {92.027}    CONFIG.CLKOUT1_PHASE_ERROR {96.948}    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {500}    CONFIG.CLKOUT2_DRIVES {Buffer}    CONFIG.CLKOUT3_DRIVES {Buffer}    CONFIG.CLKOUT4_DRIVES {Buffer}    CONFIG.CLKOUT5_DRIVES {Buffer}    CONFIG.CLKOUT6_DRIVES {Buffer}    CONFIG.CLKOUT7_DRIVES {Buffer}    CONFIG.MMCM_BANDWIDTH {OPTIMIZED}    CONFIG.MMCM_CLKFBOUT_MULT_F {8}    CONFIG.MMCM_CLKIN1_PERIOD {8.000}    CONFIG.MMCM_CLKOUT0_DIVIDE_F {2}    CONFIG.MMCM_COMPENSATION {AUTO}    CONFIG.PLL_CLKIN_PERIOD {8.000}    CONFIG.PRIMITIVE {PLL}    CONFIG.PRIM_IN_FREQ {124.998749}    CONFIG.RESET_PORT {resetn}    CONFIG.RESET_TYPE {ACTIVE_LOW}"""

pattern = r'CONFIG\.([^ ]+) \{([^}]+)\}'

# Replacement pattern
replacement = r'"\1" : "\2",\n'

# Perform the replacement
converted_string = re.sub(pattern, replacement, a).replace('\\','')

with open("CPU.json", "w") as file:
    file.write(converted_string)

print("Data saved to CPU.json")