module cpu(clk,reset,s,load,in,out,N,V,Z,w);
input wire clk, reset, s, load;
input [15:0] in;
output reg [15:0] out;
output reg N, V, Z;
output w;

wire w;
wire[15:0] datapath_out;
wire[2:0] Z_out;
wire write, loada, loadb, loadc, loads, vsel,asel,bsel;
wire [1:0] shift, ALUop,op;
wire [2:0] nsel,Rd,Rn,Rm,readnum,writenum,opcode;
reg [4:0] imm5;
reg [7:0] imm8;
wire [15:0] sximm8, sximm5,in_out;

ins_register IR(in,load,clk,in_out);
ins_decoder ID(in_out,nsel,sximm5,sximm8,opcode,op,shift,ALUop,readnum,writenum);
state_machine SM(s,reset,clk, opcode, op, write, w,vsel,loada,loadb,loadc,loads,asel,bsel,nsel);
datapath DP(sximm8,sximm5,vsel,loada,loadb,shift,bsel,asel,ALUop,loads,loadc,clk,writenum,write,readnum,Z_out,datapath_out);

always @(*) begin 
	N = Z_out[1];
	V = Z_out[2];
	Z = Z_out[0];
	out = datapath_out;
end 
endmodule 