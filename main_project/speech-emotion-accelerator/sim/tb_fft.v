`timescale 1ns / 1ps

module tb_fft;

    // Parameters
    parameter N = 512;
    parameter DATA_WIDTH = 16;
    parameter OUT_WIDTH = 18;

    // Signals
    reg clk;
    reg rst;
    reg start;
    reg [DATA_WIDTH-1:0] in_sample;
    reg in_valid;
    wire [OUT_WIDTH-1:0] out_real;
    wire [OUT_WIDTH-1:0] out_imag;
    wire out_valid;
    wire done;

    // Instantiate FFT module
    fft #(
        .N(N),
        .DATA_WIDTH(DATA_WIDTH),
        .OUT_WIDTH(OUT_WIDTH)
    ) uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .in_sample(in_sample),
        .in_valid(in_valid),
        .out_real(out_real),
        .out_imag(out_imag),
        .out_valid(out_valid),
        .done(done)
    );

    // Clock generation
    always #5 clk = ~clk;

    integer i;

    initial begin
        clk      = 0;
        rst      = 1;
        start    = 0;
        in_valid = 0;
        in_sample= 0;

        $dumpfile("output/fft.vcd");
        $dumpvars(0, tb_fft);

        // Reset and start sequence
        #20 rst   = 0;
        #10 start = 1;
        #10 start = 0;

        // Input 512 samples
        for (i = 0; i < N; i = i + 1) begin
            @(negedge clk);
            in_valid = 1;
            in_sample = i;  // input pattern: ramp from 0 to 511
        end

        // Stop input
        @(negedge clk);
        in_valid = 0;

        // Wait for FFT to complete
        wait (done);
        #20 $finish;
    end

endmodule
