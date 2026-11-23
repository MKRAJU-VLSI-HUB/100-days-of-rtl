//==============================================================================
// Project     : 100 Days of RTL Design - Day 54 / 100
// Design      : CDC Synchronizers
// File        : synchronizers.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : 2-flop level synchroniser and toggle pulse synchroniser between two clocks
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// Clock domain crossing helpers.
// 1) sync_2ff  : two-flop synchroniser for a slow level signal.
// 2) pulse_sync: carries a single-clock pulse from clock A to clock B.
//    The pulse toggles a flag in domain A; the toggle is synchronised into
//    domain B and an edge detector turns it back into a pulse.
module sync_2ff (
    input      clk_dst,
    input      rst,
    input      d_async,
    output reg q
);
    reg meta;
    always @(posedge clk_dst or posedge rst) begin
        if (rst) begin meta <= 1'b0; q <= 1'b0; end
        else     begin meta <= d_async; q <= meta; end
    end
endmodule

module pulse_sync (
    input  clk_a,
    input  clk_b,
    input  rst,
    input  pulse_a,
    output pulse_b
);
    reg toggle_a;
    always @(posedge clk_a or posedge rst) begin
        if (rst)          toggle_a <= 1'b0;
        else if (pulse_a) toggle_a <= ~toggle_a;
    end

    reg [2:0] sync_b;
    always @(posedge clk_b or posedge rst) begin
        if (rst) sync_b <= 3'b000;
        else     sync_b <= {sync_b[1:0], toggle_a};
    end

    assign pulse_b = sync_b[2] ^ sync_b[1];
endmodule
