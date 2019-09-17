module test ();

reg S;
reg [15:0] A;
wire [15:0] out;

shift uut (out, A, S);

initial begin
  A <= 32;
  S <= 1'b0;
  #10
  S <= 1'b1;
end

initial begin
  $monitor("shift: %2d (S = %1b) = %3d", A, S, out);
end

endmodule
