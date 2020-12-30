module ex_pipeline_regs(input clk,
						input [4:0] in_pc,
						input [4:0] in_rs1,
						input [4:0] in_rs2,
						input [31:0] in_rd1,
						input [31:0] in_rd2,
						input [31:0] in_imm,
						input in_alu_src,
						input [4:0] in_alu_op,
						input in_is_jump,
						input in_reg_wrenable,
						input [4:0] in_write_reg,
						input in_mem_wrenable,
						input in_mem_to_reg,
						output reg [4:0] out_pc,
						output reg [4:0] out_rs1,
						output reg [4:0] out_rs2,
						output reg [31:0] out_rd1,
						output reg [31:0] out_rd2,
						output reg [31:0] out_imm,
						output reg out_alu_src,
						output reg [4:0] out_alu_op,
						output reg out_is_jump,
						output reg out_reg_wrenable,
						output reg [4:0] out_write_reg,
						output reg out_mem_wrenable,
						output reg out_mem_to_reg);
						
initial begin
	out_is_jump = 0;
	out_reg_wrenable = 0;
	out_mem_wrenable = 0;
	out_rs1 = 0;
	out_rs2 = 0;
end

// naive module that buffers input/control signals		
// between the instruction fetch and execution stages	
always @(posedge clk) begin
	out_pc <= in_pc;
	out_rs1 <= in_rs1;
	out_rs2 <= in_rs2;
	out_rd1 <= in_rd1;
	out_rd2 <= in_rd2;
	out_imm <= in_imm;
	out_alu_src <= in_alu_src;
	out_alu_op <= in_alu_op;
	out_is_jump <= in_is_jump;
	out_reg_wrenable <= in_reg_wrenable;
	out_write_reg <= in_write_reg;
	out_mem_wrenable <= in_mem_wrenable;
	out_mem_to_reg <= in_mem_to_reg;
end						

endmodule
						