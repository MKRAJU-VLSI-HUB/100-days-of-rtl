//==============================================================================
// Project     : 100 Days of RTL Design - Day 7 / 100
// Design      : 4-bit Adder / Subtractor
// File        : adder_subtractor.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : One adder does both add and subtract using 2s complement, with signed overflow flag
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 4-bit adder/subtractor: mode = 0 -> A + B, mode = 1 -> A - B
// B is XORed with mode and mode is used as the carry in (2s complement).
module adder_subtractor (
    input  [3:0] a, b,
    input        mode,
    output [3:0] result,
    output       cout,
    output       overflow
);
    wire [3:0] bx = b ^ {4{mode}};
    wire [4:0] c;
    assign c[0] = mode;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : stage
            assign result[i] = a[i] ^ bx[i] ^ c[i];
            assign c[i+1]    = (a[i] & bx[i]) | (bx[i] & c[i]) | (a[i] & c[i]);
        end
    endgenerate

    assign cout     = c[4];
    assign overflow = c[4] ^ c[3];   // signed overflow
endmodule
