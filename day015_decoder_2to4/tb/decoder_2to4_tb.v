//==============================================================================
// Project     : 100 Days of RTL Design - Day 15 / 100
// Design      : 2-to-4 Decoder
// File        : decoder_2to4_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the 2-to-4 Decoder
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module decoder_2to4_tb;
    reg  [1:0] a;
    reg        en;
    wire [3:0] y;
    integer i, errors = 0;

    decoder_2to4 dut (.a(a), .en(en), .y(y));

    initial begin
        $display(" en a  | y");
        for (i = 0; i < 8; i = i + 1) begin
            {en, a} = i; #10;
            $display("  %b %b | %b", en, a, y);
            if (y !== (en ? (4'b0001 << a) : 4'b0000)) errors = errors + 1;
        end
        if (errors == 0) $display("RESULT: PASS - one-hot outputs correct, all off when disabled");
        else             $display("RESULT: FAIL - %0d errors", errors);
        $finish;
    end
endmodule
