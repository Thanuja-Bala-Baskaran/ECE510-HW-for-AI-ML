module log_compression #(
    parameter N_FILTERS = 40,
    parameter IN_WIDTH = 28,
    parameter OUT_WIDTH = 6
)(
    input clk,
    input rst,
    input start,
    input [IN_WIDTH*N_FILTERS-1:0] in_energy_flat,
    output reg [OUT_WIDTH*N_FILTERS-1:0] log_energy_flat,
    output reg done
);

    integer i, j;
    reg [IN_WIDTH-1:0] in_energy [0:N_FILTERS-1];
    reg [OUT_WIDTH-1:0] log_energy [0:N_FILTERS-1];

    // Flattened input → unpack
    always @(*) begin
        for (i = 0; i < N_FILTERS; i = i + 1)
            in_energy[i] = in_energy_flat[(i+1)*IN_WIDTH-1 -: IN_WIDTH];
    end

    // Main logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            done <= 0;
        end else if (start) begin
			$display("entered log compression");
            for (i = 0; i < N_FILTERS; i = i + 1) begin
                log_energy[i] = 0;
                for (j = IN_WIDTH-1; j >= 0; j = j - 1) begin
                    if (in_energy[i][j] == 1'b1 && log_energy[i] == 0)
                        log_energy[i] = j[OUT_WIDTH-1:0];
                end
            end

            // Pack log_energy back into flat output
            for (i = 0; i < N_FILTERS; i = i + 1)
                log_energy_flat[(i+1)*OUT_WIDTH-1 -: OUT_WIDTH] = log_energy[i];

            done <= 1;
        end else begin
            done <= 0;
        end
    end

endmodule
