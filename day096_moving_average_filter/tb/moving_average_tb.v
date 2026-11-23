//==============================================================================
// Project     : 100 Days of RTL Design - Day 96 / 100
// Design      : Moving Average Filter
// File        : moving_average_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Moving Average Filter
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module moving_average_tb;
    reg clk = 0, rst = 1, en = 0;
    reg  [7:0] din = 0;
    wire [7:0] avg;
    reg  [7:0] hist [0:7];
    integer n, k, s, errors = 0, noise_in = 0, noise_out = 0, prev_in = 0, prev_out = 0;

    moving_average dut (.clk(clk), .rst(rst), .en(en), .din(din), .avg(avg));

    always #5 clk = ~clk;

    task sample(input [7:0] v);
        begin
            @(negedge clk); en = 1; din = v;
            @(posedge clk); #1;
            for (k = 7; k > 0; k = k - 1) hist[k] = hist[k-1];
            hist[0] = v;
            s = 0;
            for (k = 0; k < 8; k = k + 1) s = s + hist[k];
            if (avg !== s / 8) errors = errors + 1;
        end
    endtask

    initial begin
        for (k = 0; k < 8; k = k + 1) hist[k] = 0;
        @(posedge clk); #1 rst = 0;
        // step from 0 to 200: output ramps up over 8 samples
        $write("Step 0 -> 200, output:");
        for (n = 0; n < 10; n = n + 1) begin sample(200); $write(" %0d", avg); end
        $display("");
        // noisy signal around 100: measure how much the jumps shrink
        for (n = 0; n < 400; n = n + 1) begin
            sample(100 + ($random % 40));
            if (n > 8) begin
                noise_in  = noise_in  + ((din > prev_in)  ? din - prev_in  : prev_in - din);
                noise_out = noise_out + ((avg > prev_out) ? avg - prev_out : prev_out - avg);
            end
            prev_in = din; prev_out = avg;
        end
        $display("Noisy input (100 +/- 40): average sample-to-sample jump in %0d, out %0d",
                 noise_in / 391, noise_out / 391);
        for (n = 0; n < 300; n = n + 1) sample($random);
        $display("Moving average: 710 samples checked against the full 8-sample sum");
        if (errors == 0 && noise_out < noise_in / 3) $display("RESULT: PASS (0 errors)");
        else $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
