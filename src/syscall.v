module syscall (load_signal, load_data, activate, sysreg);
integer stdout, i;

output reg load_signal;
output reg [15:0] load_data;
input wire activate;
input wire [47:0] sysreg;

reg [15:0] ram [0:65535];

initial begin
  stdout = $fopenw("/dev/stdout");
  load_signal <= 0;
end

always @(posedge activate) begin
  if (sysreg[15:0] != 2) load_signal <= 0;
  case (sysreg[15:0])
    0 : $finish;
    1 : ram[sysreg[31:16]] <= sysreg[47:32];
    2 : begin
      load_signal <= 1;
      load_data <= ram[sysreg[31:16]];
    end
    3 : $fwrite(stdout, "%d", sysreg[31:16]);
    4 : $fwrite(stdout, "%c", sysreg[31:16]);
    5 : begin
      i = 0;
      while (ram[sysreg[31:16]+i] != 0) begin
        $fwrite(stdout, "%c", ram[sysreg[31:16]+i]);
        i = i + 1;
      end
    end
  endcase
end

endmodule
