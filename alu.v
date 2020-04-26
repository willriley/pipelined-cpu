module alu(input [4:0] opc,
			  input [31:0] op1,
			  input [31:0] op2,
			  output reg [31:0] res);
			  
// leading 2 bits of opc are from f7
// remaining 3 bits of opc are from f3
			  
always @* begin
	casez(opc)
	5'b1????: res = op1-op2;
	5'b01???: res = op1*op2;
	5'b0011?: res = opc[0] ? op1 & op2 : op1 | op2;
	5'b00001: res = op1 << op2;
	default: res = op1 + op2;
	endcase
end  
			  
endmodule