module forward_unit(input [4:0] rs1,
						  input [4:0] rs2,
						  input [4:0] rd_if,
						  input ex_wren,
						  input [4:0] rd_ex,
						  input mem_wren,
						  input [4:0] rd_mem,
						  output [1:0] fwd_a,
						  output [1:0] fwd_b);
						  
// code 00 -> source operand from regfile
// code 10 -> source operand from next instr in pipeline (ex)
// code 01 -> source operand from 2 instrs ahead (mem)

// sets ex bit == 1 if we want to forward the ex instruction
assign fwd_a[1] = (ex_wren && rd_ex != 5'd0 && rd_ex == rs1);						  
assign fwd_b[1] = (ex_wren && rd_ex != 5'd0 && rd_ex == rs2);

// sets mem bit == 1 if we want to forward the mem instruction
assign fwd_a[0] = (mem_wren && rd_mem != 5'd0 && rd_mem == rs1 && !fwd_a[1]);
assign fwd_b[0] = (mem_wren && rd_mem != 5'd0 && rd_mem == rs2 && !fwd_b[1]);
endmodule