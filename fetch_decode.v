module fetch_decode(input clk,
				  input [4:0] in_write_reg,
				  input [31:0] write_data,
				  input in_reg_wrenable,
				  output [31:0] read_data1,
				  output [31:0] read_data2,
				  output [31:0] imm,
				  output [4:0] out_rs1,
				  output [4:0] out_rs2,
				  output [4:0] out_write_reg,
				  output out_reg_wrenable,
				  output is_jump,
				  output mem_wrenable,
				  output mem_to_reg,
				  output alu_src,
				  output [4:0] alu_op,
				  output reg [4:0] pc);

// instruction fetch and decode stage
// fetches the instruction + generates control signals/operands	
	
reg halt_reg;
reg [31:0] num_cycles;
wire halt, rs_equal, should_branch;
wire [3:0] jump_type;
initial begin
	pc = 0;
	halt_reg = 0;
	num_cycles = 0;
end

assign rs_equal = (read_data1 == read_data2);
assign is_jump = jump_type[1];

// branch on beq when rs1 == rs2
// branch on bne when rs1 != rs2
assign should_branch = (jump_type[2] && ((rs_equal && !jump_type[3]) || (!rs_equal && jump_type[3])));

// update pc
always @(posedge clk) begin
	if (halt_reg) begin
		pc <= pc;
		num_cycles <= num_cycles;
	end 
	else begin
		num_cycles <= num_cycles + 1'b1;
		// jal -> pc = pc + imm
		// jalr -> pc = rd1
		// beq/bne -> pc = pc + imm if taken
		// else pc = pc + 1
		if (jump_type[1]) pc <= jump_type[0] ? read_data1[4:0] : pc + imm[4:0];
		else pc <= (jump_type[2] && should_branch) ? pc + imm[4:0] : pc + 1'b1;
	end
end

always @(posedge clk) begin
	halt_reg <= halt_reg || halt;
end

// fetch instr
wire [31:0] raw_instr, instr;
instruction_rom rom(pc, raw_instr);
// TODO: make compatible with regular rom
// rom instr_rom(pc, clk, instr);

// handle simultaneous reg reads/writes
regfile rf(clk, out_rs1, out_rs2, in_write_reg, write_data, 
			  in_reg_wrenable, read_data1, read_data2);

assign out_rs1 = instr[19:15];
assign out_rs2 = instr[24:20];
assign out_write_reg = instr[11:7];

// put nop into pipeline if we're halted
assign instr = halt_reg ? 32'h00000013 : raw_instr;			  
			  
// instantiate control unit that
// sets control flags and generates imm
control_unit ctrl(.instr(instr), .imm(imm), .halt(halt),
						.reg_wrenable(out_reg_wrenable), .mem_wrenable(mem_wrenable),
						.mem_to_reg(mem_to_reg), .jump_type(jump_type),
						.alu_src(alu_src), .alu_op(alu_op));

endmodule