`timescale 1ns / 1ps

module log_compression_tb;

    parameter N_FILTERS = 40;
    parameter IN_WIDTH = 32;
    parameter OUT_WIDTH = 6;

    reg clk;
    reg rst;
    reg start;
    reg [IN_WIDTH*N_FILTERS-1:0] in_energy_flat;
    wire [OUT_WIDTH*N_FILTERS-1:0] log_energy_flat;
    wire done;

    // DUT
    log_compression #(
        .N_FILTERS(N_FILTERS),
        .IN_WIDTH(IN_WIDTH),
        .OUT_WIDTH(OUT_WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .in_energy_flat(in_energy_flat),
        .log_energy_flat(log_energy_flat),
        .done(done)
    );

    // Clock
    initial clk = 0;
    always #5 clk = ~clk;

    integer i;

    initial begin
        $display("Starting log compression TB...");
        rst = 1;
        start = 0;
        in_energy_flat = 0;

        #20 rst = 0;

        // Fill in_energy with powers of 2
        for (i = 0; i < N_FILTERS; i = i + 1) begin
            in_energy_flat[(i+1)*IN_WIDTH-1 -: IN_WIDTH] = 1 << (i % 32);
        end

        #10 start = 1;
        #10 start = 0;

        wait(done);
        #10;

        $display("--------- LOG2 OUTPUT ---------");
        for (i = 0; i < N_FILTERS; i = i + 1) begin
            $display("Input = %0d, Log2 = %0d",
                     in_energy_flat[(i+1)*IN_WIDTH-1 -: IN_WIDTH],
                     log_energy_flat[(i+1)*OUT_WIDTH-1 -: OUT_WIDTH]);
        end

        $finish;
    end

endmodule
