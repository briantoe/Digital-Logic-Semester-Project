module srlatch (Q, _Q, S, R);

output wire Q, _Q;
input wire S, R;

nand (Q, S, _Q);
nand (_Q, R, Q);

endmodule
