`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/09 20:00:35
// Design Name: 
// Module Name: TTLx8_output
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


module TTLx8_output
#(
    parameter DEST_VAL = 16'h0,
    parameter CHANNEL_LENGTH = 12
)
(
    //////////////////////////////////////////////////////////////////////////////////  
    // IO declaration for GPO_Core
    //////////////////////////////////////////////////////////////////////////////////
    input wire clk,
    input wire reset,
    input wire override_en,
    input wire selected_en,
    input wire busy,
    input wire [63:0] gpo_in_0;
    input wire [63:0] override_value_0;
    input wire counter_matched_0;
    input wire [63:0] gpo_in_1;
    input wire [63:0] override_value_1;
    input wire counter_matched_1;
    input wire [63:0] gpo_in_2;
    input wire [63:0] override_value_2;
    input wire counter_matched_2;
    input wire [63:0] gpo_in_3;
    input wire [63:0] override_value_3;
    input wire counter_matched_3;
    input wire [63:0] gpo_in_4;
    input wire [63:0] override_value_4;
    input wire counter_matched_4;
    input wire [63:0] gpo_in_5;
    input wire [63:0] override_value_5;
    input wire counter_matched_5;
    input wire [63:0] gpo_in_6;
    input wire [63:0] override_value_6;
    input wire counter_matched_6;
    input wire [63:0] gpo_in_7;
    input wire [63:0] override_value_7;
    input wire counter_matched_7;

    output wire [127:0] error_data,
    output wire overrided,
    output wire busy_error,
    //////////////////////////////////////////////////////////////////////////////////  
    // IO declaration for GPO_Core
    //////////////////////////////////////////////////////////////////////////////////
 
    output wire [7:0] TTL_output_0;
    output wire [7:0] TTL_output_1;
    output wire [7:0] TTL_output_2;
    output wire [7:0] TTL_output_3;
    output wire [7:0] TTL_output_4;
    output wire [7:0] TTL_output_5;
    output wire [7:0] TTL_output_6;
    output wire [7:0] TTL_output_7;
    output wire [7:0] TTL_output_8;
    output wire [7:0] TTL_output_9;
    output wire [7:0] TTL_output_10;
    output wire [7:0] TTL_output_11;
    output wire [7:0] TTL_output_12;
    output wire [7:0] TTL_output_13;
    output wire [7:0] TTL_output_14;
    output wire [7:0] TTL_output_15;
    output wire [7:0] TTL_output_16;
    output wire [7:0] TTL_output_17;
    output wire [7:0] TTL_output_18;
    output wire [7:0] TTL_output_19;
    output wire [7:0] TTL_output_20;
    output wire [7:0] TTL_output_21;
    output wire [7:0] TTL_output_22;
    output wire [7:0] TTL_output_23;
    output wire [7:0] TTL_output_24;
    output wire [7:0] TTL_output_25;
    output wire [7:0] TTL_output_26;
    output wire [7:0] TTL_output_27;
    output wire [7:0] TTL_output_28;
    output wire [7:0] TTL_output_29;
    output wire [7:0] TTL_output_30;
    output wire [7:0] TTL_output_31;
    output wire [7:0] TTL_output_32;
    output wire [7:0] TTL_output_33;
    output wire [7:0] TTL_output_34;
    output wire [7:0] TTL_output_35;
    output wire [7:0] TTL_output_36;
    output wire [7:0] TTL_output_37;
    output wire [7:0] TTL_output_38;
    output wire [7:0] TTL_output_39;
    output wire [7:0] TTL_output_40;
    output wire [7:0] TTL_output_41;
    output wire [7:0] TTL_output_42;
    output wire [7:0] TTL_output_43;
    output wire [7:0] TTL_output_44;
    output wire [7:0] TTL_output_45;
    output wire [7:0] TTL_output_46;
    output wire [7:0] TTL_output_47;
    output wire [7:0] TTL_output_48;
    output wire [7:0] TTL_output_49;
    output wire [7:0] TTL_output_50;
    output wire [7:0] TTL_output_51;
    output wire [7:0] TTL_output_52;
    output wire [7:0] TTL_output_53;
    output wire [7:0] TTL_output_54;
    output wire [7:0] TTL_output_55;
    output wire [7:0] TTL_output_56;
    output wire [7:0] TTL_output_57;
    output wire [7:0] TTL_output_58;
    output wire [7:0] TTL_output_59;
    output wire [7:0] TTL_output_60;
    output wire [7:0] TTL_output_61;
    output wire [7:0] TTL_output_62;
    output wire [7:0] TTL_output_63;
);

//////////////////////////////////////////////////////////////////////////////////  
// GPO_Core
//////////////////////////////////////////////////////////////////////////////////
wire selected_0;
wire overrided_0;
wire busy_error_0;
wire [63:0] gpo_out_0;

wire selected_1;
wire overrided_1;
wire busy_error_1;
wire [63:0] gpo_out_1;

wire selected_2;
wire overrided_2;
wire busy_error_2;
wire [63:0] gpo_out_2;

wire selected_3;
wire overrided_3;
wire busy_error_3;
wire [63:0] gpo_out_3;

wire selected_4;
wire overrided_4;
wire busy_error_4;
wire [63:0] gpo_out_4;

wire selected_5;
wire overrided_5;
wire busy_error_5;
wire [63:0] gpo_out_5;

wire selected_6;
wire overrided_6;
wire busy_error_6;
wire [63:0] gpo_out_6;

wire selected_7;
wire overrided_7;
wire busy_error_7;
wire [63:0] gpo_out_7;


GPO_Core #(
    .DEST_VAL(DEST_VAL),
    .CHANNEL_LENGTH(CHANNEL_LENGTH)
)
GPO_Core0(
    .clk(clk),
    .reset(reset),
    .override_en(override_en),
    .selected_en(selected_en),
    .override_value(override_value_0),
    .counter_matched(counter_matched_0),
    .gpo_in(gpo_in_0),
    .busy(busy),
    .selected(selected_0),
    .error_data(error_data_0),
    .overrided(overrided_0),
    .busy_error(busy_error_0),
    .gpo_out(gpo_out_0)
);


GPO_Core #(
    .DEST_VAL(DEST_VAL),
    .CHANNEL_LENGTH(CHANNEL_LENGTH)
)
GPO_Core1(
    .clk(clk),
    .reset(reset),
    .override_en(override_en),
    .selected_en(selected_en),
    .override_value(override_value_1),
    .counter_matched(counter_matched_1),
    .gpo_in(gpo_in_1),
    .busy(busy),
    .selected(selected_1),
    .error_data(error_data_1),
    .overrided(overrided_1),
    .busy_error(busy_error_1),
    .gpo_out(gpo_out_1)
);


GPO_Core #(
    .DEST_VAL(DEST_VAL),
    .CHANNEL_LENGTH(CHANNEL_LENGTH)
)
GPO_Core2(
    .clk(clk),
    .reset(reset),
    .override_en(override_en),
    .selected_en(selected_en),
    .override_value(override_value_2),
    .counter_matched(counter_matched_2),
    .gpo_in(gpo_in_2),
    .busy(busy),
    .selected(selected_2),
    .error_data(error_data_2),
    .overrided(overrided_2),
    .busy_error(busy_error_2),
    .gpo_out(gpo_out_2)
);


GPO_Core #(
    .DEST_VAL(DEST_VAL),
    .CHANNEL_LENGTH(CHANNEL_LENGTH)
)
GPO_Core3(
    .clk(clk),
    .reset(reset),
    .override_en(override_en),
    .selected_en(selected_en),
    .override_value(override_value_3),
    .counter_matched(counter_matched_3),
    .gpo_in(gpo_in_3),
    .busy(busy),
    .selected(selected_3),
    .error_data(error_data_3),
    .overrided(overrided_3),
    .busy_error(busy_error_3),
    .gpo_out(gpo_out_3)
);


GPO_Core #(
    .DEST_VAL(DEST_VAL),
    .CHANNEL_LENGTH(CHANNEL_LENGTH)
)
GPO_Core4(
    .clk(clk),
    .reset(reset),
    .override_en(override_en),
    .selected_en(selected_en),
    .override_value(override_value_4),
    .counter_matched(counter_matched_4),
    .gpo_in(gpo_in_4),
    .busy(busy),
    .selected(selected_4),
    .error_data(error_data_4),
    .overrided(overrided_4),
    .busy_error(busy_error_4),
    .gpo_out(gpo_out_4)
);


GPO_Core #(
    .DEST_VAL(DEST_VAL),
    .CHANNEL_LENGTH(CHANNEL_LENGTH)
)
GPO_Core5(
    .clk(clk),
    .reset(reset),
    .override_en(override_en),
    .selected_en(selected_en),
    .override_value(override_value_5),
    .counter_matched(counter_matched_5),
    .gpo_in(gpo_in_5),
    .busy(busy),
    .selected(selected_5),
    .error_data(error_data_5),
    .overrided(overrided_5),
    .busy_error(busy_error_5),
    .gpo_out(gpo_out_5)
);


GPO_Core #(
    .DEST_VAL(DEST_VAL),
    .CHANNEL_LENGTH(CHANNEL_LENGTH)
)
GPO_Core6(
    .clk(clk),
    .reset(reset),
    .override_en(override_en),
    .selected_en(selected_en),
    .override_value(override_value_6),
    .counter_matched(counter_matched_6),
    .gpo_in(gpo_in_6),
    .busy(busy),
    .selected(selected_6),
    .error_data(error_data_6),
    .overrided(overrided_6),
    .busy_error(busy_error_6),
    .gpo_out(gpo_out_6)
);


GPO_Core #(
    .DEST_VAL(DEST_VAL),
    .CHANNEL_LENGTH(CHANNEL_LENGTH)
)
GPO_Core7(
    .clk(clk),
    .reset(reset),
    .override_en(override_en),
    .selected_en(selected_en),
    .override_value(override_value_7),
    .counter_matched(counter_matched_7),
    .gpo_in(gpo_in_7),
    .busy(busy),
    .selected(selected_7),
    .error_data(error_data_7),
    .overrided(overrided_7),
    .busy_error(busy_error_7),
    .gpo_out(gpo_out_7)
);

reg [63:0] last_reg_output;
/*
for i in range(64):
assign TTL_output_{i}[0] = (selected_0 == 1\'b1 )? gpo_output_0[{i}] : last_reg_output[{i}];
for i in range(64):
    for j in range(7):
assign TTL_output_{i}[{j+1}] = (selected_{j+1} == 1\'b1 )? gpo_output_{j+1}[{i}] : TTL_output_{i}[{j}];
*/

always@(posedge clk) begin
    if( reset == 1'b1 ) begin
        last_reg_output[0] <= 1'b0;
        last_reg_output[1] <= 1'b0;
        last_reg_output[2] <= 1'b0;
        last_reg_output[3] <= 1'b0;
        last_reg_output[4] <= 1'b0;
        last_reg_output[5] <= 1'b0;
        last_reg_output[6] <= 1'b0;
        last_reg_output[7] <= 1'b0;
        last_reg_output[8] <= 1'b0;
        last_reg_output[9] <= 1'b0;
        last_reg_output[10] <= 1'b0;
        last_reg_output[11] <= 1'b0;
        last_reg_output[12] <= 1'b0;
        last_reg_output[13] <= 1'b0;
        last_reg_output[14] <= 1'b0;
        last_reg_output[15] <= 1'b0;
        last_reg_output[16] <= 1'b0;
        last_reg_output[17] <= 1'b0;
        last_reg_output[18] <= 1'b0;
        last_reg_output[19] <= 1'b0;
        last_reg_output[20] <= 1'b0;
        last_reg_output[21] <= 1'b0;
        last_reg_output[22] <= 1'b0;
        last_reg_output[23] <= 1'b0;
        last_reg_output[24] <= 1'b0;
        last_reg_output[25] <= 1'b0;
        last_reg_output[26] <= 1'b0;
        last_reg_output[27] <= 1'b0;
        last_reg_output[28] <= 1'b0;
        last_reg_output[29] <= 1'b0;
        last_reg_output[30] <= 1'b0;
        last_reg_output[31] <= 1'b0;
        last_reg_output[32] <= 1'b0;
        last_reg_output[33] <= 1'b0;
        last_reg_output[34] <= 1'b0;
        last_reg_output[35] <= 1'b0;
        last_reg_output[36] <= 1'b0;
        last_reg_output[37] <= 1'b0;
        last_reg_output[38] <= 1'b0;
        last_reg_output[39] <= 1'b0;
        last_reg_output[40] <= 1'b0;
        last_reg_output[41] <= 1'b0;
        last_reg_output[42] <= 1'b0;
        last_reg_output[43] <= 1'b0;
        last_reg_output[44] <= 1'b0;
        last_reg_output[45] <= 1'b0;
        last_reg_output[46] <= 1'b0;
        last_reg_output[47] <= 1'b0;
        last_reg_output[48] <= 1'b0;
        last_reg_output[49] <= 1'b0;
        last_reg_output[50] <= 1'b0;
        last_reg_output[51] <= 1'b0;
        last_reg_output[52] <= 1'b0;
        last_reg_output[53] <= 1'b0;
        last_reg_output[54] <= 1'b0;
        last_reg_output[55] <= 1'b0;
        last_reg_output[56] <= 1'b0;
        last_reg_output[57] <= 1'b0;
        last_reg_output[58] <= 1'b0;
        last_reg_output[59] <= 1'b0;
        last_reg_output[60] <= 1'b0;
        last_reg_output[61] <= 1'b0;
        last_reg_output[62] <= 1'b0;
        last_reg_output[63] <= 1'b0;
    end
    else begin
        last_reg_output[0] <= TTL_output_0[7];
        last_reg_output[1] <= TTL_output_1[7];
        last_reg_output[2] <= TTL_output_2[7];
        last_reg_output[3] <= TTL_output_3[7];
        last_reg_output[4] <= TTL_output_4[7];
        last_reg_output[5] <= TTL_output_5[7];
        last_reg_output[6] <= TTL_output_6[7];
        last_reg_output[7] <= TTL_output_7[7];
        last_reg_output[8] <= TTL_output_8[7];
        last_reg_output[9] <= TTL_output_9[7];
        last_reg_output[10] <= TTL_output_10[7];
        last_reg_output[11] <= TTL_output_11[7];
        last_reg_output[12] <= TTL_output_12[7];
        last_reg_output[13] <= TTL_output_13[7];
        last_reg_output[14] <= TTL_output_14[7];
        last_reg_output[15] <= TTL_output_15[7];
        last_reg_output[16] <= TTL_output_16[7];
        last_reg_output[17] <= TTL_output_17[7];
        last_reg_output[18] <= TTL_output_18[7];
        last_reg_output[19] <= TTL_output_19[7];
        last_reg_output[20] <= TTL_output_20[7];
        last_reg_output[21] <= TTL_output_21[7];
        last_reg_output[22] <= TTL_output_22[7];
        last_reg_output[23] <= TTL_output_23[7];
        last_reg_output[24] <= TTL_output_24[7];
        last_reg_output[25] <= TTL_output_25[7];
        last_reg_output[26] <= TTL_output_26[7];
        last_reg_output[27] <= TTL_output_27[7];
        last_reg_output[28] <= TTL_output_28[7];
        last_reg_output[29] <= TTL_output_29[7];
        last_reg_output[30] <= TTL_output_30[7];
        last_reg_output[31] <= TTL_output_31[7];
        last_reg_output[32] <= TTL_output_32[7];
        last_reg_output[33] <= TTL_output_33[7];
        last_reg_output[34] <= TTL_output_34[7];
        last_reg_output[35] <= TTL_output_35[7];
        last_reg_output[36] <= TTL_output_36[7];
        last_reg_output[37] <= TTL_output_37[7];
        last_reg_output[38] <= TTL_output_38[7];
        last_reg_output[39] <= TTL_output_39[7];
        last_reg_output[40] <= TTL_output_40[7];
        last_reg_output[41] <= TTL_output_41[7];
        last_reg_output[42] <= TTL_output_42[7];
        last_reg_output[43] <= TTL_output_43[7];
        last_reg_output[44] <= TTL_output_44[7];
        last_reg_output[45] <= TTL_output_45[7];
        last_reg_output[46] <= TTL_output_46[7];
        last_reg_output[47] <= TTL_output_47[7];
        last_reg_output[48] <= TTL_output_48[7];
        last_reg_output[49] <= TTL_output_49[7];
        last_reg_output[50] <= TTL_output_50[7];
        last_reg_output[51] <= TTL_output_51[7];
        last_reg_output[52] <= TTL_output_52[7];
        last_reg_output[53] <= TTL_output_53[7];
        last_reg_output[54] <= TTL_output_54[7];
        last_reg_output[55] <= TTL_output_55[7];
        last_reg_output[56] <= TTL_output_56[7];
        last_reg_output[57] <= TTL_output_57[7];
        last_reg_output[58] <= TTL_output_58[7];
        last_reg_output[59] <= TTL_output_59[7];
        last_reg_output[60] <= TTL_output_60[7];
        last_reg_output[61] <= TTL_output_61[7];
        last_reg_output[62] <= TTL_output_62[7];
        last_reg_output[63] <= TTL_output_63[7];
    end
end

assign TTL_output_0[0] = (selected_0 == 1'b1 )? gpo_output_0[0] : last_reg_output[0];
assign TTL_output_1[0] = (selected_0 == 1'b1 )? gpo_output_0[1] : last_reg_output[1];
assign TTL_output_2[0] = (selected_0 == 1'b1 )? gpo_output_0[2] : last_reg_output[2];
assign TTL_output_3[0] = (selected_0 == 1'b1 )? gpo_output_0[3] : last_reg_output[3];
assign TTL_output_4[0] = (selected_0 == 1'b1 )? gpo_output_0[4] : last_reg_output[4];
assign TTL_output_5[0] = (selected_0 == 1'b1 )? gpo_output_0[5] : last_reg_output[5];
assign TTL_output_6[0] = (selected_0 == 1'b1 )? gpo_output_0[6] : last_reg_output[6];
assign TTL_output_7[0] = (selected_0 == 1'b1 )? gpo_output_0[7] : last_reg_output[7];
assign TTL_output_8[0] = (selected_0 == 1'b1 )? gpo_output_0[8] : last_reg_output[8];
assign TTL_output_9[0] = (selected_0 == 1'b1 )? gpo_output_0[9] : last_reg_output[9];
assign TTL_output_10[0] = (selected_0 == 1'b1 )? gpo_output_0[10] : last_reg_output[10];
assign TTL_output_11[0] = (selected_0 == 1'b1 )? gpo_output_0[11] : last_reg_output[11];
assign TTL_output_12[0] = (selected_0 == 1'b1 )? gpo_output_0[12] : last_reg_output[12];
assign TTL_output_13[0] = (selected_0 == 1'b1 )? gpo_output_0[13] : last_reg_output[13];
assign TTL_output_14[0] = (selected_0 == 1'b1 )? gpo_output_0[14] : last_reg_output[14];
assign TTL_output_15[0] = (selected_0 == 1'b1 )? gpo_output_0[15] : last_reg_output[15];
assign TTL_output_16[0] = (selected_0 == 1'b1 )? gpo_output_0[16] : last_reg_output[16];
assign TTL_output_17[0] = (selected_0 == 1'b1 )? gpo_output_0[17] : last_reg_output[17];
assign TTL_output_18[0] = (selected_0 == 1'b1 )? gpo_output_0[18] : last_reg_output[18];
assign TTL_output_19[0] = (selected_0 == 1'b1 )? gpo_output_0[19] : last_reg_output[19];
assign TTL_output_20[0] = (selected_0 == 1'b1 )? gpo_output_0[20] : last_reg_output[20];
assign TTL_output_21[0] = (selected_0 == 1'b1 )? gpo_output_0[21] : last_reg_output[21];
assign TTL_output_22[0] = (selected_0 == 1'b1 )? gpo_output_0[22] : last_reg_output[22];
assign TTL_output_23[0] = (selected_0 == 1'b1 )? gpo_output_0[23] : last_reg_output[23];
assign TTL_output_24[0] = (selected_0 == 1'b1 )? gpo_output_0[24] : last_reg_output[24];
assign TTL_output_25[0] = (selected_0 == 1'b1 )? gpo_output_0[25] : last_reg_output[25];
assign TTL_output_26[0] = (selected_0 == 1'b1 )? gpo_output_0[26] : last_reg_output[26];
assign TTL_output_27[0] = (selected_0 == 1'b1 )? gpo_output_0[27] : last_reg_output[27];
assign TTL_output_28[0] = (selected_0 == 1'b1 )? gpo_output_0[28] : last_reg_output[28];
assign TTL_output_29[0] = (selected_0 == 1'b1 )? gpo_output_0[29] : last_reg_output[29];
assign TTL_output_30[0] = (selected_0 == 1'b1 )? gpo_output_0[30] : last_reg_output[30];
assign TTL_output_31[0] = (selected_0 == 1'b1 )? gpo_output_0[31] : last_reg_output[31];
assign TTL_output_32[0] = (selected_0 == 1'b1 )? gpo_output_0[32] : last_reg_output[32];
assign TTL_output_33[0] = (selected_0 == 1'b1 )? gpo_output_0[33] : last_reg_output[33];
assign TTL_output_34[0] = (selected_0 == 1'b1 )? gpo_output_0[34] : last_reg_output[34];
assign TTL_output_35[0] = (selected_0 == 1'b1 )? gpo_output_0[35] : last_reg_output[35];
assign TTL_output_36[0] = (selected_0 == 1'b1 )? gpo_output_0[36] : last_reg_output[36];
assign TTL_output_37[0] = (selected_0 == 1'b1 )? gpo_output_0[37] : last_reg_output[37];
assign TTL_output_38[0] = (selected_0 == 1'b1 )? gpo_output_0[38] : last_reg_output[38];
assign TTL_output_39[0] = (selected_0 == 1'b1 )? gpo_output_0[39] : last_reg_output[39];
assign TTL_output_40[0] = (selected_0 == 1'b1 )? gpo_output_0[40] : last_reg_output[40];
assign TTL_output_41[0] = (selected_0 == 1'b1 )? gpo_output_0[41] : last_reg_output[41];
assign TTL_output_42[0] = (selected_0 == 1'b1 )? gpo_output_0[42] : last_reg_output[42];
assign TTL_output_43[0] = (selected_0 == 1'b1 )? gpo_output_0[43] : last_reg_output[43];
assign TTL_output_44[0] = (selected_0 == 1'b1 )? gpo_output_0[44] : last_reg_output[44];
assign TTL_output_45[0] = (selected_0 == 1'b1 )? gpo_output_0[45] : last_reg_output[45];
assign TTL_output_46[0] = (selected_0 == 1'b1 )? gpo_output_0[46] : last_reg_output[46];
assign TTL_output_47[0] = (selected_0 == 1'b1 )? gpo_output_0[47] : last_reg_output[47];
assign TTL_output_48[0] = (selected_0 == 1'b1 )? gpo_output_0[48] : last_reg_output[48];
assign TTL_output_49[0] = (selected_0 == 1'b1 )? gpo_output_0[49] : last_reg_output[49];
assign TTL_output_50[0] = (selected_0 == 1'b1 )? gpo_output_0[50] : last_reg_output[50];
assign TTL_output_51[0] = (selected_0 == 1'b1 )? gpo_output_0[51] : last_reg_output[51];
assign TTL_output_52[0] = (selected_0 == 1'b1 )? gpo_output_0[52] : last_reg_output[52];
assign TTL_output_53[0] = (selected_0 == 1'b1 )? gpo_output_0[53] : last_reg_output[53];
assign TTL_output_54[0] = (selected_0 == 1'b1 )? gpo_output_0[54] : last_reg_output[54];
assign TTL_output_55[0] = (selected_0 == 1'b1 )? gpo_output_0[55] : last_reg_output[55];
assign TTL_output_56[0] = (selected_0 == 1'b1 )? gpo_output_0[56] : last_reg_output[56];
assign TTL_output_57[0] = (selected_0 == 1'b1 )? gpo_output_0[57] : last_reg_output[57];
assign TTL_output_58[0] = (selected_0 == 1'b1 )? gpo_output_0[58] : last_reg_output[58];
assign TTL_output_59[0] = (selected_0 == 1'b1 )? gpo_output_0[59] : last_reg_output[59];
assign TTL_output_60[0] = (selected_0 == 1'b1 )? gpo_output_0[60] : last_reg_output[60];
assign TTL_output_61[0] = (selected_0 == 1'b1 )? gpo_output_0[61] : last_reg_output[61];
assign TTL_output_62[0] = (selected_0 == 1'b1 )? gpo_output_0[62] : last_reg_output[62];
assign TTL_output_63[0] = (selected_0 == 1'b1 )? gpo_output_0[63] : last_reg_output[63];

assign TTL_output_0[1] = (selected_1 == 1'b1 )? gpo_output_1[0] : TTL_output_0[0];
assign TTL_output_0[2] = (selected_2 == 1'b1 )? gpo_output_2[0] : TTL_output_0[1];
assign TTL_output_0[3] = (selected_3 == 1'b1 )? gpo_output_3[0] : TTL_output_0[2];
assign TTL_output_0[4] = (selected_4 == 1'b1 )? gpo_output_4[0] : TTL_output_0[3];
assign TTL_output_0[5] = (selected_5 == 1'b1 )? gpo_output_5[0] : TTL_output_0[4];
assign TTL_output_0[6] = (selected_6 == 1'b1 )? gpo_output_6[0] : TTL_output_0[5];
assign TTL_output_0[7] = (selected_7 == 1'b1 )? gpo_output_7[0] : TTL_output_0[6];
assign TTL_output_1[1] = (selected_1 == 1'b1 )? gpo_output_1[1] : TTL_output_1[0];
assign TTL_output_1[2] = (selected_2 == 1'b1 )? gpo_output_2[1] : TTL_output_1[1];
assign TTL_output_1[3] = (selected_3 == 1'b1 )? gpo_output_3[1] : TTL_output_1[2];
assign TTL_output_1[4] = (selected_4 == 1'b1 )? gpo_output_4[1] : TTL_output_1[3];
assign TTL_output_1[5] = (selected_5 == 1'b1 )? gpo_output_5[1] : TTL_output_1[4];
assign TTL_output_1[6] = (selected_6 == 1'b1 )? gpo_output_6[1] : TTL_output_1[5];
assign TTL_output_1[7] = (selected_7 == 1'b1 )? gpo_output_7[1] : TTL_output_1[6];
assign TTL_output_2[1] = (selected_1 == 1'b1 )? gpo_output_1[2] : TTL_output_2[0];
assign TTL_output_2[2] = (selected_2 == 1'b1 )? gpo_output_2[2] : TTL_output_2[1];
assign TTL_output_2[3] = (selected_3 == 1'b1 )? gpo_output_3[2] : TTL_output_2[2];
assign TTL_output_2[4] = (selected_4 == 1'b1 )? gpo_output_4[2] : TTL_output_2[3];
assign TTL_output_2[5] = (selected_5 == 1'b1 )? gpo_output_5[2] : TTL_output_2[4];
assign TTL_output_2[6] = (selected_6 == 1'b1 )? gpo_output_6[2] : TTL_output_2[5];
assign TTL_output_2[7] = (selected_7 == 1'b1 )? gpo_output_7[2] : TTL_output_2[6];
assign TTL_output_3[1] = (selected_1 == 1'b1 )? gpo_output_1[3] : TTL_output_3[0];
assign TTL_output_3[2] = (selected_2 == 1'b1 )? gpo_output_2[3] : TTL_output_3[1];
assign TTL_output_3[3] = (selected_3 == 1'b1 )? gpo_output_3[3] : TTL_output_3[2];
assign TTL_output_3[4] = (selected_4 == 1'b1 )? gpo_output_4[3] : TTL_output_3[3];
assign TTL_output_3[5] = (selected_5 == 1'b1 )? gpo_output_5[3] : TTL_output_3[4];
assign TTL_output_3[6] = (selected_6 == 1'b1 )? gpo_output_6[3] : TTL_output_3[5];
assign TTL_output_3[7] = (selected_7 == 1'b1 )? gpo_output_7[3] : TTL_output_3[6];
assign TTL_output_4[1] = (selected_1 == 1'b1 )? gpo_output_1[4] : TTL_output_4[0];
assign TTL_output_4[2] = (selected_2 == 1'b1 )? gpo_output_2[4] : TTL_output_4[1];
assign TTL_output_4[3] = (selected_3 == 1'b1 )? gpo_output_3[4] : TTL_output_4[2];
assign TTL_output_4[4] = (selected_4 == 1'b1 )? gpo_output_4[4] : TTL_output_4[3];
assign TTL_output_4[5] = (selected_5 == 1'b1 )? gpo_output_5[4] : TTL_output_4[4];
assign TTL_output_4[6] = (selected_6 == 1'b1 )? gpo_output_6[4] : TTL_output_4[5];
assign TTL_output_4[7] = (selected_7 == 1'b1 )? gpo_output_7[4] : TTL_output_4[6];
assign TTL_output_5[1] = (selected_1 == 1'b1 )? gpo_output_1[5] : TTL_output_5[0];
assign TTL_output_5[2] = (selected_2 == 1'b1 )? gpo_output_2[5] : TTL_output_5[1];
assign TTL_output_5[3] = (selected_3 == 1'b1 )? gpo_output_3[5] : TTL_output_5[2];
assign TTL_output_5[4] = (selected_4 == 1'b1 )? gpo_output_4[5] : TTL_output_5[3];
assign TTL_output_5[5] = (selected_5 == 1'b1 )? gpo_output_5[5] : TTL_output_5[4];
assign TTL_output_5[6] = (selected_6 == 1'b1 )? gpo_output_6[5] : TTL_output_5[5];
assign TTL_output_5[7] = (selected_7 == 1'b1 )? gpo_output_7[5] : TTL_output_5[6];
assign TTL_output_6[1] = (selected_1 == 1'b1 )? gpo_output_1[6] : TTL_output_6[0];
assign TTL_output_6[2] = (selected_2 == 1'b1 )? gpo_output_2[6] : TTL_output_6[1];
assign TTL_output_6[3] = (selected_3 == 1'b1 )? gpo_output_3[6] : TTL_output_6[2];
assign TTL_output_6[4] = (selected_4 == 1'b1 )? gpo_output_4[6] : TTL_output_6[3];
assign TTL_output_6[5] = (selected_5 == 1'b1 )? gpo_output_5[6] : TTL_output_6[4];
assign TTL_output_6[6] = (selected_6 == 1'b1 )? gpo_output_6[6] : TTL_output_6[5];
assign TTL_output_6[7] = (selected_7 == 1'b1 )? gpo_output_7[6] : TTL_output_6[6];
assign TTL_output_7[1] = (selected_1 == 1'b1 )? gpo_output_1[7] : TTL_output_7[0];
assign TTL_output_7[2] = (selected_2 == 1'b1 )? gpo_output_2[7] : TTL_output_7[1];
assign TTL_output_7[3] = (selected_3 == 1'b1 )? gpo_output_3[7] : TTL_output_7[2];
assign TTL_output_7[4] = (selected_4 == 1'b1 )? gpo_output_4[7] : TTL_output_7[3];
assign TTL_output_7[5] = (selected_5 == 1'b1 )? gpo_output_5[7] : TTL_output_7[4];
assign TTL_output_7[6] = (selected_6 == 1'b1 )? gpo_output_6[7] : TTL_output_7[5];
assign TTL_output_7[7] = (selected_7 == 1'b1 )? gpo_output_7[7] : TTL_output_7[6];
assign TTL_output_8[1] = (selected_1 == 1'b1 )? gpo_output_1[8] : TTL_output_8[0];
assign TTL_output_8[2] = (selected_2 == 1'b1 )? gpo_output_2[8] : TTL_output_8[1];
assign TTL_output_8[3] = (selected_3 == 1'b1 )? gpo_output_3[8] : TTL_output_8[2];
assign TTL_output_8[4] = (selected_4 == 1'b1 )? gpo_output_4[8] : TTL_output_8[3];
assign TTL_output_8[5] = (selected_5 == 1'b1 )? gpo_output_5[8] : TTL_output_8[4];
assign TTL_output_8[6] = (selected_6 == 1'b1 )? gpo_output_6[8] : TTL_output_8[5];
assign TTL_output_8[7] = (selected_7 == 1'b1 )? gpo_output_7[8] : TTL_output_8[6];
assign TTL_output_9[1] = (selected_1 == 1'b1 )? gpo_output_1[9] : TTL_output_9[0];
assign TTL_output_9[2] = (selected_2 == 1'b1 )? gpo_output_2[9] : TTL_output_9[1];
assign TTL_output_9[3] = (selected_3 == 1'b1 )? gpo_output_3[9] : TTL_output_9[2];
assign TTL_output_9[4] = (selected_4 == 1'b1 )? gpo_output_4[9] : TTL_output_9[3];
assign TTL_output_9[5] = (selected_5 == 1'b1 )? gpo_output_5[9] : TTL_output_9[4];
assign TTL_output_9[6] = (selected_6 == 1'b1 )? gpo_output_6[9] : TTL_output_9[5];
assign TTL_output_9[7] = (selected_7 == 1'b1 )? gpo_output_7[9] : TTL_output_9[6];
assign TTL_output_10[1] = (selected_1 == 1'b1 )? gpo_output_1[10] : TTL_output_10[0];
assign TTL_output_10[2] = (selected_2 == 1'b1 )? gpo_output_2[10] : TTL_output_10[1];
assign TTL_output_10[3] = (selected_3 == 1'b1 )? gpo_output_3[10] : TTL_output_10[2];
assign TTL_output_10[4] = (selected_4 == 1'b1 )? gpo_output_4[10] : TTL_output_10[3];
assign TTL_output_10[5] = (selected_5 == 1'b1 )? gpo_output_5[10] : TTL_output_10[4];
assign TTL_output_10[6] = (selected_6 == 1'b1 )? gpo_output_6[10] : TTL_output_10[5];
assign TTL_output_10[7] = (selected_7 == 1'b1 )? gpo_output_7[10] : TTL_output_10[6];
assign TTL_output_11[1] = (selected_1 == 1'b1 )? gpo_output_1[11] : TTL_output_11[0];
assign TTL_output_11[2] = (selected_2 == 1'b1 )? gpo_output_2[11] : TTL_output_11[1];
assign TTL_output_11[3] = (selected_3 == 1'b1 )? gpo_output_3[11] : TTL_output_11[2];
assign TTL_output_11[4] = (selected_4 == 1'b1 )? gpo_output_4[11] : TTL_output_11[3];
assign TTL_output_11[5] = (selected_5 == 1'b1 )? gpo_output_5[11] : TTL_output_11[4];
assign TTL_output_11[6] = (selected_6 == 1'b1 )? gpo_output_6[11] : TTL_output_11[5];
assign TTL_output_11[7] = (selected_7 == 1'b1 )? gpo_output_7[11] : TTL_output_11[6];
assign TTL_output_12[1] = (selected_1 == 1'b1 )? gpo_output_1[12] : TTL_output_12[0];
assign TTL_output_12[2] = (selected_2 == 1'b1 )? gpo_output_2[12] : TTL_output_12[1];
assign TTL_output_12[3] = (selected_3 == 1'b1 )? gpo_output_3[12] : TTL_output_12[2];
assign TTL_output_12[4] = (selected_4 == 1'b1 )? gpo_output_4[12] : TTL_output_12[3];
assign TTL_output_12[5] = (selected_5 == 1'b1 )? gpo_output_5[12] : TTL_output_12[4];
assign TTL_output_12[6] = (selected_6 == 1'b1 )? gpo_output_6[12] : TTL_output_12[5];
assign TTL_output_12[7] = (selected_7 == 1'b1 )? gpo_output_7[12] : TTL_output_12[6];
assign TTL_output_13[1] = (selected_1 == 1'b1 )? gpo_output_1[13] : TTL_output_13[0];
assign TTL_output_13[2] = (selected_2 == 1'b1 )? gpo_output_2[13] : TTL_output_13[1];
assign TTL_output_13[3] = (selected_3 == 1'b1 )? gpo_output_3[13] : TTL_output_13[2];
assign TTL_output_13[4] = (selected_4 == 1'b1 )? gpo_output_4[13] : TTL_output_13[3];
assign TTL_output_13[5] = (selected_5 == 1'b1 )? gpo_output_5[13] : TTL_output_13[4];
assign TTL_output_13[6] = (selected_6 == 1'b1 )? gpo_output_6[13] : TTL_output_13[5];
assign TTL_output_13[7] = (selected_7 == 1'b1 )? gpo_output_7[13] : TTL_output_13[6];
assign TTL_output_14[1] = (selected_1 == 1'b1 )? gpo_output_1[14] : TTL_output_14[0];
assign TTL_output_14[2] = (selected_2 == 1'b1 )? gpo_output_2[14] : TTL_output_14[1];
assign TTL_output_14[3] = (selected_3 == 1'b1 )? gpo_output_3[14] : TTL_output_14[2];
assign TTL_output_14[4] = (selected_4 == 1'b1 )? gpo_output_4[14] : TTL_output_14[3];
assign TTL_output_14[5] = (selected_5 == 1'b1 )? gpo_output_5[14] : TTL_output_14[4];
assign TTL_output_14[6] = (selected_6 == 1'b1 )? gpo_output_6[14] : TTL_output_14[5];
assign TTL_output_14[7] = (selected_7 == 1'b1 )? gpo_output_7[14] : TTL_output_14[6];
assign TTL_output_15[1] = (selected_1 == 1'b1 )? gpo_output_1[15] : TTL_output_15[0];
assign TTL_output_15[2] = (selected_2 == 1'b1 )? gpo_output_2[15] : TTL_output_15[1];
assign TTL_output_15[3] = (selected_3 == 1'b1 )? gpo_output_3[15] : TTL_output_15[2];
assign TTL_output_15[4] = (selected_4 == 1'b1 )? gpo_output_4[15] : TTL_output_15[3];
assign TTL_output_15[5] = (selected_5 == 1'b1 )? gpo_output_5[15] : TTL_output_15[4];
assign TTL_output_15[6] = (selected_6 == 1'b1 )? gpo_output_6[15] : TTL_output_15[5];
assign TTL_output_15[7] = (selected_7 == 1'b1 )? gpo_output_7[15] : TTL_output_15[6];
assign TTL_output_16[1] = (selected_1 == 1'b1 )? gpo_output_1[16] : TTL_output_16[0];
assign TTL_output_16[2] = (selected_2 == 1'b1 )? gpo_output_2[16] : TTL_output_16[1];
assign TTL_output_16[3] = (selected_3 == 1'b1 )? gpo_output_3[16] : TTL_output_16[2];
assign TTL_output_16[4] = (selected_4 == 1'b1 )? gpo_output_4[16] : TTL_output_16[3];
assign TTL_output_16[5] = (selected_5 == 1'b1 )? gpo_output_5[16] : TTL_output_16[4];
assign TTL_output_16[6] = (selected_6 == 1'b1 )? gpo_output_6[16] : TTL_output_16[5];
assign TTL_output_16[7] = (selected_7 == 1'b1 )? gpo_output_7[16] : TTL_output_16[6];
assign TTL_output_17[1] = (selected_1 == 1'b1 )? gpo_output_1[17] : TTL_output_17[0];
assign TTL_output_17[2] = (selected_2 == 1'b1 )? gpo_output_2[17] : TTL_output_17[1];
assign TTL_output_17[3] = (selected_3 == 1'b1 )? gpo_output_3[17] : TTL_output_17[2];
assign TTL_output_17[4] = (selected_4 == 1'b1 )? gpo_output_4[17] : TTL_output_17[3];
assign TTL_output_17[5] = (selected_5 == 1'b1 )? gpo_output_5[17] : TTL_output_17[4];
assign TTL_output_17[6] = (selected_6 == 1'b1 )? gpo_output_6[17] : TTL_output_17[5];
assign TTL_output_17[7] = (selected_7 == 1'b1 )? gpo_output_7[17] : TTL_output_17[6];
assign TTL_output_18[1] = (selected_1 == 1'b1 )? gpo_output_1[18] : TTL_output_18[0];
assign TTL_output_18[2] = (selected_2 == 1'b1 )? gpo_output_2[18] : TTL_output_18[1];
assign TTL_output_18[3] = (selected_3 == 1'b1 )? gpo_output_3[18] : TTL_output_18[2];
assign TTL_output_18[4] = (selected_4 == 1'b1 )? gpo_output_4[18] : TTL_output_18[3];
assign TTL_output_18[5] = (selected_5 == 1'b1 )? gpo_output_5[18] : TTL_output_18[4];
assign TTL_output_18[6] = (selected_6 == 1'b1 )? gpo_output_6[18] : TTL_output_18[5];
assign TTL_output_18[7] = (selected_7 == 1'b1 )? gpo_output_7[18] : TTL_output_18[6];
assign TTL_output_19[1] = (selected_1 == 1'b1 )? gpo_output_1[19] : TTL_output_19[0];
assign TTL_output_19[2] = (selected_2 == 1'b1 )? gpo_output_2[19] : TTL_output_19[1];
assign TTL_output_19[3] = (selected_3 == 1'b1 )? gpo_output_3[19] : TTL_output_19[2];
assign TTL_output_19[4] = (selected_4 == 1'b1 )? gpo_output_4[19] : TTL_output_19[3];
assign TTL_output_19[5] = (selected_5 == 1'b1 )? gpo_output_5[19] : TTL_output_19[4];
assign TTL_output_19[6] = (selected_6 == 1'b1 )? gpo_output_6[19] : TTL_output_19[5];
assign TTL_output_19[7] = (selected_7 == 1'b1 )? gpo_output_7[19] : TTL_output_19[6];
assign TTL_output_20[1] = (selected_1 == 1'b1 )? gpo_output_1[20] : TTL_output_20[0];
assign TTL_output_20[2] = (selected_2 == 1'b1 )? gpo_output_2[20] : TTL_output_20[1];
assign TTL_output_20[3] = (selected_3 == 1'b1 )? gpo_output_3[20] : TTL_output_20[2];
assign TTL_output_20[4] = (selected_4 == 1'b1 )? gpo_output_4[20] : TTL_output_20[3];
assign TTL_output_20[5] = (selected_5 == 1'b1 )? gpo_output_5[20] : TTL_output_20[4];
assign TTL_output_20[6] = (selected_6 == 1'b1 )? gpo_output_6[20] : TTL_output_20[5];
assign TTL_output_20[7] = (selected_7 == 1'b1 )? gpo_output_7[20] : TTL_output_20[6];
assign TTL_output_21[1] = (selected_1 == 1'b1 )? gpo_output_1[21] : TTL_output_21[0];
assign TTL_output_21[2] = (selected_2 == 1'b1 )? gpo_output_2[21] : TTL_output_21[1];
assign TTL_output_21[3] = (selected_3 == 1'b1 )? gpo_output_3[21] : TTL_output_21[2];
assign TTL_output_21[4] = (selected_4 == 1'b1 )? gpo_output_4[21] : TTL_output_21[3];
assign TTL_output_21[5] = (selected_5 == 1'b1 )? gpo_output_5[21] : TTL_output_21[4];
assign TTL_output_21[6] = (selected_6 == 1'b1 )? gpo_output_6[21] : TTL_output_21[5];
assign TTL_output_21[7] = (selected_7 == 1'b1 )? gpo_output_7[21] : TTL_output_21[6];
assign TTL_output_22[1] = (selected_1 == 1'b1 )? gpo_output_1[22] : TTL_output_22[0];
assign TTL_output_22[2] = (selected_2 == 1'b1 )? gpo_output_2[22] : TTL_output_22[1];
assign TTL_output_22[3] = (selected_3 == 1'b1 )? gpo_output_3[22] : TTL_output_22[2];
assign TTL_output_22[4] = (selected_4 == 1'b1 )? gpo_output_4[22] : TTL_output_22[3];
assign TTL_output_22[5] = (selected_5 == 1'b1 )? gpo_output_5[22] : TTL_output_22[4];
assign TTL_output_22[6] = (selected_6 == 1'b1 )? gpo_output_6[22] : TTL_output_22[5];
assign TTL_output_22[7] = (selected_7 == 1'b1 )? gpo_output_7[22] : TTL_output_22[6];
assign TTL_output_23[1] = (selected_1 == 1'b1 )? gpo_output_1[23] : TTL_output_23[0];
assign TTL_output_23[2] = (selected_2 == 1'b1 )? gpo_output_2[23] : TTL_output_23[1];
assign TTL_output_23[3] = (selected_3 == 1'b1 )? gpo_output_3[23] : TTL_output_23[2];
assign TTL_output_23[4] = (selected_4 == 1'b1 )? gpo_output_4[23] : TTL_output_23[3];
assign TTL_output_23[5] = (selected_5 == 1'b1 )? gpo_output_5[23] : TTL_output_23[4];
assign TTL_output_23[6] = (selected_6 == 1'b1 )? gpo_output_6[23] : TTL_output_23[5];
assign TTL_output_23[7] = (selected_7 == 1'b1 )? gpo_output_7[23] : TTL_output_23[6];
assign TTL_output_24[1] = (selected_1 == 1'b1 )? gpo_output_1[24] : TTL_output_24[0];
assign TTL_output_24[2] = (selected_2 == 1'b1 )? gpo_output_2[24] : TTL_output_24[1];
assign TTL_output_24[3] = (selected_3 == 1'b1 )? gpo_output_3[24] : TTL_output_24[2];
assign TTL_output_24[4] = (selected_4 == 1'b1 )? gpo_output_4[24] : TTL_output_24[3];
assign TTL_output_24[5] = (selected_5 == 1'b1 )? gpo_output_5[24] : TTL_output_24[4];
assign TTL_output_24[6] = (selected_6 == 1'b1 )? gpo_output_6[24] : TTL_output_24[5];
assign TTL_output_24[7] = (selected_7 == 1'b1 )? gpo_output_7[24] : TTL_output_24[6];
assign TTL_output_25[1] = (selected_1 == 1'b1 )? gpo_output_1[25] : TTL_output_25[0];
assign TTL_output_25[2] = (selected_2 == 1'b1 )? gpo_output_2[25] : TTL_output_25[1];
assign TTL_output_25[3] = (selected_3 == 1'b1 )? gpo_output_3[25] : TTL_output_25[2];
assign TTL_output_25[4] = (selected_4 == 1'b1 )? gpo_output_4[25] : TTL_output_25[3];
assign TTL_output_25[5] = (selected_5 == 1'b1 )? gpo_output_5[25] : TTL_output_25[4];
assign TTL_output_25[6] = (selected_6 == 1'b1 )? gpo_output_6[25] : TTL_output_25[5];
assign TTL_output_25[7] = (selected_7 == 1'b1 )? gpo_output_7[25] : TTL_output_25[6];
assign TTL_output_26[1] = (selected_1 == 1'b1 )? gpo_output_1[26] : TTL_output_26[0];
assign TTL_output_26[2] = (selected_2 == 1'b1 )? gpo_output_2[26] : TTL_output_26[1];
assign TTL_output_26[3] = (selected_3 == 1'b1 )? gpo_output_3[26] : TTL_output_26[2];
assign TTL_output_26[4] = (selected_4 == 1'b1 )? gpo_output_4[26] : TTL_output_26[3];
assign TTL_output_26[5] = (selected_5 == 1'b1 )? gpo_output_5[26] : TTL_output_26[4];
assign TTL_output_26[6] = (selected_6 == 1'b1 )? gpo_output_6[26] : TTL_output_26[5];
assign TTL_output_26[7] = (selected_7 == 1'b1 )? gpo_output_7[26] : TTL_output_26[6];
assign TTL_output_27[1] = (selected_1 == 1'b1 )? gpo_output_1[27] : TTL_output_27[0];
assign TTL_output_27[2] = (selected_2 == 1'b1 )? gpo_output_2[27] : TTL_output_27[1];
assign TTL_output_27[3] = (selected_3 == 1'b1 )? gpo_output_3[27] : TTL_output_27[2];
assign TTL_output_27[4] = (selected_4 == 1'b1 )? gpo_output_4[27] : TTL_output_27[3];
assign TTL_output_27[5] = (selected_5 == 1'b1 )? gpo_output_5[27] : TTL_output_27[4];
assign TTL_output_27[6] = (selected_6 == 1'b1 )? gpo_output_6[27] : TTL_output_27[5];
assign TTL_output_27[7] = (selected_7 == 1'b1 )? gpo_output_7[27] : TTL_output_27[6];
assign TTL_output_28[1] = (selected_1 == 1'b1 )? gpo_output_1[28] : TTL_output_28[0];
assign TTL_output_28[2] = (selected_2 == 1'b1 )? gpo_output_2[28] : TTL_output_28[1];
assign TTL_output_28[3] = (selected_3 == 1'b1 )? gpo_output_3[28] : TTL_output_28[2];
assign TTL_output_28[4] = (selected_4 == 1'b1 )? gpo_output_4[28] : TTL_output_28[3];
assign TTL_output_28[5] = (selected_5 == 1'b1 )? gpo_output_5[28] : TTL_output_28[4];
assign TTL_output_28[6] = (selected_6 == 1'b1 )? gpo_output_6[28] : TTL_output_28[5];
assign TTL_output_28[7] = (selected_7 == 1'b1 )? gpo_output_7[28] : TTL_output_28[6];
assign TTL_output_29[1] = (selected_1 == 1'b1 )? gpo_output_1[29] : TTL_output_29[0];
assign TTL_output_29[2] = (selected_2 == 1'b1 )? gpo_output_2[29] : TTL_output_29[1];
assign TTL_output_29[3] = (selected_3 == 1'b1 )? gpo_output_3[29] : TTL_output_29[2];
assign TTL_output_29[4] = (selected_4 == 1'b1 )? gpo_output_4[29] : TTL_output_29[3];
assign TTL_output_29[5] = (selected_5 == 1'b1 )? gpo_output_5[29] : TTL_output_29[4];
assign TTL_output_29[6] = (selected_6 == 1'b1 )? gpo_output_6[29] : TTL_output_29[5];
assign TTL_output_29[7] = (selected_7 == 1'b1 )? gpo_output_7[29] : TTL_output_29[6];
assign TTL_output_30[1] = (selected_1 == 1'b1 )? gpo_output_1[30] : TTL_output_30[0];
assign TTL_output_30[2] = (selected_2 == 1'b1 )? gpo_output_2[30] : TTL_output_30[1];
assign TTL_output_30[3] = (selected_3 == 1'b1 )? gpo_output_3[30] : TTL_output_30[2];
assign TTL_output_30[4] = (selected_4 == 1'b1 )? gpo_output_4[30] : TTL_output_30[3];
assign TTL_output_30[5] = (selected_5 == 1'b1 )? gpo_output_5[30] : TTL_output_30[4];
assign TTL_output_30[6] = (selected_6 == 1'b1 )? gpo_output_6[30] : TTL_output_30[5];
assign TTL_output_30[7] = (selected_7 == 1'b1 )? gpo_output_7[30] : TTL_output_30[6];
assign TTL_output_31[1] = (selected_1 == 1'b1 )? gpo_output_1[31] : TTL_output_31[0];
assign TTL_output_31[2] = (selected_2 == 1'b1 )? gpo_output_2[31] : TTL_output_31[1];
assign TTL_output_31[3] = (selected_3 == 1'b1 )? gpo_output_3[31] : TTL_output_31[2];
assign TTL_output_31[4] = (selected_4 == 1'b1 )? gpo_output_4[31] : TTL_output_31[3];
assign TTL_output_31[5] = (selected_5 == 1'b1 )? gpo_output_5[31] : TTL_output_31[4];
assign TTL_output_31[6] = (selected_6 == 1'b1 )? gpo_output_6[31] : TTL_output_31[5];
assign TTL_output_31[7] = (selected_7 == 1'b1 )? gpo_output_7[31] : TTL_output_31[6];
assign TTL_output_32[1] = (selected_1 == 1'b1 )? gpo_output_1[32] : TTL_output_32[0];
assign TTL_output_32[2] = (selected_2 == 1'b1 )? gpo_output_2[32] : TTL_output_32[1];
assign TTL_output_32[3] = (selected_3 == 1'b1 )? gpo_output_3[32] : TTL_output_32[2];
assign TTL_output_32[4] = (selected_4 == 1'b1 )? gpo_output_4[32] : TTL_output_32[3];
assign TTL_output_32[5] = (selected_5 == 1'b1 )? gpo_output_5[32] : TTL_output_32[4];
assign TTL_output_32[6] = (selected_6 == 1'b1 )? gpo_output_6[32] : TTL_output_32[5];
assign TTL_output_32[7] = (selected_7 == 1'b1 )? gpo_output_7[32] : TTL_output_32[6];
assign TTL_output_33[1] = (selected_1 == 1'b1 )? gpo_output_1[33] : TTL_output_33[0];
assign TTL_output_33[2] = (selected_2 == 1'b1 )? gpo_output_2[33] : TTL_output_33[1];
assign TTL_output_33[3] = (selected_3 == 1'b1 )? gpo_output_3[33] : TTL_output_33[2];
assign TTL_output_33[4] = (selected_4 == 1'b1 )? gpo_output_4[33] : TTL_output_33[3];
assign TTL_output_33[5] = (selected_5 == 1'b1 )? gpo_output_5[33] : TTL_output_33[4];
assign TTL_output_33[6] = (selected_6 == 1'b1 )? gpo_output_6[33] : TTL_output_33[5];
assign TTL_output_33[7] = (selected_7 == 1'b1 )? gpo_output_7[33] : TTL_output_33[6];
assign TTL_output_34[1] = (selected_1 == 1'b1 )? gpo_output_1[34] : TTL_output_34[0];
assign TTL_output_34[2] = (selected_2 == 1'b1 )? gpo_output_2[34] : TTL_output_34[1];
assign TTL_output_34[3] = (selected_3 == 1'b1 )? gpo_output_3[34] : TTL_output_34[2];
assign TTL_output_34[4] = (selected_4 == 1'b1 )? gpo_output_4[34] : TTL_output_34[3];
assign TTL_output_34[5] = (selected_5 == 1'b1 )? gpo_output_5[34] : TTL_output_34[4];
assign TTL_output_34[6] = (selected_6 == 1'b1 )? gpo_output_6[34] : TTL_output_34[5];
assign TTL_output_34[7] = (selected_7 == 1'b1 )? gpo_output_7[34] : TTL_output_34[6];
assign TTL_output_35[1] = (selected_1 == 1'b1 )? gpo_output_1[35] : TTL_output_35[0];
assign TTL_output_35[2] = (selected_2 == 1'b1 )? gpo_output_2[35] : TTL_output_35[1];
assign TTL_output_35[3] = (selected_3 == 1'b1 )? gpo_output_3[35] : TTL_output_35[2];
assign TTL_output_35[4] = (selected_4 == 1'b1 )? gpo_output_4[35] : TTL_output_35[3];
assign TTL_output_35[5] = (selected_5 == 1'b1 )? gpo_output_5[35] : TTL_output_35[4];
assign TTL_output_35[6] = (selected_6 == 1'b1 )? gpo_output_6[35] : TTL_output_35[5];
assign TTL_output_35[7] = (selected_7 == 1'b1 )? gpo_output_7[35] : TTL_output_35[6];
assign TTL_output_36[1] = (selected_1 == 1'b1 )? gpo_output_1[36] : TTL_output_36[0];
assign TTL_output_36[2] = (selected_2 == 1'b1 )? gpo_output_2[36] : TTL_output_36[1];
assign TTL_output_36[3] = (selected_3 == 1'b1 )? gpo_output_3[36] : TTL_output_36[2];
assign TTL_output_36[4] = (selected_4 == 1'b1 )? gpo_output_4[36] : TTL_output_36[3];
assign TTL_output_36[5] = (selected_5 == 1'b1 )? gpo_output_5[36] : TTL_output_36[4];
assign TTL_output_36[6] = (selected_6 == 1'b1 )? gpo_output_6[36] : TTL_output_36[5];
assign TTL_output_36[7] = (selected_7 == 1'b1 )? gpo_output_7[36] : TTL_output_36[6];
assign TTL_output_37[1] = (selected_1 == 1'b1 )? gpo_output_1[37] : TTL_output_37[0];
assign TTL_output_37[2] = (selected_2 == 1'b1 )? gpo_output_2[37] : TTL_output_37[1];
assign TTL_output_37[3] = (selected_3 == 1'b1 )? gpo_output_3[37] : TTL_output_37[2];
assign TTL_output_37[4] = (selected_4 == 1'b1 )? gpo_output_4[37] : TTL_output_37[3];
assign TTL_output_37[5] = (selected_5 == 1'b1 )? gpo_output_5[37] : TTL_output_37[4];
assign TTL_output_37[6] = (selected_6 == 1'b1 )? gpo_output_6[37] : TTL_output_37[5];
assign TTL_output_37[7] = (selected_7 == 1'b1 )? gpo_output_7[37] : TTL_output_37[6];
assign TTL_output_38[1] = (selected_1 == 1'b1 )? gpo_output_1[38] : TTL_output_38[0];
assign TTL_output_38[2] = (selected_2 == 1'b1 )? gpo_output_2[38] : TTL_output_38[1];
assign TTL_output_38[3] = (selected_3 == 1'b1 )? gpo_output_3[38] : TTL_output_38[2];
assign TTL_output_38[4] = (selected_4 == 1'b1 )? gpo_output_4[38] : TTL_output_38[3];
assign TTL_output_38[5] = (selected_5 == 1'b1 )? gpo_output_5[38] : TTL_output_38[4];
assign TTL_output_38[6] = (selected_6 == 1'b1 )? gpo_output_6[38] : TTL_output_38[5];
assign TTL_output_38[7] = (selected_7 == 1'b1 )? gpo_output_7[38] : TTL_output_38[6];
assign TTL_output_39[1] = (selected_1 == 1'b1 )? gpo_output_1[39] : TTL_output_39[0];
assign TTL_output_39[2] = (selected_2 == 1'b1 )? gpo_output_2[39] : TTL_output_39[1];
assign TTL_output_39[3] = (selected_3 == 1'b1 )? gpo_output_3[39] : TTL_output_39[2];
assign TTL_output_39[4] = (selected_4 == 1'b1 )? gpo_output_4[39] : TTL_output_39[3];
assign TTL_output_39[5] = (selected_5 == 1'b1 )? gpo_output_5[39] : TTL_output_39[4];
assign TTL_output_39[6] = (selected_6 == 1'b1 )? gpo_output_6[39] : TTL_output_39[5];
assign TTL_output_39[7] = (selected_7 == 1'b1 )? gpo_output_7[39] : TTL_output_39[6];
assign TTL_output_40[1] = (selected_1 == 1'b1 )? gpo_output_1[40] : TTL_output_40[0];
assign TTL_output_40[2] = (selected_2 == 1'b1 )? gpo_output_2[40] : TTL_output_40[1];
assign TTL_output_40[3] = (selected_3 == 1'b1 )? gpo_output_3[40] : TTL_output_40[2];
assign TTL_output_40[4] = (selected_4 == 1'b1 )? gpo_output_4[40] : TTL_output_40[3];
assign TTL_output_40[5] = (selected_5 == 1'b1 )? gpo_output_5[40] : TTL_output_40[4];
assign TTL_output_40[6] = (selected_6 == 1'b1 )? gpo_output_6[40] : TTL_output_40[5];
assign TTL_output_40[7] = (selected_7 == 1'b1 )? gpo_output_7[40] : TTL_output_40[6];
assign TTL_output_41[1] = (selected_1 == 1'b1 )? gpo_output_1[41] : TTL_output_41[0];
assign TTL_output_41[2] = (selected_2 == 1'b1 )? gpo_output_2[41] : TTL_output_41[1];
assign TTL_output_41[3] = (selected_3 == 1'b1 )? gpo_output_3[41] : TTL_output_41[2];
assign TTL_output_41[4] = (selected_4 == 1'b1 )? gpo_output_4[41] : TTL_output_41[3];
assign TTL_output_41[5] = (selected_5 == 1'b1 )? gpo_output_5[41] : TTL_output_41[4];
assign TTL_output_41[6] = (selected_6 == 1'b1 )? gpo_output_6[41] : TTL_output_41[5];
assign TTL_output_41[7] = (selected_7 == 1'b1 )? gpo_output_7[41] : TTL_output_41[6];
assign TTL_output_42[1] = (selected_1 == 1'b1 )? gpo_output_1[42] : TTL_output_42[0];
assign TTL_output_42[2] = (selected_2 == 1'b1 )? gpo_output_2[42] : TTL_output_42[1];
assign TTL_output_42[3] = (selected_3 == 1'b1 )? gpo_output_3[42] : TTL_output_42[2];
assign TTL_output_42[4] = (selected_4 == 1'b1 )? gpo_output_4[42] : TTL_output_42[3];
assign TTL_output_42[5] = (selected_5 == 1'b1 )? gpo_output_5[42] : TTL_output_42[4];
assign TTL_output_42[6] = (selected_6 == 1'b1 )? gpo_output_6[42] : TTL_output_42[5];
assign TTL_output_42[7] = (selected_7 == 1'b1 )? gpo_output_7[42] : TTL_output_42[6];
assign TTL_output_43[1] = (selected_1 == 1'b1 )? gpo_output_1[43] : TTL_output_43[0];
assign TTL_output_43[2] = (selected_2 == 1'b1 )? gpo_output_2[43] : TTL_output_43[1];
assign TTL_output_43[3] = (selected_3 == 1'b1 )? gpo_output_3[43] : TTL_output_43[2];
assign TTL_output_43[4] = (selected_4 == 1'b1 )? gpo_output_4[43] : TTL_output_43[3];
assign TTL_output_43[5] = (selected_5 == 1'b1 )? gpo_output_5[43] : TTL_output_43[4];
assign TTL_output_43[6] = (selected_6 == 1'b1 )? gpo_output_6[43] : TTL_output_43[5];
assign TTL_output_43[7] = (selected_7 == 1'b1 )? gpo_output_7[43] : TTL_output_43[6];
assign TTL_output_44[1] = (selected_1 == 1'b1 )? gpo_output_1[44] : TTL_output_44[0];
assign TTL_output_44[2] = (selected_2 == 1'b1 )? gpo_output_2[44] : TTL_output_44[1];
assign TTL_output_44[3] = (selected_3 == 1'b1 )? gpo_output_3[44] : TTL_output_44[2];
assign TTL_output_44[4] = (selected_4 == 1'b1 )? gpo_output_4[44] : TTL_output_44[3];
assign TTL_output_44[5] = (selected_5 == 1'b1 )? gpo_output_5[44] : TTL_output_44[4];
assign TTL_output_44[6] = (selected_6 == 1'b1 )? gpo_output_6[44] : TTL_output_44[5];
assign TTL_output_44[7] = (selected_7 == 1'b1 )? gpo_output_7[44] : TTL_output_44[6];
assign TTL_output_45[1] = (selected_1 == 1'b1 )? gpo_output_1[45] : TTL_output_45[0];
assign TTL_output_45[2] = (selected_2 == 1'b1 )? gpo_output_2[45] : TTL_output_45[1];
assign TTL_output_45[3] = (selected_3 == 1'b1 )? gpo_output_3[45] : TTL_output_45[2];
assign TTL_output_45[4] = (selected_4 == 1'b1 )? gpo_output_4[45] : TTL_output_45[3];
assign TTL_output_45[5] = (selected_5 == 1'b1 )? gpo_output_5[45] : TTL_output_45[4];
assign TTL_output_45[6] = (selected_6 == 1'b1 )? gpo_output_6[45] : TTL_output_45[5];
assign TTL_output_45[7] = (selected_7 == 1'b1 )? gpo_output_7[45] : TTL_output_45[6];
assign TTL_output_46[1] = (selected_1 == 1'b1 )? gpo_output_1[46] : TTL_output_46[0];
assign TTL_output_46[2] = (selected_2 == 1'b1 )? gpo_output_2[46] : TTL_output_46[1];
assign TTL_output_46[3] = (selected_3 == 1'b1 )? gpo_output_3[46] : TTL_output_46[2];
assign TTL_output_46[4] = (selected_4 == 1'b1 )? gpo_output_4[46] : TTL_output_46[3];
assign TTL_output_46[5] = (selected_5 == 1'b1 )? gpo_output_5[46] : TTL_output_46[4];
assign TTL_output_46[6] = (selected_6 == 1'b1 )? gpo_output_6[46] : TTL_output_46[5];
assign TTL_output_46[7] = (selected_7 == 1'b1 )? gpo_output_7[46] : TTL_output_46[6];
assign TTL_output_47[1] = (selected_1 == 1'b1 )? gpo_output_1[47] : TTL_output_47[0];
assign TTL_output_47[2] = (selected_2 == 1'b1 )? gpo_output_2[47] : TTL_output_47[1];
assign TTL_output_47[3] = (selected_3 == 1'b1 )? gpo_output_3[47] : TTL_output_47[2];
assign TTL_output_47[4] = (selected_4 == 1'b1 )? gpo_output_4[47] : TTL_output_47[3];
assign TTL_output_47[5] = (selected_5 == 1'b1 )? gpo_output_5[47] : TTL_output_47[4];
assign TTL_output_47[6] = (selected_6 == 1'b1 )? gpo_output_6[47] : TTL_output_47[5];
assign TTL_output_47[7] = (selected_7 == 1'b1 )? gpo_output_7[47] : TTL_output_47[6];
assign TTL_output_48[1] = (selected_1 == 1'b1 )? gpo_output_1[48] : TTL_output_48[0];
assign TTL_output_48[2] = (selected_2 == 1'b1 )? gpo_output_2[48] : TTL_output_48[1];
assign TTL_output_48[3] = (selected_3 == 1'b1 )? gpo_output_3[48] : TTL_output_48[2];
assign TTL_output_48[4] = (selected_4 == 1'b1 )? gpo_output_4[48] : TTL_output_48[3];
assign TTL_output_48[5] = (selected_5 == 1'b1 )? gpo_output_5[48] : TTL_output_48[4];
assign TTL_output_48[6] = (selected_6 == 1'b1 )? gpo_output_6[48] : TTL_output_48[5];
assign TTL_output_48[7] = (selected_7 == 1'b1 )? gpo_output_7[48] : TTL_output_48[6];
assign TTL_output_49[1] = (selected_1 == 1'b1 )? gpo_output_1[49] : TTL_output_49[0];
assign TTL_output_49[2] = (selected_2 == 1'b1 )? gpo_output_2[49] : TTL_output_49[1];
assign TTL_output_49[3] = (selected_3 == 1'b1 )? gpo_output_3[49] : TTL_output_49[2];
assign TTL_output_49[4] = (selected_4 == 1'b1 )? gpo_output_4[49] : TTL_output_49[3];
assign TTL_output_49[5] = (selected_5 == 1'b1 )? gpo_output_5[49] : TTL_output_49[4];
assign TTL_output_49[6] = (selected_6 == 1'b1 )? gpo_output_6[49] : TTL_output_49[5];
assign TTL_output_49[7] = (selected_7 == 1'b1 )? gpo_output_7[49] : TTL_output_49[6];
assign TTL_output_50[1] = (selected_1 == 1'b1 )? gpo_output_1[50] : TTL_output_50[0];
assign TTL_output_50[2] = (selected_2 == 1'b1 )? gpo_output_2[50] : TTL_output_50[1];
assign TTL_output_50[3] = (selected_3 == 1'b1 )? gpo_output_3[50] : TTL_output_50[2];
assign TTL_output_50[4] = (selected_4 == 1'b1 )? gpo_output_4[50] : TTL_output_50[3];
assign TTL_output_50[5] = (selected_5 == 1'b1 )? gpo_output_5[50] : TTL_output_50[4];
assign TTL_output_50[6] = (selected_6 == 1'b1 )? gpo_output_6[50] : TTL_output_50[5];
assign TTL_output_50[7] = (selected_7 == 1'b1 )? gpo_output_7[50] : TTL_output_50[6];
assign TTL_output_51[1] = (selected_1 == 1'b1 )? gpo_output_1[51] : TTL_output_51[0];
assign TTL_output_51[2] = (selected_2 == 1'b1 )? gpo_output_2[51] : TTL_output_51[1];
assign TTL_output_51[3] = (selected_3 == 1'b1 )? gpo_output_3[51] : TTL_output_51[2];
assign TTL_output_51[4] = (selected_4 == 1'b1 )? gpo_output_4[51] : TTL_output_51[3];
assign TTL_output_51[5] = (selected_5 == 1'b1 )? gpo_output_5[51] : TTL_output_51[4];
assign TTL_output_51[6] = (selected_6 == 1'b1 )? gpo_output_6[51] : TTL_output_51[5];
assign TTL_output_51[7] = (selected_7 == 1'b1 )? gpo_output_7[51] : TTL_output_51[6];
assign TTL_output_52[1] = (selected_1 == 1'b1 )? gpo_output_1[52] : TTL_output_52[0];
assign TTL_output_52[2] = (selected_2 == 1'b1 )? gpo_output_2[52] : TTL_output_52[1];
assign TTL_output_52[3] = (selected_3 == 1'b1 )? gpo_output_3[52] : TTL_output_52[2];
assign TTL_output_52[4] = (selected_4 == 1'b1 )? gpo_output_4[52] : TTL_output_52[3];
assign TTL_output_52[5] = (selected_5 == 1'b1 )? gpo_output_5[52] : TTL_output_52[4];
assign TTL_output_52[6] = (selected_6 == 1'b1 )? gpo_output_6[52] : TTL_output_52[5];
assign TTL_output_52[7] = (selected_7 == 1'b1 )? gpo_output_7[52] : TTL_output_52[6];
assign TTL_output_53[1] = (selected_1 == 1'b1 )? gpo_output_1[53] : TTL_output_53[0];
assign TTL_output_53[2] = (selected_2 == 1'b1 )? gpo_output_2[53] : TTL_output_53[1];
assign TTL_output_53[3] = (selected_3 == 1'b1 )? gpo_output_3[53] : TTL_output_53[2];
assign TTL_output_53[4] = (selected_4 == 1'b1 )? gpo_output_4[53] : TTL_output_53[3];
assign TTL_output_53[5] = (selected_5 == 1'b1 )? gpo_output_5[53] : TTL_output_53[4];
assign TTL_output_53[6] = (selected_6 == 1'b1 )? gpo_output_6[53] : TTL_output_53[5];
assign TTL_output_53[7] = (selected_7 == 1'b1 )? gpo_output_7[53] : TTL_output_53[6];
assign TTL_output_54[1] = (selected_1 == 1'b1 )? gpo_output_1[54] : TTL_output_54[0];
assign TTL_output_54[2] = (selected_2 == 1'b1 )? gpo_output_2[54] : TTL_output_54[1];
assign TTL_output_54[3] = (selected_3 == 1'b1 )? gpo_output_3[54] : TTL_output_54[2];
assign TTL_output_54[4] = (selected_4 == 1'b1 )? gpo_output_4[54] : TTL_output_54[3];
assign TTL_output_54[5] = (selected_5 == 1'b1 )? gpo_output_5[54] : TTL_output_54[4];
assign TTL_output_54[6] = (selected_6 == 1'b1 )? gpo_output_6[54] : TTL_output_54[5];
assign TTL_output_54[7] = (selected_7 == 1'b1 )? gpo_output_7[54] : TTL_output_54[6];
assign TTL_output_55[1] = (selected_1 == 1'b1 )? gpo_output_1[55] : TTL_output_55[0];
assign TTL_output_55[2] = (selected_2 == 1'b1 )? gpo_output_2[55] : TTL_output_55[1];
assign TTL_output_55[3] = (selected_3 == 1'b1 )? gpo_output_3[55] : TTL_output_55[2];
assign TTL_output_55[4] = (selected_4 == 1'b1 )? gpo_output_4[55] : TTL_output_55[3];
assign TTL_output_55[5] = (selected_5 == 1'b1 )? gpo_output_5[55] : TTL_output_55[4];
assign TTL_output_55[6] = (selected_6 == 1'b1 )? gpo_output_6[55] : TTL_output_55[5];
assign TTL_output_55[7] = (selected_7 == 1'b1 )? gpo_output_7[55] : TTL_output_55[6];
assign TTL_output_56[1] = (selected_1 == 1'b1 )? gpo_output_1[56] : TTL_output_56[0];
assign TTL_output_56[2] = (selected_2 == 1'b1 )? gpo_output_2[56] : TTL_output_56[1];
assign TTL_output_56[3] = (selected_3 == 1'b1 )? gpo_output_3[56] : TTL_output_56[2];
assign TTL_output_56[4] = (selected_4 == 1'b1 )? gpo_output_4[56] : TTL_output_56[3];
assign TTL_output_56[5] = (selected_5 == 1'b1 )? gpo_output_5[56] : TTL_output_56[4];
assign TTL_output_56[6] = (selected_6 == 1'b1 )? gpo_output_6[56] : TTL_output_56[5];
assign TTL_output_56[7] = (selected_7 == 1'b1 )? gpo_output_7[56] : TTL_output_56[6];
assign TTL_output_57[1] = (selected_1 == 1'b1 )? gpo_output_1[57] : TTL_output_57[0];
assign TTL_output_57[2] = (selected_2 == 1'b1 )? gpo_output_2[57] : TTL_output_57[1];
assign TTL_output_57[3] = (selected_3 == 1'b1 )? gpo_output_3[57] : TTL_output_57[2];
assign TTL_output_57[4] = (selected_4 == 1'b1 )? gpo_output_4[57] : TTL_output_57[3];
assign TTL_output_57[5] = (selected_5 == 1'b1 )? gpo_output_5[57] : TTL_output_57[4];
assign TTL_output_57[6] = (selected_6 == 1'b1 )? gpo_output_6[57] : TTL_output_57[5];
assign TTL_output_57[7] = (selected_7 == 1'b1 )? gpo_output_7[57] : TTL_output_57[6];
assign TTL_output_58[1] = (selected_1 == 1'b1 )? gpo_output_1[58] : TTL_output_58[0];
assign TTL_output_58[2] = (selected_2 == 1'b1 )? gpo_output_2[58] : TTL_output_58[1];
assign TTL_output_58[3] = (selected_3 == 1'b1 )? gpo_output_3[58] : TTL_output_58[2];
assign TTL_output_58[4] = (selected_4 == 1'b1 )? gpo_output_4[58] : TTL_output_58[3];
assign TTL_output_58[5] = (selected_5 == 1'b1 )? gpo_output_5[58] : TTL_output_58[4];
assign TTL_output_58[6] = (selected_6 == 1'b1 )? gpo_output_6[58] : TTL_output_58[5];
assign TTL_output_58[7] = (selected_7 == 1'b1 )? gpo_output_7[58] : TTL_output_58[6];
assign TTL_output_59[1] = (selected_1 == 1'b1 )? gpo_output_1[59] : TTL_output_59[0];
assign TTL_output_59[2] = (selected_2 == 1'b1 )? gpo_output_2[59] : TTL_output_59[1];
assign TTL_output_59[3] = (selected_3 == 1'b1 )? gpo_output_3[59] : TTL_output_59[2];
assign TTL_output_59[4] = (selected_4 == 1'b1 )? gpo_output_4[59] : TTL_output_59[3];
assign TTL_output_59[5] = (selected_5 == 1'b1 )? gpo_output_5[59] : TTL_output_59[4];
assign TTL_output_59[6] = (selected_6 == 1'b1 )? gpo_output_6[59] : TTL_output_59[5];
assign TTL_output_59[7] = (selected_7 == 1'b1 )? gpo_output_7[59] : TTL_output_59[6];
assign TTL_output_60[1] = (selected_1 == 1'b1 )? gpo_output_1[60] : TTL_output_60[0];
assign TTL_output_60[2] = (selected_2 == 1'b1 )? gpo_output_2[60] : TTL_output_60[1];
assign TTL_output_60[3] = (selected_3 == 1'b1 )? gpo_output_3[60] : TTL_output_60[2];
assign TTL_output_60[4] = (selected_4 == 1'b1 )? gpo_output_4[60] : TTL_output_60[3];
assign TTL_output_60[5] = (selected_5 == 1'b1 )? gpo_output_5[60] : TTL_output_60[4];
assign TTL_output_60[6] = (selected_6 == 1'b1 )? gpo_output_6[60] : TTL_output_60[5];
assign TTL_output_60[7] = (selected_7 == 1'b1 )? gpo_output_7[60] : TTL_output_60[6];
assign TTL_output_61[1] = (selected_1 == 1'b1 )? gpo_output_1[61] : TTL_output_61[0];
assign TTL_output_61[2] = (selected_2 == 1'b1 )? gpo_output_2[61] : TTL_output_61[1];
assign TTL_output_61[3] = (selected_3 == 1'b1 )? gpo_output_3[61] : TTL_output_61[2];
assign TTL_output_61[4] = (selected_4 == 1'b1 )? gpo_output_4[61] : TTL_output_61[3];
assign TTL_output_61[5] = (selected_5 == 1'b1 )? gpo_output_5[61] : TTL_output_61[4];
assign TTL_output_61[6] = (selected_6 == 1'b1 )? gpo_output_6[61] : TTL_output_61[5];
assign TTL_output_61[7] = (selected_7 == 1'b1 )? gpo_output_7[61] : TTL_output_61[6];
assign TTL_output_62[1] = (selected_1 == 1'b1 )? gpo_output_1[62] : TTL_output_62[0];
assign TTL_output_62[2] = (selected_2 == 1'b1 )? gpo_output_2[62] : TTL_output_62[1];
assign TTL_output_62[3] = (selected_3 == 1'b1 )? gpo_output_3[62] : TTL_output_62[2];
assign TTL_output_62[4] = (selected_4 == 1'b1 )? gpo_output_4[62] : TTL_output_62[3];
assign TTL_output_62[5] = (selected_5 == 1'b1 )? gpo_output_5[62] : TTL_output_62[4];
assign TTL_output_62[6] = (selected_6 == 1'b1 )? gpo_output_6[62] : TTL_output_62[5];
assign TTL_output_62[7] = (selected_7 == 1'b1 )? gpo_output_7[62] : TTL_output_62[6];
assign TTL_output_63[1] = (selected_1 == 1'b1 )? gpo_output_1[63] : TTL_output_63[0];
assign TTL_output_63[2] = (selected_2 == 1'b1 )? gpo_output_2[63] : TTL_output_63[1];
assign TTL_output_63[3] = (selected_3 == 1'b1 )? gpo_output_3[63] : TTL_output_63[2];
assign TTL_output_63[4] = (selected_4 == 1'b1 )? gpo_output_4[63] : TTL_output_63[3];
assign TTL_output_63[5] = (selected_5 == 1'b1 )? gpo_output_5[63] : TTL_output_63[4];
assign TTL_output_63[6] = (selected_6 == 1'b1 )? gpo_output_6[63] : TTL_output_63[5];
assign TTL_output_63[7] = (selected_7 == 1'b1 )? gpo_output_7[63] : TTL_output_63[6];

endmodule
