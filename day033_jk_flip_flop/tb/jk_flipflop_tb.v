//==============================================================================
// Project     : 100 Days of RTL Design - Day 33 / 100
// Design      : JK Flip-Flop
// File        : jk_flipflop_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the JK Flip-Flop
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module jk_flipflop_tb;
    reg clk = 0, rst_n = 0, j = 0, k = 0;
    wire q, qn;
    reg model;
    integer i, errors = 0;

    jk_flipflop dut (.clk(clk), .rst_n(rst_n), .j(j), .k(k), .q(q), .qn(qn));

    always #5 clk = ~clk;

    initial begin
        model = 0;
        #12 rst_n = 1;
        for (i = 0; i < 100; i = i + 1) begin
            @(negedge clk);
            j = $random; k = $random;
            @(posedge clk);
            case ({j, k})
                2'b00: model = model;
                2'b01: model = 0;
                2'b10: model = 1;
                2'b11: model = ~model;
            endcase
            #1;
            if (q !== model || qn !== ~model) errors = errors + 1;
            if (i < 8) $display(" j=%b k=%b -> q=%b", j, k, q);
        end
        $display("JK flip-flop: 100 random j/k cycles compared with a model");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
