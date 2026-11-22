//==============================================================================
// Project     : 100 Days of RTL Design - Day 02
// File        : div_by_5_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Testbench for the divide-by-5 clock divider. Generates a
//               100 MHz clock (10 ns period) with a task, applies reset, and
//               measures the output period and high time.
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================
`timescale 1ns/1ps

module div_by_5_tb;

    reg  clk;
    reg  rst;
    wire clk_out;

    // DUT instantiation
    div_by_5 dut (
        .clk(clk),
        .rst(rst),
        .clk_out(clk_out)
    );

    // Clock generation task
    task gen_clk;
        begin
            clk = 0;
            forever #5 clk = ~clk;
        end
    endtask

    initial begin
        rst = 1;
        #10 rst = 0;
    end

    initial begin
        gen_clk;   // calling task
    end

    // Measure output period and high time
    realtime t_rise, t_fall, t_prev_rise;
    integer  periods = 0, errors = 0;

    always @(posedge clk_out) begin
        t_prev_rise = t_rise;
        t_rise      = $realtime;
        if (periods > 0 && (t_rise - t_prev_rise) != 50.0) begin
            errors = errors + 1;
            $display("ERROR: period = %0.1f ns, expected 50 ns", t_rise - t_prev_rise);
        end
        periods = periods + 1;
    end

    always @(negedge clk_out) begin
        t_fall = $realtime;
        if (periods > 0 && (t_fall - t_rise) != 20.0) begin
            errors = errors + 1;
            $display("ERROR: high time = %0.1f ns, expected 20 ns", t_fall - t_rise);
        end
    end

    initial begin
        #200;
        $display("--------------------------------------------");
        $display(" Divide-by-5: input clock 10 ns, output period 50 ns");
        $display(" High time 20 ns, low time 30 ns (40%% duty cycle)");
        $display(" Output periods observed: %0d", periods);
        if (errors == 0) $display(" RESULT: PASS (0 errors)");
        else             $display(" RESULT: FAIL (%0d errors)", errors);
        $display("--------------------------------------------");
        $finish;
    end

endmodule
