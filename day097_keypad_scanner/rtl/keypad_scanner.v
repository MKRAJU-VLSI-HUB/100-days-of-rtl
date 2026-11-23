//==============================================================================
// Project     : 100 Days of RTL Design - Day 97 / 100
// Design      : 4x4 Keypad Scanner
// File        : keypad_scanner.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Column scanning with debounce, one report per key press
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 4x4 matrix keypad scanner.
// Columns are driven low one at a time (active low); rows have pull-ups,
// so a pressed key pulls its row low while its column is selected.
// A key must be seen on SCAN_STABLE consecutive scans before it is
// reported (debounce). key_valid pulses once per press.
// Key codes: row * 4 + col  (layout 1 2 3 A / 4 5 6 B / 7 8 9 C / * 0 # D)
module keypad_scanner #(
    parameter COL_TIME    = 4,      // clocks each column is held low
    parameter SCAN_STABLE = 3
) (
    input            clk,
    input            rst,
    input      [3:0] row_n,         // from keypad, active low
    output reg [3:0] col_n,         // to keypad, active low
    output reg [3:0] key_code,
    output reg       key_valid,
    output reg       key_down
);
    reg [1:0] col;
    reg [7:0] t;
    reg       found;                // a key seen during this scan
    reg [3:0] found_code, last_code;
    reg [3:0] stable;

    function [1:0] row_idx(input [3:0] r);   // lowest active (low) row
        row_idx = !r[0] ? 2'd0 : !r[1] ? 2'd1 : !r[2] ? 2'd2 : 2'd3;
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            col <= 0; col_n <= 4'b1110; t <= 0; found <= 0; found_code <= 0;
            last_code <= 0; stable <= 0; key_code <= 0; key_valid <= 0; key_down <= 0;
        end else begin
            key_valid <= 0;
            if (t == COL_TIME - 1) begin
                t <= 0;
                // sample rows at the end of the column slot (lines have settled)
                if (row_n != 4'b1111 && !found) begin
                    found <= 1;
                    found_code <= {row_idx(row_n), col};
                end
                if (col == 2'd3) begin
                    // end of a full scan: debounce
                    if (found || (row_n != 4'b1111)) begin
                        if ((found ? found_code : {row_idx(row_n), col}) == last_code && stable != 0) begin
                            if (stable < SCAN_STABLE) stable <= stable + 1'b1;
                            if (stable == SCAN_STABLE - 1 && !key_down) begin
                                key_code <= last_code; key_valid <= 1; key_down <= 1;
                            end
                        end else begin
                            last_code <= found ? found_code : {row_idx(row_n), col};
                            stable <= 1;
                        end
                    end else begin
                        stable <= 0; key_down <= 0;
                    end
                    found <= 0;
                end
                col   <= col + 1'b1;
                col_n <= ~(4'b0001 << (col + 1'b1));
            end else t <= t + 1'b1;
        end
    end
endmodule
