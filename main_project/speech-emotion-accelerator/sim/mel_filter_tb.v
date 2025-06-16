`timescale 1ns/1ps
module mel_filter_tb;

    parameter N_FFT = 256;
    parameter N_FILTERS = 40;
    parameter DATA_WIDTH = 18;
    parameter COEF_WIDTH = 10;
    parameter MEL_WIDTH = DATA_WIDTH + COEF_WIDTH;

    reg clk = 0, rst = 0, start = 0, in_valid = 0;
    reg [DATA_WIDTH-1:0] fft_power_in;
    wire [MEL_WIDTH*N_FILTERS-1:0] filter_energy_flat;
    wire out_valid, done;

    mel_filter_bank #(
        .N_FFT(N_FFT),
        .N_FILTERS(N_FILTERS),
        .DATA_WIDTH(DATA_WIDTH),
        .COEF_WIDTH(COEF_WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .fft_power_in(fft_power_in),
        .in_valid(in_valid),
        .filter_energy_flat(filter_energy_flat),
        .out_valid(out_valid),
        .done(done)
    );

    always #5 clk = ~clk;

    integer i;

    initial begin
        $display("Starting Mel Filter TB...");

        rst = 1;
        #20 rst = 0;

        #10 start = 1;
        #10 start = 0;

        // Push 512 inputs
        for (i = 0; i < N_FFT; i = i + 1) begin
            in_valid = 1;
            fft_power_in = i + 1;  // Inject known pattern
            $display("Pushing input[%0d] = %0d", i, fft_power_in);
            #10;
        end

        in_valid = 0;

        wait (done);

        $display("---------- MEL FILTER OUTPUT ----------");
        for (i = 0; i < N_FILTERS; i = i + 1) begin
            $display("Filter %0d energy = %0d", i, filter_energy_flat[(i+1)*MEL_WIDTH-1 -: MEL_WIDTH]);
        end

        $finish;
    end

endmodule
