//==============================================================================
// Project     : 100 Days of RTL Design - Day 32 / 100
// Design      : D Flip-Flop (sync and async reset)
// File        : dff_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the D Flip-Flop (sync and async reset)
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module dff_tb;
    reg clk = 0, rst = 0, d = 0;
    wire q_async, q_sync;
    integer i, errors = 0;
    reg exp;

    dff_async ua (.clk(clk), .rst(rst), .d(d), .q(q_async));
    dff_sync  us (.clk(clk), .rst(rst), .d(d), .q(q_sync));

    always #5 clk = ~clk;

    initial begin
        // random data: both flops must capture d on each rising edge
        for (i = 0; i < 50; i = i + 1) begin
            @(negedge clk); d = $random;
            exp = d;
            @(posedge clk); #1;
            if (q_async !== exp || q_sync !== exp) errors = errors + 1;
        end

        // set q = 1, then pulse reset in the middle of the low phase
        @(negedge clk); d = 1;
        @(posedge clk); #1;
        @(negedge clk); #1 rst = 1; #1;
        $display("Reset asserted between edges: q_async = %b (clears at once), q_sync = %b (waits for clock)", q_async, q_sync);
        if (q_async !== 1'b0 || q_sync !== 1'b1) errors = errors + 1;
        @(posedge clk); #1;
        if (q_sync !== 1'b0) errors = errors + 1;
        $display("After next clock edge:          q_sync = %b", q_sync);
        rst = 0;

        $display("D flip-flop: 50 random captures checked + async vs sync reset behaviour");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
