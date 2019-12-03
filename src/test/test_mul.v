module test();

reg signed [15:0] A, B;
wire signed [15:0] hi, lo;

mul mul_test (hi, lo, A, B);

initial begin
  A <= 12;
  B <= 15;
  #10
  A <= -12;
  B <= 15;
  #10
  A <= -12;
  B <= -15;
end

initial begin
  $monitor("mul: %5d * %5d = (hi = %5d, lo = %5d)", A, B, hi, lo);
end

endmodule
