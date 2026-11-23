//==============================================================================
// Project     : 100 Days of RTL Design - Day 72 / 100
// Design      : Restoring Divider
// File        : restoring_divider_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Restoring Divider
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module restoring_divider_tb;
    reg clk = 0, rst = 1, start = 0;
    reg  [7:0] dividend = 0, divisor = 0;
    wire [7:0] quotient, remainder;
    wire done, dbz;
    integer i, j, errors = 0, n = 0;

    restoring_divider dut (.clk(clk), .rst(rst), .start(start), .dividend(dividend), .divisor(divisor),
                           .quotient(quotient), .remainder(remainder), .done(done), .div_by_zero(dbz));

    always #5 clk = ~clk;

    task divide(input [7:0] x, input [7:0] y);
        begin
            @(negedge clk); dividend = x; divisor = y; start = 1;
            @(negedge clk); start = 0;
            while (!done) @(negedge clk);
            n = n + 1;
            if (y == 0) begin
                if (!dbz) errors = errors + 1;
            end else if (quotient !== x / y || remainder !== x % y || dbz) begin
                errors = errors + 1;
                if (errors < 5) $display("MISMATCH %0d / %0d -> q=%0d r=%0d", x, y, quotient, remainder);
            end
        end
    endtask

    initial begin
        @(posedge clk); #1 rst = 0;
        divide(200, 7);  $display("200 / 7  -> quotient %0d, remainder %0d", quotient, remainder);
        divide(255, 1);  $display("255 / 1  -> quotient %0d, remainder %0d", quotient, remainder);
        divide(5, 9);    $display("5 / 9    -> quotient %0d, remainder %0d", quotient, remainder);
        divide(42, 0);   $display("42 / 0   -> divide-by-zero flag = %b", dbz);
        for (i = 0; i < 256; i = i + 1)
            for (j = 0; j < 256; j = j + 1)
                divide(i, j);
        $display("Restoring divider: all %0d dividend/divisor pairs checked", n - 4);
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
