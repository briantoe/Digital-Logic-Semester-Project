module test ();

reg [15:0] rom [0:65535];

wire syscall;
wire [15:0] pc;
wire [47:0] sysreg;
reg [15:0] ins;
reg clear, clk;

cpu #(1) cpu_test (
  .pc(pc),
  .clk(clk),
  .ins(ins),
  .clear(clear)
);

initial clk <= 0;
always #5 clk <= ~clk;

always @(posedge clk) begin
  ins <= rom[pc];
end

initial begin
  $display("Loading rom...");
  $readmemb("src/test/example.mem", rom);
  clear <= 1;
  #15
  clear <= 0;
end

endmodule
