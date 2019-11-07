module counter (out, clk, data, write);

output wire [15:0] out;
input wire clk;
input wire [15:0] data;
input wire write;
	
wire [15:0] bus_mux, bus_add;

add increment (.out(bus_add), .A(out), .B(16'b1), .carry_in(1'b0));
mux load_mux (bus_mux, bus_add, data, write);
dff pc [15:0] (.Q(out), .data(bus_mux), .write({16{clk}}));

endmodule
