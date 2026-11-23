//==============================================================================
// Project     : 100 Days of RTL Design - Day 72 / 100
// Design      : Restoring Divider
// File        : restoring_divider.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : 8-bit quotient and remainder with divide-by-zero flag
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 8-bit unsigned restoring divider: quotient = dividend / divisor,
// remainder = dividend % divisor. One quotient bit per clock (8 clocks).
// Each step: shift the remainder left and bring in the next dividend bit,
// try subtracting the divisor; if the result is negative, restore it.
module restoring_divider (
    input            clk,
    input            rst,
    input            start,
    input      [7:0] dividend,
    input      [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg       done,
    output reg       div_by_zero
);
    reg [8:0] r;       // partial remainder (one extra bit for the sign test)
    reg [7:0] q, d;
    reg [3:0] cnt;
    reg       busy;

    wire [8:0] shifted = {r[7:0], q[7]};
    wire [8:0] trial   = shifted - {1'b0, d};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            r <= 0; q <= 0; d <= 0; cnt <= 0; busy <= 0;
            quotient <= 0; remainder <= 0; done <= 0; div_by_zero <= 0;
        end else begin
            done <= 0;
            if (start && !busy) begin
                if (divisor == 0) begin
                    quotient <= 8'hFF; remainder <= dividend;
                    div_by_zero <= 1; done <= 1;
                end else begin
                    r <= 0; q <= dividend; d <= divisor; cnt <= 0;
                    busy <= 1; div_by_zero <= 0;
                end
            end else if (busy) begin
                if (trial[8]) begin             // negative: restore
                    r <= shifted;
                    q <= {q[6:0], 1'b0};
                end else begin
                    r <= trial;
                    q <= {q[6:0], 1'b1};
                end
                cnt <= cnt + 1'b1;
                if (cnt == 4'd7) begin
                    busy      <= 0;
                    done      <= 1;
                    quotient  <= trial[8] ? {q[6:0], 1'b0} : {q[6:0], 1'b1};
                    remainder <= trial[8] ? shifted[7:0]   : trial[7:0];
                end
            end
        end
    end
endmodule
