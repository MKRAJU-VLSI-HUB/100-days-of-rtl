//==============================================================================
// Project     : 100 Days of RTL Design - Day 36 / 100
// Design      : SISO Shift Register
// File        : siso_right_shift.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : 4-bit serial-in serial-out shift register
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 4-bit serial-in serial-out right shift register.
// A bit entering at si comes out at so four clocks later.
module siso_right_shift (
    input  clk,
    input  rst,
    input  si,
    output so
);
    reg [3:0] q;

    always @(posedge clk or posedge rst) begin
        if (rst) q <= 4'b0000;
        else     q <= {si, q[3:1]};
    end

    assign so = q[0];
endmodule
