//==============================================================================
// Project     : 100 Days of RTL Design - Day 71 / 100
// Design      : Booth Multiplier
// File        : booth_multiplier.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Signed radix-2 Booth algorithm, all 65536 pairs checked
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 8x8 signed sequential Booth multiplier (radix-2).
// Looks at the pair {Q[0], Q_-1} each clock:
//   01 -> A = A + M,   10 -> A = A - M,   00/11 -> no add
// then arithmetic-shifts {A, Q, Q_-1} right. 8 clocks per product.
// Runs of 1s in the multiplier cost no additions, only shifts.
// A is 9 bits wide so that A - M cannot overflow when M = -128.
module booth_multiplier (
    input                    clk,
    input                    rst,
    input                    start,
    input  signed [7:0]      m,          // multiplicand
    input  signed [7:0]      q,          // multiplier
    output signed [15:0]     product,
    output reg               done,
    output reg               busy
);
    reg signed [8:0] M, A;
    reg        [7:0] Q;
    reg              q_1;
    reg        [3:0] cnt;

    wire signed [8:0] A_add = (Q[0] & ~q_1) ? A - M :
                              (~Q[0] & q_1) ? A + M : A;

    assign product = {A[7:0], Q};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            M <= 0; A <= 0; Q <= 0; q_1 <= 0; cnt <= 0; done <= 0; busy <= 0;
        end else begin
            done <= 0;
            if (start && !busy) begin
                M <= {m[7], m}; A <= 0; Q <= q; q_1 <= 0; cnt <= 0; busy <= 1;
            end else if (busy) begin
                // arithmetic shift right of {A_add, Q, q_1}
                {A, Q, q_1} <= {A_add[8], A_add, Q};
                cnt <= cnt + 1'b1;
                if (cnt == 4'd7) begin busy <= 0; done <= 1; end
            end
        end
    end
endmodule
