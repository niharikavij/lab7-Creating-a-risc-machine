module state_machine(reset,clk,opcode,op,write,w,vsel,loada,loadb,loadc,loads,asel,bsel,nsel,load_pc,reset_pc,load_ir,addr_sel,mem_cmd, mem_addr);
input reset,clk;
input[2:0] opcode;
input[1:0] op;
output reg w,write, loada, loadb, loadc, loads, vsel,asel,bsel,load_ir,load_pc,reset_pc,addr_sel;
output reg [1:0]mem_cmd;
output reg [8:0]mem_addr;
output reg [2:0] nsel;
reg [3:0] state;

// starts state if reach decode state 
always @(posedge clk) begin
	state = reset ? 4'b0000 : state; // if reset, state return to "reset" state 4'b0000
	case(state)
		4'b0000: state = 4'b1011; // if in 'reset' state, go tp "IF1" state 4'b1000
		4'b1000: state = 4'b1001; // if in 'IF1' state, go to "IF2" state 4'b1001
		4'b1001: state = 4'b1010; // if in "IF2" state, go to 'updatePC' state 4'b1010
		4'b1010: state = 4'b0001 ; // if in 'updatePC' state, go to 'decode' state 
		4'b0001: state = (opcode == 3'b110 & op == 2'b10) ? 4'b0010 : 4'b0011; // in 'decode' state, go to 'write imme' state else 'Get A Rn'
		4'b0010: state = 4'b1000; // if in 'write imme' state, go to 'IF1' state 
		4'b0011: state = 4'b0100; //if in 'Get A Rn' state, go to 'Bet B Rm' state
		4'b0100: begin // if in 'Get B Rm' state 
			if((opcode == 3'b110 & op == 2'b00) | (opcode == 3'b101 & op == 2'b11))
				state = 4'b0101; //in mov Rd, Rm{,<sh_op>} or MVN Rd, Rm{, <sh_op>}, go to 'shift' state
			else if(opcode == 3'b101) 
				state = (op == 2'b01) ? 4'b1000 : 4'b0111; //if CMP Rn, Rm{,<sh_op>}, go to 'status' state, else go to 'ALU' state
		end
		4'b0101: state = 4'b0110; //if in 'shift' state, go to 'write Rd' state 
		4'b0110: state = 4'b1011; //if in 'write Rd' state, go to 'IF1' state
		4'b1000: state = 4'b1011; //if in 'status' state, go to 'IF1' state
		4'b0111: state = 4'b0110; //if in 'ALU' state, go to 'write Rd' state 
		4'b0110: state = 4'b1011; //if in 'write Rd' state, go to 'IF1' state
		default: state = state; 
	endcase
	state = state;
end

always @(*) begin
	w = (state == 4'b0000) ? 1'b1: 1'b0; 
	// outputs in the state machine 
	case(state)
		4'b0000:begin // in 'reset' state
			{write,vsel,reset_pc}= 3'b001;
			{loada,loadb,loadc,loads,asel,bsel,load_ir,load_pc,addr_sel} = 9'b000000010;
			nsel = 3'b000;
			mem_cmd = 2'b00; // WNONE
		end
		4'b0001:begin // in 'decode' state
			{write,vsel,reset_pc}= 3'b000;
			{loada,loadb,loadc,loads,asel,bsel,load_ir,load_pc,addr_sel} = 9'b000000000;
			nsel = 3'b000;
			mem_cmd = 2'b00; // WNONE
		end
		4'b0010:begin // in 'write imme' state 
			{write,vsel,reset_pc}= 3'b110;
			{loada,loadb,loadc,loads,asel,bsel,load_ir,load_pc,addr_sel} = 9'b000000000;
			nsel = 3'b001;
			mem_cmd = 2'b00; // WNONE
		end 
		4'b0011:begin//in 'Get A Rn' state
			{loada,loadb,loadc,loads,asel,bsel,load_ir,load_pc,addr_sel} = 9'b100000000;
			{write,vsel,reset_pc}= 3'b000;
			nsel = 3'b001;
			mem_cmd = 2'b00; // WNONE
		end 
		4'b0100:begin// in 'Get B Rm' state 
			{loada,loadb,loadc,loads,asel,bsel,load_ir,load_pc,addr_sel} = 9'b010000000;
			{write,vsel,reset_pc}= 3'b000;
			nsel = 3'b100;
			mem_cmd = 2'b00; // WNONE
		end 
		4'b0101:begin// in 'shift' state
			{loada,loadb,loadc,loads,asel,bsel,load_ir,load_pc,addr_sel} = 9'b001010000;
			{write,vsel,reset_pc}= 3'b000;
			nsel = 3'b000;//dont care 
			mem_cmd = 2'b00; // WNONE
		end 
		4'b0110:begin// in 'write Rd' state 
			{loada,loadb,loadc,loads,asel,bsel,load_ir,load_pc,addr_sel} = 9'b000000000;
			{write,vsel,reset_pc}= 3'b100;
			nsel = 3'b010;
			mem_cmd = 2'b00; // WNONE
		end
		4'b0111:begin// in 'ALU' state 
			{loada,loadb,loadc,loads,asel,bsel,load_ir,load_pc,addr_sel} = 9'b001000000;
			{write,vsel,reset_pc}= 3'b000;
			nsel = 3'b000;//dont care
		end 
		4'b1000:begin//in 'status' state 
			{loada,loadb,loadc,loads,asel,bsel,load_ir,load_pc,addr_sel} = 9'b000100000;
			{write,vsel,reset_pc}= 3'b000;
			nsel = 3'b000;//dont care
			mem_cmd = 2'b00; // WNONE
		end 
		4'b1011:begin// in 'IF1' state 
			{loada,loadb,loadc,loads,asel,bsel,load_ir,load_pc,addr_sel} = 9'b000000001;
			{write,vsel,reset_pc}= 3'b000;
			nsel = 3'b100;
			mem_cmd = 2'b01; // MREAD
		end 
		4'b1001:begin// in "IF2" state 
			{loada,loadb,loadc,loads,asel,bsel,load_ir,load_pc,addr_sel} = 9'b000000101;
			{write,vsel,reset_pc}= 3'b000;
			nsel = 3'b000;
			mem_cmd = 2'b01;//MREAD
		end 
		4'b1010:begin // in "UpdatePc" state 
			{loada,loadb,loadc,loads,asel,bsel,load_ir,load_pc,addr_sel} = 9'b000000010;
			{write,vsel,reset_pc}= 3'b000;
			nsel = 3'b000;
			mem_cmd = 2'b00; // WNONE
		end 
	endcase 
end 
endmodule 
