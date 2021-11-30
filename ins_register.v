module ins_register(read_data,load_ir,clk,in_out);
input clk, load_ir;
input [15:0] read_data;
output reg[15:0] in_out;

always @(posedge clk) begin
	//instruction registers 
	in_out = load_ir ? in_out : read_data; 
end 
endmodule 
