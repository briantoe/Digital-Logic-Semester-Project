module test_dec ();

reg [3:0] A;
wire [15:0] out;

dec dec_test (out, A);

integer i;
initial begin
  for (i = 0; i < 16; i = i + 1) begin
    if (i) #10;
    A <= i[3:0];
  end
end

initial begin
  $monitor("dec: %2d => %16b", A, out);
end

endmodule
