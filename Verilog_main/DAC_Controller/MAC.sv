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


(* use_dsp = "yes" *) module MAC(
    input wire clk,
    input wire resetn,
    input wire [47:0] A,        //timestamp
    input wire [47:0] B,        //freq
    input wire [13:0] C,        //phase
    input wire [47:0] D,        //timeoffset
    output reg [15:0] mul_result
);

reg [31:0] mul_stage1_31_0_0;
reg [31:0] mul_stage1_47_16_0;
reg [31:0] mul_stage1_47_16_1;
reg [31:0] mul_stage1_63_32_0;
reg [31:0] mul_stage1_63_32_1;
reg [31:0] mul_stage1_63_32_2;
reg [15:0] stage1_C_buffer;

wire [16:0] mul_stage1_carry_out;

reg [15:0] mul_stage2_47_32_0;
reg [15:0] mul_stage2_47_32_1;
reg [15:0] mul_stage2_47_32_2;

wire [15:0] full_mul_result;

assign mul_stage1_carry_out = {1'b0,mul_stage1_31_0_0[31:16]} + {1'b0,mul_stage1_47_16_0[15:0]} + {1'b0,mul_stage1_47_16_1[15:0]};
assign full_mul_result = mul_stage2_47_32_0[15:0] + mul_stage2_47_32_1[15:0] + mul_stage2_47_32_2[15:0];

always@(posedge clk) begin
    if( resetn == 1'b0 ) begin
        mul_stage1_31_0_0 <= 32'h0;
        mul_stage1_47_16_0 <= 32'h0;
        mul_stage1_47_16_1 <= 32'h0;
        mul_stage1_63_32_0 <= 32'h0;
        mul_stage1_63_32_1 <= 32'h0;
        mul_stage1_63_32_2 <= 32'h0;
        mul_stage2_47_32_0 <= 16'h0;
        mul_stage2_47_32_1 <= 16'h0;
        mul_stage2_47_32_2 <= 16'h0;
        stage1_C_buffer <= 16'h0;
    end
    else begin
        mul_stage1_31_0_0[31:0] <= (A[15:0] - D[15:0]) * B[15:0];
        mul_stage1_47_16_0[31:0] <= (A[31:16] - D[31:16]) * B[15:0];
        mul_stage1_47_16_1[31:0] <= (A[15:0] - D[15:0]) * B[31:16];
        mul_stage1_63_32_0[31:0] <= (A[31:16] - D[31:16]) * B[31:16];
        mul_stage1_63_32_1[31:0] <= (A[47:32] - D[47:32]) * B[15:0];
        mul_stage1_63_32_2[31:0] <= (A[15:0] - D[15:0]) * B[47:32];
        stage1_C_buffer <= {C[13:0],2'b00};

        mul_stage2_47_32_0 <= {{15{1'b0}},mul_stage1_carry_out[16]} + stage1_C_buffer;
        mul_stage2_47_32_1 <= mul_stage1_63_32_1[15:0] + mul_stage1_63_32_2[15:0];
        mul_stage2_47_32_2 <= mul_stage1_47_16_0[31:16] + mul_stage1_47_16_1[31:16];

        mul_result[15:0] <= {2'b0,full_mul_result[15:2]};
    end
end
endmodule
