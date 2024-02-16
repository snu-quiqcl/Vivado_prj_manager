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


module RTOB_Core
#(
    parameter THRESHOLD = 1000,
    parameter DEPTH     = 1024, //data number = 1024
    parameter ADDR_LEN  = 10,
    parameter DATA_LEN  = 8
)
(
    input wire wr_clk,
    input wire rd_clk,
    input wire auto_start,          // rd_clk domain
    input wire reset,               // wr_clk domain
    input wire flush,               // wr_clk domain
    input wire write,               // wr_clk domain
    input wire [127:0] fifo_din,    // wr_clk domain
    input wire [63:0] counter,      // rd_clk domain
    output wire counter_matched,    // rd_clk domain
    output wire [127:0] rto_out,    // rd_clk domain
    output wire [127:0] timestamp_error_data,
    output wire [127:0] overflow_error_data,
    output wire timestamp_error,
    output wire overflow_error,
    output wire full,               // wr_clk domain
    output wire empty               // wr_clk domain
    );

reg counter_match;
reg [64 + DATA_LEN -1:0] fifo_output;
reg [127:0] overflow_error_data_buffer;
reg [127:0] timestamp_error_data_buffer;
reg overflow_error_state;
reg timestamp_error_state;
reg is_first_input;

wire flush_fifo;
wire wr_en;
wire write_en;;
wire rd_en;
wire overflow_error_wire;
wire timestamp_error_wire;
wire timestamp_match;
wire[64 + DATA_LEN -1:0] fifo_dout;
wire full_wire;
wire empty_wire;
wire overflow_dummy_wire;
wire underflow_dummy_wire;
wire timestamp_match_not_empty;
wire fifo_output_en;
wire new_bram_comp;
wire new_timestamp_comp;
wire [ADDR_LEN - 1:0] input_top_wire;

assign flush_fifo                               = flush || reset;
assign write_en                                 = write;
assign timestamp_match                          = ( fifo_dout[64 + DATA_LEN - 1:DATA_LEN] == counter[63:0] );
assign timestamp_match_not_empty                = ( ~empty_wire && timestamp_match && auto_start );
assign timestamp_error_wire                     = (counter[63:0] > fifo_dout[64 + DATA_LEN - 1:DATA_LEN]) && auto_start && ~empty_wire;
assign rd_en                                    = timestamp_error_wire || timestamp_match_not_empty;
assign wr_en                                    = write_en && ~full_wire;
assign overflow_error_wire                      = full_wire && write_en;
assign fifo_output_en                           = ~timestamp_error_wire && timestamp_match_not_empty;
assign rto_out[127:0]                           = {fifo_output[64 + DATA_LEN - 1:DATA_LEN],{(64-DATA_LEN){1'b0}}, fifo_output[DATA_LEN - 1:0]};
assign overflow_error                           = overflow_error_state;
assign timestamp_error                          = timestamp_error_state;
assign empty                                    = empty_wire;
assign full                                     = full_wire;
assign overflow_error_data[127:0]               = overflow_error_data_buffer[127:0];
assign timestamp_error_data[127:0]              = timestamp_error_data_buffer[127:0];
assign counter_matched                          = counter_match;
assign new_bram_comp                            = ( ( last_input_timestamp != fifo_din[127:64] ) || ( is_first_input != 1'b1 ) ) && wr_en;
assign input_top_wire                           = (new_bram_comp == 1'b1 )? (input_top + 1):input_top;

//////////////////////////////////////////////////////////////////////////////////
// Depth 1024, full threshold 1000 FIFO.
//////////////////////////////////////////////////////////////////////////////////
reg [ADDR_LEN - 1:0] input_top;
reg [ADDR_LEN - 1:0] output_top;
reg [63:0] last_input_timestamp;

rtob_fifo_generator_1 RTOB_Core_timestamp_FIFO0(
    .wr_clk(wr_clk),
    .rd_clk(rd_clk),
    .srst(flush_fifo),  // rst -> srst in Vivado 2020.2
    .din(fifo_din[127:64]),
    .wr_en(new_bram_comp),
    .rd_en(rd_en),
    .dout(fifo_dout[64 + DATA_LEN - 1:DATA_LEN]),
    .prog_full(full_wire),  // full -> prog_full to deal with full delay signal
    .overflow(overflow_dummy_wire),
    .empty(empty_wire),
    .underflow(underflow_dummy_wire)
);

adj_fifo
#(
    .DEPTH(DEPTH),
    .THRESHOLD(THRESHOLD),
    .DATA_LEN(DATA_LEN),
    .ADDR_LEN(ADDR_LEN)
)
RTOB_Core_data_FIFO0
(
    .wr_clk(wr_clk),
    .rd_clk(rd_clk),
    .rst(flush_fifo),
    .wr_en(wr_en),
    .addr_in({10'h0,input_top_wire}),
    .addr_out({10'h0,output_top}),
    .din(fifo_din[DATA_LEN - 1:0]),
    .dout(fifo_dout[DATA_LEN - 1:0])
);

always @(posedge rd_clk) begin
    if( flush_fifo ) begin
        counter_match                           <= 1'b0;
        overflow_error_state                    <= 1'b0;
        timestamp_error_state                   <= 1'b0;
        fifo_output[64 + DATA_LEN -1:0]         <= {(DATA_LEN + 64){1'h0}};
        overflow_error_data_buffer[127:0]       <= 128'h0;
        timestamp_error_data_buffer[127:0]      <= 128'h0;
        counter_match                           <= 1'b0;
        input_top                               <= {ADDR_LEN{1'h0}};
        output_top                              <= {{(ADDR_LEN-1){1'b0}},1'b1};
        last_input_timestamp                    <= 64'h0;
        is_first_input                          <= 1'b0;
    end
    else begin
        counter_match                           <= timestamp_match_not_empty;
        overflow_error_state                    <= overflow_error_wire;
        timestamp_error_state                   <= timestamp_error_wire;
        if( new_bram_comp ) begin
            input_top                           <= input_top + 1;
            last_input_timestamp                <= fifo_din[127:64];
            is_first_input                      <= 1'b1;
        end

        if( rd_en ) begin
            output_top                          <= output_top + 1;
        end

        if( fifo_output_en ) begin
            fifo_output[64 + DATA_LEN -1:0]     <= fifo_dout[64 + DATA_LEN - 1:0];
            counter_match                       <= 1'b1;
        end
        
        else begin
            counter_match                       <= 1'b0;
        end
        
        if( overflow_error_wire ) begin
            overflow_error_data_buffer[127:0]   <= fifo_din[127:0];
        end
        
        if( timestamp_error_wire ) begin
            timestamp_error_data_buffer[127:0]  <= {fifo_dout[64 + DATA_LEN - 1:DATA_LEN],{(64 - DATA_LEN){1'h0}},fifo_dout[DATA_LEN - 1:0]};
        end
    end
end

endmodule
