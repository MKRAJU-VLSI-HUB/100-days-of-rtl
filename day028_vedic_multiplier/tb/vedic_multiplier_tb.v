//==============================================================================
// Project     : 100 Days of RTL Design - Day 28 / 100
// Design      : 4x4 Vedic Multiplier
// File        : vedic_multiplier_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the 4x4 Vedic Multiplier
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module vedic_multiplier_tb;
    reg  [3:0] a, b;
    wire [7:0] p;
    integer i, errors = 0;

    vedic_multiplier dut (.a(a), .b(b), .p(p));

    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            {a, b} = i[7:0]; #5;
            if (p !== a * b) begin
                errors = errors + 1;
                $display("MISMATCH %0d x %0d -> %0d", a, b, p);
            end
        end
        a = 13; b = 11; #5; $display("Example: 13 x 11 = %0d", p);
        $display("Vedic multiplier: all 256 products checked");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
