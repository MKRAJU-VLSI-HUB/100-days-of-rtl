//==============================================================================
// Project     : 100 Days of RTL Design - Day 8 / 100
// Design      : 4-bit Carry Look-Ahead Adder
// File        : carry_lookahead_adder_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the 4-bit Carry Look-Ahead Adder
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module carry_lookahead_adder_tb;
    reg  [3:0] a, b;
    reg        cin;
    wire [3:0] sum;
    wire       cout, pg, gg;
    integer i, errors = 0;

    carry_lookahead_adder dut (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout), .pg(pg), .gg(gg));

    initial begin
        for (i = 0; i < 512; i = i + 1) begin
            {a, b, cin} = i[8:0];
            #5;
            if ({cout, sum} !== a + b + cin) errors = errors + 1;
            if (cout !== (gg | (pg & cin)))  errors = errors + 1;
        end
        $display("Carry look-ahead adder: 512 vectors checked (sum, cout, group P/G)");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
