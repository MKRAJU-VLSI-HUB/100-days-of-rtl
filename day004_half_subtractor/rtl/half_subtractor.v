//==============================================================================
// Project     : 100 Days of RTL Design - Day 4 / 100
// Design      : Half Subtractor
// File        : half_subtractor.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : 1-bit half subtractor producing difference and borrow
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module half_subtractor (
    input  a, b,
    output diff, borrow
);
    assign diff   = a ^ b;
    assign borrow = ~a & b;
endmodule
