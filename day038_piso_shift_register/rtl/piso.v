//==============================================================================
// Project     : 100 Days of RTL Design - Day 38 / 100
// Design      : PISO Shift Register
// File        : piso.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Parallel byte sent out one bit per clock, MSB first
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 8-bit parallel-in serial-out shift register (MSB first).
// load captures the byte; each following clock pushes one bit out.
module piso (
    input        clk,
    input        rst,
    input        load,
    input  [7:0] pin,
    output       so,
    output       busy
);
    reg [7:0] sr;
    reg [3:0] left;          // bits still to send

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sr   <= 8'h00;
            left <= 4'd0;
        end else if (load) begin
            sr   <= pin;
            left <= 4'd8;
        end else if (left != 0) begin
            sr   <= {sr[6:0], 1'b0};
            left <= left - 1'b1;
        end
    end

    assign so   = sr[7];
    assign busy = (left != 0);
endmodule
