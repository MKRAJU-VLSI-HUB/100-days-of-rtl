//==============================================================================
// Project     : 100 Days of RTL Design - Day 64 / 100
// Design      : Sine Look-up ROM
// File        : sine_rom.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : 32-sample sine wave built from a 9-entry quarter table
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// Sine look-up ROM: 32 samples of one full sine period, 8-bit unsigned
// (128 = zero, 255 = +1, 1 = -1). Only a quarter wave (9 values) is
// stored; the other three quarters come from symmetry, which cuts the
// table to under a third of the size.
module sine_rom (
    input            clk,
    input      [4:0] addr,      // phase 0..31
    output reg [7:0] data
);
    reg [6:0] quarter [0:8];
    initial begin
        // round(127 * sin(k * 90 / 8 degrees)), k = 0..8
        quarter[0] = 7'd0;   quarter[1] = 7'd25;  quarter[2] = 7'd49;
        quarter[3] = 7'd71;  quarter[4] = 7'd90;  quarter[5] = 7'd106;
        quarter[6] = 7'd117; quarter[7] = 7'd125; quarter[8] = 7'd127;
    end

    wire [1:0] quad = addr[4:3];
    wire [2:0] idx  = addr[2:0];
    wire [3:0] k    = quad[0] ? (4'd8 - idx) : {1'b0, idx};   // mirror in quadrants 1 and 3
    wire [6:0] mag  = quarter[k];

    always @(posedge clk)
        data <= quad[1] ? (8'd128 - mag) : (8'd128 + mag);    // negative half in 2 and 3
endmodule
