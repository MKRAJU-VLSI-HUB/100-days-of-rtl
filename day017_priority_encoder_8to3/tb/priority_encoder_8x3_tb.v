//==============================================================================
// Project     : 100 Days of RTL Design - Day 17 / 100
// Design      : 8-to-3 Priority Encoder
// File        : priority_encoder_8x3_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the 8-to-3 Priority Encoder
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module priority_encoder_8x3_tb;
    reg  [7:0] din;
    wire [2:0] dout;
    wire       valid;
    integer i, k, errors = 0;
    reg [2:0] exp;
    reg       exp_v;

    priority_encoder_8x3 dut (.din(din), .dout(dout), .valid(valid));

    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            din = i; #5;
            exp = 0; exp_v = 0;
            for (k = 0; k < 8; k = k + 1)
                if (din[k]) begin exp = k; exp_v = 1; end
            if (dout !== exp || valid !== exp_v) begin
                errors = errors + 1;
                $display("MISMATCH din=%b dout=%0d valid=%b", din, dout, valid);
            end
        end
        $display("Priority encoder: all 256 input patterns checked");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
