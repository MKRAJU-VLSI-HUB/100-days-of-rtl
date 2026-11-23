//==============================================================================
// Project     : 100 Days of RTL Design - Day 37 / 100
// Design      : SIPO Shift Register
// File        : sipo_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the SIPO Shift Register
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module sipo_tb;
    reg clk = 0, rst = 1, shift_en = 0, si = 0;
    wire [7:0] pout;
    wire valid;
    reg  [7:0] byte_tx;
    integer n, b, errors = 0, got = 0;

    sipo dut (.clk(clk), .rst(rst), .shift_en(shift_en), .si(si), .pout(pout), .valid(valid));

    always #5 clk = ~clk;

    initial begin
        #12 rst = 0;
        for (n = 0; n < 20; n = n + 1) begin
            byte_tx = $random;
            for (b = 7; b >= 0; b = b - 1) begin
                @(negedge clk); shift_en = 1; si = byte_tx[b];
            end
            @(negedge clk); shift_en = 0;
            if (!valid || pout !== byte_tx) errors = errors + 1;
            else got = got + 1;
            if (n < 3) $display(" sent %h, received %h", byte_tx, pout);
        end
        $display("SIPO: %0d of 20 bytes received correctly", got);
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
