`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/08/20 10:52:18
// Design Name: 
// Module Name: Timestamp_Counter
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


module Timestamp_Counter(
    input wire clk,
    input wire reset,
    input wire start,
    input wire [63:0] counter_offset,
    input wire offset_en,
    output wire [63:0] counter
    );
reg [63:0] counter_reg;
reg start_buffer1;
reg start_buffer2;
reg offset_en_buffer1;
reg offset_en_buffer2;

assign counter = counter_reg;

always @(posedge clk) begin
    // To accomodate clock domain crossing, flip flop buffer is used
    {offset_en_buffer2, offset_en_buffer1} <= {offset_en_buffer1, offset_en};
    {start_buffer2, start_buffer1} <= {start_buffer1, start};
    if( reset ) begin
        counter_reg[63:0] <= 64'h0;
    end
    
    else if(offset_en_buffer2) begin
        counter_reg[63:0] <= counter_offset[63:0];
    end
    
    else if(start_buffer2) begin
        counter_reg[63:0] <= counter_reg[63:0] + 64'h1;
    end
end
endmodule