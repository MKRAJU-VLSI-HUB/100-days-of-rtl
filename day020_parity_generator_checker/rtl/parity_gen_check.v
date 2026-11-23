//==============================================================================
// Project     : 100 Days of RTL Design - Day 20 / 100
// Design      : Parity Generator and Checker
// File        : parity_gen_check.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Even parity for an 8-bit word, every single-bit error detected
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// Even parity generator (transmit side) and parity checker (receive side)
// for an 8-bit data word.
module parity_generator (
    input  [7:0] data,
    output       parity           // makes the total number of 1s even
);
    assign parity = ^data;
endmodule

module parity_checker (
    input  [7:0] data,
    input        parity,
    output       error            // 1 when an odd number of bits flipped
);
    assign error = ^{data, parity};
endmodule
