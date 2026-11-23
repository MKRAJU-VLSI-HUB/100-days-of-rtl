//==============================================================================
// Project     : 100 Days of RTL Design - Day 88 / 100
// Design      : SPI Slave with Registers
// File        : spi_slave.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Register read and write over SPI from a microcontroller-style master
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// SPI slave, mode 0, with a small register file behind it.
// Protocol (2 bytes per transaction, CS_n low for both):
//   byte 1 : {rw, 4'b0, addr[2:0]}   rw = 1 write, rw = 0 read
//   byte 2 : write -> data to store ; read -> slave returns reg[addr]
// SPI signals are synchronised into the system clock domain, so the
// system clock must be at least 4x faster than SCLK.
module spi_slave (
    input            clk,
    input            rst,
    input            sclk,
    input            cs_n,
    input            mosi,
    output reg       miso,
    output     [7:0] reg0           // register 0 brought out (e.g. to LEDs)
);
    reg [2:0] sclk_s, cs_s;
    reg [1:0] mosi_s;
    always @(posedge clk or posedge rst) begin
        if (rst) begin sclk_s <= 0; cs_s <= 3'b111; mosi_s <= 0; end
        else begin
            sclk_s <= {sclk_s[1:0], sclk};
            cs_s   <= {cs_s[1:0], cs_n};
            mosi_s <= {mosi_s[0], mosi};
        end
    end
    wire sclk_rise = (sclk_s[2:1] == 2'b01);
    wire sclk_fall = (sclk_s[2:1] == 2'b10);
    wire cs_active = ~cs_s[1];
    wire cs_start  = (cs_s[2:1] == 2'b10);

    reg [7:0] regs [0:7];
    reg [7:0] sh, tx_sh;
    reg [3:0] bitcnt;
    reg       byte2, rw;
    reg [2:0] addr;
    integer i;

    assign reg0 = regs[0];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 8; i = i + 1) regs[i] <= 8'h00;
            sh <= 0; tx_sh <= 0; bitcnt <= 0; byte2 <= 0; rw <= 0; addr <= 0; miso <= 0;
        end else if (cs_start) begin
            bitcnt <= 0; byte2 <= 0; miso <= 0; tx_sh <= 0;
        end else if (cs_active) begin
            if (sclk_rise) begin
                sh <= {sh[6:0], mosi_s[1]};
                bitcnt <= bitcnt + 1'b1;
                if (bitcnt == 4'd7) begin
                    bitcnt <= 0;
                    if (!byte2) begin
                        rw <= sh[6]; addr <= {sh[1:0], mosi_s[1]}; byte2 <= 1;
                        tx_sh <= regs[{sh[1:0], mosi_s[1]}];       // read data for byte 2
                    end else if (rw)
                        regs[addr] <= {sh[6:0], mosi_s[1]};
                end
            end
            if (sclk_fall) begin                      // drive MISO after the falling edge
                miso  <= tx_sh[7];
                tx_sh <= {tx_sh[6:0], 1'b0};
            end
        end
    end
endmodule
