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


module DAC_Controller#(
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
    input wire m00_axis_aclk,
    
    //////////////////////////////////////////////////////////////////////////////////
    // AXI4 Reset
    //////////////////////////////////////////////////////////////////////////////////
    input wire s_axi_aresetn,
    
    //////////////////////////////////////////////////////////////////////////////////  
    // AXIS declaration for RFDC DAC
    //////////////////////////////////////////////////////////////////////////////////
    output wire [AXIS_DATA_WIDTH - 1:0] m00_axis_tdata,
    output wire m00_axis_tvalid,
    
    input wire m00_axis_tready,
    
    //////////////////////////////////////////////////////////////////////////////////  
    // TimeController interface
    //////////////////////////////////////////////////////////////////////////////////
    input wire auto_start,
    input wire [63:0] counter,
    input wire rtio_clk
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
// DAC mode selection
// dac_mode 
// 1'b0 : DDS mode
// 1'b1 : Direct RFDC axis write mode
//////////////////////////////////////////////////////////////////////////////////
wire dac_mode;
wire [255:0] m00_axis_tdata_direct;
wire [255:0] m00_axis_tdata_dds;
wire m00_axis_tvalid_direct;
wire m00_axis_tvalid_dds;

assign m00_axis_tdata = m00_axis_tdata_dds;
assign m00_axis_tvalid = m00_axis_tvalid_dds;

//////////////////////////////////////////////////////////////////////////////////
// DDS_Controller to RFDC_DDS
//////////////////////////////////////////////////////////////////////////////////
wire [47:0] freq;
wire [13:0] amp;
wire [13:0] phase;
wire [63:0] timestamp;
wire [13:0] amp_offset;
wire [63:0] time_offset;
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
    .s_axi_awuser(s_axi_awuser),                // added to resolve wrapping error
    .s_axi_awready(s_axi_awready),              //Note that ready signal is wire
    
    //////////////////////////////////////////////////////////////////////////////////
    // AXI4 Write Response
    //////////////////////////////////////////////////////////////////////////////////
    .s_axi_bready(s_axi_bready),
    .s_axi_bresp(s_axi_bresp),
    .s_axi_bvalid(s_axi_bvalid),
    .s_axi_bid(s_axi_bid),                      // added to resolve wrapping error
    
    //////////////////////////////////////////////////////////////////////////////////
    // AXI4 Data Write
    //////////////////////////////////////////////////////////////////////////////////
    .s_axi_wdata(s_axi_wdata),
    .s_axi_wstrb(s_axi_wstrb),
    .s_axi_wvalid(s_axi_wvalid),
    .s_axi_wlast(s_axi_wlast),
    .s_axi_wready(s_axi_wready),                //Note that ready signal is wire
    
    //////////////////////////////////////////////////////////////////////////////////
    // AXI4 Address Read
    //////////////////////////////////////////////////////////////////////////////////
    .s_axi_arburst(s_axi_arburst),
    .s_axi_arlen(s_axi_arlen),
    .s_axi_araddr(s_axi_araddr),
    .s_axi_arsize(s_axi_arsize),
    .s_axi_arvalid(s_axi_arvalid),
    .s_axi_arid(s_axi_arid),                    // added to resolve wrapping error
    .s_axi_aruser(s_axi_aruser),                // added to resolve wrapping error
    .s_axi_arready(s_axi_arready),
    .s_axi_rid(s_axi_rid),                      // added to resolve wrapping error
    
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
    .rto_core_reset(rto_core_reset),            // rtio_clk region
    .rto_core_flush(rto_core_flush),            // rtio_clk region
    .rto_core_write(rto_core_write),            // rtio_clk region
    .rto_core_fifo_din(rto_core_fifo_din),      // rtio_clk region
    
    .rto_core_full(rto_core_full),              // rtio_clk region
    .rto_core_empty(rto_core_empty),            // rtio_clk region
    
    //////////////////////////////////////////////////////////////////////////////////
    // Dummy RTI_Core interface
    //////////////////////////////////////////////////////////////////////////////////
    .rti_core_full(1'b0),
    .rti_core_empty(1'b1),
    .rtio_clk(rtio_clk)
);

//////////////////////////////////////////////////////////////////////////////////
// RTO Core Declaration
//////////////////////////////////////////////////////////////////////////////////
wire counter_matched;
wire [127:0] rto_out;

RTO_Core rto_core_0(
    .clk(rtio_clk),
    .auto_start(auto_start),                    // rtio_clk region
    .reset(rto_core_flush|rto_core_reset),      // rtio_clk region
    .flush(rto_core_flush),                     // rtio_clk region
    .write(rto_core_write),                     // rtio_clk region
    .fifo_din(rto_core_fifo_din),               // rtio_clk region
    .counter(counter),                          // rtio_clk region
    .counter_matched(counter_matched),          // rtio_clk region
    .rto_out(rto_out),                          // rtio_clk region
    .timestamp_error_data(),
    .overflow_error_data(),
    .timestamp_error(),
    .overflow_error(),
    .full(rto_core_full),                       // rtio_clk region
    .empty(rto_core_empty)                      // rtio_clk region
);

//////////////////////////////////////////////////////////////////////////////////
// RFDC_Controller Declaration
//////////////////////////////////////////////////////////////////////////////////
wire sync_en;

DDS_Controller
#(
    .DEST_VAL(DEST_VAL),
    .CHANNEL_LENGTH(CHANNEL_LENGTH),
    .AXIS_DATA_WIDTH(AXIS_DATA_WIDTH)
)
dds_controller_0
(
    //////////////////////////////////////////////////////////////////////////////////  
    // IO declaration for GPO_Core
    //////////////////////////////////////////////////////////////////////////////////
    .clk(rtio_clk),
    .m00_axis_aclk(rtio_clk),
    .reset(rto_core_flush|rto_core_reset),
    .override_en(1'b0),
    .selected_en(1'b1),
    .override_value(64'h0),
    .counter_matched(counter_matched),
    .gpo_in(rto_out),
    .busy(1'b0),    // should be connected to RFDC busy line
    .error_data(),
    .overrided(),
    .busy_error(),
    
    //////////////////////////////////////////////////////////////////////////////////  
    // Output port for DDS control
    //////////////////////////////////////////////////////////////////////////////////
    .freq(freq),
    .amp(amp),
    .phase(phase),
    .amp_offset(amp_offset),
    .time_offset(time_offset),
    .timestamp(timestamp),
    .sync_en(sync_en)
);

RFDC_DDS rfdc_dds(
    .clk(rtio_clk),
    .reset(rto_core_flush|rto_core_reset),
    .sync_en(sync_en),
    .freq(freq),
    .amp(amp),              // unsigned value
    .phase(phase),
    .timestamp(counter),
    .amp_offset(amp_offset),
    .time_offset(time_offset),
    .m_axis_data_tdata(m00_axis_tdata_dds),
    .m_axis_data_tvalid(m00_axis_tvalid_dds)
);
    
endmodule