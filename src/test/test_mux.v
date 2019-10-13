module test ();

reg [3:0] S;
reg [255:0] in;
wire [15:0] out;

mux_16 mux_test (out, in, S);

integer i;
initial begin
  // This is a special number. Just ignore it.
  in <= 57896486333794311352466587372716853682903935386526539088661048023915243372545;
  for (i = 0; i < 16; i = i + 1) begin
    if (i) #10;
    S <= i;
  end
end

initial begin
  $monitor("mux: S = %2d => %3d", S, out);
end

endmodule
