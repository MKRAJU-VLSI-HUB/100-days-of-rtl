//==============================================================================
// Project     : 100 Days of RTL Design - Day 85 / 100
// Design      : UART Receiver
// File        : uart_rx.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Mid-bit sampling, glitch rejection and framing error detection
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// UART receiver, 8N1, LSB first.
// The input is synchronised with two flops. After a falling edge the
// receiver waits half a bit and checks the line is still low (a real start
// bit, not a glitch), then samples each bit in its middle.
// frame_err is set when the stop bit is not high.
module uart_rx #(
    parameter CLKS_PER_BIT = 16
) (
    input            clk,
    input            rst,
    input            rx,
    output reg [7:0] rx_data,
    output reg       rx_valid,
    output reg       frame_err
);
    localparam IDLE = 2'd0, START = 2'd1, DATA = 2'd2, STOP = 2'd3;
    reg [1:0]  state;
    reg [15:0] clk_cnt;
    reg [2:0]  bit_idx;
    reg [7:0]  shreg;
    reg        rx_s1, rx_s;

    always @(posedge clk or posedge rst) begin
        if (rst) begin rx_s1 <= 1'b1; rx_s <= 1'b1; end
        else     begin rx_s1 <= rx;   rx_s <= rx_s1; end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE; clk_cnt <= 0; bit_idx <= 0; shreg <= 0;
            rx_data <= 0; rx_valid <= 0; frame_err <= 0;
        end else begin
            rx_valid <= 1'b0;
            case (state)
                IDLE: begin
                    clk_cnt <= 0;
                    if (!rx_s) state <= START;
                end
                START: begin
                    if (clk_cnt == CLKS_PER_BIT / 2 - 1) begin
                        clk_cnt <= 0;
                        if (!rx_s) begin bit_idx <= 0; state <= DATA; end
                        else state <= IDLE;                    // glitch, not a start bit
                    end else clk_cnt <= clk_cnt + 1'b1;
                end
                DATA: begin
                    if (clk_cnt == CLKS_PER_BIT - 1) begin
                        clk_cnt <= 0;
                        shreg <= {rx_s, shreg[7:1]};
                        if (bit_idx == 3'd7) state <= STOP;
                        else bit_idx <= bit_idx + 1'b1;
                    end else clk_cnt <= clk_cnt + 1'b1;
                end
                STOP: begin
                    if (clk_cnt == CLKS_PER_BIT - 1) begin
                        clk_cnt   <= 0;
                        rx_data   <= shreg;
                        rx_valid  <= rx_s;
                        frame_err <= ~rx_s;
                        state     <= IDLE;
                    end else clk_cnt <= clk_cnt + 1'b1;
                end
            endcase
        end
    end
endmodule
