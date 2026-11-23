//==============================================================================
// Project     : 100 Days of RTL Design - Day 12 / 100
// Design      : 4:1 Multiplexer
// File        : mux4_1_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the 4:1 Multiplexer
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module mux4_1_tb;
    reg  [3:0] d;
    reg  [1:0] sel;
    wire       y;
    integer i, errors = 0;

    mux4_1 dut (.d(d), .sel(sel), .y(y));

    initial begin
        for (i = 0; i < 64; i = i + 1) begin
            {sel, d} = i[5:0]; #5;
            if (y !== d[sel]) errors = errors + 1;
        end
        $display("4:1 mux: all 64 combinations of data and select checked");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
