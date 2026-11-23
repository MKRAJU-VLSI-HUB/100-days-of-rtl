//==============================================================================
// Project     : 100 Days of RTL Design - Day 2 / 100
// Design      : Half Adder
// File        : half_adder_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Half Adder
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module half_adder_tb;
    reg a, b;
    wire sum, carry;
    integer i, errors = 0;

    half_adder dut (.a(a), .b(b), .sum(sum), .carry(carry));

    initial begin
        $display(" a b | carry sum");
        for (i = 0; i < 4; i = i + 1) begin
            {a, b} = i; #10;
            $display(" %b %b |   %b    %b", a, b, carry, sum);
            if ({carry, sum} !== a + b) errors = errors + 1;
        end
        if (errors == 0) $display("RESULT: PASS - truth table matches a + b");
        else             $display("RESULT: FAIL - %0d errors", errors);
        $finish;
    end
endmodule
