module cpu (pc, clk, ins, clear);
parameter debug = 0;

output wire [15:0] pc;
input wire clk, clear;
input wire [15:0] ins;

wire _clear, _clk;

wire [15:0] val_pc, val_0, val_1, val_2, val_3, val_4, val_ax, val_bx, val_cx,
  val_dx, val_ac, val_bp, val_hi, val_ai, val_bi, val_ci;
wire w_pc, w_0, w_1, w_2, w_3, w_4, w_ax, w_bx, w_cx, w_dx, w_ac, w_bp, w_hi, w_ai,
  w_bi, w_ci;
wire bus_w_pc, bus_w_0, bus_w_1, bus_w_2, bus_w_ax, bus_w_bx, bus_w_cx,
  bus_w_dx, bus_w_ac, bus_w_bp, bus_w_ai, bus_w_bi, bus_w_ci;
wire [1:0] bus_w_hi, bus_w_3, bus_w_4;
wire save_pc, save_0, save_1, save_2, save_3, save_4, save_ax,
  save_bx, save_cx, save_dx, save_ac, save_bp, save_hi, save_ai,
  save_bi, save_ci;

wire [3:0] op, dest, src1, src2;
wire [15:0] out, r0, r1, r2;

wire null_signal;
wire [3:0] bus_dest;

wire alu_signal, _alu_signal;
wire [15:0] alu_out;
wire [2:0] alu_flags;

wire sp_signal, jump_signal, call_signal;
wire jze_null, jnz_null;
wire zero, _zero;
wire [15:0] sp_out;

wire sys_signal, load_signal;
wire [15:0] load_val;

wire [15:0] bus_3, bus_4, pc_inc;

wire mult_signal;
wire [15:0] bus_hi, alu_hi;

wire [3:0] _op, bus_op;

initial if (debug) begin
  $monitor(
    "cpu:\tins = %16b, out = %16b\n\tpc = %5d\n\t 0 = %5d,  1 = %5d,  2 = %5d,  3 = %5d,  4 = %5d\n\tax = %5d, bx = %5d, cx = %5d, dx = %5d\n\tac = %5d, bp = %5d, hi = %5d\n\tai = %5d, bi = %5d, ci = %5d",
    ins, out,
    val_pc,
    val_0, val_1, val_2, val_3, val_4,
    val_ax, val_bx, val_cx, val_dx,
    val_ac, val_bp, val_hi,
    val_ai, val_bi, val_ci
  );
end

assign sysreg = {val_3, val_2, val_1};

assign op = ins[15:12];
assign dest = ins[11:8];
assign src1 = ins[7:4];
assign src2 = ins[3:0];

assign pc = val_pc;

not (_clk, clk);

counter reg_pc (.out(val_pc), .clk(_clk), .data(out), .write(bus_w_pc));

