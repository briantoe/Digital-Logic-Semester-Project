module mux (out, A, B, S);

parameter WIDTH = 16;

output wire [WIDTH-1:0] out;
input wire [WIDTH-1:0] A, B;
input wire S;

wire _S;
wire [WIDTH-1:0] bus1, bus2;

not (_S, S);
and and_A [WIDTH-1:0] (bus1[WIDTH-1:0], {WIDTH{_S}}, A[WIDTH-1:0]);
and and_B [WIDTH-1:0] (bus2[WIDTH-1:0], {WIDTH{S}}, B[WIDTH-1:0]);
or or_out [WIDTH-1:0] (out[WIDTH-1:0], bus1[WIDTH-1:0], bus2[WIDTH-1:0]);

endmodule
