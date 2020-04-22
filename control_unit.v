module control_unit(input [31:0] instr,
					output reg [31:0] imm,
					output reg halt,
					output reg reg_wrenable,
					output reg mem_wrenable,
					output reg [31:0] alu_src,
					output reg [4:0] alu_op,
					output reg [31:0] write_data);

// supported instruction opcodes
parameter HALT  = 7'b1111111;
parameter LOAD  = 7'b0000011;
parameter STORE = 7'b0100011;
parameter ITYPE = 7'b0010011;
parameter BTYPE = 7'b1100011;
parameter RTYPE = 7'b0010011;
parameter JAL   = 7'b1101111;
parameter JALR  = 7'b1100111;					
					
// immediate generator
always @* begin
	case (instr[6:0])
	STORE: imm = {{20{instr[31]}},instr[31:25], instr[11:7]};
	BTYPE: imm = {{22{instr[31]}}, instr[7], instr[30:25], instr[11:9]};
	JAL: imm = {{14{instr[31]}}, instr[19:12], instr[20], instr[30:22]};
	default: imm = {{20{instr[31]}}, instr[31:20]}; // itype, load, jalr
	endcase	
end

// control unit sets flags based on opcode				
always @* begin
	halt = 1'b0;
	reg_wrenable = 1'b0;
	mem_wrenable = 1'b0;
	alu_src = rd2;
	alu_op = 5'd0;
	wd = alu_res;
	
	case (instr[6:0])
	HALT: halt = 1'b1;
	STORE: begin // s-type
		alu_src = imm;
		mem_wrenable = 1'b1;
	end
	ITYPE: begin // i-type
		alu_op = {2'd0, instr[14:12]};
		alu_src = imm;
		reg_wrenable = 1'b1;
	end
	LOAD: begin // load
		alu_src = imm;
		reg_wrenable = 1'b1;
		wd = mem_res;
	end
	BTYPE: begin // b-type
		alu_op = 5'b10000; // subtraction
	end
	JAL: begin
		reg_wrenable = 1'b1;
		wd = pc + 1'b1; // save pc + 1 in return address
	end
	JALR: begin
		alu_src = imm;
		reg_wrenable = 1'b1;
		wd = pc + 1'b1; // save pc + 1 in return address
	end
	default: begin // r-type
		alu_op = {instr[30], instr[25], instr[14:12]};
		reg_wrenable = 1'b1;
	end
	endcase
end	
					
					
					
endmodule