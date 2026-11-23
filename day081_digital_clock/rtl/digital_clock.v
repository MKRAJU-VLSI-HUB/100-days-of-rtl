//==============================================================================
// Project     : 100 Days of RTL Design - Day 81 / 100
// Design      : Digital Clock
// File        : digital_clock.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : 24-hour HH:MM:SS clock in BCD with set mode
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 24-hour digital clock, HH:MM:SS in BCD.
// 'tick' is a one-second enable pulse (from a prescaler in a real board;
// TICK_DIV sets how many clk cycles make one second). Set mode loads the
// hours and minutes directly.
module digital_clock #(
    parameter TICK_DIV = 4            // clk cycles per second (small for simulation)
) (
    input            clk,
    input            rst,
    input            set,
    input      [7:0] set_hh,          // BCD
    input      [7:0] set_mm,          // BCD
    output reg [7:0] hh,              // BCD 00..23
    output reg [7:0] mm,              // BCD 00..59
    output reg [7:0] ss               // BCD 00..59
);
    reg [$clog2(TICK_DIV)-1:0] pre;
    wire tick = (pre == TICK_DIV - 1);

    always @(posedge clk or posedge rst) begin
        if (rst) pre <= 0;
        else     pre <= tick ? 0 : pre + 1'b1;
    end

    // BCD increment helpers: return {carry, next value}
    function [8:0] inc60(input [7:0] v);
        if (v[3:0] != 4'd9)      inc60 = {1'b0, v[7:4], v[3:0] + 4'd1};
        else if (v[7:4] != 4'd5) inc60 = {1'b0, v[7:4] + 4'd1, 4'd0};
        else                     inc60 = {1'b1, 8'h00};
    endfunction

    function [7:0] inc24(input [7:0] v);
        if (v == 8'h23)          inc24 = 8'h00;
        else if (v[3:0] == 4'd9) inc24 = {v[7:4] + 4'd1, 4'd0};
        else                     inc24 = {v[7:4], v[3:0] + 4'd1};
    endfunction

    wire [8:0] s_next = inc60(ss);
    wire [8:0] m_next = inc60(mm);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            hh <= 8'h00; mm <= 8'h00; ss <= 8'h00;
        end else if (set) begin
            hh <= set_hh; mm <= set_mm; ss <= 8'h00;
        end else if (tick) begin
            ss <= s_next[7:0];
            if (s_next[8]) begin
                mm <= m_next[7:0];
                if (m_next[8]) hh <= inc24(hh);
            end
        end
    end
endmodule
