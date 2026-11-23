//==============================================================================
// Project     : 100 Days of RTL Design - Day 13 / 100
// Design      : 8:1 Multiplexer
// File        : mux_8to1_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the 8:1 Multiplexer
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module mux_8to1_tb;
    reg  [7:0] d;
    reg  [2:0] sel;
    wire       y;
    integer i, errors = 0;

    mux_8to1 dut (.d(d), .sel(sel), .y(y));

    initial begin
        for (i = 0; i < 2048; i = i + 1) begin
            {sel, d} = i[10:0]; #2;
            if (y !== d[sel]) errors = errors + 1;
        end
        $display("8:1 mux: all 2048 combinations checked");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
