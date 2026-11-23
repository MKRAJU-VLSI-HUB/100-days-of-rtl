//==============================================================================
// Project     : 100 Days of RTL Design - Day 43 / 100
// Design      : Ring Counter
// File        : ring_counter.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : A single 1 circulates through 4 flip-flops
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 4-bit ring counter: a single 1 circulates, 4 states, one-hot output
module ring_counter (
    input            clk,
    input            rst,
    output reg [3:0] q
);
    always @(posedge clk or posedge rst) begin
        if (rst) q <= 4'b0001;
        else     q <= {q[2:0], q[3]};
    end
endmodule
