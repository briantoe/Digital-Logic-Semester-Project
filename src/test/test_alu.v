module test ();

reg [15:0] A, B;
reg [3:0] ins;
wire signed [15:0] out, hi;
wire [2:0] flags;

alu alu_test (out, flags, hi, A, B, ins);

initial begin
  A <= 3;
  B <= 511;
  $display("alu: A = 3, B = 511");
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
  $monitor("alu: ins = %4b => out = %4d, flags = %3b, hi = %4d", ins, out, flags, hi);
end

endmodule
