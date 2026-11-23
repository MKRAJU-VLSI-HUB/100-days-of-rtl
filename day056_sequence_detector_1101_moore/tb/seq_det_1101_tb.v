//==============================================================================
// Project     : 100 Days of RTL Design - Day 56 / 100
// Design      : 1101 Detector (Moore vs Mealy)
// File        : seq_det_1101_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the 1101 Detector (Moore vs Mealy)
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module seq_det_1101_tb;
    reg clk = 0, rst = 1, din = 0;
    wire moore_out, mealy_out;
    reg [3:0] hist = 0;
    integer i, errors = 0, n_moore = 0, n_mealy = 0;
    reg [13:0] demo = 14'b11011011101101;

    seq_det_1101 dut (.clk(clk), .rst(rst), .din(din), .moore_out(moore_out), .mealy_out(mealy_out));

    always #5 clk = ~clk;

    initial begin
        @(posedge clk); #1 rst = 0;
        for (i = 0; i < 400; i = i + 1) begin
            @(negedge clk);
            din = (i < 14) ? demo[13 - i] : $random;
            #1;
            // Mealy: high in the same cycle the final 1 is on the input
            if (mealy_out !== ({hist[2:0], din} == 4'b1101)) errors = errors + 1;
            n_mealy = n_mealy + mealy_out;
            @(posedge clk);
            hist = {hist[2:0], din};
            #1;
            // Moore: high in the cycle after the final 1 was clocked in
            if (moore_out !== (hist == 4'b1101)) errors = errors + 1;
            n_moore = n_moore + moore_out;
        end
        $display("1101 detector: 400 bits, Moore found %0d, Mealy found %0d (Mealy is one clock earlier)", n_moore, n_mealy);
        if (errors == 0 && n_moore == n_mealy) $display("RESULT: PASS (0 errors)");
        else $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
