module div(dividend,divisor, result, error, sign);
	output error;
	input [15:0] result;
	input  [15:0] dividend,divisor;
    input sign;
    reg [15:0] temp;
	wire gt, eq, lt;
	cmp cmpbzero(gt, eq, lt, divisor, 16'b0, sign);
	nand checkzero(error, eq, eq);
	always @(dividend or divisor)
	if (error == 0) begin
		temp <= dividend / divisor;
	end
    assign result = temp;
endmodule
