//==============================================================================
// Project     : 100 Days of RTL Design - Day 79 / 100
// Design      : Fixed Priority Arbiter
// File        : priority_arbiter.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : One-hot grant using the req & ~(req - 1) trick
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 4-requester fixed priority arbiter. req[0] has the highest priority.
// The grant is one-hot. The trick: req & ~(req - 1) isolates the lowest
// set bit, which is exactly the highest-priority active request.
// A registered version holds the grant until the owner drops its request
// (no pre-emption in the middle of a transfer).
module priority_arbiter (
    input            clk,
    input            rst,
    input      [3:0] req,
    output     [3:0] grant_comb,    // combinational, changes immediately
    output reg [3:0] grant          // registered, holds until released
);
    assign grant_comb = req & ~(req - 4'd1);

    always @(posedge clk or posedge rst) begin
        if (rst)                         grant <= 4'b0000;
        else if (grant == 0 || !(grant & req))
                                         grant <= grant_comb;   // free: pick a new owner
        // else keep the current owner
    end
endmodule
