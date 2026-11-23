//==============================================================================
// Project     : 100 Days of RTL Design - Day 92 / 100
// Design      : Elevator Controller
// File        : elevator.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : 4-floor lift using the elevator algorithm, door and motion safety checks
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// 4-floor elevator controller.
// Requests (from inside the car or the floor buttons) are latched in
// req[3:0]. The car keeps moving in its current direction while there are
// requests ahead of it (the classic "elevator algorithm"), then reverses.
// Moving one floor takes MOVE_T clocks, the door stays open DOOR_T clocks.
module elevator #(
    parameter MOVE_T = 4,
    parameter DOOR_T = 3
) (
    input            clk,
    input            rst,
    input      [3:0] call,          // one-clock button pulses, one bit per floor
    output reg [1:0] floor,
    output reg       door_open,
    output reg       moving,
    output reg       dir_up,
    output reg [3:0] req
);
    localparam IDLE = 2'd0, MOVE = 2'd1, DOOR = 2'd2;
    reg [1:0] state;
    reg [3:0] t;

    wire [3:0] above = req & ~((4'b0010 << floor) - 4'd1);   // floors > current
    wire [3:0] below = req &  ((4'b0001 << floor) - 4'd1);   // floors < current
    wire       here  = req[floor];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE; floor <= 0; door_open <= 0; moving <= 0; dir_up <= 1; req <= 0; t <= 0;
        end else begin
            req <= req | call;
            case (state)
                IDLE: begin
                    door_open <= 0; moving <= 0;
                    if (here) begin
                        state <= DOOR; door_open <= 1; t <= 0;
                        req[floor] <= 1'b0;
                    end else if ((dir_up && above) || (!dir_up && !below && above)) begin
                        dir_up <= 1; state <= MOVE; moving <= 1; t <= 0;
                    end else if (below) begin
                        dir_up <= 0; state <= MOVE; moving <= 1; t <= 0;
                    end
                end
                MOVE: begin
                    if (t == MOVE_T - 1) begin
                        t <= 0; moving <= 0; state <= IDLE;
                        floor <= dir_up ? floor + 1'b1 : floor - 1'b1;
                    end else t <= t + 1'b1;
                end
                DOOR: begin
                    req[floor] <= 1'b0;                     // ignore calls for the open floor
                    if (t == DOOR_T - 1) begin door_open <= 0; state <= IDLE; t <= 0; end
                    else t <= t + 1'b1;
                end
            endcase
        end
    end
endmodule
