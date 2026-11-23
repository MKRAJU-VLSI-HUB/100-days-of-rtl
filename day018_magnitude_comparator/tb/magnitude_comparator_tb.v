//==============================================================================
// Project     : 100 Days of RTL Design - Day 18 / 100
// Design      : 4-bit Magnitude Comparator
// File        : magnitude_comparator_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the 4-bit Magnitude Comparator
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module magnitude_comparator_tb;
    reg  [3:0] a, b;
    wire       a_gt_b, a_eq_b, a_lt_b;
    integer i, errors = 0;

    magnitude_comparator dut (.a(a), .b(b), .a_gt_b(a_gt_b), .a_eq_b(a_eq_b), .a_lt_b(a_lt_b));

    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            {a, b} = i[7:0]; #5;
            if ({a_gt_b, a_eq_b, a_lt_b} !== {a > b, a == b, a < b}) errors = errors + 1;
        end
        $display("Magnitude comparator: all 256 pairs checked");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
