//==============================================================================
// Project     : 100 Days of RTL Design - Day 38 / 100
// Design      : PISO Shift Register
// File        : piso_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the PISO Shift Register
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module piso_tb;
    reg clk = 0, rst = 1, load = 0;
    reg [7:0] pin = 0, rx;
    wire so, busy;
    integer n, b, errors = 0;

    piso dut (.clk(clk), .rst(rst), .load(load), .pin(pin), .so(so), .busy(busy));

    always #5 clk = ~clk;

    initial begin
        #12 rst = 0;
        for (n = 0; n < 20; n = n + 1) begin
            @(negedge clk); pin = $random; load = 1;
            @(negedge clk); load = 0;
            // sample 8 bits, one per clock
            for (b = 7; b >= 0; b = b - 1) begin
                rx[b] = so;
                @(negedge clk);
            end
            if (rx !== pin || busy) errors = errors + 1;
            if (n < 3) $display(" loaded %h, shifted out %h", pin, rx);
        end
        $display("PISO: 20 random bytes serialised MSB first");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
