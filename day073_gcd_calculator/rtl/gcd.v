//==============================================================================
// Project     : 100 Days of RTL Design - Day 73 / 100
// Design      : GCD Calculator
// File        : gcd.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Euclid algorithm with a datapath and controller
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// GCD calculator using the subtraction form of Euclid's algorithm,
// split into a datapath (two registers, a subtractor, a comparator)
// and a small controller. While a != b, subtract the smaller from the larger.
module gcd (
    input            clk,
    input            rst,
    input            start,
    input      [7:0] a_in,
    input      [7:0] b_in,
    output reg [7:0] result,
    output reg       done
);
    localparam IDLE = 2'd0, CALC = 2'd1, FIN = 2'd2;
    reg [1:0] state;
    reg [7:0] a, b;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE; a <= 0; b <= 0; result <= 0; done <= 0;
        end else begin
            done <= 0;
            case (state)
                IDLE: if (start) begin
                    a <= a_in; b <= b_in;
                    state <= CALC;
                end
                CALC: begin
                    if (a == 0)       begin result <= b; state <= FIN; end   // gcd(0, b) = b
                    else if (b == 0)  begin result <= a; state <= FIN; end
                    else if (a == b)  begin result <= a; state <= FIN; end
                    else if (a > b)   a <= a - b;
                    else              b <= b - a;
                end
                FIN: begin done <= 1; state <= IDLE; end
            endcase
        end
    end
endmodule
