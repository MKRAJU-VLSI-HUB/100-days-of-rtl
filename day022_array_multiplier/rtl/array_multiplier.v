//==============================================================================
// Project     : 100 Days of RTL Design - Day 22 / 100
// Design      : 4x4 Array Multiplier
// File        : array_multiplier.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : AND-gate partial products added row by row with full adders
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 4x4 unsigned array multiplier.
// Partial products are formed with AND gates and added row by row
// with full adders, the same way you multiply on paper.
module fa (input a, b, c, output s, co);
    assign s  = a ^ b ^ c;
    assign co = (a & b) | (b & c) | (a & c);
endmodule

module array_multiplier (
    input  [3:0] a, b,
    output [7:0] p
);
    wire [3:0] pp [0:3];          // partial products
    genvar i, j;
    generate
        for (i = 0; i < 4; i = i + 1) begin : row
            for (j = 0; j < 4; j = j + 1) begin : col
                assign pp[i][j] = a[j] & b[i];
            end
        end
    endgenerate

    // row 1: add pp0 >> 1 and pp1
    wire [3:0] s1; wire [3:0] c1;
    fa r1_0 (pp[0][1], pp[1][0], 1'b0,  s1[0], c1[0]);
    fa r1_1 (pp[0][2], pp[1][1], c1[0], s1[1], c1[1]);
    fa r1_2 (pp[0][3], pp[1][2], c1[1], s1[2], c1[2]);
    fa r1_3 (1'b0,     pp[1][3], c1[2], s1[3], c1[3]);

    // row 2: add previous sum >> 1 and pp2
    wire [3:0] s2; wire [3:0] c2;
    fa r2_0 (s1[1], pp[2][0], 1'b0,  s2[0], c2[0]);
    fa r2_1 (s1[2], pp[2][1], c2[0], s2[1], c2[1]);
    fa r2_2 (s1[3], pp[2][2], c2[1], s2[2], c2[2]);
    fa r2_3 (c1[3], pp[2][3], c2[2], s2[3], c2[3]);

    // row 3: add previous sum >> 1 and pp3
    wire [3:0] s3; wire [3:0] c3;
    fa r3_0 (s2[1], pp[3][0], 1'b0,  s3[0], c3[0]);
    fa r3_1 (s2[2], pp[3][1], c3[0], s3[1], c3[1]);
    fa r3_2 (s2[3], pp[3][2], c3[1], s3[2], c3[2]);
    fa r3_3 (c2[3], pp[3][3], c3[2], s3[3], c3[3]);

    assign p = {c3[3], s3, s2[0], s1[0], pp[0][0]};
endmodule
