//==============================================================================
// Project     : 100 Days of RTL Design - Day 10 / 100
// Design      : BCD Adder
// File        : bcd_adder_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the BCD Adder
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module bcd_adder_tb;
    reg  [3:0] a, b;
    reg        cin;
    wire [3:0] sum;
    wire       cout;
    integer x, y, c, errors = 0, total;

    bcd_adder dut (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

    initial begin
        for (x = 0; x < 10; x = x + 1)
            for (y = 0; y < 10; y = y + 1)
                for (c = 0; c < 2; c = c + 1) begin
                    a = x; b = y; cin = c; #5;
                    total = x + y + c;
                    if (cout !== (total > 9) || sum !== total % 10) begin
                        errors = errors + 1;
                        $display("MISMATCH %0d + %0d + %0d -> %b %0d", x, y, c, cout, sum);
                    end
                end
        a = 7; b = 8; cin = 1; #5;
        $display("Example: 7 + 8 + 1 -> carry %b, digit %0d", cout, sum);
        $display("BCD adder: all 200 valid digit combinations checked");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
