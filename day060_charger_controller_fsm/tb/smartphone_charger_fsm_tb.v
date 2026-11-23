//==============================================================================
// Project     : 100 Days of RTL Design - Day 60 / 100
// Design      : Smartphone Charger Controller
// File        : smartphone_charger_fsm_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Smartphone Charger Controller
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module smartphone_charger_fsm_tb;
    reg power_on = 0, charger = 0, clock = 0, reset = 1;
    wire green, white, safety_mode;
    integer green_time = 0, errors = 0;
    realtime t_start, t_safe;

    smartphone_charger_fsm dut (.power_on(power_on), .charger(charger), .clock(clock), .reset(reset),
                                .green(green), .white(white), .safety_mode(safety_mode));

    always #500 clock = ~clock;    // 1 MHz -> 1 us per clock

    initial begin
        @(posedge clock); #1 reset = 0;
        // idle: white on
        repeat (3) @(posedge clock); #1;
        if (!white || green) errors = errors + 1;

        // plug in, unplug after 20 us: must return to IDLE without safety
        power_on = 1; charger = 1;
        repeat (20) @(posedge clock); #1;
        if (!green) errors = errors + 1;
        charger = 0;
        repeat (2) @(posedge clock); #1;
        if (green || safety_mode) errors = errors + 1;
        $display("Unplugged after 20 us: back to IDLE, safety mode = %b", safety_mode);

        // plug in and leave it: safety after 60 us of charging
        charger = 1;
        @(posedge green); t_start = $realtime;
        @(posedge safety_mode); t_safe = $realtime;
        $display("Charging time before safety cut-off: %0.0f us", (t_safe - t_start) / 1000.0);
        if (t_safe - t_start != 60000.0) errors = errors + 1;
        #1 if (green || !white) errors = errors + 1;

        // stays in safety even with the charger connected
        repeat (20) @(posedge clock); #1;
        if (!safety_mode) errors = errors + 1;
        reset = 1; @(posedge clock); #1 reset = 0;
        if (safety_mode) errors = errors + 1;
        $display("Safety mode held until reset");

        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
