//==============================================================================
// Project     : 100 Days of RTL Design - Day 12 / 100
// Design      : 4:1 Multiplexer
// File        : mux4_1.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : 4:1 mux using a case statement, checked on all 64 combinations
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 4:1 multiplexer using a case statement
module mux4_1 (
    input      [3:0] d,      // data inputs d[0]..d[3]
    input      [1:0] sel,
    output reg       y
);
    always @(*) begin
        case (sel)
            2'b00: y = d[0];
            2'b01: y = d[1];
            2'b10: y = d[2];
            2'b11: y = d[3];
        endcase
    end
endmodule
