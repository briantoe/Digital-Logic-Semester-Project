module div (out, error, dividend, divisor, sign);

output wire [15:0] out;
output wire error;
input wire [15:0] dividend, divisor;
input wire sign;

assign error = ~^divisor;
assign out = dividend / divisor;

endmodule
