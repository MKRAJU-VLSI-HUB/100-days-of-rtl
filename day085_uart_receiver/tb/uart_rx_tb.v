//==============================================================================
// Project     : 100 Days of RTL Design - Day 85 / 100
// Design      : UART Receiver
// File        : uart_rx_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the UART Receiver
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module uart_rx_tb;
    localparam CPB = 16;
    localparam BIT = CPB * 10;          // ns per bit
    reg clk = 0, rst = 1, rx = 1;
    wire [7:0] rx_data;
    wire rx_valid, frame_err;
    reg  [7:0] exp_q [0:127];
    integer n, b, sent = 0, got = 0, errors = 0, ferr = 0;

    uart_rx #(.CLKS_PER_BIT(CPB)) dut (.clk(clk), .rst(rst), .rx(rx), .rx_data(rx_data),
                                       .rx_valid(rx_valid), .frame_err(frame_err));

    always #5 clk = ~clk;

    always @(posedge clk) begin
        if (rx_valid) begin
            if (rx_data !== exp_q[got]) errors = errors + 1;
            got = got + 1;
        end
        if (frame_err && rx_valid) errors = errors + 1;
    end
    always @(posedge frame_err) ferr = ferr + 1;

    // drive one 8N1 frame; skew in percent shifts the bit time (baud mismatch)
    task send(input [7:0] d, input integer skew_pct, input stop_ok);
        integer bt;
        begin
            bt = BIT + BIT * skew_pct / 100;
            rx = 0; #(bt);
            for (b = 0; b < 8; b = b + 1) begin rx = d[b]; #(bt); end
            rx = stop_ok; #(bt);
            rx = 1; #(bt);
        end
    endtask

    initial begin
        @(posedge clk); #1 rst = 0;
        #(BIT * 2);
        // a short glitch on an idle line must not start a frame
        rx = 0; #(BIT / 4); rx = 1; #(BIT * 2);
        for (n = 0; n < 60; n = n + 1) begin
            exp_q[sent] = $random;
            send(exp_q[sent], (n % 3 == 0) ? 3 : (n % 3 == 1) ? -3 : 0, 1);   // +/-3% baud error
            sent = sent + 1;
        end
        // a frame with a broken stop bit must raise frame_err and not be delivered
        send(8'hFF, 0, 0);
        #(BIT * 2);
        $display("UART RX: %0d frames sent (some with +/-3%% baud error), %0d received correctly", sent, got);
        $display("  glitch on idle line ignored, bad stop bit flagged as frame error: %0d", ferr);
        if (errors == 0 && got == sent && ferr == 1) $display("RESULT: PASS (0 errors)");
        else $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
