//==============================================================================
// Project     : 100 Days of RTL Design - Day 75 / 100
// Design      : MAC Unit
// File        : mac_unit.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Pipelined signed multiply-accumulate for dot products
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// Signed multiply-accumulate (MAC) unit: acc = acc + a * b every clock
// that 'en' is high. 8-bit signed inputs, 20-bit accumulator (room for
// 16 worst-case products without overflow). 'clr' starts a new sum.
// A two-stage pipeline: stage 1 multiplies, stage 2 accumulates.
module mac_unit (
    input                    clk,
    input                    rst,
    input                    en,
    input                    clr,
    input  signed [7:0]      a,
    input  signed [7:0]      b,
    output reg signed [19:0] acc,
    output reg               valid       // acc includes the last enabled product
);
    reg signed [15:0] prod;
    reg               prod_v, clr_d;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            prod <= 0; prod_v <= 0; clr_d <= 0; acc <= 0; valid <= 0;
        end else begin
            // stage 1: multiply
            prod   <= a * b;
            prod_v <= en;
            clr_d  <= clr;
            // stage 2: accumulate
            if (clr_d)       acc <= prod_v ? prod : 20'sd0;
            else if (prod_v) acc <= acc + prod;
            valid <= prod_v;
        end
    end
endmodule
