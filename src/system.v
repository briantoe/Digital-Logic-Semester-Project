module system ();
parameter debug = 0, program = "doom.mem", width = 150, height = 50;
integer i, stdout;

reg [15:0] mem [0:65535];

wire [15:0] pc;
wire syscall;
wire [47:0] sysregs;
reg clk, clear, load_signal, video_activate, video_clear, video_write;
reg [15:0] load_data, video_addr, video_data, ins;

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

vga #(.width(width), .height(height)) vga_module (
  .activate(video_activate),
  .clear(video_clear),
  .write(video_write),
  .addr(video_addr),
  .data(video_data)
);

initial clk <= 0;
always #5 clk <= ~clk;

always @(posedge clk) ins <= mem[pc];

initial begin
  if (debug) $display("Loading memory...");
  $readmemb(program, mem);
  stdout = $fopenw("/dev/stdout");
  load_signal <= 0;
  video_activate <= 0;
  video_clear <= 0;
  video_write <= 0;
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
      while (mem[sysregs[31:16]+i] != 0) begin
        $fwrite(stdout, "%c", mem[sysregs[31:16]+i]);
        i = i + 1;
      end
    end
    6 : begin
      video_activate <= 1;
      #5
      video_activate <= 0;
    end
    7 : begin
      video_clear <= 1;
      #5
      video_clear <= 0;
    end
    8 : begin
      video_addr <= sysregs[31:16];
      video_data <= sysregs[47:32];
      video_write <= 1;
      #5
      video_write <= 0;
    end
  endcase
end

endmodule
