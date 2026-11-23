//==============================================================================
// Project     : 100 Days of RTL Design - Day 95 / 100
// Design      : Q8.8 Fixed-Point Multiplier
// File        : q88_mult_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Q8.8 Fixed-Point Multiplier
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module q88_mult_tb;
    reg  signed [15:0] a, b;
    wire signed [15:0] p;
    wire overflow;
    integer i, errors = 0, sat = 0, expi;
    real exact;

    q88_mult dut (.a(a), .b(b), .p(p), .overflow(overflow));

    task show(input signed [15:0] x, input signed [15:0] y);
        begin
            a = x; b = y; #1;
            $display(" %8.4f x %8.4f = %9.4f %s", x / 256.0, y / 256.0, p / 256.0, overflow ? "(saturated)" : "");
        end
    endtask

    initial begin
        show(16'sh0180, 16'sh0200);     // 1.5 x 2.0
        show(16'shFF80, 16'sh0300);     // -0.5 x 3.0
        show(16'sh0040, 16'sh0040);     // 0.25 x 0.25
        show(16'sh6400, 16'sh0200);     // 100 x 2 -> saturates at +127.996
        show(16'sh8000, 16'sh8000);     // -128 x -128 -> saturates
        for (i = 0; i < 200000; i = i + 1) begin
            a = $random; b = $random;
            if (i % 2) begin a = a >>> 4; b = b >>> 4; end     // mix of small and large values
            #1;
            // reference: round half up, then clamp
            expi = (a * b + 128) >>> 8;
            if (expi > 32767)  expi = 32767;
            if (expi < -32768) expi = -32768;
            if (p !== expi[15:0]) errors = errors + 1;
            if (overflow) sat = sat + 1;
        end
        $display("Q8.8 multiplier: 200000 random products checked, %0d saturated correctly", sat);
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
