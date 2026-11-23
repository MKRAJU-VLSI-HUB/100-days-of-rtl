//==============================================================================
// Project     : 100 Days of RTL Design - Day 3 / 100
// Design      : Full Adder
// File        : full_adder.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : 1-bit full adder with carry in, checked on all 8 input combinations
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module full_adder (
    input  a, b, cin,
    output sum, cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule
