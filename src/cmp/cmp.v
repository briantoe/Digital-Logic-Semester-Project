module cmp (gt, eq, lt, A, B, sign);

  output wire gt, eq, lt;
  input wire [15:0] A, B;
  input wire sign;
  wire diff_sign, invert;
  wire gt_hi, eq_hi, lt_hi;
  wire gt_lo, eq_lo, lt_lo;
  wire test_gt, test_lt;
  wire bus_gt, bus_lt;

  // invert the output if inputs have a different sign
  xor sign_check (diff_sign, A[15], B[15]);
  and invert_check (invert, sign, diff_sign);

  cmp_8b cmp_hi (gt_hi, eq_hi, lt_hi, A[15:8], B[15:8]);
  cmp_8b cmp_lo (gt_lo, eq_lo, lt_lo, A[7:0], B[7:0]);

  and and_gt (test_gt, eq_hi, gt_lo);
  and and_lt (test_lt, eq_hi, lt_lo);

  or or_gt (bus_gt, gt_hi, test_gt);
  or or_lt (bus_lt, lt_hi, test_lt);

  and and_eq (eq, eq_hi, eq_lo);

  xor invert_gt (gt, invert, bus_gt);
  xor invert_lt (lt, invert, bus_lt);

endmodule
