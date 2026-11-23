//==============================================================================
// Project     : 100 Days of RTL Design - Day 61 / 100
// Design      : Register File
// File        : reg_file.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : 8 x 8 with two read ports, one write port and write forwarding
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 8 x 8-bit register file with two read ports and one write port,
// the kind used in a CPU. Register 0 always reads as zero.
// Reads are combinational; the write happens on the clock edge.
// If a read and a write hit the same register in one cycle, the new data
// is forwarded to the read port (write-through).
module reg_file (
    input        clk,
    input        rst,
    input        we,
    input  [2:0] waddr,
    input  [7:0] wdata,
    input  [2:0] raddr_a,
    input  [2:0] raddr_b,
    output [7:0] rdata_a,
    output [7:0] rdata_b
);
    reg [7:0] regs [0:7];
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 8; i = i + 1) regs[i] <= 8'h00;
        end else if (we && waddr != 3'd0) begin
            regs[waddr] <= wdata;
        end
    end

    // read ports: r0 is hard-wired to zero, same-cycle write is forwarded
    assign rdata_a = (raddr_a == 3'd0)           ? 8'h00 :
                     (we && raddr_a == waddr)    ? wdata : regs[raddr_a];
    assign rdata_b = (raddr_b == 3'd0)           ? 8'h00 :
                     (we && raddr_b == waddr)    ? wdata : regs[raddr_b];
endmodule
