module fft #(
    parameter N = 512,
    parameter DATA_WIDTH = 16,
    parameter OUT_WIDTH = 18
)(
    input clk,
    input rst,
    input start,
    input [DATA_WIDTH-1:0] in_sample,
    input in_valid,
    output reg [OUT_WIDTH-1:0] out_real,
    output reg [OUT_WIDTH-1:0] out_imag,
    output reg out_valid,
    output reg done
);

    // FSM States
    localparam IDLE      = 2'b00;
    localparam LOAD      = 2'b01;
    localparam FFT_STAGE = 2'b10;
    localparam DONE      = 2'b11;

    reg [1:0] state;
    reg signed [DATA_WIDTH-1:0] sample_buffer [0:N-1];
    reg [8:0] sample_count;

    // Butterfly outputs
    wire signed [DATA_WIDTH:0] stage1_real [0:N/2-1];
    wire signed [DATA_WIDTH:0] stage1_imag [0:N/2-1];
	reg j = 0, k= 0; 

    reg [8:0] out_count;  // to serially output 256 FFT values
	
	reg done_latched;

    // FSM
    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            sample_count <= 0;
            out_count <= 0;
            out_valid <= 0;
			done <= 0;
			done_latched <= 0;

        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        sample_count <= 0;
                        state <= LOAD;
                        $display("Entered LOAD state");
                    end
                end

                LOAD: begin
                    if (in_valid) begin
                        sample_buffer[sample_count] <= in_sample;
                        $display("Loading: sample_buffer[%0d] = %0d", sample_count, in_sample);
                        sample_count <= sample_count + 1;
                        if (sample_count == N-1) begin
                            state <= FFT_STAGE;
                            $display("Finished loading all %0d samples", N);
                        end
                    end
                end

                FFT_STAGE: begin
                    out_real  <= stage1_real[out_count];
                    out_imag  <= stage1_imag[out_count];
                    out_valid <= 1;
                    $display("FFT Output [%0d]: %0d + j%0d", out_count, stage1_real[out_count], stage1_imag[out_count]);

                    if (out_count == (N/2 - 1)) begin
                        out_count <= 0;
                        state <= DONE;
                    end else begin
                        out_count <= out_count + 1;
                    end
                end

                DONE: begin
                    if (!done_latched) begin
				done <= 1;
				done_latched <= 1;
				out_valid <= 0;
				$display("FFT Done.");
			end else begin
				done <= 0;  // clear after 1 cycle
			end
                end
            endcase
        end
    end

    // Butterfly instantiation
    genvar i;
    generate
        for (i = 0; i < N/2; i = i + 1) begin : stage1
            butterfly #(.DATA_WIDTH(DATA_WIDTH)) bf (
                .a(sample_buffer[2*i]),
                .b(sample_buffer[2*i+1]),
                .twiddle_real(16'd1),
                .twiddle_imag(16'd0),
                .real_out(stage1_real[i]),
                .imag_out(stage1_imag[i])
            );
        end
    endgenerate

endmodule
