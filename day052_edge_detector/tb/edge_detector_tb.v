//==============================================================================
// Project     : 100 Days of RTL Design - Day 52 / 100
// Design      : Edge Detector
// File        : edge_detector_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Edge Detector
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module edge_detector_tb;
    reg clk = 0, rst = 1, sig = 0;
    wire rise, fall, any_edge;
    reg prev = 0;
    integer i, errors = 0, n_rise = 0, n_fall = 0, exp_rise = 0, exp_fall = 0;

    edge_detector dut (.clk(clk), .rst(rst), .sig(sig), .rise(rise), .fall(fall), .any_edge(any_edge));

    always #5 clk = ~clk;

    initial begin
        @(posedge clk); #1 rst = 0;
        for (i = 0; i < 300; i = i + 1) begin
            @(negedge clk);
            sig = ($random % 4 == 0) ? ~sig : sig;   // change now and then
            #1;
            if (sig & ~prev) exp_rise = exp_rise + 1;
            if (~sig & prev) exp_fall = exp_fall + 1;
            if (rise !== (sig & ~prev) || fall !== (~sig & prev) || any_edge !== (sig ^ prev))
                errors = errors + 1;
            n_rise = n_rise + rise; n_fall = n_fall + fall;
            @(posedge clk); prev = sig;
        end
        $display("Edge detector: 300 clocks, rising edges %0d/%0d, falling edges %0d/%0d detected",
                 n_rise, exp_rise, n_fall, exp_fall);
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
