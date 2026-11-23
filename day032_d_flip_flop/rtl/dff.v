//==============================================================================
// Project     : 100 Days of RTL Design - Day 32 / 100
// Design      : D Flip-Flop (sync and async reset)
// File        : dff.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Shows the difference between synchronous and asynchronous reset
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// D flip-flops: one with asynchronous reset, one with synchronous reset.
// The difference shows when reset is asserted between clock edges.
module dff_async (
    input      clk, rst, d,
    output reg q
);
    always @(posedge clk or posedge rst) begin
        if (rst) q <= 1'b0;
        else     q <= d;
    end
endmodule

module dff_sync (
    input      clk, rst, d,
    output reg q
);
    always @(posedge clk) begin
        if (rst) q <= 1'b0;
        else     q <= d;
    end
endmodule
