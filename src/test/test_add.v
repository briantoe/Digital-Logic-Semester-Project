module test ();

reg [15:0] A, B;
wire [15:0] out;
wire carry, over;

add add_test (out, carry, over, A, B, 1'b0, 1'b0);

initial begin
  A <= 25;
  B <= 32;
  #10
  // A == 65535.
  A <= {16{1'b1}};
  B <= 16'b1;
  #10
  A <= {1'b0, {15{1'b1}}};
  B <= 16'b1;
end

initial begin
  $monitor("add: %5d + %5d = %5d, carry = %1b, overflow = %1b", A, B, out, carry, over);
end

endmodule
