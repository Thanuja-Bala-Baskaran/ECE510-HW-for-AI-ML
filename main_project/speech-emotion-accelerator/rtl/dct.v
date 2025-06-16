module dct #(
    parameter N_INPUTS   = 40,
    parameter N_OUTPUTS  = 13,
    parameter IN_WIDTH   = 6,     // log2 input width
    parameter COEF_WIDTH = 10,    // cosine precision (Q1.9)
    parameter OUT_WIDTH  = 18     // wide enough for accumulation
)(
    input clk,
    input rst,
    input start,
    input [IN_WIDTH*N_INPUTS-1:0] in_log_flat,
    output reg [OUT_WIDTH*N_OUTPUTS-1:0] dct_out_flat,
    output reg done
);

    // Internal registers
    reg signed [IN_WIDTH-1:0] in_log [0:N_INPUTS-1];
    reg signed [COEF_WIDTH-1:0] cos_rom [0:N_INPUTS*N_OUTPUTS-1];
    reg signed [OUT_WIDTH-1:0] accum;
    integer i, j, index;

    // Unpack flattened input
    always @(*) begin
        for (i = 0; i < N_INPUTS; i = i + 1)
            in_log[i] = in_log_flat[(i+1)*IN_WIDTH-1 -: IN_WIDTH];
    end

    // Load flattened cosine ROM from file (Q1.9)
    initial begin
        $readmemh("rtl/dct/dct_cos_table.hex", cos_rom);
    end

    // DCT computation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            done <= 0;
        end else if (start) begin
		$display("entered DCT");
            for (i = 0; i < N_OUTPUTS; i = i + 1) begin
                accum = 0;
                for (j = 0; j < N_INPUTS; j = j + 1) begin
                    index = i * N_INPUTS + j;
                    accum = accum + (in_log[j] * cos_rom[index]);
                end
                dct_out_flat[(i+1)*OUT_WIDTH-1 -: OUT_WIDTH] = accum;
            end
            done <= 1;
        end else begin
            done <= 0;
        end
    end

endmodule
