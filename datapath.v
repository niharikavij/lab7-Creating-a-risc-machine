module datapath(mdata,sximm8,sximm5,vsel,loada,loadb,shift,bsel,asel,ALUop,loads,loadc,clk,writenum,write,readnum,Z_out,datapath_out);
	input [15:0]sximm8,sximm5,mdata;
	input [2:0] writenum, readnum;
	input [1:0] ALUop,shift;
	reg [15:0]OpA, OpB,Ain,Bin,C;
	wire [2:0]Z;
	wire [15:0] out,sout,data_out;
	reg [15:0] data_in;

	input clk,write,loada,loadb,loadc,asel,bsel,loads;
	input [1:0] vsel;
	output reg[15:0]datapath_out;
	output reg [2:0]Z_out;
	//To be modified in lab 7
	assign PC = 16'd0;

	regfile REGFILE (data_in,writenum,write,readnum,clk,data_out);
	shifter U1(OpB,shift,sout);
	ALU U2(Ain,Bin,ALUop,out,Z);
	always @(posedge clk)begin
		if(write == 1'b0) begin
			if(loada == 1'b1)
				OpA = data_out;
			if(loadb == 1'b1)
				OpB = data_out; 
		end 
		if(loadc == 1'b1)
			datapath_out = out;
		if(loads == 1'b1)
			Z_out = Z;
	end 


	always @(*) begin
		C = datapath_out;
		Ain = asel ? 16'b0 : OpA;
		Bin = bsel ? sximm5 : sout;
		data_in = vsel ? sximm8 : C;
		case(vsel)
			2'b00: data_in = C;
			2'b01: data_in = sximm8;
			2'b10: data_in = mdata;
			2'b11: data_in = PC;
		endcase 
	end 
endmodule 