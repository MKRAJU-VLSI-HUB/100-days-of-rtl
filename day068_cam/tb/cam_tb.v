//==============================================================================
// Project     : 100 Days of RTL Design - Day 68 / 100
// Design      : Content Addressable Memory
// File        : cam_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Content Addressable Memory
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module cam_tb;
    reg clk = 0, rst = 1, wr_en = 0;
    reg  [2:0] wr_addr = 0;
    reg  [7:0] wr_key = 0, search_key = 0;
    wire [7:0] match_lines;
    wire hit;
    wire [2:0] hit_addr;
    reg  [7:0] mkeys [0:7];
    reg  [7:0] mvalid = 0, exp_lines;
    integer i, k, errors = 0, hits = 0, searches = 0;

    cam dut (.clk(clk), .rst(rst), .wr_en(wr_en), .wr_addr(wr_addr), .wr_key(wr_key),
             .search_key(search_key), .match_lines(match_lines), .hit(hit), .hit_addr(hit_addr));

    always #5 clk = ~clk;

    task search(input [7:0] key);
        integer a;
        begin
            search_key = key; #1;
            exp_lines = 0; a = -1;
            for (k = 7; k >= 0; k = k - 1)
                if (mvalid[k] && mkeys[k] == key) begin exp_lines[k] = 1; a = k; end
            if (match_lines !== exp_lines || hit !== (a >= 0) || (a >= 0 && hit_addr !== a)) errors = errors + 1;
            searches = searches + 1; hits = hits + hit;
        end
    endtask

    initial begin
        @(posedge clk); #1 rst = 0;
        // store some keys (entry 6 duplicates entry 2)
        for (i = 0; i < 7; i = i + 1) begin
            @(negedge clk); wr_en = 1; wr_addr = i;
            wr_key = (i == 6) ? 8'h42 : 8'h40 + i;
            @(posedge clk); mkeys[i] = wr_key; mvalid[i] = 1;
        end
        @(negedge clk); wr_en = 0;
        search(8'h43); $display("search 0x43 -> hit=%b addr=%0d", hit, hit_addr);
        search(8'h42); $display("search 0x42 -> hit=%b addr=%0d, match lines %b (two copies)", hit, hit_addr, match_lines);
        search(8'h99); $display("search 0x99 -> hit=%b (not stored)", hit);
        // random writes and searches
        for (i = 0; i < 400; i = i + 1) begin
            @(negedge clk);
            wr_en = ($random % 4 == 0); wr_addr = $random; wr_key = $random & 8'h0F;
            search($random & 8'h0F);           // small key range so hits happen
            @(posedge clk); if (wr_en) begin mkeys[wr_addr] = wr_key; mvalid[wr_addr] = 1; end
        end
        $display("CAM: %0d searches, %0d hits, all match lines checked against a model", searches, hits);
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
