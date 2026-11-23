//==============================================================================
// Project     : 100 Days of RTL Design - Day 55 / 100
// Design      : 101 Sequence Detector
// File        : seq_det_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the 101 Sequence Detector
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module seq_det_tb;
    reg clk = 0, rst = 1, din = 0;
    wire det;
    reg [2:0] hist = 0;
    reg exp = 0;
    integer i, errors = 0, found = 0;
    reg [15:0] demo = 16'b1010_1101_0010_1000;

    seq_det dut (.seq_in(din), .clock(clk), .reset(rst), .det_o(det));

    always #5 clk = ~clk;

    initial begin
        @(posedge clk); #1 rst = 0;
        // fixed demo stream first, then random bits
        for (i = 0; i < 300; i = i + 1) begin
            @(negedge clk);
            din = (i < 16) ? demo[15 - i] : $random;
            @(posedge clk);
            hist = {hist[1:0], din};
            exp  = (hist == 3'b101);
            #1;
            if (det !== exp) errors = errors + 1;
            if (det) found = found + 1;
        end
        $display("101 detector: 300 bits (demo 1010110100101000 + random), %0d detections, overlap allowed", found);
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
