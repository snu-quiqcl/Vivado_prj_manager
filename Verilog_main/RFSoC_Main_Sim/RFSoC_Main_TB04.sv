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
wire        RF3_CLKO_A_C_N_228;
wire        RF3_CLKO_A_C_N_229;
wire        RF3_CLKO_A_C_P_228;
wire        RF3_CLKO_A_C_P_229;
reg rtio_clk;

assign RF3_CLKO_A_C_N_228 = dac0_clk_n;
assign RF3_CLKO_A_C_N_229 = dac0_clk_n;
assign RF3_CLKO_A_C_P_228 = dac0_clk_p;
assign RF3_CLKO_A_C_P_229 = dac0_clk_p;

initial begin
    dac0_clk_n <= 1'b0;
    dac0_clk_p <= 1'b1;
end

initial begin
    rtio_clk <= 1'b0;
end
always begin
    #39800
    rtio_clk <= ~rtio_clk;
end

always begin
    #2500
    dac0_clk_n <= ~dac0_clk_n;
    dac0_clk_p <= ~dac0_clk_p;
end



wire output_pulse_x8_0_n;
wire output_pulse_x8_0_p;
wire output_pulse_x1_0;
wire locked_0;

wire [255:0] m00_axis_0_tdata;
wire m00_axis_0_tready;
wire m00_axis_0_tvalid;
wire [255:0] m00_axis_01_tdata;
wire m00_axis_01_tready;
wire m00_axis_01_tvalid;
wire [255:0] m00_axis_02_tdata;
wire m00_axis_02_tready;
wire m00_axis_02_tvalid;
wire [255:0] m00_axis_03_tdata;
wire m00_axis_03_tready;
wire m00_axis_03_tvalid;
wire [255:0] m00_axis_04_tdata;
wire m00_axis_04_tready;
wire m00_axis_04_tvalid;
wire [255:0] m00_axis_05_tdata;
wire m00_axis_05_tready;
wire m00_axis_05_tvalid;
wire [255:0] m00_axis_06_tdata;
wire m00_axis_06_tready;
wire m00_axis_06_tvalid;
wire [255:0] m00_axis_07_tdata;
wire m00_axis_07_tready;
wire m00_axis_07_tvalid;

/*
for i in range(8):
    a = f"""wire [31:0] vout{i};
assign vout{i} = m00_axis_0{i}_tdata[255:224];"""
    print(a)
*/

wire [31:0] vout0;
assign vout0 = m00_axis_0_tdata[255:224];
wire [31:0] vout1;
assign vout1 = m00_axis_01_tdata[255:224];
wire [31:0] vout2;
assign vout2 = m00_axis_02_tdata[255:224];
wire [31:0] vout3;
assign vout3 = m00_axis_03_tdata[255:224];
wire [31:0] vout4;
assign vout4 = m00_axis_04_tdata[255:224];
wire [31:0] vout5;
assign vout5 = m00_axis_05_tdata[255:224];
wire [31:0] vout6;
assign vout6 = m00_axis_06_tdata[255:224];
wire [31:0] vout7;
assign vout7 = m00_axis_07_tdata[255:224];


RFSoC_Main_blk_wrapper tb(
    /*.RF3_CLKO_A_C_N_228(RF3_CLKO_A_C_N_228),
    .RF3_CLKO_A_C_N_229(RF3_CLKO_A_C_N_229),
    .RF3_CLKO_A_C_P_228(RF3_CLKO_A_C_P_228),
    .RF3_CLKO_A_C_P_229(RF3_CLKO_A_C_P_229)*/
    .m00_axis_0_tdata(m00_axis_0_tdata),
    .m00_axis_0_tready(m00_axis_0_tready),
    .m00_axis_0_tvalid(m00_axis_0_tvalid),/*
    .m00_axis_01_tdata(m00_axis_01_tdata),
    .m00_axis_01_tready(m00_axis_01_tready),
    .m00_axis_01_tvalid(m00_axis_01_tvalid),
    .m00_axis_02_tdata(m00_axis_02_tdata),
    .m00_axis_02_tready(m00_axis_02_tready),
    .m00_axis_02_tvalid(m00_axis_02_tvalid),
    .m00_axis_03_tdata(m00_axis_03_tdata),
    .m00_axis_03_tready(m00_axis_03_tready),
    .m00_axis_03_tvalid(m00_axis_03_tvalid),
    .m00_axis_04_tdata(m00_axis_04_tdata),
    .m00_axis_04_tready(m00_axis_04_tready),
    .m00_axis_04_tvalid(m00_axis_04_tvalid),
    .m00_axis_05_tdata(m00_axis_05_tdata),
    .m00_axis_05_tready(m00_axis_05_tready),
    .m00_axis_05_tvalid(m00_axis_05_tvalid),
    .m00_axis_06_tdata(m00_axis_06_tdata),
    .m00_axis_06_tready(m00_axis_06_tready),
    .m00_axis_06_tvalid(m00_axis_06_tvalid),
    .m00_axis_07_tdata(m00_axis_07_tdata),
    .m00_axis_07_tready(m00_axis_07_tready),
    .m00_axis_07_tvalid(m00_axis_07_tvalid)*/
    /*
    .FMCP_HSPC_LA01_CC_P(output_pulse_x8_0_p),
    .FMCP_HSPC_LA01_CC_N(output_pulse_x8_0_n),*
    .input_sig_0(input_sig)
    */
    .rtio_clk(rtio_clk)
);

