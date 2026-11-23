//==============================================================================
// Project     : 100 Days of RTL Design - Day 40 / 100
// Design      : 4-bit Synchronous Up Counter
// File        : up_counter.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Counter with enable and terminal count for chaining
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 4-bit synchronous up counter with enable.
// tc (terminal count) is high when the counter is at 15 and enabled,
// so counters can be chained.
module up_counter (
    input            clk,
    input            rst,
    input            en,
    output reg [3:0] count,
    output           tc
);
    always @(posedge clk or posedge rst) begin
        if (rst)     count <= 4'd0;
        else if (en) count <= count + 1'b1;
    end

    assign tc = en & (count == 4'd15);
endmodule
