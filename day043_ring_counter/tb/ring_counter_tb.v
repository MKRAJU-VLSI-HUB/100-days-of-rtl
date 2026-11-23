//==============================================================================
// Project     : 100 Days of RTL Design - Day 43 / 100
// Design      : Ring Counter
// File        : ring_counter_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Ring Counter
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module ring_counter_tb;
    reg clk = 0, rst = 1;
    wire [3:0] q;
    reg  [3:0] model;
    integer i, errors = 0;

    ring_counter dut (.clk(clk), .rst(rst), .q(q));

    always #5 clk = ~clk;

    initial begin
        #12 rst = 0; model = 4'b0001;
        if (q !== model) errors = errors + 1;
        for (i = 0; i < 20; i = i + 1) begin
            @(posedge clk); model = {model[2:0], model[3]}; #1;
            if (i < 5) $display(" q = %b", q);
            if (q !== model || (q & (q - 1)) != 0 || q == 0) errors = errors + 1;   // must stay one-hot
        end
        $display("Ring counter: 20 clocks, output stayed one-hot and repeated every 4 clocks");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
