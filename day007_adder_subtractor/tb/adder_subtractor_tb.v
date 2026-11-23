//==============================================================================
// Project     : 100 Days of RTL Design - Day 7 / 100
// Design      : 4-bit Adder / Subtractor
// File        : adder_subtractor_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the 4-bit Adder / Subtractor
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module adder_subtractor_tb;
    reg  [3:0] a, b;
    reg        mode;
    wire [3:0] result;
    wire       cout, overflow;
    integer i, errors = 0, exp_s;
    reg [3:0] exp;
    reg exp_ovf;

    adder_subtractor dut (.a(a), .b(b), .mode(mode), .result(result), .cout(cout), .overflow(overflow));

    initial begin
        for (i = 0; i < 512; i = i + 1) begin
            {mode, a, b} = i[8:0];
            #5;
            exp     = mode ? a - b : a + b;
            exp_s   = mode ? $signed(a) - $signed(b) : $signed(a) + $signed(b);
            exp_ovf = (exp_s > 7) || (exp_s < -8);
            if (result !== exp || overflow !== exp_ovf) begin
                errors = errors + 1;
                $display("MISMATCH mode=%b a=%0d b=%0d result=%0d ovf=%b", mode, a, b, result, overflow);
            end
        end
        $display("Adder/subtractor: 512 vectors checked (add and subtract, signed overflow)");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
