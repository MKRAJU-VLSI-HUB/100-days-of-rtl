//==============================================================================
// Project     : 100 Days of RTL Design - Day 9 / 100
// Design      : 8-bit Carry Select Adder
// File        : carry_select_adder.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Upper nibble computed for both carry values in parallel, real carry picks the result
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 8-bit carry select adder.
// The lower nibble is a normal ripple adder. The upper nibble is computed
// twice in parallel (carry in = 0 and carry in = 1) and the real carry from
// the lower nibble selects the right result.
module rca4 (
    input  [3:0] a, b,
    input        cin,
    output [3:0] sum,
    output       cout
);
    assign {cout, sum} = a + b + cin;
endmodule

module carry_select_adder (
    input  [7:0] a, b,
    input        cin,
    output [7:0] sum,
    output       cout
);
    wire       c4, c8_0, c8_1;
    wire [3:0] s_hi0, s_hi1;

    rca4 lo  (.a(a[3:0]), .b(b[3:0]), .cin(cin),  .sum(sum[3:0]), .cout(c4));
    rca4 hi0 (.a(a[7:4]), .b(b[7:4]), .cin(1'b0), .sum(s_hi0),    .cout(c8_0));
    rca4 hi1 (.a(a[7:4]), .b(b[7:4]), .cin(1'b1), .sum(s_hi1),    .cout(c8_1));

    assign sum[7:4] = c4 ? s_hi1 : s_hi0;
    assign cout     = c4 ? c8_1  : c8_0;
endmodule
