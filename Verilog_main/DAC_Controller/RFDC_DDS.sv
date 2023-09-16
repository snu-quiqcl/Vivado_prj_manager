`timescale 1ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SNU QuIQCL
// Engineer: Jeonghyun Park
// 
// Create Date: 2023/08/24 16:55:51
// Design Name: 
// Module Name: RFDC_DDS
// Project Name: :
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


module RFDC_DDS(
    input wire clk,
    input wire [47:0] freq,
    input wire [13:0] amp,              // unsigned value
    input wire [13:0] phase,
    input wire [63:0] timestamp,
    input wire [13:0] amp_offset,
    input wire [63:0] time_offset,
    output reg [255:0] m_axis_data_tdata,
    output reg m_axis_data_tvalid
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
wire [15:0] phase_input_wire[16];
wire [255:0] m_axis_data_tdata_wire;

wire m_axis_data_tvalid_wire;
reg m_axis_data_tvalid_buffer3;

reg [15:0] phase_input[16];

reg [13:0] amp_buffer1;
reg [13:0] amp_buffer2;
reg [13:0] amp_buffer3;

reg [13:0] amp_offset_buffer1;
reg [13:0] amp_offset_buffer2;
reg [13:0] amp_offset_buffer3;

reg [15:0] dds_output_buffer3[16];

assign dds_output_valid_chain[0] = dds_output_valid[0] & dds_output_valid[1] & dds_output_valid[2] & dds_output_valid[3];
assign dds_output_valid_chain[1] = dds_output_valid[4] & dds_output_valid[5] & dds_output_valid[6] & dds_output_valid[7];
assign dds_output_valid_chain[2] = dds_output_valid[8] & dds_output_valid[9] & dds_output_valid[10] & dds_output_valid[11];
assign dds_output_valid_chain[3] = dds_output_valid[12] & dds_output_valid[13] & dds_output_valid[14] & dds_output_valid[15];
assign m_axis_data_tvalid_wire = dds_output_valid_chain[0] & dds_output_valid_chain[1] & dds_output_valid_chain[2] & dds_output_valid_chain[3];


// Generate loop to assign dds_output_wire slices to m_axis_data_tdata
genvar i;
generate
    for (i = 0; i < 16; i = i + 1) begin : ASSIGN_GEN
        assign amp_full_product[i] = {{2{dds_output_buffer3[i][15]}},dds_output_buffer3[i]} * {2'b00,amp_buffer3};
        assign m_axis_data_tdata_wire[16*i +: 16] = amp_full_product[i][29:14] + {2'b00,amp_offset_buffer3[13:0]};
    end
endgenerate

always@(posedge clk) begin
    m_axis_data_tdata[255:0] <= m_axis_data_tdata_wire[255:0];
    phase_input[0] <= phase_input_wire[0];
    phase_input[1] <= phase_input_wire[1];
    phase_input[2] <= phase_input_wire[2];
    phase_input[3] <= phase_input_wire[3];
    phase_input[4] <= phase_input_wire[4];
    phase_input[5] <= phase_input_wire[5];
    phase_input[6] <= phase_input_wire[6];
    phase_input[7] <= phase_input_wire[7];
    phase_input[8] <= phase_input_wire[8];
    phase_input[9] <= phase_input_wire[9];
    phase_input[10] <= phase_input_wire[10];
    phase_input[11] <= phase_input_wire[11];
    phase_input[12] <= phase_input_wire[12];
    phase_input[13] <= phase_input_wire[13];
    phase_input[14] <= phase_input_wire[14];
    phase_input[15] <= phase_input_wire[15];

    amp_buffer1[13:0] <= amp[13:0];
    amp_buffer2[13:0] <= amp_buffer1[13:0];
    amp_buffer3[13:0] <= amp_buffer2[13:0];

    amp_offset_buffer1[13:0] <= amp_offset[13:0];
    amp_offset_buffer2[13:0] <= amp_offset_buffer1[13:0];
    amp_offset_buffer3[13:0] <= amp_offset_buffer2[13:0];

    dds_output_buffer3[0][15:0] <= dds_output_wire[0][15:0];
    dds_output_buffer3[1][15:0] <= dds_output_wire[1][15:0];
    dds_output_buffer3[2][15:0] <= dds_output_wire[2][15:0];
    dds_output_buffer3[3][15:0] <= dds_output_wire[3][15:0];
    dds_output_buffer3[4][15:0] <= dds_output_wire[4][15:0];
    dds_output_buffer3[5][15:0] <= dds_output_wire[5][15:0];
    dds_output_buffer3[6][15:0] <= dds_output_wire[6][15:0];
    dds_output_buffer3[7][15:0] <= dds_output_wire[7][15:0];
    dds_output_buffer3[8][15:0] <= dds_output_wire[8][15:0];
    dds_output_buffer3[9][15:0] <= dds_output_wire[9][15:0];
    dds_output_buffer3[10][15:0] <= dds_output_wire[10][15:0];
    dds_output_buffer3[11][15:0] <= dds_output_wire[11][15:0];
    dds_output_buffer3[12][15:0] <= dds_output_wire[12][15:0];
    dds_output_buffer3[13][15:0] <= dds_output_wire[13][15:0];
    dds_output_buffer3[14][15:0] <= dds_output_wire[14][15:0];
    dds_output_buffer3[15][15:0] <= dds_output_wire[15][15:0];
    m_axis_data_tvalid_buffer3 <= m_axis_data_tvalid_wire;
    m_axis_data_tvalid <= m_axis_data_tvalid_buffer3;
end

MAC mac_0(
    .clk(clk),
    .resetn(1'b1),
    .A({timestamp[43:4],4'b0000} + 0),
    .B(freq),
    .C(phase),
    .D({time_offset[43:4],4'b0000}),
    .mul_result(phase_input_wire[0])
);

MAC mac_1(
    .clk(clk),
    .resetn(1'b1),
    .A({timestamp[43:4],4'b0000} + 1),
    .B(freq),
    .C(phase),
    .D({time_offset[43:4],4'b0000}),
    .mul_result(phase_input_wire[1])
);

MAC mac_2(
    .clk(clk),
    .resetn(1'b1),
    .A({timestamp[43:4],4'b0000} + 2),
    .B(freq),
    .C(phase),
    .D({time_offset[43:4],4'b0000}),
    .mul_result(phase_input_wire[2])
);

MAC mac_3(
    .clk(clk),
    .resetn(1'b1),
    .A({timestamp[43:4],4'b0000} + 3),
    .B(freq),
    .C(phase),
    .D({time_offset[43:4],4'b0000}),
    .mul_result(phase_input_wire[3])
);

MAC mac_4(
    .clk(clk),
    .resetn(1'b1),
    .A({timestamp[43:4],4'b0000} + 4),
    .B(freq),
    .C(phase),
    .D({time_offset[43:4],4'b0000}),
    .mul_result(phase_input_wire[4])
);

MAC mac_5(
    .clk(clk),
    .resetn(1'b1),
    .A({timestamp[43:4],4'b0000} + 5),
    .B(freq),
    .C(phase),
    .D({time_offset[43:4],4'b0000}),
    .mul_result(phase_input_wire[5])
);

MAC mac_6(
    .clk(clk),
    .resetn(1'b1),
    .A({timestamp[43:4],4'b0000} + 6),
    .B(freq),
    .C(phase),
    .D({time_offset[43:4],4'b0000}),
    .mul_result(phase_input_wire[6])
);

MAC mac_7(
    .clk(clk),
    .resetn(1'b1),
    .A({timestamp[43:4],4'b0000} + 7),
    .B(freq),
    .C(phase),
    .D({time_offset[43:4],4'b0000}),
    .mul_result(phase_input_wire[7])
);

MAC mac_8(
    .clk(clk),
    .resetn(1'b1),
    .A({timestamp[43:4],4'b0000} + 8),
    .B(freq),
    .C(phase),
    .D({time_offset[43:4],4'b0000}),
    .mul_result(phase_input_wire[8])
);

MAC mac_9(
    .clk(clk),
    .resetn(1'b1),
    .A({timestamp[43:4],4'b0000} + 9),
    .B(freq),
    .C(phase),
    .D({time_offset[43:4],4'b0000}),
    .mul_result(phase_input_wire[9])
);

MAC mac_10(
    .clk(clk),
    .resetn(1'b1),
    .A({timestamp[43:4],4'b0000} + 10),
    .B(freq),
    .C(phase),
    .D({time_offset[43:4],4'b0000}),
    .mul_result(phase_input_wire[10])
);

MAC mac_11(
    .clk(clk),
    .resetn(1'b1),
    .A({timestamp[43:4],4'b0000} + 11),
    .B(freq),
    .C(phase),
    .D({time_offset[43:4],4'b0000}),
    .mul_result(phase_input_wire[11])
);

MAC mac_12(
    .clk(clk),
    .resetn(1'b1),
    .A({timestamp[43:4],4'b0000} + 12),
    .B(freq),
    .C(phase),
    .D({time_offset[43:4],4'b0000}),
    .mul_result(phase_input_wire[12])
);

MAC mac_13(
    .clk(clk),
    .resetn(1'b1),
    .A({timestamp[43:4],4'b0000} + 13),
    .B(freq),
    .C(phase),
    .D({time_offset[43:4],4'b0000}),
    .mul_result(phase_input_wire[13])
);

MAC mac_14(
    .clk(clk),
    .resetn(1'b1),
    .A({timestamp[43:4],4'b0000} + 14),
    .B(freq),
    .C(phase),
    .D({time_offset[43:4],4'b0000}),
    .mul_result(phase_input_wire[14])
);

MAC mac_15(
    .clk(clk),
    .resetn(1'b1),
    .A({timestamp[43:4],4'b0000} + 15),
    .B(freq),
    .C(phase),
    .D({time_offset[43:4],4'b0000}),
    .mul_result(phase_input_wire[15])
);


dds_compiler_0 dds_0(
    .s_axis_phase_tdata(phase_input[0]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[0]),
    .m_axis_data_tvalid(dds_output_valid[0]),
    .aclk(clk)
);


dds_compiler_1 dds_1(
    .s_axis_phase_tdata(phase_input[1]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[1]),
    .m_axis_data_tvalid(dds_output_valid[1]),
    .aclk(clk)
);


dds_compiler_2 dds_2(
    .s_axis_phase_tdata(phase_input[2]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[2]),
    .m_axis_data_tvalid(dds_output_valid[2]),
    .aclk(clk)
);


dds_compiler_3 dds_3(
    .s_axis_phase_tdata(phase_input[3]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[3]),
    .m_axis_data_tvalid(dds_output_valid[3]),
    .aclk(clk)
);


dds_compiler_4 dds_4(
    .s_axis_phase_tdata(phase_input[4]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[4]),
    .m_axis_data_tvalid(dds_output_valid[4]),
    .aclk(clk)
);


dds_compiler_5 dds_5(
    .s_axis_phase_tdata(phase_input[5]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[5]),
    .m_axis_data_tvalid(dds_output_valid[5]),
    .aclk(clk)
);


dds_compiler_6 dds_6(
    .s_axis_phase_tdata(phase_input[6]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[6]),
    .m_axis_data_tvalid(dds_output_valid[6]),
    .aclk(clk)
);


dds_compiler_7 dds_7(
    .s_axis_phase_tdata(phase_input[7]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[7]),
    .m_axis_data_tvalid(dds_output_valid[7]),
    .aclk(clk)
);


dds_compiler_8 dds_8(
    .s_axis_phase_tdata(phase_input[8]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[8]),
    .m_axis_data_tvalid(dds_output_valid[8]),
    .aclk(clk)
);


dds_compiler_9 dds_9(
    .s_axis_phase_tdata(phase_input[9]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[9]),
    .m_axis_data_tvalid(dds_output_valid[9]),
    .aclk(clk)
);


dds_compiler_10 dds_10(
    .s_axis_phase_tdata(phase_input[10]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[10]),
    .m_axis_data_tvalid(dds_output_valid[10]),
    .aclk(clk)
);


dds_compiler_11 dds_11(
    .s_axis_phase_tdata(phase_input[11]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[11]),
    .m_axis_data_tvalid(dds_output_valid[11]),
    .aclk(clk)
);


dds_compiler_12 dds_12(
    .s_axis_phase_tdata(phase_input[12]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[12]),
    .m_axis_data_tvalid(dds_output_valid[12]),
    .aclk(clk)
);


dds_compiler_13 dds_13(
    .s_axis_phase_tdata(phase_input[13]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[13]),
    .m_axis_data_tvalid(dds_output_valid[13]),
    .aclk(clk)
);


dds_compiler_14 dds_14(
    .s_axis_phase_tdata(phase_input[14]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[14]),
    .m_axis_data_tvalid(dds_output_valid[14]),
    .aclk(clk)
);


dds_compiler_15 dds_15(
    .s_axis_phase_tdata(phase_input[15]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[15]),
    .m_axis_data_tvalid(dds_output_valid[15]),
    .aclk(clk)
);
endmodule
