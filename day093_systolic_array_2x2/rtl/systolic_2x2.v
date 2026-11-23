//==============================================================================
// Project     : 100 Days of RTL Design - Day 93 / 100
// Design      : 2x2 Systolic Array
// File        : systolic_2x2.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Output-stationary processing elements computing a matrix product
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 2x2 output-stationary systolic array for C = A x B (8-bit unsigned in,
// 18-bit accumulators). Rows of A flow left to right, columns of B flow
// top to bottom, each skewed by one clock. Every processing element (PE)
// multiplies the two values passing through it, adds to its own
// accumulator, and passes the inputs on to its neighbours.
module pe (
    input             clk,
    input             rst,
    input             clr,
    input      [7:0]  a_in,
    input      [7:0]  b_in,
    output reg [7:0]  a_out,
    output reg [7:0]  b_out,
    output reg [17:0] acc
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin a_out <= 0; b_out <= 0; acc <= 0; end
        else begin
            a_out <= a_in;
            b_out <= b_in;
            acc   <= (clr ? 18'd0 : acc) + a_in * b_in;
        end
    end
endmodule

module systolic_2x2 (
    input         clk,
    input         rst,
    input         clr,                 // start a new matrix product
    input  [7:0]  a_row0, a_row1,      // left edge inputs (already skewed)
    input  [7:0]  b_col0, b_col1,      // top edge inputs (already skewed)
    output [17:0] c00, c01, c10, c11
);
    wire [7:0] a00_01, a10_11;         // horizontal links
    wire [7:0] b00_10, b01_11;         // vertical links
    wire [7:0] unused_a0, unused_a1, unused_b0, unused_b1;
    reg        clr_d;                  // second diagonal clears one clock later

    always @(posedge clk or posedge rst) clr_d <= rst ? 1'b0 : clr;

    pe p00 (.clk(clk), .rst(rst), .clr(clr),   .a_in(a_row0), .b_in(b_col0), .a_out(a00_01),    .b_out(b00_10),    .acc(c00));
    pe p01 (.clk(clk), .rst(rst), .clr(clr_d), .a_in(a00_01), .b_in(b_col1), .a_out(unused_a0), .b_out(b01_11),    .acc(c01));
    pe p10 (.clk(clk), .rst(rst), .clr(clr_d), .a_in(a_row1), .b_in(b00_10), .a_out(a10_11),    .b_out(unused_b0), .acc(c10));
    reg clr_dd;
    always @(posedge clk or posedge rst) clr_dd <= rst ? 1'b0 : clr_d;
    pe p11 (.clk(clk), .rst(rst), .clr(clr_dd), .a_in(a10_11), .b_in(b01_11), .a_out(unused_a1), .b_out(unused_b1), .acc(c11));
endmodule
