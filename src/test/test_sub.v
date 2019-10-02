module test ();

reg signed [15:0] A, B;
wire signed [15:0] out;
wire carry, over;

add sub_test (out, carry, over, A, B, 1'b1);

initial begin
  A <= 35;
  B <= 24;
  #10
  A <= 24;
  B <= 35;
  #10
  // A == 32767
  A <= {1'b0, {15{1'b1}}};
  // B == -1
  B <= {16{1'b1}};
end

initial begin
  $monitor("sub: %5d - %6d = %5d, carry = %1b, overflow = %1b", A, B, out, carry, over);
end

endmodule
