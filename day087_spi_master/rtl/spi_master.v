//==============================================================================
// Project     : 100 Days of RTL Design - Day 87 / 100
// Design      : SPI Master
// File        : spi_master.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Mode 0 full-duplex byte transfers
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// SPI master, mode 0 (CPOL = 0, CPHA = 0), 8-bit, MSB first.
// SCLK = clk / (2 * CLK_DIV). Data is put on MOSI before the rising
// SCLK edge; MISO is sampled on the rising edge. CS_n is low for the
// whole byte. Full duplex: one byte goes out while one comes in.
module spi_master #(
    parameter CLK_DIV = 4
) (
    input            clk,
    input            rst,
    input            start,
    input      [7:0] tx_byte,
    output reg [7:0] rx_byte,
    output reg       done,
    output           busy,
    output reg       sclk,
    output reg       mosi,
    input            miso,
    output reg       cs_n
);
    reg [15:0] div;
    reg [3:0]  bits;        // bits remaining
    reg [7:0]  tx_sh, rx_sh;
    reg        active;

    assign busy = active;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            div <= 0; bits <= 0; tx_sh <= 0; rx_sh <= 0; active <= 0;
            sclk <= 0; mosi <= 0; cs_n <= 1; rx_byte <= 0; done <= 0;
        end else begin
            done <= 0;
            if (!active) begin
                sclk <= 0;
                if (start) begin
                    active <= 1; cs_n <= 0;
                    tx_sh <= {tx_byte[6:0], 1'b0};
                    mosi  <= tx_byte[7];               // first bit ready before the first edge
                    bits  <= 4'd8; div <= 0;
                end
            end else if (div == CLK_DIV - 1) begin
                div <= 0;
                if (!sclk) begin                       // rising edge: sample MISO
                    sclk  <= 1;
                    rx_sh <= {rx_sh[6:0], miso};
                end else begin                         // falling edge: next MOSI bit
                    sclk <= 0;
                    bits <= bits - 1'b1;
                    if (bits == 4'd1) begin
                        active <= 0; cs_n <= 1; done <= 1;
                        rx_byte <= rx_sh;
                    end else begin
                        mosi  <= tx_sh[7];
                        tx_sh <= {tx_sh[6:0], 1'b0};
                    end
                end
            end else div <= div + 1'b1;
        end
    end
endmodule
