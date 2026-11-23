//==============================================================================
// Project     : 100 Days of RTL Design - Day 4 / 100
// Design      : Half Subtractor
// File        : half_subtractor_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Half Subtractor
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module half_subtractor_tb;
    reg a, b;
    wire diff, borrow;
    integer i, errors = 0;

    half_subtractor dut (.a(a), .b(b), .diff(diff), .borrow(borrow));

    initial begin
        $display(" a b | borrow diff");
        for (i = 0; i < 4; i = i + 1) begin
            {a, b} = i; #10;
            $display(" %b %b |   %b     %b", a, b, borrow, diff);
            // a - b as 2-bit two's complement: {borrow, diff}
            if ({borrow, diff} !== ((a - b) & 2'b11)) errors = errors + 1;
        end
        if (errors == 0) $display("RESULT: PASS - truth table matches a - b");
        else             $display("RESULT: FAIL - %0d errors", errors);
        $finish;
    end
endmodule
