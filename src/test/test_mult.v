module test();

reg [15:0] A, B;
wire [15:0] hi, lo;

mult mult_test (hi, lo, A, B);

initial begin
  A <= 12;
  B <= 63;
  #10
  A <= 32768;
  B <= 2;
  #10
  A <= 65535;
  B <= 65535;
end

initial begin
  $monitor("mult: %5d * %5d = (hi = %5d, lo = %5d)", A, B, hi, lo);
end

endmodule
