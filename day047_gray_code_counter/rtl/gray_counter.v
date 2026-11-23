//==============================================================================
// Project     : 100 Days of RTL Design - Day 47 / 100
// Design      : Gray Code Counter
// File        : gray_counter.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Counter whose output changes one bit at a time
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 4-bit Gray code counter: a binary counter inside, Gray code outside.
// Only one output bit changes per count, which is why async FIFOs use it.
module gray_counter (
    input            clk,
    input            rst,
    input            en,
    output reg [3:0] gray
);
    reg [3:0] bin;
    wire [3:0] bin_next = bin + 1'b1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bin  <= 4'd0;
            gray <= 4'd0;
        end else if (en) begin
            bin  <= bin_next;
            gray <= bin_next ^ (bin_next >> 1);
        end
    end
endmodule
