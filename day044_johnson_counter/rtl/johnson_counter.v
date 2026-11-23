//==============================================================================
// Project     : 100 Days of RTL Design - Day 44 / 100
// Design      : Johnson Counter
// File        : johnson_counter.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Twisted ring counter with 8 states and one bit change per clock
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 4-bit Johnson (twisted ring) counter: the inverted MSB feeds back,
// giving 8 states with only one bit changing per clock.
module johnson_counter (
    input            clk,
    input            rst,
    output reg [3:0] q
);
    always @(posedge clk or posedge rst) begin
        if (rst) q <= 4'b0000;
        else     q <= {q[2:0], ~q[3]};
    end
endmodule
