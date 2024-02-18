`timescale 1ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SNU QuIQCL
// Engineer: Jeonghyun Park
// 
// Create Date: 2023/08/24 16:55:51
// Design Name: 
// Module Name: RFDC_DDS
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


(* use_dsp = "yes" *) module RFDC_DDS(
    input wire clk,
    input wire [47:0] freq,
    input wire [13:0] amp,              // unsigned value
    input wire [13:0] phase,
    input wire [63:0] timestamp,
    input wire [13:0] amp_offset,
    input wire [63:0] time_offset,
    input wire sync_en,
    input wire reset,
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

// timestamp buffer is added since dds_controller consumes 3clock cycles
reg [63:0]timestamp_buffer1;
reg [63:0]timestamp_buffer2;
reg [63:0]timestamp_buffer3;
wire [47:0] timestamp_input;

reg sync_en_buffer1;
reg sync_en_buffer2;
reg sync_en_buffer3;

wire [15:0] dds_output_wire[16];
wire [15:0] dds_output_valid; 
wire [3:0] dds_output_valid_chain;
wire [120:0] phase_full_product[16];
wire [33:0] amp_full_product[16];
wire [15:0] phase_sync_input_wire[16];
wire [47:0] phase_accu_input_wire[16];
wire [255:0] m_axis_data_tdata_wire;

wire [47:0] phase_sync_full_wire;
wire [47:0] phase_accu_full_wire;

wire m_axis_data_tvalid_wire;
reg m_axis_data_tvalid_buffer3;

// phase input to DDS
reg [15:0] phase_input[16];

reg [47:0] phase_accumulation;
wire [47:0] phase_accumulation_input;

// amp buffer is added to match clock cycle consumed from pipelines in mac
reg [13:0] amp_buffer1;
reg [13:0] amp_buffer2;
reg [13:0] amp_buffer3;
reg [13:0] amp_buffer4;
reg [13:0] amp_buffer5;

// same with amp buffer
reg [13:0] amp_offset_buffer1;
reg [13:0] amp_offset_buffer2;
reg [13:0] amp_offset_buffer3;
reg [13:0] amp_offset_buffer4;
reg [13:0] amp_offset_buffer5;

assign dds_output_valid_chain[0] = dds_output_valid[0] & dds_output_valid[1] & dds_output_valid[2] & dds_output_valid[3];
assign dds_output_valid_chain[1] = dds_output_valid[4] & dds_output_valid[5] & dds_output_valid[6] & dds_output_valid[7];
assign dds_output_valid_chain[2] = dds_output_valid[8] & dds_output_valid[9] & dds_output_valid[10] & dds_output_valid[11];
assign dds_output_valid_chain[3] = dds_output_valid[12] & dds_output_valid[13] & dds_output_valid[14] & dds_output_valid[15];
assign m_axis_data_tvalid_wire = dds_output_valid_chain[0] & dds_output_valid_chain[1] & dds_output_valid_chain[2] & dds_output_valid_chain[3];
assign timestamp_input = (sync_en | sync_en_buffer1 | sync_en_buffer2 | sync_en_buffer3)? {timestamp_buffer3[43:0],4'b0000} :48'h0;
assign phase_accumulation_input = (sync_en | sync_en_buffer1 | sync_en_buffer2 | sync_en_buffer3)? 48'h0 : phase_accumulation;

// Generate loop to assign dds_output_wire slices to m_axis_data_tdata
genvar i;
generate
    for (i = 0; i < 16; i = i + 1) begin : ASSIGN_GEN
        assign m_axis_data_tdata_wire[16*i +: 16] = amp_full_product[i][28:13] + {1'b0,amp_offset_buffer5[13:0],1'b0};
    end
endgenerate

xbip_dsp48_mul_macro_0 dsp_amp_mul_0(
    .B({3'b000, amp_buffer5}),
    .A({{dds_output_wire[0][15]},dds_output_wire[0]}),
    .P(amp_full_product[0])
);


xbip_dsp48_mul_macro_0 dsp_amp_mul_1(
    .B({3'b000, amp_buffer5}),
    .A({{dds_output_wire[1][15]},dds_output_wire[1]}),
    .P(amp_full_product[1])
);


xbip_dsp48_mul_macro_0 dsp_amp_mul_2(
    .B({3'b000, amp_buffer5}),
    .A({{dds_output_wire[2][15]},dds_output_wire[2]}),
    .P(amp_full_product[2])
);


xbip_dsp48_mul_macro_0 dsp_amp_mul_3(
    .B({3'b000, amp_buffer5}),
    .A({{dds_output_wire[3][15]},dds_output_wire[3]}),
    .P(amp_full_product[3])
);


xbip_dsp48_mul_macro_0 dsp_amp_mul_4(
    .B({3'b000, amp_buffer5}),
    .A({{dds_output_wire[4][15]},dds_output_wire[4]}),
    .P(amp_full_product[4])
);


xbip_dsp48_mul_macro_0 dsp_amp_mul_5(
    .B({3'b000, amp_buffer5}),
    .A({{dds_output_wire[5][15]},dds_output_wire[5]}),
    .P(amp_full_product[5])
);


xbip_dsp48_mul_macro_0 dsp_amp_mul_6(
    .B({3'b000, amp_buffer5}),
    .A({{dds_output_wire[6][15]},dds_output_wire[6]}),
    .P(amp_full_product[6])
);


xbip_dsp48_mul_macro_0 dsp_amp_mul_7(
    .B({3'b000, amp_buffer5}),
    .A({{dds_output_wire[7][15]},dds_output_wire[7]}),
    .P(amp_full_product[7])
);


xbip_dsp48_mul_macro_0 dsp_amp_mul_8(
    .B({3'b000, amp_buffer5}),
    .A({{dds_output_wire[8][15]},dds_output_wire[8]}),
    .P(amp_full_product[8])
);


xbip_dsp48_mul_macro_0 dsp_amp_mul_9(
    .B({3'b000, amp_buffer5}),
    .A({{dds_output_wire[9][15]},dds_output_wire[9]}),
    .P(amp_full_product[9])
);


xbip_dsp48_mul_macro_0 dsp_amp_mul_10(
    .B({3'b000, amp_buffer5}),
    .A({{dds_output_wire[10][15]},dds_output_wire[10]}),
    .P(amp_full_product[10])
);


xbip_dsp48_mul_macro_0 dsp_amp_mul_11(
    .B({3'b000, amp_buffer5}),
    .A({{dds_output_wire[11][15]},dds_output_wire[11]}),
    .P(amp_full_product[11])
);


xbip_dsp48_mul_macro_0 dsp_amp_mul_12(
    .B({3'b000, amp_buffer5}),
    .A({{dds_output_wire[12][15]},dds_output_wire[12]}),
    .P(amp_full_product[12])
);


xbip_dsp48_mul_macro_0 dsp_amp_mul_13(
    .B({3'b000, amp_buffer5}),
    .A({{dds_output_wire[13][15]},dds_output_wire[13]}),
    .P(amp_full_product[13])
);


xbip_dsp48_mul_macro_0 dsp_amp_mul_14(
    .B({3'b000, amp_buffer5}),
    .A({{dds_output_wire[14][15]},dds_output_wire[14]}),
    .P(amp_full_product[14])
);


xbip_dsp48_mul_macro_0 dsp_amp_mul_15(
    .B({3'b000, amp_buffer5}),
    .A({{dds_output_wire[15][15]},dds_output_wire[15]}),
    .P(amp_full_product[15])
);

always@(posedge clk) begin
    if( reset == 1'b1 ) begin
        timestamp_buffer1[63:0]         <= 64'h0;
        timestamp_buffer2[63:0]         <= 64'h0;
        timestamp_buffer3[63:0]         <= 64'h0;
        m_axis_data_tdata[255:0]        <= 256'h0;
        phase_input[0]                  <= 16'h0;
        phase_input[1]                  <= 16'h0;
        phase_input[2]                  <= 16'h0;
        phase_input[3]                  <= 16'h0;
        phase_input[4]                  <= 16'h0;
        phase_input[5]                  <= 16'h0;
        phase_input[6]                  <= 16'h0;
        phase_input[7]                  <= 16'h0;
        phase_input[8]                  <= 16'h0;
        phase_input[9]                  <= 16'h0;
        phase_input[10]                 <= 16'h0;
        phase_input[11]                 <= 16'h0;
        phase_input[12]                 <= 16'h0;
        phase_input[13]                 <= 16'h0;
        phase_input[14]                 <= 16'h0;
        phase_input[15]                 <= 16'h0;

        amp_buffer1[13:0]               <= 14'h0;
        amp_buffer2[13:0]               <= 14'h0;
        amp_buffer3[13:0]               <= 14'h0;
        amp_buffer4[13:0]               <= 14'h0;
        amp_buffer5[13:0]               <= 14'h0;

        amp_offset_buffer1[13:0]        <= 14'h0;
        amp_offset_buffer2[13:0]        <= 14'h0;
        amp_offset_buffer3[13:0]        <= 14'h0;
        amp_offset_buffer4[13:0]        <= 14'h0;
        amp_offset_buffer5[13:0]        <= 15'h0;

        sync_en_buffer1                 <= 1'b0;
        sync_en_buffer2                 <= 1'b0;
        sync_en_buffer3                 <= 1'b0;

        m_axis_data_tvalid_buffer3      <= 1'b0;
        m_axis_data_tvalid              <= 1'b0;
        phase_accumulation              <= 48'h0;
    end
    else begin
        timestamp_buffer1[63:0]         <= timestamp[63:0];
        timestamp_buffer2[63:0]         <= timestamp_buffer1[63:0];
        timestamp_buffer3[63:0]         <= timestamp_buffer2[63:0];
        m_axis_data_tdata[255:0]        <= m_axis_data_tdata_wire[255:0];
        
        sync_en_buffer1                 <= sync_en;
        sync_en_buffer2                 <= sync_en_buffer1;
        sync_en_buffer3                 <= sync_en_buffer2;

        if( sync_en_buffer3 == 1'b1 ) begin
            phase_accumulation              <= phase_sync_full_wire;
        end
        else begin
            phase_accumulation              <= phase_accu_full_wire;
        end
        phase_input[0]                  <= {1'b0,phase_accu_input_wire[0][47:33]};
        phase_input[1]                  <= {1'b0,phase_accu_input_wire[1][47:33]};
        phase_input[2]                  <= {1'b0,phase_accu_input_wire[2][47:33]};
        phase_input[3]                  <= {1'b0,phase_accu_input_wire[3][47:33]};
        phase_input[4]                  <= {1'b0,phase_accu_input_wire[4][47:33]};
        phase_input[5]                  <= {1'b0,phase_accu_input_wire[5][47:33]};
        phase_input[6]                  <= {1'b0,phase_accu_input_wire[6][47:33]};
        phase_input[7]                  <= {1'b0,phase_accu_input_wire[7][47:33]};
        phase_input[8]                  <= {1'b0,phase_accu_input_wire[8][47:33]};
        phase_input[9]                  <= {1'b0,phase_accu_input_wire[9][47:33]};
        phase_input[10]                 <= {1'b0,phase_accu_input_wire[10][47:33]};
        phase_input[11]                 <= {1'b0,phase_accu_input_wire[11][47:33]};
        phase_input[12]                 <= {1'b0,phase_accu_input_wire[12][47:33]};
        phase_input[13]                 <= {1'b0,phase_accu_input_wire[13][47:33]};
        phase_input[14]                 <= {1'b0,phase_accu_input_wire[14][47:33]};
        phase_input[15]                 <= {1'b0,phase_accu_input_wire[15][47:33]};

        amp_buffer1[13:0]               <= amp[13:0];
        amp_buffer2[13:0]               <= amp_buffer1[13:0];
        amp_buffer3[13:0]               <= amp_buffer2[13:0];
        amp_buffer4[13:0]               <= amp_buffer3[13:0];
        amp_buffer5[13:0]               <= amp_buffer4[13:0];

        amp_offset_buffer1[13:0]        <= amp_offset[13:0];
        amp_offset_buffer2[13:0]        <= amp_offset_buffer1[13:0];
        amp_offset_buffer3[13:0]        <= amp_offset_buffer2[13:0];
        amp_offset_buffer4[13:0]        <= amp_offset_buffer3[13:0];
        amp_offset_buffer5[13:0]        <= amp_offset_buffer4[13:0];

        m_axis_data_tvalid_buffer3      <= m_axis_data_tvalid_wire;
        m_axis_data_tvalid              <= m_axis_data_tvalid_buffer3;
    end
end

xbip_dsp48_sum_macro_1 accu_phase_calculation(
    .CONCAT({freq[43:0],4'b0000}),
    .C(phase_accumulation),
    .P(phase_accu_full_wire)
);

MAC_accu mac_sync_16(
    .clk(clk),
    .resetn(1'b1),
    .D({timestamp_buffer3[43:0],4'b0000} + 16),
    .B(freq),
    .C(phase),
    .A({time_offset[43:0],4'b0000}),
    .E(48'h0),
    .mul_result(phase_sync_full_wire)
);

MAC_accu mac_accu_0(
    .clk(clk),
    .resetn(1'b1),
    .D(timestamp_input + 0),
    .B(freq),
    .C(phase),
    .A({time_offset[43:0],4'b0000}),
    .E(phase_accumulation_input),
    .mul_result(phase_accu_input_wire[0])
);

MAC_accu mac_accu_1(
    .clk(clk),
    .resetn(1'b1),
    .D(timestamp_input + 1),
    .B(freq),
    .C(phase),
    .A({time_offset[43:0],4'b0000}),
    .E(phase_accumulation_input),
    .mul_result(phase_accu_input_wire[1])
);

MAC_accu mac_accu_2(
    .clk(clk),
    .resetn(1'b1),
    .D(timestamp_input + 2),
    .B(freq),
    .C(phase),
    .A({time_offset[43:0],4'b0000}),
    .E(phase_accumulation_input),
    .mul_result(phase_accu_input_wire[2])
);

MAC_accu mac_accu_3(
    .clk(clk),
    .resetn(1'b1),
    .D(timestamp_input + 3),
    .B(freq),
    .C(phase),
    .A({time_offset[43:0],4'b0000}),
    .E(phase_accumulation_input),
    .mul_result(phase_accu_input_wire[3])
);

MAC_accu mac_accu_4(
    .clk(clk),
    .resetn(1'b1),
    .D(timestamp_input + 4),
    .B(freq),
    .C(phase),
    .A({time_offset[43:0],4'b0000}),
    .E(phase_accumulation_input),
    .mul_result(phase_accu_input_wire[4])
);

MAC_accu mac_accu_5(
    .clk(clk),
    .resetn(1'b1),
    .D(timestamp_input + 5),
    .B(freq),
    .C(phase),
    .A({time_offset[43:0],4'b0000}),
    .E(phase_accumulation_input),
    .mul_result(phase_accu_input_wire[5])
);

MAC_accu mac_accu_6(
    .clk(clk),
    .resetn(1'b1),
    .D(timestamp_input + 6),
    .B(freq),
    .C(phase),
    .A({time_offset[43:0],4'b0000}),
    .E(phase_accumulation_input),
    .mul_result(phase_accu_input_wire[6])
);

MAC_accu mac_accu_7(
    .clk(clk),
    .resetn(1'b1),
    .D(timestamp_input + 7),
    .B(freq),
    .C(phase),
    .A({time_offset[43:0],4'b0000}),
    .E(phase_accumulation_input),
    .mul_result(phase_accu_input_wire[7])
);

MAC_accu mac_accu_8(
    .clk(clk),
    .resetn(1'b1),
    .D(timestamp_input + 8),
    .B(freq),
    .C(phase),
    .A({time_offset[43:0],4'b0000}),
    .E(phase_accumulation_input),
    .mul_result(phase_accu_input_wire[8])
);

MAC_accu mac_accu_9(
    .clk(clk),
    .resetn(1'b1),
    .D(timestamp_input + 9),
    .B(freq),
    .C(phase),
    .A({time_offset[43:0],4'b0000}),
    .E(phase_accumulation_input),
    .mul_result(phase_accu_input_wire[9])
);

MAC_accu mac_accu_10(
    .clk(clk),
    .resetn(1'b1),
    .D(timestamp_input + 10),
    .B(freq),
    .C(phase),
    .A({time_offset[43:0],4'b0000}),
    .E(phase_accumulation_input),
    .mul_result(phase_accu_input_wire[10])
);

MAC_accu mac_accu_11(
    .clk(clk),
    .resetn(1'b1),
    .D(timestamp_input + 11),
    .B(freq),
    .C(phase),
    .A({time_offset[43:0],4'b0000}),
    .E(phase_accumulation_input),
    .mul_result(phase_accu_input_wire[11])
);

MAC_accu mac_accu_12(
    .clk(clk),
    .resetn(1'b1),
    .D(timestamp_input + 12),
    .B(freq),
    .C(phase),
    .A({time_offset[43:0],4'b0000}),
    .E(phase_accumulation_input),
    .mul_result(phase_accu_input_wire[12])
);

MAC_accu mac_accu_13(
    .clk(clk),
    .resetn(1'b1),
    .D(timestamp_input + 13),
    .B(freq),
    .C(phase),
    .A({time_offset[43:0],4'b0000}),
    .E(phase_accumulation_input),
    .mul_result(phase_accu_input_wire[13])
);

MAC_accu mac_accu_14(
    .clk(clk),
    .resetn(1'b1),
    .D(timestamp_input + 14),
    .B(freq),
    .C(phase),
    .A({time_offset[43:0],4'b0000}),
    .E(phase_accumulation_input),
    .mul_result(phase_accu_input_wire[14])
);

MAC_accu mac_accu_15(
    .clk(clk),
    .resetn(1'b1),
    .D(timestamp_input + 15),
    .B(freq),
    .C(phase),
    .A({time_offset[43:0],4'b0000}),
    .E(phase_accumulation_input),
    .mul_result(phase_accu_input_wire[15])
);

dds_compiler_0 dds_0(
    .s_axis_phase_tdata(phase_input[0]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[0]),
    .m_axis_data_tvalid(dds_output_valid[0]),
    .aclk(clk)
);


dds_compiler_0 dds_1(
    .s_axis_phase_tdata(phase_input[1]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[1]),
    .m_axis_data_tvalid(dds_output_valid[1]),
    .aclk(clk)
);


dds_compiler_0 dds_2(
    .s_axis_phase_tdata(phase_input[2]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[2]),
    .m_axis_data_tvalid(dds_output_valid[2]),
    .aclk(clk)
);


dds_compiler_0 dds_3(
    .s_axis_phase_tdata(phase_input[3]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[3]),
    .m_axis_data_tvalid(dds_output_valid[3]),
    .aclk(clk)
);


dds_compiler_0 dds_4(
    .s_axis_phase_tdata(phase_input[4]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[4]),
    .m_axis_data_tvalid(dds_output_valid[4]),
    .aclk(clk)
);


dds_compiler_0 dds_5(
    .s_axis_phase_tdata(phase_input[5]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[5]),
    .m_axis_data_tvalid(dds_output_valid[5]),
    .aclk(clk)
);


dds_compiler_0 dds_6(
    .s_axis_phase_tdata(phase_input[6]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[6]),
    .m_axis_data_tvalid(dds_output_valid[6]),
    .aclk(clk)
);


dds_compiler_0 dds_7(
    .s_axis_phase_tdata(phase_input[7]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[7]),
    .m_axis_data_tvalid(dds_output_valid[7]),
    .aclk(clk)
);


dds_compiler_0 dds_8(
    .s_axis_phase_tdata(phase_input[8]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[8]),
    .m_axis_data_tvalid(dds_output_valid[8]),
    .aclk(clk)
);


dds_compiler_0 dds_9(
    .s_axis_phase_tdata(phase_input[9]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[9]),
    .m_axis_data_tvalid(dds_output_valid[9]),
    .aclk(clk)
);


dds_compiler_0 dds_10(
    .s_axis_phase_tdata(phase_input[10]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[10]),
    .m_axis_data_tvalid(dds_output_valid[10]),
    .aclk(clk)
);


dds_compiler_0 dds_11(
    .s_axis_phase_tdata(phase_input[11]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[11]),
    .m_axis_data_tvalid(dds_output_valid[11]),
    .aclk(clk)
);


dds_compiler_0 dds_12(
    .s_axis_phase_tdata(phase_input[12]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[12]),
    .m_axis_data_tvalid(dds_output_valid[12]),
    .aclk(clk)
);


dds_compiler_0 dds_13(
    .s_axis_phase_tdata(phase_input[13]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[13]),
    .m_axis_data_tvalid(dds_output_valid[13]),
    .aclk(clk)
);


dds_compiler_0 dds_14(
    .s_axis_phase_tdata(phase_input[14]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[14]),
    .m_axis_data_tvalid(dds_output_valid[14]),
    .aclk(clk)
);


dds_compiler_0 dds_15(
    .s_axis_phase_tdata(phase_input[15]),
    .s_axis_phase_tvalid(1'b1),
    .m_axis_data_tdata(dds_output_wire[15]),
    .m_axis_data_tvalid(dds_output_valid[15]),
    .aclk(clk)
);
endmodule