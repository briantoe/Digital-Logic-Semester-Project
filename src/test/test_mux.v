module test ();

reg S;
reg [15:0] A, B;
wire [15:0] out;

mux uut (out, A, B, S);

initial begin
  A <= 10;
  B <= 20;
  S <= 1'b0;
  #10;
  S <= 1'b1;
end

initial begin
  $monitor("mutex: %2d, %2d (S = %1b) => %2d", A, B, S, out);
end

endmodule
