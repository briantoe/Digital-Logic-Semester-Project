module dec_3x8 (out, in, E);

output wire [7:0] out;
input wire [2:0] in;
input wire E;

wire [2:0] _in;

not not_in [2:0] (_in[2:0], in[2:0]);

and (out[0], _in[2], _in[1], _in[0], E);
and (out[1], _in[2], _in[1], in[0], E);
and (out[2], _in[2], in[1], _in[0], E);
and (out[3], _in[2], in[1], in[0], E);
and (out[4], in[2], _in[1], _in[0], E);
and (out[5], in[2], _in[1], in[0], E);
and (out[6], in[2], in[1], _in[0], E);
and (out[7], in[2], in[1], in[0], E);

endmodule
