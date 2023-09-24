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
    parameter THRESHOLD = 1000
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
    output wire [71:0] rto_out,
    output wire [127:0] timestamp_error_data,
    output wire [127:0] overflow_error_data,
    output wire timestamp_error,
    output wire overflow_error,
    output wire full,
    output wire empty
    );

reg counter_match;
reg [71:0] fifo_output;
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
wire[71:0] fifo_dout;
wire full_wire;
wire empty_wire;
wire overflow_dummy_wire;
wire underflow_dummy_wire;
wire timestamp_match_not_empty;
wire fifo_output_en;
wire new_bram_comp;

assign flush_fifo                               = flush || reset;
assign write_en                                 = write;
assign timestamp_match                          = ( fifo_dout[71:8] == counter[63:0] );
assign timestamp_match_not_empty                = ( ~empty_wire && timestamp_match && auto_start );
assign timestamp_error_wire                     = (counter[63:0] > fifo_dout[71:8]) && auto_start && ~empty_wire;
assign rd_en                                    = timestamp_error_wire || timestamp_match_not_empty;
assign wr_en                                    = write_en && ~full_wire;
assign overflow_error_wire                      = full_wire && write_en;
assign fifo_output_en                           = ~timestamp_error_wire && timestamp_match_not_empty;
assign rto_out[71:0]                            = fifo_output[71:0];
assign overflow_error                           = overflow_error_state;
assign timestamp_error                          = timestamp_error_state;
assign empty                                    = empty_wire;
assign full                                     = full_wire;
assign overflow_error_data[127:0]               = overflow_error_data_buffer[127:0];
assign timestamp_error_data[127:0]              = timestamp_error_data_buffer[127:0];
assign counter_matched                          = counter_match;
assign full_wire                                = total_num > THRESHOLD;
assign empty_wire                               = (total_num == 10'h0);
assign new_bram_comp                            = (last_input_timestamp != fifo_din[127:64]) && wr_en;

//////////////////////////////////////////////////////////////////////////////////
// Depth 1024, full threshold 1000 FIFO.
//////////////////////////////////////////////////////////////////////////////////
reg [9:0] input_top;
reg [9:0] output_top;
reg [63:0] last_input_timestamp;
reg [9:0] total_num;

adj_fifo_generator_0 RTOB_Core_timestamp_FIFO0(
    .clk(clk),
    .srst(flush_fifo),  // rst -> srst in Vivado 2020.2
    .din(fifo_din[127:64]),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .dout(fifo_dout[71:8]),
    .prog_full(full_wire),  // full -> prog_full to deal with full delay signal
    .overflow(overflow_dummy_wire),
    .empty(empty_wire),
    .underflow(underflow_dummy_wire)
);

adj_fifo RTOB_Core_data_FIFO0
(
    .clk(clk),
    .rst(flush_fifo),
    .wr_en(wr_en),
    .addr_in(input_top),
    .addr_out(output_top),
    .din(fifo_din[7:0]),
    .dout(fifo_dout[7:0])
);

always @(posedge clk) begin
    if( reset ) begin
        counter_match                           <= 1'b0;
        overflow_error_state                    <= 1'b0;
        timestamp_error_state                   <= 1'b0;
        fifo_output[71:0]                       <= 72'h0;
        overflow_error_data_buffer[127:0]       <= 128'h0;
        timestamp_error_data_buffer[127:0]      <= 128'h0;
        counter_match                           <= 1'b0;
        input_top                               <= 10'h0;
        output_top                              <= 10'h0;
        last_input_timestamp                    <= 64'h0;
        total_num                               <= 10'h0;
    end
    else begin
        counter_match                           <= timestamp_match_not_empty;
        overflow_error_state                    <= overflow_error_wire;
        timestamp_error_state                   <= timestamp_error_wire;
        if( wr_en ) begin
            last_input_timestamp                <= fifo_din[127:64];
        end

        if( new_bram_comp ) begin
            input_top                           <= input_top + 10'h1;
        end

        if( rd_en ) begin
            output_top                          <= output_top + 10'h1;
        end

        if( fifo_output_en ) begin
            fifo_output[127:0]                  <= fifo_dout[127:0];
            counter_match                       <= 1'b1;
        end
        
        else begin
            counter_match                       <= 1'b0;
        end
        
        if( overflow_error_wire ) begin
            overflow_error_data_buffer[127:0]   <= fifo_din[127:0];
        end
        
        if( timestamp_error_wire ) begin
            timestamp_error_data_buffer[127:0]  <= {fifo_dout[71:8],56'h0,fifo_dout[7:0]};
        end

        case( {new_bram_comp, rd_en} )
            2'b00: begin
                total_num                       <= total_num;
            end

            2'b10: begin
                total_num                       <= total_num + 10'h1;
            end

            2'b01:begin
                total_num                       <= total_num - 10'h1;
            end

            2'b11: begin
                total_num                       <= total_num;
            end
        endcase

        // to resolve when first input has timestamp of 64'h0
        if( (fifo_din[127:64] == 64'h0 ) && ( wr_en == 1'b1 ) ) begin
            total_num                           <= 10'h1;
        end
    end
end

endmodule