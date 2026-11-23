//==============================================================================
// Project     : 100 Days of RTL Design - Day 74 / 100
// Design      : LCM Calculator
// File        : lcm_calc.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : GCD followed by a shift-subtract divider, fully synthesisable
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// LCM calculator, lcm(a, b) = a * b / gcd(a, b).
// The earlier version used a while loop inside always @(*), which works in
// simulation but cannot be synthesised (unbounded loop). This version is
// sequential: an FSM runs Euclid's algorithm with the modulo replaced by
// repeated subtraction, then a shift-subtract divider computes a*b / gcd.
module lcm_calc (
    input             clk,
    input             rst,
    input             start,
    input      [7:0]  a,
    input      [7:0]  b,
    output reg [15:0] lcm,
    output reg        done
);
    localparam IDLE = 3'd0, GCD = 3'd1, DIV = 3'd2, FIN = 3'd3;
    reg [2:0]  state;
    reg [7:0]  x, y;          // GCD registers
    reg [15:0] prod;          // a * b
    reg [15:0] quo;
    reg [16:0] rem;
    reg [4:0]  cnt;

    wire [16:0] rem_sh = {rem[15:0], prod[15]};
    wire [16:0] trial  = rem_sh - {9'd0, x};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE; done <= 0; lcm <= 0;
            x <= 0; y <= 0; prod <= 0; quo <= 0; rem <= 0; cnt <= 0;
        end else begin
            done <= 0;
            case (state)
                IDLE: if (start) begin
                    if (a == 0 || b == 0) begin lcm <= 0; state <= FIN; end
                    else begin
                        x <= a; y <= b; prod <= a * b; state <= GCD;
                    end
                end
                GCD: begin                         // gcd ends up in x
                    if (x == y) begin state <= DIV; rem <= 0; quo <= 0; cnt <= 0; end
                    else if (x > y) x <= x - y;
                    else            y <= y - x;
                end
                DIV: begin                         // prod / x, one bit per clock
                    prod <= {prod[14:0], 1'b0};
                    if (trial[16]) begin rem <= rem_sh;  quo <= {quo[14:0], 1'b0}; end
                    else           begin rem <= trial;   quo <= {quo[14:0], 1'b1}; end
                    cnt <= cnt + 1'b1;
                    if (cnt == 5'd15) begin
                        lcm   <= trial[16] ? {quo[14:0], 1'b0} : {quo[14:0], 1'b1};
                        state <= FIN;
                    end
                end
                FIN: begin done <= 1; state <= IDLE; end
            endcase
        end
    end
endmodule
