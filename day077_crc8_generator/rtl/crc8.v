//==============================================================================
// Project     : 100 Days of RTL Design - Day 77 / 100
// Design      : CRC-8 Generator
// File        : crc8.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Serial CRC with polynomial 0x07, matches the standard check value
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// Serial CRC-8 generator/checker, polynomial x^8 + x^2 + x + 1 (0x07),
// the CRC-8/ATM variant. One data bit per clock, MSB first.
// To check a frame, run the data and then the received CRC through the
// same register: the remainder is zero when there is no error.
module crc8 (
    input            clk,
    input            rst,
    input            init,       // clear the CRC register (start of frame)
    input            en,
    input            din,
    output reg [7:0] crc
);
    wire fb = crc[7] ^ din;

    always @(posedge clk or posedge rst) begin
        if (rst)       crc <= 8'h00;
        else if (init) crc <= 8'h00;
        else if (en)   crc <= {crc[6:0], 1'b0} ^ (fb ? 8'h07 : 8'h00);
    end
endmodule
