//==============================================================================
// Project     : 100 Days of RTL Design - Day 26 / 100
// Design      : Population Count
// File        : popcount_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Population Count
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module popcount_tb;
    reg  [7:0] x;
    wire [3:0] count;
    integer i, k, exp, errors = 0;

    popcount dut (.x(x), .count(count));

    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            x = i; #5;
            exp = 0;
            for (k = 0; k < 8; k = k + 1) exp = exp + x[k];
            if (count !== exp) errors = errors + 1;
        end
        x = 8'b1011_0110; #5; $display("Example: 10110110 has %0d ones", count);
        $display("Population count: all 256 inputs checked");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
