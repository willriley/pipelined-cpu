module control_unit(input [31:0] instr,
					output reg [31:0] imm,
					output reg halt,
					output reg reg_wrenable,
					output reg mem_wrenable,
					output reg mem_to_reg,
					output reg [3:0] jump_type,
					output reg alu_src,
					output reg [4:0] alu_op);

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
	alu_src = 1'b0;
	alu_op = 5'd0;
	jump_type = 4'd0;
	mem_to_reg = 1'b0;
	
	case (instr[6:0])
	HALT: halt = 1'b1;
	STORE: begin // s-type
		alu_src = 1'b1;
		mem_wrenable = 1'b1;
	end
	ITYPE: begin // i-type
		alu_op = {2'd0, instr[14:12]};
		alu_src = 1'b1;
		reg_wrenable = 1'b1;
	end
	LOAD: begin // load
		alu_src = 1'b1;
		reg_wrenable = 1'b1;
		mem_to_reg = 1'b1;
	end
	BTYPE: begin // b-type
		alu_op = 5'b10000; // subtraction
		jump_type = instr[12] ? 4'd12 : 4'd8;
	end
	JAL: begin
		reg_wrenable = 1'b1;
		jump_type = 4'd2;
	end
	JALR: begin
		alu_src = 1'b1;
		reg_wrenable = 1'b1;
		jump_type = 4'd3;
	end
	default: begin // r-type
		alu_op = {instr[30], instr[25], instr[14:12]};
		reg_wrenable = 1'b1;
	end
	endcase
end	
					
					
					
endmodule