//==============================================================================
// Project     : 100 Days of RTL Design - Day 19 / 100
// Design      : Binary / Gray Code Converter
// File        : binary_gray_converter.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : 8-bit binary to Gray and back, neighbouring codes differ by one bit
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 8-bit binary to Gray and Gray to binary converters
module bin2gray #(parameter N = 8) (
    input  [N-1:0] bin,
    output [N-1:0] gray
);
    assign gray = bin ^ (bin >> 1);
endmodule

module gray2bin #(parameter N = 8) (
    input      [N-1:0] gray,
    output reg [N-1:0] bin
);
    integer i;
    always @(*) begin
        bin[N-1] = gray[N-1];
        for (i = N-2; i >= 0; i = i - 1)
            bin[i] = bin[i+1] ^ gray[i];
    end
endmodule
