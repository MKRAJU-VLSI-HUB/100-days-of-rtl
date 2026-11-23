//==============================================================================
// Project     : 100 Days of RTL Design - Day 93 / 100
// Design      : 2x2 Systolic Array
// File        : systolic_2x2_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the 2x2 Systolic Array
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module systolic_2x2_tb;
    reg clk = 0, rst = 1, clr = 0;
    reg  [7:0] a_row0 = 0, a_row1 = 0, b_col0 = 0, b_col1 = 0;
    wire [17:0] c00, c01, c10, c11;
    reg  [7:0] A [0:1][0:1];
    reg  [7:0] B [0:1][0:1];
    integer t, i, j, errors = 0, e00, e01, e10, e11;

    systolic_2x2 dut (.clk(clk), .rst(rst), .clr(clr), .a_row0(a_row0), .a_row1(a_row1),
                      .b_col0(b_col0), .b_col1(b_col1), .c00(c00), .c01(c01), .c10(c10), .c11(c11));

    always #5 clk = ~clk;

    // feed one matrix pair with the diagonal skew:
    // cycle 0: a00, b00 | cycle 1: a01 a10, b10 b01 | cycle 2: a11, b11
    task run_product;
        begin
            @(negedge clk); clr = 1;
            a_row0 = A[0][0]; a_row1 = 0;       b_col0 = B[0][0]; b_col1 = 0;
            @(negedge clk); clr = 0;
            a_row0 = A[0][1]; a_row1 = A[1][0]; b_col0 = B[1][0]; b_col1 = B[0][1];
            @(negedge clk);
            a_row0 = 0;       a_row1 = A[1][1]; b_col0 = 0;       b_col1 = B[1][1];
            @(negedge clk);
            a_row0 = 0; a_row1 = 0; b_col0 = 0; b_col1 = 0;
            @(negedge clk);                     // last PE finishes here
        end
    endtask

    initial begin
        @(posedge clk); #1 rst = 0;
        for (t = 0; t < 300; t = t + 1) begin
            for (i = 0; i < 2; i = i + 1)
                for (j = 0; j < 2; j = j + 1) begin
                    A[i][j] = (t == 0) ? (i * 2 + j + 1) : (t == 1) ? 8'hFF : $random;
                    B[i][j] = (t == 0) ? (i * 2 + j + 5) : (t == 1) ? 8'hFF : $random;
                end
            run_product;
            e00 = A[0][0] * B[0][0] + A[0][1] * B[1][0];
            e01 = A[0][0] * B[0][1] + A[0][1] * B[1][1];
            e10 = A[1][0] * B[0][0] + A[1][1] * B[1][0];
            e11 = A[1][0] * B[0][1] + A[1][1] * B[1][1];
            if (c00 !== e00 || c01 !== e01 || c10 !== e10 || c11 !== e11) begin
                errors = errors + 1;
                if (errors < 4) $display("MISMATCH test %0d: got %0d %0d %0d %0d expected %0d %0d %0d %0d",
                                         t, c00, c01, c10, c11, e00, e01, e10, e11);
            end
            if (t == 0) begin
                $display("[1 2; 3 4] x [5 6; 7 8] =");
                $display("  [%0d %0d]", c00, c01);
                $display("  [%0d %0d]", c10, c11);
            end
        end
        $display("2x2 systolic array: 300 matrix products checked (including all-255 worst case)");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
