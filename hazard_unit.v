module hazard_unit(input [4:0] fd_rs1,
						  input [4:0] fd_rs2,
						  input [4:0] ex_rd,
						  input ex_reg_wrenable,
						  input ex_mem_to_reg,
						  output fwd_a,
						  output fwd_b,
						  output should_stall);
						  
assign fwd_a = (ex_reg_wrenable && ex_rd != 5'd0 && ex_rd == fd_rs1);
assign fwd_b = (ex_reg_wrenable && ex_rd != 5'd0 && ex_rd == fd_rs2);

//initial begin
//	should_stall = 0;
//end

//always @(posedge clk) begin
//	should_stall <= ((ex_mem_to_reg == 1'b1) && (ex_rd != 5'd0) && ((ex_rd == fd_rs1) || (ex_rd == fd_rs2)));
//end

assign should_stall = ((ex_mem_to_reg == 1'b1) && (ex_rd != 5'd0) && ((ex_rd == fd_rs1) || (ex_rd == fd_rs2)));

endmodule