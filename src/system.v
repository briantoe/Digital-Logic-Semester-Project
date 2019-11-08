module system ();
parameter debug = 0, file = "src/doom.mem";
integer stdout, i;

reg [15:0] mem [0:65535];

wire [15:0] pc;
wire syscall;
wire [47:0] sysregs;
reg clk, clear, load_signal;
reg [15:0] load_data, ins;

cpu #(debug) cpu_module (
  .pc(pc),
  .sys_signal(syscall),
  .sysregs(sysregs),
  .clk(clk),
  .ins(ins),
  .clear(clear),
  .load_signal(load_signal),
  .load_data(load_data)
);

initial clk <= 0;
always #5 clk <= ~clk;

always @(posedge clk) ins <= mem[pc];

initial begin
  if (debug) $display("Loading memory...");
  $readmemb(file, mem);
  stdout = $fopenw("/dev/stdout");
  load_signal <= 0;
  clear <= 1;
  #15
  clear <= 0;
end

always @(posedge syscall) begin
  if (sysregs[15:0] != 2) load_signal <= 0;
  case (sysregs[15:0])
    0 : $finish;
    1 : mem[sysregs[31:16]] <= sysregs[47:32];
    2 : begin
      load_signal <= 1;
      load_data <= mem[sysregs[31:16]];
    end
    3 : $fwrite(stdout, "%d", sysregs[31:16]);
    4 : $fwrite(stdout, "%c", sysregs[31:16]);
    5 : begin
      i = 0;
      $display("%5d, %c", sysregs[31:16], mem[sysregs[31:16]]);
      while (mem[sysregs[31:16]+i] != 0) begin
        $fwrite(stdout, "%c", mem[sysregs[31:16]+i]);
        i = i + 1;
      end
    end
  endcase
end

endmodule
