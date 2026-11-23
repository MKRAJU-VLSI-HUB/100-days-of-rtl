//==============================================================================
// Project     : 100 Days of RTL Design - Day 83 / 100
// Design      : Watchdog Timer
// File        : watchdog_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Watchdog Timer
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module watchdog_tb;
    reg clk = 0, rst = 1, enable = 0, kick = 0;
    wire warn_irq, wdt_reset;
    integer i, errors = 0, resets = 0, warns = 0, rst_len = 0, t_last_kick, t_reset;

    watchdog #(.TIMEOUT(100), .RST_PULSE(4)) dut (.clk(clk), .rst(rst), .enable(enable), .kick(kick),
                                                 .warn_irq(warn_irq), .wdt_reset(wdt_reset));

    always #5 clk = ~clk;

    always @(posedge clk) begin
        if (warn_irq) warns = warns + 1;
        if (wdt_reset) rst_len = rst_len + 1;
    end
    always @(posedge wdt_reset) resets = resets + 1;

    initial begin
        @(posedge clk); #1 rst = 0;
        // not armed: nothing happens even without kicks
        repeat (300) @(posedge clk);
        if (resets != 0) errors = errors + 1;
        $display("Not enabled: 300 clocks without kicks, resets = %0d", resets);

        // armed and kicked every 40 clocks: no reset
        @(negedge clk); enable = 1; @(negedge clk); enable = 0;
        for (i = 0; i < 10; i = i + 1) begin
            repeat (39) @(negedge clk);
            kick = 1; @(negedge clk); kick = 0;
        end
        $display("Kicked every 40 clocks for 400 clocks: resets = %0d, warnings = %0d", resets, warns);
        if (resets != 0 || warns != 0) errors = errors + 1;

        // software hangs: no more kicks
        t_last_kick = $time - 5;   // the clock edge that saw the last kick
        @(posedge wdt_reset); t_reset = $time;
        $display("Kicks stopped: warning after 50 clocks, reset after %0d clocks", (t_reset - t_last_kick) / 10);
        if ((t_reset - t_last_kick) / 10 != 100 || warns != 1) errors = errors + 1;
        repeat (10) @(posedge clk);
        $display("Reset pulse length: %0d clocks", rst_len);
        if (rst_len != 4) errors = errors + 1;

        // trying to disable does nothing: still armed, still resets
        repeat (200) @(posedge clk);
        if (resets < 2) errors = errors + 1;
        $display("Watchdog cannot be turned off: resets so far = %0d", resets);
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
