module ALU(Ain,Bin,ALUop,out,Z);
	input [15:0] Ain, Bin;
	input [1:0] ALUop;
	output reg [15:0] out;
	output reg [2:0]Z;
	reg sign_A, sign_B,sign_R;
	
	always  @(*) begin
		case(ALUop) 
			2'b00: out = Ain + Bin;
			2'b01: out = Ain - Bin;
			2'b10: out = (Ain & Bin);
			2'b11: out = ~Bin;
			default: out = {16{1'bx}};
		endcase 
		sign_A = Ain[15];
		sign_B = (ALUop == 2'b01) ? ~Bin[15] : Bin[15];
		sign_R = out[15];

		Z[0] = (out == 16'd0) ? 1'b1 : 1'b0; //Z
		Z[1] = (out[15] == 1'b1) ? 1'b1 : 1'b0; //N
		if(ALUop == 2'b00 | ALUop == 2'b01) //V
			Z[2] = ((~(sign_A ^ sign_B)) & (sign_A ^ sign_R)) ? 1'b1 : 1'b0;
		else 
			Z[2] = 1'b0;
	end 
endmodule 
