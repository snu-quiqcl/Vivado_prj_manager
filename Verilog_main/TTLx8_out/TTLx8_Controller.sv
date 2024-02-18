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


module TTLx8_Controller
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
    input wire[63:0] override_value,
    input wire counter_matched,
    input wire [127:0] gpo_in,
    input wire busy,
    output wire [127:0] error_data,
    output wire overrided,
    output wire busy_error,

    //////////////////////////////////////////////////////////////////////////////////
    // Port for TTL
    //////////////////////////////////////////////////////////////////////////////////
    input wire clk_x4,
    output wire output_pulse_0_p,
    output wire output_pulse_0_n,
    output wire output_pulse_1_p,
    output wire output_pulse_1_n,
    output wire output_pulse_2_p,
    output wire output_pulse_2_n,
    output wire output_pulse_3_p,
    output wire output_pulse_3_n,
    output wire output_pulse_4_p,
    output wire output_pulse_4_n,
    output wire output_pulse_5_p,
    output wire output_pulse_5_n,
    output wire output_pulse_6_p,
    output wire output_pulse_6_n,
    output wire output_pulse_7_p,
    output wire output_pulse_7_n
);

//////////////////////////////////////////////////////////////////////////////////  
// GPO_Core
//////////////////////////////////////////////////////////////////////////////////
wire [127:0] gpo_out;
wire selected;
wire output_pulse_0;
wire output_pulse_1;
wire output_pulse_2;
wire output_pulse_3;
wire output_pulse_4;
wire output_pulse_5;
wire output_pulse_6;
wire output_pulse_7;

GPO_Core #(
    .DEST_VAL(DEST_VAL),
    .CHANNEL_LENGTH(CHANNEL_LENGTH)
)
GPO_Core0(
    .clk(clk),
    .reset(reset),
    .override_en(override_en),
    .selected_en(selected_en),
    .override_value(override_value),
    .counter_matched(counter_matched),
    .gpo_in(gpo_in),
    .busy(busy),
    .selected(selected),
    .error_data(error_data),
    .overrided(overrided),
    .busy_error(busy_error),
    .gpo_out(gpo_out)
);

