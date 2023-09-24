module adj_fifo
#(
    parameter DEPTH = 1024,
    parameter THRESHOLD = 1000,
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 10
)
(
    input wire clk,
    input wire rst,
    input wire wr_en,
    input wire [ADDR_WIDTH - 1:0] addr_in,
    input wire [ADDR_WIDTH - 1:0] addr_out,
    input wire [DATA_WIDTH - 1:0] din,
    output wire [DATA_WIDTH - 1:0] dout
);

reg [DATA_WIDTH * DEPTH - 1:0] data;

assign dout = data[DATA_WIDTH * addr_out +:DATA_WIDTH];

always@(posedge clk) begin
    if( rst ) begin
        data <= {(DATA_WIDTH*DEPTH){1'b0}};
    end
    else begin
        if( wr_en == 1'b1) begin
            data[DATA_WIDTH * addr_in +: DATA_WIDTH] <= din;
        end
    end
end

endmodule
