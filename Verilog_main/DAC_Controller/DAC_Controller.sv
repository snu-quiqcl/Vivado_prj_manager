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
    
    //////////////////////////////////////////////////////////////////////////////////
    // AXI4 Data Read
    //////////////////////////////////////////////////////////////////////////////////
    input wire s_axi_rready,
    output wire [AXI_DATA_WIDTH - 1:0] s_axi_rdata,
    output wire [1:0] s_axi_rresp,
    output wire s_axi_rvalid,
    output wire s_axi_rlast,
    output wire [15:0] s_axi_rid, // added to resolve wrapping error
    
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

assign m00_axis_tdata = (dac_mode == 1'b1)? m00_axis_tdata_direct : m00_axis_tdata_dds;
assign m00_axis_tvalid = (dac_mode == 1'b1)? m00_axis_tvalid_direct : m00_axis_tvalid_dds;

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
// AXI Buffer Declaration
//////////////////////////////////////////////////////////////////////////////////

/*
def convert_to_dot_notation(code):
    # Convert ports (input, output, reg, etc.)
    port_pattern = r"(input|output)\s+(reg|wire)\s+(?:\[[^\]]+\]\s+)?(\w+)\,"
    port_replacement = r".\3(\3),"
    return re.sub(port_pattern, port_replacement, code)


for line in a.split('\n'):
    print(convert_to_dot_notation(line))
*/

//////////////////////////////////////////////////////////////////////////////////
// AXI4 Address Write
//////////////////////////////////////////////////////////////////////////////////
wire [AXI_ADDR_WIDTH - 1:0] m_axi_awaddr_buffer_wire;
wire [15:0] m_axi_awid_buffer_wire;
wire [1:0] m_axi_awburst_buffer_wire;
wire [2:0] m_axi_awsize_buffer_wire;
wire [7:0] m_axi_awlen_buffer_wire;
wire m_axi_awvalid_buffer_wire;
wire [15:0] m_axi_awuser_buffer_wire; // added to resolve wrapping error
wire m_axi_awready_buffer_wire;                                                        //Note that ready signal is wire

//////////////////////////////////////////////////////////////////////////////////
// AXI4 Write Response
//////////////////////////////////////////////////////////////////////////////////
wire m_axi_bready_buffer_wire;
wire [1:0] m_axi_bresp_buffer_wire;
wire m_axi_bvalid_buffer_wire;
wire [15:0] m_axi_bid_buffer_wire; // added to resolve wrapping error

//////////////////////////////////////////////////////////////////////////////////
// AXI4 Data Write
//////////////////////////////////////////////////////////////////////////////////
wire [AXI_DATA_WIDTH - 1:0] m_axi_wdata_buffer_wire;
wire [AXI_STROBE_WIDTH - 1:0] m_axi_wstrb_buffer_wire;
wire m_axi_wvalid_buffer_wire;
wire m_axi_wlast_buffer_wire;
wire m_axi_wready_buffer_wire;                                                        //Note that ready signal is wire

//////////////////////////////////////////////////////////////////////////////////
// AXI4 Address Read
//////////////////////////////////////////////////////////////////////////////////
wire [1:0] m_axi_arburst_buffer_wire;
wire [7:0] m_axi_arlen_buffer_wire;
wire [AXI_ADDR_WIDTH - 1:0] m_axi_araddr_buffer_wire;
wire [2:0] m_axi_arsize_buffer_wire;
wire m_axi_arvalid_buffer_wire;
wire [15:0] m_axi_arid_buffer_wire; // added to resolve wrapping error
wire [15:0] m_axi_aruser_buffer_wire; // added to resolve wrapping error
wire m_axi_arready_buffer_wire;

//////////////////////////////////////////////////////////////////////////////////
// AXI4 Data Read
//////////////////////////////////////////////////////////////////////////////////
wire m_axi_rready_buffer_wire;
wire [AXI_DATA_WIDTH - 1:0] m_axi_rdata_buffer_wire;
wire [1:0] m_axi_rresp_buffer_wire;
wire m_axi_rvalid_buffer_wire;
wire m_axi_rlast_buffer_wire;
wire [15:0] m_axi_rid_buffer_wire; // added to resolve wrapping error

AXI_Buffer axi_buffer_0
(
    .s_axi_aclk(s_axi_aclk),    // Clock
    .m_axi_aclk(s_axi_aclk),    // Dummy
    .s_axi_aresetn(s_axi_aresetn), // Active low reset
    .m_axi_aresetn(s_axi_aresetn), // Dummy

    ////////////////////////////////////////////////////////////
    // Slave Write Adress
    ////////////////////////////////////////////////////////////
    .s_axi_awaddr(s_axi_awaddr), // Write address
    .s_axi_awid(s_axi_awid),   // Write ID
    .s_axi_awlen(s_axi_awlen),  // Burst length
    .s_axi_awvalid(s_axi_awvalid), // Write address valid
    .s_axi_awready(s_axi_awready), // Write address ready
    .s_axi_awsize(s_axi_awsize), // Burst size
    .s_axi_awburst(s_axi_awburst), // Burst type
    .s_axi_awlock(), // Lock signal
    .s_axi_awcache(), // Cache type
    .s_axi_awprot(), // Protection type
    .s_axi_awqos(),  // Quality of service
    .s_axi_awuser(s_axi_awuser),

    /////////////////////////////////////////////////////////////
    // Slave Write Data
    /////////////////////////////////////////////////////////////
    .s_axi_wdata(s_axi_wdata),   // Write data
    .s_axi_wstrb(s_axi_wstrb),   // Write strobes
    .s_axi_wvalid(s_axi_wvalid),  // Write valid
    .s_axi_wready(s_axi_wready),  // Write ready
    .s_axi_wid(),    // Write ID (if used)
    .s_axi_wlast(s_axi_wlast),

    /////////////////////////////////////////////////////////////
    // Slave Write Response
    /////////////////////////////////////////////////////////////
    .s_axi_bresp(s_axi_bresp),   // Write response
    .s_axi_bid(s_axi_bid),     // Response ID (if used)
    .s_axi_bvalid(s_axi_bvalid),  // Response valid
    .s_axi_bready(s_axi_bready),  // Response ready

    /////////////////////////////////////////////////////////////
    // Slave Read Adress
    /////////////////////////////////////////////////////////////
    .s_axi_araddr(s_axi_araddr),  // Read address
    .s_axi_arid(s_axi_arid),    // Read ID
    .s_axi_arlen(s_axi_arlen),   // Burst length
    .s_axi_arvalid(s_axi_arvalid), // Read address valid
    .s_axi_arready(s_axi_arready), // Read address ready
    .s_axi_arsize(s_axi_arsize),  // Burst size
    .s_axi_arburst(s_axi_arburst), // Burst type
    .s_axi_arlock(),  // Lock signal
    .s_axi_arcache(), // Cache type
    .s_axi_arprot(),  // Protection type
    .s_axi_arqos(),   // Quality of service
    .s_axi_aruser(s_axi_aruser),

    /////////////////////////////////////////////////////////////
    // Slave Read Data
    /////////////////////////////////////////////////////////////
    .s_axi_rdata(s_axi_rdata),   // Read data
    .s_axi_rresp(s_axi_rresp),   // Read response
    .s_axi_rid(s_axi_rid),     // Read ID (if used)
    .s_axi_rvalid(s_axi_rvalid),  // Read valid
    .s_axi_rready(s_axi_rready),  // Read ready
    .s_axi_rlast(s_axi_rlast),

    ////////////////////////////////////////////////////////////
    // Master Write Adress
    ////////////////////////////////////////////////////////////
    .m_axi_awaddr(m_axi_awaddr_buffer_wire), // Write address
    .m_axi_awid(m_axi_awid_buffer_wire),   // Write ID
    .m_axi_awlen(m_axi_awlen_buffer_wire),  // Burst length
    .m_axi_awvalid(m_axi_awvalid_buffer_wire), // Write address valid
    .m_axi_awready(m_axi_awready_buffer_wire), // Write address ready
    .m_axi_awsize(m_axi_awsize_buffer_wire), // Burst size
    .m_axi_awburst(m_axi_awburst_buffer_wire), // Burst type
    .m_axi_awlock(), // Lock signal
    .m_axi_awcache(), // Cache type
    .m_axi_awprot(), // Protection type
    .m_axi_awqos(),  // Quality of service
    .m_axi_awuser(m_axi_awuser_buffer_wire),

    /////////////////////////////////////////////////////////////
    // Master Write Data
    /////////////////////////////////////////////////////////////
    .m_axi_wdata(m_axi_wdata_buffer_wire),   // Write data
    .m_axi_wstrb(m_axi_wstrb_buffer_wire),   // Write strobes
    .m_axi_wvalid(m_axi_wvalid_buffer_wire),  // Write valid
    .m_axi_wready(m_axi_wready_buffer_wire),  // Write ready
    .m_axi_wid(),    // Write ID (if used)
    .m_axi_wlast(m_axi_wlast_buffer_wire),

    /////////////////////////////////////////////////////////////
    // Master Write Response
    /////////////////////////////////////////////////////////////
    .m_axi_bresp(m_axi_bresp_buffer_wire),   // Write response
    .m_axi_bid(m_axi_bid_buffer_wire),     // Response ID (if used)
    .m_axi_bvalid(m_axi_bvalid_buffer_wire),  // Response valid
    .m_axi_bready(m_axi_bready_buffer_wire),  // Response ready

    /////////////////////////////////////////////////////////////
    // Master Read Adress
    /////////////////////////////////////////////////////////////
    .m_axi_araddr(m_axi_araddr_buffer_wire),  // Read address
    .m_axi_arid(m_axi_arid_buffer_wire),    // Read ID
    .m_axi_arlen(m_axi_arlen_buffer_wire),   // Burst length
    .m_axi_arvalid(m_axi_arvalid_buffer_wire), // Read address valid
    .m_axi_arready(m_axi_arready_buffer_wire), // Read address ready
    .m_axi_arsize(m_axi_arsize_buffer_wire),  // Burst size
    .m_axi_arburst(m_axi_arburst_buffer_wire), // Burst type
    .m_axi_arlock(),  // Lock signal
    .m_axi_arcache(), // Cache type
    .m_axi_arprot(),  // Protection type
    .m_axi_arqos(),   // Quality of service
    .m_axi_aruser(m_axi_aruser_buffer_wire),

    /////////////////////////////////////////////////////////////
    // Master Read Data
    /////////////////////////////////////////////////////////////
    .m_axi_rdata(m_axi_rdata_buffer_wire),   // Read data
    .m_axi_rresp(m_axi_rresp_buffer_wire),   // Read response
    .m_axi_rid(m_axi_rid_buffer_wire),     // Read ID (if used)
    .m_axi_rvalid(m_axi_rvalid_buffer_wire),  // Read valid
    .m_axi_rready(m_axi_rready_buffer_wire),  // Read ready
    .m_axi_rlast(m_axi_rlast_buffer_wire)
);

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
    .s_axi_awaddr(m_axi_awaddr_buffer_wire),
    .s_axi_awid(m_axi_awid_buffer_wire),
    .s_axi_awburst(m_axi_awburst_buffer_wire),
    .s_axi_awsize(m_axi_awsize_buffer_wire),
    .s_axi_awlen(m_axi_awlen_buffer_wire),
    .s_axi_awvalid(m_axi_awvalid_buffer_wire),
    .s_axi_awuser(m_axi_awuser_buffer_wire), // added to resolve wrapping error
    .s_axi_awready(m_axi_awready_buffer_wire),                                                        //Note that ready signal is wire

    //////////////////////////////////////////////////////////////////////////////////
    // AXI4 Write Response
    //////////////////////////////////////////////////////////////////////////////////
    .s_axi_bready(m_axi_bready_buffer_wire),
    .s_axi_bresp(m_axi_bresp_buffer_wire),
    .s_axi_bvalid(m_axi_bvalid_buffer_wire),
    .s_axi_bid(m_axi_bid_buffer_wire), // added to resolve wrapping error

    //////////////////////////////////////////////////////////////////////////////////
    // AXI4 Data Write
    //////////////////////////////////////////////////////////////////////////////////
    .s_axi_wdata(m_axi_wdata_buffer_wire),
    .s_axi_wstrb(m_axi_wstrb_buffer_wire),
    .s_axi_wvalid(m_axi_wvalid_buffer_wire),
    .s_axi_wlast(m_axi_wlast_buffer_wire),
    .s_axi_wready(m_axi_wready_buffer_wire),                                                        //Note that ready signal is wire

    //////////////////////////////////////////////////////////////////////////////////
    // AXI4 Address Read
    //////////////////////////////////////////////////////////////////////////////////
    .s_axi_arburst(m_axi_arburst_buffer_wire),
    .s_axi_arlen(m_axi_arlen_buffer_wire),
    .s_axi_araddr(m_axi_araddr_buffer_wire),
    .s_axi_arsize(m_axi_arsize_buffer_wire),
    .s_axi_arvalid(m_axi_arvalid_buffer_wire),
    .s_axi_arid(m_axi_arid_buffer_wire), // added to resolve wrapping error
    .s_axi_aruser(m_axi_aruser_buffer_wire), // added to resolve wrapping error
    .s_axi_arready(m_axi_arready_buffer_wire),
    .s_axi_rid(m_axi_rid_buffer_wire), // added to resolve wrapping error

    //////////////////////////////////////////////////////////////////////////////////
    // AXI4 Data Read
    //////////////////////////////////////////////////////////////////////////////////
    .s_axi_rready(m_axi_rready_buffer_wire),
    .s_axi_rdata(m_axi_rdata_buffer_wire),
    .s_axi_rresp(m_axi_rresp_buffer_wire),
    .s_axi_rvalid(m_axi_rvalid_buffer_wire),
    .s_axi_rlast(m_axi_rlast_buffer_wire),
        
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
    
    //////////////////////////////////////////////////////////////////////////////////
    // DAC_mode
    //////////////////////////////////////////////////////////////////////////////////
    .dac_mode(dac_mode)
);

//////////////////////////////////////////////////////////////////////////////////
// RTO Core Declaration
//////////////////////////////////////////////////////////////////////////////////
wire counter_matched;
wire [127:0] rto_out;

RTO_Core rto_core_0(
    .clk(s_axi_aclk),
    .auto_start(auto_start),// need to be connected
    .reset(rto_core_reset),
    .flush(rto_core_flush),
    .write(rto_core_write),
    .fifo_din(rto_core_fifo_din),
    .counter(counter), // need to be connected
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
// RFDC_Controller Declaration
//////////////////////////////////////////////////////////////////////////////////

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
    .clk(s_axi_aclk),
    .m00_axis_aclk(m00_axis_aclk),
    .reset(rto_core_reset),
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
    .timestamp(timestamp)
);

RFDC_DDS rfdc_dds(
    .clk(s_axi_aclk),
    .freq(freq),
    .amp(amp),              // unsigned value
    .phase(phase),
    .timestamp(timestamp),
    .amp_offset(amp_offset),
    .time_offset(time_offset),
    .m_axis_data_tdata(m00_axis_tdata_dds),
    .m_axis_data_tvalid(m00_axis_tvalid_dds)
);
    
endmodule
