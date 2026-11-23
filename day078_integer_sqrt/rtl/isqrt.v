//==============================================================================
// Project     : 100 Days of RTL Design - Day 78 / 100
// Design      : Integer Square Root
// File        : isqrt.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Bit-by-bit square root of a 16-bit number in 8 clocks
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 16-bit integer square root, root = floor(sqrt(n)), using the
// bit-by-bit (non-restoring digit) method: one result bit per clock,
// 8 clocks in total, only shifts, a subtractor and a comparator.
module isqrt (
    input             clk,
    input             rst,
    input             start,
    input      [15:0] n,
    output reg [7:0]  root,
    output reg [8:0]  rem,       // n - root^2
    output reg        done
);
    reg [15:0] x;        // remaining input bits
    reg [9:0]  r;        // partial remainder
    reg [7:0]  q;        // partial root
    reg [3:0]  cnt;
    reg        busy;

    wire [9:0] r_sh  = {r[7:0], x[15:14]};       // bring down two bits
    wire [9:0] trial = {q, 2'b01};               // 4*q + 1
    wire       ge    = (r_sh >= trial);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x <= 0; r <= 0; q <= 0; cnt <= 0; busy <= 0;
            root <= 0; rem <= 0; done <= 0;
        end else begin
            done <= 0;
            if (start && !busy) begin
                x <= n; r <= 0; q <= 0; cnt <= 0; busy <= 1;
            end else if (busy) begin
                x <= {x[13:0], 2'b00};
                r <= ge ? r_sh - trial : r_sh;
                q <= {q[6:0], ge};
                cnt <= cnt + 1'b1;
                if (cnt == 4'd7) begin
                    busy <= 0; done <= 1;
                    root <= {q[6:0], ge};
                    rem  <= ge ? r_sh - trial : r_sh;
                end
            end
        end
    end
endmodule
