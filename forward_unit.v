module forward_unit(input [4:0] ex_rs1,
						  input [4:0] ex_rs2,
						  input [4:0] mem_rd,
						  input mem_reg_wrenable,
						  output fwd_a,
						  output fwd_b);
						  
assign fwd_a = (mem_reg_wrenable && mem_rd != 5'd0 && mem_rd == ex_rs1);
assign fwd_b = (mem_reg_wrenable && mem_rd != 5'd0 && mem_rd == ex_rs2);

endmodule