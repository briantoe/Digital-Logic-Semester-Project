module full_add (out, carry_out, A, B, carry_in);

output out, carry_out;
input A, B, carry_in;

wire bus_out, bus_carry1, bus_carry2;

or (carry_out, bus_carry1, bus_carry2);
half_add half_add_carry (bus_out, bus_carry1, A, B);
half_add half_add_out (out, bus_carry2, bus_out, carry_in);

endmodule
