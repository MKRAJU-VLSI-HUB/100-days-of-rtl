//==============================================================================
// Project     : 100 Days of RTL Design - Day 37 / 100
// Design      : SIPO Shift Register
// File        : sipo.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Serial bits collected into a parallel byte with a valid pulse
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 8-bit serial-in parallel-out shift register (MSB first).
// After 8 shifts the full byte is on pout and 'valid' pulses for one clock.
module sipo (
    input            clk,
    input            rst,
    input            shift_en,
    input            si,
    output reg [7:0] pout,
    output reg       valid
);
    reg [2:0] cnt;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pout  <= 8'h00;
            cnt   <= 3'd0;
            valid <= 1'b0;
        end else begin
            valid <= 1'b0;
            if (shift_en) begin
                pout <= {pout[6:0], si};
                cnt  <= cnt + 1'b1;
                if (cnt == 3'd7) valid <= 1'b1;
            end
        end
    end
endmodule
