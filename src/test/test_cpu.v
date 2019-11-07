module test ();

reg [15:0] rom [0:65535];

wire [15:0] ins_addr;
reg [15:0] ins;
reg clear, clk;

cpu #(1) cpu_test (ins_addr, clk, ins, clear);

initial clk <= 0;
always #5 clk <= ~clk;

always @(posedge clk) begin
  ins <= rom[ins_addr];
end

initial begin
  $display("Loading rom...");
  $readmemb("src/test/gcd.mem", rom);
  clear <= 1;
  #15
  clear <= 0;
end

endmodule
