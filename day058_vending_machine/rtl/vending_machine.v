//==============================================================================
// Project     : 100 Days of RTL Design - Day 58 / 100
// Design      : Vending Machine
// File        : vending_machine.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Accepts Rs 1 and Rs 2 coins, dispenses at Rs 3 and gives change
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// Vending machine FSM. Product costs Rs 3.
// Coins: I=1, J=0 -> Rs 1 ; I=1, J=1 -> Rs 2 ; I=0 -> no coin.
// X = 1 dispenses the product, Y = 1 returns Rs 1 change.
// Moore machine: outputs depend only on the state.
module vending_machine (
    input      clk,
    input      reset,    // sync active-high
    input      I,
    input      J,
    output reg X,
    output reg Y
);
    parameter S0 = 3'd0,   // Rs 0
              S1 = 3'd1,   // Rs 1
              S2 = 3'd2,   // Rs 2
              S3 = 3'd3,   // Rs 3 -> dispense
              S4 = 3'd4;   // Rs 4 -> dispense + change

    reg [2:0] state, next_state;

    wire [1:0] coin = (I && J)  ? 2'd2 :
                      (I && !J) ? 2'd1 : 2'd0;

    always @(posedge clk) begin
        if (reset) state <= S0;
        else       state <= next_state;
    end

    always @(*) begin
        X = 1'b0; Y = 1'b0;
        case (state)
            S3: X = 1'b1;
            S4: begin X = 1'b1; Y = 1'b1; end
            default: ;
        endcase
    end

    always @(*) begin
        case (state)
            S0: next_state = (coin == 2'd1) ? S1 : (coin == 2'd2) ? S2 : S0;
            S1: next_state = (coin == 2'd1) ? S2 : (coin == 2'd2) ? S3 : S1;
            S2: next_state = (coin == 2'd1) ? S3 : (coin == 2'd2) ? S4 : S2;
            S3, S4: next_state = S0;       // back to idle after delivery
            default: next_state = S0;
        endcase
    end
endmodule
