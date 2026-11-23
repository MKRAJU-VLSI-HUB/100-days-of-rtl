//==============================================================================
// Project     : 100 Days of RTL Design - Day 5 / 100
// Design      : Full Subtractor
// File        : full_subtractor.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : 1-bit full subtractor with borrow in and borrow out
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module full_subtractor (
    input  a, b, bin,
    output diff, bout
);
    assign diff = a ^ b ^ bin;
    assign bout = (~a & b) | (~a & bin) | (b & bin);
endmodule
