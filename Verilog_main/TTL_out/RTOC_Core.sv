`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/08/19 14:50:13
// Design Name: 
// Module Name: rto_core_prime
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


module RTOC_Core
#(
    parameter THRESHOLD                     = 1000,
    parameter DEPTH                         = 10, //data number = 1024
    parameter DATA_LEN                      = 1
)
(
    input wire clk,
    input wire auto_start,
    input wire reset,
    input wire flush,
    input wire write,
    input wire [127:0] fifo_din,
    input wire [63:0] counter,
    output wire counter_matched,
    output wire [127:0] rto_out,
    output wire [127:0] timestamp_error_data,
    output wire [127:0] overflow_error_data,
    output wire timestamp_error,
    output wire overflow_error,
    output wire full,
    output wire empty
    );

reg counter_match;
reg [64 + DATA_LEN - 1:0] fifo_output;
reg [127:0] overflow_error_data_buffer;
reg [127:0] timestamp_error_data_buffer;
reg overflow_error_state;
reg timestamp_error_state;

wire flush_fifo;
wire wr_en;
wire write_en;;
wire rd_en;
wire overflow_error_wire;
wire timestamp_error_wire;
wire timestamp_match;
wire[64 + DATA_LEN - 1:0] fifo_dout;
wire full_wire;
wire empty_wire;
wire overflow_dummy_wire;
wire underflow_dummy_wire;
wire timestamp_match_not_empty;
wire fifo_output_en;

assign flush_fifo = flush || reset;
assign write_en = write;
assign timestamp_match = ( fifo_dout[64 + DATA_LEN - 1:DATA_LEN] == counter[63:0] );
assign timestamp_match_not_empty = ( ~empty_wire && timestamp_match && auto_start );
assign timestamp_error_wire = (counter[63:0] > fifo_dout[64 + DATA_LEN - 1:DATA_LEN]) && auto_start && ~empty_wire;
assign rd_en = timestamp_error_wire || timestamp_match_not_empty;
assign wr_en = write_en && ~full_wire;
assign overflow_error_wire = full_wire && write_en;
assign fifo_output_en = ~timestamp_error_wire && timestamp_match_not_empty;
assign rto_out[127:0] = {fifo_output[64 + DATA_LEN -1:DATA_LEN],{(64-DATA_LEN){1'b0}},fifo_output[DATA_LEN-1:0]};
assign overflow_error = overflow_error_state;
assign timestamp_error = timestamp_error_state;
assign empty = empty_wire;
assign full = full_wire;
assign overflow_error_data[127:0] = overflow_error_data_buffer[127:0];
assign timestamp_error_data[127:0] = timestamp_error_data_buffer[127:0];
assign counter_matched = counter_match;

//////////////////////////////////////////////////////////////////////////////////
// Depth 8192, full threshold 8100 FIFO.
//////////////////////////////////////////////////////////////////////////////////


rtoc_fifo_generator_0 RTOC_Core_FIFO0(
    .clk(clk),
    .srst(flush_fifo),  // rst -> srst in Vivado 2020.2
    .din({fifo_din[127:64], fifo_din[DATA_LEN - 1 :0]}),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .dout(fifo_dout),
    .prog_full(full_wire),  // full -> prog_full to deal with full delay signal
    .overflow(overflow_dummy_wire),
    .empty(empty_wire),
    .underflow(underflow_dummy_wire)
);

always @(posedge clk) begin
    if( reset ) begin
        counter_match                               <= 1'b0;
        overflow_error_state                        <= 1'b0;
        timestamp_error_state                       <= 1'b0;
        fifo_output[64 + DATA_LEN - 1:0]            <= {(64+DATA_LEN){1'b0}};
        overflow_error_data_buffer[64 + DATA_LEN - 1:0]<= {(64+DATA_LEN){1'b0}};
        timestamp_error_data_buffer[64 + DATA_LEN - 1:0]<= {(64+DATA_LEN){1'b0}};
        counter_match                               <= 1'b0;
    end
    else begin
        counter_match                               <= timestamp_match_not_empty;
        overflow_error_state                        <= overflow_error_wire;
        timestamp_error_state                       <= timestamp_error_wire;
        if( fifo_output_en ) begin
            fifo_output[64 + DATA_LEN - 1:0]        <= fifo_dout;
            counter_match                           <= 1'b1;
        end
        
        else begin
            counter_match                           <= 1'b0;
        end
        
        if( overflow_error_wire ) begin
            overflow_error_data_buffer[127:0]       <= {fifo_din[64 + DATA_LEN - 1:DATA_LEN], {(64-DATA_LEN){1'b0}}, fifo_din[DATA_LEN-1:0]};
        end
        
        if( timestamp_error_wire ) begin
            timestamp_error_data_buffer[127:0]      <= {fifo_din[64 + DATA_LEN - 1:DATA_LEN], {(64-DATA_LEN){1'b0}}, fifo_din[DATA_LEN-1:0]};
        end
    end
end

endmodule
