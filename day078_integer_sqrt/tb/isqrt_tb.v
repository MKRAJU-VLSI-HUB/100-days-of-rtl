//==============================================================================
// Project     : 100 Days of RTL Design - Day 78 / 100
// Design      : Integer Square Root
// File        : isqrt_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Integer Square Root
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module isqrt_tb;
    reg clk = 0, rst = 1, start = 0;
    reg  [15:0] n = 0;
    wire [7:0] root;
    wire [8:0] rem;
    wire done;
    integer i, errors = 0;

    isqrt dut (.clk(clk), .rst(rst), .start(start), .n(n), .root(root), .rem(rem), .done(done));

    always #5 clk = ~clk;

    task run(input [15:0] v);
        begin
            @(negedge clk); n = v; start = 1;
            @(negedge clk); start = 0;
            while (!done) @(negedge clk);
            // root^2 <= v < (root+1)^2 and rem = v - root^2
            if (root * root > v || (root + 1) * (root + 1) <= v || rem !== v - root * root) begin
                errors = errors + 1;
                if (errors < 5) $display("MISMATCH sqrt(%0d) -> root %0d rem %0d", v, root, rem);
            end
        end
    endtask

    initial begin
        @(posedge clk); #1 rst = 0;
        run(16'd144);   $display("sqrt(144)   = %0d, remainder %0d", root, rem);
        run(16'd200);   $display("sqrt(200)   = %0d, remainder %0d", root, rem);
        run(16'd65535); $display("sqrt(65535) = %0d, remainder %0d", root, rem);
        for (i = 0; i < 65536; i = i + 1) run(i);
        $display("Integer square root: all 65536 inputs checked, 8 clocks each");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
