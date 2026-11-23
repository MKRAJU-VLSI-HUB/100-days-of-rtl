//==============================================================================
// Project     : 100 Days of RTL Design - Day 86 / 100
// Design      : UART Loopback System
// File        : uart_loopback_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the UART Loopback System
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module uart_loopback_tb;
    localparam CPB = 16, BIT = CPB * 10;
    reg clk = 0, rst = 1, pc_tx = 1;
    wire board_tx;
    wire [7:0] last_rx;
    reg  [8*16-1:0] msg = "Hello VLSI 2026!";
    reg  [7:0] ch, echoed, exp;
    integer i, b, errors = 0;
    reg [8*16-1:0] reply;

    uart_loopback #(.CPB(CPB)) dut (.clk(clk), .rst(rst), .rx_line(pc_tx), .tx_line(board_tx), .last_rx(last_rx));

    always #5 clk = ~clk;

    // PC side: send one character
    task pc_send(input [7:0] d);
        begin
            pc_tx = 0; #(BIT);
            for (b = 0; b < 8; b = b + 1) begin pc_tx = d[b]; #(BIT); end
            pc_tx = 1; #(BIT);
        end
    endtask

    // PC side: receive one character from the board
    task pc_recv(output [7:0] d);
        integer k;
        begin
            @(negedge board_tx); #(BIT / 2);
            for (k = 0; k < 8; k = k + 1) begin #(BIT); d[k] = board_tx; end
            #(BIT);
        end
    endtask

    initial begin
        @(posedge clk); #1 rst = 0;
        #(BIT * 2);
        for (i = 15; i >= 0; i = i - 1) begin
            ch = msg[i*8 +: 8];
            fork
                pc_send(ch);
                pc_recv(echoed);
            join
            exp = ((ch >= "a" && ch <= "z") || (ch >= "A" && ch <= "Z")) ? ch ^ 8'h20 : ch;
            if (echoed !== exp) errors = errors + 1;
            reply[i*8 +: 8] = echoed;
        end
        $display("PC sent    : \"%s\"", msg);
        $display("Board echo : \"%s\"", reply);
        $display("UART loopback: 16 characters through RX -> controller -> TX, case swapped");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
