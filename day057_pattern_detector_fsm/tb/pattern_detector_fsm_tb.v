//==============================================================================
// Project     : 100 Days of RTL Design - Day 57 / 100
// Design      : Pattern Detector 000111000
// File        : pattern_detector_fsm_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Pattern Detector 000111000
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module pattern_detector_fsm_tb;
    reg clk = 0, rst_n = 0, in_bit = 0;
    wire detected;
    reg [8:0] hist = 9'h1FF;      // start with 1s so no false early match
    reg match_prev = 0;
    integer i, errors = 0, found = 0;
    reg [26:0] demo = 27'b000111000_111000_0001110001_11;   // has overlapping matches

    pattern_detector_fsm dut (.clk(clk), .rst_n(rst_n), .in_bit(in_bit), .detected(detected));

    always #5 clk = ~clk;

    initial begin
        @(posedge clk); #1 rst_n = 1;
        for (i = 0; i < 2000; i = i + 1) begin
            @(negedge clk);
            // demo first, then biased random bits so the pattern shows up often
            if (i < 27) in_bit = demo[26 - i];
            else        in_bit = (i % 9 < 3 || i % 9 > 5) ? ($random % 6 != 0 ? 0 : 1) : ($random % 6 != 0);
            @(posedge clk);
            #1;
            // detected is registered: it reflects a match completed on the previous bit
            if (detected !== match_prev) errors = errors + 1;
            if (detected) found = found + 1;
            hist = {hist[7:0], in_bit};
            match_prev = (hist == 9'b000111000);
        end
        $display("Pattern 000111000: 2000 bits checked against a shift-register model, %0d detections", found);
        if (errors == 0 && found > 0) $display("RESULT: PASS (0 errors)");
        else                          $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
