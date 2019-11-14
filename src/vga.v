module vga (activate, clear, write, addr, data);
parameter width = 150, height = 50;
integer i, video;

input wire activate, clear, write;
input wire [15:0] addr, data;

reg [15:0] vmem [0:width*height-1];

initial begin
  video = $fopenw("/dev/stdout");
  for (i = 0; i < width*height; i = i + 1) begin
    vmem[i] = 32;
  end
end

always @(posedge clear) begin
  for (i = 0; i < width*height; i = i + 1) begin
    vmem[i] <= 32;
  end
end

always @(posedge write) begin
  vmem[addr] <= data;
end

always @(posedge activate) begin
  $fwrite(video, "[?25l[2J[H[s");
  for (i = 0; i < width*height; i = i + 1) begin
    if (!(i % width)) $fwrite(video, "\n");
    $fwrite(video, "%c", vmem[i]);
  end
  $fwrite(video, "[u[?25h");
end

endmodule
