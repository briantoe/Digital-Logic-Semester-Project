/*
    VHDL Software: iVerilog
    Source: http://iverilog.icarus.com/
*/
module comparator_1b(A_greater_B, A_equal_B, A_less_B, A, B);

  output wire A_greater_B, A_equal_B, A_less_B;
  input wire A, B;
  
  wire not_A, not_B;
  
  not nA(not_A, A);
  not nB(not_B, B);
  
  and and_great(A_greater_B, A, not_B);
  and and_less(A_less_B, not_A, B);
  xnor xnor_eq(A_equal_B, A, B);

endmodule