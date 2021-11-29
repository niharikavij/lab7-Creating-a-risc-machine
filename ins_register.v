module ins_register(in,load,clk,in_out);
input clk, load;
input [15:0] in;
output reg[15:0] in_out;

always @(posedge clk) begin
	//instruction registers 
	in_out = load ? in_out : in; 
end 
endmodule 