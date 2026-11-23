//==============================================================================
// Project     : 100 Days of RTL Design - Day 30 / 100
// Design      : 4x4 Matrix Multiplier
// File        : matrix_mult_4x4.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : C = A x B for 8-bit matrices with flattened Verilog ports
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 4x4 matrix multiplier, C = A x B, 8-bit unsigned elements, 18-bit results.
// Matrices are passed as flat buses so the ports are plain Verilog:
// element (row r, col c) sits at index r*4 + c.
module matrix_mult_4x4 (
    input  [16*8-1:0]  A,
    input  [16*8-1:0]  B,
    output [16*18-1:0] C
);
    genvar r, c;
    generate
        for (r = 0; r < 4; r = r + 1) begin : row
            for (c = 0; c < 4; c = c + 1) begin : col
                wire [7:0] a0 = A[(r*4+0)*8 +: 8], a1 = A[(r*4+1)*8 +: 8];
                wire [7:0] a2 = A[(r*4+2)*8 +: 8], a3 = A[(r*4+3)*8 +: 8];
                wire [7:0] b0 = B[(0*4+c)*8 +: 8], b1 = B[(1*4+c)*8 +: 8];
                wire [7:0] b2 = B[(2*4+c)*8 +: 8], b3 = B[(3*4+c)*8 +: 8];
                // dot product of row r of A and column c of B
                assign C[(r*4+c)*18 +: 18] = a0*b0 + a1*b1 + a2*b2 + a3*b3;
            end
        end
    endgenerate
endmodule
