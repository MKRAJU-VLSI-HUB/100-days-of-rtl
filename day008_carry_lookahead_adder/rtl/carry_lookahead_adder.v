//==============================================================================
// Project     : 100 Days of RTL Design - Day 8 / 100
// Design      : 4-bit Carry Look-Ahead Adder
// File        : carry_lookahead_adder.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Carries computed directly from generate and propagate terms, no ripple
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 4-bit carry look-ahead adder.
// Generate g = a & b, propagate p = a ^ b. Every carry is computed directly
// from g, p and cin, so there is no ripple through the stages.
module carry_lookahead_adder (
    input  [3:0] a, b,
    input        cin,
    output [3:0] sum,
    output       cout,
    output       pg,      // group propagate
    output       gg       // group generate
);
    wire [3:0] g = a & b;
    wire [3:0] p = a ^ b;
    wire [4:0] c;

    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & cin);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0])
                       | (p[3] & p[2] & p[1] & p[0] & cin);

    assign sum  = p ^ c[3:0];
    assign cout = c[4];
    assign pg   = &p;
    assign gg   = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
endmodule
