//==============================================================================
// Project     : 100 Days of RTL Design - Day 45 / 100
// Design      : 2-Digit BCD Counter
// File        : bcd_counter.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : 00 to 99 using two cascaded decade counters
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// Two-digit BCD counter, 00 to 99, built from two cascaded decade counters
module decade_counter (
    input            clk,
    input            rst,
    input            en,
    output reg [3:0] q,
    output           carry      // high when q = 9 and enabled
);
    always @(posedge clk or posedge rst) begin
        if (rst)     q <= 4'd0;
        else if (en) q <= (q == 4'd9) ? 4'd0 : q + 1'b1;
    end
    assign carry = en & (q == 4'd9);
endmodule

module bcd_counter (
    input        clk,
    input        rst,
    input        en,
    output [3:0] ones,
    output [3:0] tens,
    output       rollover   // pulses when going from 99 to 00
);
    wire c1;
    decade_counter u_ones (.clk(clk), .rst(rst), .en(en), .q(ones), .carry(c1));
    decade_counter u_tens (.clk(clk), .rst(rst), .en(c1), .q(tens), .carry(rollover));
endmodule
