module mult (hi, lo, A, B);

output wire [15:0] hi, lo;
input wire [15:0] A, B;

wire [271:0] sum, carries;

assign sum[15:0] = 16'b0;
assign carries[15:0] = 16'b0;

generate
  genvar i;
  for (i = 0; i < 16; i = i + 1) begin
    assign lo[i] = sum[(16 * (i+1))];
    partial_mult u1 (sum[(16 * (i+1)) +: 16], carries[(16 * (i+1)) +: 16], A[15:0], B[i], sum[(16 * i) +: 16], carries[(16 * i) +: 16]);
  end
endgenerate

add u2 (.out(hi), .A({1'b0, sum[271:257]}), .B(carries[271:256]), .carry_in(1'b0));

endmodule
