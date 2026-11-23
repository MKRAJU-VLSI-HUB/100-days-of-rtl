//==============================================================================
// Project     : 100 Days of RTL Design - Day 15 / 100
// Design      : 2-to-4 Decoder
// File        : decoder_2to4.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : 2-to-4 decoder with enable, one-hot outputs
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 2-to-4 decoder with enable
module decoder_2to4 (
    input  [1:0] a,
    input        en,
    output [3:0] y
);
    assign y[0] = en & ~a[1] & ~a[0];
    assign y[1] = en & ~a[1] &  a[0];
    assign y[2] = en &  a[1] & ~a[0];
    assign y[3] = en &  a[1] &  a[0];
endmodule
