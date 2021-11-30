module shifter(in,shift,sout);
input [15:0] in;
input [1:0] shift;
output reg [15:0] sout;

always @(*) begin
	case(shift) 
		2'b00: sout = in;
	 	2'b01: begin//shift to the left by 1-bit, leaving last bit zero 
			sout = in << 1;
			sout[0] = 1'b0;
		       end 
		2'b10: begin//shift to the right by 1-bit, leaving last bit zero
			sout = in >> 1;
			sout[15] = 1'b0;
		       end
		2'b11: begin// MSB is B[15]
			sout = in >> 1;
			sout[15] = in[15];
			end 
		default: sout = in; 
	endcase 
end 
endmodule
