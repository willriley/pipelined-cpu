module regfile(input clk,
					input [4:0] read_reg1,
					input [4:0] read_reg2,
					input [4:0] write_reg,
					input [31:0] write_data,
					input write_enable,
					output reg [31:0] read_data1,
					output reg [31:0] read_data2);

reg [31:0] regs[0:31]; // 32x32 bit array
initial begin
	regs[0] = 0;
	regs[2] = 255; // set sp (x2) at top of address space
end
					
// perform writes in first half of clock period
always @(posedge clk) begin
	if (write_enable && write_reg!= 5'd0) begin
		regs[write_reg] <= write_data;
	end
end

always @* begin
	if (write_enable && read_reg1 == write_reg) begin
		read_data1 = write_data;
	end
	else read_data1 = regs[read_reg1];
end

always @* begin
	if (write_enable && read_reg2 == write_reg) begin
		read_data2 = write_data;
	end
	else read_data2 = regs[read_reg2];
end

endmodule


