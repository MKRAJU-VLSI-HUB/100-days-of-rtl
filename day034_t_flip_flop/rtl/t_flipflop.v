//==============================================================================
// Project     : 100 Days of RTL Design - Day 34 / 100
// Design      : T Flip-Flop
// File        : t_flipflop.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : T flip-flop made from a D flip-flop, divides the clock by 2
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// T flip-flop built from a D flip-flop: d = t ^ q
module t_flipflop (
    input      clk, rst, t,
    output reg q
);
    wire d = t ^ q;

    always @(posedge clk or posedge rst) begin
        if (rst) q <= 1'b0;
        else     q <= d;
    end
endmodule
