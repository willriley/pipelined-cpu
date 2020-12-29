module mem_pipeline_regs(input clk,
								input [31:0] in_alu_res,
								input [31:0] in_write_data,
								input in_is_jump,
								input in_reg_wrenable,
								input [4:0] in_write_reg,
								input in_mem_wrenable,
								input in_mem_to_reg,
								output reg [31:0] out_alu_res,
								output reg [31:0] out_write_data,
								output reg out_is_jump,
								output reg out_reg_wrenable,
								output reg [4:0] out_write_reg,
								output reg out_mem_wrenable,
								output reg out_mem_to_reg);

initial begin
	out_reg_wrenable = 0;
	out_is_jump = 0;
end		
		
always @(posedge clk) begin
	out_alu_res <= in_alu_res;
	out_write_data <= in_write_data;
	out_is_jump <= in_is_jump;
	out_reg_wrenable <= in_reg_wrenable;
	out_write_reg <= in_write_reg;
	out_mem_wrenable <= in_mem_wrenable;
	out_mem_to_reg <= in_mem_to_reg;
end				
								
endmodule