//==============================================================================
// Project     : 100 Days of RTL Design - Day 26 / 100
// Design      : Population Count
// File        : popcount.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Counts the 1s in a byte with an adder tree
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 8-bit population count (number of 1s) using an adder tree:
// 4 two-bit sums -> 2 three-bit sums -> 1 four-bit result.
module popcount (
    input  [7:0] x,
    output [3:0] count
);
    wire [1:0] s0 = x[0] + x[1];
    wire [1:0] s1 = x[2] + x[3];
    wire [1:0] s2 = x[4] + x[5];
    wire [1:0] s3 = x[6] + x[7];

    wire [2:0] t0 = s0 + s1;
    wire [2:0] t1 = s2 + s3;

    assign count = t0 + t1;
endmodule
