//==============================================================================
// Project     : 100 Days of RTL Design - Day 10 / 100
// Design      : BCD Adder
// File        : bcd_adder.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : 1-digit decimal adder with the +6 correction for results above 9
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 1-digit BCD adder. Add the two digits in binary; if the result is
// above 9, add 6 to bring it back into BCD and raise the decimal carry.
module bcd_adder (
    input  [3:0] a, b,     // BCD digits 0..9
    input        cin,
    output [3:0] sum,      // BCD digit
    output       cout      // decimal carry
);
    wire [4:0] bin_sum   = a + b + cin;
    assign     cout      = (bin_sum > 5'd9);
    wire [4:0] corrected = cout ? bin_sum + 5'd6 : bin_sum;
    assign     sum       = corrected[3:0];
endmodule
