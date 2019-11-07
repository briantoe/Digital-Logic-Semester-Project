module alu (out, flags, hi, A, B, ins);

output wire [15:0] out, hi;
output wire [2:0] flags;
input wire [15:0] A, B;
input wire [3:0] ins;

wire [3:0] _ins;
wire add_signal, sub_signal, div_signal;
wire [1:0] bus_add_flags, bus_sub_flags, bus_carry, bus_overflow;
wire bus_div_flag, bus_gt, bus_eq, bus_lt;
wire [15:0] bus_add, bus_sub, bus_lo, bus_div, bus_cmp, bus_or, bus_and,
  bus_not, bus_xor;

add add_module (.out(bus_add), .carry_out(bus_carry[0]), .overflow(bus_overflow[0]),
                .A(A), .B(B), .carry_in(1'b0));
add sub_module (.out(bus_sub), .carry_out(bus_carry[1]), .overflow(bus_overflow[1]),
                .A(A), .B(B), .carry_in(1'b1));
mult mul_module (.hi(hi), .lo(bus_lo), .A(A), .B(B));
div div_module (.out(bus_div), .error(bus_div_flag), .dividend(A), .divisor(B));
cmp cmp_module (.gt(bus_gt), .eq(bus_eq), .lt(bus_lt), .A(A), .B(B), .sign(1'b1));

mux_8 cmp_conversion (
  bus_cmp,
  { 48'b0, 16'b1, 32'b0, {16{1'b1}}, 16'b0 },
  {bus_gt, bus_eq, bus_lt}
);

or or_module [15:0] (bus_or, A, B);
and and_module [15:0] (bus_and, A, B);
not not_module [15:0] (bus_not, A);
xor xor_module [15:0] (bus_xor, A, B);

not not_ins [3:0] (_ins[3:0], ins[3:0]);
and (add_signal, _ins[3], _ins[2], _ins[1], ins[0]);
and (sub_signal, _ins[3], _ins[2], ins[1], _ins[0]);
and (div_signal, _ins[3], ins[2], _ins[1], _ins[0]);

and (bus_add_flags[0], bus_carry[0], add_signal);
and (bus_add_flags[1], bus_overflow[0], add_signal);
and (bus_sub_flags[0], bus_carry[1], sub_signal);
and (bus_sub_flags[1], bus_overflow[1], sub_signal);

or (flags[0], bus_add_flags[0], bus_sub_flags[0]);
or (flags[1], bus_add_flags[1], bus_sub_flags[1]);
and (flags[2], bus_div_flag, div_signal);

mux_16 out_module (
  out,
  { 96'b0, bus_cmp, bus_xor, bus_not, bus_and, bus_or, bus_div, bus_lo,
    bus_sub, bus_add, 16'b0 },
  ins
);

endmodule
