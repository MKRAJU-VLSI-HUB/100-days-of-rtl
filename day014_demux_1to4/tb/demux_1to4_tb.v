//==============================================================================
// Project     : 100 Days of RTL Design - Day 14 / 100
// Design      : 1:4 Demultiplexer
// File        : demux_1to4_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the 1:4 Demultiplexer
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module demux_1to4_tb;
    reg        din;
    reg  [1:0] sel;
    wire [3:0] y;
    integer i, errors = 0;

    demux_1to4 dut (.din(din), .sel(sel), .y(y));

    initial begin
        $display(" din sel | y3 y2 y1 y0");
        for (i = 0; i < 8; i = i + 1) begin
            {din, sel} = i; #10;
            $display("  %b  %b  |  %b  %b  %b  %b", din, sel, y[3], y[2], y[1], y[0]);
            if (y !== ({3'b000, din} << sel)) errors = errors + 1;
        end
        if (errors == 0) $display("RESULT: PASS - all 8 combinations correct");
        else             $display("RESULT: FAIL - %0d errors", errors);
        $finish;
    end
endmodule
