module fetch_decode(input clk,
				  input [4:0] jump_pc,
				  input should_jump,
				  input [4:0] in_write_reg,
				  input [31:0] write_data,
				  input in_reg_wrenable,
				  output [31:0] read_data1,
				  output [31:0] read_data2,
				  output [31:0] imm,
				  output [4:0] out_write_reg,
				  output out_reg_wrenable,
				  output [3:0] jump_type,
				  output mem_wrenable,
				  output mem_to_reg,
				  output alu_src,
				  output [4:0] alu_op,
				  output reg [4:0] pc);

// instruction fetch and decode stage
// fetches the instruction + generates control signals/operands	
	
reg halt_reg;
wire halt;
initial begin
	pc = 0;
	halt_reg = 0;
end	

// update pc
always @(posedge clk) begin
	if (halt_reg) pc <= pc;
	else begin
		pc <= should_jump ? jump_pc : pc + 1'b1;
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
wire [4:0] rr1, rr2;
regfile rf(clk, rr1, rr2, in_write_reg, write_data, 
			  in_reg_wrenable, read_data1, read_data2);
			  
assign rr1 = instr[19:15];
assign rr2 = instr[24:20];
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