module vga (activate, clear, write, addr, data);
parameter width = 120, height = 40;
integer i, video;

input wire activate, clear, write;
input wire [15:0] addr, data;

reg [7:0] vmem [0:width*height-1];

initial begin
  video = $fopenw("/dev/stdout");
  for (i = 0; i < width*height; i = i + 1) begin
    vmem[i] = 0;
  end
end

always @(posedge clear) begin
  for (i = 0; i < width*height; i = i + 1) begin
    vmem[i] <= 0;
  end
end

always @(posedge write) begin
  vmem[addr] <= data;
end

always @(posedge activate) begin
  $fwrite(video, "[?25l[2J[H[s");
  for (i = 0; i < width*height; i = i + 1) begin
    if (!(i % width)) $fwrite(video, "\n");
    case (vmem[i])
      0 : $fwrite(video, " ");
      1 : $fwrite(video, "█");
      2 : $fwrite(video, "┃");
      3 : $fwrite(video, "━");
      4 : $fwrite(video, "┳");
      5 : $fwrite(video, "┻");
      6 : $fwrite(video, "┏");
      7 : $fwrite(video, "┓");
      8 : $fwrite(video, "┛");
      9 : $fwrite(video, "┗");
    endcase
  end
  $fwrite(video, "[u[?25h");
end

endmodule
