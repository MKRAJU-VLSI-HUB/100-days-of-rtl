//==============================================================================
// Project     : 100 Days of RTL Design - Day 27 / 100
// Design      : Binary to BCD (Double Dabble)
// File        : bin2bcd.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Shift and add-3 algorithm, 8-bit binary to three BCD digits
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 8-bit binary to 3-digit BCD using the double dabble (shift and add 3)
// algorithm. Before each shift, any BCD digit that is 5 or more gets +3.
module bin2bcd (
    input      [7:0]  bin,
    output reg [11:0] bcd      // {hundreds, tens, ones}
);
    integer i;
    reg [19:0] shift;          // [19:8] BCD digits, [7:0] binary

    always @(*) begin
        shift = {12'd0, bin};
        for (i = 0; i < 8; i = i + 1) begin
            if (shift[11:8]  >= 5) shift[11:8]  = shift[11:8]  + 3;
            if (shift[15:12] >= 5) shift[15:12] = shift[15:12] + 3;
            if (shift[19:16] >= 5) shift[19:16] = shift[19:16] + 3;
            shift = shift << 1;
        end
        bcd = shift[19:8];
    end
endmodule
