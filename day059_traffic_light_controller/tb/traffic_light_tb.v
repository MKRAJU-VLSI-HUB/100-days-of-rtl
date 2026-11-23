//==============================================================================
// Project     : 100 Days of RTL Design - Day 59 / 100
// Design      : Traffic Light Controller
// File        : traffic_light_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Traffic Light Controller
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module traffic_light_tb;
    reg clk = 0, rst = 1, side_car = 0;
    wire [1:0] main_light, side_light;
    integer cyc = 0, errors = 0, run = 0, cycles_done = 0;
    reg [1:0] last_main, last_side;


    traffic_light #(.GREEN_T(10), .YELLOW_T(3), .SIDE_GREEN_T(6)) dut
        (.clk(clk), .rst(rst), .side_car(side_car), .main_light(main_light), .side_light(side_light));

    always #5 clk = ~clk;

    function [8*6-1:0] name(input [1:0] l);
        name = (l == 2'b10) ? "GREEN " : (l == 2'b01) ? "YELLOW" : "RED   ";
    endfunction

    // safety: both roads must never be non-red at the same time
    always @(posedge clk) if (!rst && main_light != 2'b00 && side_light != 2'b00) errors = errors + 1;

    initial begin
        @(posedge clk); #1 rst = 0;
        last_main = main_light; last_side = side_light; run = 1;
        // no side car for 40 clocks: main must stay green
        repeat (40) begin @(posedge clk); #1; if (main_light !== 2'b10) errors = errors + 1; end
        $display("No car on side road for 40 clocks: main road stayed GREEN");
        side_car = 1; run = 40;
        repeat (60) begin
            @(posedge clk); #1;
            run = run + 1;
            if (main_light != last_main || side_light != last_side) begin
                $display(" t=%3d  main %s  side %s  (previous phase %0d clocks)", cyc,
                         name(main_light), name(side_light), run);
                // check phase lengths
                if (last_main == 2'b01 && run != 3) errors = errors + 1;   // main yellow
                if (last_side == 2'b10 && run != 6) errors = errors + 1;   // side green
                if (last_side == 2'b01) cycles_done = cycles_done + 1;
                run = 0;
                last_main = main_light; last_side = side_light;
            end
            cyc = cyc + 1;
        end
        $display("Full light cycles completed with a car waiting: %0d", cycles_done);
        if (errors == 0 && cycles_done >= 2) $display("RESULT: PASS (0 errors, never green/yellow on both roads)");
        else $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
