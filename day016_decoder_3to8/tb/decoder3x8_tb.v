//==============================================================================
// Project     : 100 Days of RTL Design - Day 16 / 100
// Design      : 3-to-8 Decoder
// File        : decoder3x8_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the 3-to-8 Decoder
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module decoder3x8_tb;
    reg  [2:0] a;
    reg        en;
    wire [7:0] y;
    integer i, errors = 0;

    decoder3x8 dut (.a(a), .en(en), .y(y));

    initial begin
        $display(" en a   | y");
        for (i = 0; i < 16; i = i + 1) begin
            {en, a} = i; #10;
            $display("  %b %b | %b", en, a, y);
            if (y !== (en ? (8'b1 << a) : 8'b0)) errors = errors + 1;
        end
        if (errors == 0) $display("RESULT: PASS - all 16 combinations correct");
        else             $display("RESULT: FAIL - %0d errors", errors);
        $finish;
    end
endmodule
