module ex(input [4:0] in_pc,
			input [31:0] rd1,
			input [31:0] rd2,
			input [31:0] imm,
			input alu_src,
			input [4:0] alu_op,
			input is_jump,
			input reg_wrenable,
			input [4:0] write_reg,
			input mem_wrenable,
			input mem_to_reg,
			output [31:0] alu_res,
			output [31:0] write_data);
			
alu alu(.opc(alu_op), .op1(rd1), 
		.op2(alu_src ? imm : rd2), .res(alu_res));

// write_data = in_pc + 1 if jal/jalr
// 			  = rd2 otherwise
assign write_data = is_jump ? in_pc + 1'b1 : rd2;

endmodule