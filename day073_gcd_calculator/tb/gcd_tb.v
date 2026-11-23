//==============================================================================
// Project     : 100 Days of RTL Design - Day 73 / 100
// Design      : GCD Calculator
// File        : gcd_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the GCD Calculator
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module gcd_tb;
    reg clk = 0, rst = 1, start = 0;
    reg  [7:0] a_in = 0, b_in = 0;
    wire [7:0] result;
    wire done;
    integer i, errors = 0, cycles, worst = 0;

    gcd dut (.clk(clk), .rst(rst), .start(start), .a_in(a_in), .b_in(b_in), .result(result), .done(done));

    always #5 clk = ~clk;

    function integer ref_gcd(input integer x, input integer y);
        integer t;
        begin
            while (y != 0) begin t = y; y = x % y; x = t; end
            ref_gcd = x;
        end
    endfunction

    task run(input [7:0] x, input [7:0] y);
        begin
            @(negedge clk); a_in = x; b_in = y; start = 1;
            @(negedge clk); start = 0;
            cycles = 1;
            while (!done) begin @(negedge clk); cycles = cycles + 1; end
            if (cycles > worst) worst = cycles;
            if (result !== ref_gcd(x, y)) begin
                errors = errors + 1;
                $display("MISMATCH gcd(%0d, %0d) = %0d, got %0d", x, y, ref_gcd(x, y), result);
            end
        end
    endtask

    initial begin
        @(posedge clk); #1 rst = 0;
        run(48, 18);   $display("gcd(48, 18)  = %0d  (%0d clocks)", result, cycles);
        run(255, 17);  $display("gcd(255, 17) = %0d", result);
        run(97, 89);   $display("gcd(97, 89)  = %0d (two primes)", result);
        run(0, 12);    $display("gcd(0, 12)   = %0d", result);
        for (i = 0; i < 2000; i = i + 1) run($random, $random);
        $display("GCD: 2004 pairs checked against Euclid, worst case %0d clocks", worst);
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
