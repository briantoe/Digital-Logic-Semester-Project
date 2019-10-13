module cmp_1b (gt, eq, lt, A, B);

  output wire gt, eq, lt;
  input wire A, B;

  wire _A, _B;

  not not_A (_A, A);
  not not_B (_B, B);

  and and_gt (gt, A, _B);
  and and_lt (lt, _A, B);
  xnor xnor_eq (eq, A, B);

endmodule
