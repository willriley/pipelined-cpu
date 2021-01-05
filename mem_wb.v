module mem_wb(input clk,
				input [31:0] alu_res,
				input [31:0] write_data,
				input is_jump,
				input reg_wrenable,
				input mem_wrenable,
				input mem_to_reg,
				output [31:0] out_write_data);
				
wire [31:0] mem_res;
wire mem_clk, mem_clk_rst;
assign mem_clk_rst = 1'b0;

pll pll(.refclk(clk), .rst(mem_clk_rst), .outclk_0(mem_clk));		
				
ram ram(.address(alu_res[7:0]), .clock(mem_clk), .data(write_data),
			.wren(mem_wrenable), .q(mem_res));

// write data = pc + 1 if is_jump
//            = mem contents if LW
//            = alu_res otherwise			
assign out_write_data = is_jump ? write_data : (mem_to_reg ? mem_res : alu_res);
				
endmodule
