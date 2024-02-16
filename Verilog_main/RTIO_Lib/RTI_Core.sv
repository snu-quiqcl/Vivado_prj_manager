`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/08/20 13:54:51
// Design Name: 
// Module Name: rti_core_prime
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


module RTI_Core
#(
    parameter FIFO_DEPTH = 10
)
(
    input wire wr_clk,
    input wire rd_clk,
    input wire reset,
    input wire flush,
    input wire write,
    input wire read,
    input wire [127:0] rti_in,
    output wire [127:0] rti_out,
    output wire [127:0] overflow_error_data,
    output wire overflow_error,
    output wire underflow_error,
    output wire full,
    output wire empty,
    output reg [FIFO_DEPTH - 1:0]data_num
    );
   
reg [127:0] overflow_error_data_buffer;
reg overflow_error_state;
reg underflow_error_state;

wire flush_fifo;
wire full_wire;
wire empty_wire;
wire [127:0] fifo_din;
wire [127:0] fifo_dout;
wire wr_en;
wire rd_en;
wire overflow_dummy_wire;
wire underflow_dummy_wire;
wire overflow_error_wire;
wire underflow_error_wire;

assign flush_fifo = flush || reset;
assign fifo_din[127:0] = rti_in[127:0];
assign rti_out[127:0] = fifo_dout[127:0];
assign wr_en = ~full_wire && write;
assign rd_en = ~empty_wire && read;
assign underflow_error_wire = read && empty;
assign overflow_error_wire = write && full;
assign underflow_error = underflow_error_state;
assign overflow_error = overflow_error_state;
assign overflow_error_data[127:0] = overflow_error_data_buffer[127:0];
assign full = full_wire;
assign empty = empty_wire;
    
fifo_generator_0 RTI_Core_FIFO(
    .wr_clk(wr_clk),
    .rd_clk(rd_clk),
    .srst(flush_fifo),
    .din(fifo_din),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .dout(fifo_dout),
    .prog_full(full_wire),
    .overflow(overflow_dummy_wire),
    .empty(empty_wire),
    .underflow(underflow_dummy_wire)
);

always @(posedge wr_clk) begin
    if( reset | flush_fifo ) begin
        overflow_error_data_buffer[127:0] <= 128'h0;
        overflow_error_state <= 1'b0;
        underflow_error_state <= 1'b0;
        data_num <= {FIFO_DEPTH{1'b0}};
    end
    else begin
        overflow_error_state <= overflow_error_wire;
        underflow_error_state <= underflow_error_wire;
        if( overflow_error_wire ) begin
            overflow_error_data_buffer[127:0] <= rti_in[127:0];
        end

        if( wr_en == 1'b1 && rd_en == 1'b0 ) begin
            data_num <= data_num + 1;
        end
        else if( wr_en == 1'b0 && rd_en == 1'b1 ) begin
            data_num <= data_num - 1;
        end
        else if( wr_en == 1'b1 && rd_en == 1'b1 ) begin
            data_num <= data_num;
        end
    end
end
    
endmodule
