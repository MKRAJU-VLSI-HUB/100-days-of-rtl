//==============================================================================
// Project     : 100 Days of RTL Design - Day 17 / 100
// Design      : 8-to-3 Priority Encoder
// File        : priority_encoder_8x3.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Highest active input wins, valid flag when no input is set
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 8-to-3 priority encoder. The highest set bit wins.
// valid = 0 when no input is active.
module priority_encoder_8x3 (
    input      [7:0] din,
    output reg [2:0] dout,
    output reg       valid
);
    always @(*) begin
        valid = 1'b1;
        casez (din)
            8'b1???????: dout = 3'b111;
            8'b01??????: dout = 3'b110;
            8'b001?????: dout = 3'b101;
            8'b0001????: dout = 3'b100;
            8'b00001???: dout = 3'b011;
            8'b000001??: dout = 3'b010;
            8'b0000001?: dout = 3'b001;
            8'b00000001: dout = 3'b000;
            default: begin
                dout  = 3'b000;
                valid = 1'b0;
            end
        endcase
    end
endmodule
