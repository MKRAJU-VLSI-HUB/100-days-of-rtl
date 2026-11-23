//==============================================================================
// Project     : 100 Days of RTL Design - Day 52 / 100
// Design      : Edge Detector
// File        : edge_detector.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : One-clock pulses on rising and falling edges
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// Edge detector: one-clock pulses on the rising and falling edges of
// a (synchronous) input. The input is registered and compared with its
// previous value.
module edge_detector (
    input  clk,
    input  rst,
    input  sig,
    output rise,
    output fall,
    output any_edge
);
    reg sig_q;

    always @(posedge clk or posedge rst) begin
        if (rst) sig_q <= 1'b0;
        else     sig_q <= sig;
    end

    assign rise     =  sig & ~sig_q;
    assign fall     = ~sig &  sig_q;
    assign any_edge =  sig ^  sig_q;
endmodule
