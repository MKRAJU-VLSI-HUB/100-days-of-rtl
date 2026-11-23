//==============================================================================
// Project     : 100 Days of RTL Design - Day 42 / 100
// Design      : Mod-12 Counter
// File        : mod12_up_counter.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Counts 0 to 11 and wraps, with load
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// Mod-12 up counter (0..11) with load, the kind used for the hours of a clock
module mod12_up_counter (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       load,
    input  wire [3:0] load_data,
    output reg  [3:0] count
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)              count <= 4'd0;
        else if (load)           count <= (load_data > 4'd11) ? 4'd0 : load_data;
        else if (count == 4'd11) count <= 4'd0;
        else                     count <= count + 1'b1;
    end
endmodule
