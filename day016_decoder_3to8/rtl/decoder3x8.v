//==============================================================================
// Project     : 100 Days of RTL Design - Day 16 / 100
// Design      : 3-to-8 Decoder
// File        : decoder3x8.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : 3-to-8 decoder with enable using a case statement
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 3-to-8 decoder with active-high enable
module decoder3x8 (
    input      [2:0] a,
    input            en,
    output reg [7:0] y
);
    always @(*) begin
        y = 8'b0;
        if (en) begin
            case (a)
                3'd0: y = 8'b0000_0001;
                3'd1: y = 8'b0000_0010;
                3'd2: y = 8'b0000_0100;
                3'd3: y = 8'b0000_1000;
                3'd4: y = 8'b0001_0000;
                3'd5: y = 8'b0010_0000;
                3'd6: y = 8'b0100_0000;
                3'd7: y = 8'b1000_0000;
            endcase
        end
    end
endmodule
