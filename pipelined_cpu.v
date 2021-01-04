module pipelined_cpu(input CLOCK_50);

wire [4:0] fd_out_write_reg, fd_alu_op, fd_pc, fd_rs1, fd_rs2;
wire [4:0] mem_write_reg;
wire should_jump, fd_reg_wrenable, fd_out_reg_wrenable, mem_reg_wrenable;
wire fd_mem_wrenable, fd_alu_src, fd_mem_to_reg, fd_is_jump;
wire [31:0] fd_write_data, fd_rd1, fd_rd2, fd_imm, reg_write_data;

// instruction fetch/decode stage
fetch_decode stage1(.clk(CLOCK_50), .in_write_reg(mem_write_reg), 
						.write_data(reg_write_data), .in_reg_wrenable(mem_reg_wrenable),
						.read_data1(fd_rd1), .read_data2(fd_rd2), 
						.imm(fd_imm), .out_rs1(fd_rs1), .out_rs2(fd_rs2), 
						.out_write_reg(fd_out_write_reg), .out_reg_wrenable(fd_out_reg_wrenable), 
						.is_jump(fd_is_jump), .mem_wrenable(fd_mem_wrenable), 
						.mem_to_reg(fd_mem_to_reg), .alu_src(fd_alu_src), 
						.alu_op(fd_alu_op), .pc(fd_pc));

wire [4:0] ex_in_pc, ex_in_alu_op, ex_in_write_reg, ex_in_rs1, ex_in_rs2;
wire [31:0] ex_in_rd1, ex_in_rd2, ex_in_imm;
wire ex_in_alu_src, ex_in_reg_wrenable, ex_in_mem_wrenable, ex_in_mem_to_reg, ex_is_jump;

// pipeline regs between instruction decode and execute stages
ex_pipeline_regs exp(.clk(CLOCK_50), .in_pc(fd_pc), .in_rs1(fd_rs1), .in_rs2(fd_rs2), 
						.in_rd1(fd_rd1), .in_rd2(fd_rd2), .in_imm(fd_imm),
						.in_alu_src(fd_alu_src), .in_alu_op(fd_alu_op), .in_is_jump(fd_is_jump), 
						.in_reg_wrenable(fd_out_reg_wrenable), .in_write_reg(fd_out_write_reg), 
						.in_mem_wrenable(fd_mem_wrenable), .in_mem_to_reg(fd_mem_to_reg),
						.out_pc(ex_in_pc), .out_rs1(ex_in_rs1), .out_rs2(ex_in_rs2), 
						.out_rd1(ex_in_rd1), .out_rd2(ex_in_rd2), .out_imm(ex_in_imm),
						.out_alu_src(ex_in_alu_src), .out_alu_op(ex_in_alu_op), 
						.out_is_jump(ex_is_jump), .out_reg_wrenable(ex_in_reg_wrenable), 
						.out_write_reg(ex_in_write_reg),
						.out_mem_wrenable(ex_in_mem_wrenable), .out_mem_to_reg(ex_in_mem_to_reg));

wire [31:0] ex_alu_res, ex_write_data;
wire fwd_a, fwd_b;
						
// execute stage						
ex ex_stage(.in_pc(ex_in_pc), .rd1(ex_in_rd1), .rd2(ex_in_rd2), .imm(ex_in_imm), 
				.fwd_res(mem_alu_res), .alu_src(ex_in_alu_src), .fwd_a(fwd_a), .fwd_b(fwd_b),
				.alu_op(ex_in_alu_op), .is_jump(ex_is_jump),
				.alu_res(ex_alu_res), .write_data(ex_write_data));

wire [31:0] mem_alu_res, mem_write_data;
wire mem_is_jump;
wire mem_mem_wrenable, mem_mem_to_reg;

mem_pipeline_regs mpr(.clk(CLOCK_50), .in_alu_res(ex_alu_res), 
							.in_write_data(ex_write_data), .in_is_jump(ex_is_jump), 
							.in_reg_wrenable(ex_in_reg_wrenable), .in_write_reg(ex_in_write_reg),
							.in_mem_wrenable(ex_in_mem_wrenable), .in_mem_to_reg(ex_in_mem_to_reg), 
							.out_alu_res(mem_alu_res), .out_write_data(mem_write_data), 
							.out_is_jump(mem_is_jump), .out_reg_wrenable(mem_reg_wrenable), 
							.out_write_reg(mem_write_reg), .out_mem_wrenable(mem_mem_wrenable), 
							.out_mem_to_reg(mem_mem_to_reg));
							
forward_unit fw(.ex_rs1(ex_in_rs1), .ex_rs2(ex_in_rs2), .mem_rd(mem_write_reg), 
					 .mem_reg_wrenable(mem_reg_wrenable), .fwd_a(fwd_a), .fwd_b(fwd_b));
							
mem_wb mem_wb(.clk(CLOCK_50), .alu_res(mem_alu_res), .write_data(mem_write_data), 
				  .is_jump(mem_is_jump), .reg_wrenable(mem_reg_wrenable), 
				  .mem_wrenable(mem_mem_wrenable), .mem_to_reg(mem_mem_to_reg),
				  .out_write_data(reg_write_data));
							

endmodule