//==============================================================================
// Project     : 100 Days of RTL Design - Day 24 / 100
// Design      : 8-bit ALU
// File        : alu.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : 16 operations (arithmetic, logic, shifts, multiply, divide) with tri-state output
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 8-bit ALU with 16 operations and a tri-state output (oe).
module alu (
    input  [7:0]  a_in, b_in,
    input  [3:0]  command_in,
    input         oe,
    output [15:0] d_out
);
    parameter ADD  = 4'b0000,  // a + b
              INC  = 4'b0001,  // a + 1
              SUB  = 4'b0010,  // a - b
              DEC  = 4'b0011,  // a - 1
              MUL  = 4'b0100,  // a * b (16-bit result)
              DIV  = 4'b0101,  // a / b
              SHL  = 4'b0110,  // a << 1
              SHR  = 4'b0111,  // a >> 1
              AND  = 4'b1000,
              OR   = 4'b1001,
              INV  = 4'b1010,  // ~a
              NAND = 4'b1011,
              NOR  = 4'b1100,
              XOR  = 4'b1101,
              XNOR = 4'b1110,
              BUF  = 4'b1111;  // pass a

    reg [15:0] out;

    always @(*) begin
        case (command_in)
            ADD : out = a_in + b_in;
            INC : out = a_in + 1;
            SUB : out = a_in - b_in;
            DEC : out = a_in - 1;
            MUL : out = a_in * b_in;
            DIV : out = (b_in != 0) ? a_in / b_in : 16'hFFFF;  // divide-by-zero guard
            SHL : out = a_in << 1;
            SHR : out = a_in >> 1;
            AND : out = a_in & b_in;
            OR  : out = a_in | b_in;
            INV : out = ~a_in;
            NAND: out = ~(a_in & b_in);
            NOR : out = ~(a_in | b_in);
            XOR : out = a_in ^ b_in;
            XNOR: out = ~(a_in ^ b_in);
            BUF : out = a_in;
            default: out = 16'h0000;
        endcase
    end

    assign d_out = oe ? out : 16'hzzzz;
endmodule
