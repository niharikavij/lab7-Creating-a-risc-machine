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
		if(out == 16'd0)begin
			Z[0] = 1'b1;
		end 
		else begin
			Z[0] = 1'b0;
		end 
		if(out[15] == 1'b1)begin
			Z[1] = 1'b1;
		end 
		else begin
			Z[1] = 1'b0;
		end 
		if(ALUop == 2'b00 | ALUop == 2'b01)begin
			if((~(sign_A ^ sign_B)) & (sign_A ^ sign_R))begin
				Z[2] = 1'b1;
			end 
			else 
				Z[2] = 1'b0;
		end 
		else begin
			Z[2] = 1'b0;
		end 
	end 
endmodule 