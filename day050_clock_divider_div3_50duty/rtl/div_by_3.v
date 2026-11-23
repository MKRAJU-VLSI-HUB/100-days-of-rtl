//==============================================================================
// Project     : 100 Days of RTL Design - Day 50 / 100
// Design      : Divide-by-3 with 50% Duty
// File        : div_by_3.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Uses both clock edges to get an exact 50% duty cycle
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// Divide-by-3 clock divider with a true 50% duty cycle.
// A mod-3 counter makes a 1-of-3 pulse on the rising edge; a copy of it
// delayed by half a cycle (falling edge) is ORed in, stretching the high
// time to exactly 1.5 input periods.
module div_by_3 (
    input  clk,
    input  rst,
    output clk_out
);
    reg [1:0] cnt;
    reg       pos_q, neg_q;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt   <= 2'd0;
            pos_q <= 1'b0;
        end else begin
            cnt   <= (cnt == 2'd2) ? 2'd0 : cnt + 1'b1;
            pos_q <= (cnt == 2'd0);
        end
    end

    always @(negedge clk or posedge rst) begin
        if (rst) neg_q <= 1'b0;
        else     neg_q <= pos_q;
    end

    assign clk_out = pos_q | neg_q;
endmodule
