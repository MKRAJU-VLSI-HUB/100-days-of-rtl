//==============================================================================
// Project     : 100 Days of RTL Design - Day 67 / 100
// Design      : LIFO Stack
// File        : lifo_stack_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the LIFO Stack
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module lifo_stack_tb;
    reg clk = 0, rst = 1, push = 0, pop = 0;
    reg  [7:0] din = 0;
    wire [7:0] top;
    wire full, empty;
    wire [3:0] depth;
    reg  [7:0] model [0:7];
    integer sp = 0, i, errors = 0;

    lifo_stack dut (.clk(clk), .rst(rst), .push(push), .pop(pop), .din(din),
                    .top(top), .full(full), .empty(empty), .depth(depth));

    always #5 clk = ~clk;

    task step(input pu, input po, input [7:0] d);
        begin
            @(negedge clk); push = pu; pop = po; din = d; #1;
            if (depth !== sp || full !== (sp == 8) || empty !== (sp == 0)) errors = errors + 1;
            if (sp > 0 && top !== model[sp-1]) errors = errors + 1;
            @(posedge clk);
            if (pu && po && sp > 0)     model[sp-1] = d;
            else if (pu && sp < 8)      begin model[sp] = d; sp = sp + 1; end
            else if (po && sp > 0)      sp = sp - 1;
        end
    endtask

    initial begin
        @(posedge clk); #1 rst = 0;
        // push 1..10 (last two ignored because full), then pop everything
        for (i = 1; i <= 10; i = i + 1) step(1, 0, i);
        $display("After pushing 1..10: depth = %0d, full = %b, top = %0d", depth, full, top);
        $write("Popped order:");
        for (i = 0; i < 9; i = i + 1) begin
            if (!empty) $write(" %0d", top);
            step(0, 1, 0);
        end
        $display("");
        // random traffic
        for (i = 0; i < 500; i = i + 1) step($random, $random, $random);
        $display("LIFO: last in first out order, full/empty limits and 500 random operations checked");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
