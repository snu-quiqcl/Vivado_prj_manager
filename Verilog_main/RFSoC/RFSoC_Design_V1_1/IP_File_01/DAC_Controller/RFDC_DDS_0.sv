`timescale 1ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SNU QuIQCL
// Engineer: Jeonghyun Park
// 
// Create Date: 2023/08/24 16:55:51
// Design Name: 
// Module Name: RFDC_DDS_0
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


(* use_dsp = "yes" *) module RFDC_DDS_0(
    input wire CLK100MHz,
    input wire [47:0] freq,
    input wire [13:0] amp,              // unsigned value
    input wire [13:0] phase,
    input wire [63:0] timestamp,
    input wire [13:0] amp_offset,
    input wire [63:0] time_offset,
    output wire [255:0] m_axis_data_tdata,
    output wire m_axis_data_tvalid
);

/*
For 16 dds_compiler
0 to 15 = 2**4 - 1 = [3:0] fine_timestamp
-> {timestamp,fine_timestampe}

Xilinx dds_compiler : v6.0 input Phase : (2pi/(2**14 - 1)) * input
-> (input_incr/(2**14 - 1)) * (16 * F_sys) = F_actual
One period of timestamp = (1/F_actual) * 10**8 (since it has 10ns resolution)
Input_incr: freq * timestamp -> [(freq_bin) * (1/F_actual) * (10 ** 8) ][n+13:n] = 2**14 - 1
F_actual = (freq_bin/(2**48 - 2**34)) * 16 * 10 ** 8 Hz
->[(2**48 - 2**34)][n+13:n] = 2 ** 14 - 1
= [2 ** 14 - 1][n-21:n-34]
-> n = 34

DSP : 27 * 18 two's complement
72 bit * 48 bit -> 3DSP
Unsigned 72 *  Unsigned 48 bit -> 120 bit

*/

wire [15:0] dds_output_wire[16];
wire [15:0] dds_output_valid; 
wire [3:0] dds_output_valid_chain;
wire [120:0] phase_full_product[16];
wire [31:0] amp_full_product[16];
wire [15:0] phase_input[16];

assign dds_output_valid_chain[0] = dds_output_valid[0] & dds_output_valid[1] & dds_output_valid[2] & dds_output_valid[3];
assign dds_output_valid_chain[1] = dds_output_valid[4] & dds_output_valid[5] & dds_output_valid[6] & dds_output_valid[7];
assign dds_output_valid_chain[2] = dds_output_valid[8] & dds_output_valid[9] & dds_output_valid[10] & dds_output_valid[11];
assign dds_output_valid_chain[3] = dds_output_valid[12] & dds_output_valid[13] & dds_output_valid[14] & dds_output_valid[15];
assign m_axis_data_tvalid = dds_output_valid_chain[0] & dds_output_valid_chain[1] & dds_output_valid_chain[2] & dds_output_valid_chain[3];

always @(posedge CLK100MHz) begin
    
end

// Generate loop to assign dds_output_wire slices to m_axis_data_tdata
genvar i;
generate
    for (i = 0; i < 16; i = i + 1) begin : ASSIGN_GEN
        assign amp_full_product[i] = {{16{dds_output_wire[i][15]}},dds_output_wire[i]} * {18'h0,amp};
        assign m_axis_data_tdata[16*i +: 16] = amp_full_product[i][29:14] + {2'b00,amp_offset[13:0]};
        assign phase_full_product[i] = (freq * ( {timestamp-time_offset,4'b0000} + i ));
        assign phase_input[i] = {2'h0, phase_full_product[i][47:34] + phase};
    end
endgenerate

dds_compiler_0 dds_0(
    .s_axis_phase_tdata(phase_input[0]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[0]),
    .m_axis_data_tvalid(dds_output_valid[0]),
    .aclk(CLK100MHz)
);


dds_compiler_1 dds_1(
    .s_axis_phase_tdata(phase_input[1]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[1]),
    .m_axis_data_tvalid(dds_output_valid[1]),
    .aclk(CLK100MHz)
);


dds_compiler_2 dds_2(
    .s_axis_phase_tdata(phase_input[2]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[2]),
    .m_axis_data_tvalid(dds_output_valid[2]),
    .aclk(CLK100MHz)
);


dds_compiler_3 dds_3(
    .s_axis_phase_tdata(phase_input[3]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[3]),
    .m_axis_data_tvalid(dds_output_valid[3]),
    .aclk(CLK100MHz)
);


dds_compiler_4 dds_4(
    .s_axis_phase_tdata(phase_input[4]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[4]),
    .m_axis_data_tvalid(dds_output_valid[4]),
    .aclk(CLK100MHz)
);


dds_compiler_5 dds_5(
    .s_axis_phase_tdata(phase_input[5]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[5]),
    .m_axis_data_tvalid(dds_output_valid[5]),
    .aclk(CLK100MHz)
);


dds_compiler_6 dds_6(
    .s_axis_phase_tdata(phase_input[6]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[6]),
    .m_axis_data_tvalid(dds_output_valid[6]),
    .aclk(CLK100MHz)
);


dds_compiler_7 dds_7(
    .s_axis_phase_tdata(phase_input[7]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[7]),
    .m_axis_data_tvalid(dds_output_valid[7]),
    .aclk(CLK100MHz)
);


dds_compiler_8 dds_8(
    .s_axis_phase_tdata(phase_input[8]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[8]),
    .m_axis_data_tvalid(dds_output_valid[8]),
    .aclk(CLK100MHz)
);


dds_compiler_9 dds_9(
    .s_axis_phase_tdata(phase_input[9]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[9]),
    .m_axis_data_tvalid(dds_output_valid[9]),
    .aclk(CLK100MHz)
);


dds_compiler_10 dds_10(
    .s_axis_phase_tdata(phase_input[10]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[10]),
    .m_axis_data_tvalid(dds_output_valid[10]),
    .aclk(CLK100MHz)
);


dds_compiler_11 dds_11(
    .s_axis_phase_tdata(phase_input[11]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[11]),
    .m_axis_data_tvalid(dds_output_valid[11]),
    .aclk(CLK100MHz)
);


dds_compiler_12 dds_12(
    .s_axis_phase_tdata(phase_input[12]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[12]),
    .m_axis_data_tvalid(dds_output_valid[12]),
    .aclk(CLK100MHz)
);


dds_compiler_13 dds_13(
    .s_axis_phase_tdata(phase_input[13]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[13]),
    .m_axis_data_tvalid(dds_output_valid[13]),
    .aclk(CLK100MHz)
);


dds_compiler_14 dds_14(
    .s_axis_phase_tdata(phase_input[14]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[14]),
    .m_axis_data_tvalid(dds_output_valid[14]),
    .aclk(CLK100MHz)
);


dds_compiler_15 dds_15(
    .s_axis_phase_tdata(phase_input[15]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[15]),
    .m_axis_data_tvalid(dds_output_valid[15]),
    .aclk(CLK100MHz)
);
endmodule
