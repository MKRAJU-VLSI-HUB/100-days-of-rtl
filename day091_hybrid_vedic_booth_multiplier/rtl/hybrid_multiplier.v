//==============================================================================
// Project     : 100 Days of RTL Design - Day 91 / 100
// Design      : Hybrid Vedic + Booth Multiplier
// File        : hybrid_multiplier.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Picks a recursive Vedic multiplier or a Booth multiplier based on operand signs
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// Hybrid Vedic + Booth multiplier.
// - Vedic path : unsigned, built recursively from 2x2 Urdhva Tiryagbhyam cells
//                (W x W is made of four W/2 x W/2 blocks plus adders).
// - Booth path : signed radix-2 Booth (combinational, unrolled).
// - Mode logic : 00 = auto, 01 = force Vedic, 10 = force Booth.
//                In auto mode, if both operands are non-negative (MSB = 0)
//                the faster unsigned Vedic path is used, otherwise Booth.
module hybrid_multiplier #(parameter W = 16) (
    input  [W-1:0]   A,
    input  [W-1:0]   B,
    input  [1:0]     mode_in,
    output [2*W-1:0] final_result,
    output [1:0]     chosen_mode
);
    wire [2*W-1:0] vedic_out, booth_out;

    vedic_mul  #(W) U1 (.A(A), .B(B), .P(vedic_out));
    booth_mul  #(W) U2 (.A(A), .B(B), .P(booth_out));
    mode_logic #(W) U3 (.A(A), .B(B), .mode_in(mode_in), .chosen_mode(chosen_mode));
    result_mux #(W) U4 (.vedic_res(vedic_out), .booth_res(booth_out),
                        .chosen_mode(chosen_mode), .final_res(final_result));
endmodule

// Recursive Vedic multiplier (W must be a power of 2, at least 2)
module vedic_mul #(parameter W = 16) (
    input  [W-1:0]   A,
    input  [W-1:0]   B,
    output [2*W-1:0] P
);
    generate
        if (W == 2) begin : base
            wire t1 = A[1] & B[0], t2 = A[0] & B[1], t3 = A[1] & B[1];
            wire c1 = t1 & t2;
            assign P = {t3 & c1, t3 ^ c1, t1 ^ t2, A[0] & B[0]};
        end else begin : split
            localparam H = W / 2;
            wire [W-1:0] ll, hl, lh, hh;
            vedic_mul #(H) m0 (.A(A[H-1:0]), .B(B[H-1:0]), .P(ll));   // low  x low
            vedic_mul #(H) m1 (.A(A[W-1:H]), .B(B[H-1:0]), .P(hl));   // high x low
            vedic_mul #(H) m2 (.A(A[H-1:0]), .B(B[W-1:H]), .P(lh));   // low  x high
            vedic_mul #(H) m3 (.A(A[W-1:H]), .B(B[W-1:H]), .P(hh));   // high x high
            // crosswise sum in the middle, then add everything in place
            wire [W:0]       mid = hl + lh;
            wire [W+H-1:0]   up  = {hh, {H{1'b0}}} + mid + ll[W-1:H];
            assign P = {up, ll[H-1:0]};
        end
    endgenerate
endmodule

// Signed radix-2 Booth multiplier, unrolled. The upper part of the
// accumulator has one extra bit so that adding or subtracting the most
// negative value cannot overflow.
module booth_mul #(parameter W = 16) (
    input  signed [W-1:0]   A,
    input  signed [W-1:0]   B,
    output signed [2*W-1:0] P
);
    reg signed [2*W+1:0] acc;     // {upper (W+1 bits), B (W bits), q_-1}
    reg signed [W:0]     upper;
    integer k;

    always @(*) begin
        acc = {{(W+1){1'b0}}, B, 1'b0};
        for (k = 0; k < W; k = k + 1) begin
            upper = acc[2*W+1:W+1];
            case (acc[1:0])
                2'b01: upper = upper + {A[W-1], A};
                2'b10: upper = upper - {A[W-1], A};
                default: ;
            endcase
            acc = {upper, acc[W:0]};
            acc = acc >>> 1;
        end
    end

    assign P = acc[2*W:1];
endmodule

module mode_logic #(parameter W = 16) (
    input  [W-1:0]   A,
    input  [W-1:0]   B,
    input  [1:0]     mode_in,
    output reg [1:0] chosen_mode
);
    always @(*) begin
        case (mode_in)
            2'b01:   chosen_mode = 2'b01;                                       // force Vedic
            2'b10:   chosen_mode = 2'b10;                                       // force Booth
            2'b00:   chosen_mode = (!A[W-1] && !B[W-1]) ? 2'b01 : 2'b10;       // auto
            default: chosen_mode = 2'b01;
        endcase
    end
endmodule

module result_mux #(parameter W = 16) (
    input      [2*W-1:0] vedic_res,
    input      [2*W-1:0] booth_res,
    input      [1:0]     chosen_mode,
    output reg [2*W-1:0] final_res
);
    always @(*) final_res = (chosen_mode == 2'b10) ? booth_res : vedic_res;
endmodule
