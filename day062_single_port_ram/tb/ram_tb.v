//==============================================================================
// Project     : 100 Days of RTL Design - Day 62 / 100
// Design      : Single-Port RAM
// File        : ram_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Single-Port RAM
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module ram_tb;
    reg        we = 0, en = 0;
    reg  [3:0] addr = 0;
    reg  [7:0] drive = 0;
    reg        tb_drives = 0;
    wire [7:0] data;
    reg  [7:0] model [0:15];
    integer i, errors = 0;

    // the testbench drives the bus only during writes
    assign data = tb_drives ? drive : 8'hzz;

    ram dut (.we_in(we), .enable_in(en), .addr_in(addr), .data(data));

    task write(input [3:0] a, input [7:0] d);
        begin
            addr = a; drive = d; tb_drives = 1; we = 1; en = 0; #10;
            we = 0; #2 tb_drives = 0; #3;
            model[a] = d;
        end
    endtask

    task read_check(input [3:0] a);
        begin
            addr = a; we = 0; en = 1; #10;
            if (data !== model[a]) begin
                errors = errors + 1;
                $display("MISMATCH addr %0d: got %h expected %h", a, data, model[a]);
            end
            en = 0; #5;
        end
    endtask

    initial begin
        for (i = 0; i < 16; i = i + 1) write(i, 8'h10 + i * 3);
        for (i = 0; i < 16; i = i + 1) read_check(i);
        for (i = 0; i < 200; i = i + 1) begin
            if ($random & 1) write($random, $random);
            else             read_check($random);
        end
        // bus must float when idle
        we = 0; en = 0; #5;
        if (data !== 8'hzz) errors = errors + 1;
        $display("Single-port RAM: 16 writes + 16 reads, then 200 random accesses, bus floats when idle");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
