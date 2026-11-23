//==============================================================================
// Project     : 100 Days of RTL Design - Day 2 / 100
// Design      : Half Adder
// File        : half_adder.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : 1-bit half adder: sum = a ^ b, carry = a & b
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module half_adder (
    input  a, b,
    output sum, carry
);
    assign sum   = a ^ b;
    assign carry = a & b;
endmodule
