module div(dividend,divisor, result, error, sign);
	input  [15:0] dividend,divisor;
    input sign;
	output error;
	output wire [15:0] result;
    // Checking if Divisor equal to zero
	//cmp cmpbzero(.eq(output), .A(divisor), .B(16'b0), .sign(sign));
    assign result = dividend / divisor;
endmodule
