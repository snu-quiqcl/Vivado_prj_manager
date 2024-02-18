`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:53:46 04/24/2014 
// Design Name: 
// Module Name:    counter 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module EdgeCounter_Controller
#(
    parameter DATA_WIDTH = 16
)
(
    input wire clk,
    input wire input_sig,
    input wire reset,
    input wire [63:0] cmd_in,
    input wire [63:0] counter,
    input wire valid,
    output reg write,
    output wire [127:0] count_out
    );

parameter START_COUNT = 64'b1;
parameter STOP_COUNT = 64'b10;
parameter SAVE_COUNT = 64'b100;
parameter RESET_COUNT = 64'b1000;

initial measured_count <= 0;
wire inc_count;
reg [DATA_WIDTH-1:0] measured_count;
reg internal_reset;
reg count_en;

assign inc_count = input_sig & count_en;
assign count_out = 128'h0|measured_count|(counter << 64);

always @(posedge clk) begin
    if( reset == 1'b1) begin
        internal_reset <= 1'b1;
        count_en <= 1'b0;
        write <= 1'b0;
    end
    else begin
        internal_reset <= 1'b0;
        write <= 1'b0;
        if( cmd_in[0] == 1'b1 && valid == 1'b1) begin
            count_en <= 1'b1;
        end
        else if(cmd_in[1] == 1'b1 && valid == 1'b1) begin
            count_en <= 1'b0;
        end
        if( cmd_in[2] == 1'b1 && valid == 1'b1) begin
            write <= 1'b1;
        end
        if( cmd_in[3] == 1'b1 && valid == 1'b1) begin
            internal_reset <= 1'b1;
        end
    end
end

always @ (posedge inc_count, posedge internal_reset) begin
    if (internal_reset) measured_count <= 0;
    else measured_count <= measured_count + 1;
end

endmodule