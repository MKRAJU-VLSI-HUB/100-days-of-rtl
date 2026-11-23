//==============================================================================
// Project     : 100 Days of RTL Design - Day 83 / 100
// Design      : Watchdog Timer
// File        : watchdog.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Resets the system if software stops kicking it, with early warning
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// Watchdog timer. Software must 'kick' the watchdog before the counter
// reaches TIMEOUT, otherwise the watchdog asserts a reset pulse.
// A warning interrupt fires at TIMEOUT/2 so software gets a last chance.
// The watchdog can only be enabled once (it cannot be switched off by
// runaway code), which is how real watchdogs are designed.
module watchdog #(
    parameter TIMEOUT   = 100,
    parameter RST_PULSE = 4
) (
    input      clk,
    input      rst,
    input      enable,
    input      kick,
    output reg warn_irq,
    output reg wdt_reset
);
    reg        armed;
    reg [15:0] cnt;
    reg [3:0]  pulse;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            armed <= 0; cnt <= 0; warn_irq <= 0; wdt_reset <= 0; pulse <= 0;
        end else begin
            if (enable) armed <= 1'b1;            // sticky
            warn_irq <= 1'b0;
            if (pulse != 0) begin                 // reset pulse in progress
                pulse     <= pulse - 1'b1;
                wdt_reset <= (pulse != 1);
                cnt       <= 0;
            end else if (!armed || kick) begin
                cnt <= 0;
            end else begin
                cnt <= cnt + 1'b1;
                if (cnt == TIMEOUT / 2 - 1) warn_irq <= 1'b1;
                if (cnt == TIMEOUT - 1) begin
                    wdt_reset <= 1'b1;
                    pulse     <= RST_PULSE;
                end
            end
        end
    end
endmodule
