module test ();

reg [15:0] A, B;
reg [3:0] ins;
wire signed [15:0] out, hi, lo;

alu alu_test (out, hi, lo, A, B, ins);

initial begin
  A <= 511;
  B <= 3;
  $display("alu: A = 511, B = 3");
  ins <= 1;
  #10
  ins <= 2;
  #10
  ins <= 3;
  #10
  ins <= 4;
  #10
  ins <= 5;
  #10
  ins <= 6;
  #10
  ins <= 7;
  #10
  ins <= 8;
  #10
  ins <= 9;
end

initial begin
  $monitor("alu: ins = %4b => out = %4d, hi = %4d, lo = %4d", ins, out, hi, lo);
end

endmodule
