//==============================================================================
// Project     : 100 Days of RTL Design - Day 66 / 100
// Design      : Asynchronous FIFO
// File        : async_fifo.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Two clock domains, Gray-coded pointers and 2-flop synchronisers
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// Asynchronous FIFO (separate write and read clocks), 16 x 8.
// Pointers are kept in binary for addressing and converted to Gray code
// before crossing to the other clock domain through two flip-flops.
// Because only one Gray bit changes per increment, a pointer sampled
// mid-change is either the old or the new value, never garbage.
module async_fifo #(
    parameter DW = 8,
    parameter AW = 4                    // 2^AW entries
) (
    input               wclk, wrst_n, winc,
    input      [DW-1:0] wdata,
    output              wfull,
    input               rclk, rrst_n, rinc,
    output     [DW-1:0] rdata,
    output              rempty
);
    reg [DW-1:0] mem [0:(1<<AW)-1];
    reg [AW:0]   wbin, wgray, rbin, rgray;     // binary and Gray pointers

    // ---------------- write domain ----------------

    reg  [AW:0] rgray_w1, rgray_w2;            // read pointer synchronised into wclk
    wire [AW:0] wbin_next  = wbin + (winc & ~wfull);
    wire [AW:0] wgray_next = (wbin_next >> 1) ^ wbin_next;

    always @(posedge wclk or negedge wrst_n)
        if (!wrst_n) begin wbin <= 0; wgray <= 0; end
        else         begin wbin <= wbin_next; wgray <= wgray_next; end

    always @(posedge wclk)
        if (winc && !wfull) mem[wbin[AW-1:0]] <= wdata;

    always @(posedge wclk or negedge wrst_n)
        if (!wrst_n) {rgray_w2, rgray_w1} <= 0;
        else         {rgray_w2, rgray_w1} <= {rgray_w1, rgray};

    // full: Gray pointers equal except the two MSBs are inverted
    assign wfull = (wgray == {~rgray_w2[AW:AW-1], rgray_w2[AW-2:0]});

    // ---------------- read domain ----------------

    reg  [AW:0] wgray_r1, wgray_r2;            // write pointer synchronised into rclk
    wire [AW:0] rbin_next  = rbin + (rinc & ~rempty);
    wire [AW:0] rgray_next = (rbin_next >> 1) ^ rbin_next;

    always @(posedge rclk or negedge rrst_n)
        if (!rrst_n) begin rbin <= 0; rgray <= 0; end
        else         begin rbin <= rbin_next; rgray <= rgray_next; end

    always @(posedge rclk or negedge rrst_n)
        if (!rrst_n) {wgray_r2, wgray_r1} <= 0;
        else         {wgray_r2, wgray_r1} <= {wgray_r1, wgray};

    assign rempty = (rgray == wgray_r2);
    assign rdata  = mem[rbin[AW-1:0]];
endmodule
