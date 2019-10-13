module cmp_2b (gt, eq, lt, A, B);

  output wire gt, eq, lt;
  input wire [1:0] A, B;

  wire gt_hi, eq_hi, lt_hi;
  wire gt_lo, eq_lo, lt_lo;
  wire test_gt, test_lt;

  cmp_1b cmp_hi (gt_hi, eq_hi, lt_hi, A[1], B[1]);
  cmp_1b cmp_lo (gt_lo, eq_lo, lt_lo, A[0], B[0]);

  and and_gt (test_gt, eq_hi, gt_lo);
  and and_lt (test_lt, eq_hi, lt_lo);

  or or_gt (gt, gt_hi, test_gt);
  or or_lt (lt, lt_hi, test_lt);

  and and_eq (eq, eq_hi, eq_lo);

endmodule
