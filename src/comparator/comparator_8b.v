/*
    VHDL Software: iVerilog
    Source: http://iverilog.icarus.com/
*/
module comparator_8b(A_greater_B, A_equal_B, A_less_B, A, B);

  output wire A_greater_B, A_equal_B, A_less_B;
  input wire [7:0] A, B; // input 8 bit numbers
  
  wire great0, equal0, less0; // outputs of comparator 0
  wire great1, equal1, less1; // outputs of comparator 1
  
  comparator_4b c0(great0, equal0, less0, A[7:4], B[7:4]);
  comparator_4b c1(great1, equal1, less1, A[3:0], B[3:0]);
  
  wire a1, a3; // buses for AND outputs
               // a2 is just A_equal_B
  
  // AND operations
  and and1(a1, equal0, great1);
  and and2(A_equal_B, equal0, equal1);
  and and3(a3, equal0, less1);
  
  or less(A_less_B, less0, a3);
  or great(A_greater_B, great0, a1);


endmodule
