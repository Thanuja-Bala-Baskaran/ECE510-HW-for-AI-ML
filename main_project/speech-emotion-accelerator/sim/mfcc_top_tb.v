`timescale 1ns/1ps

module mfcc_top_tb;
    reg clk, rst, start, valid_in;
    reg [15:0] input_sample;
    wire done;
    wire [17:0] mfcc_out_0, mfcc_out_1, mfcc_out_2, mfcc_out_3, mfcc_out_4,
               mfcc_out_5, mfcc_out_6, mfcc_out_7, mfcc_out_8, mfcc_out_9,
               mfcc_out_10, mfcc_out_11, mfcc_out_12;

    // Instantiate DUT
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

    // Clock generation
    always #5 clk = ~clk;

    integer i;

    initial begin
        clk = 0;
        rst = 1;
        start = 0;
        valid_in = 0;
        input_sample = 0;
        #20;

        rst = 0;
        #10;

        #10 start = 1;
        #10 start = 0;
for (i = 0; i < 512; i = i + 1) begin
    @(negedge clk);
    valid_in = 1;
    input_sample = i;
end
@(negedge clk);
valid_in = 0;

        // Wait for done
        wait (done);
        #10;

        $display("\n==== MFCC Coefficients ====");
        $display("mfcc_out_0  = %d", mfcc_out_0);
        $display("mfcc_out_1  = %d", mfcc_out_1);
        $display("mfcc_out_2  = %d", mfcc_out_2);
        $display("mfcc_out_3  = %d", mfcc_out_3);
        $display("mfcc_out_4  = %d", mfcc_out_4);
        $display("mfcc_out_5  = %d", mfcc_out_5);
        $display("mfcc_out_6  = %d", mfcc_out_6);
        $display("mfcc_out_7  = %d", mfcc_out_7);
        $display("mfcc_out_8  = %d", mfcc_out_8);
        $display("mfcc_out_9  = %d", mfcc_out_9);
        $display("mfcc_out_10 = %d", mfcc_out_10);
        $display("mfcc_out_11 = %d", mfcc_out_11);
        $display("mfcc_out_12 = %d", mfcc_out_12);

        $finish;
    end

endmodule
