//==============================================================================
// Project     : 100 Days of RTL Design - Day 94 / 100
// Design      : CORDIC Sine / Cosine
// File        : cordic.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Shift-and-add rotations, results within about 1 LSB
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// CORDIC sine/cosine generator (rotation mode), 16-bit fixed point I/O.
// Angle input : Q2.14 radians (16384 = 1.0 rad), valid range -pi/2..+pi/2.
// Outputs     : Q1.14 (16384 = 1.0).
// Each iteration rotates the vector by +/- atan(2^-i) using only shifts
// and adds - no multipliers. Starting x at 1/K (K = 1.64676, the CORDIC
// gain) gives unscaled results.
// Internally the datapath carries 4 extra fraction bits (Q.18) so the
// truncation in the shifts does not pile up; outputs are rounded at the end.
module cordic (
    input                    clk,
    input                    rst,
    input                    start,
    input  signed [15:0]     angle,
    output reg signed [15:0] cos_out,
    output reg signed [15:0] sin_out,
    output reg               done
);
    localparam ITER = 16;

    // atan(2^-i) scaled by 2^18
    function signed [21:0] atan_tab(input [3:0] k);
        case (k)
            4'd0:  atan_tab = 22'sd205887; 4'd1:  atan_tab = 22'sd121543;
            4'd2:  atan_tab = 22'sd64220;  4'd3:  atan_tab = 22'sd32599;
            4'd4:  atan_tab = 22'sd16363;  4'd5:  atan_tab = 22'sd8189;
            4'd6:  atan_tab = 22'sd4096;   4'd7:  atan_tab = 22'sd2048;
            4'd8:  atan_tab = 22'sd1024;   4'd9:  atan_tab = 22'sd512;
            4'd10: atan_tab = 22'sd256;    4'd11: atan_tab = 22'sd128;
            4'd12: atan_tab = 22'sd64;     4'd13: atan_tab = 22'sd32;
            4'd14: atan_tab = 22'sd16;     default: atan_tab = 22'sd8;
        endcase
    endfunction

    reg signed [21:0] x, y, z;
    reg [3:0] i;
    reg       busy;

    wire signed [21:0] xs = x >>> i;
    wire signed [21:0] ys = y >>> i;
    wire signed [21:0] a  = atan_tab(i);
    wire               cw = z[21];          // z < 0: rotate clockwise

    wire signed [21:0] x_n = cw ? x + ys : x - ys;
    wire signed [21:0] y_n = cw ? y - xs : y + xs;
    wire signed [21:0] z_n = cw ? z + a  : z - a;

    // round from Q.18 back to Q.14
    wire signed [21:0] x_r = (x_n + 22'sd8) >>> 4;
    wire signed [21:0] y_r = (y_n + 22'sd8) >>> 4;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x <= 0; y <= 0; z <= 0; i <= 0; busy <= 0; done <= 0;
            cos_out <= 0; sin_out <= 0;
        end else begin
            done <= 0;
            if (start && !busy) begin
                x <= 22'sd159188;                       // 2^18 / 1.64676
                y <= 0;
                z <= {{2{angle[15]}}, angle, 4'b0000};  // Q2.14 -> Q.18
                i <= 0;
                busy <= 1;
            end else if (busy) begin
                x <= x_n; y <= y_n; z <= z_n;
                if (i == ITER - 1) begin
                    busy <= 0; done <= 1;
                    cos_out <= x_r[15:0];
                    sin_out <= y_r[15:0];
                end else i <= i + 1'b1;
            end
        end
    end
endmodule
