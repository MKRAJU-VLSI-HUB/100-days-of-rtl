//==============================================================================
// Project     : 100 Days of RTL Design - Day 49 / 100
// Design      : Divide-by-5 Clock Divider
// File        : div_by_5.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Odd divide ratio, 2 cycles high and 3 low
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// Divide-by-5 clock divider. A 3-bit counter runs 0..4; the
// output is high for 2 input cycles and low for 3 (40% duty).
module div_by_5 (
    input      clk,
    input      rst,
    output reg clk_out
);
    reg [2:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count   <= 3'd0;
            clk_out <= 1'b0;
        end else begin
            count <= count + 1;

            if (count < 3'd2)
                clk_out <= 1'b1;   // 2 cycles HIGH
            else
                clk_out <= 1'b0;   // 3 cycles LOW

            if (count == 3'd4)
                count <= 3'd0;
        end
    end
endmodule
