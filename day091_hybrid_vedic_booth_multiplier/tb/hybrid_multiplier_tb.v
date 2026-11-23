//==============================================================================
// Project     : 100 Days of RTL Design - Day 91 / 100
// Design      : Hybrid Vedic + Booth Multiplier
// File        : hybrid_multiplier_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Hybrid Vedic + Booth Multiplier
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module hybrid_multiplier_tb;
    // 8-bit instance: checked exhaustively; 16-bit instance: random
    reg  [7:0]  a8, b8;
    reg  [1:0]  mode8;
    wire [15:0] p8;
    wire [1:0]  ch8;
    reg  [15:0] a16, b16;
    reg  [1:0]  mode16;
    wire [31:0] p16;
    wire [1:0]  ch16;
    integer i, m, errors = 0, n_vedic = 0, n_booth = 0;
    reg [31:0] exp;

    hybrid_multiplier #(8)  dut8  (.A(a8),  .B(b8),  .mode_in(mode8),  .final_result(p8),  .chosen_mode(ch8));
    hybrid_multiplier #(16) dut16 (.A(a16), .B(b16), .mode_in(mode16), .final_result(p16), .chosen_mode(ch16));

    initial begin
        // 8-bit: every operand pair in all three modes
        for (m = 0; m < 3; m = m + 1)
            for (i = 0; i < 65536; i = i + 1) begin
                {a8, b8} = i[15:0]; mode8 = m; #1;
                if (ch8 == 2'b10) exp = $signed(a8) * $signed(b8);
                else              exp = a8 * b8;
                if (p8 !== exp[15:0]) errors = errors + 1;
                if (m == 0) begin
                    if (ch8 !== ((!a8[7] && !b8[7]) ? 2'b01 : 2'b10)) errors = errors + 1;
                    if (ch8 == 2'b01) n_vedic = n_vedic + 1; else n_booth = n_booth + 1;
                end
            end
        // 16-bit: random pairs, auto mode, plus corner cases
        for (i = 0; i < 20000; i = i + 1) begin
            a16 = (i == 0) ? 16'h8000 : (i == 1) ? 16'h7FFF : $random;
            b16 = (i == 0) ? 16'h8000 : (i == 1) ? 16'h7FFF : $random;
            mode16 = 2'b00; #1;
            if (ch16 == 2'b10) exp = $signed(a16) * $signed(b16);
            else              exp = a16 * b16;
            if (p16 !== exp) errors = errors + 1;
        end
        a8 = 8'd25; b8 = 8'd12; mode8 = 0; #1;
        $display("auto mode: 25 x 12 = %0d via %s", p8, ch8 == 2'b01 ? "Vedic" : "Booth");
        a8 = -8'sd25; b8 = 8'd12; #1;
        $display("auto mode: -25 x 12 = %0d via %s", $signed(p8), ch8 == 2'b01 ? "Vedic" : "Booth");
        $display("8-bit: all 65536 pairs x 3 modes checked (auto picked Vedic %0d times, Booth %0d times)", n_vedic, n_booth);
        $display("16-bit: 20000 random pairs in auto mode checked, including -32768 x -32768");
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
