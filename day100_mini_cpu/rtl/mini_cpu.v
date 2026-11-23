//==============================================================================
// Project     : 100 Days of RTL Design - Day 100 / 100
// Design      : Mini 8-bit CPU
// File        : mini_cpu.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Single-cycle CPU with 14 instructions running a Fibonacci program
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// Mini 8-bit single-cycle CPU.
// 8 registers (r0 is always 0), 16-bit instructions, 256-word program ROM
// loaded from program.mem, an 8-bit output port.
//
// Instruction format
//   R-type : [15:12] opcode | [11:9] rd | [8:6] rs1 | [5:3] rs2 | [2:0] unused
//   I-type : [15:12] opcode | [11:9] rd | [8] unused | [7:0] imm8
//
// Opcode  Mnemonic          Operation
//   0     NOP
//   1     ADD  rd,rs1,rs2   rd = rs1 + rs2
//   2     SUB  rd,rs1,rs2   rd = rs1 - rs2
//   3     AND  rd,rs1,rs2   rd = rs1 & rs2
//   4     OR   rd,rs1,rs2   rd = rs1 | rs2
//   5     XOR  rd,rs1,rs2   rd = rs1 ^ rs2
//   6     SHL  rd,rs1       rd = rs1 << 1
//   7     SHR  rd,rs1       rd = rs1 >> 1
//   8     LDI  rd,imm       rd = imm
//   9     ADDI rd,imm       rd = rd + imm
//   A     JNZ  rd,addr      if (rd != 0) pc = addr
//   B     JMP  addr         pc = addr
//   C     OUT  rd           out_port = rd
//   D     HALT              stop

module pc (
    input            clk,
    input            rst,
    input            en,
    input      [7:0] pc_in,
    output reg [7:0] pc_out
);
    always @(posedge clk or posedge rst) begin
        if (rst)     pc_out <= 8'd0;
        else if (en) pc_out <= pc_in;
    end
endmodule

module inst_mem #(parameter PROGRAM = "program.mem") (
    input  [7:0]  addr,
    output [15:0] instruction
);
    reg [15:0] memory [0:255];
    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) memory[i] = 16'h0000;
        $readmemh(PROGRAM, memory);
    end
    assign instruction = memory[addr];
endmodule

module control_unit (
    input      [3:0] opcode,
    output reg       reg_write,
    output reg       use_imm,      // ALU B input = immediate
    output reg       imm_only,     // result = immediate (LDI)
    output reg [2:0] alu_op,
    output reg       is_jnz,
    output reg       is_jmp,
    output reg       is_out,
    output reg       is_halt
);
    always @(*) begin
        reg_write = 0; use_imm = 0; imm_only = 0; alu_op = 3'b000;
        is_jnz = 0; is_jmp = 0; is_out = 0; is_halt = 0;
        case (opcode)
            4'h1: begin reg_write = 1; alu_op = 3'b000; end      // ADD
            4'h2: begin reg_write = 1; alu_op = 3'b001; end      // SUB
            4'h3: begin reg_write = 1; alu_op = 3'b010; end      // AND
            4'h4: begin reg_write = 1; alu_op = 3'b011; end      // OR
            4'h5: begin reg_write = 1; alu_op = 3'b100; end      // XOR
            4'h6: begin reg_write = 1; alu_op = 3'b110; end      // SHL
            4'h7: begin reg_write = 1; alu_op = 3'b111; end      // SHR
            4'h8: begin reg_write = 1; imm_only = 1; end         // LDI
            4'h9: begin reg_write = 1; use_imm = 1; alu_op = 3'b000; end   // ADDI
            4'hA: is_jnz  = 1;
            4'hB: is_jmp  = 1;
            4'hC: is_out  = 1;
            4'hD: is_halt = 1;
            default: ;                                            // NOP
        endcase
    end
endmodule

module alu (
    input      [7:0] A, B,
    input      [2:0] ALU_Op,
    output reg [7:0] Result
);
    always @(*) begin
        case (ALU_Op)
            3'b000: Result = A + B;
            3'b001: Result = A - B;
            3'b010: Result = A & B;
            3'b011: Result = A | B;
            3'b100: Result = A ^ B;
            3'b101: Result = ~A;
            3'b110: Result = A << 1;
            3'b111: Result = A >> 1;
        endcase
    end
endmodule

module reg_file (
    input            clk,
    input            rst,
    input      [2:0] rs1, rs2, rd,
    input      [7:0] wr_data,
    input            reg_write,
    output     [7:0] rd1, rd2, rd_val
);
    reg [7:0] registers [0:7];
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst)
            for (i = 0; i < 8; i = i + 1) registers[i] <= 8'h00;   // clear every register
        else if (reg_write && rd != 3'd0)
            registers[rd] <= wr_data;
    end

    assign rd1    = (rs1 == 0) ? 8'h00 : registers[rs1];
    assign rd2    = (rs2 == 0) ? 8'h00 : registers[rs2];
    assign rd_val = (rd  == 0) ? 8'h00 : registers[rd];
endmodule

module toplevel #(parameter PROGRAM = "program.mem") (
    input            clk,
    input            rst,
    output     [7:0] pc_out,
    output     [7:0] alu_result,
    output reg [7:0] out_port,
    output reg       out_valid,
    output reg       halted
);
    wire [15:0] instruction;
    wire [3:0]  opcode = instruction[15:12];
    wire [2:0]  rd     = instruction[11:9];
    wire [2:0]  rs1    = instruction[8:6];
    wire [2:0]  rs2    = instruction[5:3];
    wire [7:0]  imm    = instruction[7:0];

    wire reg_write, use_imm, imm_only, is_jnz, is_jmp, is_out, is_halt;
    wire [2:0] alu_op;
    wire [7:0] rd1, rd2, rd_val, wr_data, pc_next;

    pc PC (.clk(clk), .rst(rst), .en(!halted && !is_halt), .pc_in(pc_next), .pc_out(pc_out));

    inst_mem #(PROGRAM) INST_MEM (.addr(pc_out), .instruction(instruction));

    control_unit CONTROL (.opcode(opcode), .reg_write(reg_write), .use_imm(use_imm), .imm_only(imm_only),
                          .alu_op(alu_op), .is_jnz(is_jnz), .is_jmp(is_jmp), .is_out(is_out), .is_halt(is_halt));

    // ADDI uses rd as both source and destination
    alu ALU (.A(use_imm ? rd_val : rd1), .B(use_imm ? imm : rd2), .ALU_Op(alu_op), .Result(alu_result));

    reg_file REG_FILE (.clk(clk), .rst(rst), .rs1(rs1), .rs2(rs2), .rd(rd), .wr_data(wr_data),
                       .reg_write(reg_write && !halted), .rd1(rd1), .rd2(rd2), .rd_val(rd_val));

    assign wr_data = imm_only ? imm : alu_result;

    assign pc_next = is_jmp                       ? imm :
                     (is_jnz && rd_val != 8'd0)   ? imm :
                     pc_out + 8'd1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out_port <= 8'h00; out_valid <= 1'b0; halted <= 1'b0;
        end else begin
            out_valid <= 1'b0;
            if (!halted) begin
                if (is_out)  begin out_port <= rd_val; out_valid <= 1'b1; end
                if (is_halt) halted <= 1'b1;
            end
        end
    end
endmodule
