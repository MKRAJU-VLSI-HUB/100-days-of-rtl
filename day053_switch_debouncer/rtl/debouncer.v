//==============================================================================
// Project     : 100 Days of RTL Design - Day 53 / 100
// Design      : Switch Debouncer
// File        : debouncer.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Synchroniser plus stability counter, bouncy presses give one clean pulse
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// Push-button debouncer. The raw input is synchronised with two flops,
// then the output only changes after the input has stayed at the new
// level for STABLE_CYCLES clocks in a row. Bounces shorter than that
// are ignored. A one-clock 'pressed' pulse marks each clean press.
module debouncer #(
    parameter STABLE_CYCLES = 16
) (
    input      clk,
    input      rst,
    input      btn_raw,
    output reg btn_clean,
    output     pressed
);
    reg s1, s2;
    reg [$clog2(STABLE_CYCLES+1)-1:0] cnt;
    reg clean_q;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            s1 <= 0; s2 <= 0; cnt <= 0; btn_clean <= 0; clean_q <= 0;
        end else begin
            s1 <= btn_raw;
            s2 <= s1;
            clean_q <= btn_clean;
            if (s2 == btn_clean)
                cnt <= 0;
            else if (cnt == STABLE_CYCLES - 1) begin
                btn_clean <= s2;
                cnt <= 0;
            end else
                cnt <= cnt + 1'b1;
        end
    end

    assign pressed = btn_clean & ~clean_q;
endmodule
