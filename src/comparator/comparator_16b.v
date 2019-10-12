/*
    VHDL Software: iVerilog
    Source: http://iverilog.icarus.com/
*/

module comparator_16b(A_greater_B, A_equal_B, A_less_B, A, B, if_neg);

  output wire A_greater_B, A_equal_B, A_less_B;
  input wire [15:0] A, B; // input 4 bit numbers
  input wire if_neg; // negative signal

  wire same_sign, negate_sig;

  xor same_checker(same_sign, A[15], B[15]); // same_sign is assigned 1 if they are not the same sign, 0 if they are the same sign
  and negate_checker(negate_sig, if_neg, same_sign); // and the negative signal and the same_sign signal. negate_sig is 1 if both numbers are negative.
                                      // want to negate the greater than and less than outputs
                            
  wire great0, equal0, less0; // outputs of comparator 0
  wire great1, equal1, less1; // outputs of comparator 1
  
  comparator_8b c0(great0, equal0, less0, A[15:8], B[15:8]);
  comparator_8b c1(great1, equal1, less1, A[7:0], B[7:0]);
  
  wire a1, a3; // buses for AND outputs
               // a2 is just A_equal_B

  // AND operations
  and and1(a1, equal0, great1);
  and and2(A_equal_B, equal0, equal1);
  and and3(a3, equal0, less1);
  
  wire int1, int2; // intermediary wires for output

  or less(int1, less0, a3); // less output
  or great(int2, great0, a1); // great output

  xor final_less(A_less_B, negate_sig, int1);
  xor final_great(A_greater_B, negate_sig, int2);



endmodule