//==============================================================================
// Project     : 100 Days of RTL Design - Day 79 / 100
// Design      : Fixed Priority Arbiter
// File        : priority_arbiter_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Fixed Priority Arbiter
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module priority_arbiter_tb;
    reg clk = 0, rst = 1;
    reg  [3:0] req = 0;
    wire [3:0] grant_comb, grant;
    reg  [3:0] model = 0, exp_c;
    integer i, k, errors = 0;
    integer wins [0:3];

    priority_arbiter dut (.clk(clk), .rst(rst), .req(req), .grant_comb(grant_comb), .grant(grant));

    always #5 clk = ~clk;

    initial begin
        for (k = 0; k < 4; k = k + 1) wins[k] = 0;
        // combinational part: all 16 request patterns
        for (i = 0; i < 16; i = i + 1) begin
            req = i; #1;
            exp_c = 0;
            for (k = 3; k >= 0; k = k - 1) if (req[k]) exp_c = 4'b1 << k;
            if (grant_comb !== exp_c) errors = errors + 1;
        end
        req = 0;
        @(posedge clk); #1 rst = 0;
        // registered part with random requests
        for (i = 0; i < 500; i = i + 1) begin
            @(negedge clk); req = $random; #1;
            exp_c = req & ~(req - 4'd1);
            @(posedge clk);
            if (model == 0 || !(model & req)) model = exp_c;
            #1;
            if (grant !== model) errors = errors + 1;
            if (grant & (grant - 4'd1)) errors = errors + 1;        // never more than one grant
            for (k = 0; k < 4; k = k + 1) if (grant[k]) wins[k] = wins[k] + 1;
        end
        $display("Fixed priority arbiter: 16 patterns + 500 random cycles");
        $display("  grants: req0 %0d, req1 %0d, req2 %0d, req3 %0d  (lower index wins more)",
                 wins[0], wins[1], wins[2], wins[3]);
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
