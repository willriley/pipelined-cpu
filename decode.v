module decode(input clk,
				  input [4:0] jump_pc,
				  input should_jump,
				  input [4:0] in_write_reg,
				  input [31:0] write_data,
				  input in_wrenable,
				  output [31:0] read_data1,
				  output [31:0] read_data2,
				  output [31:0] imm,
				  output [4:0] out_write_reg,
				  output out_reg_wrenable,
				  output branch,
				  output load,
				  output mem_read,
				  output mem_wrenable,
				  output alu_src,
				  output [4:0] alu_op,
				  output reg [4:0] pc);
				  
reg halt;
initial begin
	pc = 0;
	halt = 0;
end	

// update pc
always @(posedge clk) begin
	if (halt) pc <= pc;
	else begin
		pc <= should_jump ? jump_pc : pc + 1'b1;
	end
end

// fetch instr
wire [31:0] instr;
rom instr_rom(pc, clk, instr);

// handle simultaneous reg reads/writes
wire [4:0] rr1, rr2;
regfile rf(clk, rr1, rr2, in_write_reg, write_data, 
			  in_wrenable, read_data1, read_data2);
			  
assign rr1 = instr[19:15];
assign rr2 = instr[24:20];
assign out_write_reg = instr[11:7];
			  
			  
// instantiate control unit that
// sets control flags and generates imm
control_unit ctrl(instr, imm, halt, reg_wrenable, 

// halt, reg_wrenable, mem_wrenable, wd, alu_src, alu_op, imm

endmodule