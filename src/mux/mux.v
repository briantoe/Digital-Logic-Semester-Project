module mux (out, A, B, sel);
parameter width = 16;

output wire [width-1:0] out;
input wire [width-1:0] A, B;
input wire sel;

wire _sel;
wire [width-1:0] bus1, bus2;

not (_sel, sel);
and and_A [width-1:0] (bus1, {width{_sel}}, A);
and and_B [width-1:0] (bus2, {width{sel}}, B);
or or_out [width-1:0] (out, bus1, bus2);

endmodule
