module AXI_Buffer
#(
    S_AXI_AWADDR = 40
    S_AXI_AWID = 16
    S_AXI_AWLEN = 8
    S_AXI_AWSIZE = 3
    S_AXI_AWBURST = 2
    S_AXI_AWLOCK = 1
    S_AXI_AWCACHE = 4
    S_AXI_AWPROT = 3
    S_AXI_AWQOS = 4
    S_AXI_WDATA = 128
    S_AXI_WSTRB = 16
    S_AXI_WID = 16
    S_AXI_BRESP = 2
    S_AXI_BID = 16
    S_AXI_ARADDR = 40
    S_AXI_ARID = 16
    S_AXI_ARLEN = 8
    S_AXI_ARSIZE = 3
    S_AXI_ARBURST = 2
    S_AXI_ARLOCK = 1
    S_AXI_ARCACHE = 4
    S_AXI_ARPROT = 3
    S_AXI_ARQOS = 4
    S_AXI_RDATA = 128
    S_AXI_RRESP = 2
    S_AXI_RID = 16
    S_AXI_AWUSER = 16
    S_AXI_ARUSER = 16
   
    M_AXI_AWADDR = 40
    M_AXI_AWID = 16
    M_AXI_AWLEN = 8
    M_AXI_AWSIZE = 3
    M_AXI_AWBURST = 2
    M_AXI_AWLOCK = 1
    M_AXI_AWCACHE = 4
    M_AXI_AWPROT = 3
    M_AXI_AWQOS = 4
    M_AXI_WDATA = 128
    M_AXI_WSTRB = 16
    M_AXI_WID = 16
    M_AXI_BRESP = 2
    M_AXI_BID = 16
    M_AXI_ARADDR = 40
    M_AXI_ARID = 16
    M_AXI_ARLEN = 8
    M_AXI_ARSIZE = 3
    M_AXI_ARBURST = 2
    M_AXI_ARLOCK = 1
    M_AXI_ARCACHE = 4
    M_AXI_ARPROT = 3
    M_AXI_ARQOS = 4
    M_AXI_RDATA = 128
    M_AXI_RRESP = 2
    M_AXI_RID = 16
    M_AXI_AWUSER = 16
    M_AXI_ARUSER = 16
)
(
    input wire                     s_axi_aclk;    // Clock
    input wire                     s_axi_aresetn; // Active low reset
    
    ////////////////////////////////////////////////////////////
    // Slave Write Adress
    ////////////////////////////////////////////////////////////
    input wire [S_AXI_AWADDR-1:0] s_axi_awaddr; // Write address
    input wire [S_AXI_AWID-1:0]   s_axi_awid;   // Write ID
    input wire [S_AXI_AWLEN-1:0]  s_axi_awlen;  // Burst length
    input wire                     s_axi_awvalid; // Write address valid
    output wire                    s_axi_awready; // Write address ready
    input wire [S_AXI_AWSIZE-1:0] s_axi_awsize; // Burst size
    input wire [S_AXI_AWBURST-1:0] s_axi_awburst; // Burst type
    input wire [S_AXI_AWLOCK-1:0] s_axi_awlock; // Lock signal
    input wire [S_AXI_AWCACHE-1:0] s_axi_awcache; // Cache type
    input wire [S_AXI_AWPROT-1:0] s_axi_awprot; // Protection type
    input wire [S_AXI_AWQOS-1:0]  s_axi_awqos;  // Quality of service
    input wire [S_AXI_AWUSER-1:0] s_axi_awuser;
    
    /////////////////////////////////////////////////////////////
    // Slave Write Data
    /////////////////////////////////////////////////////////////
    input wire [S_AXI_WDATA-1:0] s_axi_wdata;   // Write data
    input wire [S_AXI_WSTRB-1:0] s_axi_wstrb;   // Write strobes
    input wire                     s_axi_wvalid;  // Write valid
    output wire                    s_axi_wready;  // Write ready
    input wire [S_AXI_WID-1:0]   s_axi_wid;    // Write ID (if used)
    
    /////////////////////////////////////////////////////////////
    // Slave Write Response
    /////////////////////////////////////////////////////////////
    output wire [S_AXI_BRESP-1:0] s_axi_bresp;   // Write response
    output wire [S_AXI_BID-1:0]   s_axi_bid;     // Response ID (if used)
    output wire                    s_axi_bvalid;  // Response valid
    input wire                     s_axi_bready;  // Response ready
    
    /////////////////////////////////////////////////////////////
    // Slave Read Adress
    /////////////////////////////////////////////////////////////
    input wire [S_AXI_ARADDR-1:0] s_axi_araddr;  // Read address
    input wire [S_AXI_ARID-1:0]   s_axi_arid;    // Read ID
    input wire [S_AXI_ARLEN-1:0]  s_axi_arlen;   // Burst length
    input wire                     s_axi_arvalid; // Read address valid
    output wire                    s_axi_arready; // Read address ready
    input wire [S_AXI_ARSIZE-1:0] s_axi_arsize;  // Burst size
    input wire [S_AXI_ARBURST-1:0] s_axi_arburst; // Burst type
    input wire [S_AXI_ARLOCK-1:0] s_axi_arlock;  // Lock signal
    input wire [S_AXI_ARCACHE-1:0] s_axi_arcache; // Cache type
    input wire [S_AXI_ARPROT-1:0] s_axi_arprot;  // Protection type
    input wire [S_AXI_ARQOS-1:0]  s_axi_arqos;   // Quality of service
    input wire [S_AXI_ARUSER-1:0] s_axi_aruser;
    
    /////////////////////////////////////////////////////////////
    // Slave Read Data
    /////////////////////////////////////////////////////////////
    output wire [S_AXI_RDATA-1:0] s_axi_rdata;   // Read data
    output wire [S_AXI_RRESP-1:0] s_axi_rresp;   // Read response
    output wire [S_AXI_RID-1:0]   s_axi_rid;     // Read ID (if used)
    output wire                    s_axi_rvalid;  // Read valid
    input wire                     s_axi_rready;  // Read ready

    ////////////////////////////////////////////////////////////
    // Master Write Adress
    ////////////////////////////////////////////////////////////
    output wire [M_AXI_AWADDR-1:0] m_axi_awaddr; // Write address
    output wire [M_AXI_AWID-1:0]   m_axi_awid;   // Write ID
    output wire [M_AXI_AWLEN-1:0]  m_axi_awlen;  // Burst length
    output wire                     m_axi_awvalid; // Write address valid
    input wire                    m_axi_awready; // Write address ready
    output wire [M_AXI_AWSIZE-1:0] m_axi_awsize; // Burst size
    output wire [M_AXI_AWBURST-1:0] m_axi_awburst; // Burst type
    output wire [M_AXI_AWLOCK-1:0] m_axi_awlock; // Lock signal
    output wire [M_AXI_AWCACHE-1:0] m_axi_awcache; // Cache type
    output wire [M_AXI_AWPROT-1:0] m_axi_awprot; // Protection type
    output wire [M_AXI_AWQOS-1:0]  m_axi_awqos;  // Quality of service
    output wire [M_AXI_AWUSER-1:0] m_axi_awuser;

    /////////////////////////////////////////////////////////////
    // Master Write Data
    /////////////////////////////////////////////////////////////
    output wire [M_AXI_WDATA-1:0] m_axi_wdata;   // Write data
    output wire [M_AXI_WSTRB-1:0] m_axi_wstrb;   // Write strobes
    output wire                     m_axi_wvalid;  // Write valid
    input wire                    m_axi_wready;  // Write ready
    output wire [M_AXI_WID-1:0]   m_axi_wid;    // Write ID (if used)

    /////////////////////////////////////////////////////////////
    // Master Write Response
    /////////////////////////////////////////////////////////////
    input wire [M_AXI_BRESP-1:0] m_axi_bresp;   // Write response
    input wire [M_AXI_BID-1:0]   m_axi_bid;     // Response ID (if used)
    input wire                    m_axi_bvalid;  // Response valid
    output wire                     m_axi_bready;  // Response ready

    /////////////////////////////////////////////////////////////
    // Master Read Adress
    /////////////////////////////////////////////////////////////
    output wire [M_AXI_ARADDR-1:0] m_axi_araddr;  // Read address
    output wire [M_AXI_ARID-1:0]   m_axi_arid;    // Read ID
    output wire [M_AXI_ARLEN-1:0]  m_axi_arlen;   // Burst length
    output wire                     m_axi_arvalid; // Read address valid
    input wire                    m_axi_arready; // Read address ready
    output wire [M_AXI_ARSIZE-1:0] m_axi_arsize;  // Burst size
    output wire [M_AXI_ARBURST-1:0] m_axi_arburst; // Burst type
    output wire [M_AXI_ARLOCK-1:0] m_axi_arlock;  // Lock signal
    output wire [M_AXI_ARCACHE-1:0] m_axi_arcache; // Cache type
    output wire [M_AXI_ARPROT-1:0] m_axi_arprot;  // Protection type
    output wire [M_AXI_ARQOS-1:0]  m_axi_arqos;   // Quality of service
    output wire [M_AXI_ARUSER-1:0] m_axi_aruser;

    /////////////////////////////////////////////////////////////
    // Master Read Data
    /////////////////////////////////////////////////////////////
    input wire [M_AXI_RDATA-1:0] m_axi_rdata;   // Read data
    input wire [M_AXI_RRESP-1:0] m_axi_rresp;   // Read response
    input wire [M_AXI_RID-1:0]   m_axi_rid;     // Read ID (if used)
    input wire                    m_axi_rvalid;  // Read valid
    output wire                     m_axi_rready;  // Read ready
);

