module mux_8 (out, in, sel);

output wire [15:0] out;
input wire [127:0] in;
input wire [2:0] sel;

wire [15:0] lo, hi;

mux_4 mux_hi (hi, in[127:64], sel[1:0]);
mux_4 mux_lo (lo, in[63:0], sel[1:0]);
mux mux_out (out, lo, hi, sel[2]);

endmodule
