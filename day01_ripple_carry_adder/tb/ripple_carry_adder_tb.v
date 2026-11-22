//==============================================================================
// Project     : 100 Days of RTL Design - Day 01
// File        : ripple_carry_adder_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Exhaustive self-checking testbench. Applies all 512 input
//               combinations (a, b, cin) and compares against a + b + cin.
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================
`timescale 1ns/1ps

module ripple_carry_adder_tb;

    reg  [3:0] a, b;
    reg        cin;
    wire [3:0] sum;
    wire       cout;

    integer i, errors;

    ripplecarry dut (.sum(sum), .cout(cout), .a(a), .b(b), .cin(cin));

    initial begin
        errors = 0;
        for (i = 0; i < 512; i = i + 1) begin
            {a, b, cin} = i[8:0];
            #5;
            if ({cout, sum} !== a + b + cin) begin
                errors = errors + 1;
                $display("MISMATCH a=%0d b=%0d cin=%0d -> got %0d, expected %0d",
                         a, b, cin, {cout, sum}, a + b + cin);
            end
        end

        $display("--------------------------------------------");
        $display(" Ripple carry adder: 512 vectors checked");
        if (errors == 0) $display(" RESULT: PASS (0 errors)");
        else             $display(" RESULT: FAIL (%0d errors)", errors);
        $display("--------------------------------------------");
        $finish;
    end

endmodule
