module main ();
parameter program_file = "src/test/example.mem";

system #(.debug(0), .file(program_file)) system_module ();

endmodule
