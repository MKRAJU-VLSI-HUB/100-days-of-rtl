//==============================================================================
// Project     : 100 Days of RTL Design - Day 01
// File        : ripple_carry_adder.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Created     : 01-Jan-2026
// Tool        : Xilinx Vivado 2024.2
// Description : 4-bit ripple carry adder built from four full adders.
//               The carry out of each stage feeds the carry in of the next.
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================
`timescale 1ns/1ps

// 1-bit full adder
module full (sum, carry, a, b, c);
    input  a, b, c;
    output sum, carry;

    assign sum   = a ^ b ^ c;
    assign carry = (a & b) | (b & c) | (c & a);
endmodule

// 4-bit ripple carry adder
module ripplecarry (sum, cout, a, b, cin);
    input  [3:0] a, b;
    input        cin;
    output [3:0] sum;
    output       cout;

    wire c0, c1, c2;

    full f1 (sum[0], c0,   a[0], b[0], cin);
    full f2 (sum[1], c1,   a[1], b[1], c0);
    full f3 (sum[2], c2,   a[2], b[2], c1);
    full f4 (sum[3], cout, a[3], b[3], c2);
endmodule
