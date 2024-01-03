`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/09 20:00:35
// Design Name: 
// Module Name: TTL_output
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


module TTL_Controller
#(
    parameter DEST_VAL = 16'h0,
    parameter CHANNEL_LENGTH = 12,
    parameter OUTPUT_NUM = 8
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
    output wire [OUTPUT_NUM - 1:0] output_pulse
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

//////////////////////////////////////////////////////////////////////////////////  
// TTL
//////////////////////////////////////////////////////////////////////////////////
reg [OUTPUT_NUM - 1:0] last_input_pulse;

always @(posedge clk) begin
    if( reset == 1'b1 ) begin
        last_input_pulse[OUTPUT_NUM-1:0] <= {OUTPUT_NUM{1'b0}};
    end

    else begin
        if( selected == 1'b1 ) begin
            last_input_pulse[OUTPUT_NUM - 1:0] <= gpo_out[OUTPUT_NUM - 1:0];
        end
    end
end

endmodule
