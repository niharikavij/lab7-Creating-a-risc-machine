module lab7_top(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);
input [3:0] KEY;
input [9:0] SW;
output reg[9:0] LEDR;
output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

wire [1:0]mem_cmd;
wire [8:0]mem_addr;
wire [15:0]dout,write_data,datapath_out,mdata;
reg [8:0]write_address,read_address; 
wire clk;

reg [15:0]read_data,din;
reg write,load_input;

	cpu CPU(.clk(~KEY[0]),.reset(~KEY[1]),.read_data(read_data),.mem_cmd(mem_cmd),.mem_addr(mem_addr),.write_data(write_data));
	RAM MEM(.clk(~KEY[0]),.read_address(read_address),.write_address(write_address),.write(write),.din(din),.dout(dout));
always @(*)begin
	read_address = mem_addr[7:0];
	write_address = mem_addr[7:0]; 
	write = ((mem_cmd == 2'b10) & (mem_addr[8] == 1'b0)) ? 1'b1 : 1'b0;
	load_input = ((mem_cmd == 2'b01) & (mem_addr == 9'h140)) ? 1'b1 : 1'b0;
	read_data = ((mem_cmd == 2'b01) & (mem_addr[8] == 1'b0)) ? dout : {16{1'bz}};
	read_data [7:0] = (load_input == 1'b1) ? SW[7:0] : dout[7:0];
	read_data [15:8] = (load_input == 1'b1) ? {8'h00} : dout[15:8]; 
	din = write_data;
end 

always@(*) begin
	if (mem_addr == 9'h100)begin
		if(mem_cmd == 2'b10) begin
			LEDR = write_data;
		end
		else LEDR = LEDR;
	end
	else LEDR = LEDR;
end
	
endmodule	
