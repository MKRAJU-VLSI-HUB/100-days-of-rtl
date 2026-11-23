//==============================================================================
// Project     : 100 Days of RTL Design - Day 54 / 100
// Design      : CDC Synchronizers
// File        : synchronizers_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the CDC Synchronizers
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module synchronizers_tb;
    reg clk_a = 0, clk_b = 0, rst = 1;
    reg level = 0, pulse_a = 0;
    wire level_b, pulse_b;
    integer i, sent = 0, received = 0, errors = 0;

    sync_2ff   u_lvl (.clk_dst(clk_b), .rst(rst), .d_async(level), .q(level_b));
    pulse_sync u_pls (.clk_a(clk_a), .clk_b(clk_b), .rst(rst), .pulse_a(pulse_a), .pulse_b(pulse_b));

    always #5   clk_a = ~clk_a;   // 100 MHz source
    always #7.3 clk_b = ~clk_b;   // ~68 MHz destination, unrelated phase

    always @(posedge clk_b) if (pulse_b) received = received + 1;

    initial begin
        #20 rst = 0;
        // level crossing: output must follow within 2-3 destination clocks
        @(posedge clk_a); level = 1;
        repeat (3) @(posedge clk_b); #1;
        if (level_b !== 1) errors = errors + 1;
        @(posedge clk_a); level = 0;
        repeat (3) @(posedge clk_b); #1;
        if (level_b !== 0) errors = errors + 1;

        // 50 single-cycle pulses, spaced far enough for the handshake-free scheme
        for (i = 0; i < 50; i = i + 1) begin
            @(posedge clk_a); #1 pulse_a = 1;
            @(posedge clk_a); #1 pulse_a = 0;
            sent = sent + 1;
            repeat (6 + ($random & 3)) @(posedge clk_a);
        end
        repeat (10) @(posedge clk_b);
        $display("2-flop sync: level change seen in the destination domain within 3 clocks");
        $display("Pulse sync : %0d pulses sent from 100 MHz, %0d received at ~68 MHz", sent, received);
        if (errors == 0 && sent == received) $display("RESULT: PASS (0 errors)");
        else $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
