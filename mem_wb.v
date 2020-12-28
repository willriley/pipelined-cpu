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
				
wire mem_clk, mem_clk_rst;
assign mem_clk_rst = 0;

pll pll(clk, mem_clk_rst, mem_clk);		
				
ram ram(.address(alu_res[7:0]), .clock(mem_clk), .data(write_data),
			.wren(mem_wrenable), .q(mem_res));

// write data = pc + 1 if should_jump
//            = mem contents if LW
//            = alu_res otherwise			
assign out_write_data = should_jump ? write_data : (mem_to_reg ? mem_res : alu_res);

always @* begin
	// beq jump_type is 100
	// bne is 110
	// jalr and jal are both 001
	if (jump_type[2]) begin 
		// bne -> alu_res != 0
		// beq -> alu_res == 0
		should_jump = (jump_type[1] && alu_res) || (!jump_type[1] && !alu_res);
	end
	else begin
		should_jump = jump_type[0];
	end
end		
				
endmodule
