`timescale 10ns/1ns
module tb;

reg clk;
pipelined_cpu cpu(clk);

initial begin
	clk = 0;

	#20000;
	$stop;
end


always begin
	#5 clk = ~clk;
end


endmodule