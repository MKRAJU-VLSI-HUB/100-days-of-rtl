//==============================================================================
// Project     : 100 Days of RTL Design - Day 59 / 100
// Design      : Traffic Light Controller
// File        : traffic_light.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Main road and side road with sensor, timed phases, never two greens
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// Traffic light controller for a main road and a side road.
// Main road stays green until a car is waiting on the side road (and the
// minimum green time has passed). Each phase has its own duration, counted
// in clock ticks: GREEN_T, YELLOW_T, SIDE_GREEN_T.
// Light encoding: 2'b00 red, 2'b01 yellow, 2'b10 green.
module traffic_light #(
    parameter GREEN_T      = 10,
    parameter YELLOW_T     = 3,
    parameter SIDE_GREEN_T = 6
) (
    input            clk,
    input            rst,
    input            side_car,     // sensor on the side road
    output reg [1:0] main_light,
    output reg [1:0] side_light
);
    localparam RED = 2'b00, YEL = 2'b01, GRN = 2'b10;
    localparam MAIN_G = 2'd0, MAIN_Y = 2'd1, SIDE_G = 2'd2, SIDE_Y = 2'd3;

    reg [1:0] state;
    reg [7:0] timer;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= MAIN_G;
            timer <= 8'd0;
        end else begin
            timer <= timer + 1'b1;
            case (state)
                MAIN_G: if (timer >= GREEN_T - 1 && side_car) begin state <= MAIN_Y; timer <= 0; end
                MAIN_Y: if (timer == YELLOW_T - 1)            begin state <= SIDE_G; timer <= 0; end
                SIDE_G: if (timer == SIDE_GREEN_T - 1)        begin state <= SIDE_Y; timer <= 0; end
                SIDE_Y: if (timer == YELLOW_T - 1)            begin state <= MAIN_G; timer <= 0; end
            endcase
            if (state == MAIN_G && timer >= GREEN_T - 1 && !side_car) timer <= timer;  // hold
        end
    end

    always @(*) begin
        case (state)
            MAIN_G: begin main_light = GRN; side_light = RED; end
            MAIN_Y: begin main_light = YEL; side_light = RED; end
            SIDE_G: begin main_light = RED; side_light = GRN; end
            default: begin main_light = RED; side_light = YEL; end
        endcase
    end
endmodule
