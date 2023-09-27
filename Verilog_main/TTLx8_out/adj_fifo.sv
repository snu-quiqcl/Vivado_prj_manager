module adj_fifo
#(
    parameter DEPTH = 1024,
    parameter THRESHOLD = 1000,
    parameter DATA_LEN = 8,
    parameter ADDR_LEN = 10
)
(
    input wire clk,
    input wire rst,
    input wire wr_en,
    input wire [ADDR_LEN - 1:0] addr_in,
    input wire [ADDR_LEN - 1:0] addr_out,
    input wire [DATA_LEN - 1:0] din,
    output wire [DATA_LEN - 1:0] dout
);

reg [DATA_LEN * DEPTH - 1:0] data;

assign dout = data[DATA_LEN * addr_out +:DATA_LEN];

always@(posedge clk) begin
    if( rst ) begin
        data <= {(DATA_LEN*DEPTH){1'b0}};
    end
    else begin
        if( wr_en == 1'b1) begin
            data[DATA_LEN * addr_in +: DATA_LEN] <= din;
        end
    end
end

endmodule
