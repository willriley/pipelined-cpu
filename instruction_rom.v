module instruction_rom(input [4:0] addr, output reg [31:0] instr);

//always @* begin
//	case (addr)
//	5'd0: instr = 32'h0000_0093; // addi x1 x0 0
//	5'd1: instr = 32'h0100_0113; // addi x2 x0 16
//	5'd2: instr = 32'h0640_0193; // addi x3 x0 100
//	5'd3: instr = 32'h0080_0213; // addi x4 x0 8
//	5'd4: instr = 32'h0020_82b3; // add  x5 x1 x2
//	5'd5: instr = 32'h0041_8333; // add  x6 x3 x4
//	5'd6: instr = 32'h0050_a023; // sw x5 0(x1)
//	5'd7: instr = 32'h0061_2223; // sw x6 4(x2)
//	default: instr = 32'hffff_ffff; // halt
//	endcase
//end

always @* begin
	case (addr)
	5'd0: instr = 32'h00800293; // prog 2
	5'd1: instr = 32'h00f00313;
	5'd2: instr = 32'h0062a023;
	5'd3: instr = 32'h00000013; // RAW hazard after instr 2
	5'd4: instr = 32'h00000013; // so 3 + 4 need to be nops for now
	5'd5: instr = 32'h005303b3; 
	5'd6: instr = 32'h40530e33; 
	5'd7: instr = 32'h03c384b3; 
	5'd8: instr = 32'h00428293; 
	5'd9: instr = 32'hffc2a903;
	5'd10: instr = 32'h41248933;
	5'd11: instr = 32'h00291913;
	5'd12: instr = 32'h0122a023;
	default: instr = 32'hffff_ffff; // halt
	endcase
end

endmodule