//==============================================================================
// Project     : 100 Days of RTL Design - Day 69 / 100
// Design      : Memory BIST (March C-)
// File        : mbist_march_tb.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Self-checking testbench for the Memory BIST (March C-)
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

module mbist_march_tb;
    reg clk = 0, rst = 1, start = 0;
    reg inject = 0, f_val = 0;
    reg [3:0] f_addr = 0;
    reg [2:0] f_bit = 0;
    wire done, fail, we;
    wire [3:0] fail_addr, addr;
    wire [7:0] wdata, rdata;
    integer t, errors = 0, caught = 0, cycles;

    mbist_march bist (.clk(clk), .rst(rst), .start(start), .done(done), .fail(fail), .fail_addr(fail_addr),
                      .we(we), .addr(addr), .wdata(wdata), .rdata(rdata));
    ram16x8_faulty ram (.clk(clk), .we(we), .addr(addr), .wdata(wdata), .rdata(rdata),
                        .inject(inject), .f_addr(f_addr), .f_bit(f_bit), .f_val(f_val));

    always #5 clk = ~clk;

    task run_bist;
        begin
            @(negedge clk); start = 1;
            @(negedge clk); start = 0;
            cycles = 1;
            while (!done) begin @(posedge clk); cycles = cycles + 1; end
            #1;
        end
    endtask

    initial begin
        @(posedge clk); #1 rst = 0;
        // fault-free memory must pass
        run_bist;
        $display("Fault-free RAM : fail = %b  (March C- took %0d clocks)", fail, cycles);
        if (fail) errors = errors + 1;

        // 32 random stuck-at faults must all be caught at the right address
        for (t = 0; t < 32; t = t + 1) begin
            inject = 1; f_addr = $random; f_bit = $random; f_val = t[0];
            run_bist;
            if (fail && fail_addr == f_addr) caught = caught + 1;
            else errors = errors + 1;
            if (t < 3) $display("Stuck-at-%0d at addr %0d bit %0d -> fail = %b, reported addr %0d",
                                f_val, f_addr, f_bit, fail, fail_addr);
        end
        $display("Injected stuck-at faults detected and located: %0d / 32", caught);
        if (errors == 0) $display("RESULT: PASS (0 errors)");
        else             $display("RESULT: FAIL (%0d errors)", errors);
        $finish;
    end
endmodule
