//==============================================================================
// Project     : 100 Days of RTL Design - Day 31 / 100
// Design      : SR Latch and D Latch
// File        : latches_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the SR Latch and D Latch
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module latches_tb;
    reg s, r, d, en;
    wire q_sr, qn_sr, q_d;
    integer errors = 0;

    sr_latch u_sr (.s(s), .r(r), .q(q_sr), .qn(qn_sr));
    d_latch  u_d  (.d(d), .en(en), .q(q_d));

    task check(input exp, input got, input [8*24-1:0] what);
        begin
            if (got !== exp) begin
                errors = errors + 1;
                $display("FAIL: %0s expected %b got %b", what, exp, got);
            end else $display("ok  : %0s = %b", what, got);
        end
    endtask

    initial begin
        // SR latch
        s = 1; r = 0; #10; check(1, q_sr, "SR set");
        s = 0; r = 0; #10; check(1, q_sr, "SR hold after set");
        s = 0; r = 1; #10; check(0, q_sr, "SR reset");
        s = 0; r = 0; #10; check(0, q_sr, "SR hold after reset");
        check(1, qn_sr, "SR qn is complement");

        // D latch
        en = 1; d = 1; #10; check(1, q_d, "D latch transparent 1");
        d = 0;         #10; check(0, q_d, "D latch transparent 0");
        d = 1;         #10;
        en = 0;        #10;
        d = 0;         #10; check(1, q_d, "D latch holds when en=0");
        d = 1; #5 d = 0; #5; check(1, q_d, "D latch ignores d glitch");

        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
