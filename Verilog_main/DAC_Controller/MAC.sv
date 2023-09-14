`timescale 1ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SNU QuIQCL
// Engineer: Jeonghyun Park
// 
// Create Date: 2023/08/24 16:55:51
// Design Name: 
// Module Name: MAC
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


module MAC(
    input wire clk,
    input wire resetn,
    input wire [47:0] A,        //timeoffset
    input wire [47:0] B,        //freq
    input wire [13:0] C,        //phase
    input wire [47:0] D,        //timestamp
    output reg [15:0] mul_result
);

wire [31:0] mul_stage1_31_0_0_wire;
wire [31:0] mul_stage1_47_16_0_wire;
wire [31:0] mul_stage1_47_16_1_wire;
wire [31:0] mul_stage1_63_32_0_wire;
wire [31:0] mul_stage1_63_32_1_wire;
wire [31:0] mul_stage1_63_32_2_wire;
wire [15:0] stage1_C_buffer_wire;

reg [31:0] mul_stage1_31_0_0;
reg [31:0] mul_stage1_47_16_0;
reg [31:0] mul_stage1_47_16_1;
reg [31:0] mul_stage1_63_32_0;
reg [31:0] mul_stage1_63_32_1;
reg [31:0] mul_stage1_63_32_2;
reg [15:0] stage1_C_buffer;

wire sum_stage2_carryout_wire;

reg sum_stage2_carryout;

wire [16:0] sum_stage2_47_32_0_wire;
wire [16:0] sum_stage2_47_32_1_wire;
wire [16:0] sum_stage2_47_32_2_wire;

reg [16:0] sum_stage2_47_32_0;
reg [16:0] sum_stage2_47_32_1;
reg [16:0] sum_stage2_47_32_2;

wire [16:0] full_mul_result;

//////////////////////////////////////////////////////////
// Pipeline 1
//////////////////////////////////////////////////////////

xbip_dsp48_mul_macro_0 dsp_stage_1_0(
    .CLK(clk),
    .A(A[15:0]),
    .B(B[15:0]),
    .D(D[15:0]),
    .P(mul_stage1_31_0_0_wire)
);

xbip_dsp48_mul_macro_1 dsp_stage_1_1(
    .CLK(clk),
    .A(A[31:16]),
    .B(B[15:0]),
    .D(D[31:16]),
    .P(mul_stage1_47_16_0_wire)
);

xbip_dsp48_mul_macro_2 dsp_stage_1_2(
    .CLK(clk),
    .A(A[15:0]),
    .B(B[31:16]),
    .D(D[15:0]),
    .P(mul_stage1_47_16_1_wire)
);

xbip_dsp48_mul_macro_3 dsp_stage_1_3(
    .CLK(clk),
    .A(A[31:16]),
    .B(B[31:16]),
    .D(D[31:16]),
    .P(mul_stage1_63_32_0_wire)
);

xbip_dsp48_mul_macro_4 dsp_stage_1_4(
    .CLK(clk),
    .A(A[47:32]),
    .B(B[15:0]),
    .D(D[47:32]),
    .P(mul_stage1_63_32_1_wire)
);

xbip_dsp48_mul_macro_5 dsp_stage_1_5(
    .CLK(clk),
    .A(A[15:0]),
    .B(B[47:32]),
    .D(D[15:0]),
    .P(mul_stage1_63_32_2_wire)
);

//////////////////////////////////////////////////////////
// Pipeline 2
//////////////////////////////////////////////////////////

xbip_dsp48_sum_macro_0 dsp_stage_2_0(
    .CLK(clk),
    .A(mul_stage1_31_0_0[31:16]),
    .B(mul_stage1_47_16_0[15:0]),
    .D(mul_stage1_47_16_1[15:0]),
    .CARRYIN(1'b0),
    .P(),
    .CARRYOUT(sum_stage2_carryout_wire)
);

xbip_dsp48_sum_macro_1 dsp_stage_2_1(
    .CLK(clk),
    .A(mul_stage1_63_32_0[15:0]),
    .B(mul_stage1_63_32_1[15:0]),
    .D(mul_stage1_63_32_2[15:0]),
    .CARRYIN(1'b0),
    .P(sum_stage2_47_32_0_wire),
    .CARRYOUT()
);

xbip_dsp48_sum_macro_2 dsp_stage_2_2(
    .CLK(clk),
    .A(mul_stage1_47_16_0[15:0]),
    .B(mul_stage1_47_16_1[15:0]),
    .D(stage1_C_buffer[15:0]),
    .CARRYIN(1'b0),
    .P(sum_stage2_47_32_1_wire),
    .CARRYOUT()
);

//////////////////////////////////////////////////////////
// Pipeline 3
//////////////////////////////////////////////////////////

xbip_dsp48_sum_macro_3 dsp_stage_3_0(
    .CLK(clk),
    .A(sum_stage2_47_32_0[15:0]),
    .B(sum_stage2_47_32_1[15:0]),
    .D(16'h0),
    .CARRYIN(sum_stage2_carryout),
    .P(full_mul_result),
    .CARRYOUT()
);


always@(posedge clk) begin
    if( resetn == 1'b0 ) begin
        mul_stage1_31_0_0           <= 32'h0;
        mul_stage1_47_16_0          <= 32'h0;
        mul_stage1_47_16_1          <= 32'h0;
        mul_stage1_63_32_0          <= 32'h0;
        mul_stage1_63_32_1          <= 32'h0;
        mul_stage1_63_32_2          <= 32'h0;
        sum_stage2_47_32_0          <= 16'h0;
        sum_stage2_47_32_1          <= 16'h0;
        sum_stage2_47_32_2          <= 16'h0;
        stage1_C_buffer             <= 16'h0;
        sum_stage2_carryout         <= 1'b0;
    end
    else begin
        //////////////////////////////////////////////////////////
        // Pipeline 1
        //////////////////////////////////////////////////////////
        mul_stage1_31_0_0[31:0]     <= mul_stage1_31_0_0_wire;
        mul_stage1_47_16_0[31:0]    <= mul_stage1_47_16_0_wire;
        mul_stage1_47_16_1[31:0]    <= mul_stage1_47_16_1_wire;
        mul_stage1_63_32_0[31:0]    <= mul_stage1_63_32_0_wire;
        mul_stage1_63_32_1[31:0]    <= mul_stage1_63_32_1_wire;
        mul_stage1_63_32_2[31:0]    <= mul_stage1_63_32_2_wire;
        stage1_C_buffer             <= {C[13:0],2'b00};

        //////////////////////////////////////////////////////////
        // Pipeline 2
        //////////////////////////////////////////////////////////
        sum_stage2_carryout         <= sum_stage2_carryout_wire;

        sum_stage2_47_32_0          <= sum_stage2_47_32_0_wire;
        sum_stage2_47_32_1          <= sum_stage2_47_32_1_wire;

        //////////////////////////////////////////////////////////
        // Pipeline 3
        //////////////////////////////////////////////////////////
        mul_result[15:0]            <= {2'b0,full_mul_result[15:2]};
    end
end
endmodule
