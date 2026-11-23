//==============================================================================
// Project     : 100 Days of RTL Design - Day 94 / 100
// Design      : CORDIC Sine / Cosine
// File        : cordic_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the CORDIC Sine / Cosine
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module cordic_tb;
    reg clk = 0, rst = 1, start = 0;
    reg  signed [15:0] angle = 0;
    wire signed [15:0] cos_out, sin_out;
    wire done;
    integer n, errors = 0, deg;
    real ang, ec, es, gc, gs, err, max_err = 0;

    cordic dut (.clk(clk), .rst(rst), .start(start), .angle(angle),
                             .cos_out(cos_out), .sin_out(sin_out), .done(done));

    always #5 clk = ~clk;

    task run(input real rad);
        begin
            @(negedge clk); angle = $rtoi(rad * 16384.0); start = 1;
            @(negedge clk); start = 0;
            while (!done) @(negedge clk);
            ang = angle / 16384.0;
            ec = $cos(ang); es = $sin(ang);
            gc = cos_out / 16384.0; gs = sin_out / 16384.0;
            err = (gc > ec) ? gc - ec : ec - gc;
            if (err > max_err) max_err = err;
            err = (gs > es) ? gs - es : es - gs;
            if (err > max_err) max_err = err;
        end
    endtask

    initial begin
        @(posedge clk); #1 rst = 0;
        $display(" angle |   cos (CORDIC / exact)  |   sin (CORDIC / exact)");
        for (deg = -90; deg <= 90; deg = deg + 30) begin
            run(deg * 3.14159265358979 / 180.0);
            $display(" %4d  |  %8.5f / %8.5f   |  %8.5f / %8.5f", deg, gc, ec, gs, es);
        end
        for (n = 0; n < 1000; n = n + 1) run(($random % 25735) / 16384.0);   // random in +/- pi/2
        $display("CORDIC: 1000 random angles in [-pi/2, pi/2], worst error = %0.6f (%0.1f LSB)", max_err, max_err * 16384.0);
        if (max_err < 0.00025) $display("RESULT: PASS (0 errors)");
        else                  $display("RESULT: FAIL (error too large)");
        $finish;
    end
endmodule
