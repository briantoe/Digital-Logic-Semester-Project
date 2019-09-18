module shift (out, A, S, N);

output wire [15:0] out;
input wire [15:0] A;
input wire N, S;

wire [16:0] bus1, bus2;
assign bus1[16:1] = A[15:0];
assign bus1[0] = N;
assign bus2[15:0] = A[15:0];
assign bus2[16] = N;

mux u1 (out[15:0], bus1[15:0], bus2[16:1], S);

endmodule
