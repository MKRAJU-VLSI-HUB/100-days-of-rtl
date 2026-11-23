//==============================================================================
// Project     : 100 Days of RTL Design - Day 86 / 100
// Design      : UART Loopback System
// File        : uart_loopback.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Receiver, controller and transmitter that echo text back with case swapped
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// UART loopback system: a transmitter and receiver joined through the
// serial line, plus a small controller that echoes every received byte
// back out with its case swapped (a -> A, A -> a), the way a test
// console on a board would. Both sides share one CLKS_PER_BIT setting.
module uart_tx_core #(parameter CPB = 16) (
    input clk, rst, start, input [7:0] data, output reg tx, output busy
);
    reg [3:0] idx; reg [15:0] cnt; reg [9:0] frame; reg run;
    assign busy = run;
    always @(posedge clk or posedge rst) begin
        if (rst) begin tx <= 1; idx <= 0; cnt <= 0; frame <= 10'h3FF; run <= 0; end
        else if (!run) begin
            tx <= 1;
            if (start) begin frame <= {1'b1, data, 1'b0}; run <= 1; idx <= 0; cnt <= 0; end
        end else begin
            tx <= frame[idx];
            if (cnt == CPB - 1) begin
                cnt <= 0;
                if (idx == 4'd9) run <= 0; else idx <= idx + 1'b1;
            end else cnt <= cnt + 1'b1;
        end
    end
endmodule

module uart_rx_core #(parameter CPB = 16) (
    input clk, rst, rx, output reg [7:0] data, output reg valid
);
    reg s1, s; reg [3:0] idx; reg [15:0] cnt; reg busy; reg [7:0] sh;
    always @(posedge clk or posedge rst) begin
        if (rst) begin s1 <= 1; s <= 1; end else begin s1 <= rx; s <= s1; end
    end
    always @(posedge clk or posedge rst) begin
        if (rst) begin busy <= 0; idx <= 0; cnt <= 0; sh <= 0; data <= 0; valid <= 0; end
        else begin
            valid <= 0;
            if (!busy) begin
                if (!s) begin busy <= 1; cnt <= 0; idx <= 0; end
            end else if (cnt == ((idx == 0) ? CPB / 2 - 1 : CPB - 1)) begin
                cnt <= 0;
                if (idx == 0 && s) busy <= 0;                    // false start
                else if (idx >= 1 && idx <= 8) sh <= {s, sh[7:1]};
                if (idx == 4'd9) begin busy <= 0; data <= sh; valid <= s; end
                else idx <= idx + 1'b1;
            end else cnt <= cnt + 1'b1;
        end
    end
endmodule

module uart_loopback #(parameter CPB = 16) (
    input        clk,
    input        rst,
    input        rx_line,      // from the PC
    output       tx_line,      // back to the PC
    output [7:0] last_rx
);
    wire [7:0] rdata; wire rvalid; wire tbusy;
    reg  [7:0] echo; reg pending, tstart;

    uart_rx_core #(CPB) RX (.clk(clk), .rst(rst), .rx(rx_line), .data(rdata), .valid(rvalid));
    uart_tx_core #(CPB) TX (.clk(clk), .rst(rst), .start(tstart), .data(echo), .tx(tx_line), .busy(tbusy));

    // swap the case of letters, pass everything else unchanged
    function [7:0] swap_case(input [7:0] c);
        if ((c >= "a" && c <= "z") || (c >= "A" && c <= "Z")) swap_case = c ^ 8'h20;
        else swap_case = c;
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin echo <= 0; pending <= 0; tstart <= 0; end
        else begin
            tstart <= 0;
            if (rvalid) begin echo <= swap_case(rdata); pending <= 1; end
            else if (pending && !tbusy && !tstart) begin tstart <= 1; pending <= 0; end
        end
    end

    assign last_rx = rdata;
endmodule
