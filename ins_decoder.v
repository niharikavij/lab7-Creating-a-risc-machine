module ins_decoder(in_out,nsel,sximm5,sximm8,opcode,op,shift,ALUop,readnum,writenum);
input [2:0]nsel;
input [15:0]in_out;

reg [4:0] imm5;
reg [7:0] imm8;
output reg [15:0] sximm5,sximm8;
output reg [1:0] shift, ALUop,op;
output reg [2:0] readnum,writenum,opcode;
reg [2:0] Rn,Rm,Rd;

always @(*)begin
	ALUop = in_out[12:11];
	imm5 = in_out[4:0];
	imm8 = in_out[7:0];
	shift = in_out[4:3];
	Rn = in_out[10:8];
	Rd = in_out[7:5];
	Rm = in_out[2:0]; 
	opcode = in_out[15:13];
	op = in_out[12:11];

	case (nsel)
		3'b001:  {readnum,writenum} = {Rn,Rn};
		3'b010:  {readnum,writenum} = {Rd,Rd};
		3'b100:  {readnum,writenum} = {Rm,Rm};
		default: {readnum,writenum} = {6'bxxxxxx};
	endcase
	if(imm8[7] == 1'b0)
		sximm8 = {{8{1'b0}}, imm8};
	else 
		sximm8 = {{8{1'b1}}, imm8};
end 
endmodule 