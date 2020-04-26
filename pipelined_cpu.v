module pipelined_cpu(input CLOCK_50);

reg [4:0] pc; 
wire [31:0] instr; 
reg halt;

initial begin
	pc = 0;
	halt = 0;
end


// TODO: set up stages IF-ID|EX|MEM-WB

wire [4:0] fd_jump_pc, fd_write_reg, fd_out_write_reg, fd_alu_op, fd_pc;
wire should_jump, fd_reg_wrenable, fd_out_reg_wrenable;
wire fd_mem_wrenable, fd_alu_src, fd_halt, fd_mem_to_reg;
wire [31:0] fd_write_data, fd_rd1, fd_rd2, fd_imm;
wire [3:0] fd_jump_type;

fetch_decode stage1(clk, fd_jump_pc, should_jump,
						fd_reg_wrenable, fd_write_reg,
						fd_write_data, fd_rd1, fd_rd2, 
						fd_imm, fd_out_write_reg, 
						fd_out_reg_wrenable, fd_jump_type,
						fd_mem_wrenable, fd_mem_to_reg,
						fd_alu_src, fd_halt, fd_alu_op, fd_pc);



endmodule