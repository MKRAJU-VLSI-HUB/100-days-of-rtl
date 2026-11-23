//==============================================================================
// Project     : 100 Days of RTL Design - Day 70 / 100
// Design      : Shift-Add Multiplier
// File        : shift_add_multiplier_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Shift-Add Multiplier
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module shift_add_multiplier_tb;
    reg clk = 0, rst = 1, start = 0;
    reg  [7:0] a = 0, b = 0;
    wire [15:0] product;
    wire busy, done;
    integer i, errors = 0, cycles;

    shift_add_multiplier dut (.clk(clk), .rst(rst), .start(start), .a(a), .b(b),
                              .product(product), .busy(busy), .done(done));

    always #5 clk = ~clk;

    task mult(input [7:0] x, input [7:0] y);
        begin
            @(negedge clk); a = x; b = y; start = 1;
            @(negedge clk); start = 0;
            cycles = 1;
            while (!done) begin @(negedge clk); cycles = cycles + 1; end
            if (product !== x * y) begin
                errors = errors + 1;
                $display("MISMATCH %0d x %0d = %0d, got %0d", x, y, x * y, product);
            end
        end
    endtask

    initial begin
        @(posedge clk); #1 rst = 0;
        mult(8'd13, 8'd11);  $display("13 x 11 = %0d  (%0d clocks)", product, cycles);
        mult(8'd255, 8'd255); $display("255 x 255 = %0d", product);
        mult(8'd0, 8'd200);   $display("0 x 200 = %0d", product);
        for (i = 0; i < 1000; i = i + 1) mult($random, $random);
        $display("Shift-add multiplier: 1003 products checked, 8 clocks per multiply");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
