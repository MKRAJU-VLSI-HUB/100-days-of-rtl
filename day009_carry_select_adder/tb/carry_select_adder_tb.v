//==============================================================================
// Project     : 100 Days of RTL Design - Day 9 / 100
// Design      : 8-bit Carry Select Adder
// File        : carry_select_adder_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the 8-bit Carry Select Adder
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module carry_select_adder_tb;
    reg  [7:0] a, b;
    reg        cin;
    wire [7:0] sum;
    wire       cout;
    integer i, errors = 0;

    carry_select_adder dut (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

    initial begin
        for (i = 0; i < 131072; i = i + 1) begin
            {a, b, cin} = i[16:0];
            #1;
            if ({cout, sum} !== a + b + cin) errors = errors + 1;
        end
        $display("Carry select adder: all 131072 input combinations checked");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
