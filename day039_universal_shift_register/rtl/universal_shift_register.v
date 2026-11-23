//==============================================================================
// Project     : 100 Days of RTL Design - Day 39 / 100
// Design      : Universal Shift Register
// File        : universal_shift_register.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Hold, shift left, shift right and parallel load like the 74194
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 4-bit universal shift register (like the 74194)
// mode: 00 = hold, 01 = shift right, 10 = shift left, 11 = parallel load
module universal_shift_register (
    input            clk,
    input            rst,
    input      [1:0] mode,
    input      [3:0] pin,
    input            sr_in,     // serial input for shift right (enters at MSB)
    input            sl_in,     // serial input for shift left  (enters at LSB)
    output reg [3:0] q
);
    always @(posedge clk or posedge rst) begin
        if (rst) q <= 4'b0000;
        else begin
            case (mode)
                2'b00: q <= q;
                2'b01: q <= {sr_in, q[3:1]};
                2'b10: q <= {q[2:0], sl_in};
                2'b11: q <= pin;
            endcase
        end
    end
endmodule
