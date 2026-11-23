//==============================================================================
// Project     : 100 Days of RTL Design - Day 21 / 100
// Design      : BCD to 7-Segment Decoder
// File        : bcd_to_7seg.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Drives a 7-segment display for digits 0-9, prints the digits as ASCII art
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// BCD to 7-segment decoder (common cathode, active-high segments).
// seg = {g, f, e, d, c, b, a}. Inputs 10..15 blank the display.
module bcd_to_7seg (
    input      [3:0] bcd,
    output reg [6:0] seg
);
    always @(*) begin
        case (bcd)
            4'd0: seg = 7'b011_1111;
            4'd1: seg = 7'b000_0110;
            4'd2: seg = 7'b101_1011;
            4'd3: seg = 7'b100_1111;
            4'd4: seg = 7'b110_0110;
            4'd5: seg = 7'b110_1101;
            4'd6: seg = 7'b111_1101;
            4'd7: seg = 7'b000_0111;
            4'd8: seg = 7'b111_1111;
            4'd9: seg = 7'b110_1111;
            default: seg = 7'b000_0000;
        endcase
    end
endmodule
