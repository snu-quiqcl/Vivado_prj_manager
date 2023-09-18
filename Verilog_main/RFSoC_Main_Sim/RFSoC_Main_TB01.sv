`timescale 0.1ps / 0.1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/31 16:33:57
// Design Name: 
// Module Name: RFSoC_Main_TB00
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


module RFSoC_Main_TB00;

wire [255:0]m00_axis_0_tdata;
reg m00_axis_0_tready;
wire m00_axis_0_tvalid;
reg [5:0]s_axi_0_araddr;
reg [1:0]s_axi_0_arburst;
reg [15:0]s_axi_0_arid;
reg [7:0]s_axi_0_arlen;
wire s_axi_0_arready;
reg [2:0]s_axi_0_arsize;
reg [15:0]s_axi_0_aruser;
reg s_axi_0_arvalid;
reg [5:0]s_axi_0_awaddr;
reg [1:0]s_axi_0_awburst;
reg [15:0]s_axi_0_awid;
reg [7:0]s_axi_0_awlen;
wire s_axi_0_awready;
reg [2:0]s_axi_0_awsize;
reg [15:0]s_axi_0_awuser;
reg s_axi_0_awvalid;
wire [15:0]s_axi_0_bid;
reg s_axi_0_bready;
wire [1:0]s_axi_0_bresp;
wire s_axi_0_bvalid;
wire [127:0]s_axi_0_rdata;
wire [15:0]s_axi_0_rid;
wire s_axi_0_rlast;
reg s_axi_0_rready;
wire [1:0]s_axi_0_rresp;
wire s_axi_0_rvalid;
reg [127:0]s_axi_0_wdata;
reg s_axi_0_wlast;
wire s_axi_0_wready;
reg [15:0]s_axi_0_wstrb;
reg s_axi_0_wvalid;
reg [5:0]s_axi_1_araddr;
reg [1:0]s_axi_1_arburst;
reg [15:0]s_axi_1_arid;
reg [7:0]s_axi_1_arlen;
wire s_axi_1_arready;
reg [2:0]s_axi_1_arsize;
reg [15:0]s_axi_1_aruser;
reg s_axi_1_arvalid;
reg [5:0]s_axi_1_awaddr;
reg [1:0]s_axi_1_awburst;
reg [15:0]s_axi_1_awid;
reg [7:0]s_axi_1_awlen;
wire s_axi_1_awready;
reg [2:0]s_axi_1_awsize;
reg [15:0]s_axi_1_awuser;
reg s_axi_1_awvalid;
wire [15:0]s_axi_1_bid;
reg s_axi_1_bready;
wire [1:0]s_axi_1_bresp;
wire s_axi_1_bvalid;
wire [127:0]s_axi_1_rdata;
wire [15:0]s_axi_1_rid;
wire s_axi_1_rlast;
reg s_axi_1_rready;
wire [1:0]s_axi_1_rresp;
wire s_axi_1_rvalid;
reg [127:0]s_axi_1_wdata;
reg s_axi_1_wlast;
wire s_axi_1_wready;
reg [15:0]s_axi_1_wstrb;
reg s_axi_1_wvalid;

RFSoC_Main_blk_wrapper tb();


//////////////////////////////////////////////////////////////////////////////////
// DAC output
//////////////////////////////////////////////////////////////////////////////////

reg[1:0] resp;
reg[1:0] resp2;

//assign m00_axis_0_tdata = tb.RFSoC_Main_blk_i.DAC_Controller_0.inst.rfdc_dds.m_axis_data_tdata;

initial begin
end

endmodule
