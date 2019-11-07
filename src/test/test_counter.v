module test ();

wire [15:0] out;
reg clk;
reg [15:0] data;
reg write;

counter counter_test (out, clk, data, write);

initial clk <= 1;
always #5 clk <= ~clk;

initial begin
  write <= 1'b1;
  data <= 16'b0;
  #10
  write <= 1'b0;
  #50
  write <= 1'b1;
  data <= {8'b1,8'b0};
  #10
  write <= 1'b0;
  #50
  $finish;
end

initial begin
  $monitor("counter: clk = %1b, data = %4d, write = %1b => out = %4d", clk, data, write, out);
end

endmodule
