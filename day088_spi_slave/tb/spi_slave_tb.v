//==============================================================================
// Project     : 100 Days of RTL Design - Day 88 / 100
// Design      : SPI Slave with Registers
// File        : spi_slave_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the SPI Slave with Registers
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module spi_slave_tb;
    reg clk = 0, rst = 1, sclk = 0, cs_n = 1, mosi = 0;
    wire miso;
    wire [7:0] reg0;
    reg  [7:0] model [0:7];
    reg  [7:0] rd;
    integer i, n, errors = 0, writes = 0, reads = 0;
    localparam HALF = 40;               // SCLK half period 40 ns (system clock 10 ns)

    spi_slave dut (.clk(clk), .rst(rst), .sclk(sclk), .cs_n(cs_n), .mosi(mosi), .miso(miso), .reg0(reg0));

    always #5 clk = ~clk;

    // master model: mode 0 byte transfer
    task xfer(input [7:0] out, output [7:0] in);
        integer b;
        begin
            for (b = 7; b >= 0; b = b - 1) begin
                mosi = out[b];
                #(HALF) sclk = 1; in[b] = miso;
                #(HALF) sclk = 0;
            end
        end
    endtask

    task spi_write(input [2:0] a, input [7:0] d);
        reg [7:0] dummy;
        begin
            cs_n = 0; #(HALF);
            xfer({1'b1, 4'b0, a}, dummy); xfer(d, dummy);
            #(HALF) cs_n = 1; #(HALF * 2);
            model[a] = d; writes = writes + 1;
        end
    endtask

    task spi_read(input [2:0] a, output [7:0] d);
        reg [7:0] dummy;
        begin
            cs_n = 0; #(HALF);
            xfer({1'b0, 4'b0, a}, dummy); xfer(8'h00, d);
            #(HALF) cs_n = 1; #(HALF * 2);
            reads = reads + 1;
        end
    endtask

    initial begin
        for (i = 0; i < 8; i = i + 1) model[i] = 0;
        #20 rst = 0; #100;
        spi_write(3'd2, 8'hC3);
        spi_read(3'd2, rd);
        $display("write 0xC3 to reg 2, read back 0x%h", rd);
        if (rd !== 8'hC3) errors = errors + 1;
        spi_write(3'd0, 8'h5A);
        $display("write 0x5A to reg 0 -> reg0 output pins = 0x%h", reg0);
        if (reg0 !== 8'h5A) errors = errors + 1;
        for (n = 0; n < 200; n = n + 1) begin
            if ($random & 1) spi_write($random, $random);
            else begin
                i = $random & 7;
                spi_read(i, rd);
                if (rd !== model[i]) errors = errors + 1;
            end
        end
        $display("SPI slave: %0d register writes and %0d reads over SPI, all read data matched", writes, reads);
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
