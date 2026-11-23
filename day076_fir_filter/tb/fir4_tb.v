//==============================================================================
// Project     : 100 Days of RTL Design - Day 76 / 100
// Design      : 4-Tap FIR Filter
// File        : fir4_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the 4-Tap FIR Filter
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module fir4_tb;
    reg clk = 0, rst = 1, en = 0;
    reg  signed [7:0] x = 0;
    wire signed [7:0] y;
    integer n, errors = 0, h1, h2, h3, exp, max_hf = 0, max_lf = 0;
    reg signed [7:0] d1 = 0, d2 = 0, d3 = 0;

    fir4 dut (.clk(clk), .rst(rst), .en(en), .x(x), .y(y));

    always #5 clk = ~clk;

    task sample(input signed [7:0] s);
        begin
            @(negedge clk); en = 1; x = s;
            exp = (s + 3 * d1 + 3 * d2 + d3) >>> 3;
            @(posedge clk); #1;
            d3 = d2; d2 = d1; d1 = s;
            if (y !== exp[7:0]) errors = errors + 1;
        end
    endtask

    initial begin
        @(posedge clk); #1 rst = 0;
        // impulse response
        $write("Impulse response (input 64 then zeros): ");
        sample(64); $write("%0d ", y);
        for (n = 0; n < 4; n = n + 1) begin sample(0); $write("%0d ", y); end
        $display("");
        // DC: output settles to the input value
        for (n = 0; n < 8; n = n + 1) sample(80);
        $display("DC input 80 -> output %0d (unity gain)", y);
        if (y !== 80) errors = errors + 1;
        // highest frequency (+100, -100, ...) is removed
        for (n = 0; n < 16; n = n + 1) begin
            sample((n % 2) ? -100 : 100);
            if (n > 4 && (y > max_hf || -y > max_hf)) max_hf = (y > 0) ? y : -y;
        end
        $display("Nyquist-rate input +/-100 -> output amplitude %0d (filtered out)", max_hf);
        if (max_hf > 1) errors = errors + 1;
        // random signal vs reference model
        for (n = 0; n < 500; n = n + 1) sample($random);
        $display("FIR: impulse, DC, high-frequency and 500 random samples checked against the equation");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
