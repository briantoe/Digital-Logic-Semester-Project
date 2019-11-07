module halt (activate, value);

input wire activate;
input wire [15:0] value;

always @(posedge activate) begin
  if (value == 0) begin
    $finish;
  end
end

endmodule
