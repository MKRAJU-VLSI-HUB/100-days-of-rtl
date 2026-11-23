//==============================================================================
// Project     : 100 Days of RTL Design - Day 87 / 100
// Design      : SPI Master
// File        : spi_master_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the SPI Master
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module spi_master_tb;
    reg clk = 0, rst = 1, start = 0;
    reg  [7:0] tx_byte = 0;
    wire [7:0] rx_byte;
    wire done, busy, sclk, mosi, cs_n;
    reg  miso = 0;

    // behavioural SPI slave (mode 0): shifts a reply out, captures MOSI
    reg [7:0] slave_tx, slave_rx;
    integer edges;
    always @(negedge cs_n) begin slave_rx = 0; edges = 0; miso = slave_tx[7]; end
    always @(posedge sclk) if (!cs_n) begin slave_rx = {slave_rx[6:0], mosi}; edges = edges + 1; end
    always @(negedge sclk) if (!cs_n) begin slave_tx = {slave_tx[6:0], 1'b0}; miso = slave_tx[7]; end

    integer n, errors = 0;
    reg [7:0] reply;

    spi_master #(.CLK_DIV(4)) dut (.clk(clk), .rst(rst), .start(start), .tx_byte(tx_byte), .rx_byte(rx_byte),
                                   .done(done), .busy(busy), .sclk(sclk), .mosi(mosi), .miso(miso), .cs_n(cs_n));

    always #5 clk = ~clk;

    initial begin
        @(posedge clk); #1 rst = 0;
        for (n = 0; n < 100; n = n + 1) begin
            tx_byte = (n == 0) ? 8'hA5 : $random;
            reply   = (n == 0) ? 8'h3C : $random;
            slave_tx = reply;
            @(negedge clk); start = 1;
            @(negedge clk); start = 0;
            @(posedge done); #1;
            if (slave_rx !== tx_byte || rx_byte !== reply || edges != 8) errors = errors + 1;
            if (n == 0) $display("master sent 0x%h -> slave got 0x%h | slave sent 0x%h -> master got 0x%h (%0d SCLK edges)",
                                 tx_byte, slave_rx, reply, rx_byte, edges);
            repeat (3) @(posedge clk);
            if (!cs_n || sclk) errors = errors + 1;    // idle state: CS high, SCLK low
        end
        $display("SPI master: 100 full-duplex byte transfers in mode 0 checked against a slave model");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
