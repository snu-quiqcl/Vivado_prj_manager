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
CONFIG.ADDRESS_WIDTH                                string   true       32
CONFIG.ARUSER_Width                                 string   true       0
CONFIG.AWUSER_Width                                 string   true       0
CONFIG.Add_NGC_Constraint_AXI                       string   true       false
CONFIG.Almost_Empty_Flag                            string   true       false
CONFIG.Almost_Full_Flag                             string   true       false
CONFIG.BUSER_Width                                  string   true       0
CONFIG.CORE_CLK.FREQ_HZ                             string   true       100000000
CONFIG.C_SELECT_XPM                                 string   true       0
CONFIG.Clock_Enable_Type                            string   true       Slave_Interface_Clock_Enable
CONFIG.Clock_Type_AXI                               string   true       Common_Clock
CONFIG.Component_Name                               string   true       fifo_generator_0
CONFIG.DATA_WIDTH                                   string   true       64
CONFIG.Data_Count                                   string   true       false
CONFIG.Data_Count_Width                             string   true       13
CONFIG.Disable_Timing_Violations                    string   true       false
CONFIG.Disable_Timing_Violations_AXI                string   true       false
CONFIG.Dout_Reset_Value                             string   true       0
CONFIG.Empty_Threshold_Assert_Value                 string   true       4
CONFIG.Empty_Threshold_Assert_Value_axis            string   true       1022
CONFIG.Empty_Threshold_Assert_Value_rach            string   true       1022
CONFIG.Empty_Threshold_Assert_Value_rdch            string   true       1022
CONFIG.Empty_Threshold_Assert_Value_wach            string   true       1022
CONFIG.Empty_Threshold_Assert_Value_wdch            string   true       1022
CONFIG.Empty_Threshold_Assert_Value_wrch            string   true       1022
CONFIG.Empty_Threshold_Negate_Value                 string   true       5
CONFIG.Enable_Common_Overflow                       string   true       false
CONFIG.Enable_Common_Underflow                      string   true       false
CONFIG.Enable_Data_Counts_axis                      string   true       false
CONFIG.Enable_Data_Counts_rach                      string   true       false
CONFIG.Enable_Data_Counts_rdch                      string   true       false
CONFIG.Enable_Data_Counts_wach                      string   true       false
CONFIG.Enable_Data_Counts_wdch                      string   true       false
CONFIG.Enable_Data_Counts_wrch                      string   true       false
CONFIG.Enable_ECC                                   string   true       false
CONFIG.Enable_ECC_Type                              string   true       Hard_ECC
CONFIG.Enable_ECC_axis                              string   true       false
CONFIG.Enable_ECC_rach                              string   true       false
CONFIG.Enable_ECC_rdch                              string   true       false
CONFIG.Enable_ECC_wach                              string   true       false
CONFIG.Enable_ECC_wdch                              string   true       false
CONFIG.Enable_ECC_wrch                              string   true       false
CONFIG.Enable_Reset_Synchronization                 string   true       true
CONFIG.Enable_Safety_Circuit                        string   true       false
CONFIG.Enable_TLAST                                 string   true       false
CONFIG.Enable_TREADY                                string   true       true
CONFIG.FIFO_Application_Type_axis                   string   true       Data_FIFO
CONFIG.FIFO_Application_Type_rach                   string   true       Data_FIFO
CONFIG.FIFO_Application_Type_rdch                   string   true       Data_FIFO
CONFIG.FIFO_Application_Type_wach                   string   true       Data_FIFO
CONFIG.FIFO_Application_Type_wdch                   string   true       Data_FIFO
CONFIG.FIFO_Application_Type_wrch                   string   true       Data_FIFO
CONFIG.FIFO_Implementation_axis                     string   true       Common_Clock_Block_RAM
CONFIG.FIFO_Implementation_rach                     string   true       Common_Clock_Block_RAM
CONFIG.FIFO_Implementation_rdch                     string   true       Common_Clock_Block_RAM
CONFIG.FIFO_Implementation_wach                     string   true       Common_Clock_Block_RAM
CONFIG.FIFO_Implementation_wdch                     string   true       Common_Clock_Block_RAM
CONFIG.FIFO_Implementation_wrch                     string   true       Common_Clock_Block_RAM
CONFIG.Fifo_Implementation                          string   true       Common_Clock_Builtin_FIFO
CONFIG.Full_Flags_Reset_Value                       string   true       0
CONFIG.Full_Threshold_Assert_Value                  string   true       8191
CONFIG.Full_Threshold_Assert_Value_axis             string   true       1023
CONFIG.Full_Threshold_Assert_Value_rach             string   true       1023
CONFIG.Full_Threshold_Assert_Value_rdch             string   true       1023
CONFIG.Full_Threshold_Assert_Value_wach             string   true       1023
CONFIG.Full_Threshold_Assert_Value_wdch             string   true       1023
CONFIG.Full_Threshold_Assert_Value_wrch             string   true       1023
CONFIG.Full_Threshold_Negate_Value                  string   true       8190
CONFIG.HAS_ACLKEN                                   string   true       false
CONFIG.HAS_TKEEP                                    string   true       false
CONFIG.HAS_TSTRB                                    string   true       false
CONFIG.ID_WIDTH                                     string   true       0
CONFIG.INTERFACE_TYPE                               string   true       Native
CONFIG.Inject_Dbit_Error                            string   true       false
CONFIG.Inject_Dbit_Error_axis                       string   true       false
CONFIG.Inject_Dbit_Error_rach                       string   true       false
CONFIG.Inject_Dbit_Error_rdch                       string   true       false
CONFIG.Inject_Dbit_Error_wach                       string   true       false
CONFIG.Inject_Dbit_Error_wdch                       string   true       false
CONFIG.Inject_Dbit_Error_wrch                       string   true       false
CONFIG.Inject_Sbit_Error                            string   true       false
CONFIG.Inject_Sbit_Error_axis                       string   true       false
CONFIG.Inject_Sbit_Error_rach                       string   true       false
CONFIG.Inject_Sbit_Error_rdch                       string   true       false
CONFIG.Inject_Sbit_Error_wach                       string   true       false
CONFIG.Inject_Sbit_Error_wdch                       string   true       false
CONFIG.Inject_Sbit_Error_wrch                       string   true       false
CONFIG.Input_Data_Width                             string   true       8
CONFIG.Input_Depth                                  string   true       8192
CONFIG.Input_Depth_axis                             string   true       1024
CONFIG.Input_Depth_rach                             string   true       16
CONFIG.Input_Depth_rdch                             string   true       1024
CONFIG.Input_Depth_wach                             string   true       16
CONFIG.Input_Depth_wdch                             string   true       1024
CONFIG.Input_Depth_wrch                             string   true       16
CONFIG.MASTER_ACLK.FREQ_HZ                          string   true       100000000
CONFIG.Master_interface_Clock_enable_memory_mapped  string   true       false
CONFIG.Output_Data_Width                            string   true       8
CONFIG.Output_Depth                                 string   true       8192
CONFIG.Output_Register_Type                         string   true       Embedded_Reg
CONFIG.Overflow_Flag                                string   true       true
CONFIG.Overflow_Flag_AXI                            string   true       false
CONFIG.Overflow_Sense                               string   true       Active_High
CONFIG.Overflow_Sense_AXI                           string   true       Active_High
CONFIG.PROTOCOL                                     string   true       AXI4
CONFIG.Performance_Options                          string   true       First_Word_Fall_Through
CONFIG.Programmable_Empty_Type                      string   true       No_Programmable_Empty_Threshold
CONFIG.Programmable_Empty_Type_axis                 string   true       No_Programmable_Empty_Threshold
CONFIG.Programmable_Empty_Type_rach                 string   true       No_Programmable_Empty_Threshold
CONFIG.Programmable_Empty_Type_rdch                 string   true       No_Programmable_Empty_Threshold
CONFIG.Programmable_Empty_Type_wach                 string   true       No_Programmable_Empty_Threshold
CONFIG.Programmable_Empty_Type_wdch                 string   true       No_Programmable_Empty_Threshold
CONFIG.Programmable_Empty_Type_wrch                 string   true       No_Programmable_Empty_Threshold
CONFIG.Programmable_Full_Type                       string   true       No_Programmable_Full_Threshold
CONFIG.Programmable_Full_Type_axis                  string   true       No_Programmable_Full_Threshold
CONFIG.Programmable_Full_Type_rach                  string   true       No_Programmable_Full_Threshold
CONFIG.Programmable_Full_Type_rdch                  string   true       No_Programmable_Full_Threshold
CONFIG.Programmable_Full_Type_wach                  string   true       No_Programmable_Full_Threshold
CONFIG.Programmable_Full_Type_wdch                  string   true       No_Programmable_Full_Threshold
CONFIG.Programmable_Full_Type_wrch                  string   true       No_Programmable_Full_Threshold
CONFIG.READ_CLK.FREQ_HZ                             string   true       100000000
CONFIG.READ_WRITE_MODE                              string   true       READ_WRITE
CONFIG.RUSER_Width                                  string   true       0
CONFIG.Read_Clock_Frequency                         string   true       1
CONFIG.Read_Data_Count                              string   true       false
CONFIG.Read_Data_Count_Width                        string   true       13
CONFIG.Register_Slice_Mode_axis                     string   true       Fully_Registered
CONFIG.Register_Slice_Mode_rach                     string   true       Fully_Registered
CONFIG.Register_Slice_Mode_rdch                     string   true       Fully_Registered
CONFIG.Register_Slice_Mode_wach                     string   true       Fully_Registered
CONFIG.Register_Slice_Mode_wdch                     string   true       Fully_Registered
CONFIG.Register_Slice_Mode_wrch                     string   true       Fully_Registered
CONFIG.Reset_Pin                                    string   true       true
CONFIG.Reset_Type                                   string   true       Asynchronous_Reset
CONFIG.SLAVE_ACLK.FREQ_HZ                           string   true       100000000
CONFIG.Slave_interface_Clock_enable_memory_mapped   string   true       false
CONFIG.TDATA_NUM_BYTES                              string   true       1
CONFIG.TDEST_WIDTH                                  string   true       0
CONFIG.TID_WIDTH                                    string   true       0
CONFIG.TKEEP_WIDTH                                  string   true       1
CONFIG.TSTRB_WIDTH                                  string   true       1
CONFIG.TUSER_WIDTH                                  string   true       4
CONFIG.Underflow_Flag                               string   true       true
CONFIG.Underflow_Flag_AXI                           string   true       false
CONFIG.Underflow_Sense                              string   true       Active_High
CONFIG.Underflow_Sense_AXI                          string   true       Active_High
CONFIG.Use_Dout_Reset                               string   true       false
CONFIG.Use_Embedded_Registers                       string   true       false
CONFIG.Use_Embedded_Registers_axis                  string   true       false
CONFIG.Use_Extra_Logic                              string   true       false
CONFIG.Valid_Flag                                   string   true       false
CONFIG.Valid_Sense                                  string   true       Active_High
CONFIG.WRITE_CLK.FREQ_HZ                            string   true       100000000
CONFIG.WUSER_Width                                  string   true       0
CONFIG.Write_Acknowledge_Flag                       string   true       false
CONFIG.Write_Acknowledge_Sense                      string   true       Active_High
CONFIG.Write_Clock_Frequency                        string   true       1
CONFIG.Write_Data_Count                             string   true       false
CONFIG.Write_Data_Count_Width                       string   true       13
CONFIG.asymmetric_port_width                        string   true       false
CONFIG.axis_type                                    string   true       FIFO
CONFIG.dynamic_power_saving                         string   true       false
CONFIG.ecc_pipeline_reg                             string   true       false
CONFIG.enable_low_latency                           string   true       false
CONFIG.enable_read_pointer_increment_by2            string   true       false
CONFIG.rach_type                                    string   true       FIFO
CONFIG.rdch_type                                    string   true       FIFO
CONFIG.synchronization_stages                       string   true       2
CONFIG.synchronization_stages_axi                   string   true       2
CONFIG.use_dout_register                            string   true       false
CONFIG.wach_type                                    string   true       FIFO
CONFIG.wdch_type                                    string   true       FIFO
CONFIG.wrch_type                                    string   true       FIFO
"""
    Convert2json(input_str)