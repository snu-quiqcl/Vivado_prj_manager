`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/24 10:36:41
// Design Name: 
// Module Name: DAC0_Controller
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


module TTL_Controller#(
    //////////////////////////////////////////////////////////////////////////////////
    // AXI4 Configuraiton
    //////////////////////////////////////////////////////////////////////////////////
    parameter AXI_ADDR_WIDTH = 6,
    parameter AXI_DATA_WIDTH = 128,
    parameter AXI_STROBE_WIDTH = AXI_DATA_WIDTH >> 3,
    parameter AXI_STROBE_LEN = 4, // LOG(AXI_STROBE_WDITH)
    
    //////////////////////////////////////////////////////////////////////////////////
    // RFDC & GPO Configuration
    //////////////////////////////////////////////////////////////////////////////////
    parameter DEST_VAL = 16'h0,
    parameter CHANNEL_LENGTH = 12,
    parameter AXIS_DATA_WIDTH = 256
)
(
    //////////////////////////////////////////////////////////////////////////////////
    // AXI4 Address Write
    //////////////////////////////////////////////////////////////////////////////////
    input wire [AXI_ADDR_WIDTH - 1:0] s_axi_awaddr,
    input wire [15:0] s_axi_awid, 
    input wire [1:0] s_axi_awburst,
    input wire [2:0] s_axi_awsize,
    input wire [7:0] s_axi_awlen,
    input wire s_axi_awvalid,
    input wire [15:0] s_axi_awuser, // added to resolve wrapping error
    output wire s_axi_awready,                                                        //Note that ready signal is wire
    
    //////////////////////////////////////////////////////////////////////////////////
    // AXI4 Write Response
    //////////////////////////////////////////////////////////////////////////////////
    input wire s_axi_bready,
    output wire [1:0] s_axi_bresp,
    output wire s_axi_bvalid,
    output wire [15:0] s_axi_bid, // added to resolve wrapping error
    
    //////////////////////////////////////////////////////////////////////////////////
    // AXI4 Data Write
    //////////////////////////////////////////////////////////////////////////////////
    input wire [AXI_DATA_WIDTH - 1:0] s_axi_wdata,
    input wire [AXI_STROBE_WIDTH - 1:0] s_axi_wstrb,
    input wire s_axi_wvalid,
    input wire s_axi_wlast,
    output wire s_axi_wready,                                                        //Note that ready signal is wire
    
    //////////////////////////////////////////////////////////////////////////////////
    // AXI4 Address Read
    //////////////////////////////////////////////////////////////////////////////////
    input wire [1:0] s_axi_arburst,
    input wire [7:0] s_axi_arlen,
    input wire [AXI_ADDR_WIDTH - 1:0] s_axi_araddr,
    input wire [2:0] s_axi_arsize,
    input wire s_axi_arvalid,
    input wire [15:0] s_axi_arid, // added to resolve wrapping error
    input wire [15:0] s_axi_aruser, // added to resolve wrapping error
    output wire s_axi_arready,
    output wire [15:0] s_axi_rid, // added to resolve wrapping error
    
    //////////////////////////////////////////////////////////////////////////////////
    // AXI4 Data Read
    //////////////////////////////////////////////////////////////////////////////////
    input wire s_axi_rready,
    output wire [AXI_DATA_WIDTH - 1:0] s_axi_rdata,
    output wire [1:0] s_axi_rresp,
    output wire s_axi_rvalid,
    output wire s_axi_rlast,
    
    //////////////////////////////////////////////////////////////////////////////////
    // AXI4 Clock
    //////////////////////////////////////////////////////////////////////////////////
    input wire s_axi_aclk,
    
    //////////////////////////////////////////////////////////////////////////////////
    // AXI4 Reset
    //////////////////////////////////////////////////////////////////////////////////
    input wire s_axi_aresetn,
    
    //////////////////////////////////////////////////////////////////////////////////  
    // Port for TTL Module
    //////////////////////////////////////////////////////////////////////////////////
    output wire output_pulse,
    
    input wire clk_x4,
    
    //////////////////////////////////////////////////////////////////////////////////  
    // TimeController interface
    //////////////////////////////////////////////////////////////////////////////////
    input wire auto_start,
    input wire [63:0] counter
);
//////////////////////////////////////////////////////////////////////////////////
// AXI2FIFO to RTO_Core wire
//////////////////////////////////////////////////////////////////////////////////

wire rto_core_reset;
wire rto_core_flush;
wire rto_core_write;
wire [127:0] rto_core_fifo_din;
    
wire rto_core_full;
wire rto_core_empty;

//////////////////////////////////////////////////////////////////////////////////
// AXI2FIFO Declaration
//////////////////////////////////////////////////////////////////////////////////

AXI2FIFO
#(
    //////////////////////////////////////////////////////////////////////////////////
    // AXI4 Configuraiton
    //////////////////////////////////////////////////////////////////////////////////
    .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
    .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
    .AXI_STROBE_WIDTH(AXI_STROBE_WIDTH ),
    .AXI_STROBE_LEN(AXI_STROBE_LEN)
)
axi2fifo_0
(
    //////////////////////////////////////////////////////////////////////////////////
    // AXI4 Address Write
    //////////////////////////////////////////////////////////////////////////////////
    .s_axi_awaddr(s_axi_awaddr),
    .s_axi_awid(s_axi_awid),
    .s_axi_awburst(s_axi_awburst),
    .s_axi_awsize(s_axi_awsize),
    .s_axi_awlen(s_axi_awlen),
    .s_axi_awvalid(s_axi_awvalid),
    .s_axi_awuser(s_axi_awuser), // added to resolve wrapping error
    .s_axi_awready(s_axi_awready),                                                        //Note that ready signal is wire
    
    //////////////////////////////////////////////////////////////////////////////////
    // AXI4 Write Response
    //////////////////////////////////////////////////////////////////////////////////
    .s_axi_bready(s_axi_bready),
    .s_axi_bresp(s_axi_bresp),
    .s_axi_bvalid(s_axi_bvalid),
    .s_axi_bid(s_axi_bid), // added to resolve wrapping error
    
    //////////////////////////////////////////////////////////////////////////////////
    // AXI4 Data Write
    //////////////////////////////////////////////////////////////////////////////////
    .s_axi_wdata(s_axi_wdata),
    .s_axi_wstrb(s_axi_wstrb),
    .s_axi_wvalid(s_axi_wvalid),
    .s_axi_wlast(s_axi_wlast),
    .s_axi_wready(s_axi_wready),                                                        //Note that ready signal is wire
    
    //////////////////////////////////////////////////////////////////////////////////
    // AXI4 Address Read
    //////////////////////////////////////////////////////////////////////////////////
    .s_axi_arburst(s_axi_arburst),
    .s_axi_arlen(s_axi_arlen),
    .s_axi_araddr(s_axi_araddr),
    .s_axi_arsize(s_axi_arsize),
    .s_axi_arvalid(s_axi_arvalid),
    .s_axi_arid(s_axi_arid), // added to resolve wrapping error
    .s_axi_aruser(s_axi_aruser), // added to resolve wrapping error
    .s_axi_arready(s_axi_arready),
    .s_axi_rid(s_axi_rid), // added to resolve wrapping error
    
    //////////////////////////////////////////////////////////////////////////////////
    // AXI4 Data Read
    //////////////////////////////////////////////////////////////////////////////////
    .s_axi_rready(s_axi_rready),
    .s_axi_rdata(s_axi_rdata),
    .s_axi_rresp(s_axi_rresp),
    .s_axi_rvalid(s_axi_rvalid),
    .s_axi_rlast(s_axi_rlast),
    
    //////////////////////////////////////////////////////////////////////////////////
    // AXI4 Clock
    //////////////////////////////////////////////////////////////////////////////////
    .s_axi_aclk(s_axi_aclk),
    
    //////////////////////////////////////////////////////////////////////////////////
    // AXI4 Reset
    //////////////////////////////////////////////////////////////////////////////////
    .s_axi_aresetn(s_axi_aresetn),
    
    //////////////////////////////////////////////////////////////////////////////////
    // RTO_Core interface
    //////////////////////////////////////////////////////////////////////////////////
    .rto_core_reset(rto_core_reset),
    .rto_core_flush(rto_core_flush),
    .rto_core_write(rto_core_write),
    .rto_core_fifo_din(rto_core_fifo_din),
    
    .rto_core_full(rto_core_full),
    .rto_core_empty(rto_core_empty),
);

//////////////////////////////////////////////////////////////////////////////////
// RTO Core Declaration
//////////////////////////////////////////////////////////////////////////////////
reg rto_core_write_0;
wire rto_core_full_0;
wire rto_core_empty_0;
reg [127:0] rto_core_fifo_din_0;

reg rto_core_write_1;
wire rto_core_full_1;
wire rto_core_empty_1;
reg [127:0] rto_core_fifo_din_1;

reg rto_core_write_2;
wire rto_core_full_2;
wire rto_core_empty_2;
reg [127:0] rto_core_fifo_din_2;

reg rto_core_write_3;
wire rto_core_full_3;
wire rto_core_empty_3;
reg [127:0] rto_core_fifo_din_3;

reg rto_core_write_4;
wire rto_core_full_4;
wire rto_core_empty_4;
reg [127:0] rto_core_fifo_din_4;

reg rto_core_write_5;
wire rto_core_full_5;
wire rto_core_empty_5;
reg [127:0] rto_core_fifo_din_5;

reg rto_core_write_6;
wire rto_core_full_6;
wire rto_core_empty_6;
reg [127:0] rto_core_fifo_din_6;

reg rto_core_write_7;
wire rto_core_full_7;
wire rto_core_empty_7;
reg [127:0] rto_core_fifo_din_7;


assign rto_core_full = rto_core_full_0 & rto_core_full_1 & rto_core_full_2 & rto_core_full_3 & rto_core_full_4 & rto_core_full_5 & rto_core_full_6 & rto_core_full_7;
assign rto_core_empty = rto_core_empty_0 | rto_core_empty_1 | rto_core_empty_2 | rto_core_empty_3 | rto_core_empty_4 | rto_core_empty_5 | rto_core_empty_6 | rto_core_empty_7;

wire counter_matched_0;
wire [127:0] rto_out_0;

always@(posedge s_axi_aclk) begin
    if( s_axi_aresetn == 1'b0 ) begin
        rto_core_write_0 <= 1'b0;
        rto_core_fifo_din_0 <= 128'h0;

        rto_core_write_1 <= 1'b0;
        rto_core_fifo_din_1 <= 128'h0;

        rto_core_write_2 <= 1'b0;
        rto_core_fifo_din_2 <= 128'h0;

        rto_core_write_3 <= 1'b0;
        rto_core_fifo_din_3 <= 128'h0;

        rto_core_write_4 <= 1'b0;
        rto_core_fifo_din_4 <= 128'h0;

        rto_core_write_5 <= 1'b0;
        rto_core_fifo_din_5 <= 128'h0;

        rto_core_write_6 <= 1'b0;
        rto_core_fifo_din_6 <= 128'h0;

        rto_core_write_7 <= 1'b0;
        rto_core_fifo_din_7 <= 128'h0;
    end

    else begin
        rto_core_write_0 <= 1'b0;
        rto_core_write_1 <= 1'b0;
        rto_core_write_2 <= 1'b0;
        rto_core_write_3 <= 1'b0;
        rto_core_write_4 <= 1'b0;
        rto_core_write_5 <= 1'b0;
        rto_core_write_6 <= 1'b0;
        rto_core_write_7 <= 1'b0;

        case(rto_core_fifo_din[66:64]):
            3'h0:begin
                rto_core_write_0 <= 1'b1;
                rto_core_fifo_din_0 <= rto_core_fifo_din[127:0];
            end

            3'h1:begin
                rto_core_write_1 <= 1'b1;
                rto_core_fifo_din_1 <= rto_core_fifo_din[127:0];
            end

            3'h2:begin
                rto_core_write_2 <= 1'b1;
                rto_core_fifo_din_2 <= rto_core_fifo_din[127:0];
            end

            3'h3:begin
                rto_core_write_3 <= 1'b1;
                rto_core_fifo_din_3 <= rto_core_fifo_din[127:0];
            end

            3'h4:begin
                rto_core_write_4 <= 1'b1;
                rto_core_fifo_din_4 <= rto_core_fifo_din[127:0];
            end

            3'h5:begin
                rto_core_write_5 <= 1'b1;
                rto_core_fifo_din_5 <= rto_core_fifo_din[127:0];
            end

            3'h6:begin
                rto_core_write_6 <= 1'b1;
                rto_core_fifo_din_6 <= rto_core_fifo_din[127:0];
            end

            3'h7:begin
                rto_core_write_7 <= 1'b1;
                rto_core_fifo_din_7 <= rto_core_fifo_din[127:0];
            end
        endcase
    end
end

RTO_Core rto_core_0(
    .clk(s_axi_aclk),
    .auto_start(auto_start),// need to be connected
    .reset(rto_core_reset),
    .flush(rto_core_flush),
    .write(rto_core_write_0),
    .fifo_din(rto_core_fifo_din_0),
    .counter(counter), // need to be connected
    .counter_matched(counter_matched_0),
    .rto_out(rto_out_0), 
    .timestamp_error_data(),
    .overflow_error_data(),
    .timestamp_error(),
    .overflow_error(),
    .full(rto_core_full_0),
    .empty(rto_core_empty_0)
);
wire counter_matched_1;
wire [127:0] rto_out_1;

RTO_Core rto_core_1(
    .clk(s_axi_aclk),
    .auto_start(auto_start),// need to be connected
    .reset(rto_core_reset),
    .flush(rto_core_flush),
    .write(rto_core_write_1),
    .fifo_din(rto_core_fifo_din_1),
    .counter(counter), // need to be connected
    .counter_matched(counter_matched_1),
    .rto_out(rto_out_1), 
    .timestamp_error_data(),
    .overflow_error_data(),
    .timestamp_error(),
    .overflow_error(),
    .full(rto_core_full_1),
    .empty(rto_core_empty_1)
);
wire counter_matched_2;
wire [127:0] rto_out_2;

RTO_Core rto_core_2(
    .clk(s_axi_aclk),
    .auto_start(auto_start),// need to be connected
    .reset(rto_core_reset),
    .flush(rto_core_flush),
    .write(rto_core_write_2),
    .fifo_din(rto_core_fifo_din_2),
    .counter(counter), // need to be connected
    .counter_matched(counter_matched_2),
    .rto_out(rto_out_2), 
    .timestamp_error_data(),
    .overflow_error_data(),
    .timestamp_error(),
    .overflow_error(),
    .full(rto_core_full_2),
    .empty(rto_core_empty_2)
);
wire counter_matched_3;
wire [127:0] rto_out_3;

RTO_Core rto_core_3(
    .clk(s_axi_aclk),
    .auto_start(auto_start),// need to be connected
    .reset(rto_core_reset),
    .flush(rto_core_flush),
    .write(rto_core_write_3),
    .fifo_din(rto_core_fifo_din_3),
    .counter(counter), // need to be connected
    .counter_matched(counter_matched_3),
    .rto_out(rto_out_3), 
    .timestamp_error_data(),
    .overflow_error_data(),
    .timestamp_error(),
    .overflow_error(),
    .full(rto_core_full_3),
    .empty(rto_core_empty_3)
);
wire counter_matched_4;
wire [127:0] rto_out_4;

RTO_Core rto_core_4(
    .clk(s_axi_aclk),
    .auto_start(auto_start),// need to be connected
    .reset(rto_core_reset),
    .flush(rto_core_flush),
    .write(rto_core_write_4),
    .fifo_din(rto_core_fifo_din_4),
    .counter(counter), // need to be connected
    .counter_matched(counter_matched_4),
    .rto_out(rto_out_4), 
    .timestamp_error_data(),
    .overflow_error_data(),
    .timestamp_error(),
    .overflow_error(),
    .full(rto_core_full_4),
    .empty(rto_core_empty_4)
);
wire counter_matched_5;
wire [127:0] rto_out_5;

RTO_Core rto_core_5(
    .clk(s_axi_aclk),
    .auto_start(auto_start),// need to be connected
    .reset(rto_core_reset),
    .flush(rto_core_flush),
    .write(rto_core_write_5),
    .fifo_din(rto_core_fifo_din_5),
    .counter(counter), // need to be connected
    .counter_matched(counter_matched_5),
    .rto_out(rto_out_5), 
    .timestamp_error_data(),
    .overflow_error_data(),
    .timestamp_error(),
    .overflow_error(),
    .full(rto_core_full_5),
    .empty(rto_core_empty_5)
);
wire counter_matched_6;
wire [127:0] rto_out_6;

RTO_Core rto_core_6(
    .clk(s_axi_aclk),
    .auto_start(auto_start),// need to be connected
    .reset(rto_core_reset),
    .flush(rto_core_flush),
    .write(rto_core_write_6),
    .fifo_din(rto_core_fifo_din_6),
    .counter(counter), // need to be connected
    .counter_matched(counter_matched_6),
    .rto_out(rto_out_6), 
    .timestamp_error_data(),
    .overflow_error_data(),
    .timestamp_error(),
    .overflow_error(),
    .full(rto_core_full_6),
    .empty(rto_core_empty_6)
);
wire counter_matched_7;
wire [127:0] rto_out_7;

RTO_Core rto_core_7(
    .clk(s_axi_aclk),
    .auto_start(auto_start),// need to be connected
    .reset(rto_core_reset),
    .flush(rto_core_flush),
    .write(rto_core_write_7),
    .fifo_din(rto_core_fifo_din_7),
    .counter(counter), // need to be connected
    .counter_matched(counter_matched_7),
    .rto_out(rto_out_7), 
    .timestamp_error_data(),
    .overflow_error_data(),
    .timestamp_error(),
    .overflow_error(),
    .full(rto_core_full_7),
    .empty(rto_core_empty_7)
);

//////////////////////////////////////////////////////////////////////////////////
// TTL Declaration
//////////////////////////////////////////////////////////////////////////////////

TTLx8_output
(
    .DEST_VAL(DEST_VAL),
    .CHANNEL_LENGTH(CHANNEL_LENGTH),
)
ttlx8_output_0
(
    //////////////////////////////////////////////////////////////////////////////////  
    // IO declaration for GPO_Core
    //////////////////////////////////////////////////////////////////////////////////
    .clk(s_axi_aclk),
    .reset(rto_core_reset),
    .override_en(1'b0),
    .selected_en(1'b1),
    .override_value(64'h0),
    .counter_matched(counter_matched),
    .gpo_in(rto_out),
    .busy(1'b0),
    .error_data(),
    .overrided(),
    .busy_error(),

    //////////////////////////////////////////////////////////////////////////////////
    // Port for TTL
    //////////////////////////////////////////////////////////////////////////////////
    .clk_x4(clk_x4),
    .output_pulse(output_pulse)
);

endmodule
