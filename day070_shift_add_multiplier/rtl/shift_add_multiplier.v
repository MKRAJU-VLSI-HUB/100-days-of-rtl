//==============================================================================
// Project     : 100 Days of RTL Design - Day 70 / 100
// Design      : Shift-Add Multiplier
// File        : shift_add_multiplier.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : 8x8 sequential multiplier, one bit per clock
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 8x8 unsigned sequential multiplier (shift and add).
// One multiplier bit is handled per clock, so a product takes 8 clocks
// but only needs one 8-bit adder instead of a full array.
// Register layout: {acc (9 bits), mplier (8 bits)}. Each clock:
//   if mplier[0] = 1, add the multiplicand to acc; then shift everything right.
module shift_add_multiplier (
    input             clk,
    input             rst,
    input             start,
    input      [7:0]  a,          // multiplicand
    input      [7:0]  b,          // multiplier
    output     [15:0] product,
    output reg        busy,
    output reg        done
);
    reg [7:0]  mcand;
    reg [3:0]  cnt;
    reg [16:0] pr;                // {acc[8:0], mplier[7:0]}

    wire [8:0]  sum  = pr[0] ? ({1'b0, pr[15:8]} + mcand) : {1'b0, pr[15:8]};
    wire [16:0] next = {sum, pr[7:0]} >> 1;

    assign product = pr[15:0];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            busy <= 0; done <= 0; cnt <= 0; pr <= 0; mcand <= 0;
        end else begin
            done <= 0;
            if (start && !busy) begin
                mcand <= a;
                pr    <= {9'd0, b};
                cnt   <= 4'd0;
                busy  <= 1;
            end else if (busy) begin
                pr  <= next;
                cnt <= cnt + 1'b1;
                if (cnt == 4'd7) begin
                    busy <= 0;
                    done <= 1;
                end
            end
        end
    end
endmodule
