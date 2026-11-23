//==============================================================================
// Project     : 100 Days of RTL Design - Day 81 / 100
// Design      : Digital Clock
// File        : digital_clock_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Digital Clock
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module digital_clock_tb;
    reg clk = 0, rst = 1, set = 0;
    reg  [7:0] set_hh = 0, set_mm = 0;
    wire [7:0] hh, mm, ss;
    integer secs, t, errors = 0, exp;

    digital_clock #(.TICK_DIV(4)) dut (.clk(clk), .rst(rst), .set(set), .set_hh(set_hh), .set_mm(set_mm),
                                       .hh(hh), .mm(mm), .ss(ss));

    always #5 clk = ~clk;

    function integer bcd2int(input [7:0] v);
        bcd2int = v[7:4] * 10 + v[3:0];
    endfunction

    initial begin
        @(posedge clk); #1 rst = 0;
        // set 23:58:00, then run 150 seconds -> must roll over midnight to 00:00:30
        @(negedge clk); set = 1; set_hh = 8'h23; set_mm = 8'h58;
        @(negedge clk); set = 0;
        $display("Clock set to %h:%h:%h", hh, mm, ss);
        secs = 23 * 3600 + 58 * 60;
        for (t = 0; t < 150; t = t + 1) begin
            repeat (4) @(posedge clk);
            #1;
            secs = (secs + 1) % 86400;
            exp = bcd2int(hh) * 3600 + bcd2int(mm) * 60 + bcd2int(ss);
            if (exp != secs) errors = errors + 1;
            if (ss[3:0] > 9 || mm[3:0] > 9 || hh[3:0] > 9) errors = errors + 1;   // valid BCD
            if (t == 119 || t == 120 || t == 149) $display("  after %3d s: %h:%h:%h", t + 1, hh, mm, ss);
        end
        $display("Digital clock: 150 seconds across midnight, every second compared with a seconds counter");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
