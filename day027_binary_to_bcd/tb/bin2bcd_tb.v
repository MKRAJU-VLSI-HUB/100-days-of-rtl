//==============================================================================
// Project     : 100 Days of RTL Design - Day 27 / 100
// Design      : Binary to BCD (Double Dabble)
// File        : bin2bcd_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Binary to BCD (Double Dabble)
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module bin2bcd_tb;
    reg  [7:0]  bin;
    wire [11:0] bcd;
    integer i, errors = 0;

    bin2bcd dut (.bin(bin), .bcd(bcd));

    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            bin = i; #5;
            if (bcd[11:8] !== i / 100 || bcd[7:4] !== (i / 10) % 10 || bcd[3:0] !== i % 10)
                errors = errors + 1;
        end
        bin = 8'd173; #5; $display("Example: 173 -> BCD %h", bcd);
        bin = 8'd255; #5; $display("Example: 255 -> BCD %h", bcd);
        $display("Binary to BCD: all 256 values checked");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
