`timescale 1ns / 1ps

module dct_tb;

    parameter N_INPUTS = 40;
    parameter N_OUTPUTS = 13;
    parameter IN_WIDTH = 6;
    parameter COEF_WIDTH = 10;
    parameter OUT_WIDTH = 18;

    reg clk;
    reg rst;
    reg start;
    reg [IN_WIDTH*N_INPUTS-1:0] in_log_flat;
    wire [OUT_WIDTH*N_OUTPUTS-1:0] dct_out_flat;
    wire done;

    // Instantiate DUT
    dct #(
        .N_INPUTS(N_INPUTS),
        .N_OUTPUTS(N_OUTPUTS),
        .IN_WIDTH(IN_WIDTH),
        .COEF_WIDTH(COEF_WIDTH),
        .OUT_WIDTH(OUT_WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .in_log_flat(in_log_flat),
        .dct_out_flat(dct_out_flat),
        .done(done)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    integer i;

    initial begin
        $display("Starting DCT TB...");
        rst = 1;
        start = 0;
        in_log_flat = 0;

        // Reset pulse
        #20 rst = 0;

        // Step 1: Fill dummy log_energy vector (simple ramp: 0, 1, 2, ..., 39)
        for (i = 0; i < N_INPUTS; i = i + 1) begin
            in_log_flat[(i+1)*IN_WIDTH-1 -: IN_WIDTH] = i;
        end

        // Step 2: Trigger start pulse
        #10 start = 1;
        #10 start = 0;

        // Step 3: Wait for done
        wait(done);
        #10;

        // Step 4: Display results
        $display("--------- DCT OUTPUT ---------");
        for (i = 0; i < N_OUTPUTS; i = i + 1) begin
            $display("DCT[%0d] = %0d", i, dct_out_flat[(i+1)*OUT_WIDTH-1 -: OUT_WIDTH]);
        end

        $finish;
    end

endmodule
