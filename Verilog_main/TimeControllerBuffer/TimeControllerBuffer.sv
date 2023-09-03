module TimeControllerBuffer(
    input wire [63:0] counter_I,
    input wire auto_start_I,
    input wire s_axi_aclk,
    input wire s_axi_aresetn,

    output reg [63:0] counter0_O,
    output reg auto_start0_O,
    output reg [63:0] counter1_O,
    output reg auto_start1_O,
    output reg [63:0] counter2_O,
    output reg auto_start2_O,
    output reg [63:0] counter3_O,
    output reg auto_start3_O
);

always @(posedge s_axi_aclk) begin
    if( s_axi_aresetn == 1'b0 ) begin
        counter0_O <= 64'h0;
        counter1_O <= 64'h0;
        counter2_O <= 64'h0;
        counter3_O <= 64'h0;
        auto_start0_O <= 1'b0;
        auto_start1_O <= 1'b0;
        auto_start2_O <= 1'b0;
        auto_start3_O <= 1'b0;
    end

    else begin
        counter0_O <= counter_I;
        counter1_O <= counter_I;
        counter2_O <= counter_I;
        counter3_O <= counter_I;
        auto_start0_O <= auto_start_I;
        auto_start1_O <= auto_start_I;
        auto_start2_O <= auto_start_I;
        auto_start3_O <= auto_start_I;
    end
end

endmodule