OSERDESE3 #(
    .DATA_WIDTH(8),
    .INIT(1'b0),
    .IS_CLKDIV_INVERTED(1'b0),
    .IS_CLK_INVERTED(1'b0),
    .IS_RST_INVERTED(1'b0),
    .SIM_DEVICE("ULTRASCALE_PLUS")
) oserdes3_output_0 (
    .CLK(clk_x4),
    .CLKDIV(clk),
    .D(input_pulse_buffer_0[7:0]),
    .OQ(output_pulse_0),
    .RST(reset),
    .T(1'b0)
);

OBUFDS #(
    .IOSTANDARD("LVDS")
) lvds_output_0(
    .I(output_pulse_0),
    .O(output_pulse_0_p),
    .OB(output_pulse_0_n)
);
OSERDESE3 #(
    .DATA_WIDTH(8),
    .INIT(1'b0),
    .IS_CLKDIV_INVERTED(1'b0),
    .IS_CLK_INVERTED(1'b0),
    .IS_RST_INVERTED(1'b0),
    .SIM_DEVICE("ULTRASCALE_PLUS")
) oserdes3_output_1 (
    .CLK(clk_x4),
    .CLKDIV(clk),
    .D(input_pulse_buffer_1[7:0]),
    .OQ(output_pulse_1),
    .RST(reset),
    .T(1'b0)
);

OBUFDS #(
    .IOSTANDARD("LVDS")
) lvds_output_1(
    .I(output_pulse_1),
    .O(output_pulse_1_p),
    .OB(output_pulse_1_n)
);
OSERDESE3 #(
    .DATA_WIDTH(8),
    .INIT(1'b0),
    .IS_CLKDIV_INVERTED(1'b0),
    .IS_CLK_INVERTED(1'b0),
    .IS_RST_INVERTED(1'b0),
    .SIM_DEVICE("ULTRASCALE_PLUS")
) oserdes3_output_2 (
    .CLK(clk_x4),
    .CLKDIV(clk),
    .D(input_pulse_buffer_2[7:0]),
    .OQ(output_pulse_2),
    .RST(reset),
    .T(1'b0)
);

OBUFDS #(
    .IOSTANDARD("LVDS")
) lvds_output_2(
    .I(output_pulse_2),
    .O(output_pulse_2_p),
    .OB(output_pulse_2_n)
);
OSERDESE3 #(
    .DATA_WIDTH(8),
    .INIT(1'b0),
    .IS_CLKDIV_INVERTED(1'b0),
    .IS_CLK_INVERTED(1'b0),
    .IS_RST_INVERTED(1'b0),
    .SIM_DEVICE("ULTRASCALE_PLUS")
) oserdes3_output_3 (
    .CLK(clk_x4),
    .CLKDIV(clk),
    .D(input_pulse_buffer_3[7:0]),
    .OQ(output_pulse_3),
    .RST(reset),
    .T(1'b0)
);

OBUFDS #(
    .IOSTANDARD("LVDS")
) lvds_output_3(
    .I(output_pulse_3),
    .O(output_pulse_3_p),
    .OB(output_pulse_3_n)
);
OSERDESE3 #(
    .DATA_WIDTH(8),
    .INIT(1'b0),
    .IS_CLKDIV_INVERTED(1'b0),
    .IS_CLK_INVERTED(1'b0),
    .IS_RST_INVERTED(1'b0),
    .SIM_DEVICE("ULTRASCALE_PLUS")
) oserdes3_output_4 (
    .CLK(clk_x4),
    .CLKDIV(clk),
    .D(input_pulse_buffer_4[7:0]),
    .OQ(output_pulse_4),
    .RST(reset),
    .T(1'b0)
);

OBUFDS #(
    .IOSTANDARD("LVDS")
) lvds_output_4(
    .I(output_pulse_4),
    .O(output_pulse_4_p),
    .OB(output_pulse_4_n)
);
OSERDESE3 #(
    .DATA_WIDTH(8),
    .INIT(1'b0),
    .IS_CLKDIV_INVERTED(1'b0),
    .IS_CLK_INVERTED(1'b0),
    .IS_RST_INVERTED(1'b0),
    .SIM_DEVICE("ULTRASCALE_PLUS")
) oserdes3_output_5 (
    .CLK(clk_x4),
    .CLKDIV(clk),
    .D(input_pulse_buffer_5[7:0]),
    .OQ(output_pulse_5),
    .RST(reset),
    .T(1'b0)
);

OBUFDS #(
    .IOSTANDARD("LVDS")
) lvds_output_5(
    .I(output_pulse_5),
    .O(output_pulse_5_p),
    .OB(output_pulse_5_n)
);
OSERDESE3 #(
    .DATA_WIDTH(8),
    .INIT(1'b0),
    .IS_CLKDIV_INVERTED(1'b0),
    .IS_CLK_INVERTED(1'b0),
    .IS_RST_INVERTED(1'b0),
    .SIM_DEVICE("ULTRASCALE_PLUS")
) oserdes3_output_6 (
    .CLK(clk_x4),
    .CLKDIV(clk),
    .D(input_pulse_buffer_6[7:0]),
    .OQ(output_pulse_6),
    .RST(reset),
    .T(1'b0)
);

OBUFDS #(
    .IOSTANDARD("LVDS")
) lvds_output_6(
    .I(output_pulse_6),
    .O(output_pulse_6_p),
    .OB(output_pulse_6_n)
);
OSERDESE3 #(
    .DATA_WIDTH(8),
    .INIT(1'b0),
    .IS_CLKDIV_INVERTED(1'b0),
    .IS_CLK_INVERTED(1'b0),
    .IS_RST_INVERTED(1'b0),
    .SIM_DEVICE("ULTRASCALE_PLUS")
) oserdes3_output_7 (
    .CLK(clk_x4),
    .CLKDIV(clk),
    .D(input_pulse_buffer_7[7:0]),
    .OQ(output_pulse_7),
    .RST(reset),
    .T(1'b0)
);

OBUFDS #(
    .IOSTANDARD("LVDS")
) lvds_output_7(
    .I(output_pulse_7),
    .O(output_pulse_7_p),
    .OB(output_pulse_7_n)
);


//////////////////////////////////////////////////////////////////////////////////  
// TTL
//////////////////////////////////////////////////////////////////////////////////
reg [7:0] last_input_pulse;
reg [7:0] input_pulse_buffer_0;
reg [7:0] input_pulse_buffer_1;
reg [7:0] input_pulse_buffer_2;
reg [7:0] input_pulse_buffer_3;
reg [7:0] input_pulse_buffer_4;
reg [7:0] input_pulse_buffer_5;
reg [7:0] input_pulse_buffer_6;
reg [7:0] input_pulse_buffer_7;

always @(posedge clk) begin
    if( reset == 1'b1 ) begin
        last_input_pulse[7:0] <= 8'b0;
    end

    else begin
        if( selected == 1'b1 ) begin
            input_pulse_buffer_0[7:0] <= gpo_out[7:0];
            input_pulse_buffer_1[7:0] <= gpo_out[15:8];
            input_pulse_buffer_2[7:0] <= gpo_out[23:16];
            input_pulse_buffer_3[7:0] <= gpo_out[31:24];
            input_pulse_buffer_4[7:0] <= gpo_out[39:32];
            input_pulse_buffer_5[7:0] <= gpo_out[47:40];
            input_pulse_buffer_6[7:0] <= gpo_out[55:48];
            input_pulse_buffer_7[7:0] <= gpo_out[63:56];
            last_input_pulse[0] <= gpo_out[7];
            last_input_pulse[1] <= gpo_out[15];
            last_input_pulse[2] <= gpo_out[23];
            last_input_pulse[3] <= gpo_out[31];
            last_input_pulse[4] <= gpo_out[39];
            last_input_pulse[5] <= gpo_out[47];
            last_input_pulse[6] <= gpo_out[55];
            last_input_pulse[7] <= gpo_out[63];
        end
        else begin
            input_pulse_buffer_0[7:0] <= {8{last_input_pulse[0]}};
            input_pulse_buffer_1[7:0] <= {8{last_input_pulse[1]}};
            input_pulse_buffer_2[7:0] <= {8{last_input_pulse[2]}};
            input_pulse_buffer_3[7:0] <= {8{last_input_pulse[3]}};
            input_pulse_buffer_4[7:0] <= {8{last_input_pulse[4]}};
            input_pulse_buffer_5[7:0] <= {8{last_input_pulse[5]}};
            input_pulse_buffer_6[7:0] <= {8{last_input_pulse[6]}};
            input_pulse_buffer_7[7:0] <= {8{last_input_pulse[7]}};
        end
    end
end

endmodule