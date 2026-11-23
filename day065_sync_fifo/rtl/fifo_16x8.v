//==============================================================================
// Project     : 100 Days of RTL Design - Day 65 / 100
// Design      : Synchronous FIFO
// File        : fifo_16x8.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : 16 x 8 FIFO with full, empty and count using an extra pointer bit
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 16 x 8 synchronous FIFO.
// The read and write pointers have one extra bit (5 bits for 16 entries).
// Equal pointers mean empty; same index with different top bits means full.
// This way all 16 locations can be used.
module fifo_16x8 (
    input        clk,
    input        reset_n,     // async active-low reset
    input        write_in,
    input        read_in,
    input  [7:0] data_in,
    output [7:0] data_out,    // first-word fall-through: head of the FIFO
    output       full,
    output       empty,
    output [4:0] count
);
    reg [7:0] mem [0:15];
    reg [4:0] wr_ptr, rd_ptr;

    assign data_out = mem[rd_ptr[3:0]];
    assign empty    = (wr_ptr == rd_ptr);
    assign full     = (wr_ptr[3:0] == rd_ptr[3:0]) && (wr_ptr[4] != rd_ptr[4]);
    assign count    = wr_ptr - rd_ptr;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            wr_ptr <= 5'd0;
            rd_ptr <= 5'd0;
        end else begin
            if (write_in && !full) begin
                mem[wr_ptr[3:0]] <= data_in;
                wr_ptr <= wr_ptr + 1'b1;
            end
            if (read_in && !empty)
                rd_ptr <= rd_ptr + 1'b1;
        end
    end
endmodule
