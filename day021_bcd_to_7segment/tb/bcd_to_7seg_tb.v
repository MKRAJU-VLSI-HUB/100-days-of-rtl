//==============================================================================
// Project     : 100 Days of RTL Design - Day 21 / 100
// Design      : BCD to 7-Segment Decoder
// File        : bcd_to_7seg_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the BCD to 7-Segment Decoder
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module bcd_to_7seg_tb;
    reg  [3:0] bcd;
    wire [6:0] seg;
    integer i, errors = 0;

    // number of lit segments for digits 0..9
    integer lit [0:9];
    integer n, k;

    bcd_to_7seg dut (.bcd(bcd), .seg(seg));

    // draw the digit as ASCII art
    task show;
        begin
            $display("  %s ", seg[0] ? " _ " : "   ");
            $display("  %s%s%s", seg[5] ? "|" : " ", seg[6] ? "_" : " ", seg[1] ? "|" : " ");
            $display("  %s%s%s   <- %0d", seg[4] ? "|" : " ", seg[3] ? "_" : " ", seg[2] ? "|" : " ", bcd);
        end
    endtask

    initial begin
        lit[0]=6; lit[1]=2; lit[2]=5; lit[3]=5; lit[4]=4;
        lit[5]=5; lit[6]=6; lit[7]=3; lit[8]=7; lit[9]=6;
        for (i = 0; i < 16; i = i + 1) begin
            bcd = i; #10;
            n = 0;
            for (k = 0; k < 7; k = k + 1) n = n + seg[k];
            if (i < 10) begin
                show;
                if (n != lit[i]) errors = errors + 1;
            end else if (seg !== 7'b0) errors = errors + 1;
        end
        // spot checks on exact patterns
        bcd = 4'd1; #1; if (seg !== 7'b000_0110) errors = errors + 1;
        bcd = 4'd8; #1; if (seg !== 7'b111_1111) errors = errors + 1;
        if (errors == 0) $display("RESULT: PASS - digits 0..9 drawn correctly, 10..15 blank");
        else             $display("RESULT: FAIL - %0d errors", errors);
        $finish;
    end
endmodule
