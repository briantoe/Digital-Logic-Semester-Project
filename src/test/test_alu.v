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
  $display("ins | out| flags| hi||add|sub  | mul|div| or|and|not  |xor|cmp");
  $monitor("%4b|%4d|%6d|%3d||%3d|%3d|%3d|%3d|%3d|%3d|%3d|%3d|%3d", 
    ins,
    out,
    flags,
    hi,
    alu_test.add_module.out,
    alu_test.sub_module.out,
    alu_test.mul_module.lo,
    alu_test.div_module.out,
    alu_test.bus_or,
    alu_test.bus_and,
    alu_test.bus_not,
    alu_test.bus_xor,
    alu_test.cmp_conversion.out
  );
end

endmodule
