//==============================================================================
// Project     : 100 Days of RTL Design - Day 96 / 100
// Design      : Moving Average Filter
// File        : moving_average.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : 8-sample average with a running sum
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 8-sample moving average filter for 8-bit unsigned samples.
// Instead of adding all 8 samples every time, a running sum is kept:
// sum = sum + newest - oldest. Dividing by 8 is a shift by 3.
// Cost: one adder, one subtractor and an 8-entry delay line,
// whatever the window length.
module moving_average (
    input            clk,
    input            rst,
    input            en,
    input      [7:0] din,
    output     [7:0] avg
);
    reg [7:0]  win [0:7];
    reg [2:0]  ptr;
    reg [10:0] sum;          // 8 x 255 = 2040 fits in 11 bits
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 8; i = i + 1) win[i] <= 8'd0;
            ptr <= 0; sum <= 0;
        end else if (en) begin
            sum      <= sum + din - win[ptr];    // add newest, drop oldest
            win[ptr] <= din;
            ptr      <= ptr + 1'b1;
        end
    end

    assign avg = sum[10:3];
endmodule
