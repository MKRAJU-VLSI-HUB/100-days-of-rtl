//==============================================================================
// Project     : 100 Days of RTL Design - Day 80 / 100
// Design      : Round-Robin Arbiter
// File        : round_robin_arbiter.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Fair arbitration, every requester served within 4 grants
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 4-requester round-robin arbiter. After a requester is served, it drops
// to the lowest priority, so every active requester is served within
// 4 grants (no starvation, unlike a fixed priority arbiter).
// Implementation: rotate the requests so the search starts just after the
// last winner, pick the first active one, rotate the result back.
module round_robin_arbiter (
    input            clk,
    input            rst,
    input      [3:0] req,
    output reg [3:0] grant
);
    reg  [1:0] last;                       // index of the last winner
    wire [1:0] start = last + 2'd1;        // search starts here

    // rotate right by 'start' so the start position becomes bit 0
    wire [7:0] req2   = {req, req};
    wire [3:0] rot    = req2 >> start;
    wire [3:0] pick   = rot & ~(rot - 4'd1);          // first set bit
    wire [7:0] pick2  = {pick, pick} << start;
    wire [3:0] g_next = pick2[7:4];                   // rotate back

    function [1:0] idx(input [3:0] oh);
        idx = oh[1] ? 2'd1 : oh[2] ? 2'd2 : oh[3] ? 2'd3 : 2'd0;
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 4'b0000;
            last  <= 2'd3;                 // so requester 0 is checked first
        end else begin
            grant <= g_next;
            if (g_next != 0) last <= idx(g_next);
        end
    end
endmodule
