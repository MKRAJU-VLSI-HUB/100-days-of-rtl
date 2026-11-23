//==============================================================================
// Project     : 100 Days of RTL Design - Day 31 / 100
// Design      : SR Latch and D Latch
// File        : latches.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Level-sensitive storage: cross-coupled NOR latch and gated D latch
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// SR latch (NOR based) and gated D latch.
// Latches are level sensitive: the output follows the input while enable is high.
module sr_latch (
    input  s, r,
    output q, qn
);
    // cross-coupled NOR gates
    assign q  = ~(r | qn);
    assign qn = ~(s | q);
endmodule

module d_latch (
    input      d, en,
    output reg q
);
    always @(*) begin
        if (en) q = d;   // transparent while en = 1, holds otherwise
    end
endmodule
