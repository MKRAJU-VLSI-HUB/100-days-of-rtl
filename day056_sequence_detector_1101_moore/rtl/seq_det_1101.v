//==============================================================================
// Project     : 100 Days of RTL Design - Day 56 / 100
// Design      : 1101 Detector (Moore vs Mealy)
// File        : seq_det_1101.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Both machine types side by side, Mealy reacts one clock earlier
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// "1101" sequence detector: Moore and Mealy versions side by side.
// Both allow overlap (1101101 contains two matches).
// The Mealy output comes one clock earlier because it depends on the input.
module seq_det_1101 (
    input  clk,
    input  rst,
    input  din,
    output moore_out,
    output mealy_out
);
    // ---------------- Moore: 5 states, output tied to state S4 ----------------
    localparam M0 = 3'd0, M1 = 3'd1, M11 = 3'd2, M110 = 3'd3, M1101 = 3'd4;
    reg [2:0] ms, ms_n;

    always @(posedge clk or posedge rst)
        if (rst) ms <= M0; else ms <= ms_n;

    always @(*) begin
        case (ms)
            M0   : ms_n = din ? M1    : M0;
            M1   : ms_n = din ? M11   : M0;
            M11  : ms_n = din ? M11   : M110;
            M110 : ms_n = din ? M1101 : M0;
            M1101: ms_n = din ? M11   : M0;     // the last 1 starts a new match
            default: ms_n = M0;
        endcase
    end
    assign moore_out = (ms == M1101);

    // ---------------- Mealy: 4 states, output on the transition ----------------
    localparam A0 = 2'd0, A1 = 2'd1, A11 = 2'd2, A110 = 2'd3;
    reg [1:0] as, as_n;

    always @(posedge clk or posedge rst)
        if (rst) as <= A0; else as <= as_n;

    always @(*) begin
        case (as)
            A0  : as_n = din ? A1  : A0;
            A1  : as_n = din ? A11 : A0;
            A11 : as_n = din ? A11 : A110;
            A110: as_n = din ? A1  : A0;
            default: as_n = A0;
        endcase
    end
    assign mealy_out = (as == A110) & din;
endmodule
