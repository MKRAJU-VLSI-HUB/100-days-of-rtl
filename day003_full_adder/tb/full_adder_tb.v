//==============================================================================
// Project     : 100 Days of RTL Design - Day 3 / 100
// Design      : Full Adder
// File        : full_adder_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Full Adder
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module full_adder_tb;
    reg a, b, cin;
    wire sum, cout;
    integer i, errors = 0;

    full_adder dut (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

    initial begin
        $display(" a b cin | cout sum");
        for (i = 0; i < 8; i = i + 1) begin
            {a, b, cin} = i; #10;
            $display(" %b %b  %b  |  %b    %b", a, b, cin, cout, sum);
            if ({cout, sum} !== a + b + cin) errors = errors + 1;
        end
        if (errors == 0) $display("RESULT: PASS - all 8 combinations correct");
        else             $display("RESULT: FAIL - %0d errors", errors);
        $finish;
    end
endmodule
