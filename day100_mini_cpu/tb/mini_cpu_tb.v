//==============================================================================
// Project     : 100 Days of RTL Design - Day 100 / 100
// Design      : Mini 8-bit CPU
// File        : mini_cpu_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Mini 8-bit CPU
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module mini_cpu_tb;
    reg clk = 0, rst = 1;
    wire [7:0] pc_out, alu_result, out_port;
    wire out_valid, halted;
    integer n_out = 0, errors = 0, cycles = 0;
    integer expected [0:10];

    toplevel #(.PROGRAM("program.mem")) cpu (.clk(clk), .rst(rst), .pc_out(pc_out), .alu_result(alu_result),
                                             .out_port(out_port), .out_valid(out_valid), .halted(halted));

    always #5 clk = ~clk;

    always @(posedge clk) begin
        if (!rst && !halted) cycles = cycles + 1;
        if (out_valid) begin
            if (n_out < 10) $display("  OUT[%0d] = %0d   (Fibonacci)", n_out, out_port);
            else            $display("  OUT[%0d] = %0d  (sum 1..10)", n_out, out_port);
            if (n_out > 10 || out_port !== expected[n_out]) errors = errors + 1;
            n_out = n_out + 1;
        end
    end

    initial begin
        expected[0] = 0;  expected[1] = 1;  expected[2] = 1;  expected[3] = 2;
        expected[4] = 3;  expected[5] = 5;  expected[6] = 8;  expected[7] = 13;
        expected[8] = 21; expected[9] = 34; expected[10] = 55;
        $display("Running program.mem on the mini CPU:");
        @(posedge clk); #1 rst = 0;
        wait (halted);
        repeat (5) @(posedge clk);
        $display("CPU halted at pc = 0x%h after %0d instructions", pc_out, cycles);
        // the PC must stay frozen after HALT
        if (pc_out !== 8'h0F) errors = errors + 1;
        if (n_out != 11) errors = errors + 1;
        if (errors == 0) $display("RESULT: PASS (0 errors) - all 11 outputs correct");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end

    initial begin #100000; $display("RESULT: FAIL - CPU did not halt"); $finish; end
endmodule
