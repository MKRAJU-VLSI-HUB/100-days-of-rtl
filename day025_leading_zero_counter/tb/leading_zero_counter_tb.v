//==============================================================================
// Project     : 100 Days of RTL Design - Day 25 / 100
// Design      : 16-bit Leading Zero Counter
// File        : leading_zero_counter_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the 16-bit Leading Zero Counter
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module leading_zero_counter_tb;
    reg  [15:0] x;
    wire [4:0]  cnt;
    wire        all_zero;
    integer i, k, exp, errors = 0;

    leading_zero_counter dut (.x(x), .cnt(cnt), .all_zero(all_zero));

    initial begin
        for (i = 0; i < 65536; i = i + 1) begin
            x = i; #1;
            exp = 16;
            for (k = 0; k < 16; k = k + 1) if (x[k]) exp = 15 - k;
            if (cnt !== exp || all_zero !== (x == 0)) errors = errors + 1;
        end
        x = 16'h0040; #1; $display("Example: x = 0000000001000000 -> %0d leading zeros", cnt);
        $display("Leading zero counter: all 65536 inputs checked");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
