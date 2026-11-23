//==============================================================================
// Project     : 100 Days of RTL Design - Day 98 / 100
// Design      : 4-Digit 7-Segment Multiplexer
// File        : seg7_mux_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the 4-Digit 7-Segment Multiplexer
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module seg7_mux_tb;
    reg clk = 0, rst = 1;
    reg  [15:0] value = 0;
    wire [3:0] an_n;
    wire [6:0] seg_n;
    reg  [6:0] seen [0:3];
    integer n, d, errors = 0, active;
    reg [6:0] font [0:15];

    seg7_mux #(.REFRESH(8)) dut (.clk(clk), .rst(rst), .value(value), .an_n(an_n), .seg_n(seg_n));

    always #5 clk = ~clk;

    function [7:0] glyph(input [6:0] s);    // turn a segment pattern back into a character
        integer i;
        begin
            glyph = "?";
            if (s == 7'b0000000) glyph = " ";
            for (i = 0; i < 16; i = i + 1) if (s == font[i]) glyph = (i < 10) ? "0" + i : "A" + i - 10;
        end
    endfunction

    // capture what each digit shows over one full refresh cycle
    task capture;
        integer c;
        begin
            for (c = 0; c < 32; c = c + 1) begin
                @(posedge clk); #1;
                active = 0;
                for (d = 0; d < 4; d = d + 1) if (!an_n[d]) begin seen[d] = ~seg_n; active = active + 1; end
                if (active != 1) errors = errors + 1;      // exactly one digit on at a time
            end
        end
    endtask

    task show(input [15:0] v);
        integer i; reg [6:0] exp;
        begin
            value = v; capture;
            $display(" value 0x%h -> display [%s%s%s%s]", v, glyph(seen[3]), glyph(seen[2]), glyph(seen[1]), glyph(seen[0]));
            for (i = 0; i < 4; i = i + 1) begin
                exp = font[v[i*4 +: 4]];
                if ((i == 3 && v[15:12] == 0) || (i == 2 && v[15:8] == 0) || (i == 1 && v[15:4] == 0)) exp = 0;
                if (seen[i] !== exp) errors = errors + 1;
            end
        end
    endtask

    initial begin
        font[0]=7'b0111111; font[1]=7'b0000110; font[2]=7'b1011011; font[3]=7'b1001111;
        font[4]=7'b1100110; font[5]=7'b1101101; font[6]=7'b1111101; font[7]=7'b0000111;
        font[8]=7'b1111111; font[9]=7'b1101111; font[10]=7'b1110111; font[11]=7'b1111100;
        font[12]=7'b0111001; font[13]=7'b1011110; font[14]=7'b1111001; font[15]=7'b1110001;
        @(posedge clk); #1 rst = 0;
        show(16'hBEEF); show(16'h2026); show(16'h00A7); show(16'h0005); show(16'h0000);
        for (n = 0; n < 200; n = n + 1) begin
            value = $random; capture;
            for (d = 0; d < 4; d = d + 1)
                if (!((d == 3 && value[15:12] == 0) || (d == 2 && value[15:8] == 0) || (d == 1 && value[15:4] == 0)))
                    if (seen[d] !== font[value[d*4 +: 4]]) errors = errors + 1;
        end
        $display("7-segment multiplexer: 205 values, one digit lit at a time, leading zeros blanked");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
