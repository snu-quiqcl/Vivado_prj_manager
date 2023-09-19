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

reg [47:0] A_buffer;
reg [47:0] B_buffer;
reg [13:0] C_buffer;

wire [47:0] sub_stage0_47_0_wire;

wire [33:0] mul_stage1_31_0_0_wire;
wire [33:0] mul_stage1_47_16_0_wire;
wire [33:0] mul_stage1_47_16_1_wire;
wire [33:0] mul_stage1_63_32_0_wire;
wire [33:0] mul_stage1_63_32_1_wire;
wire [33:0] mul_stage1_63_32_2_wire;
wire [16:0] stage1_C_buffer_wire;

reg [33:0] mul_stage1_31_0_0;
reg [33:0] mul_stage1_47_16_0;
reg [33:0] mul_stage1_47_16_1;
reg [33:0] mul_stage1_63_32_0;
reg [33:0] mul_stage1_63_32_1;
reg [33:0] mul_stage1_63_32_2;
reg [16:0] stage1_C_buffer;

wire sum_stage2_carryout_wire;

reg sum_stage2_carryout;

wire [17:0] sum_stage2_47_32_0_wire;
wire [17:0] sum_stage2_47_32_1_wire;
wire [17:0] sum_stage2_47_32_2_wire;

reg [17:0] sum_stage2_47_32_0;
reg [17:0] sum_stage2_47_32_1;
reg [17:0] sum_stage2_47_32_2;

wire [17:0] full_mul_result;

//////////////////////////////////////////////////////////
// Pipeline 0
//////////////////////////////////////////////////////////

xbip_dsp48_sub_macro_0 dsp_stage_0_0(
    .CONCAT(D),
    .C(A),
    .P(mul_stage1_31_0_0_wire)
);


//////////////////////////////////////////////////////////
// Pipeline 1
//////////////////////////////////////////////////////////

xbip_dsp48_mul_macro_0 dsp_stage_1_0(
    .A({1'b0,D_buffer[15:0]}),
    .B({1'b0,B_buffer[15:0]}),
    .P(mul_stage1_31_0_0_wire)
);

xbip_dsp48_mul_macro_0 dsp_stage_1_1(
    .A({1'b0,D_buffer[31:16]}),
    .B({1'b0,B_buffer[15:0]}),
    .P(mul_stage1_47_16_0_wire)
);

xbip_dsp48_mul_macro_0 dsp_stage_1_2(
    .A({1'b0,D_buffer[15:0]}),
    .B({1'b0,B_buffer[31:16]}),
    .P(mul_stage1_47_16_1_wire)
);

xbip_dsp48_mul_macro_0 dsp_stage_1_3(
    .A({1'b0,D_buffer[31:16]}),
    .B({1'b0,B_buffer[31:16]}),
    .P(mul_stage1_63_32_0_wire)
);

xbip_dsp48_mul_macro_0 dsp_stage_1_4(
    .A({1'b0,D_buffer[47:32]}),
    .B({1'b0,B_buffer[15:0]}),
    .P(mul_stage1_63_32_1_wire)
);

xbip_dsp48_mul_macro_0 dsp_stage_1_5(
    .A({1'b0,D_buffer[15:0]}),
    .B({1'b0,B_buffer[47:32]}),
    .P(mul_stage1_63_32_2_wire)
);

//////////////////////////////////////////////////////////
// Pipeline 2
//////////////////////////////////////////////////////////

xbip_dsp48_sum_macro_0 dsp_stage_2_0(
    .A({1'b0,mul_stage1_31_0_0[31:16]}),
    .C({1'b0,mul_stage1_47_16_0[15:0]}),
    .D({1'b0,mul_stage1_47_16_1[15:0]}),
    .P(sum_stage2_47_32_2_wire)
);

xbip_dsp48_sum_macro_0 dsp_stage_2_1(
    .A({1'b0,mul_stage1_63_32_0[15:0]}),
    .C({1'b0,mul_stage1_63_32_1[15:0]}),
    .D({1'b0,mul_stage1_63_32_2[15:0]}),
    .P(sum_stage2_47_32_0_wire)
);

xbip_dsp48_sum_macro_0 dsp_stage_2_2(
    .A({1'b0,mul_stage1_47_16_0[31:16]}),
    .C({1'b0,mul_stage1_47_16_1[31:16]}),
    .D({1'b0,stage1_C_buffer[15:0]}),
    .P(sum_stage2_47_32_1_wire)
);

//////////////////////////////////////////////////////////
// Pipeline 3
//////////////////////////////////////////////////////////

xbip_dsp48_sum_macro_0 dsp_stage_3_0(
    .A({1'b0,sum_stage2_47_32_0[15:0]}),
    .C({1'b0,sum_stage2_47_32_1[15:0]}),
    .D({16'b000000000000000,sum_stage2_carryout}),
    .P(full_mul_result)
);


always@(posedge clk) begin
    if( resetn == 1'b0 ) begin
        mul_stage1_31_0_0           <= 34'h0;
        mul_stage1_47_16_0          <= 34'h0;
        mul_stage1_47_16_1          <= 34'h0;
        mul_stage1_63_32_0          <= 34'h0;
        mul_stage1_63_32_1          <= 34'h0;
        mul_stage1_63_32_2          <= 34'h0;
        sum_stage2_47_32_0          <= 18'h0;
        sum_stage2_47_32_1          <= 18'h0;
        sum_stage2_47_32_2          <= 18'h0;
        stage1_C_buffer             <= 17'h0;
        sum_stage2_carryout         <= 1'b0;
        A_buffer                    <= 48'h0;
        B_buffer                    <= 48'h0;
        C_buffer                    <= 14'h0;
    end
    else begin
        //////////////////////////////////////////////////////////
        // Pipeline 1
        //////////////////////////////////////////////////////////
        A_buffer                    <= sub_stage0_47_0_wire;
        B_buffer                    <= B;
        C_buffer                    <= C;

        //////////////////////////////////////////////////////////
        // Pipeline 1
        //////////////////////////////////////////////////////////
        mul_stage1_31_0_0[33:0]     <= mul_stage1_31_0_0_wire;
        mul_stage1_47_16_0[33:0]    <= mul_stage1_47_16_0_wire;
        mul_stage1_47_16_1[33:0]    <= mul_stage1_47_16_1_wire;
        mul_stage1_63_32_0[33:0]    <= mul_stage1_63_32_0_wire;
        mul_stage1_63_32_1[33:0]    <= mul_stage1_63_32_1_wire;
        mul_stage1_63_32_2[33:0]    <= mul_stage1_63_32_2_wire;
        stage1_C_buffer             <= {1'b0,C_buffer[13:0],2'b00};

        //////////////////////////////////////////////////////////
        // Pipeline 2
        //////////////////////////////////////////////////////////
        sum_stage2_carryout         <= sum_stage2_47_32_2_wire[16];
        sum_stage2_47_32_0          <= sum_stage2_47_32_0_wire;
        sum_stage2_47_32_1          <= sum_stage2_47_32_1_wire;

        //////////////////////////////////////////////////////////
        // Pipeline 3
        //////////////////////////////////////////////////////////
        mul_result[15:0]            <= {2'b0,full_mul_result[15:2]};
    end
end
endmodule
