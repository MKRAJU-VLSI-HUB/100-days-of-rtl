//==============================================================================
// Project     : 100 Days of RTL Design - Day 69 / 100
// Design      : Memory BIST (March C-)
// File        : mbist_march.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-test engine that finds and locates stuck-at faults in a RAM
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// Memory built-in self-test (MBIST) running the March C- algorithm on a
// 16 x 8 RAM. March C- has 6 elements:
//   1: up   (w0)        2: up   (r0, w1)     3: up   (r1, w0)
//   4: down (r0, w1)    5: down (r1, w0)     6: down (r0)
// It finds stuck-at, transition and most coupling faults.
// A fault can be injected into the RAM model for testing the BIST itself.
module ram16x8_faulty (
    input        clk,
    input        we,
    input  [3:0] addr,
    input  [7:0] wdata,
    output [7:0] rdata,
    input        inject,           // enable a stuck-at fault
    input  [3:0] f_addr,
    input  [2:0] f_bit,
    input        f_val
);
    reg [7:0] mem [0:15];
    always @(posedge clk) if (we) mem[addr] <= wdata;
    wire [7:0] raw = mem[addr];
    assign rdata = (inject && addr == f_addr) ? (f_val ? raw | (8'h1 << f_bit) : raw & ~(8'h1 << f_bit)) : raw;
endmodule

module mbist_march (
    input            clk,
    input            rst,
    input            start,
    output reg       done,
    output reg       fail,
    output reg [3:0] fail_addr,
    // RAM interface
    output reg       we,
    output reg [3:0] addr,
    output reg [7:0] wdata,
    input      [7:0] rdata
);
    localparam IDLE = 0, RUN = 1, FIN = 2;
    reg [1:0] st;
    reg [2:0] elem;        // march element 1..6
    reg       phase;       // 0 = first op (read or write), 1 = second op
    reg [4:0] idx;         // 0..15 position within the element

    wire       down   = (elem >= 3'd4);
    wire [3:0] a      = down ? (4'd15 - idx[3:0]) : idx[3:0];

    // expected read value and value to write for each element
    reg  [7:0] exp_r, w_val;
    reg        has_read, has_write;
    always @(*) begin
        has_read = 1; has_write = 1; exp_r = 8'h00; w_val = 8'h00;
        case (elem)
            3'd1: begin has_read = 0; w_val = 8'h00; end
            3'd2: begin exp_r = 8'h00; w_val = 8'hFF; end
            3'd3: begin exp_r = 8'hFF; w_val = 8'h00; end
            3'd4: begin exp_r = 8'h00; w_val = 8'hFF; end
            3'd5: begin exp_r = 8'hFF; w_val = 8'h00; end
            3'd6: begin exp_r = 8'h00; has_write = 0; end
        endcase
    end

    // drive the RAM
    always @(*) begin
        addr  = a;
        wdata = w_val;
        we    = (st == RUN) && has_write && (has_read ? phase : 1'b1);
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            st <= IDLE; done <= 0; fail <= 0; fail_addr <= 0;
            elem <= 3'd1; phase <= 0; idx <= 0;
        end else case (st)
            IDLE: if (start) begin
                st <= RUN; done <= 0; fail <= 0; elem <= 3'd1; phase <= 0; idx <= 0;
            end
            RUN: begin
                // compare on the read phase
                if (has_read && !phase && rdata !== exp_r && !fail) begin
                    fail <= 1; fail_addr <= a;
                end
                if (has_read && has_write && !phase) phase <= 1;
                else begin
                    phase <= 0;
                    if (idx == 5'd15) begin
                        idx <= 0;
                        if (elem == 3'd6) st <= FIN;
                        else              elem <= elem + 1'b1;
                    end else idx <= idx + 1'b1;
                end
            end
            FIN: begin done <= 1; st <= IDLE; end
        endcase
    end
endmodule
