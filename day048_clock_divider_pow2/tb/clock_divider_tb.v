//==============================================================================
// Project     : 100 Days of RTL Design - Day 48 / 100
// Design      : Clock Divider by 2, 4, 8
// File        : clock_divider_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Clock Divider by 2, 4, 8
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module clock_divider_tb;
    reg clk = 0, rst = 1;
    wire d2, d4, d8;
    realtime r2 [0:1], r4 [0:1], r8 [0:1], f8;
    integer errors = 0;

    clock_divider dut (.clk(clk), .rst(rst), .clk_div2(d2), .clk_div4(d4), .clk_div8(d8));

    always #5 clk = ~clk;     // 100 MHz, 10 ns

    always @(posedge d2) begin r2[0] = r2[1]; r2[1] = $realtime; end
    always @(posedge d4) begin r4[0] = r4[1]; r4[1] = $realtime; end
    always @(posedge d8) begin r8[0] = r8[1]; r8[1] = $realtime; end
    always @(negedge d8) f8 = $realtime;

    initial begin
        #12 rst = 0;
        #400;
        $display("Input clock 10 ns -> div2 period %0.0f ns, div4 period %0.0f ns, div8 period %0.0f ns",
                 r2[1] - r2[0], r4[1] - r4[0], r8[1] - r8[0]);
        if (r2[1] - r2[0] != 20.0) errors = errors + 1;
        if (r4[1] - r4[0] != 40.0) errors = errors + 1;
        if (r8[1] - r8[0] != 80.0) errors = errors + 1;
        // duty cycle of div8: high for 40 ns
        if (f8 > r8[1]) begin
            if (f8 - r8[1] != 40.0) errors = errors + 1;
        end else if (r8[1] - f8 != 40.0) errors = errors + 1;
        $display("div8 duty cycle: 50%%");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