/*
import re

def transform_string(s):
    # Split string into lines
    lines = s.strip().split('\n')
    # Transform each line
    transformed_lines = [f".{line.strip(',')}({line.strip(',')})," for line in lines]
    # Join lines back into a single string
    return '\n'.join(transformed_lines)

def transform_string2(s):
    # Split string into lines
    lines = s.strip().split('\n')
    # Transform each line
    transformed_lines = [f"wire {line.strip(',')};" for line in lines]
    # Join lines back into a single string
    return '\n'.join(transformed_lines)
    


a = """m00_axis_00_tdata,
m00_axis_00_tready,
m00_axis_00_tvalid,
m00_axis_01_tdata,
m00_axis_01_tready,
m00_axis_01_tvalid,
m00_axis_02_tdata,
m00_axis_02_tready,
m00_axis_02_tvalid,
m00_axis_03_tdata,
m00_axis_03_tready,
m00_axis_03_tvalid,
m00_axis_04_tdata,
m00_axis_04_tready,
m00_axis_04_tvalid,
m00_axis_05_tdata,
m00_axis_05_tready,
m00_axis_05_tvalid,
m00_axis_06_tdata,
m00_axis_06_tready,
m00_axis_06_tvalid,
m00_axis_07_tdata,
m00_axis_07_tready,
m00_axis_07_tvalid
"""
print(transform_string(a))
*/


//////////////////////////////////////////////////////////////////////////////////
// DAC output
//////////////////////////////////////////////////////////////////////////////////
/*
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
reg[1:0] resp10;
reg[1:0] resp11;

reg [127:0] read_data;

reg input_sig;

int k;
    
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
    #10000000;
    //tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha000c004, 8'h04, 32'h00000001, resp2);
    
    #10000000;
    
    
    ///////////////////////////////////////////////////////////////////////////////////
    // DDS
    ///////////////////////////////////////////////////////////////////////////////////
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0001010, 8'h10, 128'h00000000000000000000000000000001, resp1);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0001000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000001 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h00101210, resp1);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0001000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000010 << 64) + (14'h0000 << 46) + (14'h0000 << 32) + 32'h37006210, resp1);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0001000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000020 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h00506210, resp1);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0001000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000030 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h00006210, resp1);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0001000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000040 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h00100210, resp1);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0001000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000050 << 64) + (14'h3fff << 46) + (14'h0000 << 32) + 32'h01523921, resp1);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0001000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000060 << 64) + (4'b0001 << 60) + 48'h228F5D3119B9, resp1);
    
    
    ///////////////////////////////////////////////////////////////////////////////////
    // TTLx8 Signal
    ///////////////////////////////////////////////////////////////////////////////////
    /*
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0010000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000001 << 64) + 8'b00110000, resp10);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0010000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000001 << 64) + 8'b10110001, resp10);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0010000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000004 << 64) + 8'b00010001, resp10);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0010000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000004 << 64) + 8'b10110001, resp10);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0010000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000005 << 64) + 8'b00110000, resp10);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0010000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000010 << 64) + 8'b11111110, resp10);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0010000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000011 << 64) + 8'b00000000, resp10);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0010000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000012 << 64) + 8'b10101010, resp10);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0010010, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000012 << 64) + 8'b10101011, resp10);
    #10000000;
    
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0010000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000001 << 64) + 8'b00110000, resp10);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0010000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000001 << 64) + 8'b10110001, resp10);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0010000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000004 << 64) + 8'b00010001, resp10);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0010000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000004 << 64) + 8'b10110001, resp10);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0010000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000005 << 64) + 8'b00110000, resp10);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0010000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000010 << 64) + 8'b11111110, resp10);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0010000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000011 << 64) + 8'b00000000, resp10);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0010000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000012 << 64) + 8'b10101010, resp10);
    #10000000;
    */
    ///////////////////////////////////////////////////////////////////////////////////
    // Edge Counter
    ///////////////////////////////////////////////////////////////////////////////////
    
    input_sig <= 1'b0;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0002000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000010 << 64) + 4'b0001, resp10);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0002000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000400 << 64) + 4'b0010, resp10);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0002000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000410 << 64) + 4'b0100, resp10);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0002000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000420 << 64) + 4'b1000, resp10);
    
    
    ///////////////////////////////////////////////////////////////////////////////////
    // TTL Signal
    ///////////////////////////////////////////////////////////////////////////////////
/*
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0020000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000001 << 64) + 8'b00110001, resp11);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0020000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000004 << 64) + 8'b10110001, resp11);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0020000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000005 << 64) + 8'b00110000, resp11);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0020000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000010 << 64) + 8'b11111110, resp11);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0020000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000011 << 64) + 8'b00000000, resp11);
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0020000, 8'h10, 128'h00000000000000000000000000000000 + (64'h0000000000000012 << 64) + 8'b10101011, resp11);
    #10000000;
*/

/*
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
    */
    //TimeController
    #10000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0000000, 8'h10, 128'h00000000000000000000000000000000 + 4'b0010, resp9);
    
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.write_data(32'ha0000000, 8'h10, 128'h00000000000000000000000000000000 + 4'b1001, resp9);
    
    
    
    #2000000;
    input_sig <= 1'b1;
    #100000;
    input_sig <= 1'b0;
    
    #1000000;
    input_sig <= 1'b1;
    #100000;
    input_sig <= 1'b0;
    
    #1000000;
    input_sig <= 1'b1;
    #100000;
    input_sig <= 1'b0;
    //READ
    #100000000;
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.read_data(32'ha0002010, 8'h10, read_data, resp10);
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.read_data(32'ha0002000, 8'h10, read_data, resp10);
    tb.RFSoC_Main_blk_i.zynq_ultra_ps_e_0.inst.read_data(32'ha0002010, 8'h10, read_data, resp10);
    
end

endmodule
