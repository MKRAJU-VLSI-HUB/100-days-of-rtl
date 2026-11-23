//==============================================================================
// Project     : 100 Days of RTL Design - Day 74 / 100
// Design      : LCM Calculator
// File        : lcm_calc_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the LCM Calculator
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module lcm_calc_tb;
    reg clk = 0, rst = 1, start = 0;
    reg  [7:0] a = 0, b = 0;
    wire [15:0] lcm;
    wire done;
    integer i, j, errors = 0;

    lcm_calc dut (.clk(clk), .rst(rst), .start(start), .a(a), .b(b), .lcm(lcm), .done(done));

    always #5 clk = ~clk;

    function integer ref_lcm(input integer x, input integer y);
        integer p, q, t;
        begin
            if (x == 0 || y == 0) ref_lcm = 0;
            else begin
                p = x; q = y;
                while (q != 0) begin t = q; q = p % q; p = t; end
                ref_lcm = x * y / p;
            end
        end
    endfunction

    task run(input [7:0] x, input [7:0] y);
        begin
            @(negedge clk); a = x; b = y; start = 1;
            @(negedge clk); start = 0;
            while (!done) @(negedge clk);
            if (lcm !== ref_lcm(x, y)) begin
                errors = errors + 1;
                if (errors < 5) $display("MISMATCH lcm(%0d, %0d) = %0d, got %0d", x, y, ref_lcm(x, y), lcm);
            end
        end
    endtask

    initial begin
        @(posedge clk); #1 rst = 0;
        run(4, 6);     $display("lcm(4, 6)     = %0d", lcm);
        run(12, 18);   $display("lcm(12, 18)   = %0d", lcm);
        run(255, 254); $display("lcm(255, 254) = %0d", lcm);
        for (i = 1; i < 64; i = i + 1)
            for (j = 1; j < 64; j = j + 1) run(i, j);
        for (i = 0; i < 500; i = i + 1) run($random, $random);
        $display("LCM: all pairs 1..63 plus 500 random 8-bit pairs checked");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
