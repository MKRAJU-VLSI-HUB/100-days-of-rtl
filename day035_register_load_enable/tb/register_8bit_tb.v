//==============================================================================
// Project     : 100 Days of RTL Design - Day 35 / 100
// Design      : 8-bit Register
// File        : register_8bit_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the 8-bit Register
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module register_8bit_tb;
    reg        clk = 0, rst_n = 0, clr = 0, load = 0, oe = 0;
    reg  [7:0] d = 0, model = 0;
    wire [7:0] q_bus, q;
    integer i, errors = 0;

    register_8bit dut (.clk(clk), .rst_n(rst_n), .clr(clr), .load(load), .oe(oe),
                       .d(d), .q_bus(q_bus), .q(q));

    always #5 clk = ~clk;

    initial begin
        #12 rst_n = 1;
        for (i = 0; i < 200; i = i + 1) begin
            @(negedge clk);
            d = $random; load = $random; clr = ($random % 8 == 0); oe = $random;
            @(posedge clk);
            if (clr) model = 0; else if (load) model = d;
            #1;
            if (q !== model) errors = errors + 1;
            if (oe && q_bus !== model) errors = errors + 1;
            if (!oe && q_bus !== 8'hzz) errors = errors + 1;
        end
        $display("8-bit register: 200 random cycles of load / clear / output enable");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
