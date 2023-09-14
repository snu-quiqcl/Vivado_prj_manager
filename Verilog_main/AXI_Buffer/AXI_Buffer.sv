module AXI_Buffer
#(
    S_AXI_AWADDR = 40,
    S_AXI_AWID = 16,
    S_AXI_AWLEN = 8,
    S_AXI_AWSIZE = 3,
    S_AXI_AWBURST = 2,
    S_AXI_AWLOCK = 1,
    S_AXI_AWCACHE = 4,
    S_AXI_AWPROT = 3,
    S_AXI_AWQOS = 4,
    S_AXI_WDATA = 128,
    S_AXI_WSTRB = 16,
    S_AXI_WID = 16,
    S_AXI_BRESP = 2,
    S_AXI_BID = 16,
    S_AXI_ARADDR = 40,
    S_AXI_ARID = 16,
    S_AXI_ARLEN = 8,
    S_AXI_ARSIZE = 3,
    S_AXI_ARBURST = 2,
    S_AXI_ARLOCK = 1,
    S_AXI_ARCACHE = 4,
    S_AXI_ARPROT = 3,
    S_AXI_ARQOS = 4,
    S_AXI_RDATA = 128,
    S_AXI_RRESP = 2,
    S_AXI_RID = 16,
    S_AXI_AWUSER = 16,
    S_AXI_ARUSER = 16,
    M_AXI_AWADDR = 40,
    M_AXI_AWID = 16,
    M_AXI_AWLEN = 8,
    M_AXI_AWSIZE = 3,
    M_AXI_AWBURST = 2,
    M_AXI_AWLOCK = 1,
    M_AXI_AWCACHE = 4,
    M_AXI_AWPROT = 3,
    M_AXI_AWQOS = 4,
    M_AXI_WDATA = 128,
    M_AXI_WSTRB = 16,
    M_AXI_WID = 16,
    M_AXI_BRESP = 2,
    M_AXI_BID = 16,
    M_AXI_ARADDR = 40,
    M_AXI_ARID = 16,
    M_AXI_ARLEN = 8,
    M_AXI_ARSIZE = 3,
    M_AXI_ARBURST = 2,
    M_AXI_ARLOCK = 1,
    M_AXI_ARCACHE = 4,
    M_AXI_ARPROT = 3,
    M_AXI_ARQOS = 4,
    M_AXI_RDATA = 128,
    M_AXI_RRESP = 2,
    M_AXI_RID = 16,
    M_AXI_AWUSER = 16,
    M_AXI_ARUSER = 16
)
(
    input wire                      s_axi_aclk,    // Clock
    input wire                      m_axi_aclk,    // Dummy
    input wire                      s_axi_aresetn, // Active low reset
    input wire                      m_axi_aresetn, // Dummy

    ////////////////////////////////////////////////////////////
    // Slave Write Adress
    ////////////////////////////////////////////////////////////
    input wire [S_AXI_AWADDR-1:0]   s_axi_awaddr, // Write address
    input wire [S_AXI_AWID-1:0]     s_axi_awid,   // Write ID
    input wire [S_AXI_AWLEN-1:0]    s_axi_awlen,  // Burst length
    input wire                      s_axi_awvalid, // Write address valid
    output reg                      s_axi_awready, // Write address ready
    input wire [S_AXI_AWSIZE-1:0]   s_axi_awsize, // Burst size
    input wire [S_AXI_AWBURST-1:0]  s_axi_awburst, // Burst type
    input wire [S_AXI_AWLOCK-1:0]   s_axi_awlock, // Lock signal
    input wire [S_AXI_AWCACHE-1:0]  s_axi_awcache, // Cache type
    input wire [S_AXI_AWPROT-1:0]   s_axi_awprot, // Protection type
    input wire [S_AXI_AWQOS-1:0]    s_axi_awqos,  // Quality of service
    input wire [S_AXI_AWUSER-1:0]   s_axi_awuser,

    /////////////////////////////////////////////////////////////
    // Slave Write Data
    /////////////////////////////////////////////////////////////
    input wire [S_AXI_WDATA-1:0]    s_axi_wdata,   // Write data
    input wire [S_AXI_WSTRB-1:0]    s_axi_wstrb,   // Write strobes
    input wire                      s_axi_wvalid,  // Write valid
    output reg                      s_axi_wready,  // Write ready
    input wire [S_AXI_WID-1:0]      s_axi_wid,    // Write ID (if used)

    /////////////////////////////////////////////////////////////
    // Slave Write Response
    /////////////////////////////////////////////////////////////
    output reg [S_AXI_BRESP-1:0]    s_axi_bresp,   // Write response
    output reg [S_AXI_BID-1:0]      s_axi_bid,     // Response ID (if used)
    output reg                      s_axi_bvalid,  // Response valid
    input wire                      s_axi_bready,  // Response ready

    /////////////////////////////////////////////////////////////
    // Slave Read Adress
    /////////////////////////////////////////////////////////////
    input wire [S_AXI_ARADDR-1:0]   s_axi_araddr,  // Read address
    input wire [S_AXI_ARID-1:0]     s_axi_arid,    // Read ID
    input wire [S_AXI_ARLEN-1:0]    s_axi_arlen,   // Burst length
    input wire                      s_axi_arvalid, // Read address valid
    output reg                      s_axi_arready, // Read address ready
    input wire [S_AXI_ARSIZE-1:0]   s_axi_arsize,  // Burst size
    input wire [S_AXI_ARBURST-1:0]  s_axi_arburst, // Burst type
    input wire [S_AXI_ARLOCK-1:0]   s_axi_arlock,  // Lock signal
    input wire [S_AXI_ARCACHE-1:0]  s_axi_arcache, // Cache type
    input wire [S_AXI_ARPROT-1:0]   s_axi_arprot,  // Protection type
    input wire [S_AXI_ARQOS-1:0]    s_axi_arqos,   // Quality of service
    input wire [S_AXI_ARUSER-1:0]   s_axi_aruser,

    /////////////////////////////////////////////////////////////
    // Slave Read Data
    /////////////////////////////////////////////////////////////
    output reg [S_AXI_RDATA-1:0]    s_axi_rdata,   // Read data
    output reg [S_AXI_RRESP-1:0]    s_axi_rresp,   // Read response
    output reg [S_AXI_RID-1:0]      s_axi_rid,     // Read ID (if used)
    output reg                      s_axi_rvalid,  // Read valid
    input wire                      s_axi_rready,  // Read ready

    ////////////////////////////////////////////////////////////
    // Master Write Adress
    ////////////////////////////////////////////////////////////
    output reg [M_AXI_AWADDR-1:0]   m_axi_awaddr, // Write address
    output reg [M_AXI_AWID-1:0]     m_axi_awid,   // Write ID
    output reg [M_AXI_AWLEN-1:0]    m_axi_awlen,  // Burst length
    output reg                      m_axi_awvalid, // Write address valid
    input wire                      m_axi_awready, // Write address ready
    output reg [M_AXI_AWSIZE-1:0]   m_axi_awsize, // Burst size
    output reg [M_AXI_AWBURST-1:0]  m_axi_awburst, // Burst type
    output reg [M_AXI_AWLOCK-1:0]   m_axi_awlock, // Lock signal
    output reg [M_AXI_AWCACHE-1:0]  m_axi_awcache, // Cache type
    output reg [M_AXI_AWPROT-1:0]   m_axi_awprot, // Protection type
    output reg [M_AXI_AWQOS-1:0]    m_axi_awqos,  // Quality of service
    output reg [M_AXI_AWUSER-1:0]   m_axi_awuser,

    /////////////////////////////////////////////////////////////
    // Master Write Data
    /////////////////////////////////////////////////////////////
    output reg [M_AXI_WDATA-1:0]    m_axi_wdata,   // Write data
    output reg [M_AXI_WSTRB-1:0]    m_axi_wstrb,   // Write strobes
    output reg                      m_axi_wvalid,  // Write valid
    input wire                      m_axi_wready,  // Write ready
    output reg [M_AXI_WID-1:0]      m_axi_wid,    // Write ID (if used)

    /////////////////////////////////////////////////////////////
    // Master Write Response
    /////////////////////////////////////////////////////////////
    input wire [M_AXI_BRESP-1:0]    m_axi_bresp,   // Write response
    input wire [M_AXI_BID-1:0]      m_axi_bid,     // Response ID (if used)
    input wire                      m_axi_bvalid,  // Response valid
    output reg                      m_axi_bready,  // Response ready

    /////////////////////////////////////////////////////////////
    // Master Read Adress
    /////////////////////////////////////////////////////////////
    output reg [M_AXI_ARADDR-1:0]   m_axi_araddr,  // Read address
    output reg [M_AXI_ARID-1:0]     m_axi_arid,    // Read ID
    output reg [M_AXI_ARLEN-1:0]    m_axi_arlen,   // Burst length
    output reg                      m_axi_arvalid, // Read address valid
    input wire                      m_axi_arready, // Read address ready
    output reg [M_AXI_ARSIZE-1:0]   m_axi_arsize,  // Burst size
    output reg [M_AXI_ARBURST-1:0]  m_axi_arburst, // Burst type
    output reg [M_AXI_ARLOCK-1:0]   m_axi_arlock,  // Lock signal
    output reg [M_AXI_ARCACHE-1:0]  m_axi_arcache, // Cache type
    output reg [M_AXI_ARPROT-1:0]   m_axi_arprot,  // Protection type
    output reg [M_AXI_ARQOS-1:0]    m_axi_arqos,   // Quality of service
    output reg [M_AXI_ARUSER-1:0]   m_axi_aruser,

    /////////////////////////////////////////////////////////////
    // Master Read Data
    /////////////////////////////////////////////////////////////
    input wire [M_AXI_RDATA-1:0]    m_axi_rdata,   // Read data
    input wire [M_AXI_RRESP-1:0]    m_axi_rresp,   // Read response
    input wire [M_AXI_RID-1:0]      m_axi_rid,     // Read ID (if used)
    input wire                      m_axi_rvalid,  // Read valid
    output reg                      m_axi_rready  // Read ready
);

