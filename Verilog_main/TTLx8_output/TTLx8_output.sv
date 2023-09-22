OSERDESE3_0 #(
    .DATA_WIDTH(8),
    .INIT(1'b0),
    .IS_CLKDIV_INVERTED(1'b0),
    .IS_CLK_INVERTED(1'b0),
    .IS_RST_INVERTED(1'b1),
    .ODDR_MODE("TRUE"),
    .SIM_DEVICE("ULTRASCALE_PLUS")
) oserdes3_output_0 (
    .CLK(clk_x4),
    .CLKDIV(clk),
    .D(input_pulse),
    .OQ(output_pulse),
    .RST(resetn),
    .T(1'b0)
);

