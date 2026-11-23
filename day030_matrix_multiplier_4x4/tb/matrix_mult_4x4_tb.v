//==============================================================================
// Project     : 100 Days of RTL Design - Day 30 / 100
// Design      : 4x4 Matrix Multiplier
// File        : matrix_mult_4x4_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the 4x4 Matrix Multiplier
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module matrix_mult_4x4_tb;
    reg  [16*8-1:0]  A, B;
    wire [16*18-1:0] C;
    integer t, r, c, k, exp, errors = 0;

    matrix_mult_4x4 dut (.A(A), .B(B), .C(C));

    task print_c;
        begin
            for (r = 0; r < 4; r = r + 1)
                $display("   %6d %6d %6d %6d", C[(r*4+0)*18 +: 18], C[(r*4+1)*18 +: 18],
                                               C[(r*4+2)*18 +: 18], C[(r*4+3)*18 +: 18]);
        end
    endtask

    initial begin
        // test 1: A = 1..16, B = identity -> C must equal A
        for (k = 0; k < 16; k = k + 1) begin
            A[k*8 +: 8] = k + 1;
            B[k*8 +: 8] = (k % 5 == 0) ? 1 : 0;
        end
        #5;
        $display("A (1..16) x Identity =");
        print_c;
        for (k = 0; k < 16; k = k + 1) if (C[k*18 +: 18] !== k + 1) errors = errors + 1;

        // test 2: 200 random matrices including the worst case 255
        for (t = 0; t < 200; t = t + 1) begin
            for (k = 0; k < 16; k = k + 1) begin
                A[k*8 +: 8] = (t == 0) ? 8'hFF : $random;
                B[k*8 +: 8] = (t == 0) ? 8'hFF : $random;
            end
            #5;
            for (r = 0; r < 4; r = r + 1)
                for (c = 0; c < 4; c = c + 1) begin
                    exp = 0;
                    for (k = 0; k < 4; k = k + 1)
                        exp = exp + A[(r*4+k)*8 +: 8] * B[(k*4+c)*8 +: 8];
                    if (C[(r*4+c)*18 +: 18] !== exp) errors = errors + 1;
                end
        end
        $display("Identity test + 200 random 4x4 products checked (3200 elements)");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
