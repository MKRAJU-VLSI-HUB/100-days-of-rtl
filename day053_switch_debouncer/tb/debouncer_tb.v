//==============================================================================
// Project     : 100 Days of RTL Design - Day 53 / 100
// Design      : Switch Debouncer
// File        : debouncer_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Switch Debouncer
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module debouncer_tb;
    reg clk = 0, rst = 1, btn = 0;
    wire clean, pressed;
    integer presses = 0, toggles = 0, errors = 0, k;
    reg clean_prev = 0;

    debouncer #(.STABLE_CYCLES(16)) dut (.clk(clk), .rst(rst), .btn_raw(btn), .btn_clean(clean), .pressed(pressed));

    always #5 clk = ~clk;

    always @(posedge clk) begin
        if (pressed) presses = presses + 1;
        if (clean !== clean_prev) toggles = toggles + 1;
        clean_prev = clean;
    end

    // bouncy press: random chatter for a while, then stable
    task bounce_to(input level);
        begin
            for (k = 0; k < 12; k = k + 1) begin
                btn = ~btn;
                #(10 + ($random & 32'h1F));   // 10..41 ns, shorter than 16 clocks
            end
            btn = level;
            #400;                              // hold stable for 40 clocks
        end
    endtask

    initial begin
        @(posedge clk); #1 rst = 0;
        #100;
        bounce_to(1);  if (clean !== 1) errors = errors + 1;
        bounce_to(0);  if (clean !== 0) errors = errors + 1;
        bounce_to(1);  if (clean !== 1) errors = errors + 1;
        bounce_to(0);  if (clean !== 0) errors = errors + 1;
        // a short glitch alone must be ignored
        btn = 1; #50; btn = 0; #400;
        if (clean !== 0) errors = errors + 1;
        $display("Debouncer: 2 bouncy presses (12 chatter edges each) + 1 short glitch");
        $display("  clean output changed %0d times, press pulses = %0d", toggles, presses);
        if (errors == 0 && presses == 2 && toggles == 4) $display("RESULT: PASS (0 errors)");
        else $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
