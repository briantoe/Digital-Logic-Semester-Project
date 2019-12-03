module partial_mul (out, carries_out, A, B, prev, carries_in);

output wire [15:0] out, carries_out;
input wire [15:0] A, prev, carries_in;
input wire B;

wire [15:0] partial;

and bit_multiply [15:0] (partial[15:0], A[15:0], {16{B}});
full_add adder [15:0] (out[15:0], carries_out[15:0], partial[15:0], {1'b0, prev[15:1]}, carries_in[15:0]);

endmodule
