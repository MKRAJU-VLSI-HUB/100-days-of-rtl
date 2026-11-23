//==============================================================================
// Project     : 100 Days of RTL Design - Day 23 / 100
// Design      : 8-bit Barrel Shifter
// File        : barrel_shifter_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the 8-bit Barrel Shifter
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module barrel_shifter_tb;
    reg  [7:0] din;
    reg  [2:0] shamt;
    reg  [1:0] op;
    wire [7:0] dout;
    reg  [7:0] exp;
    integer i, errors = 0;

    barrel_shifter dut (.din(din), .shamt(shamt), .op(op), .dout(dout));

    initial begin
        for (i = 0; i < 8192; i = i + 1) begin
            {op, shamt, din} = i[12:0]; #1;
            case (op)
                2'b00: exp = din << shamt;
                2'b01: exp = din >> shamt;
                2'b10: exp = $signed(din) >>> shamt;
                2'b11: exp = (din << shamt) | (din >> (8 - shamt));
            endcase
            if (dout !== exp) errors = errors + 1;
        end
        din = 8'b1001_0110; shamt = 3; op = 2'b11; #1;
        $display("Example: rotate left 10010110 by 3 -> %b", dout);
        din = 8'b1000_0000; shamt = 2; op = 2'b10; #1;
        $display("Example: arithmetic right 10000000 by 2 -> %b", dout);
        $display("Barrel shifter: all 8192 combinations of data, amount and op checked");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
