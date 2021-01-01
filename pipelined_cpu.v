module pipelined_cpu(input CLOCK_50);

wire [4:0] fd_out_write_reg, fd_alu_op, fd_pc, fd_rs1, fd_rs2;
wire [4:0] mem_write_reg;
wire should_jump, fd_reg_wrenable, fd_out_reg_wrenable, mem_reg_wrenable;
wire fd_mem_wrenable, fd_alu_src, fd_mem_to_reg, fd_is_jump;
wire [31:0] fd_write_data, fd_rd1, fd_rd2, fd_imm, reg_write_data;

// instruction fetch/decode stage
fetch_decode stage1(CLOCK_50, mem_write_reg, 
						reg_write_data, mem_reg_wrenable,
						fd_rd1, fd_rd2, 
						fd_imm, fd_rs1, fd_rs2, fd_out_write_reg, 
						fd_out_reg_wrenable, fd_is_jump,
						fd_mem_wrenable, fd_mem_to_reg,
						fd_alu_src, fd_alu_op, fd_pc);

wire [4:0] ex_in_pc, ex_in_alu_op, ex_in_write_reg, ex_in_rs1, ex_in_rs2;
wire [31:0] ex_in_rd1, ex_in_rd2, ex_in_imm;
wire ex_in_alu_src, ex_in_reg_wrenable, ex_in_mem_wrenable, ex_in_mem_to_reg, ex_is_jump;

// pipeline regs between instruction decode and execute stages
ex_pipeline_regs exp(CLOCK_50, fd_pc, fd_rs1, fd_rs2, fd_rd1, fd_rd2, fd_imm,
						fd_alu_src, fd_alu_op, fd_is_jump, fd_out_reg_wrenable,
						fd_out_write_reg, fd_mem_wrenable, fd_mem_to_reg,
						ex_in_pc, ex_in_rs1, ex_in_rs2, ex_in_rd1, ex_in_rd2, ex_in_imm,
						ex_in_alu_src, ex_in_alu_op, ex_is_jump,
						ex_in_reg_wrenable, ex_in_write_reg,
						ex_in_mem_wrenable, ex_in_mem_to_reg);

wire [31:0] ex_alu_res, ex_write_data;
wire fwd_a, fwd_b;
						
// execute stage						
ex ex_stage(ex_in_pc, ex_in_rd1, ex_in_rd2, ex_in_imm, 
		mem_alu_res, ex_in_alu_src, fwd_a, fwd_b,
		ex_in_alu_op, ex_is_jump,
		ex_alu_res, ex_write_data);

wire [31:0] mem_alu_res, mem_write_data;
wire mem_is_jump;
wire mem_mem_wrenable, mem_mem_to_reg;

mem_pipeline_regs mpr(CLOCK_50, ex_alu_res, ex_write_data,
							ex_is_jump, ex_in_reg_wrenable, ex_in_write_reg,
							ex_in_mem_wrenable, ex_in_mem_to_reg, mem_alu_res, 
							mem_write_data, mem_is_jump, mem_reg_wrenable, 
							mem_write_reg, mem_mem_wrenable, mem_mem_to_reg);
							
forward_unit fw(ex_in_rs1, ex_in_rs2, mem_write_reg, mem_reg_wrenable, fwd_a, fwd_b);
							
mem_wb mem_wb(CLOCK_50, mem_alu_res, mem_write_data, mem_is_jump,
				mem_reg_wrenable, mem_mem_wrenable, mem_mem_to_reg,
				reg_write_data);
							

endmodule