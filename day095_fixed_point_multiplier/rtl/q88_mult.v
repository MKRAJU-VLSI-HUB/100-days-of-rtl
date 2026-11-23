//==============================================================================
// Project     : 100 Days of RTL Design - Day 95 / 100
// Design      : Q8.8 Fixed-Point Multiplier
// File        : q88_mult.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Signed fixed-point multiply with rounding and saturation
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// Signed Q8.8 fixed-point multiplier with rounding and saturation.
// Q8.8: 8 integer bits (including sign) and 8 fraction bits, so
// 0x0100 = 1.0, 0x0180 = 1.5, 0xFF00 = -1.0. Range -128 .. +127.996.
// The 32-bit product is Q16.16; we round to nearest and shift right by 8
// to get back to Q8.8. Results outside the range clamp to the limits
// instead of wrapping around (wrapping would turn +200 into -56).
module q88_mult (
    input  signed [15:0]     a,
    input  signed [15:0]     b,
    output reg signed [15:0] p,
    output reg               overflow
);
    wire signed [31:0] full    = a * b;                 // Q16.16
    wire signed [31:0] rounded = full + 32'sd128;        // add half an LSB of the result
    wire signed [23:0] shifted = rounded >>> 8;          // Q16.8

    always @(*) begin
        if (shifted > 24'sd32767) begin
            p = 16'sh7FFF; overflow = 1'b1;
        end else if (shifted < -24'sd32768) begin
            p = 16'sh8000; overflow = 1'b1;
        end else begin
            p = shifted[15:0]; overflow = 1'b0;
        end
    end
endmodule
