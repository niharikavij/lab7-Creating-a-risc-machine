module state_machine(reset,clk,opcode,op,write,vsel,loada,loadb,loadc,loads,asel,bsel,nsel,load_pc,reset_pc,load_ir,addr_sel,mem_cmd,load_addr);
input reset,clk;
input[2:0] opcode;
input[1:0] op;
output reg write, loada, loadb, loadc, loads,asel,bsel,load_ir,load_pc,reset_pc,addr_sel,load_addr;
output reg [1:0]mem_cmd,vsel;
output reg [2:0] nsel;
reg [4:0] state;

// starts state if reach decode state 
always @(posedge clk) begin
	if(reset == 1'b1)begin
	state =  5'b00000; // if reset, state return to "reset" state 4'b0000
	end 
	else begin 
		case(state)
		5'b00000: state = 5'b01011; // if in 'reset' state, go tp "IF1" state 4'b1011
		5'b01011: state = 5'b01001; // if in 'IF1' state, go to "IF2" state 4'b1001
		5'b01001: state = 5'b01010; // if in "IF2" state, go to 'updatePC' state 4'b1010
		5'b01010: state = 5'b00001 ; // if in 'updatePC' state, go to 'decode' state 
		// in 'decode' state
		5'b0001: begin
			if(opcode == 3'b111)
				state = 5'b01100; //go to 'HALT' state if opcode == 111
			else if(opcode == 3'b110 & op == 2'b10)
				state = 5'b00010; // go to 'write imme' state 
			else 
				state = 5'b00011;  //  go to 'Get A Rn' state 

		end 
		//in 'get sximm5 in ALU' state 
		5'b01110: begin  
			if(opcode == 3'b011)
				state = 5'b10010;// go to 'load mem addr' state 
			else if(opcode == 3'b100)
				state = 5'b10001;//go to 'write to ram' state 
			else 
				state = 5'b00110; // go to 'write Rd' state 
		end 
		5'b00010: state = 5'b01000; // if in 'write imme' state, go to 'IF1' state 
		//in 'Get A Rn' state
		5'b00011: begin 
			if(opcode == 3'b011 | opcode == 3'b100) 
				state = 5'b01110; // go to 'sximm5 in ALU' 
			else 
				state = 5'b00100; //go to 'Bet B Rm' state
		end 
		5'b00100: begin // if in 'Get B Rm' state 
			if((opcode == 3'b110 & op == 2'b00) | (opcode == 3'b101 & op == 2'b11))
				state = 5'b00101; //in mov Rd, Rm{,<sh_op>} or MVN Rd, Rm{, <sh_op>}, go to 'shift' state
			else if(opcode == 3'b101) 
				state = (op == 2'b01) ? 5'b01000 : 5'b00111; //if CMP Rn, Rm{,<sh_op>}, go to 'status' state, else go to 'ALU' state
		end
		// in 'load mem addr' state 
		5'b10010: state = 5'b01111; // go to 'get ram value' state
		5'b00101: state = 5'b00110; //if in 'shift' state, go to 'write Rd' state 
		5'b00110: state = 5'b01011; //if in 'write Rd' state, go to 'IF1' state
		5'b01000: state = 5'b01011; //if in 'status' state, go to 'IF1' state
		//in 'ALU' state
		5'b00111: state = 5'b00110; // go to 'write Rd' state 
		//in 'get ram add' state'
		5'b01111: state = 5'b10000;//go to 'write ram' state 
		5'b00110: state = 5'b01011; //if in 'write Rd' state, go to 'IF1' state
		5'b10001: state = 5'b01011; // if in 'write to ram' state, go to 'IF1' state
		5'b10000: state = 5'b01011; // if in 'write ram' state, go to 'IF1' state
		default: state = state; 
	endcase
	end 
	state = state;
end

always @(*) begin
	// outputs in the state machine 
	case(state)
		5'b00000:begin // in 'reset' state
			{write,vsel,reset_pc,load_addr}= 5'b00010;
			{loada,loadb,loadc,loads,asel,bsel,load_ir,load_pc,addr_sel} = 9'b000000010;
			nsel = 3'b000;
			mem_cmd = 2'b00; // WNONE
		end
		5'b00001:begin // in 'decode' state
			{write,vsel,reset_pc}= 4'b0000;
			{loada,loadb,loadc,loads,asel,bsel,load_ir,load_pc,addr_sel} = 9'b000000000;
			nsel = 3'b000;
			mem_cmd = 2'b00; // WNONE
		end
		5'b00010:begin // in 'write imme' state 
			{write,vsel,reset_pc,load_addr}= 5'b10100; // vsel == 01 select imm8
			{loada,loadb,loadc,loads,asel,bsel,load_ir,load_pc,addr_sel} = 9'b000000000;
			nsel = 3'b001;
			mem_cmd = 2'b00; // WNONE
		end 
		5'b00011:begin//in 'Get A Rn' state
			{loada,loadb,loadc,loads,asel,bsel,load_ir,load_pc,addr_sel} = 9'b100000000;
			{write,vsel,reset_pc,load_addr}= 5'b00000;
			nsel = 3'b001;
			mem_cmd = 2'b00; // WNONE
		end 
		5'b00100:begin// in 'Get B Rm' state 
			{loada,loadb,loadc,loads,asel,bsel,load_ir,load_pc,addr_sel} = 9'b010000000;
			{write,vsel,reset_pc,load_addr}= 5'b00000;
			nsel = 3'b100;
			mem_cmd = 2'b00; // WNONE
		end 
		5'b00101:begin// in 'shift' state
			{loada,loadb,loadc,loads,asel,bsel,load_ir,load_pc,addr_sel} = 9'b001010000;
			{write,vsel,reset_pc,load_addr}= 5'b00000;
			nsel = 3'b000;//dont care 
			mem_cmd = 2'b00; // WNONE
		end 
		5'b00110:begin// in 'write Rd' state 
			{loada,loadb,loadc,loads,asel,bsel,load_ir,load_pc,addr_sel} = 9'b000000000;
			{write,vsel,reset_pc,load_addr}= 5'b10000;
			nsel = 3'b010;
			mem_cmd = 2'b00; // WNONE
		end
		5'b00111:begin// in 'ALU' state 
			{loada,loadb,loadc,loads,asel,bsel,load_ir,load_pc,addr_sel} = 9'b001000000;
			{write,vsel,reset_pc,load_addr}= 5'b00000;
			nsel = 3'b000;//dont care
		end 
		5'b01000:begin//in 'status' state 
			{loada,loadb,loadc,loads,asel,bsel,load_ir,load_pc,addr_sel} = 9'b000100000;
			{write,vsel,reset_pc,load_addr}= 5'b00000;
			nsel = 3'b000;//dont care
			mem_cmd = 2'b00; // WNONE
		end 
		5'b01011:begin// in 'IF1' state 
			{loada,loadb,loadc,loads,asel,bsel,load_ir,load_pc,addr_sel} = 9'b000000001;
			{write,vsel,reset_pc}= 4'b0000;
			nsel = 3'b100;
			mem_cmd = 2'b01; // MREAD
		end 
		5'b01001:begin// in "IF2" state 
			{loada,loadb,loadc,loads,asel,bsel,load_ir,load_pc,addr_sel} = 9'b000000101;
			{write,vsel,reset_pc,load_addr}= 5'b00000;
			nsel = 3'b000;
			mem_cmd = 2'b01;//MREAD
		end 
		5'b01010:begin // in "UpdatePc" state 
			{loada,loadb,loadc,loads,asel,bsel,load_ir,load_pc,addr_sel} = 9'b000000010;
			{write,vsel,reset_pc,load_addr}= 5'b00000;
			nsel = 3'b000;
			mem_cmd = 2'b00; // WNONE
		end 

		5'b01100:begin//in "HAlT" state, stop updating 
			{loada,loadb,loadc,loads,asel,bsel,load_ir,load_pc,addr_sel} = 9'b000000000;
			{write,vsel,reset_pc,load_addr}= 5'b00000;
			nsel = 3'b000;
			mem_cmd = 2'b00; // WNONE
		end 
		5'b01110:begin// "sximm5 in ALU" state 
			{loada,loadb,loadc,loads,asel,bsel,load_ir,load_pc,addr_sel} = 9'b001001000;
			{write,vsel,reset_pc,load_addr}= 5'b00000;
			nsel = 3'b000;
			mem_cmd = 2'b00; // WNONE
		end 
		5'b01111:begin // 'Get ram value' state
			{loada,loadb,loadc,loads,asel,bsel,load_ir,load_pc,addr_sel} = 9'b000000000;
			{write,vsel,reset_pc,load_addr}= 5'b00001;
			nsel = 3'b000;
			mem_cmd = 2'b10; // Wread
		end 
		5'b10000:begin//'write ram to register' state 
			{loada,loadb,loadc,loads,asel,bsel,load_ir,load_pc,addr_sel} = 9'b000000000;
			{write,vsel,reset_pc,load_addr}= 5'b11000; // write, vsel = mdata
			nsel = 3'b010;//write to rd
			mem_cmd = 2'b10; // Wread
		end 
		5'b10001:begin// 'write to ram' state
			{loada,loadb,loadc,loads,asel,bsel,load_ir,load_pc,addr_sel} = 9'b000000000;
			{write,vsel,reset_pc,load_addr}= 5'b00001; // write, vsel = ram addr
			nsel = 3'b000;//NONE
			mem_cmd = 2'b10; // WRITE
		end 
		5'b10010:begin// 'load mem_addr' state
			{loada,loadb,loadc,loads,asel,bsel,load_ir,load_pc,addr_sel} = 9'b000000000;
			{write,vsel,reset_pc,load_addr}= 5'b00001; // write, vsel = ram addr
			nsel = 3'b000;//NONE
			mem_cmd = 2'b00; // WNONE
		end 
	endcase 
end 
endmodule 