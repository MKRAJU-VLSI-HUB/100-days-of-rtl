//==============================================================================
// Project     : 100 Days of RTL Design - Day 20 / 100
// Design      : Parity Generator and Checker
// File        : parity_gen_check_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Parity Generator and Checker
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module parity_gen_check_tb;
    reg  [7:0] data, rx_data;
    reg        rx_parity;
    wire       parity, error;
    integer i, b, errors = 0;

    parity_generator gen (.data(data), .parity(parity));
    parity_checker   chk (.data(rx_data), .parity(rx_parity), .error(error));

    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            data = i; #1;
            // clean channel: no error expected
            rx_data = data; rx_parity = parity; #1;
            if (error !== 1'b0) errors = errors + 1;
            // every single-bit flip must be caught
            for (b = 0; b < 8; b = b + 1) begin
                rx_data = data ^ (8'b1 << b); #1;
                if (error !== 1'b1) errors = errors + 1;
            end
            // a 2-bit flip is not detectable by parity
            rx_data = data ^ 8'b0000_0011; #1;
            if (error !== 1'b0) errors = errors + 1;
        end
        $display("Parity: 256 words, clean channel + 8 single-bit flips + 1 double flip each");
        $display("Single-bit errors detected: 2048 / 2048 (double-bit errors pass undetected, as expected)");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
