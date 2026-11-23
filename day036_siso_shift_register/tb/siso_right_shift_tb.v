//==============================================================================
// Project     : 100 Days of RTL Design - Day 36 / 100
// Design      : SISO Shift Register
// File        : siso_right_shift_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the SISO Shift Register
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module siso_right_shift_tb;
    reg clk = 0, rst = 1, si = 0;
    wire so;
    reg [99:0] sent;
    integer i, errors = 0;

    siso_right_shift dut (.clk(clk), .rst(rst), .si(si), .so(so));

    always #5 clk = ~clk;

    initial begin
        #12 rst = 0;
        for (i = 0; i < 100; i = i + 1) begin
            @(negedge clk); si = $random; sent[i] = si;
            @(posedge clk); #1;
            // the output now shows the bit sent 3 clocks before this one
            if (i >= 3 && so !== sent[i-3]) errors = errors + 1;
        end
        $display("SISO: 100 random bits shifted, each one appears at the output after 4 clocks");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
