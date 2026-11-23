//==============================================================================
// Project     : 100 Days of RTL Design - Day 58 / 100
// Design      : Vending Machine
// File        : vending_machine_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Vending Machine
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module vending_machine_tb;
    reg clk = 0, reset = 1, I = 0, J = 0;
    wire X, Y;
    integer i, money = 0, errors = 0, products = 0, changes = 0, coins_in = 0;
    integer coin;

    vending_machine dut (.clk(clk), .reset(reset), .I(I), .J(J), .X(X), .Y(Y));

    always #5 clk = ~clk;

    initial begin
        @(posedge clk); #1 reset = 0;
        for (i = 0; i < 500; i = i + 1) begin
            @(negedge clk);
            // check outputs for the current state (model money)
            if (X !== (money >= 3) || Y !== (money == 4)) errors = errors + 1;
            if (X) products = products + 1;
            if (Y) changes  = changes + 1;
            coin = $random & 3;               // 0,1 = Rs1 / Rs2 / none mix
            {I, J} = (coin == 0) ? 2'b00 : (coin == 1) ? 2'b10 : (coin == 2) ? 2'b11 : 2'b01;
            @(posedge clk);
            if (money >= 3) money = 0;        // delivery state: coins ignored
            else begin
                if (I && !J) begin money = money + 1; coins_in = coins_in + 1; end
                if (I &&  J) begin money = money + 2; coins_in = coins_in + 2; end
            end
        end
        $display("Vending machine: 500 clocks of random coins (Rs %0d inserted)", coins_in);
        $display("  products dispensed: %0d, change returned: %0d times", products, changes);
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
