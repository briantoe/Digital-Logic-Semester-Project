module mux_16 (out, in, sel);

output wire [15:0] out;
input wire [255:0] in;
input wire [3:0] sel;

wire [15:0] lo, hi;

mux_8 mux_hi (hi, in[255:128], sel[2:0]);
mux_8 mux_lo (lo, in[127:0], sel[2:0]);
mux mux_out (out, lo, hi, sel[3]);

endmodule
