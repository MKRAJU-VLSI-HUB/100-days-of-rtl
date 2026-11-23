//==============================================================================
// Project     : 100 Days of RTL Design - Day 34 / 100
// Design      : T Flip-Flop
// File        : t_flipflop_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the T Flip-Flop
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module t_flipflop_tb;
    reg clk = 0, rst = 1, t = 0;
    wire q;
    reg model = 0;
    integer i, errors = 0, toggles = 0;

    t_flipflop dut (.clk(clk), .rst(rst), .t(t), .q(q));

    always #5 clk = ~clk;

    initial begin
        #12 rst = 0;
        // t held high: q must toggle every clock (divide by 2)
        t = 1;
        for (i = 0; i < 10; i = i + 1) begin
            @(posedge clk); model = ~model; #1;
            if (q !== model) errors = errors + 1; else toggles = toggles + 1;
        end
        // random t
        for (i = 0; i < 100; i = i + 1) begin
            @(negedge clk); t = $random;
            @(posedge clk); if (t) model = ~model; #1;
            if (q !== model) errors = errors + 1;
        end
        $display("T flip-flop: toggles on every clock when t=1 (%0d/10), 100 random cycles checked", toggles);
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
