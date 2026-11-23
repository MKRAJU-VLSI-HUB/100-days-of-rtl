//==============================================================================
// Project     : 100 Days of RTL Design - Day 65 / 100
// Design      : Synchronous FIFO
// File        : fifo_16x8_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Synchronous FIFO
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module fifo_16x8_tb;
    reg        clk = 0, reset_n = 0, wr = 0, rd = 0;
    reg  [7:0] din = 0;
    wire [7:0] dout;
    wire       full, empty;
    wire [4:0] count;

    // queue model
    reg [7:0] q [0:255];
    integer head = 0, tail = 0, i, errors = 0, max_count = 0, pushes = 0, pops = 0;
    reg f_now, e_now;

    fifo_16x8 dut (.clk(clk), .reset_n(reset_n), .write_in(wr), .read_in(rd), .data_in(din),
                   .data_out(dout), .full(full), .empty(empty), .count(count));

    always #5 clk = ~clk;

    task cycle(input w, input r);
        begin
            @(negedge clk);
            wr = w; rd = r; din = $random;
            #1;
            if (empty !== (tail == head) || full !== (tail - head == 16) || count !== tail - head)
                errors = errors + 1;
            if (!empty && dout !== q[head % 256]) errors = errors + 1;
            f_now = (tail - head == 16);
            e_now = (tail == head);
            @(posedge clk);
            if (r && !e_now) begin head = head + 1; pops = pops + 1; end
            if (w && !f_now) begin q[tail % 256] = din; tail = tail + 1; pushes = pushes + 1; end
            if (tail - head > max_count) max_count = tail - head;
        end
    endtask

    initial begin
        @(posedge clk); #1 reset_n = 1;
        for (i = 0; i < 20; i = i + 1) cycle(1, 0);   // fill past full: extra writes ignored
        $display("After 20 writes: count = %0d, full = %b", count, full);
        for (i = 0; i < 20; i = i + 1) cycle(0, 1);   // drain past empty
        $display("After 20 reads : count = %0d, empty = %b", count, empty);
        for (i = 0; i < 1000; i = i + 1) cycle($random, $random);
        $display("Sync FIFO: %0d pushes, %0d pops, max fill %0d of 16, order and flags checked every clock",
                 pushes, pops, max_count);
        if (errors == 0 && max_count == 16) $display("RESULT: PASS (0 errors)");
        else $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
