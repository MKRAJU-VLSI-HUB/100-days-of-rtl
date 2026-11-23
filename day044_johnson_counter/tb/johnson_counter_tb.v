//==============================================================================
// Project     : 100 Days of RTL Design - Day 44 / 100
// Design      : Johnson Counter
// File        : johnson_counter_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Johnson Counter
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module johnson_counter_tb;
    reg clk = 0, rst = 1;
    wire [3:0] q;
    reg  [3:0] expected [0:7];
    reg  [3:0] prev;
    integer i, errors = 0;

    johnson_counter dut (.clk(clk), .rst(rst), .q(q));

    always #5 clk = ~clk;

    initial begin
        expected[0] = 4'b0000; expected[1] = 4'b0001; expected[2] = 4'b0011; expected[3] = 4'b0111;
        expected[4] = 4'b1111; expected[5] = 4'b1110; expected[6] = 4'b1100; expected[7] = 4'b1000;
        #12 rst = 0;
        prev = q;
        for (i = 1; i <= 24; i = i + 1) begin
            @(posedge clk); #1;
            if (i <= 8) $display(" state %0d: %b", i % 8, q);
            if (q !== expected[i % 8]) errors = errors + 1;
            if (((q ^ prev) & ((q ^ prev) - 1)) != 0) errors = errors + 1;  // exactly one bit changed
            prev = q;
        end
        $display("Johnson counter: 8-state sequence repeated 3 times, one bit change per clock");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
