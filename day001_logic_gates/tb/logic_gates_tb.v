//==============================================================================
// Project     : 100 Days of RTL Design - Day 1 / 100
// Design      : Basic Logic Gates
// File        : logic_gates_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Basic Logic Gates
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module logic_gates_tb;
    reg a, b;
    wire y_and, y_or, y_not, y_nand, y_nor, y_xor, y_xnor;
    integer i, errors = 0;

    logic_gates dut (.a(a), .b(b), .y_and(y_and), .y_or(y_or), .y_not(y_not),
                     .y_nand(y_nand), .y_nor(y_nor), .y_xor(y_xor), .y_xnor(y_xnor));

    initial begin
        $display(" a b | AND OR NOT NAND NOR XOR XNOR");
        for (i = 0; i < 4; i = i + 1) begin
            {a, b} = i; #10;
            $display(" %b %b |  %b   %b   %b    %b    %b   %b    %b", a, b,
                     y_and, y_or, y_not, y_nand, y_nor, y_xor, y_xnor);
            if ({y_and, y_or, y_not, y_nand, y_nor, y_xor, y_xnor} !==
                {a&b, a|b, ~a, ~(a&b), ~(a|b), a^b, ~(a^b)}) errors = errors + 1;
        end
        if (errors == 0) $display("RESULT: PASS - all 4 input combinations correct");
        else             $display("RESULT: FAIL - %0d errors", errors);
        $finish;
    end
endmodule
