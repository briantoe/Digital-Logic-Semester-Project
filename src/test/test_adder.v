module test ();

reg [15:0] A, B;
wire [15:0] out;
wire carry;

adder uut (out, carry, A, B, 1'b0);

initial begin
  A <= 25;
  B <= 32;
  #10;
  A <= 16'hffff;
  B <= 1'b1;
end

initial begin
  $monitor("add: %5d + %5d = %5d, carry = %1b", A, B, out, carry);
end

endmodule
