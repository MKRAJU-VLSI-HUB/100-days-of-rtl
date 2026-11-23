//==============================================================================
// Project     : 100 Days of RTL Design - Day 98 / 100
// Design      : 4-Digit 7-Segment Multiplexer
// File        : seg7_mux.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Time-multiplexed display driver with leading zero blanking
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 4-digit multiplexed seven-segment display driver.
// All four digits share the same 7 segment lines; one digit is switched
// on at a time (anode active low) and they are cycled fast enough that the
// eye sees all four lit. Input is a 16-bit value shown as 4 hex digits.
// Leading zeros are blanked.
module seg7_mux #(
    parameter REFRESH = 8            // clocks per digit
) (
    input            clk,
    input            rst,
    input     [15:0] value,
    output reg [3:0] an_n,           // digit enables, active low
    output reg [6:0] seg_n           // {g,f,e,d,c,b,a}, active low
);
    reg [$clog2(REFRESH)-1:0] t;
    reg [1:0] digit;

    always @(posedge clk or posedge rst) begin
        if (rst) begin t <= 0; digit <= 0; end
        else if (t == REFRESH - 1) begin t <= 0; digit <= digit + 1'b1; end
        else t <= t + 1'b1;
    end

    wire [3:0] nib = value[digit*4 +: 4];

    // blank leading zeros (digit 0 is always shown)
    wire blank = (digit == 3 && value[15:12] == 0) ||
                 (digit == 2 && value[15:8]  == 0) ||
                 (digit == 1 && value[15:4]  == 0);

    reg [6:0] seg;
    always @(*) begin
        case (nib)
            4'h0: seg = 7'b0111111; 4'h1: seg = 7'b0000110; 4'h2: seg = 7'b1011011; 4'h3: seg = 7'b1001111;
            4'h4: seg = 7'b1100110; 4'h5: seg = 7'b1101101; 4'h6: seg = 7'b1111101; 4'h7: seg = 7'b0000111;
            4'h8: seg = 7'b1111111; 4'h9: seg = 7'b1101111; 4'hA: seg = 7'b1110111; 4'hB: seg = 7'b1111100;
            4'hC: seg = 7'b0111001; 4'hD: seg = 7'b1011110; 4'hE: seg = 7'b1111001; default: seg = 7'b1110001;
        endcase
        seg_n = blank ? 7'b1111111 : ~seg;
        an_n  = ~(4'b0001 << digit);
    end
endmodule
