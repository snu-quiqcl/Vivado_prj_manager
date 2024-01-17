`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/18 16:37:21
// Design Name: 
// Module Name: EdgeCounter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 128 bit slave AXI4 to native FIFO interface module
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module EdgeCounter
#(
    //////////////////////////////////////////////////////////////////////////////////
    // AXI4 Configuraiton
    //////////////////////////////////////////////////////////////////////////////////
    parameter AXI_ADDR_WIDTH = 6,
    parameter AXI_DATA_WIDTH = 128,
    parameter AXI_STROBE_WIDTH = AXI_DATA_WIDTH >> 3,
    parameter AXI_STROBE_LEN = 4, // LOG(AXI_STROBE_WDITH)
    parameter FIFO_DEPTH = 10,
    parameter DATA_WIDTH = 16
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
    input wire [15:0] s_axi_awuser, 
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
    input wire [15:0] s_axi_arid,
    input wire [15:0] s_axi_aruser,
    output wire s_axi_arready,
    output wire [15:0] s_axi_rid,
    
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
    // TimeController interface
    //////////////////////////////////////////////////////////////////////////////////
    input wire auto_start,
    input wire [63:0] counter,
    
    input wire input_sig
    
    
);

//////////////////////////////////////////////////////////////////////////////////
// RTO_Core interface
//////////////////////////////////////////////////////////////////////////////////
wire rto_core_reset;
wire rto_core_flush;
wire rto_core_write;
wire [127:0] rto_core_fifo_din;

wire rto_core_full;
wire rto_core_empty;

//////////////////////////////////////////////////////////////////////////////////
// RTI_Core interface
//////////////////////////////////////////////////////////////////////////////////
wire rti_core_reset;
wire rti_core_rd_en;
wire rti_core_flush;

wire [127:0] rti_core_fifo_dout;
wire rti_core_full;
wire rti_core_empty;
wire [FIFO_DEPTH - 1:0] data_num;

AXI2FIFO
#(
    //////////////////////////////////////////////////////////////////////////////////
    // AXI4 Configuraiton
    //////////////////////////////////////////////////////////////////////////////////
    . AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
    . AXI_DATA_WIDTH(AXI_DATA_WIDTH),
    . AXI_STROBE_WIDTH(AXI_STROBE_WIDTH),
    . AXI_STROBE_LEN(AXI_STROBE_LEN), // LOG(AXI_STROBE_WDITH)
    . FIFO_DEPTH(FIFO_DEPTH)
)
axi2_fifo_0
(
    //////////////////////////////////////////////////////////////////////////////////
    // AXI4 Address Write
    //////////////////////////////////////////////////////////////////////////////////
    // AXI4 Address Write
    .s_axi_awaddr(s_axi_awaddr),
    .s_axi_awid(s_axi_awid),
    .s_axi_awburst(s_axi_awburst),
    .s_axi_awsize(s_axi_awsize),
    .s_axi_awlen(s_axi_awlen),
    .s_axi_awvalid(s_axi_awvalid),
    .s_axi_awuser(s_axi_awuser),
    .s_axi_awready(s_axi_awready),

    // AXI4 Write Response
    .s_axi_bready(s_axi_bready),
    .s_axi_bresp(s_axi_bresp),
    .s_axi_bvalid(s_axi_bvalid),
    .s_axi_bid(s_axi_bid),

    // AXI4 Data Write
    .s_axi_wdata(s_axi_wdata),
    .s_axi_wstrb(s_axi_wstrb),
    .s_axi_wvalid(s_axi_wvalid),
    .s_axi_wlast(s_axi_wlast),
    .s_axi_wready(s_axi_wready),

    // AXI4 Address Read
    .s_axi_arburst(s_axi_arburst),
    .s_axi_arlen(s_axi_arlen),
    .s_axi_araddr(s_axi_araddr),
    .s_axi_arsize(s_axi_arsize),
    .s_axi_arvalid(s_axi_arvalid),
    .s_axi_arid(s_axi_arid),
    .s_axi_aruser(s_axi_aruser),
    .s_axi_arready(s_axi_arready),

    // AXI4 Data Read
    .s_axi_rready(s_axi_rready),
    .s_axi_rdata(s_axi_rdata),
    .s_axi_rresp(s_axi_rresp),
    .s_axi_rvalid(s_axi_rvalid),
    .s_axi_rlast(s_axi_rlast),

    // AXI4 Clock and Reset
    .s_axi_aclk(s_axi_aclk),
    .s_axi_aresetn(s_axi_aresetn),

    // RTO_Core interface
    .rto_core_reset(rto_core_reset),
    .rto_core_flush(rto_core_flush),
    .rto_core_write(rto_core_write),
    .rto_core_fifo_din(rto_core_fifo_din),
    .rto_core_full(rto_core_full),
    .rto_core_empty(rto_core_empty),

    // RTI_Core interface
    .rti_core_reset(rti_core_reset),
    .rti_core_rd_en(rti_core_rd_en),
    .rti_core_flush(rti_core_flush),
    .rti_core_fifo_dout(rti_core_fifo_dout),
    .rti_core_full(rti_core_full),
    .rti_core_empty(rti_core_empty),
    .data_num(data_num)
);
//////////////////////////////////////////////////////////////////////////////////
// RTO Core Declaration
//////////////////////////////////////////////////////////////////////////////////
wire [127:0] rto_out;
wire counter_matched;

RTO_Core rto_core_0
(
    .clk(s_axi_aclk),
    .auto_start(auto_start),
    .reset(rto_core_reset),
    .flush(rto_core_flush),
    .write(rto_core_write),
    .fifo_din(rto_core_fifo_din),
    .counter(counter),
    .counter_matched(counter_matched),
    .rto_out(rto_out),
    .timestamp_error_data(),
    .overflow_error_data(),
    .timestamp_error(),
    .overflow_error(),
    .full(rto_core_full),
    .empty(rto_core_empty)
    );

//////////////////////////////////////////////////////////////////////////////////
// RTI Core Declaration
//////////////////////////////////////////////////////////////////////////////////
wire [127:0] rti_in;
wire [FIFO_DEPTH - 1:0]data_num;
RTI_Core
#(
    .FIFO_DEPTH(FIFO_DEPTH)
)
rti_core_0
(
    .clk(s_axi_aclk),
    .reset(rti_core_reset),
    .flush(rti_core_flush),
    .write(write),
    .read(rti_core_rd_en),
    .rti_in(rti_in),
    .rti_out(rti_core_fifo_dout),
    .overflow_error_data(),
    .overflow_error(),
    .underflow_error(),
    .full,
    .empty,
    .data_num(data_num)
    );
    
 //////////////////////////////////////////////////////////////////////////////////
// GPO Core Declaration
//////////////////////////////////////////////////////////////////////////////////
wire[127:0] gpo_out;
wire seleceted;

GPO_Core gpo_core_0
(
    .clk(s_axi_aclk),
    .reset(rto_core_reset),
    .override_en(1'b0),
    .selected_en(1'b1),
    .override_value(),
    .counter_matched(counter_matched),
    .gpo_in(rto_out),
    .busy(1'b0),
    .selected(seleceted),
    .error_data(),
    .overrided(1'b0),
    .busy_error(),
    .gpo_out(gpo_out)
    );
    
//////////////////////////////////////////////////////////////////////////////////
// Edge Controller Declaration
//////////////////////////////////////////////////////////////////////////////////
wire write;

EdgeCounter_Controller
#(
    .DATA_WIDTH(DATA_WIDTH)
)
(
    .clk(s_axi_aclk),
    .input_sig(input_sig),
    .reset(rto_core_reset),
    .cmd_in(gpo_out[63:0]),
    .counter(counter),
    .write(write),
    .count_out(rti_in)
    );
endmodule