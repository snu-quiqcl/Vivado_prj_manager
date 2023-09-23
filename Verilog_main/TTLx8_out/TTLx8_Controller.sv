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
    output wire output_pulse
);

//////////////////////////////////////////////////////////////////////////////////  
// GPO_Core
//////////////////////////////////////////////////////////////////////////////////
wire [127:0] gpo_out;
wire selected;

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
    .IS_RST_INVERTED(1'b1),
    .ODDR_MODE("TRUE"),
    .SIM_DEVICE("ULTRASCALE_PLUS")
) oserdes3_output_0 (
    .CLK(clk_x4),
    .CLKDIV(clk),
    .D(input_pulse),
    .OQ(output_pulse),
    .RST(resetn),
    .T(1'b0)
);

//////////////////////////////////////////////////////////////////////////////////  
// TTL
//////////////////////////////////////////////////////////////////////////////////
reg last_input_pulse;
reg [7:0] input_pulse_buffer;

always @(posedge clk) begin
    if( resetn == 1'b1 ) begin
        last_input_pulse <= 1'b0;
    end

    else begin
        if( selected == 1'b1 ) begin
            input_pulse_buffer[7:0] <= gpo_out[7:0];
            last_input_pulse <= gpo_out[7];
        end
        else begin
            input_pulse_buffer[7:0] <= {8{last_input_pulse}};
        end
    end
end

endmodule
