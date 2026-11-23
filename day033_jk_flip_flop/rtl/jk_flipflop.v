//==============================================================================
// Project     : 100 Days of RTL Design - Day 33 / 100
// Design      : JK Flip-Flop
// File        : jk_flipflop.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Hold, set, reset and toggle modes compared with a model
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// JK flip-flop with active-low asynchronous reset
module jk_flipflop (
    input  wire clk,
    input  wire rst_n,
    input  wire j,
    input  wire k,
    output reg  q,
    output wire qn
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 1'b0;
        else begin
            case ({j, k})
                2'b00: q <= q;      // hold
                2'b01: q <= 1'b0;   // reset
                2'b10: q <= 1'b1;   // set
                2'b11: q <= ~q;     // toggle
            endcase
        end
    end

    assign qn = ~q;
endmodule
