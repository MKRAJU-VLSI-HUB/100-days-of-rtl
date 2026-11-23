//==============================================================================
// Project     : 100 Days of RTL Design - Day 23 / 100
// Design      : 8-bit Barrel Shifter
// File        : barrel_shifter.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Shift left/right, arithmetic shift and rotate in three mux stages
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 8-bit barrel shifter built as 3 mux stages (shift by 1, 2, 4).
// op: 00 = logical left, 01 = logical right, 10 = arithmetic right, 11 = rotate left
module barrel_shifter (
    input  [7:0] din,
    input  [2:0] shamt,
    input  [1:0] op,
    output [7:0] dout
);
    function [7:0] stage(input [7:0] x, input [1:0] op, input integer n);
        begin
            case (op)
                2'b00: stage = x << n;
                2'b01: stage = x >> n;
                2'b10: stage = $signed(x) >>> n;
                2'b11: stage = (x << n) | (x >> (8 - n));
            endcase
        end
    endfunction

    wire [7:0] s1 = shamt[0] ? stage(din, op, 1) : din;
    wire [7:0] s2 = shamt[1] ? stage(s1,  op, 2) : s1;
    wire [7:0] s3 = shamt[2] ? stage(s2,  op, 4) : s2;
    assign dout = s3;
endmodule
