module mem_wb(input clk,
				input [4:0] pc,
				input [31:0] alu_res,
				input [31:0] write_data,
				input [2:0] jump_type,
				input reg_wrenable,
				input mem_wrenable,
				input [4:0] write_reg,
				input mem_to_reg,
				output reg should_jump,
				output [31:0] out_write_data);
				
wire [31:0] mem_res;

initial begin
	should_jump = 0;
end
				
// TODO:	phase shift mem clock?
ram ram(.address(alu_res[7:0]), .clock(clk), .data(write_data),
			.wren(mem_wrenable), .q(mem_res));
			
assign out_write_data = mem_to_reg ? mem_res : alu_res;

always @* begin
	if (jump_type[2]) begin 
		// if jump type is a branch, check alu_res
		// bne -> alu_res != 0
		// beq -> alu_res == 0
		should_jump = (jump_type[1] && alu_res) || (jump_type[1] && !alu_res);
	end
	else begin
		should_jump = jump_type[0];
	end
end		
				
endmodule
