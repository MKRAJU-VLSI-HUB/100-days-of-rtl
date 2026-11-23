//==============================================================================
// Project     : 100 Days of RTL Design - Day 66 / 100
// Design      : Asynchronous FIFO
// File        : async_fifo_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Asynchronous FIFO
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module async_fifo_tb;
    reg wclk = 0, rclk = 0, wrst_n = 0, rrst_n = 0, winc = 0, rinc = 0;
    reg  [7:0] wdata = 0;
    wire [7:0] rdata;
    wire wfull, rempty;

    reg [7:0] sent [0:4095];
    integer n_wr = 0, n_rd = 0, errors = 0, full_hits = 0, empty_hits = 0;
    localparam TOTAL = 2000;

    async_fifo #(.DW(8), .AW(4)) dut (.wclk(wclk), .wrst_n(wrst_n), .winc(winc), .wdata(wdata), .wfull(wfull),
                                      .rclk(rclk), .rrst_n(rrst_n), .rinc(rinc), .rdata(rdata), .rempty(rempty));

    always #5   wclk = ~wclk;    // 100 MHz writer
    always #8.5 rclk = ~rclk;    // ~59 MHz reader, unrelated phase

    // writer: tries to write most cycles
    always @(posedge wclk) if (wrst_n) begin
        if (winc && !wfull) begin sent[n_wr] = wdata; n_wr = n_wr + 1; end
        if (wfull) full_hits = full_hits + 1;
        #1;
        winc  = (n_wr < TOTAL) && ($random % 4 != 0);
        wdata = $random;
    end

    // reader: reads when not empty, sometimes pauses
    always @(posedge rclk) if (rrst_n) begin
        if (rinc && !rempty) begin
            if (rdata !== sent[n_rd]) errors = errors + 1;
            n_rd = n_rd + 1;
        end
        if (rempty) empty_hits = empty_hits + 1;
        #1;
        rinc = ($random % 5 != 0);
    end

    initial begin
        #30 wrst_n = 1; rrst_n = 1;
        wait (n_rd == TOTAL);
        #100;
        $display("Async FIFO: %0d words written at 100 MHz, %0d read at ~59 MHz", n_wr, n_rd);
        $display("  writer saw FULL %0d times, reader saw EMPTY %0d times, data order checked", full_hits, empty_hits);
        if (errors == 0 && n_rd == TOTAL && full_hits > 0) $display("RESULT: PASS (0 errors)");
        else $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end

    initial begin #2000000; $display("RESULT: FAIL - timeout"); $finish; end
endmodule
