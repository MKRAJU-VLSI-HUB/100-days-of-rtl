//==============================================================================
// Project     : 100 Days of RTL Design - Day 50 / 100
// Design      : Divide-by-3 with 50% Duty
// File        : div_by_3_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Divide-by-3 with 50% Duty
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module div_by_3_tb;
    reg clk = 0, rst = 1;
    wire clk_out;
    realtime t_rise = 0, t_prev = 0, t_fall;
    integer periods = 0, errors = 0;

    div_by_3 dut (.clk(clk), .rst(rst), .clk_out(clk_out));

    always #5 clk = ~clk;   // 10 ns input

    always @(posedge clk_out) begin
        t_prev = t_rise; t_rise = $realtime;
        if (periods > 0 && t_rise - t_prev != 30.0) errors = errors + 1;
        periods = periods + 1;
    end
    always @(negedge clk_out) begin
        t_fall = $realtime;
        if (periods > 0 && t_fall - t_rise != 15.0) errors = errors + 1;
    end

    initial begin
        #12 rst = 0;
        #400;
        $display("Divide-by-3: input period 10 ns -> output period %0.0f ns, high time %0.0f ns",
                 t_rise - t_prev, t_fall - t_rise);
        $display("Duty cycle 50%% (15 ns high, 15 ns low), %0d output periods measured", periods);
        if (errors == 0 && periods > 10) $display("RESULT: PASS (0 errors)");
        else                             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
