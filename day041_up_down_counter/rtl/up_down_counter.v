//==============================================================================
// Project     : 100 Days of RTL Design - Day 41 / 100
// Design      : Up/Down Counter
// File        : up_down_counter.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : 4-bit counter that counts both ways with parallel load
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 4-bit up/down counter with synchronous reset and parallel load
module up_down_counter (
    input  wire       clk,
    input  wire       rst_n,      // sync active-low reset
    input  wire       load,
    input  wire       up_down,    // 1 = count up, 0 = count down
    input  wire [3:0] data_in,
    output reg  [3:0] count
);
    always @(posedge clk) begin
        if (!rst_n)       count <= 4'b0000;
        else if (load)    count <= data_in;
        else if (up_down) count <= count + 1'b1;
        else              count <= count - 1'b1;
    end
endmodule
