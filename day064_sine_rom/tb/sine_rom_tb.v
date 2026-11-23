//==============================================================================
// Project     : 100 Days of RTL Design - Day 64 / 100
// Design      : Sine Look-up ROM
// File        : sine_rom_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Sine Look-up ROM
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module sine_rom_tb;
    reg clk = 0;
    reg  [4:0] addr = 0;
    wire [7:0] data;
    integer i, k, errors = 0, exp, bar;
    real s;
    reg [8*40-1:0] line;

    sine_rom dut (.clk(clk), .addr(addr), .data(data));

    always #5 clk = ~clk;

    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            @(negedge clk); addr = i;
            @(posedge clk); #1;
            s   = $sin(2.0 * 3.14159265358979 * i / 32.0);
            exp = 128 + $rtoi(127.0 * s + (s >= 0 ? 0.5 : -0.5));
            if (data > exp + 1 || data + 1 < exp) errors = errors + 1;
            // text plot of the waveform
            bar = data / 8;
            line = "";
            for (k = 0; k < 32; k = k + 1) line = {line[8*39-1:0], (k == bar) ? "*" : (k == 16 ? "|" : " ")};
            $display(" %2d %3d %s", i, data, line[8*32-1:0]);
        end
        $display("Sine ROM: 32 samples within 1 LSB of 128 + 127*sin(2*pi*n/32), built from a 9-entry quarter table");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
