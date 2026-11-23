//==============================================================================
// Project     : 100 Days of RTL Design - Day 75 / 100
// Design      : MAC Unit
// File        : mac_unit_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the MAC Unit
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module mac_unit_tb;
    reg clk = 0, rst = 1, en = 0, clr = 0;
    reg  signed [7:0] a = 0, b = 0;
    wire signed [19:0] acc;
    wire valid;
    integer i, v, errors = 0, model, dots = 0;
    reg signed [7:0] va [0:7], vb [0:7];

    mac_unit dut (.clk(clk), .rst(rst), .en(en), .clr(clr), .a(a), .b(b), .acc(acc), .valid(valid));

    always #5 clk = ~clk;

    initial begin
        @(posedge clk); #1 rst = 0;
        // 200 dot products of 8-element signed vectors
        for (v = 0; v < 200; v = v + 1) begin
            model = 0;
            for (i = 0; i < 8; i = i + 1) begin
                va[i] = (v == 0) ? -128 : $random;
                vb[i] = (v == 0) ? -128 : $random;
                model = model + va[i] * vb[i];
            end
            for (i = 0; i < 8; i = i + 1) begin
                @(negedge clk); en = 1; clr = (i == 0); a = va[i]; b = vb[i];
            end
            @(negedge clk); en = 0; clr = 0;
            @(negedge clk);                      // pipeline latency
            if (acc !== model) begin
                errors = errors + 1;
                $display("MISMATCH dot %0d: got %0d expected %0d", v, acc, model);
            end
            dots = dots + 1;
            if (v < 2) $display(" dot product %0d = %0d", v, acc);
        end
        $display("MAC unit: %0d signed 8-element dot products checked (worst case -128 x -128 x 8 included)", dots);
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
