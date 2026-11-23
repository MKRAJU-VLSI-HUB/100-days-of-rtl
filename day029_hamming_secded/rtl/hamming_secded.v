//==============================================================================
// Project     : 100 Days of RTL Design - Day 29 / 100
// Design      : Hamming SECDED Code
// File        : hamming_secded.v
// Author      : M Kamaraju (MKRAJU-VLSI-HUB)
// GitHub      : https://github.com/MKRAJU-VLSI-HUB
// LinkedIn    : https://www.linkedin.com/in/magupallikamaraju/
// Tool        : Xilinx Vivado 2024.2 (xsim)
// Description : Hamming(7,4) plus parity: corrects 1-bit errors, detects 2-bit errors
// License     : MIT License - Copyright (c) 2026 M Kamaraju
//==============================================================================

// Hamming(7,4) code with an extra overall parity bit (SECDED):
// Single Error Correction, Double Error Detection.

// Encoder: data d3 d2 d1 d0 -> code word d3 d2 d1 p4 d0 p2 p1 + overall parity
module hamming74_enc (
    input  [3:0] i_data,
    output [6:0] o_hamming_code,
    output       o_parity
);
    wire p1 = i_data[0] ^ i_data[1] ^ i_data[3];
    wire p2 = i_data[0] ^ i_data[2] ^ i_data[3];
    wire p4 = i_data[1] ^ i_data[2] ^ i_data[3];

    assign o_hamming_code = {i_data[3:1], p4, i_data[0], p2, p1};
    assign o_parity       = ^o_hamming_code;
endmodule

// Decoder: syndrome points to the wrong bit, which is flipped back.
module hamming74_dec (
    input  [6:0] i_data,
    input        i_parity,
    output [3:0] o_data,
    output       o_1bit_error,     // corrected
    output       o_2bit_error,     // detected, not correctable
    output       o_parity_error    // only the extra parity bit was hit
);
    wire s1 = i_data[0] ^ i_data[2] ^ i_data[4] ^ i_data[6];
    wire s2 = i_data[1] ^ i_data[2] ^ i_data[5] ^ i_data[6];
    wire s4 = i_data[3] ^ i_data[4] ^ i_data[5] ^ i_data[6];
    wire [2:0] syn = {s4, s2, s1};

    reg [6:0] flip;
    always @(*) begin
        flip = 7'b0;
        if (syn != 3'd0) flip[syn - 1] = 1'b1;
    end

    wire [6:0] fixed          = i_data ^ flip;
    wire       overall_parity = ^{i_parity, i_data};

    assign o_1bit_error   = (syn != 3'd0) &  overall_parity;
    assign o_2bit_error   = (syn != 3'd0) & ~overall_parity;
    assign o_parity_error = (syn == 3'd0) &  overall_parity;
    assign o_data         = {fixed[6:4], fixed[2]};
endmodule

// Channel model: XOR the 8-bit code word with an error mask
module noise_add (
    input  [7:0] i_data,
    input  [7:0] i_noise,
    output [7:0] o_data
);
    assign o_data = i_data ^ i_noise;
endmodule

// Top level: encoder -> noisy channel -> decoder
module hamming_secded (
    input  [3:0] i_secded,
    input  [7:0] i_noise,
    output [3:0] o_secded,
    output       o_1bit_error,
    output       o_2bit_error,
    output       o_parity_error
);
    wire [6:0] enc_code;  wire enc_parity;
    wire [6:0] rx_code;   wire rx_parity;

    hamming74_enc ENC (.i_data(i_secded), .o_hamming_code(enc_code), .o_parity(enc_parity));
    noise_add     NOISE (.i_data({enc_parity, enc_code}), .i_noise(i_noise), .o_data({rx_parity, rx_code}));
    hamming74_dec DEC (.i_data(rx_code), .i_parity(rx_parity), .o_data(o_secded),
                       .o_1bit_error(o_1bit_error), .o_2bit_error(o_2bit_error),
                       .o_parity_error(o_parity_error));
endmodule
