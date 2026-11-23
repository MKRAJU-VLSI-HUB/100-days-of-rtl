//==============================================================================
// Project     : 100 Days of RTL Design - Day 25 / 100
// Design      : 16-bit Leading Zero Counter
// File        : leading_zero_counter.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Tree of small counters, used in floating point normalisation
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 16-bit leading zero counter, built as a tree:
// two 8-bit counters, each made of two 4-bit counters.
// Used in floating point normalisation and priority logic.
module lzc4 (
    input  [3:0] x,
    output [2:0] cnt        // 0..4
);
    assign cnt = x[3] ? 3'd0 :
                 x[2] ? 3'd1 :
                 x[1] ? 3'd2 :
                 x[0] ? 3'd3 : 3'd4;
endmodule

module lzc8 (
    input  [7:0] x,
    output [3:0] cnt        // 0..8
);
    wire [2:0] hi, lo;
    lzc4 u_hi (.x(x[7:4]), .cnt(hi));
    lzc4 u_lo (.x(x[3:0]), .cnt(lo));
    assign cnt = (hi == 3'd4) ? 4'd4 + lo : {1'b0, hi};
endmodule

module leading_zero_counter (
    input  [15:0] x,
    output [4:0]  cnt,      // 0..16
    output        all_zero
);
    wire [3:0] hi, lo;
    lzc8 u_hi (.x(x[15:8]), .cnt(hi));
    lzc8 u_lo (.x(x[7:0]),  .cnt(lo));
    assign cnt      = (hi == 4'd8) ? 5'd8 + lo : {1'b0, hi};
    assign all_zero = (x == 16'd0);
endmodule
