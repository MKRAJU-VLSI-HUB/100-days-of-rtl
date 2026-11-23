//==============================================================================
// Project     : 100 Days of RTL Design - Day 51 / 100
// Design      : PWM Generator
// File        : pwm_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the PWM Generator
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module pwm_tb;
    reg clk = 0, rst = 1;
    reg  [7:0] duty = 0;
    wire pwm_out;
    integer t, i, high, errors = 0;
    integer duties [0:5];

    pwm dut (.clk(clk), .rst(rst), .duty(duty), .pwm_out(pwm_out));

    always #5 clk = ~clk;

    initial begin
        duties[0] = 0; duties[1] = 32; duties[2] = 64; duties[3] = 128; duties[4] = 192; duties[5] = 255;
        @(posedge clk); #1 rst = 0;
        for (t = 0; t < 6; t = t + 1) begin
            duty = duties[t];
            // let the new value load at the period boundary, then measure one full period
            repeat (256) @(posedge clk);
            high = 0;
            for (i = 0; i < 256; i = i + 1) begin
                @(posedge clk); #1;
                high = high + pwm_out;
            end
            $display(" duty = %3d -> high for %3d of 256 clocks (%0d%%)", duties[t], high, high * 100 / 256);
            if (high != duties[t]) errors = errors + 1;
        end
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
