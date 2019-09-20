module half_add (out, carry, A, B);

output out, carry;
input A, B;

xor (out, A, B);
and (carry, A, B);

endmodule
