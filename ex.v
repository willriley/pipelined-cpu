module ex(input [4:0] in_pc,
			input [31:0] rd1,
			input [31:0] rd2,
			input [31:0] imm,
			input alu_src,
			input [4:0] alu_op,
			input [3:0] jump_type,
			input reg_wrenable,
			input [4:0] write_reg,
			input mem_wrenable,
			input mem_to_reg,
			output [4:0] out_pc,
			output [31:0] alu_res,
			output [31:0] write_data);
			
// execution stage
// includes alu, calculates jump offset, write data


alu alu(.opc(alu_op), .op1(rd1), 
		.op2(alu_src ? imm : rd2), .res(alu_res));

// out_pc = alu_res if jump_type == jalr
//        = in_pc + imm otherwise
assign out_pc = in_jump_type[1:0] == 2'b11 ? alu_res : in_pc + imm[4:0];

// write_data = in_pc + 1 if jal/jalr
// 			  = rd2 otherwise
assign write_data = in_jump_type[1] ? in_pc + 1'b1 : rd2;

endmodule