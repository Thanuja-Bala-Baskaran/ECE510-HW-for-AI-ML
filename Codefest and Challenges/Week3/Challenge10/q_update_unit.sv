module q_update_unit #(
  parameter STATE_BITS = 4,
  parameter ACTION_BITS = 2,
  parameter DATA_WIDTH = 16 // Q4.12 fixed-point
)(
  input logic clk,
  input logic rst,
  input logic start,
  input logic [STATE_BITS-1:0] state,
  input logic [ACTION_BITS-1:0] action,
  input logic [STATE_BITS-1:0] new_state,
  input logic signed [DATA_WIDTH-1:0] reward,
  input logic signed [DATA_WIDTH-1:0] alpha,
  input logic signed [DATA_WIDTH-1:0] gamma,
  output logic done
);

  logic signed [DATA_WIDTH-1:0] q_table [0:63];
  logic signed [DATA_WIDTH-1:0] q_sa;
  logic signed [DATA_WIDTH-1:0] q_next [0:3];
  logic signed [DATA_WIDTH-1:0] max_q_next;
  logic signed [DATA_WIDTH-1:0] target, delta, update, new_q;

  typedef enum logic [2:0] { IDLE, READ_Q, COMPUTE_MAX, CALC_DELTA, WRITE_BACK, DONE } state_t;
  state_t current_state, next_state;

  always_ff @(posedge clk or posedge rst) begin
    if (rst) current_state <= IDLE;
    else current_state <= next_state;
  end

  always_comb begin
    case (current_state)
      IDLE:        next_state = start ? READ_Q : IDLE;
      READ_Q:      next_state = COMPUTE_MAX;
      COMPUTE_MAX: next_state = CALC_DELTA;
      CALC_DELTA:  next_state = WRITE_BACK;
      WRITE_BACK:  next_state = DONE;
      DONE:        next_state = IDLE;
    endcase
  end

  always_ff @(posedge clk) begin
    if (rst) done <= 0;
    else case (current_state)
      READ_Q: begin
        q_sa <= q_table[{state, action}];
        q_next[0] <= q_table[{new_state, 2'b00}];
        q_next[1] <= q_table[{new_state, 2'b01}];
        q_next[2] <= q_table[{new_state, 2'b10}];
        q_next[3] <= q_table[{new_state, 2'b11}];
      end
      COMPUTE_MAX: begin
        max_q_next <= q_next[0];
        if (q_next[1] > max_q_next) max_q_next <= q_next[1];
        if (q_next[2] > max_q_next) max_q_next <= q_next[2];
        if (q_next[3] > max_q_next) max_q_next <= q_next[3];
      end
      CALC_DELTA: begin
        target <= reward + ((gamma * max_q_next) >>> 12);
        delta  <= target - q_sa;
        update <= (alpha * delta) >>> 12;
        new_q  <= q_sa + update;
      end
      WRITE_BACK: begin
        q_table[{state, action}] <= new_q;
      end
      DONE: done <= 1;
      default: done <= 0;
    endcase
  end

endmodule
