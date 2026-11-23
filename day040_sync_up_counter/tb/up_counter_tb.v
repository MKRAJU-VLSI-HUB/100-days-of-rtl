//==============================================================================
// Project     : 100 Days of RTL Design - Day 40 / 100
// Design      : 4-bit Synchronous Up Counter
// File        : up_counter_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the 4-bit Synchronous Up Counter
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module up_counter_tb;
    reg clk = 0, rst = 1, en = 0;
    wire [3:0] count;
    wire tc;
    reg  [3:0] model = 0;
    integer i, errors = 0, wraps = 0;

    up_counter dut (.clk(clk), .rst(rst), .en(en), .count(count), .tc(tc));

    always #5 clk = ~clk;

    initial begin
        #12 rst = 0;
        for (i = 0; i < 100; i = i + 1) begin
            @(negedge clk);
            en = (i % 7 != 3);                // pause now and then
            #1;
            if (tc !== (en && model == 15)) errors = errors + 1;
            if (tc) wraps = wraps + 1;
            @(posedge clk); if (en) model = model + 1; #1;
            if (count !== model) errors = errors + 1;
        end
        $display("Up counter: 100 cycles with enable pauses, %0d wrap-arounds seen", wraps);
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
