module div (out, error, dividend, divisor);

output wire [15:0] out;
output wire error;
input wire [15:0] dividend, divisor;

assign error = ~|divisor;
assign out = dividend / divisor;

endmodule
