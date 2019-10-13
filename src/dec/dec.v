module dec (out, in);

output wire [15:0] out;
input wire [3:0] in;

wire _in_msb;

not (_in_msb, in[3]);

dec_3x8 lower (out[7:0], in[2:0], _in_msb);
dec_3x8 upper (out[15:8], in[2:0], in[3]);

endmodule
