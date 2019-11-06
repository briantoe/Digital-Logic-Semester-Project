module test ();

reg data, write;
wire Q, _Q;

dff dff_test (Q, _Q, data, write);

initial begin
  data <= 1;
  write <= 0;
  #10
  write <= 1;
  #10
  write <= 0;
  #10
  data <= 0;
  #10
  write <= 1;
  #10
  write <= 0;
  #10
  write <= 1;
  data <= 1;
  #10;
end

initial begin
  $monitor("dff: data = %1b, write = %1b => Q = %1b", data, write, Q);
end

endmodule
