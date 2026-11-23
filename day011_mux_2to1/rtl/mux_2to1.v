//==============================================================================
// Project     : 100 Days of RTL Design - Day 11 / 100
// Design      : 2:1 Multiplexer (3 styles)
// File        : mux_2to1.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Same mux in dataflow, gate level and behavioural Verilog, all three compared
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 2:1 multiplexer written three ways: dataflow, gate level and behavioural.
// All three must give the same output.
module mux_2to1 (
    input  a, b, sel,
    output y_dataflow,
    output y_gate,
    output reg y_behav
);
    // dataflow
    assign y_dataflow = sel ? b : a;

    // gate level
    wire nsel, t0, t1;
    not g0 (nsel, sel);
    and g1 (t0, a, nsel);
    and g2 (t1, b, sel);
    or  g3 (y_gate, t0, t1);

    // behavioural
    always @(*) begin
        if (sel) y_behav = b;
        else     y_behav = a;
    end
endmodule
