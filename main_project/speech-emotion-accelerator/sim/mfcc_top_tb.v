`timescale 1ns/1ps

module mfcc_top_tb (
    input clk,
    input rst,
    input start,
    input [15:0] input_sample,
    input valid_in,
    output done,
    output [17:0] mfcc_out_0,
    output [17:0] mfcc_out_1,
    output [17:0] mfcc_out_2,
    output [17:0] mfcc_out_3,
    output [17:0] mfcc_out_4,
    output [17:0] mfcc_out_5,
    output [17:0] mfcc_out_6,
    output [17:0] mfcc_out_7,
    output [17:0] mfcc_out_8,
    output [17:0] mfcc_out_9,
    output [17:0] mfcc_out_10,
    output [17:0] mfcc_out_11,
    output [17:0] mfcc_out_12
);

    mfcc_top dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .input_sample(input_sample),
        .valid_in(valid_in),
        .done(done),
        .mfcc_out_0(mfcc_out_0),
        .mfcc_out_1(mfcc_out_1),
        .mfcc_out_2(mfcc_out_2),
        .mfcc_out_3(mfcc_out_3),
        .mfcc_out_4(mfcc_out_4),
        .mfcc_out_5(mfcc_out_5),
        .mfcc_out_6(mfcc_out_6),
        .mfcc_out_7(mfcc_out_7),
        .mfcc_out_8(mfcc_out_8),
        .mfcc_out_9(mfcc_out_9),
        .mfcc_out_10(mfcc_out_10),
        .mfcc_out_11(mfcc_out_11),
        .mfcc_out_12(mfcc_out_12)
    );

endmodule

