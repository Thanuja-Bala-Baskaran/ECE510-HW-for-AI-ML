module mel_filter_bank #(
    parameter N_FFT = 256,
    parameter N_FILTERS = 40,
    parameter DATA_WIDTH = 18,
    parameter COEF_WIDTH = 10,
    parameter MEL_WIDTH = DATA_WIDTH + COEF_WIDTH
)(
    input clk,
    input rst,
    input start,
    input [DATA_WIDTH-1:0] fft_power_in,
    input in_valid,

    output reg [MEL_WIDTH*N_FILTERS-1:0] filter_energy_flat,
    output reg out_valid,
    output reg done
);

    // Sample buffer
    reg [DATA_WIDTH-1:0] sample_buffer [0:N_FFT-1];
    reg [8:0] sample_idx;

    // Coefficient ROM (1D flattened)
    reg [COEF_WIDTH-1:0] mel_coeff [0:N_FILTERS*N_FFT-1];

    initial begin
        $readmemh("rtl/mel_coeff/mel_coeffs.hex", mel_coeff);
        $display("DEBUG: mel_coeff[0] = %h", mel_coeff[0]);
    end

    // FSM states
    reg [1:0] state;
    localparam IDLE = 2'd0,
               COLLECT = 2'd1,
               CALC = 2'd2,
               DONE = 2'd3;

    integer i, j, k;
    reg [MEL_WIDTH-1:0] mel_energy [0:N_FILTERS-1];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sample_idx <= 0;
            done <= 0;
            out_valid <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        sample_idx <= 0;
                        done <= 0;
                        out_valid <= 0;
                        state <= COLLECT;
                    end
                end

                COLLECT: begin
                    if (in_valid && sample_idx < N_FFT) begin
                        sample_buffer[sample_idx] <= fft_power_in;
                        sample_idx <= sample_idx + 1;
                    end
                    if (sample_idx == N_FFT - 1) begin
                        state <= CALC;
                    end
                end

                CALC: begin
                    for (i = 0; i < N_FILTERS; i = i + 1) begin
                        mel_energy[i] = 0;
                        for (j = 0; j < N_FFT; j = j + 1) begin
                            mel_energy[i] = mel_energy[i] + sample_buffer[j] * mel_coeff[i*N_FFT + j];
                        end
                        filter_energy_flat[(i+1)*MEL_WIDTH-1 -: MEL_WIDTH] <= mel_energy[i];
                        $display("mel_energy[%0d] = %0d", i, mel_energy[i]);
                    end
                    out_valid <= 1;
                    done <= 1;
                    state <= DONE;
                end

                DONE: begin
                    out_valid <= 0;
                end
            endcase
        end
    end

endmodule
