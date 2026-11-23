//==============================================================================
// Project     : 100 Days of RTL Design - Day 19 / 100
// Design      : Binary / Gray Code Converter
// File        : binary_gray_converter_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Binary / Gray Code Converter
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module binary_gray_converter_tb;
    reg  [7:0] bin_in;
    wire [7:0] gray, bin_back;
    reg  [7:0] prev_gray;
    integer i, errors = 0;

    bin2gray #(8) u_b2g (.bin(bin_in), .gray(gray));
    gray2bin #(8) u_g2b (.gray(gray),  .bin(bin_back));

    function integer ones(input [7:0] v);
        integer k;
        begin
            ones = 0;
            for (k = 0; k < 8; k = k + 1) ones = ones + v[k];
        end
    endfunction

    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            bin_in = i; #5;
            if (bin_back !== bin_in) errors = errors + 1;                 // round trip
            if (i > 0 && ones(gray ^ prev_gray) != 1) errors = errors + 1; // one bit changes
            if (i < 6) $display(" bin %b -> gray %b", bin_in, gray);
            prev_gray = gray;
        end
        $display("Checked 256 values: round trip is exact and neighbouring Gray codes differ by one bit");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
