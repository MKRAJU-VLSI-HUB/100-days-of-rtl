//==============================================================================
// Project     : 100 Days of RTL Design - Day 18 / 100
// Design      : 4-bit Magnitude Comparator
// File        : magnitude_comparator.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Greater, equal and less outputs built from bit equality terms like the 7485
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 4-bit magnitude comparator built from bit-level equality terms
// (same structure as the 7485 chip).
module magnitude_comparator (
    input  [3:0] a, b,
    output       a_gt_b,
    output       a_eq_b,
    output       a_lt_b
);
    wire [3:0] x = ~(a ^ b);   // x[i] = 1 when bit i is equal

    assign a_eq_b = &x;
    assign a_gt_b = (a[3] & ~b[3])
                  | (x[3] & a[2] & ~b[2])
                  | (x[3] & x[2] & a[1] & ~b[1])
                  | (x[3] & x[2] & x[1] & a[0] & ~b[0]);
    assign a_lt_b = ~a_gt_b & ~a_eq_b;
endmodule
