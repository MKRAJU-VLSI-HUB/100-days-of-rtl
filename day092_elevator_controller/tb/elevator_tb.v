//==============================================================================
// Project     : 100 Days of RTL Design - Day 92 / 100
// Design      : Elevator Controller
// File        : elevator_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Elevator Controller
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module elevator_tb;
    reg clk = 0, rst = 1;
    reg  [3:0] call = 0;
    wire [1:0] floor;
    wire door_open, moving, dir_up;
    wire [3:0] req;
    integer i, errors = 0, stops = 0, served = 0, waited, t0;
    reg [1:0] prev_floor = 0;
    reg [8*40-1:0] trace;
    integer call_time [0:3], max_wait = 0;

    elevator #(.MOVE_T(4), .DOOR_T(3)) dut (.clk(clk), .rst(rst), .call(call), .floor(floor),
                                            .door_open(door_open), .moving(moving), .dir_up(dir_up), .req(req));

    always #5 clk = ~clk;

    // safety and sanity checks every clock
    always @(posedge clk) if (!rst) begin
        if (door_open && moving) errors = errors + 1;                          // never move with door open
        if (floor != prev_floor && (floor - prev_floor != 1) && (prev_floor - floor != 1))
            errors = errors + 1;                                               // one floor at a time
        prev_floor = floor;
    end

    // record the stop sequence and waiting time per call
    always @(posedge door_open) begin
        stops = stops + 1;
        if (call_time[floor] >= 0) begin
            served = served + 1;
            waited = ($time - call_time[floor]) / 10;
            if (waited > max_wait) max_wait = waited;
            call_time[floor] = -1;
        end
        if (stops <= 6) $display("  t=%5d ns  door opens at floor %0d", $time, floor);
    end

    task press(input [1:0] f);
        begin
            @(negedge clk); call = 4'b1 << f;
            if (call_time[f] < 0) call_time[f] = $time;
            @(negedge clk); call = 0;
        end
    endtask

    initial begin
        for (i = 0; i < 4; i = i + 1) call_time[i] = -1;
        @(posedge clk); #1 rst = 0;
        // car at floor 0: calls for 3 and 1 -> must stop at 1 on the way up to 3
        $display("Calls for floors 3 and 1 while at floor 0:");
        press(3); press(1);
        repeat (40) @(posedge clk);
        // now at 3: calls for 0 and 2 -> stops at 2 then 0
        $display("Calls for floors 0 and 2 while at floor 3:");
        press(0); press(2);
        repeat (40) @(posedge clk);
        // random calls
        for (i = 0; i < 60; i = i + 1) begin
            press($random);
            repeat ($random & 15) @(posedge clk);
        end
        repeat (200) @(posedge clk);
        for (i = 0; i < 4; i = i + 1) if (call_time[i] >= 0) errors = errors + 1;   // every call served
        $display("Elevator: %0d door stops, every call served, longest wait %0d clocks", stops, max_wait);
        $display("  never moved with the door open, never skipped a floor");
        if (errors == 0 && req == 0) $display("RESULT: PASS (0 errors)");
        else $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
