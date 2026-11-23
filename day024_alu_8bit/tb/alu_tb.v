//==============================================================================
// Project     : 100 Days of RTL Design - Day 24 / 100
// Design      : 8-bit ALU
// File        : alu_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the 8-bit ALU
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module alu_tb;
    reg  [7:0]  a, b;
    reg  [3:0]  cmd;
    reg         oe;
    wire [15:0] d_out;
    reg  [15:0] exp;
    integer i, errors = 0, checks = 0;

    alu dut (.a_in(a), .b_in(b), .command_in(cmd), .oe(oe), .d_out(d_out));

    // reference model
    function [15:0] model(input [7:0] a, input [7:0] b, input [3:0] c);
        begin
            case (c)
                4'h0: model = a + b;
                4'h1: model = a + 1;
                4'h2: model = {8'h00, a} - {8'h00, b};
                4'h3: model = {8'h00, a} - 16'd1;
                4'h4: model = a * b;
                4'h5: model = (b != 0) ? a / b : 16'hFFFF;
                4'h6: model = {8'h00, a} << 1;
                4'h7: model = a >> 1;
                4'h8: model = a & b;
                4'h9: model = a | b;
                4'hA: model = ~{8'h00, a};
                4'hB: model = ~({8'h00, a} & {8'h00, b});
                4'hC: model = ~({8'h00, a} | {8'h00, b});
                4'hD: model = a ^ b;
                4'hE: model = ~({8'h00, a} ^ {8'h00, b});
                4'hF: model = a;
            endcase
        end
    endfunction

    initial begin
        oe = 1;
        for (i = 0; i < 16 * 2000; i = i + 1) begin
            cmd = i % 16;
            a = $random; b = $random;
            if (i < 64) b = i % 4;            // make sure b = 0 is hit for DIV
            #2;
            exp = model(a, b, cmd);
            checks = checks + 1;
            if (d_out !== exp) begin
                errors = errors + 1;
                if (errors < 10) $display("MISMATCH cmd=%h a=%0d b=%0d out=%h exp=%h", cmd, a, b, d_out, exp);
            end
        end
        oe = 0; #2;
        if (d_out !== 16'hzzzz) errors = errors + 1;
        $display("ALU: %0d random checks over all 16 operations + tri-state check", checks);
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
