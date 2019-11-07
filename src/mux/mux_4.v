module mux_4 (out, in, sel);

output wire [15:0] out;
input wire [63:0] in;
input wire [1:0] sel;

wire [15:0] lo, hi;

mux mux_hi (hi, in[47:32], in[63:48], sel[0]);
mux mux_lo (lo, in[15:0], in[31:16], sel[0]);
mux mux_out (out, lo, hi, sel[1]);

endmodule
