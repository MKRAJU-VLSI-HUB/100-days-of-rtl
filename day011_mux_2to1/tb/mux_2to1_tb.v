//==============================================================================
// Project     : 100 Days of RTL Design - Day 11 / 100
// Design      : 2:1 Multiplexer (3 styles)
// File        : mux_2to1_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the 2:1 Multiplexer (3 styles)
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module mux_2to1_tb;
    reg a, b, sel;
    wire y_dataflow, y_gate, y_behav;
    integer i, errors = 0;
    reg exp;

    mux_2to1 dut (.a(a), .b(b), .sel(sel), .y_dataflow(y_dataflow), .y_gate(y_gate), .y_behav(y_behav));

    initial begin
        $display(" sel a b | dataflow gate behav");
        for (i = 0; i < 8; i = i + 1) begin
            {sel, a, b} = i; #10;
            exp = sel ? b : a;
            $display("  %b  %b %b |    %b      %b     %b", sel, a, b, y_dataflow, y_gate, y_behav);
            if (y_dataflow !== exp || y_gate !== exp || y_behav !== exp) errors = errors + 1;
        end
        if (errors == 0) $display("RESULT: PASS - all three styles agree on all 8 inputs");
        else             $display("RESULT: FAIL - %0d errors", errors);
        $finish;
    end
endmodule
