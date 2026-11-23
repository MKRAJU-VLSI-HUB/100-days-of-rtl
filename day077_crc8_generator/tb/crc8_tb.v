//==============================================================================
// Project     : 100 Days of RTL Design - Day 77 / 100
// Design      : CRC-8 Generator
// File        : crc8_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the CRC-8 Generator
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module crc8_tb;
    reg clk = 0, rst = 1, init = 0, en = 0, din = 0;
    wire [7:0] crc;
    integer f, k, b, errors = 0, detected = 0, len;
    reg [7:0] frame [0:15];
    reg [7:0] tx_crc, ref_crc;

    crc8 dut (.clk(clk), .rst(rst), .init(init), .en(en), .din(din), .crc(crc));

    always #5 clk = ~clk;

    // byte-wise software reference
    function [7:0] ref_byte(input [7:0] c, input [7:0] d);
        integer i;
        begin
            c = c ^ d;
            for (i = 0; i < 8; i = i + 1) c = c[7] ? ((c << 1) ^ 8'h07) : (c << 1);
            ref_byte = c;
        end
    endfunction

    task shift_byte(input [7:0] d);
        begin
            for (b = 7; b >= 0; b = b - 1) begin
                @(negedge clk); en = 1; din = d[b];
            end
            @(negedge clk); en = 0;
        end
    endtask

    task start_frame;
        begin @(negedge clk); init = 1; @(negedge clk); init = 0; end
    endtask

    initial begin
        @(posedge clk); #1 rst = 0;
        // standard check value: CRC-8 of ASCII "123456789" is 0xF4
        start_frame;
        for (k = 0; k < 9; k = k + 1) shift_byte("1" + k);
        $display("CRC-8 of \"123456789\" = 0x%h (standard check value 0xF4)", crc);
        if (crc !== 8'hF4) errors = errors + 1;

        for (f = 0; f < 100; f = f + 1) begin
            len = 1 + ($random & 15);
            if (len > 16) len = 16;
            ref_crc = 0;
            start_frame;
            for (k = 0; k < len; k = k + 1) begin
                frame[k] = $random;
                ref_crc = ref_byte(ref_crc, frame[k]);
                shift_byte(frame[k]);
            end
            tx_crc = crc;
            if (tx_crc !== ref_crc) errors = errors + 1;
            // receiver: data + CRC must leave a zero remainder
            start_frame;
            for (k = 0; k < len; k = k + 1) shift_byte(frame[k]);
            shift_byte(tx_crc);
            if (crc !== 8'h00) errors = errors + 1;
            // corrupt one bit: remainder must be non-zero
            start_frame;
            for (k = 0; k < len; k = k + 1) shift_byte(k == 0 ? frame[k] ^ (8'h01 << (f % 8)) : frame[k]);
            shift_byte(tx_crc);
            if (crc !== 8'h00) detected = detected + 1; else errors = errors + 1;
        end
        $display("100 random frames: CRC matches software model, clean frames check to zero");
        $display("Single-bit errors detected: %0d / 100", detected);
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
