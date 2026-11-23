//==============================================================================
// Project     : 100 Days of RTL Design - Day 84 / 100
// Design      : UART Transmitter
// File        : uart_tx.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : 8N1 serial transmitter with configurable baud rate
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// UART transmitter, 8N1 (8 data bits, no parity, 1 stop bit), LSB first.
// CLKS_PER_BIT = clock frequency / baud rate
// (e.g. 50 MHz / 115200 = 434). The line idles high.
module uart_tx #(
    parameter CLKS_PER_BIT = 16
) (
    input        clk,
    input        rst,
    input        tx_start,
    input  [7:0] tx_data,
    output reg   tx,
    output       tx_busy,
    output reg   tx_done
);
    localparam IDLE = 2'd0, START = 2'd1, DATA = 2'd2, STOP = 2'd3;
    reg [1:0]  state;
    reg [15:0] clk_cnt;
    reg [2:0]  bit_idx;
    reg [7:0]  shreg;

    assign tx_busy = (state != IDLE);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE; tx <= 1'b1; clk_cnt <= 0; bit_idx <= 0; shreg <= 0; tx_done <= 0;
        end else begin
            tx_done <= 1'b0;
            case (state)
                IDLE: begin
                    tx <= 1'b1;
                    if (tx_start) begin
                        shreg <= tx_data; clk_cnt <= 0; state <= START;
                    end
                end
                START: begin
                    tx <= 1'b0;
                    if (clk_cnt == CLKS_PER_BIT - 1) begin clk_cnt <= 0; bit_idx <= 0; state <= DATA; end
                    else clk_cnt <= clk_cnt + 1'b1;
                end
                DATA: begin
                    tx <= shreg[bit_idx];
                    if (clk_cnt == CLKS_PER_BIT - 1) begin
                        clk_cnt <= 0;
                        if (bit_idx == 3'd7) state <= STOP;
                        else bit_idx <= bit_idx + 1'b1;
                    end else clk_cnt <= clk_cnt + 1'b1;
                end
                STOP: begin
                    tx <= 1'b1;
                    if (clk_cnt == CLKS_PER_BIT - 1) begin clk_cnt <= 0; tx_done <= 1'b1; state <= IDLE; end
                    else clk_cnt <= clk_cnt + 1'b1;
                end
            endcase
        end
    end
endmodule
