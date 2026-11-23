//==============================================================================
// Project     : 100 Days of RTL Design - Day 63 / 100
// Design      : Dual-Port RAM
// File        : sync_dual_port_ram_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Dual-Port RAM
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module sync_dual_port_ram_tb;
    reg        clk = 0, wr_en = 0, rd_en = 0;
    reg  [3:0] wr_addr = 0, rd_addr = 0;
    reg  [7:0] data_in = 0;
    wire [7:0] data_out;
    reg  [7:0] model [0:15];
    reg  [7:0] exp_out;
    reg        check_next = 0;
    integer i, errors = 0, reads = 0;

    sync_dual_port_ram dut (.clk(clk), .wr_en(wr_en), .rd_en(rd_en), .wr_addr(wr_addr),
                            .rd_addr(rd_addr), .data_in(data_in), .data_out(data_out));

    always #5 clk = ~clk;

    initial begin
        // fill memory
        for (i = 0; i < 16; i = i + 1) begin
            @(negedge clk); wr_en = 1; wr_addr = i; data_in = i * 17;
            @(posedge clk); model[i] = i * 17;
        end
        @(negedge clk); wr_en = 0;
        // random simultaneous reads and writes
        for (i = 0; i < 400; i = i + 1) begin
            @(negedge clk);
            if (check_next) begin
                if (data_out !== exp_out) errors = errors + 1;
                reads = reads + 1;
            end
            wr_en = $random; rd_en = $random;
            wr_addr = $random; rd_addr = $random; data_in = $random;
            @(posedge clk);
            check_next = rd_en;
            exp_out = model[rd_addr];            // read-first: old value
            if (wr_en) model[wr_addr] = data_in;
        end
        $display("Dual-port RAM: 400 cycles of independent read/write traffic, %0d reads checked", reads);
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
