`timescale 1ns/1ps

module tb_binary_lif_neuron;

    logic clk, rst, spike_input;
    logic spike_output;

    binary_lif_neuron uut (
        .clk(clk),
        .rst(rst),
        .spike_input(spike_input),
        .spike_output(spike_output)
    );

    // Clock generator
    always #5 clk = ~clk;

    initial begin
        $display("Time\tInput\tOutput");
        $monitor("%0t\t%b\t%b", $time, spike_input, spike_output);
        
        clk = 0; rst = 1; spike_input = 0;
        #12 rst = 0;

        // Test 1: Constant input below threshold (short pulses)
        repeat (5) begin
            spike_input = 1; #10;
            spike_input = 0; #10;
        end

        // Gap
        #20;

        // Test 2: Accumulate until threshold
        spike_input = 1;
        repeat (8) #10;

        // Gap
        spike_input = 0; #50;

        // Test 3: Leakage with no input
        repeat (6) #10;

        // Gap
        #20;

        // Test 4: Strong spike (held input for quick accumulation)
        spike_input = 1;
        repeat (12) #10;

        // Finish
        $finish;
    end
endmodule
