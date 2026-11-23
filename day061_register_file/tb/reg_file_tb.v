//==============================================================================
// Project     : 100 Days of RTL Design - Day 61 / 100
// Design      : Register File
// File        : reg_file_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Register File
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module reg_file_tb;
    reg        clk = 0, rst = 1, we = 0;
    reg  [2:0] waddr = 0, ra = 0, rb = 0;
    reg  [7:0] wdata = 0;
    wire [7:0] rda, rdb;
    reg  [7:0] model [0:7];
    integer i, errors = 0;

    reg_file dut (.clk(clk), .rst(rst), .we(we), .waddr(waddr), .wdata(wdata),
                  .raddr_a(ra), .raddr_b(rb), .rdata_a(rda), .rdata_b(rdb));

    always #5 clk = ~clk;

    function [7:0] exp_rd(input [2:0] a);
        if (a == 0)                  exp_rd = 0;
        else if (we && a == waddr)   exp_rd = wdata;
        else                         exp_rd = model[a];
    endfunction

    initial begin
        for (i = 0; i < 8; i = i + 1) model[i] = 0;
        @(posedge clk); #1 rst = 0;
        for (i = 0; i < 500; i = i + 1) begin
            @(negedge clk);
            we = $random; waddr = $random; wdata = $random; ra = $random; rb = $random;
            #1;
            if (rda !== exp_rd(ra) || rdb !== exp_rd(rb)) errors = errors + 1;
            @(posedge clk);
            if (we && waddr != 0) model[waddr] = wdata;
        end
        // register 0 can never be written
        @(negedge clk); we = 1; waddr = 0; wdata = 8'hFF; ra = 0;
        @(posedge clk); #1; if (rda !== 8'h00) errors = errors + 1;
        $display("Register file: 500 random cycles, 2 reads + 1 write each, forwarding and r0 = 0 checked");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
