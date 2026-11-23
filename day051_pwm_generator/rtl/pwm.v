//==============================================================================
// Project     : 100 Days of RTL Design - Day 51 / 100
// Design      : PWM Generator
// File        : pwm.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : 8-bit duty cycle, glitch-free update at the end of each period
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 8-bit PWM generator. An 8-bit counter runs 0..255; the output is high
// while counter < duty, so duty = 64 gives 25% and duty = 128 gives 50%.
// A new duty value is taken only at the start of a period (no glitches).
module pwm (
    input        clk,
    input        rst,
    input  [7:0] duty,
    output       pwm_out
);
    reg [7:0] cnt, duty_q;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt    <= 8'd0;
            duty_q <= 8'd0;
        end else begin
            cnt <= cnt + 1'b1;
            if (cnt == 8'd255) duty_q <= duty;   // update at end of period
        end
    end

    assign pwm_out = (cnt < duty_q);
endmodule
