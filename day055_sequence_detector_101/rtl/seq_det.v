//==============================================================================
// Project     : 100 Days of RTL Design - Day 55 / 100
// Design      : 101 Sequence Detector
// File        : seq_det.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Moore FSM with overlap detecting the pattern 101
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// "101" sequence detector, Moore machine, overlapping.
// det_o goes high for one clock after the last 1 of each 101.
module seq_det (seq_in, clock, reset, det_o);
    parameter IDLE   = 2'b00,   // nothing useful yet
              STATE1 = 2'b01,   // seen 1
              STATE2 = 2'b10,   // seen 10
              STATE3 = 2'b11;   // seen 101 -> output 1

    input  seq_in, clock, reset;
    output det_o;

    reg [1:0] state, next_state;

    // present state register, active-high asynchronous reset
    always @(posedge clock, posedge reset) begin
        if (reset) state <= IDLE;
        else       state <= next_state;
    end

    // next state logic
    always @(state, seq_in) begin
        case (state)
            IDLE   : next_state = seq_in ? STATE1 : IDLE;
            STATE1 : next_state = seq_in ? STATE1 : STATE2;
            STATE2 : next_state = seq_in ? STATE3 : IDLE;
            STATE3 : next_state = seq_in ? STATE1 : STATE2;   // overlap: the last 1 can start a new 101
            default: next_state = IDLE;
        endcase
    end

    // Moore output
    assign det_o = (state == STATE3);
endmodule
