`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/18 16:37:21
// Design Name: 
// Module Name: AXI2FIFO
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


module AXI2FIFO
#(
    //////////////////////////////////////////////////////////////////////////////////
    // AXI4 Configuraiton
    //////////////////////////////////////////////////////////////////////////////////
    parameter AXI_ADDR_WIDTH = 6,
    parameter AXI_DATA_WIDTH = 128,
    parameter AXI_STROBE_WIDTH = AXI_DATA_WIDTH >> 3,
    parameter AXI_STROBE_LEN = 4 // LOG(AXI_STROBE_WDITH)
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
    output reg [1:0] s_axi_bresp,
    output reg s_axi_bvalid,
    output reg [15:0] s_axi_bid, // added to resolve wrapping error
    
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
    output reg [15:0] s_axi_rid,
    
    //////////////////////////////////////////////////////////////////////////////////
    // AXI4 Data Read
    //////////////////////////////////////////////////////////////////////////////////
    input wire s_axi_rready,
    output reg [AXI_DATA_WIDTH - 1:0] s_axi_rdata,
    output reg [1:0] s_axi_rresp,
    output reg s_axi_rvalid,
    output reg s_axi_rlast,
    
    //////////////////////////////////////////////////////////////////////////////////
    // AXI4 Clock
    //////////////////////////////////////////////////////////////////////////////////
    input wire s_axi_aclk,
    
    //////////////////////////////////////////////////////////////////////////////////
    // AXI4 Reset
    //////////////////////////////////////////////////////////////////////////////////
    input wire s_axi_aresetn,
    
    //////////////////////////////////////////////////////////////////////////////////
    // RTO_Core interface
    //////////////////////////////////////////////////////////////////////////////////
    output reg rto_core_reset,
    output reg rto_core_flush,
    output reg rto_core_write,
    output reg [127:0] rto_core_fifo_din,
    
    input wire rto_core_full,
    input wire rto_core_empty,
    
    //////////////////////////////////////////////////////////////////////////////////
    // DAC_mode
    //////////////////////////////////////////////////////////////////////////////////
    output reg dac_mode
);

//////////////////////////////////////////////////////////////////////////////////
// AXI4 Address Space
//////////////////////////////////////////////////////////////////////////////////
parameter AXI_WRITE_FIFO = {AXI_ADDR_WIDTH{1'b0}};
parameter AXI_FLUSH_FIFO = {AXI_ADDR_WIDTH{1'b0}} + 6'h10;
parameter AXI_DAC_MODE = {AXI_ADDR_WIDTH{1'b0}} + 6'h20;

//////////////////////////////////////////////////////////////////////////////////
// AXI4 Write, Read FSM State & reg definition
//////////////////////////////////////////////////////////////////////////////////

parameter IDLE = 4'h0;
parameter WRITE_ADDRESS = 4'h1;
parameter WRITE_DATA_WRITE_FIFO = 4'h2;
parameter WRITE_DATA_FLUSH_FIFO = 4'h3;
parameter ERROR_STATE = 4'h4;
parameter WRITE_RESPONSE = 4'h5;
parameter WRITE_DAC_MODE = 4'h6;

parameter READ_ADDRESS = 4'h1;
parameter READ_DATA = 4'h2;

reg[3:0] axi_state_write;
reg[3:0] axi_state_read;

//////////////////////////////////////////////////////////////////////////////////
// AXI Data Buffer
//////////////////////////////////////////////////////////////////////////////////
reg [AXI_ADDR_WIDTH - 1:0] axi_waddr;
reg [AXI_ADDR_WIDTH - 1:0] axi_waddr_base;
reg [7:0] axi_wlen;
reg [7:0] axi_wlen_counter;
reg [2:0] axi_wsize;
reg [7:0] axi_wshift_size;
reg [7:0] axi_wshift_count;
reg [AXI_STROBE_LEN - 1:0] axi_wunaligned_data_num;
reg [AXI_STROBE_LEN - 1:0] axi_wunaligned_count;
reg [1:0] axi_wburst;

reg [AXI_DATA_WIDTH - 1:0] axi_wdata;
reg [AXI_STROBE_WIDTH - 1:0] axi_wstrb;
reg axi_wvalid;
reg [15:0] axi_awid;
reg [15:0] axi_awuser;
reg axi_wlast;

//////////////////////////////////////////////////////////////////////////////////
// AXI4 FSM State initialization
// For simulation, each state was initiated to IDLE state.
//////////////////////////////////////////////////////////////////////////////////

initial begin
    axi_state_write <= IDLE;
    axi_state_read <= IDLE;
end

//////////////////////////////////////////////////////////////////////////////////
// AXI4 Output Assign Logic
//////////////////////////////////////////////////////////////////////////////////

assign s_axi_awready = (axi_state_write == IDLE);
assign s_axi_wready = ((axi_state_write == WRITE_DATA_WRITE_FIFO) && (rto_core_full == 1'b0)) || (axi_state_write == WRITE_DATA_FLUSH_FIFO);
assign s_axi_arready = (axi_state_read == IDLE);

//////////////////////////////////////////////////////////////////////////////////
// AXI4 Write FSM
// In AXI write, wlast signal has to be actived to end sending data. Only sending
// length of AXI signal does not work.
//////////////////////////////////////////////////////////////////////////////////

always @(posedge s_axi_aclk) begin
    if( s_axi_aresetn == 1'b0 ) begin
        axi_state_write <= IDLE;
        s_axi_bresp <= 2'b0;
        s_axi_bvalid <= 1'b0;
        axi_waddr <= {AXI_ADDR_WIDTH{1'b0}};
        axi_waddr_base <= {AXI_ADDR_WIDTH{1'b0}};
        axi_wlen <= 8'h0;
        axi_wsize <= 3'h0;
        axi_wburst <= 2'h0;
        axi_wlen_counter <= 8'h0;
        axi_wunaligned_data_num <= 4'h0;
        axi_wunaligned_count <= 4'h0;
        axi_wshift_size <= 8'h0;
        axi_wshift_count <= 8'h0;
        s_axi_bid <= 16'h0; // id value
        rto_core_fifo_din <= 128'h0;
        rto_core_flush <= 1'b0;
        axi_awid <= 16'h0;
        axi_awuser <= 16'h0;
        dac_mode <= 1'b0;
    end
    
    else begin
        case(axi_state_write)
            IDLE: begin
                s_axi_bid <= 16'h0; // id value
                rto_core_write <= 1'b0;
                rto_core_flush <= 1'b0;
                rto_core_fifo_din <= 128'h0;
                s_axi_bresp <= 2'b0;
                s_axi_bvalid <= 1'b0;
                axi_awuser <= 16'h0;
                axi_awid <= 16'h0;
                
                if( s_axi_awvalid == 1'b1 ) begin
                    axi_waddr <= {AXI_ADDR_WIDTH{1'b0}};
                    axi_waddr_base <= {AXI_ADDR_WIDTH{1'b0}};
                    axi_wlen <= 8'h0;
                    axi_wsize <= 3'h0;
                    axi_wburst <= 2'h0;
                    axi_wlen_counter <= 8'h0;
                    axi_wunaligned_data_num <= 4'h0;
                    axi_wunaligned_count <= 4'h0;
                    axi_wshift_size <= 8'h0;
                    axi_wshift_count <= 8'h0;
                    
                    if( s_axi_awaddr == AXI_WRITE_FIFO ) begin
                        axi_waddr <= s_axi_awaddr;
                        axi_waddr_base <= s_axi_awaddr;
                        axi_wlen <= s_axi_awlen;
                        axi_wsize <= s_axi_awsize;
                        axi_wburst <= s_axi_awburst;
                        axi_wlen_counter <= s_axi_awlen;
                        axi_wshift_size <= 8'h1 << s_axi_awsize;
                        axi_wshift_count <= 8'h0;
                        axi_awuser <= s_axi_awuser;
                        axi_awid <= s_axi_awid;
                        
                        if( rto_core_full == 1'b0 ) begin
                            axi_state_write <= WRITE_DATA_WRITE_FIFO;
                        end
                        
                        else begin
                            axi_state_write <= WRITE_DATA_WRITE_FIFO;
                        end
                    end
                    
                    else if( s_axi_awaddr == AXI_FLUSH_FIFO ) begin
                        axi_waddr <= s_axi_awaddr;
                        axi_waddr_base <= s_axi_awaddr;
                        axi_wlen <= s_axi_awlen;
                        axi_wsize <= s_axi_awsize;
                        axi_wburst <= s_axi_awburst;
                        axi_wlen_counter <= s_axi_awlen;
                        axi_wshift_size <= 8'h1 << s_axi_awsize;
                        axi_wshift_count <= 8'h0;
                        axi_awuser <= s_axi_awuser;
                        axi_awid <= s_axi_awid;
                        
                        axi_state_write <= WRITE_DATA_FLUSH_FIFO;
                    end
                    
                    else if( s_axi_awaddr == AXI_DAC_MODE ) begin
                        axi_waddr <= s_axi_awaddr;
                        axi_waddr_base <= s_axi_awaddr;
                        axi_wlen <= s_axi_awlen;
                        axi_wsize <= s_axi_awsize;
                        axi_wburst <= s_axi_awburst;
                        axi_wlen_counter <= s_axi_awlen;
                        axi_wshift_size <= 8'h1 << s_axi_awsize;
                        axi_wshift_count <= 8'h0;
                        axi_awuser <= s_axi_awuser;
                        axi_awid <= s_axi_awid;
                        
                        axi_state_write <= WRITE_DAC_MODE;
                    end
                    
                    else begin
                        axi_waddr <= {AXI_ADDR_WIDTH{1'b0}};
                        axi_waddr_base <= {AXI_ADDR_WIDTH{1'b0}};
                        axi_wlen <= 8'h0;
                        axi_wsize <= 3'h0;
                        axi_wburst <= 2'h0;
                        axi_wlen_counter <= 8'h0;
                        axi_wshift_size <= 8'h0;
                        axi_wshift_count <= 8'h0;
                        axi_state_write <= ERROR_STATE;
                        axi_awuser <= s_axi_awuser;
                        axi_awid <= s_axi_awid;
                    end
                end
                
                else begin
                    axi_waddr <= {AXI_ADDR_WIDTH{1'b0}};
                    axi_waddr_base <= {AXI_ADDR_WIDTH{1'b0}};
                    axi_wlen <= 8'h0;
                    axi_wsize <= 3'h0;
                    axi_wburst <= 2'h0;
                    axi_wlen_counter <= 8'h0;
                    axi_wshift_size <= 8'h0;
                    axi_wshift_count <= 8'h0;
                    axi_state_write <= IDLE;
                    axi_awuser <= 16'h0;
                    axi_awid <= 16'h0;
                end
            end
            
            WRITE_DATA_WRITE_FIFO: begin
                if( rto_core_full == 1'b0 ) begin
                    if( s_axi_wvalid == 1'b1 ) begin
                        rto_core_fifo_din <= s_axi_wdata;
                        rto_core_write <= 1'b1;
                        if( s_axi_wlast == 1'b1 ) begin
                            axi_state_write <= WRITE_RESPONSE;
                        end
                    end
                    else begin
                        rto_core_fifo_din <= s_axi_wdata;
                        rto_core_write <= 1'b0;
                    end
                end
                else begin
                    rto_core_fifo_din <= 128'h0;
                    rto_core_write <= 1'b0;
                end
            end
            WRITE_DATA_FLUSH_FIFO: begin
                if( s_axi_wvalid == 1'b1 ) begin
                    if( s_axi_wdata[0] == 1'b1 ) begin
                        rto_core_flush <= 1'b1;
                    end
                    if( s_axi_wlast == 1'b1 ) begin
                        axi_state_write <= WRITE_RESPONSE;
                    end
                end
            end
            
            WRITE_DAC_MODE: begin
                if( s_axi_wvalid == 1'b1 ) begin
                    if( s_axi_wdata[0] == 1'b1 ) begin
                        dac_mode <= s_axi_wdata[0];
                    end
                    if( s_axi_wlast == 1'b1 ) begin
                        axi_state_write <= WRITE_RESPONSE;
                    end
                end
            end
            
            ERROR_STATE: begin
                if( s_axi_bready == 1'b1 ) begin
                    s_axi_bresp <= 2'b10;
                    s_axi_bvalid <= 1'b1;
                    axi_state_write <= IDLE;
                    s_axi_bid <= axi_awid;
                end
            end
            
            WRITE_RESPONSE: begin
                rto_core_write <= 1'b0;
                rto_core_fifo_din <= 128'h0;
                if( s_axi_bready == 1'b1 ) begin
                    s_axi_bresp <= 2'b00;
                    s_axi_bvalid <= 1'b1;
                    axi_state_write <= IDLE;
                    s_axi_bid <= axi_awid;
                end
            end
        endcase
    end
end

//////////////////////////////////////////////////////////////////////////////////
// AXI4 Read FSM
// AXI read only gives zero data to master from slave
//////////////////////////////////////////////////////////////////////////////////

reg [15:0] axi_arid;
reg [15:0] axi_aruser;

always @(posedge s_axi_aclk) begin
    if( s_axi_aresetn == 1'b0 ) begin
        axi_state_read <= IDLE;
        s_axi_rdata <= {AXI_DATA_WIDTH{1'b0}};
        s_axi_rresp <= 2'b0;
        s_axi_rvalid <= 1'b0;
        s_axi_rlast <= 1'b0;
        s_axi_rid <= 16'h0; // id value
        
        axi_arid <= 16'h0;
        axi_aruser <= 16'h0;
    end
    
    else begin
        s_axi_rid <= 16'h0; // id value
        axi_arid <= 16'h0;
        axi_aruser <= 16'h0;
        
        case(axi_state_read)
            IDLE: begin
                s_axi_rdata <= {AXI_DATA_WIDTH{1'b0}};
                s_axi_rresp <= 2'b0;
                s_axi_rvalid <= 1'b0;
                s_axi_rlast <= 1'b0;
                if( s_axi_arvalid == 1'b1 ) begin
                    axi_state_read <= READ_DATA;
                    axi_arid <= s_axi_arid;
                    axi_aruser <= s_axi_aruser;
                end
            end
            READ_DATA: begin
                if( s_axi_rready == 1'b1 ) begin
                    s_axi_rdata <= {AXI_DATA_WIDTH{1'b0}};
                    s_axi_rresp <= 2'b0;
                    s_axi_rvalid <= 1'b1;
                    s_axi_rlast <= 1'b1;
                    s_axi_rid <= axi_arid;
                    axi_state_read <= IDLE;
                end
            end
        endcase
    end
end


//////////////////////////////////////////////////////////////////////////////////
// AXI4 Reset
//////////////////////////////////////////////////////////////////////////////////

always @(posedge s_axi_aclk) begin
    if( s_axi_aresetn == 1'b0 ) begin
        rto_core_reset <= 1'b1;
    end
    else begin
        rto_core_reset <= 1'b0;
    end
end

endmodule