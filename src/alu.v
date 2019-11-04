module alu (out, hi, lo, A, B, ins);

output wire [15:0] out, hi, lo;
input wire [15:0] A, B;
input wire [3:0] ins;

wire bus_gt, bus_eq, bus_lt;
wire [15:0] bus_add;
wire [15:0] bus_sub;
wire [15:0] bus_div;
wire [15:0] bus_cmp;
wire [15:0] bus_or;
wire [15:0] bus_and;
wire [15:0] bus_not;
wire [15:0] bus_xor;

add add_module (.out(bus_add), .A(A), .B(B), .carry_in(1'b0));
add sub_module (.out(bus_sub), .A(A), .B(B), .carry_in(1'b1));
mult mul_module (.hi(hi), .lo(lo), .A(A), .B(B));
div div_module (.out(bus_div), .dividend(A), .divisor(B));
cmp cmp_module (.gt(bus_gt), .eq(bus_eq), .lt(bus_lt), .A(A), .B(B), .sign(1'b1));

mux_8 cmp_conversion (
  bus_cmp,
  {
  48'b0,
  {15'b0,1'b1},
  32'b0,
  16'b1,
  16'b0
  },
  {bus_gt, bus_eq, bus_lt}
);

or or_module [15:0] (bus_or[15:0], A[15:0], B[15:0]);
and and_module [15:0] (bus_and[15:0], A[15:0], B[15:0]);
not not_module [15:0] (bus_not[15:0], A[15:0]);
xor xor_module [15:0] (bus_xor[15:0], A[15:0], B[15:0]);

mux_16 out_module (
  out,
  {
  96'b0,
  bus_cmp[15:0],
  bus_xor[15:0],
  bus_not[15:0],
  bus_and[15:0],
  bus_or[15:0],
  bus_div[15:0],
  lo[15:0],
  bus_sub[15:0],
  bus_add[15:0],
  16'b0
  },
  ins
);

endmodule
