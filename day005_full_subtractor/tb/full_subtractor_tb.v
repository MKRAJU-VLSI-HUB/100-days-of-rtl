//==============================================================================
// Project     : 100 Days of RTL Design - Day 5 / 100
// Design      : Full Subtractor
// File        : full_subtractor_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Full Subtractor
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module full_subtractor_tb;
    reg a, b, bin;
    wire diff, bout;
    integer i, errors = 0;

    full_subtractor dut (.a(a), .b(b), .bin(bin), .diff(diff), .bout(bout));

    initial begin
        $display(" a b bin | bout diff");
        for (i = 0; i < 8; i = i + 1) begin
            {a, b, bin} = i; #10;
            $display(" %b %b  %b  |  %b    %b", a, b, bin, bout, diff);
            if ({bout, diff} !== ((a - b - bin) & 2'b11)) errors = errors + 1;
        end
        if (errors == 0) $display("RESULT: PASS - all 8 combinations correct");
        else             $display("RESULT: FAIL - %0d errors", errors);
        $finish;
    end
endmodule
