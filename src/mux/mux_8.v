module mux_8 (out, in, sel);

output wire [15:0] out;
input wire [127:0] in;
input wire [2:0] sel;

wire [15:0] lo, hi;

mux_4 mux_hi (hi[15:0], in[127:64], sel[1:0]);
mux_4 mux_lo (lo[15:0], in[63:0], sel[1:0]);
mux mux_out (out[15:0], lo[15:0], hi[15:0], sel[2]);

endmodule
