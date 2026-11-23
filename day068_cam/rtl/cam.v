//==============================================================================
// Project     : 100 Days of RTL Design - Day 68 / 100
// Design      : Content Addressable Memory
// File        : cam.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Search by data, all 8 entries compared in parallel
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 8-entry content addressable memory (CAM), 8-bit keys.
// Instead of giving an address and getting data, you give the data (key)
// and get back the address where it is stored. All entries are compared
// in parallel in one cycle. Used in network switches and TLBs.
module cam (
    input            clk,
    input            rst,
    input            wr_en,
    input      [2:0] wr_addr,
    input      [7:0] wr_key,
    input      [7:0] search_key,
    output     [7:0] match_lines,   // one bit per entry
    output reg       hit,
    output reg [2:0] hit_addr       // lowest matching entry
);
    reg [7:0] keys  [0:7];
    reg [7:0] valid;
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) valid <= 8'h00;
        else if (wr_en) begin
            keys[wr_addr]  <= wr_key;
            valid[wr_addr] <= 1'b1;
        end
    end

    genvar g;
    generate
        for (g = 0; g < 8; g = g + 1) begin : cmp
            assign match_lines[g] = valid[g] && (keys[g] == search_key);
        end
    endgenerate

    // priority encode the match lines
    always @(*) begin
        hit = |match_lines;
        hit_addr = 3'd0;
        for (i = 7; i >= 0; i = i - 1)
            if (match_lines[i]) hit_addr = i;
    end
endmodule
