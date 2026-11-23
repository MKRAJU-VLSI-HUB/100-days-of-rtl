//==============================================================================
// Project     : 100 Days of RTL Design - Day 90 / 100
// Design      : Valid/Ready Skid Buffer
// File        : skid_buffer.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Streaming pipeline stage that never drops or duplicates data
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// Valid/ready skid buffer (a 2-entry pipeline register).
// Registers both the data path and the ready path, which breaks long
// timing paths in streaming designs (AXI-Stream style), while still
// moving one word per clock when nothing stalls. When the output stalls,
// the word already in flight "skids" into the spare register instead of
// being lost. in_ready is simply "the skid register is empty".
module skid_buffer #(
    parameter W = 8
) (
    input              clk,
    input              rst,
    // upstream
    input              in_valid,
    output reg         in_ready,
    input      [W-1:0] in_data,
    // downstream
    output reg         out_valid,
    input              out_ready,
    output reg [W-1:0] out_data
);
    reg [W-1:0] skid_data;
    reg         skid_valid;

    wire accept   = in_valid && in_ready;        // word taken from upstream this cycle
    wire out_load = !out_valid || out_ready;     // output register free this cycle

    // skid register state for the next cycle
    wire skid_next = out_load ? 1'b0 : (skid_valid || accept);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            in_ready <= 1'b1; out_valid <= 1'b0; skid_valid <= 1'b0;
            out_data <= 0; skid_data <= 0;
        end else begin
            if (out_load) begin
                if (skid_valid) begin             // drain the skid register first
                    out_data  <= skid_data;
                    out_valid <= 1'b1;
                end else begin
                    out_data  <= in_data;
                    out_valid <= accept;
                end
            end else if (accept) begin
                skid_data <= in_data;             // output stalled: catch the word
            end
            skid_valid <= skid_next;
            in_ready   <= !skid_next;
        end
    end
endmodule