reg                    s_axi_awready_buffer; // Write address ready
reg                    s_axi_wready_buffer;  // Write ready
reg [S_AXI_BRESP-1:0] s_axi_bresp_buffer;   // Write response
reg [S_AXI_BID-1:0]   s_axi_bid_buffer;     // Response ID (if used)
reg                    s_axi_bvalid_buffer;  // Response valid
reg                    s_axi_arready_buffer; // Read address ready
reg [S_AXI_RDATA-1:0] s_axi_rdata_buffer;   // Read data
reg [S_AXI_RRESP-1:0] s_axi_rresp_buffer;   // Read response
reg [S_AXI_RID-1:0]   s_axi_rid_buffer;     // Read ID (if used)
reg                    s_axi_rvalid_buffer;  // Read valid
reg [M_AXI_AWADDR-1:0] m_axi_awaddr_buffer; // Write address
reg [M_AXI_AWID-1:0]   m_axi_awid_buffer;   // Write ID
reg [M_AXI_AWLEN-1:0]  m_axi_awlen_buffer;  // Burst length
reg                     m_axi_awvalid_buffer; // Write address valid
reg [M_AXI_AWSIZE-1:0] m_axi_awsize_buffer; // Burst size
reg [M_AXI_AWBURST-1:0] m_axi_awburst_buffer; // Burst type
reg [M_AXI_AWLOCK-1:0] m_axi_awlock_buffer; // Lock signal
reg [M_AXI_AWCACHE-1:0] m_axi_awcache_buffer; // Cache type
reg [M_AXI_AWPROT-1:0] m_axi_awprot_buffer; // Protection type
reg [M_AXI_AWQOS-1:0]  m_axi_awqos_buffer;  // Quality of service
reg [M_AXI_WDATA-1:0] m_axi_wdata_buffer;   // Write data
reg [M_AXI_WSTRB-1:0] m_axi_wstrb_buffer;   // Write strobes
reg                     m_axi_wvalid_buffer;  // Write valid
reg [M_AXI_WID-1:0]   m_axi_wid_buffer;    // Write ID (if used)
reg                     m_axi_bready_buffer;  // Response ready
reg [M_AXI_ARADDR-1:0] m_axi_araddr_buffer;  // Read address
reg [M_AXI_ARID-1:0]   m_axi_arid_buffer;    // Read ID
reg [M_AXI_ARLEN-1:0]  m_axi_arlen_buffer;   // Burst length
reg                     m_axi_arvalid_buffer; // Read address valid
reg [M_AXI_ARSIZE-1:0] m_axi_arsize_buffer;  // Burst size
reg [M_AXI_ARBURST-1:0] m_axi_arburst_buffer; // Burst type
reg [M_AXI_ARLOCK-1:0] m_axi_arlock_buffer;  // Lock signal
reg [M_AXI_ARCACHE-1:0] m_axi_arcache_buffer; // Cache type
reg [M_AXI_ARPROT-1:0] m_axi_arprot_buffer;  // Protection type
reg [M_AXI_ARQOS-1:0]  m_axi_arqos_buffer;   // Quality of service
reg                     m_axi_rready_buffer;  // Read ready
reg [M_AXI_AWUSER-1:0] m_axi_awuser_buffer;
reg [M_AXI_ARUSER-1:0] m_axi_aruser_buffer;

