module butterfly #(parameter DATA_WIDTH = 16)(
    input signed [DATA_WIDTH-1:0] a,
    input signed [DATA_WIDTH-1:0] b,
    input signed [DATA_WIDTH-1:0] twiddle_real,
    input signed [DATA_WIDTH-1:0] twiddle_imag,
    output signed [DATA_WIDTH:0] real_out,
    output signed [DATA_WIDTH:0] imag_out
);

    wire signed [DATA_WIDTH:0] temp_real;
    wire signed [DATA_WIDTH:0] temp_imag;

    assign temp_real = b * twiddle_real;  // ignore complex mult for now
    assign temp_imag = b * twiddle_imag;

    assign real_out = a + temp_real;
    assign imag_out = temp_imag;

endmodule
