module test();
    wire error;
    reg signed [15:0] A,B, result;
    reg sign = 1;


    div div_test(A,B, result, error, sign);
    initial begin
        sign <= 0;
        A <= 100;
        B <= 2;
        #10
        A <= 8;
        B <= 4;
        #10;
        A <= 10;
        B <= 0;
        #10;
    end

    initial begin
        $monitor("div: divisor = %5d, dividend =  %5d\nresult | error\n%16b | %16b ", A, B, result, error);
    end
    endmodule
