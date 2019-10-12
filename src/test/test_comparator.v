/*
    VHDL Software: iVerilog
    Source: http://iverilog.icarus.com/
*/

module test();

  wire great, equal, less;
  reg signed [15:0] a, b; 
  // reg [15:0] b;
  // reg [15:0] neg_a, neg_b;
  reg negative_sig;
  
  comparator_16b comparator_test(great, equal, less, a, b, negative_sig);
  
  initial begin
    a <= 60000;
    b <= 60000;
    negative_sig <= 0;
    #10
    a <= 5000;
    b <= 4001;
    negative_sig <= 0;
    #10
    a <= 3;
    b <= 4;
    negative_sig <= 0;
    #10
    a <= 32767;
    b <= -32768;
    negative_sig <= 1;
  end

  initial begin
    //$display("G | E | L");
    //$display("--|---|--");
    // is A greater, equal to, or less than B?
    $monitor("comparator: A = %5d, B = %5d\nG | E | L\n%1b | %1b | %1b", a, b, great, equal, less);

    // $monitor("%1b | %1b | %1b", great, equal, less);  
  end

endmodule