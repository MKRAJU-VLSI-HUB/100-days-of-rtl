//==============================================================================
// Project     : 100 Days of RTL Design - Day 63 / 100
// Design      : Dual-Port RAM
// File        : sync_dual_port_ram.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : 16 x 8 synchronous RAM with independent read and write ports
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 16 x 8 synchronous simple dual-port RAM: one write port and one read
// port, both on the same clock. The read data appears one clock after the
// address (registered output, like FPGA block RAM). Reading an address in
// the same cycle it is written returns the old data (read-first).
module sync_dual_port_ram (
    input            clk,
    input            wr_en,
    input            rd_en,
    input      [3:0] wr_addr,
    input      [3:0] rd_addr,
    input      [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] mem [0:15];

    always @(posedge clk) begin
        if (wr_en) mem[wr_addr] <= data_in;
    end

    always @(posedge clk) begin
        if (rd_en) data_out <= mem[rd_addr];
    end
endmodule
