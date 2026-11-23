//==============================================================================
// Project     : 100 Days of RTL Design - Day 99 / 100
// Design      : Manchester Encoder / Decoder
// File        : manchester_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Manchester Encoder / Decoder
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module manchester_tb;
    reg clk = 0, rst = 1, start = 0, frame_start = 0, stuck = 0;
    reg  [7:0] data = 0;
    wire line_tx, busy, valid, code_err;
    wire [7:0] rx;
    wire line_rx = stuck ? 1'b1 : line_tx;      // fault injection: line stuck high
    integer n, errors = 0, ok = 0, max_run = 0, run = 0;
    reg prev = 0;

    manchester_enc #(.HALF(4)) enc (.clk(clk), .rst(rst), .start(start), .data(data), .line(line_tx), .busy(busy));
    manchester_dec #(.HALF(4)) dec (.clk(clk), .rst(rst), .line(line_rx), .frame_start(frame_start),
                                    .data(rx), .valid(valid), .code_err(code_err));

    always #5 clk = ~clk;

    // line statistics while sending: longest time without a transition
    always @(posedge clk) if (busy) begin
        if (line_tx != prev) run = 0; else run = run + 1;
        if (run > max_run) max_run = run;
        prev = line_tx;
    end

    task send(input [7:0] d);
        begin
            @(negedge clk); data = d; start = 1;
            @(posedge clk); #1 start = 0; frame_start = 1;    // decoder aligned to the frame start
            @(posedge clk); #1 frame_start = 0;
            @(posedge valid); #1;
        end
    endtask

    initial begin
        @(posedge clk); #1 rst = 0;
        send(8'h00);
        $display("0x00 sent, decoded 0x%h (all zeros still give a transition every bit)", rx);
        if (rx !== 8'h00 || code_err) errors = errors + 1;
        send(8'hFF);
        $display("0xFF sent, decoded 0x%h", rx);
        if (rx !== 8'hFF || code_err) errors = errors + 1;
        for (n = 0; n < 200; n = n + 1) begin
            send($random);
            if (rx !== data || code_err) errors = errors + 1; else ok = ok + 1;
        end
        // hold the line high for one whole bit in the middle of a frame: decoder must flag it
        fork
            send(8'hA5);
            begin repeat (2 + 8 * 3) @(posedge clk); stuck = 1; repeat (8) @(posedge clk); stuck = 0; end
        join
        $display("Line stuck high for one bit time -> code error flag = %b", code_err);
        if (!code_err) errors = errors + 1;
        $display("200 random bytes decoded correctly: %0d", ok);
        $display("Longest run without a transition: %0d clocks (one bit = 8 clocks)", max_run + 1);
        if (errors == 0 && max_run < 8) $display("RESULT: PASS (0 errors)");
        else $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
