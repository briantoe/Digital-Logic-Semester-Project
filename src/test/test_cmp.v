/*
    VHDL Software: iVerilog
    Source: http://iverilog.icarus.com/
*/

module test();

  wire gt, eq, lt;
  reg signed [15:0] A, B;
  reg sign;

  cmp cmp_test (gt, eq, lt, A, B, sign);

  initial begin
    sign <= 1;
    A <= 1;
    B <= 2;
    #10
    A <= 2;
    B <= 1;
    #10
    A <= 1;
    B <= 1;
    #10
    A <= 256;
    B <= 257;
    #10
    A <= 257;
    B <= 256;
    #10
    A <= 256;
    B <= 256;
    #10
    A <= 2;
    B <= -1;
    #10
    A <= -1;
    B <= 2;
    #10
    A <= 257;
    B <= -256;
    #10
    A <= -256;
    B <= 257;
    #10
    A <= -256;
    B <= -257;
    #10
    A <= -257;
    B <= -256;
  end

  initial begin
    $monitor("cmp: A = %5d, B = %5d\nG | E | L\n%1b | %1b | %1b", A, B, gt, eq, lt);
  end

endmodule
