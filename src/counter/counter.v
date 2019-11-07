module counter(out, load_data, load, clk);
	input wire clk;
	output wire[0:15] out;
	input wire load;
	input wire [0:15] load_data;
	
	wire [0:15] dff_out, mux_out, adder_out;
	
	//dang, i guess I can't do that
	//dff [0:15] flops (.Q(dff_out), ._Q(), .data(mux_out), .write({16{clk}}));
	//dff flop (.Q(), ._Q(), .data(), .write());
	
	genvar i;
	generate
		for (i=0; i < 16; i=i+1) begin: dff_maker
			dff flopper (.Q(dff_out[i]), .data(mux_out[i]), .write(clk));
		end
	endgenerate
	
	add incr (.out(adder_out), .carry_out(), .overflow(), .A(dff_out), .B(16'b0), .carry_in(1'b1));
	mux load_mux (mux_out, adder_out, load_data, load);
endmodule