`timescale 0.1ps / 0.1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/31 16:33:57
// Design Name: 
// Module Name: RFSoC_Main_TB00
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RFSoC_Main_TB00;
reg         dac0_clk_n;
reg         dac0_clk_p;

initial begin
    dac0_clk_n <= 1'b0;
    dac0_clk_p <= 1'b1;
end

always begin
    #3125
    dac0_clk_n <= ~dac0_clk_n;
    dac0_clk_p <= ~dac0_clk_p;
end

wire vout00_v_n;
wire vout00_v_p;
wire vout01_v_n;
wire vout01_v_p;
wire vout02_v_n;
wire vout02_v_p;
wire vout03_v_n;
wire vout03_v_p;
wire vout04_v_n;
wire vout04_v_p;
wire vout05_v_n;
wire vout05_v_p;
wire vout06_v_n;
wire vout06_v_p;
wire vout07_v_n;
wire vout07_v_p;

RFSoC_Main_blk_wrapper tb(
    .RF3_CLKO_A_C_N_228(dac0_clk_n),
    .RF3_CLKO_A_C_N_229(dac0_clk_n),
    .RF3_CLKO_A_C_P_228(dac0_clk_p),
    .RF3_CLKO_A_C_P_229(dac0_clk_p),
    .RFMC_DAC_00_N(vout00_v_n),
    .RFMC_DAC_00_P(vout00_v_p),
    .RFMC_DAC_01_N(vout01_v_n),
    .RFMC_DAC_01_P(vout01_v_p),
    .RFMC_DAC_02_N(vout02_v_n),
    .RFMC_DAC_02_P(vout02_v_p),
    .RFMC_DAC_03_N(vout03_v_n),
    .RFMC_DAC_03_P(vout03_v_p),
    .RFMC_DAC_04_N(vout04_v_n),
    .RFMC_DAC_04_P(vout04_v_p),
    .RFMC_DAC_05_N(vout05_v_n),
    .RFMC_DAC_05_P(vout05_v_p),
    .RFMC_DAC_06_N(vout06_v_n),
    .RFMC_DAC_06_P(vout06_v_p),
    .RFMC_DAC_07_N(vout07_v_n),
    .RFMC_DAC_07_P(vout07_v_p)
);


//////////////////////////////////////////////////////////////////////////////////
// DAC output
//////////////////////////////////////////////////////////////////////////////////
real dac00_p;
real dac00_n;

reg[31:0] dac00_p_int;
reg[31:0] dac00_n_int;

always @ (*) begin
   dac00_p = tb.RFSoC_Main_blk_i.usp_rf_data_converter_0.inst.RFSoC_Main_blk_usp_rf_data_converter_0_0_rf_wrapper_i.tx0_u_dac.SIP_HSDAC_INST.VOUT0_P;
   dac00_n = tb.RFSoC_Main_blk_i.usp_rf_data_converter_0.inst.RFSoC_Main_blk_usp_rf_data_converter_0_0_rf_wrapper_i.tx0_u_dac.SIP_HSDAC_INST.VOUT0_N;
   dac00_p_int = dac00_p * (2 ** 31 - 1);
   dac00_n_int = dac00_n * (2 ** 31 - 1);
end

real dac01_p;
real dac01_n;

reg[31:0] dac01_p_int;
reg[31:0] dac01_n_int;

always @ (*) begin
   dac01_p = tb.RFSoC_Main_blk_i.usp_rf_data_converter_0.inst.RFSoC_Main_blk_usp_rf_data_converter_0_0_rf_wrapper_i.tx0_u_dac.SIP_HSDAC_INST.VOUT1_P;
   dac01_n = tb.RFSoC_Main_blk_i.usp_rf_data_converter_0.inst.RFSoC_Main_blk_usp_rf_data_converter_0_0_rf_wrapper_i.tx0_u_dac.SIP_HSDAC_INST.VOUT1_N;
   dac01_p_int = dac01_p * (2 ** 31 - 1);
   dac01_n_int = dac01_n * (2 ** 31 - 1);
end

real dac02_p;
real dac02_n;

reg[31:0] dac02_p_int;
reg[31:0] dac02_n_int;

always @ (*) begin
   dac02_p = tb.RFSoC_Main_blk_i.usp_rf_data_converter_0.inst.RFSoC_Main_blk_usp_rf_data_converter_0_0_rf_wrapper_i.tx0_u_dac.SIP_HSDAC_INST.VOUT2_P;
   dac02_n = tb.RFSoC_Main_blk_i.usp_rf_data_converter_0.inst.RFSoC_Main_blk_usp_rf_data_converter_0_0_rf_wrapper_i.tx0_u_dac.SIP_HSDAC_INST.VOUT2_N;
   dac02_p_int = dac02_p * (2 ** 31 - 1);
   dac02_n_int = dac02_n * (2 ** 31 - 1);
end

real dac03_p;
real dac03_n;

reg[31:0] dac03_p_int;
reg[31:0] dac03_n_int;

always @ (*) begin
   dac03_p = tb.RFSoC_Main_blk_i.usp_rf_data_converter_0.inst.RFSoC_Main_blk_usp_rf_data_converter_0_0_rf_wrapper_i.tx0_u_dac.SIP_HSDAC_INST.VOUT3_P;
   dac03_n = tb.RFSoC_Main_blk_i.usp_rf_data_converter_0.inst.RFSoC_Main_blk_usp_rf_data_converter_0_0_rf_wrapper_i.tx0_u_dac.SIP_HSDAC_INST.VOUT3_N;
   dac03_p_int = dac03_p * (2 ** 31 - 1);
   dac03_n_int = dac03_n * (2 ** 31 - 1);
end

real dac04_p;
real dac04_n;

reg[31:0] dac04_p_int;
reg[31:0] dac04_n_int;

always @ (*) begin
   dac04_p = tb.RFSoC_Main_blk_i.usp_rf_data_converter_0.inst.RFSoC_Main_blk_usp_rf_data_converter_0_0_rf_wrapper_i.tx1_u_dac.SIP_HSDAC_INST.VOUT0_P;
   dac04_n = tb.RFSoC_Main_blk_i.usp_rf_data_converter_0.inst.RFSoC_Main_blk_usp_rf_data_converter_0_0_rf_wrapper_i.tx1_u_dac.SIP_HSDAC_INST.VOUT0_N;
   dac04_p_int = dac04_p * (2 ** 31 - 1);
   dac04_n_int = dac04_n * (2 ** 31 - 1);
end

real dac05_p;
real dac05_n;

reg[31:0] dac05_p_int;
reg[31:0] dac05_n_int;

always @ (*) begin
   dac05_p = tb.RFSoC_Main_blk_i.usp_rf_data_converter_0.inst.RFSoC_Main_blk_usp_rf_data_converter_0_0_rf_wrapper_i.tx1_u_dac.SIP_HSDAC_INST.VOUT1_P;
   dac05_n = tb.RFSoC_Main_blk_i.usp_rf_data_converter_0.inst.RFSoC_Main_blk_usp_rf_data_converter_0_0_rf_wrapper_i.tx1_u_dac.SIP_HSDAC_INST.VOUT1_N;
   dac05_p_int = dac05_p * (2 ** 31 - 1);
   dac05_n_int = dac05_n * (2 ** 31 - 1);
end

real dac06_p;
real dac06_n;

reg[31:0] dac06_p_int;
reg[31:0] dac06_n_int;

always @ (*) begin
   dac06_p = tb.RFSoC_Main_blk_i.usp_rf_data_converter_0.inst.RFSoC_Main_blk_usp_rf_data_converter_0_0_rf_wrapper_i.tx1_u_dac.SIP_HSDAC_INST.VOUT2_P;
   dac06_n = tb.RFSoC_Main_blk_i.usp_rf_data_converter_0.inst.RFSoC_Main_blk_usp_rf_data_converter_0_0_rf_wrapper_i.tx1_u_dac.SIP_HSDAC_INST.VOUT2_N;
   dac06_p_int = dac06_p * (2 ** 31 - 1);
   dac06_n_int = dac06_n * (2 ** 31 - 1);
end

real dac07_p;
real dac07_n;

reg[31:0] dac07_p_int;
reg[31:0] dac07_n_int;

always @ (*) begin
   dac07_p = tb.RFSoC_Main_blk_i.usp_rf_data_converter_0.inst.RFSoC_Main_blk_usp_rf_data_converter_0_0_rf_wrapper_i.tx1_u_dac.SIP_HSDAC_INST.VOUT3_P;
   dac07_n = tb.RFSoC_Main_blk_i.usp_rf_data_converter_0.inst.RFSoC_Main_blk_usp_rf_data_converter_0_0_rf_wrapper_i.tx1_u_dac.SIP_HSDAC_INST.VOUT3_N;
   dac07_p_int = dac07_p * (2 ** 31 - 1);
   dac07_n_int = dac07_n * (2 ** 31 - 1);
end

/*
for i in range(8):
    if i < 4:
        a = f"""real dac0{i}_p;
real dac0{i}_n;

reg[31:0] dac0{i}_p_int;
reg[31:0] dac0{i}_n_int;

always @ (*) begin
   dac0{i}_p = tb.RFSoC_Main_blk_i.usp_rf_data_converter_0.inst.RFSoC_Main_blk_usp_rf_data_converter_0_0_rf_wrapper_i.tx0_u_dac.SIP_HSDAC_INST.VOUT{i}_P;
   dac0{i}_n = tb.RFSoC_Main_blk_i.usp_rf_data_converter_0.inst.RFSoC_Main_blk_usp_rf_data_converter_0_0_rf_wrapper_i.tx0_u_dac.SIP_HSDAC_INST.VOUT{i}_N;
   dac0{i}_p_int = dac0{i}_p * (2 ** 31 - 1);
   dac0{i}_n_int = dac0{i}_n * (2 ** 31 - 1);
end
        """
    else:
        a = f"""real dac0{i}_p;
real dac0{i}_n;

reg[31:0] dac0{i}_p_int;
reg[31:0] dac0{i}_n_int;

always @ (*) begin
   dac0{i}_p = tb.RFSoC_Main_blk_i.usp_rf_data_converter_0.inst.RFSoC_Main_blk_usp_rf_data_converter_0_0_rf_wrapper_i.tx1_u_dac.SIP_HSDAC_INST.VOUT{i-4}_P;
   dac0{i}_n = tb.RFSoC_Main_blk_i.usp_rf_data_converter_0.inst.RFSoC_Main_blk_usp_rf_data_converter_0_0_rf_wrapper_i.tx1_u_dac.SIP_HSDAC_INST.VOUT{i-4}_N;
   dac0{i}_p_int = dac0{i}_p * (2 ** 31 - 1);
   dac0{i}_n_int = dac0{i}_n * (2 ** 31 - 1);
end
        """
    print(a)
*/


reg[1:0] resp1;
reg[1:0] resp2;
reg[1:0] resp3;
reg[1:0] resp4;
reg[1:0] resp5;
reg[1:0] resp6;
reg[1:0] resp7;
reg[1:0] resp8;
reg[1:0] resp9;

initial begin
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.por_srstb_reset(1'b1);
    #2000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.por_srstb_reset(1'b0);
    #2000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.fpga_soft_reset(4'hf);
    #4000000;
    //minimum 16 clock pulse width delay
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.por_srstb_reset(1'b1);
    #4000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.fpga_soft_reset(4'h0);
    
    //////////////////////////////////////////////////////////////////////////////////
    // Restart Machine
    //////////////////////////////////////////////////////////////////////////////////
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha000c004, 8'h04, 32'h00000001, resp2);
    
    #1700000000;
    
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0000000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000001 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h00110210, resp1);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0000000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000001000 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h00226210, resp1);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0000000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000002000 << 64) + (14'h00ff << 46) + (14'h0000 << 32) + 32'h00226210, resp1);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0000000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000003000 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h00226210, resp1);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0000000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000004000 << 64) + (14'h0000 << 46) + (14'h0000 << 32) + 32'h00226210, resp1);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0000000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000005000 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h00226210, resp1);
    #10000000;


    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0001000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000001 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h00110210, resp2);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0001000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000001500 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h00526210, resp2);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0001000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000002000 << 64) + (14'h00ff << 46) + (14'h0000 << 32) + 32'h00226210, resp2);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0001000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000003000 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h00226210, resp2);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0001000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000004000 << 64) + (14'h0000 << 46) + (14'h0000 << 32) + 32'h00526210, resp2);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0001000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000005000 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h00526210, resp2);
    #10000000;


    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0002000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000001 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h00110210, resp3);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0002000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000001000 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h00226210, resp3);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0002000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000002000 << 64) + (14'h00ff << 46) + (14'h0000 << 32) + 32'h00226210, resp3);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0002000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000003000 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h00926210, resp3);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0002000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000004000 << 64) + (14'h0000 << 46) + (14'h0000 << 32) + 32'h00926210, resp3);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0002000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000005000 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h00926210, resp3);
    #10000000;


    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0003000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000001 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h00110210, resp4);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0003000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000001000 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h00226210, resp4);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0003000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000002000 << 64) + (14'h00ff << 46) + (14'h0000 << 32) + 32'h00226210, resp4);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0003000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000003000 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h00226210, resp4);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0003000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000004000 << 64) + (14'h0000 << 46) + (14'h0000 << 32) + 32'h00226210, resp4);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0003000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000005000 << 64) + (14'h0000 << 46) + (14'h0000 << 32) + 32'h00226210, resp4);
    #10000000;


    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0004000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000001 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h00110210, resp5);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0004000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000001000 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h00226210, resp5);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0004000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000002000 << 64) + (14'h00ff << 46) + (14'h0000 << 32) + 32'h00226210, resp5);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0004000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000003000 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h00226210, resp5);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0004000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000004000 << 64) + (14'h0000 << 46) + (14'h0000 << 32) + 32'h00226210, resp5);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0004000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000005000 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h02226210, resp5);
    #10000000;


    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0005000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000001 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h00110210, resp6);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0005000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000001000 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h00226210, resp6);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0005000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000002000 << 64) + (14'h0000 << 46) + (14'h0000 << 32) + 32'h00226210, resp6);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0005000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000003000 << 64) + (14'h0000 << 46) + (14'h0000 << 32) + 32'h00226210, resp6);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0005000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000004000 << 64) + (14'h0000 << 46) + (14'h0000 << 32) + 32'h00226210, resp6);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0005000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000005000 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h00226210, resp6);
    #10000000;


    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0006000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000001 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h00110210, resp7);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0006000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000001000 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h00226210, resp7);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0006000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000002000 << 64) + (14'h00ff << 46) + (14'h0000 << 32) + 32'h00226210, resp7);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0006000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000003000 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h00226210, resp7);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0006000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000004000 << 64) + (14'h0000 << 46) + (14'h0000 << 32) + 32'h00226210, resp7);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0006000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000005000 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h00000000, resp7);
    #10000000;


    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0007000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000001 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h00110210, resp8);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0007000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000001000 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h00226210, resp8);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0007000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000002000 << 64) + (14'h00ff << 46) + (14'h0000 << 32) + 32'h00226210, resp8);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0007000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000003000 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h00226210, resp8);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0007000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000004000 << 64) + (14'h0000 << 46) + (14'h0000 << 32) + 32'h00226210, resp8);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0007000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000005000 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h00226210, resp8);
    #10000000;
    
    //TimeController
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0008000, 8'h10, 128'h00000000000000000000000000000000 + 4'b0010, resp9);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0008000, 8'h10, 128'h00000000000000000000000000000000 + 4'b1001, resp9);
end

endmodule
