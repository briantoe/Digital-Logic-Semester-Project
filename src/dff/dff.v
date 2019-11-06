module dff (Q, _Q, data, write);

output wire Q, _Q;
input wire data, write;

wire S, _S, R, _R, bus_write;

and (bus_write, write, S);
srlatch latch_S (S, _S, write, _R);
srlatch latch_R (R, _R, bus_write, data);
srlatch latch_Q (Q, _Q, S, R);

endmodule
