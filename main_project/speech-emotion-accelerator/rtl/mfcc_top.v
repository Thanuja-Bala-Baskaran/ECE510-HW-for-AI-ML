module mfcc_top(
    input clk,
    input rst,
    input start,
    input [15:0] input_sample,
    input valid_in,
    output reg done,
    output [17:0] mfcc_out_0,
    output [17:0] mfcc_out_1,
    output [17:0] mfcc_out_2,
    output [17:0] mfcc_out_3,
    output [17:0] mfcc_out_4,
    output [17:0] mfcc_out_5,
    output [17:0] mfcc_out_6,
    output [17:0] mfcc_out_7,
    output [17:0] mfcc_out_8,
    output [17:0] mfcc_out_9,
    output [17:0] mfcc_out_10,
    output [17:0] mfcc_out_11,
    output [17:0] mfcc_out_12
);

    // === FFT output ===
    wire [17:0] fft_real;
    wire [17:0] fft_imag;
    wire fft_valid;
    wire fft_done;

    // === MEL ===
    wire mel_done;
    wire [1119:0] mel_energy_bus;

    // === LOG & DCT ===
    wire log_done;
    wire [239:0] log_energy_bus;

    wire dct_done;
    wire [233:0] dct_out_flat;

    // === Buffer and FSM control ===
    reg [17:0] fft_buffer [0:255];
    reg [7:0] fft_buf_idx, mel_send_idx;
    reg [17:0] mel_input;
    reg mel_valid, start_mel;

    // === FSM ===
    reg [1:0] state;
    localparam IDLE = 2'd0,
               START_MEL = 2'd1,
               SEND_MEL = 2'd2;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            fft_buf_idx <= 0;
            mel_send_idx <= 0;
            state <= IDLE;
            mel_valid <= 0;
            start_mel <= 0;
        end else begin
            start_mel <= 0;     // default low unless pulsed
            mel_valid <= 0;     // only high when sending data

            case (state)
                IDLE: begin
                    if (fft_valid) begin
                        fft_buffer[fft_buf_idx] <= fft_real;
                        fft_buf_idx <= fft_buf_idx + 1;
                        if (fft_buf_idx == 8'd255)
                            state <= START_MEL;
                    end
                end

                START_MEL: begin
                    start_mel <= 1;  // pulse to enter MEL.COLLECT
                    mel_send_idx <= 0;
                    state <= SEND_MEL;
                end

                SEND_MEL: begin
                    mel_input <= fft_buffer[mel_send_idx];
                    mel_valid <= 1;
                    mel_send_idx <= mel_send_idx + 1;
                    if (mel_send_idx == 8'd255)
                        state <= IDLE;
                end
            endcase
        end
    end

    // === FFT ===
    fft fft_inst(
        .clk(clk),
        .rst(rst),
        .start(start),
        .in_sample(input_sample),
        .in_valid(valid_in),
        .out_real(fft_real),
        .out_imag(fft_imag),
        .out_valid(fft_valid),
        .done(fft_done)
    );

    // === MEL ===
    mel_filter_bank mel_inst(
        .clk(clk),
        .rst(rst),
        .start(start_mel),
        .fft_power_in(mel_input),
        .in_valid(mel_valid),
        .filter_energy_flat(mel_energy_bus),
        .out_valid(), // optional
        .done(mel_done)
    );

    // === LOG ===
    reg prev_mel_done, start_log;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            prev_mel_done <= 0;
            start_log <= 0;
        end else begin
            prev_mel_done <= mel_done;
            start_log <= (mel_done && !prev_mel_done);
        end
    end

    log_compression log_inst(
        .clk(clk),
        .rst(rst),
        .start(start_log),
        .in_energy_flat(mel_energy_bus),
        .log_energy_flat(log_energy_bus),
        .done(log_done)
    );

    // === DCT ===
    reg prev_log_done, start_dct;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            prev_log_done <= 0;
            start_dct <= 0;
        end else begin
            prev_log_done <= log_done;
            start_dct <= (log_done && !prev_log_done);
        end
    end

    dct dct_inst(
        .clk(clk),
        .rst(rst),
        .start(start_dct),
        .in_log_flat(log_energy_bus),
        .dct_out_flat(dct_out_flat),
        .done(dct_done)
    );

    // === MFCC Outputs ===
    assign mfcc_out_0  = dct_out_flat[18*1-1 -: 18];
    assign mfcc_out_1  = dct_out_flat[18*2-1 -: 18];
    assign mfcc_out_2  = dct_out_flat[18*3-1 -: 18];
    assign mfcc_out_3  = dct_out_flat[18*4-1 -: 18];
    assign mfcc_out_4  = dct_out_flat[18*5-1 -: 18];
    assign mfcc_out_5  = dct_out_flat[18*6-1 -: 18];
    assign mfcc_out_6  = dct_out_flat[18*7-1 -: 18];
    assign mfcc_out_7  = dct_out_flat[18*8-1 -: 18];
    assign mfcc_out_8  = dct_out_flat[18*9-1 -: 18];
    assign mfcc_out_9  = dct_out_flat[18*10-1 -: 18];
    assign mfcc_out_10 = dct_out_flat[18*11-1 -: 18];
    assign mfcc_out_11 = dct_out_flat[18*12-1 -: 18];
    assign mfcc_out_12 = dct_out_flat[18*13-1 -: 18];

    // === DONE Flag ===
    always @(posedge clk or posedge rst) begin
        if (rst)
            done <= 0;
        else if (dct_done)
            done <= 1;
        else
            done <= 0;
    end

endmodule
