module adder (out, carry_out, A, B, carry_in);

output wire [15:0] out;
output wire carry_out;
input wire [15:0] A, B;
input wire carry_in;

wire [16:0] bus_carry;
assign bus_carry[0] = carry_in;
assign carry_out = bus_carry[16];

full_adder u1 [15:0] (out[15:0], bus_carry[16:1], A[15:0], B[15:0], bus_carry[15:0]);

endmodule
