//==============================================================================
// Project     : 100 Days of RTL Design - Day 48 / 100
// Design      : Clock Divider by 2, 4, 8
// File        : clock_divider.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Divided clocks from a free-running counter, periods measured
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// Clock divider by 2, 4 and 8 using a 3-bit counter.
// Bit n of a free-running counter toggles at clk / 2^(n+1), 50% duty cycle.
module clock_divider (
    input  clk,
    input  rst,
    output clk_div2,
    output clk_div4,
    output clk_div8
);
    reg [2:0] cnt;

    always @(posedge clk or posedge rst) begin
        if (rst) cnt <= 3'd0;
        else     cnt <= cnt + 1'b1;
    end

    assign clk_div2 = cnt[0];
    assign clk_div4 = cnt[1];
    assign clk_div8 = cnt[2];
endmodule
