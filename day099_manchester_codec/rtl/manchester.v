//==============================================================================
// Project     : 100 Days of RTL Design - Day 99 / 100
// Design      : Manchester Encoder / Decoder
// File        : manchester.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-clocking line code with code error detection
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// Manchester encoder and decoder (IEEE 802.3 convention):
//   bit 0 -> high then low (falling edge in the middle of the bit)
//   bit 1 -> low then high (rising edge in the middle)
// Every bit has a transition, so the receiver can recover the clock from
// the data and the line has no DC component.
// The encoder uses 2 half-bit slots per data bit. The decoder samples the
// line OVS times per bit and looks for the mid-bit transition.
module manchester_enc #(parameter HALF = 4) (      // clocks per half bit
    input        clk,
    input        rst,
    input        start,
    input  [7:0] data,
    output reg   line,
    output reg   busy
);
    reg [7:0] sh;
    reg [3:0] nbit;
    reg       second;
    reg [7:0] t;

    always @(posedge clk or posedge rst) begin
        if (rst) begin line <= 0; busy <= 0; sh <= 0; nbit <= 0; second <= 0; t <= 0; end
        else if (!busy) begin
            line <= 0;
            if (start) begin
                busy <= 1; sh <= data; nbit <= 0; second <= 0; t <= 0;
                line <= ~data[7];                  // first half of the MSB
            end
        end else if (t == HALF - 1) begin
            t <= 0;
            if (!second) begin
                second <= 1;
                line   <= sh[7];                   // second half = bit value
            end else begin
                second <= 0;
                if (nbit == 4'd7) begin busy <= 0; line <= 0; end
                else begin
                    nbit <= nbit + 1'b1;
                    sh   <= {sh[6:0], 1'b0};
                    line <= ~sh[6];                // first half of the next bit
                end
            end
        end else t <= t + 1'b1;
    end
endmodule

module manchester_dec #(parameter HALF = 4) (
    input            clk,
    input            rst,
    input            line,
    input            frame_start,   // pulse at the start of a frame (from a preamble detector)
    output reg [7:0] data,
    output reg       valid,
    output reg       code_err       // no transition in the middle of a bit
);
    reg [7:0] sh;
    reg [3:0] nbit;
    reg [7:0] t;
    reg       first_half, busy;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data <= 0; valid <= 0; code_err <= 0; sh <= 0; nbit <= 0; t <= 0; first_half <= 0; busy <= 0;
        end else begin
            valid <= 0;
            if (frame_start) begin
                busy <= 1; nbit <= 0; t <= 0; code_err <= 0;
            end else if (busy) begin
                t <= t + 1'b1;
                if (t == HALF / 2)            first_half <= line;          // middle of first half
                if (t == HALF + HALF / 2) begin                            // middle of second half
                    if (line == first_half) code_err <= 1;
                    sh <= {sh[6:0], line};
                end
                if (t == 2 * HALF - 1) begin
                    t <= 0;
                    if (nbit == 4'd7) begin
                        busy <= 0; valid <= 1; data <= sh;
                    end else nbit <= nbit + 1'b1;
                end
            end
        end
    end
endmodule
