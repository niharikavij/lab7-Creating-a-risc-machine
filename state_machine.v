module state_machine(s,reset,clk,opcode,op,write,w,vsel,loada,loadb,loadc,loads,asel,bsel,nsel);
input s, reset,clk;
input[2:0] opcode;
input[1:0] op;
output reg w,write, loada, loadb, loadc, loads, vsel,asel,bsel;
output reg [2:0] nsel;
reg [3:0] state;

// starts state if reach decode state 
always @(posedge clk) begin
	state = reset ? 4'b0000 : state; // if reset, state return to wait state 4'b0000
	case(state)
		4'b0000: state = (s == 1'b1) ? 4'b0001 : 4'b0000; // if s, go to 'decode' state 
		4'b0001: state = (opcode == 3'b110 & op == 2'b10) ? 4'b0010 : 4'b0011; // in 'decode' state, go to 'write imme' state else 'Get A Rn'
		4'b0010: state = 4'b0000; // if in 'write imme' state, go to 'wait' state 
		4'b0011: state = 4'b0100; //if in 'Get A Rn' state, go to 'Bet B Rm' state
		4'b0100: begin // if in 'Get B Rm' state 
			if((opcode == 3'b110 & op == 2'b00) | (opcode == 3'b101 & op == 2'b11))
				state = 4'b0101; //in mov Rd, Rm{,<sh_op>} or MVN Rd, Rm{, <sh_op>}, go to 'shift' state
			else if(opcode == 3'b101) 
				state = (op == 2'b01) ? 4'b1000 : 4'b0111; //if CMP Rn, Rm{,<sh_op>}, go to 'status' state, else go to 'ALU' state
		end
		4'b0101: state = 4'b0110; //if in 'shift' state, go to 'write Rd' state 
		4'b0110: state = 4'b0000; //if in 'write Rd' state, go to 'wait' state
		4'b1000: state = 4'b0000; //if in 'status' state, go to 'wait' state
		4'b0111: state = 4'b0110; //if in 'ALU' state, go to 'write Rd' state 
		4'b0110: state = 4'b0000; //if in 'write Rd' state, go to 'wait' state
		default: state = state; 
	endcase
	state = state;
end

always @(*) begin
	w = (state == 4'b0000) ? 1'b1: 1'b0; 
	// outputs in the state machine 
	// could be optimized using casex...
	case(state)
		4'b0000:begin // in 'wait' state
			{write,vsel}= 2'b00;
			{loada,loadb,loadc,loads,asel,bsel} = 6'b000000;
			nsel = 3'b000;
		end
		4'b0001:begin // in 'decode' state
			{write,vsel}= 2'b00;
			{loada,loadb,loadc,loads,asel,bsel} = 6'b000000;
			nsel = 3'b000;
		end
		4'b0010:begin // in 'write imme' state 
			{write,vsel}= 2'b11;
			{loada,loadb,loadc,loads,asel,bsel} = 6'b000000;
			nsel = 3'b001;
		end 
		4'b0011:begin//in 'Get A Rn' state
			{loada,loadb,loadc,loads,asel,bsel} = 6'b100000;
			{write,vsel}= 2'b00;
			nsel = 3'b001;
		end 
		4'b0100:begin// in 'Get B Rm' state 
			{loada,loadb,loadc,loads,asel,bsel} = 6'b010000;
			{write,vsel}= 2'b00;
			nsel = 3'b100;
		end 
		4'b0101:begin// in 'shift' state
			{loada,loadb,loadc,loads,asel,bsel} = 6'b001010;
			{write,vsel}= 2'b00;
			nsel = 3'b000;//dont care 
		end 
		4'b0110:begin// in 'write Rd' state 
			{loada,loadb,loadc,loads,asel,bsel} = 6'b000000;
			{write,vsel}= 2'b10;
			nsel = 3'b010;
		end
		4'b0111:begin// in 'ALU' state 
			{loada,loadb,loadc,loads,asel,bsel} = 6'b001000;
			{write,vsel}= 2'b00;
			nsel = 3'b000;//dont care
		end 
		4'b1000:begin//in 'status' state 
			{loada,loadb,loadc,loads,asel,bsel} = 6'b000100;
			{write,vsel}= 2'b00;
			nsel = 3'b000;//dont care
		end 
	endcase 
end 
endmodule 