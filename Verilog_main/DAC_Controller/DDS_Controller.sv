`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SNU QuIQCL
// Engineer: Jeonghyun Park
// 
// Create Date: 2023/02/23 17:14:19
// Design Name: 
// Module Name: DDS_Controller
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

module DDS_Controller
#(
    parameter DEST_VAL = 16'h0,
    parameter CHANNEL_LENGTH = 12,
    parameter AXIS_DATA_WIDTH = 256
)
(
    //////////////////////////////////////////////////////////////////////////////////  
    // IO declaration for GPO_Core
    //////////////////////////////////////////////////////////////////////////////////
    input wire CLK100MHZ,
    input wire m00_axis_aclk,
    input wire reset,
    input wire override_en,
    input wire selected_en,
    input wire[63:0] override_value,
    input wire counter_matched,
    input wire [127:0] gpo_in,
    input wire busy,
    output wire [127:0] error_data,
    output wire overrided,
    output wire busy_error,
    
    //////////////////////////////////////////////////////////////////////////////////  
    // Output port for DDS control
    //////////////////////////////////////////////////////////////////////////////////
    output reg [47:0] freq,
    output reg  [13:0] amp,              // unsigned value
    output reg [13:0] phase,
    output reg [13:0] amp_offset,
    output reg [63:0] time_offset,
    output reg [63:0] timestamp
    );
    
//////////////////////////////////////////////////////////////////////////////////  
// Wire declaration in RFDC_DDS
//////////////////////////////////////////////////////////////////////////////////
// input wire [47:0] freq,
// input wire [13:0] amp,              // unsigned value
// input wire [13:0] phase,
// input wire [63:0] timestamp,
// input wire [13:0] amp_offset,
// input wire [63:0] time_offset,
// output wire [255:0] m_axis_data_tdata,
// output wire m_axis_data_tvalid
//
// 64 bit data format
// 4 bit - data dest sel | 60 bit - data
//
// * Cases of data dest sel bits [3:0] *
// 
// -Case 0000
// 14-bit amp | 14-bit phase | 32-bit freq
// 32-bit freq change only  freq[47:16]
//
// -Case 0001
// Only change 48 bit frequency value
//
// -Case 0010
// 14 bit - amp  | 46 bit -upper freq ( [47:2] )
//
// -Case 0011
// 14 bit - phase  | 46 bit -upper freq ( [47:2] )
//
// -Case 0100
// timeoffset[59:0]
// 
// -Case 0101
// 14 bit - amp_offset 
//
// -Case 1 << 3 | lower[2:0]
// 14-bit amp | 14-bit phase | 32-bit freq
// 32-bit freq change only freq[47 - 2  - lower[2:0] * 2:16 - 2 - lower[2:0] * 2]
//
// Other case
  
//////////////////////////////////////////////////////////////////////////////////  
// Wire declaration for GPO_Core
//////////////////////////////////////////////////////////////////////////////////

wire selected;
wire[127:0] gpo_out;

//////////////////////////////////////////////////////////////////////////////////  
// GPO_Core
//////////////////////////////////////////////////////////////////////////////////

GPO_Core #(
    .DEST_VAL(DEST_VAL),
    .CHANNEL_LENGTH(CHANNEL_LENGTH)
)
GPO_Core0(
    .CLK100MHZ(CLK100MHZ),
    .reset(reset),
    .override_en(override_en),
    .selected_en(selected_en),
    .override_value(override_value),
    .counter_matched(counter_matched),
    .gpo_in(gpo_in),
    .busy(busy),
    .selected(selected),
    .error_data(error_data),
    .overrided(overrided),
    .busy_error(busy_error),
    .gpo_out(gpo_out)
);

always @( posedge CLK100MHZ ) begin
    if( reset == 1'b1 ) begin
        freq <= 48'h0;
        amp <= 14'h0;
        phase <= 14'h0;
        amp_offset <= 14'h0;
        time_offset <= 64'h0;
        timestamp <= 64'h0;
    end
    
    else begin
        if( selected == 1'b1 ) begin
            timestamp <= gpo_out[127:64];
            case( gpo_out[63:60] )
                4'b0000: begin
                    freq[47:16] <= gpo_out[31:0];
                    phase <= gpo_out[45:32];
                    amp <= gpo_out[59:46];
                end
                
                4'b0001: begin
                    freq[47:0] <= gpo_out[47:0];
                end
                
                4'b0010: begin
                    freq[47:2] <= gpo_out[45:0];
                    amp <= gpo_out[59:46];
                end
                
                4'b0011: begin
                    freq[47:2] <= gpo_out[45:0];
                    phase <= gpo_out[59:46];
                end
                
                4'b0100: begin
                    time_offset[59:0] <= gpo_out[59:0];
                end
                
                4'b0101: begin
                    amp_offset <= gpo_out[13:0];
                end
                
                4'b1000: begin
                    freq[45:14] <= gpo_out[31:0];
                    phase <= gpo_out[45:32];
                    amp <= gpo_out[59:46];
                end
                
                4'b1001: begin
                    freq[43:12] <= gpo_out[31:0];
                    phase <= gpo_out[45:32];
                    amp <= gpo_out[59:46];
                end
                
                4'b1010: begin
                    freq[41:10] <= gpo_out[31:0];
                    phase <= gpo_out[45:32];
                    amp <= gpo_out[59:46];
                end
                
                4'b1011: begin
                    freq[39:8] <= gpo_out[31:0];
                    phase <= gpo_out[45:32];
                    amp <= gpo_out[59:46];
                end
                
                4'b1100: begin
                    freq[37:6] <= gpo_out[31:0];
                    phase <= gpo_out[45:32];
                    amp <= gpo_out[59:46];
                end
                
                4'b1101: begin
                    freq[35:4] <= gpo_out[31:0];
                    phase <= gpo_out[45:32];
                    amp <= gpo_out[59:46];
                end
                
                4'b1110: begin
                    freq[33:2] <= gpo_out[31:0];
                    phase <= gpo_out[45:32];
                    amp <= gpo_out[59:46];
                end
                
                4'b1111: begin
                    freq[31:0] <= gpo_out[31:0];
                    phase <= gpo_out[45:32];
                    amp <= gpo_out[59:46];
                end
            endcase
        end
    end
end
    
endmodule
