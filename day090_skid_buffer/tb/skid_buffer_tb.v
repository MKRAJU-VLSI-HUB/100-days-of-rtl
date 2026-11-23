//==============================================================================
// Project     : 100 Days of RTL Design - Day 90 / 100
// Design      : Valid/Ready Skid Buffer
// File        : skid_buffer_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Valid/Ready Skid Buffer
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module skid_buffer_tb;
    reg clk = 0, rst = 1, in_valid = 0, out_ready = 0;
    reg  [7:0] in_data = 0;
    wire in_ready, out_valid;
    wire [7:0] out_data;
    reg  [7:0] next_tx = 0, next_rx = 0;
    integer cyc, errors = 0, sent = 0, recv = 0, stall_cycles = 0, full_rate = 0;

    skid_buffer #(.W(8)) dut (.clk(clk), .rst(rst), .in_valid(in_valid), .in_ready(in_ready), .in_data(in_data),
                              .out_valid(out_valid), .out_ready(out_ready), .out_data(out_data));

    always #5 clk = ~clk;

    initial begin
        @(posedge clk); #1 rst = 0;
        for (cyc = 0; cyc < 3000; cyc = cyc + 1) begin
            @(negedge clk);
            // phase 1: no back-pressure, phase 2: random stalls on both sides
            if (cyc < 200) begin in_valid = 1; out_ready = 1; end
            else begin in_valid = ($random % 4 != 0); out_ready = ($random % 3 != 0); end
            in_data = next_tx;
            if (!out_ready) stall_cycles = stall_cycles + 1;
            @(posedge clk);
            if (in_valid && in_ready) begin next_tx = next_tx + 1; sent = sent + 1; end
            if (out_valid && out_ready) begin
                if (out_data !== next_rx) errors = errors + 1;   // no loss, no duplicates, in order
                next_rx = next_rx + 1; recv = recv + 1;
                if (cyc >= 10 && cyc < 200) full_rate = full_rate + 1;
            end
        end
        $display("Skid buffer: %0d words sent, %0d received in order, %0d downstream stall cycles", sent, recv, stall_cycles);
        $display("  without stalls it moved %0d words in 190 clocks (one per clock)", full_rate);
        if (errors == 0 && full_rate == 190 && sent - recv <= 2) $display("RESULT: PASS (0 errors)");
        else $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
