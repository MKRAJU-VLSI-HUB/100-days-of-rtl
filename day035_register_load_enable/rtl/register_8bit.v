//==============================================================================
// Project     : 100 Days of RTL Design - Day 35 / 100
// Design      : 8-bit Register
// File        : register_8bit.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Register with load, clear and tri-state output enable
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 8-bit register with synchronous load, clear and tri-state output enable
module register_8bit (
    input            clk,
    input            rst_n,     // async active-low reset
    input            clr,       // sync clear
    input            load,
    input            oe,
    input      [7:0] d,
    output     [7:0] q_bus,     // tri-state bus output
    output reg [7:0] q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)    q <= 8'h00;
        else if (clr)  q <= 8'h00;
        else if (load) q <= d;
    end

    assign q_bus = oe ? q : 8'hzz;
endmodule
