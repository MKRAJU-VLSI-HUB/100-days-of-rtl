//==============================================================================
// Project     : 100 Days of RTL Design - Day 39 / 100
// Design      : Universal Shift Register
// File        : universal_shift_register_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Universal Shift Register
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module universal_shift_register_tb;
    reg        clk = 0, rst = 1, sr_in = 0, sl_in = 0;
    reg  [1:0] mode = 0;
    reg  [3:0] pin = 0, model = 0;
    wire [3:0] q;
    integer i, errors = 0;
    integer used [0:3];

    universal_shift_register dut (.clk(clk), .rst(rst), .mode(mode), .pin(pin),
                                  .sr_in(sr_in), .sl_in(sl_in), .q(q));

    always #5 clk = ~clk;

    initial begin
        used[0] = 0; used[1] = 0; used[2] = 0; used[3] = 0;
        #12 rst = 0;
        for (i = 0; i < 300; i = i + 1) begin
            @(negedge clk);
            mode = $random; pin = $random; sr_in = $random; sl_in = $random;
            used[mode] = used[mode] + 1;
            @(posedge clk);
            case (mode)
                2'b00: model = model;
                2'b01: model = {sr_in, model[3:1]};
                2'b10: model = {model[2:0], sl_in};
                2'b11: model = pin;
            endcase
            #1;
            if (q !== model) errors = errors + 1;
        end
        $display("Universal shift register: 300 random cycles");
        $display("  hold %0d, shift right %0d, shift left %0d, load %0d", used[0], used[1], used[2], used[3]);
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
