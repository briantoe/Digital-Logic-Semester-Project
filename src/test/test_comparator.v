/*
    VHDL Software: iVerilog
    Source: http://iverilog.icarus.com/
*/

module test();

  wire great, equal, less;
  reg [15:0] a; 
  reg [15:0] b;
  
  comparator_16b comparator_test(great, equal, less, a, b);
  
  initial begin
    a <= 60000;
    b <= 60000;
    #10
    a <= 5000;
    b <= 4001;
    #10
    a <= 2;
    b <= 4;
  end

  initial begin
    //$display("G | E | L");
    //$display("--|---|--");
    // is A greater, equal to, or less than B?
    $monitor("comparator: A = %5d, B = %5d\nG | E | L\n%1b | %1b | %1b", a, b, great, equal, less);

    // $monitor("%1b | %1b | %1b", great, equal, less);  
  end

endmodule