//==============================================================================
// Project     : 100 Days of RTL Design - Day 46 / 100
// Design      : 8-bit LFSR
// File        : lfsr8.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Maximal-length pseudo-random sequence, all 255 states visited
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 8-bit Fibonacci LFSR, polynomial x^8 + x^6 + x^5 + x^4 + 1.
// This polynomial is maximal length: it visits all 255 non-zero states
// before repeating. Used for pseudo-random numbers and test patterns.
module lfsr8 (
    input            clk,
    input            rst,
    input            en,
    input      [7:0] seed,
    output reg [7:0] q
);
    wire fb = q[7] ^ q[5] ^ q[4] ^ q[3];

    always @(posedge clk or posedge rst) begin
        if (rst)     q <= (seed == 8'h00) ? 8'h01 : seed;   // all-zero is a lock-up state
        else if (en) q <= {q[6:0], fb};
    end
endmodule
