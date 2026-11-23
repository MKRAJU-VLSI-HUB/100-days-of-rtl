//==============================================================================
// Project     : 100 Days of RTL Design - Day 46 / 100
// Design      : 8-bit LFSR
// File        : lfsr8_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the 8-bit LFSR
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module lfsr8_tb;
    reg clk = 0, rst = 1, en = 0;
    reg  [7:0] seed = 8'hA5;
    wire [7:0] q;
    reg  seen [0:255];
    integer i, period = 0, errors = 0, unique_states = 0;
    reg [7:0] start;

    lfsr8 dut (.clk(clk), .rst(rst), .en(en), .seed(seed), .q(q));

    always #5 clk = ~clk;

    initial begin
        for (i = 0; i < 256; i = i + 1) seen[i] = 0;
        #12 rst = 0; en = 1;
        start = q;
        seen[q] = 1; unique_states = 1;
        for (i = 0; i < 300; i = i + 1) begin
            @(posedge clk); #1;
            if (q == 8'h00) errors = errors + 1;          // must never lock up
            if (period == 0 && q == start) period = i + 1;
            if (!seen[q]) begin seen[q] = 1; unique_states = unique_states + 1; end
            if (i < 5) $display(" q = %h", q);
        end
        $display("LFSR: period = %0d, distinct states visited = %0d", period, unique_states);
        if (errors == 0 && period == 255 && unique_states == 255) $display("RESULT: PASS - maximal length sequence");
        else $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
