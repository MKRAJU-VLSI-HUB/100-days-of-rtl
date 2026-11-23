//==============================================================================
// Project     : 100 Days of RTL Design - Day 89 / 100
// Design      : APB Slave
// File        : apb_slave_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the APB Slave
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module apb_slave_tb;
    reg pclk = 0, presetn = 0, psel = 0, penable = 0, pwrite = 0;
    reg  [7:0]  paddr = 0;
    reg  [31:0] pwdata = 0;
    wire [31:0] prdata;
    wire pready, pslverr;
    reg  [31:0] rd, m_ctrl = 0, m_data = 0, m_count = 0;
    reg  err;
    integer i, errors = 0, waits;

    apb_slave dut (.pclk(pclk), .presetn(presetn), .psel(psel), .penable(penable), .pwrite(pwrite),
                   .paddr(paddr), .pwdata(pwdata), .prdata(prdata), .pready(pready), .pslverr(pslverr));

    always #5 pclk = ~pclk;

    // APB master: setup phase, then access phase until PREADY
    task apb_write(input [7:0] a, input [31:0] d, output e);
        begin
            @(negedge pclk); psel = 1; penable = 0; pwrite = 1; paddr = a; pwdata = d;
            @(negedge pclk); penable = 1; #1;
            while (!pready) begin @(negedge pclk); #1; end
            e = pslverr;
            @(posedge pclk); #1 psel = 0; penable = 0;
        end
    endtask

    task apb_read(input [7:0] a, output [31:0] d, output e);
        begin
            @(negedge pclk); psel = 1; penable = 0; pwrite = 0; paddr = a;
            @(negedge pclk); penable = 1; waits = 0; #1;
            while (!pready) begin @(negedge pclk); #1; waits = waits + 1; end
            d = prdata; e = pslverr;
            @(posedge pclk); #1 psel = 0; penable = 0;
        end
    endtask

    initial begin
        @(posedge pclk); #1 presetn = 1;
        apb_write(8'h00, 32'h0000_00F0, err); m_ctrl = 32'hF0; m_count = m_count + 1;
        apb_write(8'h04, 32'h1234_5678, err); m_data = 32'h12345678; m_count = m_count + 1;
        apb_read(8'h04, rd, err);
        $display("write DATA = 0x12345678, read back 0x%h (read took %0d wait state)", rd, waits);
        if (rd !== 32'h12345678 || waits != 1) errors = errors + 1;
        apb_read(8'h08, rd, err);
        $display("STATUS = 0x%h", rd);
        if (rd !== {16'hA5A5, 8'h00, 8'hF0 ^ 8'h78}) errors = errors + 1;
        apb_write(8'h08, 32'hDEAD, err);
        $display("write to read-only STATUS -> PSLVERR = %b", err);
        if (err !== 1'b1) errors = errors + 1;
        apb_read(8'h40, rd, err);
        $display("read unmapped address 0x40 -> PSLVERR = %b", err);
        if (err !== 1'b1) errors = errors + 1;

        // random traffic
        for (i = 0; i < 300; i = i + 1) begin
            if ($random & 1) begin
                pwdata = $random;
                case ($random & 1)
                    0: begin apb_write(8'h00, pwdata, err); m_ctrl = pwdata; end
                    1: begin apb_write(8'h04, pwdata, err); m_data = pwdata; end
                endcase
                m_count = m_count + 1;
                if (err) errors = errors + 1;
            end else begin
                case ($random & 3)
                    0: begin apb_read(8'h00, rd, err); if (rd !== m_ctrl)  errors = errors + 1; end
                    1: begin apb_read(8'h04, rd, err); if (rd !== m_data)  errors = errors + 1; end
                    2: begin apb_read(8'h0C, rd, err); if (rd !== m_count) errors = errors + 1; end
                    3: begin apb_read(8'h08, rd, err);
                             if (rd !== {16'hA5A5, 8'h00, m_ctrl[7:0] ^ m_data[7:0]}) errors = errors + 1; end
                endcase
            end
        end
        $display("APB slave: 300 random transfers, register model and write counter (%0d writes) checked", m_count);
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
