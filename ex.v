module ex(input [4:0] in_pc,
			input [31:0] rd1,
			input [31:0] rd2,
			input [31:0] imm,
			input [31:0] fwd_res,
			input alu_src,
			input fwd_a,
			input fwd_b,
			input [4:0] alu_op,
			input is_jump,
			output [31:0] alu_res,
			output [31:0] write_data);

reg [31:0] op2;
always @* begin
	if (fwd_b) op2 = fwd_res;
	else op2 = alu_src ? imm : rd2;
end
			
alu alu(.opc(alu_op), .op1(fwd_a ? fwd_res : rd1), 
		.op2(op2), .res(alu_res));

// write_data = in_pc + 1 if jal/jalr
// 			  = rd2 otherwise
assign write_data = is_jump ? in_pc + 1'b1 : rd2;

endmodule