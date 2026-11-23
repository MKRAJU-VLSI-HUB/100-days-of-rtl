//==============================================================================
// Project     : 100 Days of RTL Design - Day 13 / 100
// Design      : 8:1 Multiplexer
// File        : mux_8to1.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : 8:1 mux built hierarchically from two 4:1 muxes and a 2:1 mux
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 8:1 multiplexer built from two 4:1 muxes and one 2:1 mux
module mux4 (
    input  [3:0] d,
    input  [1:0] sel,
    output       y
);
    assign y = d[sel];
endmodule

module mux_8to1 (
    input  [7:0] d,
    input  [2:0] sel,
    output       y
);
    wire y_lo, y_hi;

    mux4 m_lo (.d(d[3:0]), .sel(sel[1:0]), .y(y_lo));
    mux4 m_hi (.d(d[7:4]), .sel(sel[1:0]), .y(y_hi));

    assign y = sel[2] ? y_hi : y_lo;
endmodule
