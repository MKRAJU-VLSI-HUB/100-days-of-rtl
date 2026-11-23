//==============================================================================
// Project     : 100 Days of RTL Design - Day 67 / 100
// Design      : LIFO Stack
// File        : lifo_stack.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : 8-deep stack with push, pop, full and empty
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 8-deep x 8-bit LIFO (stack) with push, pop, full and empty.
// top shows the value that the next pop will return.
// Push and pop in the same cycle replaces the top entry.
module lifo_stack (
    input        clk,
    input        rst,
    input        push,
    input        pop,
    input  [7:0] din,
    output [7:0] top,
    output       full,
    output       empty,
    output [3:0] depth
);
    reg [7:0] mem [0:7];
    reg [3:0] sp;          // number of items on the stack

    assign empty = (sp == 4'd0);
    assign full  = (sp == 4'd8);
    assign depth = sp;
    assign top   = empty ? 8'h00 : mem[sp - 1'b1];

    always @(posedge clk or posedge rst) begin
        if (rst) sp <= 4'd0;
        else if (push && pop && !empty) mem[sp - 1'b1] <= din;     // replace top
        else if (push && !full) begin
            mem[sp[2:0]] <= din;
            sp <= sp + 1'b1;
        end else if (pop && !empty)
            sp <= sp - 1'b1;
    end
endmodule