always@(posedge s_axi_aclk) begin
    if( s_axi_aresetn == 1'b0 ) begin
        s_axi_awready     <= 1'b0;
        s_axi_wready      <= 1'b0;
        s_axi_bresp       <= {S_AXI_BRESP{1'b0}};
        s_axi_bid         <= {S_AXI_BID{1'b0}};
        s_axi_bvalid      <= 1'b0;
        s_axi_arready     <= 1'b0;
        s_axi_rdata       <= {S_AXI_RDATA{1'b0}};
        s_axi_rresp       <= {S_AXI_RRESP{1'b0}};
        s_axi_rid         <= {S_AXI_RID{1'b0}};
        s_axi_rvalid      <= 1'b0;
        m_axi_awaddr      <= {M_AXI_AWADDR{1'b0}};
        m_axi_awid        <= {M_AXI_AWID{1'b0}};
        m_axi_awlen       <= {M_AXI_AWLEN{1'b0}};
        m_axi_awvalid     <= 1'b0;
        m_axi_awsize      <= {M_AXI_AWSIZE{1'b0}};
        m_axi_awburst     <= {M_AXI_AWBURST{1'b0}};
        m_axi_awlock      <= {M_AXI_AWLOCK{1'b0}};
        m_axi_awcache     <= {M_AXI_AWCACHE{1'b0}};
        m_axi_awprot      <= {M_AXI_AWPROT{1'b0}};
        m_axi_awqos       <= {M_AXI_AWQOS{1'b0}};
        m_axi_wdata       <= {M_AXI_WDATA{1'b0}};
        m_axi_wstrb       <= {M_AXI_WSTRB{1'b0}};
        m_axi_wvalid      <= 1'b0;
        m_axi_wid         <= {M_AXI_WID{1'b0}};
        m_axi_bready      <= 1'b0;
        m_axi_araddr      <= {M_AXI_ARADDR{1'b0}};
        m_axi_arid        <= {M_AXI_ARID{1'b0}};
        m_axi_arlen       <= {M_AXI_ARLEN{1'b0}};
        m_axi_arvalid     <= 1'b0;
        m_axi_arsize      <= {M_AXI_ARSIZE{1'b0}};
        m_axi_arburst     <= {M_AXI_ARBURST{1'b0}};
        m_axi_arlock      <= {M_AXI_ARLOCK{1'b0}};
        m_axi_arcache     <= {M_AXI_ARCACHE{1'b0}};
        m_axi_arprot      <= {M_AXI_ARPROT{1'b0}};
        m_axi_arqos       <= {M_AXI_ARQOS{1'b0}};
        m_axi_rready      <= 1'b0;
        m_axi_awuser      <= {M_AXI_AWUSER{1'b0}};
        m_axi_aruser      <= {M_AXI_ARUSER{1'b0}};
    end

    else begin
        s_axi_awready     <= m_axi_awready;
        s_axi_wready      <= m_axi_wready;
        s_axi_bresp       <= m_axi_bresp;
        s_axi_bid         <= m_axi_bid;
        s_axi_bvalid      <= m_axi_bvalid;
        s_axi_arready     <= m_axi_arready;
        s_axi_rdata       <= m_axi_rdata;
        s_axi_rresp       <= m_axi_rresp;
        s_axi_rid         <= m_axi_rid;
        s_axi_rvalid      <= m_axi_rvalid;
        m_axi_awaddr      <= s_axi_awaddr;
        m_axi_awid        <= s_axi_awid;
        m_axi_awlen       <= s_axi_awlen;
        m_axi_awvalid     <= s_axi_awvalid;
        m_axi_awsize      <= s_axi_awsize;
        m_axi_awburst     <= s_axi_awburst;
        m_axi_awlock      <= s_axi_awlock;
        m_axi_awcache     <= s_axi_awcache;
        m_axi_awprot      <= s_axi_awprot;
        m_axi_awqos       <= s_axi_awqos;
        m_axi_wdata       <= s_axi_wdata;
        m_axi_wstrb       <= s_axi_wstrb;
        m_axi_wvalid      <= s_axi_wvalid;
        m_axi_wid         <= s_axi_wid;
        m_axi_bready      <= s_axi_bready;
        m_axi_araddr      <= s_axi_araddr;
        m_axi_arid        <= s_axi_arid;
        m_axi_arlen       <= s_axi_arlen;
        m_axi_arvalid     <= s_axi_arvalid;
        m_axi_arsize      <= s_axi_arsize;
        m_axi_arburst     <= s_axi_arburst;
        m_axi_arlock      <= s_axi_arlock;
        m_axi_arcache     <= s_axi_arcache;
        m_axi_arprot      <= s_axi_arprot;
        m_axi_arqos       <= s_axi_arqos;
        m_axi_rready      <= s_axi_rready;
        m_axi_awuser      <= s_axi_awuser;
        m_axi_aruser      <= s_axi_aruser;
    end
end


endmodule
