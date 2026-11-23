//==============================================================================
// Project     : 100 Days of RTL Design - Day 1 / 100
// Design      : Basic Logic Gates
// File        : logic_gates.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : AND, OR, NOT, NAND, NOR, XOR and XNOR gates with a full truth table check
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module logic_gates (
    input  a, b,
    output y_and, y_or, y_not, y_nand, y_nor, y_xor, y_xnor
);
    assign y_and  = a & b;
    assign y_or   = a | b;
    assign y_not  = ~a;
    assign y_nand = ~(a & b);
    assign y_nor  = ~(a | b);
    assign y_xor  = a ^ b;
    assign y_xnor = ~(a ^ b);
endmodule
