module regfile(data_in,writenum,write,readnum,clk,data_out);
	input [15:0] data_in;
	input [2:0] writenum, readnum;
	reg [15:0] R0,R1,R2,R3,R4,R5,R6,R7;
	input write, clk;
	output reg [15:0] data_out;
	
	always @(posedge clk) begin
	// Only changes anything if write is true
		if (write == 1'b1) begin
			case(writenum)
				3'd0: R0 = data_in;
				3'd1: R1 = data_in;
				3'd2: R2 = data_in;
				3'd3: R3 = data_in;
				3'd4: R4 = data_in;
				3'd5: R5 = data_in;
				3'd6: R6 = data_in;
				3'd7: R7 = data_in;
			endcase 
		end 
	end 

	//Combinational Logic: Read number from Register 
	always @(*) begin 
		if(write == 1'b0)begin
		case(readnum)
			//3:8 decoder 
			3'd0: data_out = R0;
			3'd1: data_out = R1;
			3'd2: data_out = R2;
			3'd3: data_out = R3;
			3'd4: data_out = R4;
			3'd5: data_out = R5;
			3'd6: data_out = R6;
			3'd7: data_out = R7;
		endcase 
		end 
		else begin
			data_out = {16{1'bx}};
		end 
	end
	
endmodule 
