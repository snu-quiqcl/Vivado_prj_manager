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
    output wire output_pulse_0,
    output wire output_pulse_1,
    output wire output_pulse_2,
    output wire output_pulse_3,
    output wire output_pulse_4,
    output wire output_pulse_5,
    output wire output_pulse_6,
    output wire output_pulse_7
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
reg [7:0] last_input_pulse;

assign output_pulse_0 = last_input_pulse[0];
assign output_pulse_1 = last_input_pulse[1];
assign output_pulse_2 = last_input_pulse[2];
assign output_pulse_3 = last_input_pulse[3];
assign output_pulse_4 = last_input_pulse[4];
assign output_pulse_5 = last_input_pulse[5];
assign output_pulse_6 = last_input_pulse[6];
assign output_pulse_7 = last_input_pulse[7];

always @(posedge clk) begin
    if( reset == 1'b1 ) begin
        last_input_pulse[7:0] <= {8{1'b0}};
    end

    else begin
        if( selected == 1'b1 ) begin
            last_input_pulse[7:0] <= gpo_out[7:0];
        end
    end
end

endmodule
