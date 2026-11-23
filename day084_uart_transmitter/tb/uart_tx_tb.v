//==============================================================================
// Project     : 100 Days of RTL Design - Day 84 / 100
// Design      : UART Transmitter
// File        : uart_tx_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the UART Transmitter
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module uart_tx_tb;
    localparam CPB = 16;
    reg clk = 0, rst = 1, tx_start = 0;
    reg  [7:0] tx_data = 0;
    wire tx, tx_busy, tx_done;
    reg  [7:0] got;
    integer n, b, errors = 0, frame_errors = 0;

    uart_tx #(.CLKS_PER_BIT(CPB)) dut (.clk(clk), .rst(rst), .tx_start(tx_start), .tx_data(tx_data),
                                       .tx(tx), .tx_busy(tx_busy), .tx_done(tx_done));

    always #5 clk = ~clk;

    // independent line monitor: waits for the start bit, samples mid-bit
    task monitor_byte(output [7:0] d);
        begin
            @(negedge tx);
            #(CPB * 10 / 2);                       // middle of the start bit
            if (tx !== 1'b0) frame_errors = frame_errors + 1;
            for (b = 0; b < 8; b = b + 1) begin
                #(CPB * 10);
                d[b] = tx;
            end
            #(CPB * 10);
            if (tx !== 1'b1) frame_errors = frame_errors + 1;   // stop bit
        end
    endtask

    initial begin
        @(posedge clk); #1 rst = 0;
        repeat (5) @(posedge clk);
        if (tx !== 1'b1) errors = errors + 1;                     // idle high
        for (n = 0; n < 50; n = n + 1) begin
            @(negedge clk); tx_data = (n == 0) ? 8'h55 : (n == 1) ? 8'hA3 : $random; tx_start = 1;
            @(negedge clk); tx_start = 0;
            monitor_byte(got);
            if (got !== tx_data) errors = errors + 1;
            if (n < 2) $display("sent 0x%h, line monitor decoded 0x%h", tx_data, got);
            wait (!tx_busy);
        end
        $display("UART TX: 50 bytes at %0d clocks per bit, start/stop bits and LSB-first data checked", CPB);
        if (errors == 0 && frame_errors == 0) $display("RESULT: PASS (0 errors)");
        else $display("RESULT: FAIL (%0d data errors, %0d framing errors)", errors, frame_errors);
        $finish;
    end
endmodule
