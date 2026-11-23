//==============================================================================
// Project     : 100 Days of RTL Design - Day 29 / 100
// Design      : Hamming SECDED Code
// File        : hamming_secded_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Hamming SECDED Code
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module hamming_secded_tb;
    reg  [3:0] din;
    reg  [7:0] noise;
    wire [3:0] dout;
    wire       e1, e2, ep;
    integer d, i, j, errors = 0, n_single = 0, n_double = 0;

    hamming_secded dut (.i_secded(din), .i_noise(noise), .o_secded(dout),
                        .o_1bit_error(e1), .o_2bit_error(e2), .o_parity_error(ep));

    initial begin
        for (d = 0; d < 16; d = d + 1) begin
            din = d;
            // no error
            noise = 8'h00; #2;
            if (dout !== din || e1 || e2 || ep) errors = errors + 1;
            // every single-bit error in the 7-bit code word is corrected
            for (i = 0; i < 7; i = i + 1) begin
                noise = 8'h01 << i; #2;
                n_single = n_single + 1;
                if (dout !== din || !e1 || e2) errors = errors + 1;
            end
            // error only on the extra parity bit
            noise = 8'h80; #2;
            if (dout !== din || !ep) errors = errors + 1;
            // every double-bit error is flagged
            for (i = 0; i < 7; i = i + 1)
                for (j = i + 1; j < 7; j = j + 1) begin
                    noise = (8'h01 << i) | (8'h01 << j); #2;
                    n_double = n_double + 1;
                    if (!e2 || e1) errors = errors + 1;
                end
        end
        $display("Hamming SECDED: 16 data words");
        $display("  single-bit errors corrected : %0d cases", n_single);
        $display("  double-bit errors detected  : %0d cases", n_double);
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