dff reg_0 [15:0] (.Q(val_0), .data(16'b0), .write(save_0));

dff reg_1 [15:0] (.Q(val_1), .data(out), .write(save_1));
dff reg_2 [15:0] (.Q(val_2), .data(out), .write(save_2));
dff reg_3 [15:0] (.Q(val_3), .data(bus_3), .write(save_3));
dff reg_4 [15:0] (.Q(val_4), .data(bus_4), .write(save_4));

dff reg_ax [15:0] (.Q(val_ax), .data(out), .write(save_ax));
dff reg_bx [15:0] (.Q(val_bx), .data(out), .write(save_bx));
dff reg_cx [15:0] (.Q(val_cx), .data(out), .write(save_cx));
dff reg_dx [15:0] (.Q(val_dx), .data(out), .write(save_dx));

dff reg_ac [15:0] (.Q(val_ac), .data(out), .write(save_ac));
dff reg_bp [15:0] (.Q(val_bp), .data(out), .write(save_bp));
dff reg_hi [15:0] (.Q(val_hi), .data(bus_hi), .write(save_hi));

dff reg_ai [15:0] (.Q(val_ai), .data(out), .write(save_ai));
dff reg_bi [15:0] (.Q(val_bi), .data(out), .write(save_bi));
dff reg_ci [15:0] (.Q(val_ci), .data(out), .write(save_ci));

and (save_pc, bus_w_pc, _clk);
and (save_0, bus_w_0, _clk);
and (save_ax, bus_w_ax, _clk);
and (save_bx, bus_w_bx, _clk);
and (save_cx, bus_w_cx, _clk);
and (save_dx, bus_w_dx, _clk);
and (save_ac, bus_w_ac, _clk);
and (save_bp, bus_w_bp, _clk);
and (save_hi, bus_w_hi[1], _clk);
and (save_1, bus_w_1, _clk);
and (save_2, bus_w_2, _clk);
and (save_3, bus_w_3[1], _clk);
and (save_4, bus_w_4[1], _clk);
and (save_ai, bus_w_ai, _clk);
and (save_bi, bus_w_bi, _clk);
and (save_ci, bus_w_ci, _clk);

or (bus_w_hi[1], bus_w_hi[0], mult_signal);
or (bus_w_3[1], bus_w_3[0], load_signal);
or (bus_w_4[1], bus_w_4[0], call_signal);

or (bus_w_pc, w_pc, clear);
or (bus_w_0, w_0, clear);
or (bus_w_ax, w_ax, clear);
or (bus_w_bx, w_bx, clear);
or (bus_w_cx, w_cx, clear);
or (bus_w_dx, w_dx, clear);
or (bus_w_ac, w_ac, clear);
or (bus_w_bp, w_bp, clear);
or (bus_w_hi[0], w_hi, clear);
or (bus_w_1, w_1, clear);
or (bus_w_2, w_2, clear);
or (bus_w_3[0], w_3, clear);
or (bus_w_4[0], w_4, clear);
or (bus_w_ai, w_ai, clear);
or (bus_w_bi, w_bi, clear);
or (bus_w_ci, w_ci, clear);

dec dest_dec (
  { w_pc, w_ci, w_bi, w_ai, w_4, w_3, w_2, w_1, w_hi, w_bp, w_ac, w_dx, w_cx,
    w_bx, w_ax, w_0 },
  bus_dest
);

mux_16 r0_mux (
  r0,
  { val_pc, val_ci, val_bi, val_ai, val_4, val_3, val_2, val_1, val_hi,
    val_bp, val_ac, val_dx, val_cx, val_bx, val_ax, val_0 },
  bus_dest
);

mux_16 r1_mux (
  r1,
  { val_pc, val_ci, val_bi, val_ai, val_4, val_3, val_2, val_1, val_hi,
    val_bp, val_ac, val_dx, val_cx, val_bx, val_ax, val_0 },
  src1
);

mux_16 r2_mux (
  r2,
  { val_pc, val_ci, val_bi, val_ai, val_4, val_3, val_2, val_1, val_hi,
    val_bp, val_ac, val_dx, val_cx, val_bx, val_ax, val_0 },
  src2
);

not invert_op [3:0] (_op, op);
or (bus_op[0], op[1], op[2]);
or (bus_op[1], op[0], bus_op[0]);
and (bus_op[2], _op[3], bus_op[1]);
and (bus_op[3], op[3], _op[2], _op[1]);

not (zero, _zero);
or (
  _zero,
  r2[0], r2[1], r2[2], r2[3], r2[4], r2[5], r2[6], r2[7], r2[8], r2[9],
  r2[10], r2[11], r2[12], r2[13], r2[14], r2[15]
);

add pc_add (.out(pc_inc), .A(val_pc), .B(16'b1), .carry_in(1'b0));

not (_clear, clear);
not (_alu_signal, alu_signal);
or (alu_signal, bus_op[2], bus_op[3]);
and (mult_signal, alu_signal, op[0], op[1], _clear);
and (sp_signal, _alu_signal, bus_op[0]);
and (jump_signal, sp_signal, _op[2], op[1]);
and (call_signal, op[3], op[2], _op[1], _op[0], _clear);
and (sys_signal, op[3], op[2], _op[1], op[0]);
and (jze_null, jump_signal, _op[0], _zero);
and (jnz_null, jump_signal, op[0], zero);
or (null_signal, sys_signal, jze_null, jnz_null);

mux #(4) dest_mux (bus_dest, dest, 4'b0, null_signal);
mux hi_mux (bus_hi, out, alu_hi, mult_signal);
mux reg3_mux (bus_3, out, load_val, load_signal);
mux reg4_mux (bus_4, out, pc_inc, call_signal);
mux_4 out_mux (out, {32'b0, alu_out, sp_out}, {clear, alu_signal});

alu alu_module (
  .out(alu_out),
  .flags(alu_flags),
  .hi(alu_hi),
  .A(r1),
  .B(r2),
  .ins(op)
);

mux_8 sp_mux (
  sp_out,
  { {ins[7:0], r0[7:0]}, {8'b0, ins[7:0]}, 16'b0, {3{r1}}, 32'b0 },
  op[2:0]
);

syscall sys_module (load_signal, load_val, sys_signal, {val_3, val_2, val_1});

endmodule
