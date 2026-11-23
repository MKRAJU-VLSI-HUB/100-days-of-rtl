//==============================================================================
// Project     : 100 Days of RTL Design - Day 57 / 100
// Design      : Pattern Detector 000111000
// File        : pattern_detector_fsm.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : 10-state FSM for a 9-bit pattern with overlap
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// Pattern detector for the 9-bit pattern 000111000 (overlap allowed).
// S1..S3 count the leading zeros, S4..S6 the ones, S7..S9 the trailing
// zeros. The trailing 000 can also be the start of the next pattern.
// 'detected' is registered, so it goes high one clock after S9 is reached.
module pattern_detector_fsm (
    input  wire clk,
    input  wire rst_n,
    input  wire in_bit,
    output reg  detected
);
    localparam S0 = 4'd0, S1 = 4'd1, S2 = 4'd2, S3 = 4'd3, S4 = 4'd4,
               S5 = 4'd5, S6 = 4'd6, S7 = 4'd7, S8 = 4'd8, S9 = 4'd9;

    reg [3:0] state, next_state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) state <= S0;
        else        state <= next_state;
    end

    always @(*) begin
        case (state)
            S0: next_state = (in_bit == 1'b0) ? S1 : S0;
            S1: next_state = (in_bit == 1'b0) ? S2 : S0;
            S2: next_state = (in_bit == 1'b0) ? S3 : S0;
            S3: next_state = (in_bit == 1'b0) ? S3 : S4;   // extra zeros keep us in S3
            S4: next_state = (in_bit == 1'b0) ? S1 : S5;
            S5: next_state = (in_bit == 1'b0) ? S1 : S6;
            S6: next_state = (in_bit == 1'b0) ? S7 : S0;
            S7: next_state = (in_bit == 1'b0) ? S8 : S0;
            S8: next_state = (in_bit == 1'b0) ? S9 : S0;
            S9: next_state = (in_bit == 1'b0) ? S3 : S4;   // overlap
            default: next_state = S0;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) detected <= 1'b0;
        else        detected <= (state == S9);
    end
endmodule
