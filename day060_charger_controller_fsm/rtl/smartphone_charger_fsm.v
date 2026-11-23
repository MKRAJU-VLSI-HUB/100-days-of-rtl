//==============================================================================
// Project     : 100 Days of RTL Design - Day 60 / 100
// Design      : Smartphone Charger Controller
// File        : smartphone_charger_fsm.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Charging timer with a safety cut-off after 60 us
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// Smartphone charger controller.
// IDLE     : white LED on, waiting for power and charger.
// CHARGING : green LED on; after 60 clocks (60 us at 1 MHz) the timer
//            expires and the charger moves to SAFETY.
// SAFETY   : charging stopped, white LED on, safety_mode = 1 until reset.
module smartphone_charger_fsm (
    input  wire power_on,
    input  wire charger,
    input  wire clock,
    input  wire reset,
    output reg  green,
    output reg  white,
    output wire safety_mode
);
    localparam IDLE = 2'b00, CHARGING = 2'b01, SAFETY = 2'b10;

    reg [1:0] state, next_state;
    reg [5:0] counter;   // 0..59

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            state   <= IDLE;
            counter <= 6'd0;
        end else begin
            state <= next_state;
            if (state == CHARGING && next_state == CHARGING) counter <= counter + 1'b1;
            else                                             counter <= 6'd0;
        end
    end

    assign safety_mode = (state == SAFETY);

    always @(*) begin
        next_state = state;
        green = 1'b0;
        white = 1'b1;
        case (state)
            IDLE: begin
                if (power_on && charger) next_state = CHARGING;
            end
            CHARGING: begin
                green = 1'b1;
                white = 1'b0;
                if (!power_on || !charger) next_state = IDLE;      // unplugged
                else if (counter == 6'd59) next_state = SAFETY;
            end
            SAFETY: ;   // stay until reset
            default: next_state = IDLE;
        endcase
    end
endmodule
