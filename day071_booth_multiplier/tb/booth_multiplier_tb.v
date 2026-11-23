//==============================================================================
// Project     : 100 Days of RTL Design - Day 71 / 100
// Design      : Booth Multiplier
// File        : booth_multiplier_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Booth Multiplier
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module booth_multiplier_tb;
    reg clk = 0, rst = 1, start = 0;
    reg  signed [7:0] m = 0, q = 0;
    wire signed [15:0] product;
    wire done, busy;
    integer i, j, errors = 0;

    booth_multiplier dut (.clk(clk), .rst(rst), .start(start), .m(m), .q(q),
                          .product(product), .done(done), .busy(busy));

    always #5 clk = ~clk;

    task mult(input signed [7:0] x, input signed [7:0] y);
        begin
            @(negedge clk); m = x; q = y; start = 1;
            @(negedge clk); start = 0;
            while (!done) @(negedge clk);
            if (product !== x * y) begin
                errors = errors + 1;
                if (errors < 5) $display("MISMATCH %0d x %0d -> %0d", x, y, product);
            end
        end
    endtask

    initial begin
        @(posedge clk); #1 rst = 0;
        mult(-7, 3);     $display("-7 x 3 = %0d", product);
        mult(-128, -128); $display("-128 x -128 = %0d", product);
        mult(127, -128); $display("127 x -128 = %0d", product);
        // every signed pair: 65536 products
        for (i = -128; i < 128; i = i + 1)
            for (j = -128; j < 128; j = j + 1)
                mult(i, j);
        $display("Booth multiplier: all 65536 signed 8-bit pairs checked");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
