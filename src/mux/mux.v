module mux (out, A, B, sel);

output wire [15:0] out;
input wire [15:0] A, B;
input wire sel;

wire _sel;
wire [15:0] bus1, bus2;

not (_sel, sel);
and and_A [15:0] (bus1[15:0], {16{_sel}}, A[15:0]);
and and_B [15:0] (bus2[15:0], {16{sel}}, B[15:0]);
or or_out [15:0] (out[15:0], bus1[15:0], bus2[15:0]);

endmodule
