//==============================================================================
// Project     : 100 Days of RTL Design - Day 76 / 100
// Design      : 4-Tap FIR Filter
// File        : fir4.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Low-pass filter with coefficients 1 3 3 1
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 4-tap FIR low-pass filter, direct form.
// y[n] = h0*x[n] + h1*x[n-1] + h2*x[n-2] + h3*x[n-3]
// Coefficients 1, 3, 3, 1 (sum 8) so dividing by 8 gives unity gain at DC.
// 8-bit signed input, registered output.
module fir4 (
    input                   clk,
    input                   rst,
    input                   en,          // new sample
    input  signed [7:0]     x,
    output reg signed [7:0] y
);
    localparam signed [3:0] H0 = 4'sd1, H1 = 4'sd3, H2 = 4'sd3, H3 = 4'sd1;

    reg signed [7:0] x1, x2, x3;          // delay line

    wire signed [11:0] sum = H0 * x + H1 * x1 + H2 * x2 + H3 * x3;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x1 <= 0; x2 <= 0; x3 <= 0; y <= 0;
        end else if (en) begin
            x3 <= x2; x2 <= x1; x1 <= x;
            y  <= sum >>> 3;                 // divide by 8
        end
    end
endmodule
