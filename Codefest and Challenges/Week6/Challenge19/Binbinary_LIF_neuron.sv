module binary_lif_neuron (
    input  logic clk,
    input  logic rst,
    input  logic spike_input,      // I(t)
    output logic spike_output      // S(t)
);

    // Q4.4 fixed-point format
    typedef logic [7:0] fixed_t;
    fixed_t potential;

    // Parameters
    parameter fixed_t LAMBDA     = 8'b11100110; // ~0.9 in Q4.4
    parameter fixed_t THRESHOLD  = 8'b01000000; // 4.0 in Q4.4
    parameter fixed_t INPUT_INC  = 8'b00010000; // 1.0 in Q4.4
    parameter fixed_t RESET_VAL  = 8'b00000000; // 0

    // Fixed-point multiplication: Q4.4 × Q4.4 = Q8.8 → truncate to Q4.4
    function automatic fixed_t mult_fixed(fixed_t a, fixed_t b);
        logic [15:0] product;
        product = a * b;
        return product[11:4]; // extract Q4.4 from Q8.8
    endfunction

    // Declare intermediate signals outside always block
    fixed_t decayed_potential;
    fixed_t input_added;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            potential     <= 0;
            spike_output  <= 0;
        end else begin
            decayed_potential = mult_fixed(potential, LAMBDA);
            input_added       = decayed_potential + (spike_input ? INPUT_INC : 8'd0);

            if (input_added >= THRESHOLD) begin
                spike_output <= 1;
                potential    <= RESET_VAL;
            end else begin
                spike_output <= 0;
                potential    <= input_added;
            end
        end
    end
endmodule