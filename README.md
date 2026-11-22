# 100 Days of RTL Design

I'm using this repository to log my 100 Days of RTL Design challenge. Each day
I write one digital design in Verilog, write a testbench for it, and simulate
it in Xilinx Vivado. The aim is to get the basics really solid first, then
move on to bigger blocks.

**Author:** M Kamaraju ([MKRAJU-VLSI-HUB](https://github.com/MKRAJU-VLSI-HUB)) ·
[LinkedIn](https://www.linkedin.com/in/magupallikamaraju/)

## Progress

| Day | Design | Type | Verification | Result |
|-----|--------|------|--------------|--------|
| 01 | [4-bit ripple carry adder](day01_ripple_carry_adder) | Combinational | All 512 input combinations, self-checking | PASS |
| 02 | [Divide-by-5 clock divider](day02_clock_divider_div5) | Sequential | Output period and high time measured | PASS |

## Repository layout

```
100-days-of-rtl/
├── day01_ripple_carry_adder/
│   ├── rtl/ripple_carry_adder.v
│   ├── tb/ripple_carry_adder_tb.v
│   └── simulation/sim_output.log
├── day02_clock_divider_div5/
│   ├── rtl/div_by_5.v
│   ├── tb/div_by_5_tb.v
│   └── simulation/sim_output.log
├── docs/100_Days_of_RTL_Journey.pdf
├── LICENSE
└── README.md
```

---

## Day 01 - 4-bit Ripple Carry Adder

The first thing I built was a full adder:

- `sum   = a ^ b ^ c`
- `carry = (a & b) | (b & c) | (c & a)`

Then I chained four of them together. The carry out of each stage goes into
the carry in of the next stage, which is where the "ripple" in the name comes
from. Inputs are two 4-bit numbers `a`, `b` and a carry in `cin`. Outputs are
a 4-bit `sum` and `cout`.

**Testing:** with only 9 input bits there are 512 combinations, so the
testbench tries every one of them and compares `{cout, sum}` against
`a + b + cin`.

```
 Ripple carry adder: 512 vectors checked
 RESULT: PASS (0 errors)
```

**What I learned:** structural modelling, module instantiation, and why the
carry chain sets the delay of this adder. Every stage has to wait for the one
before it, so the delay grows with the width. That's the reason carry
look-ahead adders exist.

## Day 02 - Divide-by-5 Clock Divider

A 3-bit counter counts 0, 1, 2, 3, 4 and then wraps back to 0. The output is
high while the count is 0 or 1 and low for 2, 3 and 4. That gives one output
cycle for every five input cycles, with a 40% duty cycle (2 high, 3 low).
The reset is asynchronous and active high.

**Testing:** the testbench makes a 100 MHz clock (10 ns period) using a
`task`, holds reset for the first 10 ns, and then measures the time between
rising edges and how long the output stays high.

```
 Divide-by-5: input clock 10 ns, output period 50 ns
 High time 20 ns, low time 30 ns (40% duty cycle)
 Output periods observed: 4
 RESULT: PASS (0 errors)
```

**What I learned:** counter-based clock division, asynchronous reset, using
tasks in a testbench, and why an odd divide ratio can't give a 50% duty cycle
from a single clock edge. Getting 50% would need logic on both edges.

---

## How to run

With Vivado 2024.2 on your PATH, from inside a day folder:

```
xvlog rtl/<design>.v tb/<design>_tb.v
xelab <design>_tb -s sim
xsim sim -R
```

You can also add the `rtl` and `tb` files to a Vivado project and run
behavioural simulation from there.

## License

This project is released under the [MIT License](LICENSE). You're free to use
and modify the code. If you use it in your own work, please credit
**M Kamaraju (MKRAJU-VLSI-HUB)** and link back to this repository.
