module mux (out, A, B, S);

output wire [15:0] out;
input wire [15:0] A, B;
input wire S;

wire _S;
wire [15:0] bus1, bus2;

not (_S, S);
and u1 [15:0] (bus1[15:0], {16{_S}}, A[15:0]);
and u2 [15:0] (bus2[15:0], {16{S}}, B[15:0]);
or u3 [15:0] (out[15:0], bus1[15:0], bus2[15:0]);

endmodule
