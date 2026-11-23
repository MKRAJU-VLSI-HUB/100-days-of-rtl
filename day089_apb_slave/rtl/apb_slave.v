//==============================================================================
// Project     : 100 Days of RTL Design - Day 89 / 100
// Design      : APB Slave
// File        : apb_slave.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : AMBA APB3 register block with wait states and error response
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// AMBA APB3 slave with four 32-bit registers.
//   0x00 CTRL    read/write
//   0x04 DATA    read/write
//   0x08 STATUS  read only  (write -> PSLVERR)
//   0x0C COUNT   read only, counts completed writes
// Any other address returns PSLVERR. The slave adds one wait state to
// reads (PREADY low for one cycle) to show how wait states work.
module apb_slave (
    input             pclk,
    input             presetn,
    input             psel,
    input             penable,
    input             pwrite,
    input      [7:0]  paddr,
    input      [31:0] pwdata,
    output reg [31:0] prdata,
    output            pready,
    output            pslverr
);
    reg [31:0] ctrl, data, count;
    wire [31:0] status = {16'hA5A5, 8'h00, ctrl[7:0] ^ data[7:0]};
    reg        wait_done;

    wire access   = psel && penable;
    wire valid    = (paddr == 8'h00) || (paddr == 8'h04) || (paddr == 8'h08) || (paddr == 8'h0C);
    wire ro_write = pwrite && (paddr == 8'h08 || paddr == 8'h0C);

    // one wait state for reads, none for writes
    assign pready  = pwrite ? 1'b1 : wait_done;
    assign pslverr = access && pready && (!valid || ro_write);

    always @(posedge pclk or negedge presetn) begin
        if (!presetn) wait_done <= 1'b0;
        else          wait_done <= access && !pwrite && !wait_done;
    end

    always @(posedge pclk or negedge presetn) begin
        if (!presetn) begin
            ctrl <= 0; data <= 0; count <= 0;
        end else if (access && pready && pwrite && valid && !ro_write) begin
            case (paddr)
                8'h00: ctrl <= pwdata;
                8'h04: data <= pwdata;
            endcase
            count <= count + 1;
        end
    end

    always @(*) begin
        case (paddr)
            8'h00:   prdata = ctrl;
            8'h04:   prdata = data;
            8'h08:   prdata = status;
            8'h0C:   prdata = count;
            default: prdata = 32'h0;
        endcase
    end
endmodule
