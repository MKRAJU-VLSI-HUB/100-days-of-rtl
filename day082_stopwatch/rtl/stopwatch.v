//==============================================================================
// Project     : 100 Days of RTL Design - Day 82 / 100
// Design      : Stopwatch
// File        : stopwatch.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Start/stop, lap and clear, counts to hundredths of a second
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// Stopwatch with start/stop (one button), lap and clear.
// Counts minutes:seconds.hundredths up to 59:59.99.
// 'lap' freezes the display while the counter keeps running; pressing
// lap again returns to the live time. Buttons are one-clock pulses.
module stopwatch #(
    parameter TICK_DIV = 2       // clk cycles per 1/100 s
) (
    input            clk,
    input            rst,
    input            start_stop,
    input            lap,
    input            clear,
    output     [5:0] disp_min,
    output     [5:0] disp_sec,
    output     [6:0] disp_cs,
    output reg       running
);
    reg [5:0] min, sec;
    reg [6:0] cs;
    reg [5:0] l_min, l_sec;
    reg [6:0] l_cs;
    reg       lap_hold;
    reg [$clog2(TICK_DIV+1)-1:0] pre;
    wire tick = running && (pre == TICK_DIV - 1);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            running <= 0; lap_hold <= 0; pre <= 0;
            min <= 0; sec <= 0; cs <= 0; l_min <= 0; l_sec <= 0; l_cs <= 0;
        end else begin
            if (start_stop) running <= ~running;
            if (lap) begin
                lap_hold <= ~lap_hold;
                l_min <= min; l_sec <= sec; l_cs <= cs;
            end
            if (clear && !running) begin
                min <= 0; sec <= 0; cs <= 0; lap_hold <= 0; pre <= 0;
            end else if (running) begin
                pre <= tick ? 0 : pre + 1'b1;
                if (tick) begin
                    if (cs != 99) cs <= cs + 1'b1;
                    else begin
                        cs <= 0;
                        if (sec != 59) sec <= sec + 1'b1;
                        else begin
                            sec <= 0;
                            min <= (min == 59) ? 0 : min + 1'b1;
                        end
                    end
                end
            end
        end
    end

    assign disp_min = lap_hold ? l_min : min;
    assign disp_sec = lap_hold ? l_sec : sec;
    assign disp_cs  = lap_hold ? l_cs  : cs;
endmodule
