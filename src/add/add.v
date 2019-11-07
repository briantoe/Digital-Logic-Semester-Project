module add (out, carry_out, overflow, A, B, carry_in);

output wire [15:0] out;
output wire carry_out, overflow;
input wire [15:0] A, B;
input wire carry_in;

wire [15:0] _B;
wire [16:0] bus_carry;

assign sign_A = A[15];
assign sign_B = _B[15];
assign sign_out = out[15];
assign bus_carry[0] = carry_in;
assign carry_out = bus_carry[16];

xor (overflow, bus_carry[16], bus_carry[15]);
xor invert_B [15:0] (_B[15:0], B[15:0], {16{carry_in}});
full_add full_adders [15:0] (out[15:0], bus_carry[16:1], A[15:0], _B[15:0], bus_carry[15:0]);

endmodule
