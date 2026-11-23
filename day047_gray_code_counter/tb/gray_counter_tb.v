//==============================================================================
// Project     : 100 Days of RTL Design - Day 47 / 100
// Design      : Gray Code Counter
// File        : gray_counter_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Gray Code Counter
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module gray_counter_tb;
    reg clk = 0, rst = 1, en = 0;
    wire [3:0] gray;
    reg  [3:0] prev, bin_model = 0;
    integer i, errors = 0;

    gray_counter dut (.clk(clk), .rst(rst), .en(en), .gray(gray));

    always #5 clk = ~clk;

    initial begin
        #12 rst = 0; en = 1;
        prev = gray;
        for (i = 0; i < 40; i = i + 1) begin
            @(posedge clk); bin_model = bin_model + 1; #1;
            if (gray !== (bin_model ^ (bin_model >> 1))) errors = errors + 1;
            if (((gray ^ prev) & ((gray ^ prev) - 4'd1)) != 4'd0 || gray == prev) errors = errors + 1;
            if (i < 8) $display(" count %2d -> gray %b", bin_model, gray);
            prev = gray;
        end
        $display("Gray counter: 40 counts (including wrap 15 -> 0), one bit change every time");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
