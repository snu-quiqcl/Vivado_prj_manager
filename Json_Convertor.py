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
CONFIG.ADDRESS_WIDTH                                string   false      32
CONFIG.ARUSER_Width                                 string   false      0
CONFIG.AWUSER_Width                                 string   false      0
CONFIG.Add_NGC_Constraint_AXI                       string   false      false
CONFIG.Almost_Empty_Flag                            string   false      false
CONFIG.Almost_Full_Flag                             string   false      false
CONFIG.BUSER_Width                                  string   false      0
CONFIG.CORE_CLK.FREQ_HZ                             string   false      100000000
CONFIG.CORE_CLK.INSERT_VIP                          string   false      0
CONFIG.C_SELECT_XPM                                 string   false      0
CONFIG.Clock_Enable_Type                            string   false      Slave_Interface_Clock_Enable
CONFIG.Clock_Type_AXI                               string   false      Common_Clock
CONFIG.Component_Name                               string   false      GTH_serializer_async_fifo
CONFIG.DATA_WIDTH                                   string   false      64
CONFIG.Data_Count                                   string   false      false
CONFIG.Data_Count_Width                             string   false      10
CONFIG.Disable_Timing_Violations                    string   false      false
CONFIG.Disable_Timing_Violations_AXI                string   false      false
CONFIG.Dout_Reset_Value                             string   false      0
CONFIG.Empty_Threshold_Assert_Value                 string   false      4
CONFIG.Empty_Threshold_Assert_Value_axis            string   false      1022
CONFIG.Empty_Threshold_Assert_Value_rach            string   false      1022
CONFIG.Empty_Threshold_Assert_Value_rdch            string   false      1022
CONFIG.Empty_Threshold_Assert_Value_wach            string   false      1022
CONFIG.Empty_Threshold_Assert_Value_wdch            string   false      1022
CONFIG.Empty_Threshold_Assert_Value_wrch            string   false      1022
CONFIG.Empty_Threshold_Negate_Value                 string   false      5
CONFIG.Enable_Common_Overflow                       string   false      false
CONFIG.Enable_Common_Underflow                      string   false      false
CONFIG.Enable_Data_Counts_axis                      string   false      false
CONFIG.Enable_Data_Counts_rach                      string   false      false
CONFIG.Enable_Data_Counts_rdch                      string   false      false
CONFIG.Enable_Data_Counts_wach                      string   false      false
CONFIG.Enable_Data_Counts_wdch                      string   false      false
CONFIG.Enable_Data_Counts_wrch                      string   false      false
CONFIG.Enable_ECC                                   string   false      false
CONFIG.Enable_ECC_Type                              string   false      Hard_ECC
CONFIG.Enable_ECC_axis                              string   false      false
CONFIG.Enable_ECC_rach                              string   false      false
CONFIG.Enable_ECC_rdch                              string   false      false
CONFIG.Enable_ECC_wach                              string   false      false
CONFIG.Enable_ECC_wdch                              string   false      false
CONFIG.Enable_ECC_wrch                              string   false      false
CONFIG.Enable_Reset_Synchronization                 string   false      true
CONFIG.Enable_Safety_Circuit                        string   false      false
CONFIG.Enable_TLAST                                 string   false      false
CONFIG.Enable_TREADY                                string   false      true
CONFIG.FIFO_Application_Type_axis                   string   false      Data_FIFO
CONFIG.FIFO_Application_Type_rach                   string   false      Data_FIFO
CONFIG.FIFO_Application_Type_rdch                   string   false      Data_FIFO
CONFIG.FIFO_Application_Type_wach                   string   false      Data_FIFO
CONFIG.FIFO_Application_Type_wdch                   string   false      Data_FIFO
CONFIG.FIFO_Application_Type_wrch                   string   false      Data_FIFO
CONFIG.FIFO_Implementation_axis                     string   false      Common_Clock_Block_RAM
CONFIG.FIFO_Implementation_rach                     string   false      Common_Clock_Block_RAM
CONFIG.FIFO_Implementation_rdch                     string   false      Common_Clock_Block_RAM
CONFIG.FIFO_Implementation_wach                     string   false      Common_Clock_Block_RAM
CONFIG.FIFO_Implementation_wdch                     string   false      Common_Clock_Block_RAM
CONFIG.FIFO_Implementation_wrch                     string   false      Common_Clock_Block_RAM
CONFIG.Fifo_Implementation                          string   false      Independent_Clocks_Builtin_FIFO
CONFIG.Full_Flags_Reset_Value                       string   false      0
CONFIG.Full_Threshold_Assert_Value                  string   false      1022
CONFIG.Full_Threshold_Assert_Value_axis             string   false      1023
CONFIG.Full_Threshold_Assert_Value_rach             string   false      1023
CONFIG.Full_Threshold_Assert_Value_rdch             string   false      1023
CONFIG.Full_Threshold_Assert_Value_wach             string   false      1023
CONFIG.Full_Threshold_Assert_Value_wdch             string   false      1023
CONFIG.Full_Threshold_Assert_Value_wrch             string   false      1023
CONFIG.Full_Threshold_Negate_Value                  string   false      1020
CONFIG.HAS_ACLKEN                                   string   false      false
CONFIG.HAS_TKEEP                                    string   false      false
CONFIG.HAS_TSTRB                                    string   false      false
CONFIG.ID_WIDTH                                     string   false      0
CONFIG.INTERFACE_TYPE                               string   false      Native
CONFIG.Inject_Dbit_Error                            string   false      false
CONFIG.Inject_Dbit_Error_axis                       string   false      false
CONFIG.Inject_Dbit_Error_rach                       string   false      false
CONFIG.Inject_Dbit_Error_rdch                       string   false      false
CONFIG.Inject_Dbit_Error_wach                       string   false      false
CONFIG.Inject_Dbit_Error_wdch                       string   false      false
CONFIG.Inject_Dbit_Error_wrch                       string   false      false
CONFIG.Inject_Sbit_Error                            string   false      false
CONFIG.Inject_Sbit_Error_axis                       string   false      false
CONFIG.Inject_Sbit_Error_rach                       string   false      false
CONFIG.Inject_Sbit_Error_rdch                       string   false      false
CONFIG.Inject_Sbit_Error_wach                       string   false      false
CONFIG.Inject_Sbit_Error_wdch                       string   false      false
CONFIG.Inject_Sbit_Error_wrch                       string   false      false
CONFIG.Input_Data_Width                             string   false      60
CONFIG.Input_Depth                                  string   false      1024
CONFIG.Input_Depth_axis                             string   false      1024
CONFIG.Input_Depth_rach                             string   false      16
CONFIG.Input_Depth_rdch                             string   false      1024
CONFIG.Input_Depth_wach                             string   false      16
CONFIG.Input_Depth_wdch                             string   false      1024
CONFIG.Input_Depth_wrch                             string   false      16
CONFIG.MASTER_ACLK.FREQ_HZ                          string   false      100000000
CONFIG.MASTER_ACLK.INSERT_VIP                       string   false      0
CONFIG.M_AXI.INSERT_VIP                             string   false      0
CONFIG.M_AXIS.INSERT_VIP                            string   false      0
CONFIG.Master_interface_Clock_enable_memory_mapped  string   false      false
CONFIG.Output_Data_Width                            string   false      60
CONFIG.Output_Depth                                 string   false      1024
CONFIG.Output_Register_Type                         string   false      Embedded_Reg
CONFIG.Overflow_Flag                                string   false      false
CONFIG.Overflow_Flag_AXI                            string   false      false
CONFIG.Overflow_Sense                               string   false      Active_High
CONFIG.Overflow_Sense_AXI                           string   false      Active_High
CONFIG.PROTOCOL                                     string   false      AXI4
CONFIG.Performance_Options                          string   false      First_Word_Fall_Through
CONFIG.Programmable_Empty_Type                      string   false      No_Programmable_Empty_Threshold
CONFIG.Programmable_Empty_Type_axis                 string   false      No_Programmable_Empty_Threshold
CONFIG.Programmable_Empty_Type_rach                 string   false      No_Programmable_Empty_Threshold
CONFIG.Programmable_Empty_Type_rdch                 string   false      No_Programmable_Empty_Threshold
CONFIG.Programmable_Empty_Type_wach                 string   false      No_Programmable_Empty_Threshold
CONFIG.Programmable_Empty_Type_wdch                 string   false      No_Programmable_Empty_Threshold
CONFIG.Programmable_Empty_Type_wrch                 string   false      No_Programmable_Empty_Threshold
CONFIG.Programmable_Full_Type                       string   false      No_Programmable_Full_Threshold
CONFIG.Programmable_Full_Type_axis                  string   false      No_Programmable_Full_Threshold
CONFIG.Programmable_Full_Type_rach                  string   false      No_Programmable_Full_Threshold
CONFIG.Programmable_Full_Type_rdch                  string   false      No_Programmable_Full_Threshold
CONFIG.Programmable_Full_Type_wach                  string   false      No_Programmable_Full_Threshold
CONFIG.Programmable_Full_Type_wdch                  string   false      No_Programmable_Full_Threshold
CONFIG.Programmable_Full_Type_wrch                  string   false      No_Programmable_Full_Threshold
CONFIG.READ_CLK.FREQ_HZ                             string   false      33000000
CONFIG.READ_CLK.INSERT_VIP                          string   false      0
CONFIG.READ_WRITE_MODE                              string   false      READ_WRITE
CONFIG.RUSER_Width                                  string   false      0
CONFIG.Read_Clock_Frequency                         string   false      33
CONFIG.Read_Data_Count                              string   false      false
CONFIG.Read_Data_Count_Width                        string   false      10
CONFIG.Register_Slice_Mode_axis                     string   false      Fully_Registered
CONFIG.Register_Slice_Mode_rach                     string   false      Fully_Registered
CONFIG.Register_Slice_Mode_rdch                     string   false      Fully_Registered
CONFIG.Register_Slice_Mode_wach                     string   false      Fully_Registered
CONFIG.Register_Slice_Mode_wdch                     string   false      Fully_Registered
CONFIG.Register_Slice_Mode_wrch                     string   false      Fully_Registered
CONFIG.Reset_Pin                                    string   false      true
CONFIG.Reset_Type                                   string   false      Synchronous_Reset
CONFIG.SLAVE_ACLK.FREQ_HZ                           string   false      100000000
CONFIG.SLAVE_ACLK.INSERT_VIP                        string   false      0
CONFIG.SLAVE_ARESETN.INSERT_VIP                     string   false      0
CONFIG.S_AXI.INSERT_VIP                             string   false      0
CONFIG.S_AXIS.INSERT_VIP                            string   false      0
CONFIG.Slave_interface_Clock_enable_memory_mapped   string   false      false
CONFIG.TDATA_NUM_BYTES                              string   false      1
CONFIG.TDEST_WIDTH                                  string   false      0
CONFIG.TID_WIDTH                                    string   false      0
CONFIG.TKEEP_WIDTH                                  string   false      1
CONFIG.TSTRB_WIDTH                                  string   false      1
CONFIG.TUSER_WIDTH                                  string   false      4
CONFIG.Underflow_Flag                               string   false      true
CONFIG.Underflow_Flag_AXI                           string   false      false
CONFIG.Underflow_Sense                              string   false      Active_High
CONFIG.Underflow_Sense_AXI                          string   false      Active_High
CONFIG.Use_Dout_Reset                               string   false      true
CONFIG.Use_Embedded_Registers                       string   false      false
CONFIG.Use_Embedded_Registers_axis                  string   false      false
CONFIG.Use_Extra_Logic                              string   false      false
CONFIG.Valid_Flag                                   string   false      false
CONFIG.Valid_Sense                                  string   false      Active_High
CONFIG.WRITE_CLK.FREQ_HZ                            string   false      67000000
CONFIG.WRITE_CLK.INSERT_VIP                         string   false      0
CONFIG.WUSER_Width                                  string   false      0
CONFIG.Write_Acknowledge_Flag                       string   false      false
CONFIG.Write_Acknowledge_Sense                      string   false      Active_High
CONFIG.Write_Clock_Frequency                        string   false      67
CONFIG.Write_Data_Count                             string   false      false
CONFIG.Write_Data_Count_Width                       string   false      10
CONFIG.asymmetric_port_width                        string   false      false
CONFIG.axis_type                                    string   false      FIFO
CONFIG.dynamic_power_saving                         string   false      false
CONFIG.ecc_pipeline_reg                             string   false      false
CONFIG.enable_low_latency                           string   false      true
CONFIG.enable_read_pointer_increment_by2            string   false      false
CONFIG.rach_type                                    string   false      FIFO
CONFIG.rdch_type                                    string   false      FIFO
CONFIG.synchronization_stages                       string   false      2
CONFIG.synchronization_stages_axi                   string   false      2
CONFIG.use_dout_register                            string   false      false
CONFIG.wach_type                                    string   false      FIFO
CONFIG.wdch_type                                    string   false      FIFO
CONFIG.wrch_type                                    string   false      FIFO
"""
    Convert2json(input_str)