//==============================================================================
// Project     : 100 Days of RTL Design - Day 97 / 100
// Design      : 4x4 Keypad Scanner
// File        : keypad_scanner_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the 4x4 Keypad Scanner
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module keypad_scanner_tb;
    reg clk = 0, rst = 1;
    wire [3:0] col_n, key_code;
    wire key_valid, key_down;
    reg  [15:0] pressed = 0;            // one bit per key, row*4 + col
    wire [3:0] row_n;
    integer k, errors = 0, reports = 0;
    reg [7:0] label [0:15];
    reg [8*16-1:0] typed;

    // keypad model: a row reads low when a pressed key in it sits on the selected column
    genvar r;
    generate
        for (r = 0; r < 4; r = r + 1) begin : rows
            assign row_n[r] = ~|(pressed[r*4 +: 4] & ~col_n);
        end
    endgenerate

    keypad_scanner #(.COL_TIME(4), .SCAN_STABLE(3)) dut (.clk(clk), .rst(rst), .row_n(row_n), .col_n(col_n),
                                                          .key_code(key_code), .key_valid(key_valid), .key_down(key_down));

    always #5 clk = ~clk;

    always @(posedge clk) if (key_valid) begin
        reports = reports + 1;
        typed = {typed[8*15-1:0], label[key_code]};
    end

    // press a key with contact bounce, hold it, release it
    task press_key(input [3:0] code);
        integer b;
        begin
            for (b = 0; b < 6; b = b + 1) begin pressed[code] = ~pressed[code]; #(7 + ($random & 7)); end
            pressed[code] = 1;
            #(16 * 10 * 6);                 // hold for 6 full scans
            pressed[code] = 0;
            #(16 * 10 * 4);                 // released for 4 scans
        end
    endtask

    initial begin
        label[0]="1"; label[1]="2"; label[2]="3"; label[3]="A";
        label[4]="4"; label[5]="5"; label[6]="6"; label[7]="B";
        label[8]="7"; label[9]="8"; label[10]="9"; label[11]="C";
        label[12]="*"; label[13]="0"; label[14]="#"; label[15]="D";
        typed = "";
        @(posedge clk); #1 rst = 0;
        // type every key once, in order
        for (k = 0; k < 16; k = k + 1) begin
            press_key(k);
            if (key_code !== k) errors = errors + 1;
        end
        // a very short glitch must not register
        pressed[5] = 1; #30; pressed[5] = 0; #(16 * 10 * 5);
        $display("Typed all 16 keys with contact bounce, scanner reported: \"%s\"", typed);
        $display("Key reports: %0d (one per press, glitch ignored)", reports);
        if (errors == 0 && reports == 16) $display("RESULT: PASS (0 errors)");
        else $display("RESULT: FAIL (%0d errors, %0d reports)", errors, reports);
        $finish;
    end
endmodule
