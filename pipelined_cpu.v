module pipelined_cpu(input CLOCK_50);

// TODO: set up stages IF-ID|EX|MEM-WB

wire [4:0] fd_jump_pc, fd_write_reg, fd_out_write_reg, fd_alu_op, fd_pc;
wire should_jump, fd_reg_wrenable, fd_out_reg_wrenable;
wire fd_mem_wrenable, fd_alu_src, fd_mem_to_reg;
wire [31:0] fd_write_data, fd_rd1, fd_rd2, fd_imm;
wire [3:0] fd_jump_type;

// instruction fetch/decode stage
fetch_decode stage1(clk, fd_jump_pc, should_jump,
						fd_reg_wrenable, fd_write_reg,
						fd_write_data, fd_rd1, fd_rd2, 
						fd_imm, fd_out_write_reg, 
						fd_out_reg_wrenable, fd_jump_type,
						fd_mem_wrenable, fd_mem_to_reg,
						fd_alu_src, fd_alu_op, fd_pc);

wire [4:0] ex_in_pc, ex_in_alu_op, ex_in_write_reg;
wire [31:0] ex_in_rd1, ex_in_rd2, ex_in_imm;
wire ex_in_alu_src, ex_in_reg_wrenable, ex_in_mem_wrenable, ex_in_mem_to_reg;
wire [3:0] ex_in_jmp_type;

// pipeline regs between instruction decode and execute stages
ex_pipeline_regs exp(clk, fd_pc, fd_rd1, fd_rd2, fd_imm,
						fd_alu_src, fd_jump_type, fd_out_reg_wrenable,
						fd_out_write_reg, fd_mem_wrenable, fd_mem_to_reg,
						ex_in_pc, ex_in_rd1, ex_in_rd2, ex_in_imm,
						ex_in_alu_src, ex_in_alu_op, ex_in_jmp_type,
						ex_in_reg_wrenable, ex_in_write_reg,
						ex_in_mem_wrenable, ex_in_mem_to_reg);

wire [4:0] ex_out_pc;
wire [31:0] ex_alu_res, ex_write_data;
						
// execute stage						
ex ex(ex_in_pc, ex_in_rd1,	ex_in_rd2, ex_in_imm, ex_in_alu_src,
		ex_in_alu_op, ex_in_jmp_type, ex_in_reg_wrenable,
		ex_in_mem_wrenable, ex_in_mem_to_reg, ex_out_pc,
		ex_alu_res, ex_write_data);

endmodule