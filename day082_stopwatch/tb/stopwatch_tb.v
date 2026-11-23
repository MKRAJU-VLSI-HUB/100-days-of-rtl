//==============================================================================
// Project     : 100 Days of RTL Design - Day 82 / 100
// Design      : Stopwatch
// File        : stopwatch_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Stopwatch
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module stopwatch_tb;
    reg clk = 0, rst = 1, ss = 0, lap = 0, clr = 0;
    wire [5:0] m, s;
    wire [6:0] c;
    wire running;
    integer errors = 0, total_cs;
    reg [5:0] fm, fs; reg [6:0] fc;

    stopwatch #(.TICK_DIV(2)) dut (.clk(clk), .rst(rst), .start_stop(ss), .lap(lap), .clear(clr),
                                   .disp_min(m), .disp_sec(s), .disp_cs(c), .running(running));

    always #5 clk = ~clk;

    // 0 = start/stop, 1 = lap, 2 = clear (one-clock pulse)
    task press(input integer which);
        begin
            @(negedge clk);
            ss = (which == 0); lap = (which == 1); clr = (which == 2);
            @(negedge clk);
            ss = 0; lap = 0; clr = 0;
        end
    endtask

    function integer to_cs(input [5:0] mi, input [5:0] se, input [6:0] ce);
        to_cs = mi * 6000 + se * 100 + ce;
    endfunction

    initial begin
        @(posedge clk); #1 rst = 0;
        press(0);                                 // start
        repeat (2 * 12345) @(posedge clk);         // 123.45 s worth of ticks
        press(0);                                 // stop
        total_cs = to_cs(m, s, c);
        $display("Ran for 12345 ticks -> display %0d:%0d.%0d", m, s, c);
        if (total_cs < 12344 || total_cs > 12346) errors = errors + 1;   // +/-1 for button timing
        repeat (50) @(posedge clk);
        if (to_cs(m, s, c) != total_cs) errors = errors + 1;
        $display("Stopped: time holds at %0d:%0d.%0d", m, s, c);

        press(0);                                 // resume
        repeat (200) @(posedge clk);
        press(1);                                // freeze display
        fm = m; fs = s; fc = c;
        repeat (300) @(posedge clk);
        if (m !== fm || s !== fs || c !== fc) errors = errors + 1;
        $display("Lap: display frozen at %0d:%0d.%0d while counting continues", m, s, c);
        press(1);                                // back to live time
        if (to_cs(m, s, c) <= to_cs(fm, fs, fc) + 100) errors = errors + 1;
        $display("Lap released: live time %0d:%0d.%0d", m, s, c);

        press(0); press(2);
        if (m !== 0 || s !== 0 || c !== 0) errors = errors + 1;
        $display("Stopped and cleared: %0d:%0d.%0d", m, s, c);
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
