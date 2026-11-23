//==============================================================================
// Project     : 100 Days of RTL Design - Day 45 / 100
// Design      : 2-Digit BCD Counter
// File        : bcd_counter_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the 2-Digit BCD Counter
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module bcd_counter_tb;
    reg clk = 0, rst = 1, en = 0;
    wire [3:0] ones, tens;
    wire rollover;
    integer i, model = 0, errors = 0, rolls = 0;

    bcd_counter dut (.clk(clk), .rst(rst), .en(en), .ones(ones), .tens(tens), .rollover(rollover));

    always #5 clk = ~clk;

    initial begin
        #12 rst = 0;
        for (i = 0; i < 250; i = i + 1) begin
            @(negedge clk); en = 1; #1;
            if (rollover) rolls = rolls + 1;
            @(posedge clk); model = (model + 1) % 100; #1;
            if (tens !== model / 10 || ones !== model % 10) errors = errors + 1;
            if (i == 98 || i == 99 || i == 100) $display(" count = %0d%0d", tens, ones);
        end
        $display("BCD counter: 250 counts, rolled over from 99 to 00 %0d times", rolls);
        if (errors == 0 && rolls == 2) $display("RESULT: PASS (0 errors)");
        else                           $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
