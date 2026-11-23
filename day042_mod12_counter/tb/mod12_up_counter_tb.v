//==============================================================================
// Project     : 100 Days of RTL Design - Day 42 / 100
// Design      : Mod-12 Counter
// File        : mod12_up_counter_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Mod-12 Counter
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module mod12_up_counter_tb;
    reg clk = 0, rst_n = 0, load = 0;
    reg  [3:0] load_data = 0, model = 0;
    wire [3:0] count;
    integer i, errors = 0, max_seen = 0;

    mod12_up_counter dut (.clk(clk), .rst_n(rst_n), .load(load), .load_data(load_data), .count(count));

    always #5 clk = ~clk;

    initial begin
        @(posedge clk); #1 rst_n = 1;
        for (i = 0; i < 150; i = i + 1) begin
            @(negedge clk);
            load = (i == 60 || i == 100); load_data = (i == 60) ? 4'd9 : 4'd14;
            @(posedge clk);
            if (load) model = (load_data > 11) ? 0 : load_data;
            else      model = (model == 11) ? 0 : model + 1;
            #1;
            if (count !== model) errors = errors + 1;
            if (count > max_seen) max_seen = count;
        end
        $display("Mod-12 counter: 150 cycles, highest value seen = %0d (never reaches 12)", max_seen);
        $display("Load of 9 accepted, illegal load of 14 forced to 0");
        if (errors == 0 && max_seen == 11) $display("RESULT: PASS (0 errors)");
        else                               $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
