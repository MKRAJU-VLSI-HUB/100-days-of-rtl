//==============================================================================
// Project     : 100 Days of RTL Design - Day 28 / 100
// Design      : 4x4 Vedic Multiplier
// File        : vedic_multiplier.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Urdhva Tiryagbhyam method built from 2x2 Vedic cells
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 4x4 Vedic multiplier (Urdhva Tiryagbhyam - "vertically and crosswise").
// A 2x2 Vedic block is the base cell; four 2x2 blocks plus adders make 4x4.
module vedic2x2 (
    input  [1:0] a, b,
    output [3:0] p
);
    wire t0 = a[0] & b[0];
    wire t1 = a[1] & b[0];
    wire t2 = a[0] & b[1];
    wire t3 = a[1] & b[1];
    wire c1;

    assign p[0] = t0;
    assign p[1] = t1 ^ t2;
    assign c1   = t1 & t2;
    assign p[2] = t3 ^ c1;
    assign p[3] = t3 & c1;
endmodule

module vedic_multiplier (
    input  [3:0] a, b,
    output [7:0] p
);
    wire [3:0] q0, q1, q2, q3;

    vedic2x2 m0 (.a(a[1:0]), .b(b[1:0]), .p(q0));   // low  x low
    vedic2x2 m1 (.a(a[3:2]), .b(b[1:0]), .p(q1));   // high x low
    vedic2x2 m2 (.a(a[1:0]), .b(b[3:2]), .p(q2));   // low  x high
    vedic2x2 m3 (.a(a[3:2]), .b(b[3:2]), .p(q3));   // high x high

    // crosswise terms are added in the middle
    wire [4:0] mid  = q1 + q2;
    wire [5:0] up   = {q3, 2'b00} + mid + q0[3:2];

    assign p = {up, q0[1:0]};
endmodule
