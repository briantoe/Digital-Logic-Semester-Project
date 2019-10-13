module alu (clk, out, A, B, ins);

input wire clk;

output reg [15:0] out;
input wire [15:0] A, B;
input wire [3:0] ins;

wire [15:0] ins_hot;
wire [15:0] bus_add;
wire [15:0] bus_mul_hi;
wire [15:0] bus_mul_lo;
wire [15:0] bus_cmp;

dec ins_decode (ins_hot, ins);
add add_module (.out(bus_add), .A(A), .B(B), 1'b0);
mult mul_module (.hi(bus_mul_hi), .lo(bus_mul_lo), .A(A), .B(B));

always @(posedge clk) begin
end

endmodule
