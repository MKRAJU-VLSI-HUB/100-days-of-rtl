//==============================================================================
// Project     : 100 Days of RTL Design - Day 62 / 100
// Design      : Single-Port RAM
// File        : ram.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : 16 x 8 asynchronous RAM with a bidirectional data bus
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 16 x 8 asynchronous single-port RAM with a bidirectional data bus.
// we_in = 1, enable_in = 0 : write the bus value into mem[addr_in]
// we_in = 0, enable_in = 1 : drive mem[addr_in] onto the bus
// otherwise                : bus released (high impedance)
module ram (
    input        we_in,
    input        enable_in,
    input  [3:0] addr_in,
    inout  [7:0] data
);
    reg [7:0] mem [15:0];

    always @(data, we_in, enable_in, addr_in)
        if (we_in && !enable_in)
            mem[addr_in] = data;

    assign data = (enable_in && !we_in) ? mem[addr_in] : 8'hzz;
endmodule
