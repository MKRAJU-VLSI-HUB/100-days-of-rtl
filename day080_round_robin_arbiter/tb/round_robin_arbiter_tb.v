//==============================================================================
// Project     : 100 Days of RTL Design - Day 80 / 100
// Design      : Round-Robin Arbiter
// File        : round_robin_arbiter_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Round-Robin Arbiter
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module round_robin_arbiter_tb;
    reg clk = 0, rst = 1;
    reg  [3:0] req = 0;
    wire [3:0] grant;
    integer i, k, errors = 0, last = 3, exp_idx, cand;
    integer wins [0:3], wait_cnt [0:3], max_wait = 0;

    round_robin_arbiter dut (.clk(clk), .rst(rst), .req(req), .grant(grant));

    always #5 clk = ~clk;

    initial begin
        for (k = 0; k < 4; k = k + 1) begin wins[k] = 0; wait_cnt[k] = 0; end
        @(posedge clk); #1 rst = 0;

        // all four requesting all the time: grants must rotate 0,1,2,3,0,...
        req = 4'b1111;
        $write("All requesting, grant order:");
        for (i = 0; i < 8; i = i + 1) begin
            @(posedge clk); #1;
            $write(" %0d", grant[0] ? 0 : grant[1] ? 1 : grant[2] ? 2 : 3);
            if (grant !== (4'b1 << (i % 4))) errors = errors + 1;
        end
        $display("");
        last = 3;   // grant 3 was the last in the sequence above

        // random requests: compare with a model and measure the longest wait
        for (i = 0; i < 1000; i = i + 1) begin
            @(negedge clk); req = $random;
            exp_idx = -1;
            for (k = 1; k <= 4; k = k + 1) begin
                cand = (last + k) % 4;
                if (exp_idx < 0 && req[cand]) exp_idx = cand;
            end
            @(posedge clk); #1;
            if (exp_idx < 0) begin
                if (grant !== 0) errors = errors + 1;
            end else begin
                if (grant !== (4'b1 << exp_idx)) errors = errors + 1;
                last = exp_idx;
                wins[exp_idx] = wins[exp_idx] + 1;
            end
            for (k = 0; k < 4; k = k + 1) begin
                if (req[k] && !grant[k]) wait_cnt[k] = wait_cnt[k] + 1; else wait_cnt[k] = 0;
                if (wait_cnt[k] > max_wait) max_wait = wait_cnt[k];
            end
        end
        $display("Round-robin arbiter: 1000 random cycles checked against a model");
        $display("  grants: req0 %0d, req1 %0d, req2 %0d, req3 %0d  (fair share)", wins[0], wins[1], wins[2], wins[3]);
        $display("  longest time a held request waited: %0d cycles", max_wait);
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
