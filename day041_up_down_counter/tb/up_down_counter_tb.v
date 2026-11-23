//==============================================================================
// Project     : 100 Days of RTL Design - Day 41 / 100
// Design      : Up/Down Counter
// File        : up_down_counter_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Up/Down Counter
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module up_down_counter_tb;
    reg clk = 0, rst_n = 0, load = 0, up_down = 1;
    reg  [3:0] data_in = 0, model = 0;
    wire [3:0] count;
    integer i, errors = 0;

    up_down_counter dut (.clk(clk), .rst_n(rst_n), .load(load), .up_down(up_down),
                         .data_in(data_in), .count(count));

    always #5 clk = ~clk;

    initial begin
        @(posedge clk); #1 rst_n = 1;
        for (i = 0; i < 200; i = i + 1) begin
            @(negedge clk);
            load = ($random % 10 == 0); data_in = $random;
            up_down = (i < 40) ? 1 : (i < 80) ? 0 : $random;
            @(posedge clk);
            if (load) model = data_in; else if (up_down) model = model + 1; else model = model - 1;
            #1;
            if (count !== model) errors = errors + 1;
        end
        $display("Up/down counter: 40 up, 40 down, 120 random cycles with random loads");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
