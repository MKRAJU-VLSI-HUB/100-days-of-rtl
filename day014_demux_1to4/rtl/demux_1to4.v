//==============================================================================
// Project     : 100 Days of RTL Design - Day 14 / 100
// Design      : 1:4 Demultiplexer
// File        : demux_1to4.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Routes one input to one of four outputs selected by sel
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 1:4 demultiplexer: the input is routed to the output picked by sel,
// all other outputs stay 0.
module demux_1to4 (
    input            din,
    input      [1:0] sel,
    output reg [3:0] y
);
    always @(*) begin
        y = 4'b0000;
        y[sel] = din;
    end
endmodule