always@(posedge s_axi_aclk) begin
    if( s_axi_aresetn == 1'b0 ) begin
        s_axi_awready_buffer     <= 1'b0;
        s_axi_wready_buffer      <= 1'b0;
        s_axi_bresp_buffer       <= {S_AXI_BRESP{1'b0}};
        s_axi_bid_buffer         <= {S_AXI_BID{1'b0}};
        s_axi_bvalid_buffer      <= 1'b0;
        s_axi_arready_buffer     <= 1'b0;
        s_axi_rdata_buffer       <= {S_AXI_RDATA{1'b0}};
        s_axi_rresp_buffer       <= {S_AXI_RRESP{1'b0}};
        s_axi_rid_buffer         <= {S_AXI_RID{1'b0}};
        s_axi_rvalid_buffer      <= 1'b0;
        m_axi_awaddr_buffer      <= {M_AXI_AWADDR{1'b0}};
        m_axi_awid_buffer        <= {M_AXI_AWID{1'b0}};
        m_axi_awlen_buffer       <= {M_AXI_AWLEN{1'b0}};
        m_axi_awvalid_buffer     <= 1'b0;
        m_axi_awsize_buffer      <= {M_AXI_AWSIZE{1'b0}};
        m_axi_awburst_buffer     <= {M_AXI_AWBURST{1'b0}};
        m_axi_awlock_buffer      <= {M_AXI_AWLOCK{1'b0}};
        m_axi_awcache_buffer     <= {M_AXI_AWCACHE{1'b0}};
        m_axi_awprot_buffer      <= {M_AXI_AWPROT{1'b0}};
        m_axi_awqos_buffer       <= {M_AXI_AWQOS{1'b0}};
        m_axi_wdata_buffer       <= {M_AXI_WDATA{1'b0}};
        m_axi_wstrb_buffer       <= {M_AXI_WSTRB{1'b0}};
        m_axi_wvalid_buffer      <= 1'b0;
        m_axi_wid_buffer         <= {M_AXI_WID{1'b0}};
        m_axi_bready_buffer      <= 1'b0;
        m_axi_araddr_buffer      <= {M_AXI_ARADDR{1'b0}};
        m_axi_arid_buffer        <= {M_AXI_ARID{1'b0}};
        m_axi_arlen_buffer       <= {M_AXI_ARLEN{1'b0}};
        m_axi_arvalid_buffer     <= 1'b0;
        m_axi_arsize_buffer      <= {M_AXI_ARSIZE{1'b0}};
        m_axi_arburst_buffer     <= {M_AXI_ARBURST{1'b0}};
        m_axi_arlock_buffer      <= {M_AXI_ARLOCK{1'b0}};
        m_axi_arcache_buffer     <= {M_AXI_ARCACHE{1'b0}};
        m_axi_arprot_buffer      <= {M_AXI_ARPROT{1'b0}};
        m_axi_arqos_buffer       <= {M_AXI_ARQOS{1'b0}};
        m_axi_rready_buffer      <= 1'b0;
        m_axi_awuser_buffer      <= {M_AXI_AWUSER{1'b0}};
        m_axi_aruser_buffer      <= {M_AXI_ARUSER{1'b0}};
    end

    else begin
        s_axi_awready_buffer     <= s_axi_awready;
        s_axi_wready_buffer      <= s_axi_wready;
        s_axi_bresp_buffer       <= s_axi_bresp;
        s_axi_bid_buffer         <= s_axi_bid;
        s_axi_bvalid_buffer      <= s_axi_bvalid;
        s_axi_arready_buffer     <= s_axi_arready;
        s_axi_rdata_buffer       <= s_axi_rdata;
        s_axi_rresp_buffer       <= s_axi_rresp;
        s_axi_rid_buffer         <= s_axi_rid;
        s_axi_rvalid_buffer      <= s_axi_rvalid;
        m_axi_awaddr_buffer      <= s_axi_awaddr;
        m_axi_awid_buffer        <= s_axi_awid;
        m_axi_awlen_buffer       <= s_axi_awlen;
        m_axi_awvalid_buffer     <= s_axi_awvalid;
        m_axi_awsize_buffer      <= s_axi_awsize;
        m_axi_awburst_buffer     <= s_axi_awburst;
        m_axi_awlock_buffer      <= s_axi_awlock;
        m_axi_awcache_buffer     <= s_axi_awcache;
        m_axi_awprot_buffer      <= s_axi_awprot;
        m_axi_awqos_buffer       <= s_axi_awqos;
        m_axi_wdata_buffer       <= s_axi_wdata;
        m_axi_wstrb_buffer       <= s_axi_wstrb;
        m_axi_wvalid_buffer      <= s_axi_wvalid;
        m_axi_wid_buffer         <= s_axi_wid;
        m_axi_bready_buffer      <= s_axi_bready;
        m_axi_araddr_buffer      <= s_axi_araddr;
        m_axi_arid_buffer        <= s_axi_arid;
        m_axi_arlen_buffer       <= s_axi_arlen;
        m_axi_arvalid_buffer     <= s_axi_arvalid;
        m_axi_arsize_buffer      <= s_axi_arsize;
        m_axi_arburst_buffer     <= s_axi_arburst;
        m_axi_arlock_buffer      <= s_axi_arlock;
        m_axi_arcache_buffer     <= s_axi_arcache;
        m_axi_arprot_buffer      <= s_axi_arprot;
        m_axi_arqos_buffer       <= s_axi_arqos;
        m_axi_rready_buffer      <= s_axi_rready;
        m_axi_awuser_buffer      <= s_axi_awuser;
        m_axi_aruser_buffer      <= s_axi_aruser;
    end
end


endmodule
