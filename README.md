# 100 Days of RTL Design

100 digital designs in Verilog, from a single logic gate up to a small CPU.
Every design comes with a self-checking testbench and a real simulation log
from Xilinx Vivado (xsim). None of the testbenches rely on reading
waveforms by eye: each one compares the design against a reference model
and prints PASS or FAIL.

**Author:** M Kamaraju ([MKRAJU-VLSI-HUB](https://github.com/MKRAJU-VLSI-HUB)) ·
[LinkedIn](https://www.linkedin.com/in/magupallikamaraju/)

**Status:** 100 / 100 designs pass simulation.

## Why I did this

I wanted my RTL basics to be solid, not just "I've seen that before".
So I set myself one rule: a design only counts once its testbench checks
it automatically and it passes. Where an input space was small enough,
I tested every possible input: all 65536 signed pairs for the Booth
multiplier, every dividend and divisor for the divider, and all 65536
inputs for the square root.

Some of these started life as my lab and exam exercises (ALU, FIFO,
vending machine, sequence detectors, pattern detector, charger FSM,
Hamming code, matrix multiplier, hybrid multiplier, mini CPU). Going back
to them with proper testbenches turned up real bugs. The pattern
detector had a syntax error. The FIFO could only hold 15 of its 16 entries.
The LCM block used a loop that cannot be synthesised. The charger FSM
drove one signal from two always blocks. The CPU's register file only
cleared one register on reset. All of these are fixed here.

## The 100 designs

| Day | Design | Area | What it does |
|----:|--------|------|--------------|
| 1 | [Basic Logic Gates](day001_logic_gates) | Combinational | AND, OR, NOT, NAND, NOR, XOR and XNOR gates with a full truth table check |
| 2 | [Half Adder](day002_half_adder) | Combinational | 1-bit half adder: sum = a ^ b, carry = a & b |
| 3 | [Full Adder](day003_full_adder) | Combinational | 1-bit full adder with carry in, checked on all 8 input combinations |
| 4 | [Half Subtractor](day004_half_subtractor) | Combinational | 1-bit half subtractor producing difference and borrow |
| 5 | [Full Subtractor](day005_full_subtractor) | Combinational | 1-bit full subtractor with borrow in and borrow out |
| 6 | [4-bit Ripple Carry Adder](day006_ripple_carry_adder) | Combinational | Four full adders chained through their carries, checked on all 512 inputs |
| 7 | [4-bit Adder / Subtractor](day007_adder_subtractor) | Combinational | One adder does both add and subtract using 2s complement, with signed overflow flag |
| 8 | [4-bit Carry Look-Ahead Adder](day008_carry_lookahead_adder) | Combinational | Carries computed directly from generate and propagate terms, no ripple |
| 9 | [8-bit Carry Select Adder](day009_carry_select_adder) | Combinational | Upper nibble computed for both carry values in parallel, real carry picks the result |
| 10 | [BCD Adder](day010_bcd_adder) | Combinational | 1-digit decimal adder with the +6 correction for results above 9 |
| 11 | [2:1 Multiplexer (3 styles)](day011_mux_2to1) | Combinational | Same mux in dataflow, gate level and behavioural Verilog, all three compared |
| 12 | [4:1 Multiplexer](day012_mux_4to1) | Combinational | 4:1 mux using a case statement, checked on all 64 combinations |
| 13 | [8:1 Multiplexer](day013_mux_8to1) | Combinational | 8:1 mux built hierarchically from two 4:1 muxes and a 2:1 mux |
| 14 | [1:4 Demultiplexer](day014_demux_1to4) | Combinational | Routes one input to one of four outputs selected by sel |
| 15 | [2-to-4 Decoder](day015_decoder_2to4) | Combinational | 2-to-4 decoder with enable, one-hot outputs |
| 16 | [3-to-8 Decoder](day016_decoder_3to8) | Combinational | 3-to-8 decoder with enable using a case statement |
| 17 | [8-to-3 Priority Encoder](day017_priority_encoder_8to3) | Combinational | Highest active input wins, valid flag when no input is set |
| 18 | [4-bit Magnitude Comparator](day018_magnitude_comparator) | Combinational | Greater, equal and less outputs built from bit equality terms like the 7485 |
| 19 | [Binary / Gray Code Converter](day019_binary_gray_converter) | Combinational | 8-bit binary to Gray and back, neighbouring codes differ by one bit |
| 20 | [Parity Generator and Checker](day020_parity_generator_checker) | Combinational | Even parity for an 8-bit word, every single-bit error detected |
| 21 | [BCD to 7-Segment Decoder](day021_bcd_to_7segment) | Combinational | Drives a 7-segment display for digits 0-9, prints the digits as ASCII art |
| 22 | [4x4 Array Multiplier](day022_array_multiplier) | Combinational | AND-gate partial products added row by row with full adders |
| 23 | [8-bit Barrel Shifter](day023_barrel_shifter) | Combinational | Shift left/right, arithmetic shift and rotate in three mux stages |
| 24 | [8-bit ALU](day024_alu_8bit) | Combinational | 16 operations (arithmetic, logic, shifts, multiply, divide) with tri-state output |
| 25 | [16-bit Leading Zero Counter](day025_leading_zero_counter) | Combinational | Tree of small counters, used in floating point normalisation |
| 26 | [Population Count](day026_population_count) | Combinational | Counts the 1s in a byte with an adder tree |
| 27 | [Binary to BCD (Double Dabble)](day027_binary_to_bcd) | Combinational | Shift and add-3 algorithm, 8-bit binary to three BCD digits |
| 28 | [4x4 Vedic Multiplier](day028_vedic_multiplier) | Combinational | Urdhva Tiryagbhyam method built from 2x2 Vedic cells |
| 29 | [Hamming SECDED Code](day029_hamming_secded) | Combinational | Hamming(7,4) plus parity: corrects 1-bit errors, detects 2-bit errors |
| 30 | [4x4 Matrix Multiplier](day030_matrix_multiplier_4x4) | Combinational | C = A x B for 8-bit matrices with flattened Verilog ports |
| 31 | [SR Latch and D Latch](day031_latches) | Sequential | Level-sensitive storage: cross-coupled NOR latch and gated D latch |
| 32 | [D Flip-Flop (sync and async reset)](day032_d_flip_flop) | Sequential | Shows the difference between synchronous and asynchronous reset |
| 33 | [JK Flip-Flop](day033_jk_flip_flop) | Sequential | Hold, set, reset and toggle modes compared with a model |
| 34 | [T Flip-Flop](day034_t_flip_flop) | Sequential | T flip-flop made from a D flip-flop, divides the clock by 2 |
| 35 | [8-bit Register](day035_register_load_enable) | Sequential | Register with load, clear and tri-state output enable |
| 36 | [SISO Shift Register](day036_siso_shift_register) | Sequential | 4-bit serial-in serial-out shift register |
| 37 | [SIPO Shift Register](day037_sipo_shift_register) | Sequential | Serial bits collected into a parallel byte with a valid pulse |
| 38 | [PISO Shift Register](day038_piso_shift_register) | Sequential | Parallel byte sent out one bit per clock, MSB first |
| 39 | [Universal Shift Register](day039_universal_shift_register) | Sequential | Hold, shift left, shift right and parallel load like the 74194 |
| 40 | [4-bit Synchronous Up Counter](day040_sync_up_counter) | Sequential | Counter with enable and terminal count for chaining |
| 41 | [Up/Down Counter](day041_up_down_counter) | Sequential | 4-bit counter that counts both ways with parallel load |
| 42 | [Mod-12 Counter](day042_mod12_counter) | Sequential | Counts 0 to 11 and wraps, with load |
| 43 | [Ring Counter](day043_ring_counter) | Sequential | A single 1 circulates through 4 flip-flops |
| 44 | [Johnson Counter](day044_johnson_counter) | Sequential | Twisted ring counter with 8 states and one bit change per clock |
| 45 | [2-Digit BCD Counter](day045_bcd_counter) | Sequential | 00 to 99 using two cascaded decade counters |
| 46 | [8-bit LFSR](day046_lfsr) | Sequential | Maximal-length pseudo-random sequence, all 255 states visited |
| 47 | [Gray Code Counter](day047_gray_code_counter) | Sequential | Counter whose output changes one bit at a time |
| 48 | [Clock Divider by 2, 4, 8](day048_clock_divider_pow2) | Sequential | Divided clocks from a free-running counter, periods measured |
| 49 | [Divide-by-5 Clock Divider](day049_clock_divider_div5) | Sequential | Odd divide ratio, 2 cycles high and 3 low |
| 50 | [Divide-by-3 with 50% Duty](day050_clock_divider_div3_50duty) | Sequential | Uses both clock edges to get an exact 50% duty cycle |
| 51 | [PWM Generator](day051_pwm_generator) | Sequential | 8-bit duty cycle, glitch-free update at the end of each period |
| 52 | [Edge Detector](day052_edge_detector) | Sequential | One-clock pulses on rising and falling edges |
| 53 | [Switch Debouncer](day053_switch_debouncer) | Sequential | Synchroniser plus stability counter, bouncy presses give one clean pulse |
| 54 | [CDC Synchronizers](day054_cdc_synchronizers) | Sequential | 2-flop level synchroniser and toggle pulse synchroniser between two clocks |
| 55 | [101 Sequence Detector](day055_sequence_detector_101) | FSM | Moore FSM with overlap detecting the pattern 101 |
| 56 | [1101 Detector (Moore vs Mealy)](day056_sequence_detector_1101_moore) | FSM | Both machine types side by side, Mealy reacts one clock earlier |
| 57 | [Pattern Detector 000111000](day057_pattern_detector_fsm) | FSM | 10-state FSM for a 9-bit pattern with overlap |
| 58 | [Vending Machine](day058_vending_machine) | FSM | Accepts Rs 1 and Rs 2 coins, dispenses at Rs 3 and gives change |
| 59 | [Traffic Light Controller](day059_traffic_light_controller) | FSM | Main road and side road with sensor, timed phases, never two greens |
| 60 | [Smartphone Charger Controller](day060_charger_controller_fsm) | FSM | Charging timer with a safety cut-off after 60 us |
| 61 | [Register File](day061_register_file) | Memory | 8 x 8 with two read ports, one write port and write forwarding |
| 62 | [Single-Port RAM](day062_single_port_ram) | Memory | 16 x 8 asynchronous RAM with a bidirectional data bus |
| 63 | [Dual-Port RAM](day063_dual_port_ram) | Memory | 16 x 8 synchronous RAM with independent read and write ports |
| 64 | [Sine Look-up ROM](day064_sine_rom) | Memory | 32-sample sine wave built from a 9-entry quarter table |
| 65 | [Synchronous FIFO](day065_sync_fifo) | Memory | 16 x 8 FIFO with full, empty and count using an extra pointer bit |
| 66 | [Asynchronous FIFO](day066_async_fifo) | Memory | Two clock domains, Gray-coded pointers and 2-flop synchronisers |
| 67 | [LIFO Stack](day067_lifo_stack) | Memory | 8-deep stack with push, pop, full and empty |
| 68 | [Content Addressable Memory](day068_cam) | Memory | Search by data, all 8 entries compared in parallel |
| 69 | [Memory BIST (March C-)](day069_memory_bist) | Memory | Self-test engine that finds and locates stuck-at faults in a RAM |
| 70 | [Shift-Add Multiplier](day070_shift_add_multiplier) | Arithmetic | 8x8 sequential multiplier, one bit per clock |
| 71 | [Booth Multiplier](day071_booth_multiplier) | Arithmetic | Signed radix-2 Booth algorithm, all 65536 pairs checked |
| 72 | [Restoring Divider](day072_restoring_divider) | Arithmetic | 8-bit quotient and remainder with divide-by-zero flag |
| 73 | [GCD Calculator](day073_gcd_calculator) | Arithmetic | Euclid algorithm with a datapath and controller |
| 74 | [LCM Calculator](day074_lcm_calculator) | Arithmetic | GCD followed by a shift-subtract divider, fully synthesisable |
| 75 | [MAC Unit](day075_mac_unit) | Arithmetic | Pipelined signed multiply-accumulate for dot products |
| 76 | [4-Tap FIR Filter](day076_fir_filter) | DSP | Low-pass filter with coefficients 1 3 3 1 |
| 77 | [CRC-8 Generator](day077_crc8_generator) | DSP | Serial CRC with polynomial 0x07, matches the standard check value |
| 78 | [Integer Square Root](day078_integer_sqrt) | Arithmetic | Bit-by-bit square root of a 16-bit number in 8 clocks |
| 79 | [Fixed Priority Arbiter](day079_fixed_priority_arbiter) | Control | One-hot grant using the req & ~(req - 1) trick |
| 80 | [Round-Robin Arbiter](day080_round_robin_arbiter) | Control | Fair arbitration, every requester served within 4 grants |
| 81 | [Digital Clock](day081_digital_clock) | System | 24-hour HH:MM:SS clock in BCD with set mode |
| 82 | [Stopwatch](day082_stopwatch) | System | Start/stop, lap and clear, counts to hundredths of a second |
| 83 | [Watchdog Timer](day083_watchdog_timer) | System | Resets the system if software stops kicking it, with early warning |
| 84 | [UART Transmitter](day084_uart_transmitter) | Protocol | 8N1 serial transmitter with configurable baud rate |
| 85 | [UART Receiver](day085_uart_receiver) | Protocol | Mid-bit sampling, glitch rejection and framing error detection |
| 86 | [UART Loopback System](day086_uart_loopback) | Protocol | Receiver, controller and transmitter that echo text back with case swapped |
| 87 | [SPI Master](day087_spi_master) | Protocol | Mode 0 full-duplex byte transfers |
| 88 | [SPI Slave with Registers](day088_spi_slave) | Protocol | Register read and write over SPI from a microcontroller-style master |
| 89 | [APB Slave](day089_apb_slave) | Protocol | AMBA APB3 register block with wait states and error response |
| 90 | [Valid/Ready Skid Buffer](day090_skid_buffer) | Protocol | Streaming pipeline stage that never drops or duplicates data |
| 91 | [Hybrid Vedic + Booth Multiplier](day091_hybrid_vedic_booth_multiplier) | Arithmetic | Picks a recursive Vedic multiplier or a Booth multiplier based on operand signs |
| 92 | [Elevator Controller](day092_elevator_controller) | System | 4-floor lift using the elevator algorithm, door and motion safety checks |
| 93 | [2x2 Systolic Array](day093_systolic_array_2x2) | DSP | Output-stationary processing elements computing a matrix product |
| 94 | [CORDIC Sine / Cosine](day094_cordic_sin_cos) | DSP | Shift-and-add rotations, results within about 1 LSB |
| 95 | [Q8.8 Fixed-Point Multiplier](day095_fixed_point_multiplier) | Arithmetic | Signed fixed-point multiply with rounding and saturation |
| 96 | [Moving Average Filter](day096_moving_average_filter) | DSP | 8-sample average with a running sum |
| 97 | [4x4 Keypad Scanner](day097_keypad_scanner) | System | Column scanning with debounce, one report per key press |
| 98 | [4-Digit 7-Segment Multiplexer](day098_seven_segment_multiplexer) | System | Time-multiplexed display driver with leading zero blanking |
| 99 | [Manchester Encoder / Decoder](day099_manchester_codec) | Protocol | Self-clocking line code with code error detection |
| 100 | [Mini 8-bit CPU](day100_mini_cpu) | Capstone | Single-cycle CPU with 14 instructions running a Fibonacci program |

## Repository layout

Every day has the same structure:

```
dayNNN_<name>/
├── rtl/          design source
├── tb/           self-checking testbench
└── simulation/   sim_output.log from Vivado xsim
```

## How to run any day

With Vivado 2024.2 on your PATH, from inside a day folder:

```
xvlog -sv rtl/*.v tb/*.v
xelab <name>_tb -s sim -timescale 1ns/1ps
xsim sim -R
```

Day 100 also needs `rtl/program.mem` in the folder you run from. You can
also add the `rtl` and `tb` files to a Vivado project and run behavioural
simulation from the GUI.

## Things I learned along the way

- **Race conditions in testbenches are real.** Checking a combinational
  output in the same time step that its input changes gives you the old
  value. A `#1` before the check, or sampling on the opposite clock edge,
  fixes it.
- **A function call inside `assign` only wakes up when its arguments
  change**, not when other signals it reads change. I hit this in the
  register file and rewrote the read logic as plain expressions.
- **Signed and unsigned don't mix in Verilog.** One unsigned operand in a
  `? :` makes the whole expression unsigned, which silently broke a
  signed reference model until I split it into `if`/`else`.
- **Booth needs one extra accumulator bit**, or `A - M` overflows when M is
  the most negative number.
- **CORDIC precision depends on guard bits.** With only 2 extra bits the
  error was about 9 LSB. With 4 extra fraction bits and rounding it dropped
  to about 1 LSB.

## License

Released under the [MIT License](LICENSE). You are free to use and modify
the code. If it helps your own work, please credit
**M Kamaraju (MKRAJU-VLSI-HUB)** and link back to this repository.
