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

//always @* begin
//	case (addr)
//	5'd0: instr = 32'h00800293; // prog 2
//	5'd1: instr = 32'h00f00313;
//	5'd4: instr = 32'h0062a023;
//	5'd7: instr = 32'h005303b3; 
//	5'd8: instr = 32'h40530e33; 
//	5'd10: instr = 32'h03c384b3; 
//	5'd11: instr = 32'h00428293; 
//	5'd14: instr = 32'hffc2a903;
//	5'd17: instr = 32'h41248933;
//	5'd20: instr = 32'h00291913;
//	5'd23: instr = 32'h0122a023;
//	5'd24: instr = 32'hffff_ffff; // halt
//	default: instr = 32'h00000013;
//	endcase
//end

always @* begin
	case (addr)
	5'd0: instr = 32'h00500513;  // addi a0,x0,5
	5'd1: instr = 32'h00c000ef;  // jal ra,fact
	5'd2: instr = 32'h00a02023;  // sw a0,0(x0)
	5'd3: instr = 32'hffffffff;  // halt 
	5'd4: instr = 32'hff810113;  // fact: addi sp,sp,-8
	5'd7: instr = 32'h00112223;  // sw ra, 4(sp)
	5'd8: instr = 32'h00a12023;  // sw a0, 0(sp)
	5'd9: instr = 32'hfff50513;  // addi a0,a0,-1 
	5'd12: instr = 32'h00051863; // bne a0,x0,else 
	5'd13: instr = 32'h00100513; // addi a0,x0,1 
	5'd14: instr = 32'h00810113; // addi sp,sp,8 
	5'd15: instr = 32'h00008067; // jalr x0,0(ra) 
	5'd16: instr = 32'hfd1ff0ef; // else: jal ra,fact 
	5'd17: instr = 32'h00050293; // addi t0,a0,0 
	5'd18: instr = 32'h00012503; // lw a0,0(sp) 
	5'd19: instr = 32'h00412083; // lw ra,4(sp) 
	5'd20: instr = 32'h00810113; // addi sp,sp,8  
	5'd21: instr = 32'h02550533; // mul a0,a0,t0 
	5'd22: instr = 32'h00008067; // jalr x0,0(ra) 
	default: instr = 32'h00000013; // nop
	endcase
end

endmodule